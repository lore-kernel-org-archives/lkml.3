Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3IKKz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:55:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40682 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465Ab3IKKzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:55:55 -0400
Date: Wed, 11 Sep 2013 11:55:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <pinskia@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Andrew Pinski <apinski@cavium.com>
Subject: Re: [PATCH 1/5] ARM64: Split out CONFIG_ARM64_AARCH32 from
 CONFIG_COMPAT. Signed-off-by: Andrew Pinski <apinski@cavium.com>
Message-ID: <20130911105523.GB26777@darko.cambridge.arm.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378762380-13152-1-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Sep 09, 2013 at 10:32:55PM +0100, Andrew Pinski wrote:
> Right now CONFIG_COMPAT means enabling AARCH32 support in the ARM64 traget, which we want to split out so we can it to mean any 32bit ABI support instead.

First, there are some coding style and patch format issues. Please pass
the patches through checkpatch.pl.

Also, I would like to see a cover letter giving an overview of the ABI
changes needed for arm64 ILP32 and better, longer patch description. At
a first look, you would think that this simply changes CONFIG_COMPAT to
CONFIG_ARM64_AARCH32 but you have other changes like compat_elf_greg_t
types.

More comments below.

> --- a/arch/arm64/include/asm/compat.h
> +++ b/arch/arm64/include/asm/compat.h
> @@ -279,28 +279,52 @@ struct compat_shmid64_ds {
>         compat_ulong_t __unused5;
>  };
> 
> -static inline int is_compat_task(void)
> +#if defined(CONFIG_ARM64_AARCH32)
> +static inline int is_aarch32_task(void)
>  {
>         return test_thread_flag(TIF_32BIT);
>  }
> 
> -static inline int is_compat_thread(struct thread_info *thread)
> +static inline int is_aarch32_thread(struct thread_info *thread)
>  {
>         return test_ti_thread_flag(thread, TIF_32BIT);
>  }
> +#else
> +static inline int is_aarch32_task(void)
> +{
> +       return 0;
> +}
> +
> +static inline int is_aarch32_thread(struct thread_info *thread)
> +{
> +       return 0;
> +}
> +#endif
> +
> 
>  #else /* !CONFIG_COMPAT */

Is the comment still correct here?

> -static inline int is_compat_task(void)
> +static inline int is_aarch32_task(void)
>  {
>         return 0;
>  }
> 
> -static inline int is_compat_thread(struct thread_info *thread)
> +static inline int is_aarch32_thread(struct thread_info *thread)
>  {
>         return 0;
>  }
> 
>  #endif /* CONFIG_COMPAT */

Same here.

> diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
> index e7fa87f..0a89e94 100644
> --- a/arch/arm64/include/asm/elf.h
> +++ b/arch/arm64/include/asm/elf.h
> @@ -153,24 +153,33 @@ extern unsigned long arch_randomize_brk(struct mm_struct *mm);
> 
>  #define COMPAT_ELF_ET_DYN_BASE         (randomize_et_dyn(2 * TASK_SIZE_32 / 3))
> 
> +#ifdef CONFIG_ARM64_AARCH32
>  /* AArch32 registers. */
>  #define COMPAT_ELF_NGREG               18
> -typedef unsigned int                   compat_elf_greg_t;
> -typedef compat_elf_greg_t              compat_elf_gregset_t[COMPAT_ELF_NGREG];
> +typedef unsigned int                   compat_a32_elf_greg_t;
> +typedef compat_a32_elf_greg_t compat_a32_elf_gregset_t[COMPAT_ELF_NGREG];

I'm not sure we need to bother placing typedefs under #ifdef. I'll have
to see how this file is modified in later patches.

> 
>  /* AArch32 EABI. */
>  #define EF_ARM_EABI_MASK               0xff000000
> -#define compat_elf_check_arch(x)       (((x)->e_machine == EM_ARM) && \
> +#define compat_elf_a32_check_arch(x)   (((x)->e_machine == EM_ARM) && \
>                                          ((x)->e_flags & EF_ARM_EABI_MASK))
> 
> -#define compat_start_thread            compat_start_thread
> -#define COMPAT_SET_PERSONALITY(ex)     set_thread_flag(TIF_32BIT);
> +#define COMPAT_SET_A32_PERSONALITY(ex) set_thread_flag(TIF_32BIT);
>  #define COMPAT_ARCH_DLINFO
> +
>  extern int aarch32_setup_vectors_page(struct linux_binprm *bprm,
>                                       int uses_interp);
>  #define compat_arch_setup_additional_pages \
>                                         aarch32_setup_vectors_page
> 
> +typedef compat_a32_elf_greg_t          compat_elf_greg_t;
> +typedef compat_a32_elf_gregset_t       compat_elf_gregset_t;
> +#endif
> +
> +#define compat_elf_check_arch(x) compat_elf_a32_check_arch(x)
> +#define COMPAT_SET_PERSONALITY(ex) COMPAT_SET_A32_PERSONALITY(x)
> +#define compat_start_thread            compat_start_thread
> +
>  #endif /* CONFIG_COMPAT */

Mismatched comment?

> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 20925bc..4a644a5 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -49,11 +49,11 @@
> 
>  #ifdef CONFIG_COMPAT
>  #define TASK_SIZE_32           UL(0x100000000)
> -#define TASK_SIZE              (test_thread_flag(TIF_32BIT) ? \
> +#define TASK_SIZE              (is_compat_task() ? \
>                                 TASK_SIZE_32 : TASK_SIZE_64)

Does this file also need to include compat.h?

> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -38,7 +38,7 @@
>  #define STACK_TOP_MAX          TASK_SIZE_64
>  #ifdef CONFIG_COMPAT
>  #define AARCH32_VECTORS_BASE   0xffff0000
> -#define STACK_TOP              (test_thread_flag(TIF_32BIT) ? \
> +#define STACK_TOP              (is_compat_task() ? \
>                                 AARCH32_VECTORS_BASE : STACK_TOP_MAX)

Same here.

> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -107,7 +107,7 @@ struct pt_regs {
> 
>  #define arch_has_single_step() (1)
> 
> -#ifdef CONFIG_COMPAT
> +#ifdef CONFIG_ARM64_AARCH32
>  #define compat_thumb_mode(regs) \
>         (((regs)->pstate & COMPAT_PSR_T_BIT))

Maybe for consistency it could be worth changing to
compat_a32_thumb_mode(), if the aim is to use compat_ prefix for ILP32
as well (I'll see in the rest of the patches).

> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -35,6 +35,7 @@
>  #include <asm/system_misc.h>
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
> +#include <asm/compat.h>
> 
>  static const char *fault_name(unsigned int esr);
> 
> diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
> index 8ed6cb1..29eb82a 100644
> --- a/arch/arm64/mm/mmap.c
> +++ b/arch/arm64/mm/mmap.c
> @@ -28,6 +28,7 @@
>  #include <linux/random.h>
> 
>  #include <asm/cputype.h>
> +#include <asm/compat.h>

So you added these includes because one was missing in memory.h?

-- 
Catalin
