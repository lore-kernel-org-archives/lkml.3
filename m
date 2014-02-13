Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaBMDJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:09:51 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:57405 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaBMDJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:09:50 -0500
MIME-Version: 1.0
In-Reply-To: <20131012171007.GA17167@gmail.com>
References: <20131012171007.GA17167@gmail.com>
Date: Wed, 12 Feb 2014 19:09:48 -0800
Message-ID: <CAKbGBLgs9t4HPD4duBt=vPaw0WfxLv5qr6pNupHsPTFaV5m+dQ@mail.gmail.com>
Subject: Re: [GIT PULL] compiler/gcc4: Add quirk for 'asm goto' miscompilation bug
From: Steven Noonan <steven@uplinklabs.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jakub Jelinek <jakub@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resurrecting this thread, as I'm running with GCC 4.8.2 and am
encountering miscompiles without this quirk being enabled for my
compiler version. I'm having trouble pinning down the miscompilation
itself, but I have a problem that seems reliably reproducible in my
environment.

I noticed that when I launch/destroy a KVM guest, the guest memory is
staying mapped. i.e. host has 200MB used, guest launches, ~4300MB
used, guest terminates, still 4300MB used and no qemu-system-x86_64
process hanging around. Thus depending on the guest memory size I can
exhaust host memory after a few guest reboots.

If I change the GCC_VERSION check for the asm_volatile_goto quirk to
include 4.8.2, then KVM guests are properly cleaned up.

The test case provided in the 'asm goto' bugzilla entry doesn't fail
on my compiler: gcc.gnu.org/bugzilla/show_bug.cgi?id=58670

So is there some other 'asm goto' bug we haven't yet fully uncovered
and reported to GCC upstream? Anyone have any idea where to look for
the miscompilation? I started by looking at the
mmu_notifier_unregister() function, since that seems like the obvious
place for a guest memory unmap problem. mmu_notifier_unregister()
calls mmdrop(), which uses the atomic_dec_and_test macro to determine
whether or not to call __mmdrop(). The generated code looks correct to
me, but it's possibly not this callsite that's broken:

On Sat, Oct 12, 2013 at 10:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
> Linus,
>
> Please pull the latest core-urgent-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus
>
>    HEAD: 3f0116c3238a96bc18ad4b4acefe4e7be32fa861 compiler/gcc4: Add quirk for 'asm goto' miscompilation bug
>
> This is the fix for the GCC miscompilation discussed in the following lkml
> thread:
>
>    [x86] BUG: unable to handle kernel paging request at 00740060
>
> The bug in GCC has been fixed by Jakub and the fix will be part of the GCC
> 4.8.2 release expected to be released next week - so the quirk's version
> test checks for <= 4.8.1.
>
> The quirk is only added to compiler-gcc4.h and not to the higher level
> compiler.h because all asm goto uses are behind a feature check.
>
>  Thanks,
>
>         Ingo
>
> ------------------>
> Ingo Molnar (1):
>       compiler/gcc4: Add quirk for 'asm goto' miscompilation bug
>
>
>  arch/arm/include/asm/jump_label.h     |  2 +-
>  arch/mips/include/asm/jump_label.h    |  2 +-
>  arch/powerpc/include/asm/jump_label.h |  2 +-
>  arch/s390/include/asm/jump_label.h    |  2 +-
>  arch/sparc/include/asm/jump_label.h   |  2 +-
>  arch/x86/include/asm/cpufeature.h     |  6 +++---
>  arch/x86/include/asm/jump_label.h     |  2 +-
>  arch/x86/include/asm/mutex_64.h       |  4 ++--
>  include/linux/compiler-gcc4.h         | 15 +++++++++++++++
>  9 files changed, 26 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_label.h
> index bfc198c..863c892 100644
> --- a/arch/arm/include/asm/jump_label.h
> +++ b/arch/arm/include/asm/jump_label.h
> @@ -16,7 +16,7 @@
>
>  static __always_inline bool arch_static_branch(struct static_key *key)
>  {
> -       asm goto("1:\n\t"
> +       asm_volatile_goto("1:\n\t"
>                  JUMP_LABEL_NOP "\n\t"
>                  ".pushsection __jump_table,  \"aw\"\n\t"
>                  ".word 1b, %l[l_yes], %c0\n\t"
> diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
> index 4d6d77e..e194f95 100644
> --- a/arch/mips/include/asm/jump_label.h
> +++ b/arch/mips/include/asm/jump_label.h
> @@ -22,7 +22,7 @@
>
>  static __always_inline bool arch_static_branch(struct static_key *key)
>  {
> -       asm goto("1:\tnop\n\t"
> +       asm_volatile_goto("1:\tnop\n\t"
>                 "nop\n\t"
>                 ".pushsection __jump_table,  \"aw\"\n\t"
>                 WORD_INSN " 1b, %l[l_yes], %0\n\t"
> diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/asm/jump_label.h
> index ae098c4..f016bb6 100644
> --- a/arch/powerpc/include/asm/jump_label.h
> +++ b/arch/powerpc/include/asm/jump_label.h
> @@ -19,7 +19,7 @@
>
>  static __always_inline bool arch_static_branch(struct static_key *key)
>  {
> -       asm goto("1:\n\t"
> +       asm_volatile_goto("1:\n\t"
>                  "nop\n\t"
>                  ".pushsection __jump_table,  \"aw\"\n\t"
>                  JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
> diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
> index 6c32190..346b1c8 100644
> --- a/arch/s390/include/asm/jump_label.h
> +++ b/arch/s390/include/asm/jump_label.h
> @@ -15,7 +15,7 @@
>
>  static __always_inline bool arch_static_branch(struct static_key *key)
>  {
> -       asm goto("0:    brcl 0,0\n"
> +       asm_volatile_goto("0:   brcl 0,0\n"
>                 ".pushsection __jump_table, \"aw\"\n"
>                 ASM_ALIGN "\n"
>                 ASM_PTR " 0b, %l[label], %0\n"
> diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
> index 5080d16..ec2e2e2 100644
> --- a/arch/sparc/include/asm/jump_label.h
> +++ b/arch/sparc/include/asm/jump_label.h
> @@ -9,7 +9,7 @@
>
>  static __always_inline bool arch_static_branch(struct static_key *key)
>  {
> -               asm goto("1:\n\t"
> +               asm_volatile_goto("1:\n\t"
>                          "nop\n\t"
>                          "nop\n\t"
>                          ".pushsection __jump_table,  \"aw\"\n\t"
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index d3f5c63..89270b4 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -374,7 +374,7 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
>                  * Catch too early usage of this before alternatives
>                  * have run.
>                  */
> -               asm goto("1: jmp %l[t_warn]\n"
> +               asm_volatile_goto("1: jmp %l[t_warn]\n"
>                          "2:\n"
>                          ".section .altinstructions,\"a\"\n"
>                          " .long 1b - .\n"
> @@ -388,7 +388,7 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
>
>  #endif
>
> -               asm goto("1: jmp %l[t_no]\n"
> +               asm_volatile_goto("1: jmp %l[t_no]\n"
>                          "2:\n"
>                          ".section .altinstructions,\"a\"\n"
>                          " .long 1b - .\n"
> @@ -453,7 +453,7 @@ static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
>   * have. Thus, we force the jump to the widest, 4-byte, signed relative
>   * offset even though the last would often fit in less bytes.
>   */
> -               asm goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
> +               asm_volatile_goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
>                          "2:\n"
>                          ".section .altinstructions,\"a\"\n"
>                          " .long 1b - .\n"              /* src offset */
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> index 64507f3..6a2cefb 100644
> --- a/arch/x86/include/asm/jump_label.h
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -18,7 +18,7 @@
>
>  static __always_inline bool arch_static_branch(struct static_key *key)
>  {
> -       asm goto("1:"
> +       asm_volatile_goto("1:"
>                 ".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
>                 ".pushsection __jump_table,  \"aw\" \n\t"
>                 _ASM_ALIGN "\n\t"
> diff --git a/arch/x86/include/asm/mutex_64.h b/arch/x86/include/asm/mutex_64.h
> index e7e6751..07537a4 100644
> --- a/arch/x86/include/asm/mutex_64.h
> +++ b/arch/x86/include/asm/mutex_64.h
> @@ -20,7 +20,7 @@
>  static inline void __mutex_fastpath_lock(atomic_t *v,
>                                          void (*fail_fn)(atomic_t *))
>  {
> -       asm volatile goto(LOCK_PREFIX "   decl %0\n"
> +       asm_volatile_goto(LOCK_PREFIX "   decl %0\n"
>                           "   jns %l[exit]\n"
>                           : : "m" (v->counter)
>                           : "memory", "cc"
> @@ -75,7 +75,7 @@ static inline int __mutex_fastpath_lock_retval(atomic_t *count)
>  static inline void __mutex_fastpath_unlock(atomic_t *v,
>                                            void (*fail_fn)(atomic_t *))
>  {
> -       asm volatile goto(LOCK_PREFIX "   incl %0\n"
> +       asm_volatile_goto(LOCK_PREFIX "   incl %0\n"
>                           "   jg %l[exit]\n"
>                           : : "m" (v->counter)
>                           : "memory", "cc"
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 842de22..ded4299 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -65,6 +65,21 @@
>  #define __visible __attribute__((externally_visible))
>  #endif
>
> +/*
> + * GCC 'asm goto' miscompiles certain code sequences:
> + *
> + *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
> + *
> + * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
> + * Fixed in GCC 4.8.2 and later versions.
> + *
> + * (asm goto is automatically volatile - the naming reflects this.)
> + */
> +#if GCC_VERSION <= 40801
> +# define asm_volatile_goto(x...)       do { asm goto(x); asm (""); } while (0)
> +#else
> +# define asm_volatile_goto(x...)       do { asm goto(x); } while (0)
> +#endif
>
>  #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
>  #if GCC_VERSION >= 40400
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
