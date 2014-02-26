Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbaBZFsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:48:22 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:33710 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaBZFsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:48:20 -0500
MIME-Version: 1.0
In-Reply-To: <1392238575-10000-5-git-send-email-msalter@redhat.com>
References: <1392238575-10000-1-git-send-email-msalter@redhat.com>
	<1392238575-10000-5-git-send-email-msalter@redhat.com>
Date: Tue, 25 Feb 2014 23:48:19 -0600
Message-ID: <CAL_JsqLi=GhGy7dNf2BiAGd4EtzfqqYfbo0YhRhyhuwEp0w8HQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] arm: add early_ioremap support
From: Rob Herring <robherring2@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Linaro Patches <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 2:56 PM, Mark Salter <msalter@redhat.com> wrote:
> This patch uses the generic early_ioremap code to implement
> early_ioremap for ARM. The ARM-specific bits come mostly from
> an earlier patch from Leif Lindholm <leif.lindholm@linaro.org>
> here:

This doesn't actually work for me. The PTE flags are not correct and
accesses to a device fault. See below.

>
>   https://lkml.org/lkml/2013/10/3/279
>
> Signed-off-by: Mark Salter <msalter@redhat.com>
> Tested-by: Leif Lindholm <leif.lindholm@linaro.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/Kconfig              | 10 +++++
>  arch/arm/include/asm/Kbuild   |  1 +
>  arch/arm/include/asm/fixmap.h | 20 ++++++++++
>  arch/arm/include/asm/io.h     |  1 +
>  arch/arm/kernel/setup.c       |  2 +
>  arch/arm/mm/Makefile          |  4 ++
>  arch/arm/mm/early_ioremap.c   | 93 +++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mm/mmu.c             |  2 +
>  8 files changed, 133 insertions(+)
>  create mode 100644 arch/arm/mm/early_ioremap.c
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e254198..7a35ef6 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1874,6 +1874,16 @@ config UACCESS_WITH_MEMCPY
>           However, if the CPU data cache is using a write-allocate mode,
>           this option is unlikely to provide any performance gain.
>
> +config EARLY_IOREMAP
> +       bool "Provide early_ioremap() support for kernel initialization"
> +       select GENERIC_EARLY_IOREMAP
> +       help
> +         Provide a mechanism for kernel initialisation code to temporarily
> +         map, in a highmem-agnostic way, memory pages in before ioremap()
> +         and friends are available (before paging_init() has run). It uses
> +         the same virtual memory range as kmap so all early mappings must
> +         be unmapped before paging_init() is called.
> +
>  config SECCOMP
>         bool
>         prompt "Enable seccomp to safely compute untrusted bytecode"
> diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
> index 3278afe..6fcfd7d 100644
> --- a/arch/arm/include/asm/Kbuild
> +++ b/arch/arm/include/asm/Kbuild
> @@ -4,6 +4,7 @@ generic-y += auxvec.h
>  generic-y += bitsperlong.h
>  generic-y += cputime.h
>  generic-y += current.h
> +generic-y += early_ioremap.h
>  generic-y += emergency-restart.h
>  generic-y += errno.h
>  generic-y += exec.h
> diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
> index 68ea615..ff8fa3e 100644
> --- a/arch/arm/include/asm/fixmap.h
> +++ b/arch/arm/include/asm/fixmap.h
> @@ -21,8 +21,28 @@ enum fixed_addresses {
>         FIX_KMAP_BEGIN,
>         FIX_KMAP_END = (FIXADDR_TOP - FIXADDR_START) >> PAGE_SHIFT,
>         __end_of_fixed_addresses
> +/*
> + * 224 temporary boot-time mappings, used by early_ioremap(),
> + * before ioremap() is functional.
> + *
> + * (P)re-using the FIXADDR region, which is used for highmem
> + * later on, and statically aligned to 1MB.
> + */
> +#define NR_FIX_BTMAPS          32
> +#define FIX_BTMAPS_SLOTS       7
> +#define TOTAL_FIX_BTMAPS       (NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
> +#define FIX_BTMAP_END          FIX_KMAP_BEGIN
> +#define FIX_BTMAP_BEGIN                (FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1)

Why the different logic from arm64? Specifically, it doesn't make
adding a permanent mapping simple.

>  };
>
> +#define FIXMAP_PAGE_COMMON (L_PTE_YOUNG | L_PTE_PRESENT | L_PTE_XN)
> +
> +#define FIXMAP_PAGE_NORMAL (FIXMAP_PAGE_COMMON | L_PTE_MT_WRITEBACK)
> +#define FIXMAP_PAGE_IO    (FIXMAP_PAGE_COMMON | L_PTE_MT_DEV_NONSHARED)

This should be L_PTE_MT_DEV_SHARED and also needs L_PTE_DIRTY and
L_PTE_SHARED as we want this to match MT_DEVICE.

These should also be wrapped with __pgprot().

> +
> +extern void __early_set_fixmap(enum fixed_addresses idx,
> +                              phys_addr_t phys, pgprot_t flags);
> +
>  #include <asm-generic/fixmap.h>
>
>  #endif
> diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> index 8aa4cca..637e0cd 100644
> --- a/arch/arm/include/asm/io.h
> +++ b/arch/arm/include/asm/io.h
> @@ -28,6 +28,7 @@
>  #include <asm/byteorder.h>
>  #include <asm/memory.h>
>  #include <asm-generic/pci_iomap.h>
> +#include <asm/early_ioremap.h>
>  #include <xen/xen.h>
>
>  /*
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index b0df976..9c8b751 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -30,6 +30,7 @@
>  #include <linux/bug.h>
>  #include <linux/compiler.h>
>  #include <linux/sort.h>
> +#include <linux/io.h>
>
>  #include <asm/unified.h>
>  #include <asm/cp15.h>
> @@ -880,6 +881,7 @@ void __init setup_arch(char **cmdline_p)
>         const struct machine_desc *mdesc;
>
>         setup_processor();
> +       early_ioremap_init();
>         mdesc = setup_machine_fdt(__atags_pointer);
>         if (!mdesc)
>                 mdesc = setup_machine_tags(__atags_pointer, __machine_arch_type);
> diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
> index 7f39ce2..501af98 100644
> --- a/arch/arm/mm/Makefile
> +++ b/arch/arm/mm/Makefile
> @@ -12,6 +12,10 @@ ifneq ($(CONFIG_MMU),y)
>  obj-y                          += nommu.o
>  endif
>
> +ifeq ($(CONFIG_MMU),y)
> +obj-$(CONFIG_EARLY_IOREMAP)    += early_ioremap.o
> +endif
> +
>  obj-$(CONFIG_ARM_PTDUMP)       += dump.o
>  obj-$(CONFIG_MODULES)          += proc-syms.o
>
> diff --git a/arch/arm/mm/early_ioremap.c b/arch/arm/mm/early_ioremap.c
> new file mode 100644
> index 0000000..c3e2bf2
> --- /dev/null
> +++ b/arch/arm/mm/early_ioremap.c
> @@ -0,0 +1,93 @@
> +/*
> + * early_ioremap() support for ARM
> + *
> + * Based on existing support in arch/x86/mm/ioremap.c
> + *
> + * Restrictions: currently only functional before paging_init()
> + */
> +
> +#include <linux/init.h>
> +#include <linux/io.h>

io.h doesn't appear to be needed.

> +
> +#include <asm/fixmap.h>
> +#include <asm/pgalloc.h>
> +#include <asm/pgtable.h>
> +#include <asm/tlbflush.h>
> +
> +#include <asm/mach/map.h>
> +
> +static pte_t bm_pte[PTRS_PER_PTE] __aligned(PTE_HWTABLE_SIZE) __initdata;
> +
> +static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
> +{
> +       unsigned int index = pgd_index(addr);
> +       pgd_t *pgd = cpu_get_pgd() + index;
> +       pud_t *pud = pud_offset(pgd, addr);
> +       pmd_t *pmd = pmd_offset(pud, addr);
> +
> +       return pmd;
> +}
> +
> +static inline pte_t * __init early_ioremap_pte(unsigned long addr)
> +{
> +       return &bm_pte[pte_index(addr)];
> +}
> +
> +void __init early_ioremap_init(void)
> +{
> +       pmd_t *pmd;
> +
> +       pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
> +
> +       pmd_populate_kernel(NULL, pmd, bm_pte);
> +
> +       /*
> +        * Make sure we don't span multiple pmds.
> +        */
> +       BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
> +                    != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
> +
> +       if (pmd != early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END))) {
> +               WARN_ON(1);
> +               pr_warn("pmd %p != %p\n",
> +                       pmd, early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END)));
> +               pr_warn("fix_to_virt(FIX_BTMAP_BEGIN): %08lx\n",
> +                       fix_to_virt(FIX_BTMAP_BEGIN));
> +               pr_warn("fix_to_virt(FIX_BTMAP_END):   %08lx\n",
> +                       fix_to_virt(FIX_BTMAP_END));
> +               pr_warn("FIX_BTMAP_END:       %d\n", FIX_BTMAP_END);
> +               pr_warn("FIX_BTMAP_BEGIN:     %d\n", FIX_BTMAP_BEGIN);
> +       }
> +
> +       early_ioremap_setup();
> +}
> +
> +void __init __early_set_fixmap(enum fixed_addresses idx,
> +                              phys_addr_t phys, pgprot_t flags)
> +{
> +       unsigned long addr = __fix_to_virt(idx);
> +       pte_t *pte;
> +       u64 desc;
> +
> +       if (idx > FIX_KMAP_END) {
> +               BUG();
> +               return;
> +       }
> +       pte = early_ioremap_pte(addr);
> +
> +       if (pgprot_val(flags))
> +               set_pte_at(NULL, 0xfff00000, pte,

Couldn't you use addr here instead of 0xfff00000? It's not really used
other than a check against TASK_SIZE.

> +                          pfn_pte(phys >> PAGE_SHIFT, flags));

phys_to_pfn(phys)

> +       else
> +               pte_clear(NULL, addr, pte);
> +       flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> +       desc = *pte;
> +}
> +
> +void __init
> +early_ioremap_shutdown(void)
> +{
> +       pmd_t *pmd;
> +       pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
> +       pmd_clear(pmd);

This is redundant with the clearing done in devicemaps_init. Not a big
deal but this is probably something we don't want with permanent
mappings. I'm still trying to figure out how to do those. Leaving this
page table in place doesn't seem to work, so I think we'll have to
copy mappings to the new page tables.

Rob
