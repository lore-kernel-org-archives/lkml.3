Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbaAJQLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:11:06 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:61143 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaAJQLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:11:04 -0500
MIME-Version: 1.0
In-Reply-To: <1389325833-16535-5-git-send-email-msalter@redhat.com>
References: <1389325833-16535-1-git-send-email-msalter@redhat.com>
	<1389325833-16535-5-git-send-email-msalter@redhat.com>
Date: Fri, 10 Jan 2014 10:11:03 -0600
Message-ID: <CAL_JsqLZQ=3gph4yaNSrZ5oPL3kasQKqA5C5+my0GwjGHsvMeQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] arm: add early_ioremap support
From: Rob Herring <robherring2@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 9:50 PM, Mark Salter <msalter@redhat.com> wrote:
> This patch uses the generic early_ioremap code to implement
> early_ioremap for ARM. The ARM-specific bits come mostly from
> an earlier patch from Leif Lindholm <leif.lindholm@linaro.org>
> here:
>
>   https://lkml.org/lkml/2013/10/3/279

I think this will be useful to implement an arm64 style earlycon for
arm as the current DEBUG_LL doesn't really work with multi-platform
kernels. I started on this and quickly realized I needed the fixmap
support.

> Signed-off-by: Mark Salter <msalter@redhat.com>
> Tested-by: Leif Lindholm <leif.lindholm@linaro.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> CC: linux-arm-kernel@lists.infradead.org
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/Kconfig              | 11 +++++
>  arch/arm/include/asm/Kbuild   |  1 +
>  arch/arm/include/asm/fixmap.h | 18 +++++++++
>  arch/arm/include/asm/io.h     |  1 +
>  arch/arm/kernel/setup.c       |  3 ++
>  arch/arm/mm/Makefile          |  1 +
>  arch/arm/mm/early_ioremap.c   | 93 +++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mm/mmu.c             |  2 +
>  8 files changed, 130 insertions(+)
>  create mode 100644 arch/arm/mm/early_ioremap.c
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c1f1a7e..78a79a6a 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1842,6 +1842,17 @@ config UACCESS_WITH_MEMCPY
>           However, if the CPU data cache is using a write-allocate mode,
>           this option is unlikely to provide any performance gain.
>
> +config EARLY_IOREMAP
> +       depends on MMU

Is it possible to implement a !MMU version of early_ioremap that
simply returns the phys address rather than have this dependency?

> +       bool "Provide early_ioremap() support for kernel initialization."
> +       select GENERIC_EARLY_IOREMAP
> +       help
> +         Provide a mechanism for kernel initialisation code to temporarily
> +         map, in a highmem-agnostic way, memory pages in before ioremap()
> +         and friends are available (before paging_init() has run). It uses
> +         the same virtual memory range as kmap so all early mappings must
> +         be unapped before paging_init() is called.
> +
>  config SECCOMP
>         bool
>         prompt "Enable seccomp to safely compute untrusted bytecode"
> diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
> index c38b58c..49ec506 100644
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
> index 68ea615..e92b7a4 100644
> --- a/arch/arm/include/asm/fixmap.h
> +++ b/arch/arm/include/asm/fixmap.h
> @@ -21,8 +21,26 @@ enum fixed_addresses {
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
>  };
>
> +#define FIXMAP_PAGE_NORMAL (L_PTE_MT_WRITEBACK | L_PTE_YOUNG | L_PTE_PRESENT)
> +#define FIXMAP_PAGE_IO (L_PTE_MT_DEV_NONSHARED | L_PTE_YOUNG | L_PTE_PRESENT)
> +
> +extern void __early_set_fixmap(enum fixed_addresses idx,
> +                              phys_addr_t phys, pgprot_t flags);
> +
>  #include <asm-generic/fixmap.h>
>
>  #endif
> diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> index fbeb39c..6b2cc53 100644
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
> index 987a7f5..038fb75 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -36,6 +36,7 @@
>  #include <asm/cpu.h>
>  #include <asm/cputype.h>
>  #include <asm/elf.h>
> +#include <asm/io.h>

Use linux/io.h?

>  #include <asm/procinfo.h>
>  #include <asm/psci.h>
>  #include <asm/sections.h>
> @@ -887,6 +888,8 @@ void __init setup_arch(char **cmdline_p)
>
>         parse_early_param();
>
> +       early_ioremap_init();
> +

This call would need to be before parse_early_param for the earlycon to work.

Rob
