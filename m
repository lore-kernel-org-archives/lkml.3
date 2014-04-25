Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaDYVDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:03:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49357 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaDYVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:03:36 -0400
Date: Fri, 25 Apr 2014 17:02:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, boris.ostrovsky@oracle.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andy Lutomirski <amluto@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
Message-ID: <20140425210241.GB30532@phenom.dumpdata.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
 <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
 <535714A1.9080502@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535714A1.9080502@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 06:17:21PM -0700, H. Peter Anvin wrote:
> Another spin of the prototype.  This one avoids the espfix for anything
> but #GP, and avoids save/restore/saving registers... one can wonder,
> though, how much that actually matters in practice.
> 
> It still does redundant SWAPGS on the slow path.  I'm not sure I
> personally care enough to optimize that, as it means some fairly
> significant restructuring of some of the code paths.  Some of that
> restructuring might actually be beneficial, but still...

Sorry about being late to the party.


 .. snip..
> diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
> new file mode 100644
> index 000000000000..05567d706f92
> --- /dev/null
> +++ b/arch/x86/kernel/espfix_64.c
> @@ -0,0 +1,136 @@
> +/* ----------------------------------------------------------------------- *
> + *
> + *   Copyright 2014 Intel Corporation; author: H. Peter Anvin
> + *
> + *   This file is part of the Linux kernel, and is made available under
> + *   the terms of the GNU General Public License version 2 or (at your
> + *   option) any later version; incorporated herein by reference.
> + *
> + * ----------------------------------------------------------------------- */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/percpu.h>
> +#include <linux/gfp.h>
> +#include <asm/pgtable.h>
> +
> +#define ESPFIX_STACK_SIZE	64UL
> +#define ESPFIX_STACKS_PER_PAGE	(PAGE_SIZE/ESPFIX_STACK_SIZE)
> +
> +#define ESPFIX_MAX_CPUS (ESPFIX_STACKS_PER_PAGE << (PGDIR_SHIFT-PAGE_SHIFT-16))
> +#if CONFIG_NR_CPUS > ESPFIX_MAX_CPUS
> +# error "Need more than one PGD for the ESPFIX hack"
> +#endif
> +
> +#define ESPFIX_BASE_ADDR	(-2UL << PGDIR_SHIFT)
> +
> +#define PGALLOC_GFP (GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
> +
> +/* This contains the *bottom* address of the espfix stack */
> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
> +
> +/* Initialization mutex - should this be a spinlock? */
> +static DEFINE_MUTEX(espfix_init_mutex);
> +
> +/* Page allocation bitmap - each page serves ESPFIX_STACKS_PER_PAGE CPUs */
> +#define ESPFIX_MAX_PAGES  DIV_ROUND_UP(CONFIG_NR_CPUS, ESPFIX_STACKS_PER_PAGE)
> +#define ESPFIX_MAP_SIZE   DIV_ROUND_UP(ESPFIX_MAX_PAGES, BITS_PER_LONG)
> +static unsigned long espfix_page_alloc_map[ESPFIX_MAP_SIZE];
> +
> +static __page_aligned_bss pud_t espfix_pud_page[PTRS_PER_PUD]
> +	__aligned(PAGE_SIZE);
> +
> +/*
> + * This returns the bottom address of the espfix stack for a specific CPU.
> + * The math allows for a non-power-of-two ESPFIX_STACK_SIZE, in which case
> + * we have to account for some amount of padding at the end of each page.
> + */
> +static inline unsigned long espfix_base_addr(unsigned int cpu)
> +{
> +	unsigned long page, addr;
> +
> +	page = (cpu / ESPFIX_STACKS_PER_PAGE) << PAGE_SHIFT;
> +	addr = page + (cpu % ESPFIX_STACKS_PER_PAGE) * ESPFIX_STACK_SIZE;
> +	addr = (addr & 0xffffUL) | ((addr & ~0xffffUL) << 16);
> +	addr += ESPFIX_BASE_ADDR;
> +	return addr;
> +}
> +
> +#define PTE_STRIDE        (65536/PAGE_SIZE)
> +#define ESPFIX_PTE_CLONES (PTRS_PER_PTE/PTE_STRIDE)
> +#define ESPFIX_PMD_CLONES PTRS_PER_PMD
> +#define ESPFIX_PUD_CLONES (65536/(ESPFIX_PTE_CLONES*ESPFIX_PMD_CLONES))
> +
> +void init_espfix_this_cpu(void)
> +{
> +	unsigned int cpu, page;
> +	unsigned long addr;
> +	pgd_t pgd, *pgd_p;
> +	pud_t pud, *pud_p;
> +	pmd_t pmd, *pmd_p;
> +	pte_t pte, *pte_p;
> +	int n;
> +	void *stack_page;
> +	pteval_t ptemask;
> +
> +	/* We only have to do this once... */
> +	if (likely(this_cpu_read(espfix_stack)))
> +		return;		/* Already initialized */
> +
> +	cpu = smp_processor_id();
> +	addr = espfix_base_addr(cpu);
> +	page = cpu/ESPFIX_STACKS_PER_PAGE;
> +
> +	/* Did another CPU already set this up? */
> +	if (likely(test_bit(page, espfix_page_alloc_map)))
> +		goto done;
> +
> +	mutex_lock(&espfix_init_mutex);
> +
> +	/* Did we race on the lock? */
> +	if (unlikely(test_bit(page, espfix_page_alloc_map)))
> +		goto unlock_done;
> +
> +	ptemask = __supported_pte_mask;
> +
> +	pgd_p = &init_level4_pgt[pgd_index(addr)];
> +	pgd = *pgd_p;
> +	if (!pgd_present(pgd)) {
> +		/* This can only happen on the BSP */
> +		pgd = __pgd(__pa_symbol(espfix_pud_page) |

Any particular reason you are using __pgd

> +			    (_KERNPG_TABLE & ptemask));
> +		set_pgd(pgd_p, pgd);
> +	}
> +
> +	pud_p = &espfix_pud_page[pud_index(addr)];
> +	pud = *pud_p;
> +	if (!pud_present(pud)) {
> +		pmd_p = (pmd_t *)__get_free_page(PGALLOC_GFP);
> +		pud = __pud(__pa(pmd_p) | (_KERNPG_TABLE & ptemask));

_pud
> +		for (n = 0; n < ESPFIX_PUD_CLONES; n++)
> +			set_pud(&pud_p[n], pud);
> +	}
> +
> +	pmd_p = pmd_offset(&pud, addr);
> +	pmd = *pmd_p;
> +	if (!pmd_present(pmd)) {
> +		pte_p = (pte_t *)__get_free_page(PGALLOC_GFP);
> +		pmd = __pmd(__pa(pte_p) | (_KERNPG_TABLE & ptemask));

and _pmd?
> +		for (n = 0; n < ESPFIX_PMD_CLONES; n++)
> +			set_pmd(&pmd_p[n], pmd);
> +	}
> +
> +	pte_p = pte_offset_kernel(&pmd, addr);
> +	stack_page = (void *)__get_free_page(GFP_KERNEL);
> +	pte = __pte(__pa(stack_page) | (__PAGE_KERNEL & ptemask));

and __pte instead of the 'pmd', 'pud', 'pmd' and 'pte' macros?

> +	for (n = 0; n < ESPFIX_PTE_CLONES; n++)
> +		set_pte(&pte_p[n*PTE_STRIDE], pte);
> +
> +	/* Job is done for this CPU and any CPU which shares this page */
> +	set_bit(page, espfix_page_alloc_map);
> +
> +unlock_done:
> +	mutex_unlock(&espfix_init_mutex);
> +done:
> +	this_cpu_write(espfix_stack, addr);
> +}
