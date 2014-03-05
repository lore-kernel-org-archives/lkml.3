Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbaCEW34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:29:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbaCEW3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:29:55 -0500
Date: Wed, 5 Mar 2014 14:29:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, patches@linaro.org
Subject: Re: [PATCH 2/5] mm: create generic early_ioremap() support
Message-Id: <20140305142953.669fd030495e802b2e03879c@linux-foundation.org>
In-Reply-To: <1393963738-9210-3-git-send-email-msalter@redhat.com>
References: <1393963738-9210-1-git-send-email-msalter@redhat.com>
	<1393963738-9210-3-git-send-email-msalter@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Mar 2014 15:08:55 -0500 Mark Salter <msalter@redhat.com> wrote:

> This patch creates a generic implementation of early_ioremap() support
> based on the existing x86 implementation. early_ioremp() is useful for
> early boot code which needs to temporarily map I/O or memory regions
> before normal mapping functions such as ioremap() are available.
> 
> Some architectures have optional MMU. In the no-MMU case, the remap
> functions simply return the passed in physical address and the unmap
> functions do nothing.
> 
>
> ....
>
> --- /dev/null
> +++ b/mm/early_ioremap.c
> @@ -0,0 +1,271 @@
> +/*
> + * Provide common bits of early_ioremap() support for architectures needing
> + * temporary mappings during boot before ioremap() is available.
> + *
> + * This is mostly a direct copy of the x86 early_ioremap implementation.
> + *
> + * (C) Copyright 1995 1996, 2014 Linus Torvalds
> + *
> + */

I suppose one should include linux/kernel.h.

> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/mm.h>
> +#include <linux/vmalloc.h>
> +#include <asm/fixmap.h>
> +
> +#ifdef CONFIG_MMU
> +static int early_ioremap_debug __initdata;
> +
> +static int __init early_ioremap_debug_setup(char *str)
> +{
> +	early_ioremap_debug = 1;
> +
> +	return 0;
> +}
> +early_param("early_ioremap_debug", early_ioremap_debug_setup);

Should be documented somewhere.  Documentation/kernel-parameters.txt?

> +static int after_paging_init __initdata;
> +
> +void __init __attribute__((weak)) early_ioremap_shutdown(void)

__weak

Do __init and __weak work together?  They should, but I don't recall
seeing it.

> +{
> +}
> +
>
> ....
>
> +static void __init __iomem *
> +__early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
> +{
> +	unsigned long offset;
> +	resource_size_t last_addr;
> +	unsigned int nrpages;
> +	enum fixed_addresses idx;
> +	int i, slot;
> +
> +	WARN_ON(system_state != SYSTEM_BOOTING);
> +
> +	slot = -1;
> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
> +		if (!prev_map[i]) {
> +			slot = i;
> +			break;
> +		}
> +	}
> +
> +	if (slot < 0) {
> +		pr_info("%s(%08llx, %08lx) not found slot\n",
> +			__func__, (u64)phys_addr, size);
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +
> +	if (early_ioremap_debug) {
> +		pr_info("%s(%08llx, %08lx) [%d] => ",
> +			__func__, (u64)phys_addr, size, slot);
> +		dump_stack();
> +	}
> +
> +	/* Don't allow wraparound or zero size */
> +	last_addr = phys_addr + size - 1;
> +	if (!size || last_addr < phys_addr) {
> +		WARN_ON(1);
> +		return NULL;
> +	}

	if (WARN_ON(!size || last_addr < phys_addr))
		return NULL;

> +	prev_size[slot] = size;
> +	/*
> +	 * Mappings have to be page-aligned
> +	 */
> +	offset = phys_addr & ~PAGE_MASK;
> +	phys_addr &= PAGE_MASK;
> +	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
> +
> +	/*
> +	 * Mappings have to fit in the FIX_BTMAP area.
> +	 */
> +	nrpages = size >> PAGE_SHIFT;
> +	if (nrpages > NR_FIX_BTMAPS) {
> +		WARN_ON(1);
> +		return NULL;
> +	}

Ditto.

> +	/*
> +	 * Ok, go for it..
> +	 */
> +	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
> +	while (nrpages > 0) {
> +		if (after_paging_init)
> +			__late_set_fixmap(idx, phys_addr, prot);
> +		else
> +			__early_set_fixmap(idx, phys_addr, prot);
> +		phys_addr += PAGE_SIZE;
> +		--idx;
> +		--nrpages;
> +	}
> +	if (early_ioremap_debug)
> +		pr_cont("%08lx + %08lx\n", offset, slot_virt[slot]);
> +
> +	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
> +	return prev_map[slot];
> +}
> +
> +void __init early_iounmap(void __iomem *addr, unsigned long size)
> +{
> +	unsigned long virt_addr;
> +	unsigned long offset;
> +	unsigned int nrpages;
> +	enum fixed_addresses idx;
> +	int i, slot;
> +
> +	slot = -1;
> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
> +		if (prev_map[i] == addr) {
> +			slot = i;
> +			break;
> +		}
> +	}
> +
> +	if (slot < 0) {
> +		pr_info("early_iounmap(%p, %08lx) not found slot\n",
> +			addr, size);
> +		WARN_ON(1);
> +		return;
> +	}

Can we do

	if (WARN(slot < 0, "...", addr, size))
		return;

here?

And in lots of other places?

> +	if (prev_size[slot] != size) {
> +		pr_info("early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
> +			addr, size, slot, prev_size[slot]);
> +		WARN_ON(1);
> +		return;
> +	}
> +
> +	if (early_ioremap_debug) {
> +		pr_info("early_iounmap(%p, %08lx) [%d]\n", addr,
> +			size, slot);
> +		dump_stack();
> +	}

That could be a WARN as well.

> +	virt_addr = (unsigned long)addr;
> +	if (virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)) {
> +		WARN_ON(1);
> +		return;
> +	}
> +	offset = virt_addr & ~PAGE_MASK;
> +	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
> +
> +	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
> +	while (nrpages > 0) {
> +		if (after_paging_init)
> +			__late_clear_fixmap(idx);
> +		else
> +			__early_set_fixmap(idx, 0, FIXMAP_PAGE_CLEAR);
> +		--idx;
> +		--nrpages;
> +	}
> +	prev_map[slot] = NULL;
> +}
> +
>
> ...
