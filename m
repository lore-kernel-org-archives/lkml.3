Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaKDSnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:43:04 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46511 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaKDSnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:43:02 -0500
MIME-Version: 1.0
In-Reply-To: <1415121836-16241-1-git-send-email-leif.lindholm@linaro.org>
References: <1415121836-16241-1-git-send-email-leif.lindholm@linaro.org>
Date: Tue, 4 Nov 2014 10:43:00 -0800
X-Google-Sender-Auth: 6rlxUc6uADbxFvj0KubXkwqIkjg
Message-ID: <CAGXu5jL1BBAvoxVqFa1YHJSMCbGdLiPey-dyC15YKVPB2xGfig@mail.gmail.com>
Subject: Re: [RFC PATCH] make CONFIG_STRICT_DEVMEM a core non-debug feature
From: Kees Cook <keescook@chromium.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        paulus@samba.org, mpe@ellerman.id.au,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, eiko.carstens@de.ibm.com,
        linux390@de.ibm.com, metcalf@tilera.com,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, dave.long@linaro.org,
        Christoph Hellwig <hch@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 9:23 AM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> Most, but not all, architectures supporting CONFIG_STRICT_DEVMEM treat
> it as a debug feature - although its function is pretty much the
> opposite of debug.
>
> This patch deletes all architecture-specific config options and moves
> the option to core code, as a non-debug option.
>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
> Apologies for wide distribution, but this is a bit invasive,
> if trivial.
>
>  arch/Kconfig                 |    3 +++
>  arch/arm/Kconfig             |    1 +
>  arch/arm/Kconfig.debug       |   14 --------------
>  arch/arm64/Kconfig           |    1 +
>  arch/arm64/Kconfig.debug     |   14 --------------
>  arch/powerpc/Kconfig         |    1 +
>  arch/powerpc/Kconfig.debug   |   12 ------------
>  arch/s390/Kconfig            |    1 +
>  arch/s390/Kconfig.debug      |   12 ------------
>  arch/tile/Kconfig            |    4 +---
>  arch/unicore32/Kconfig       |    1 +
>  arch/unicore32/Kconfig.debug |   14 --------------
>  arch/x86/Kconfig             |    1 +
>  arch/x86/Kconfig.debug       |   17 -----------------
>  drivers/char/Kconfig         |   16 ++++++++++++++++
>  15 files changed, 26 insertions(+), 86 deletions(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 05d7a8a..e5f4f03 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -484,6 +484,9 @@ config HAVE_IRQ_EXIT_ON_IRQ_STACK
>           This spares a stack switch and improves cache usage on softirq
>           processing.
>
> +config HAVE_ARCH_RESTRICTED_DEVMEM
> +       bool
> +
>  #
>  # ABI hall of shame
>  #
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 89c4b5c..e04910f 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -30,6 +30,7 @@ config ARM
>         select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
>         select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
>         select HAVE_ARCH_KGDB
> +       select HAVE_ARCH_RESTRICTED_DEVMEM if MMU
>         select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
>         select HAVE_ARCH_TRACEHOOK
>         select HAVE_BPF_JIT
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index d8f6a2e..2a02a7d 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -14,20 +14,6 @@ config ARM_PTDUMP
>           kernel.
>           If in doubt, say "N"
>
> -config STRICT_DEVMEM
> -       bool "Filter access to /dev/mem"
> -       depends on MMU
> -       ---help---
> -         If this option is disabled, you allow userspace (root) access to all
> -         of memory, including kernel and userspace memory. Accidental
> -         access to this is obviously disastrous, but specific access can
> -         be used by people debugging the kernel.
> -
> -         If this option is switched on, the /dev/mem file only allows
> -         userspace access to memory mapped peripherals.
> -
> -          If in doubt, say Y.
> -
>  # RMK wants arm kernels compiled with frame pointers or stack unwinding.
>  # If you know what you are doing and are willing to live without stack
>  # traces, you can get a slightly smaller kernel by setting this option to
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 9532f8d..90abbb2 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -37,6 +37,7 @@ config ARM64
>         select HAVE_ARCH_AUDITSYSCALL
>         select HAVE_ARCH_JUMP_LABEL
>         select HAVE_ARCH_KGDB
> +       select HAVE_ARCH_RESTRICTED_DEVMEM if MMU
>         select HAVE_ARCH_TRACEHOOK
>         select HAVE_BPF_JIT
>         select HAVE_C_RECORDMCOUNT
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 0a12933..d0036dd 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -6,20 +6,6 @@ config FRAME_POINTER
>         bool
>         default y
>
> -config STRICT_DEVMEM
> -       bool "Filter access to /dev/mem"
> -       depends on MMU
> -       help
> -         If this option is disabled, you allow userspace (root) access to all
> -         of memory, including kernel and userspace memory. Accidental
> -         access to this is obviously disastrous, but specific access can
> -         be used by people debugging the kernel.
> -
> -         If this option is switched on, the /dev/mem file only allows
> -         userspace access to memory mapped peripherals.
> -
> -         If in doubt, say Y.
> -
>  config PID_IN_CONTEXTIDR
>         bool "Write the current PID to the CONTEXTIDR register"
>         help
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 88eace4..cd35068 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -148,6 +148,7 @@ config PPC
>         select HAVE_ARCH_AUDITSYSCALL
>         select ARCH_SUPPORTS_ATOMIC_RMW
>         select DCACHE_WORD_ACCESS if PPC64 && CPU_LITTLE_ENDIAN
> +       select HAVE_ARCH_RESTRICTED_DEVMEM
>
>  config GENERIC_CSUM
>         def_bool CPU_LITTLE_ENDIAN
> diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
> index ec2e40f..6f11382 100644
> --- a/arch/powerpc/Kconfig.debug
> +++ b/arch/powerpc/Kconfig.debug
> @@ -334,18 +334,6 @@ config PPC_EARLY_DEBUG_CPM_ADDR
>           platform probing is done, all platforms selected must
>           share the same address.
>
> -config STRICT_DEVMEM
> -       def_bool y
> -       prompt "Filter access to /dev/mem"
> -       help
> -         This option restricts access to /dev/mem.  If this option is
> -         disabled, you allow userspace access to all memory, including
> -         kernel and userspace memory. Accidental memory access is likely
> -         to be disastrous.
> -         Memory access is required for experts who want to debug the kernel.
> -
> -         If you are unsure, say Y.
> -
>  config FAIL_IOMMU
>         bool "Fault-injection capability for IOMMU"
>         depends on FAULT_INJECTION
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index f2cf1f9..fe92272 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -109,6 +109,7 @@ config S390
>         select HAVE_ALIGNED_STRUCT_PAGE if SLUB
>         select HAVE_ARCH_AUDITSYSCALL
>         select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
> +       select HAVE_ARCH_RESTRICTED_DEVMEM
>         select HAVE_ARCH_SECCOMP_FILTER
>         select HAVE_ARCH_TRACEHOOK
>         select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT
> diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
> index c56878e..26c5d5be 100644
> --- a/arch/s390/Kconfig.debug
> +++ b/arch/s390/Kconfig.debug
> @@ -5,18 +5,6 @@ config TRACE_IRQFLAGS_SUPPORT
>
>  source "lib/Kconfig.debug"
>
> -config STRICT_DEVMEM
> -       def_bool y
> -       prompt "Filter access to /dev/mem"
> -       ---help---
> -         This option restricts access to /dev/mem.  If this option is
> -         disabled, you allow userspace access to all memory, including
> -         kernel and userspace memory. Accidental memory access is likely
> -         to be disastrous.
> -         Memory access is required for experts who want to debug the kernel.
> -
> -         If you are unsure, say Y.
> -
>  config S390_PTDUMP
>         bool "Export kernel pagetable layout to userspace via debugfs"
>         depends on DEBUG_KERNEL
> diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
> index 7cca418..f881168 100644
> --- a/arch/tile/Kconfig
> +++ b/arch/tile/Kconfig
> @@ -27,6 +27,7 @@ config TILE
>         select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>         select HAVE_DEBUG_STACKOVERFLOW
>         select ARCH_WANT_FRAME_POINTERS
> +       select HAVE_ARCH_RESTRICTED_DEVMEM
>
>  # FIXME: investigate whether we need/want these options.
>  #      select HAVE_IOREMAP_PROT
> @@ -110,9 +111,6 @@ config ARCH_DISCONTIGMEM_DEFAULT
>  config TRACE_IRQFLAGS_SUPPORT
>         def_bool y
>
> -config STRICT_DEVMEM
> -       def_bool y
> -
>  # SMP is required for Tilera Linux.
>  config SMP
>         def_bool y
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index 928237a..574b07f 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -18,6 +18,7 @@ config UNICORE32
>         select ARCH_WANT_FRAME_POINTERS
>         select GENERIC_IOMAP
>         select MODULES_USE_ELF_REL
> +       select HAVE_ARCH_RESTRICTED_DEVMEM if MMU
>         help
>           UniCore-32 is 32-bit Instruction Set Architecture,
>           including a series of low-power-consumption RISC chip
> diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
> index 1a36262..f075bbe 100644
> --- a/arch/unicore32/Kconfig.debug
> +++ b/arch/unicore32/Kconfig.debug
> @@ -2,20 +2,6 @@ menu "Kernel hacking"
>
>  source "lib/Kconfig.debug"
>
> -config STRICT_DEVMEM
> -       bool "Filter access to /dev/mem"
> -       depends on MMU
> -       ---help---
> -         If this option is disabled, you allow userspace (root) access to all
> -         of memory, including kernel and userspace memory. Accidental
> -         access to this is obviously disastrous, but specific access can
> -         be used by people debugging the kernel.
> -
> -         If this option is switched on, the /dev/mem file only allows
> -         userspace access to memory mapped peripherals.
> -
> -          If in doubt, say Y.
> -
>  config EARLY_PRINTK
>         def_bool DEBUG_OCD
>         help
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ded8a67..91392bf 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -137,6 +137,7 @@ config X86
>         select HAVE_ACPI_APEI_NMI if ACPI
>         select ACPI_LEGACY_TABLES_LOOKUP if ACPI
>         select X86_FEATURE_NAMES if PROC_FS
> +       select HAVE_ARCH_RESTRICTED_DEVMEM
>
>  config INSTRUCTION_DECODER
>         def_bool y
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 61bd2ad..e35d4a1 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -5,23 +5,6 @@ config TRACE_IRQFLAGS_SUPPORT
>
>  source "lib/Kconfig.debug"
>
> -config STRICT_DEVMEM
> -       bool "Filter access to /dev/mem"
> -       ---help---
> -         If this option is disabled, you allow userspace (root) access to all
> -         of memory, including kernel and userspace memory. Accidental
> -         access to this is obviously disastrous, but specific access can
> -         be used by people debugging the kernel. Note that with PAT support
> -         enabled, even in this case there are restrictions on /dev/mem
> -         use due to the cache aliasing requirements.
> -
> -         If this option is switched on, the /dev/mem file only allows
> -         userspace access to PCI space and the BIOS code and data regions.
> -         This is sufficient for dosemu and X and all common users of
> -         /dev/mem.
> -
> -         If in doubt, say Y.
> -
>  config X86_VERBOSE_BOOTUP
>         bool "Enable verbose x86 bootup info messages"
>         default y
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index efefd12..39f7817 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -6,6 +6,22 @@ menu "Character devices"
>
>  source "drivers/tty/Kconfig"
>
> +config STRICT_DEVMEM
> +       bool "Reduced access to /dev/mem"
> +       depends on HAVE_ARCH_RESTRICTED_DEVMEM
> +       default y
> +       help
> +         If this option is disabled, you allow userspace (root) access to all
> +         of memory, including kernel and userspace memory. Accidental
> +         access to this is obviously disastrous, but specific access can
> +         be used by people debugging the kernel.
> +
> +         If this option is switched on, the /dev/mem file restricts userspace
> +         access to an architecture-specific subset of the physical address
> +         space.

Great consolidation, thanks! I would probably expand this help text a
bit to include some of details mentioned in the x86 portion of the
option. For example:


If this option is switched on, the /dev/mem file restricts userspace
access to an architecture-specific subset of the physical address
space. For example on x86, PCI space and BIOS code and data
regions. This is sufficient for things like dosemu and non-KMS
Xorg and all common users of /dev/mem.


Thanks!

-Kees

> +
> +         If in doubt, say Y.
> +
>  config DEVKMEM
>         bool "/dev/kmem virtual device support"
>         default y
> --
> 1.7.10.4
>



-- 
Kees Cook
Chrome OS Security
