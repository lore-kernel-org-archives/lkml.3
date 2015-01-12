Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbbALAi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 19:38:59 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:55370 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbbALAi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 19:38:58 -0500
MIME-Version: 1.0
In-Reply-To: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 11 Jan 2015 16:38:36 -0800
Message-ID: <CALCETrXsSTPi2jmMgA_Muh6y6eU2yq-fs8_MGPhJVNnfYaop1A@mail.gmail.com>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 3:07 PM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
> Sequences
>         pushl_cfi %reg
>         CFI_REL_OFFSET reg, 0
> and
>         popl_cfi %reg
>         CFI_RESTORE reg
> happen quite often. This patch adds macros which generate them.
>
> No assembly changes (verified with objdump -dr vmlinux.o).

Looks sane to me.  Where does this apply in relation to the rest of your series?

>
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: X86 ML <x86@kernel.org>
> CC: Alexei Starovoitov <ast@plumgrid.com>
> CC: Will Drewry <wad@chromium.org>
> CC: Kees Cook <keescook@chromium.org>
> CC: linux-kernel@vger.kernel.org
> ---
>  arch/x86/include/asm/calling.h | 42 ++++++++++-------------------
>  arch/x86/include/asm/dwarf2.h  | 24 +++++++++++++++++
>  arch/x86/kernel/entry_32.S     | 21 +++++----------
>  arch/x86/lib/atomic64_cx8_32.S | 50 ++++++++++++++---------------------
>  arch/x86/lib/checksum_32.S     | 60 ++++++++++++++----------------------------
>  arch/x86/lib/msr-reg.S         | 24 ++++++++---------
>  arch/x86/lib/rwsem.S           | 44 ++++++++++++++-----------------
>  arch/x86/lib/thunk_32.S        | 18 +++++--------
>  arch/x86/lib/thunk_64.S        | 54 +++++++++++++------------------------
>  9 files changed, 141 insertions(+), 196 deletions(-)
>
> diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
> index 1f1297b..3c711f2a 100644
> --- a/arch/x86/include/asm/calling.h
> +++ b/arch/x86/include/asm/calling.h
> @@ -210,37 +210,23 @@ For 32-bit we have the following conventions - kernel is built with
>   */
>
>         .macro SAVE_ALL
> -       pushl_cfi %eax
> -       CFI_REL_OFFSET eax, 0
> -       pushl_cfi %ebp
> -       CFI_REL_OFFSET ebp, 0
> -       pushl_cfi %edi
> -       CFI_REL_OFFSET edi, 0
> -       pushl_cfi %esi
> -       CFI_REL_OFFSET esi, 0
> -       pushl_cfi %edx
> -       CFI_REL_OFFSET edx, 0
> -       pushl_cfi %ecx
> -       CFI_REL_OFFSET ecx, 0
> -       pushl_cfi %ebx
> -       CFI_REL_OFFSET ebx, 0
> +       pushl_cfi_reg eax
> +       pushl_cfi_reg ebp
> +       pushl_cfi_reg edi
> +       pushl_cfi_reg esi
> +       pushl_cfi_reg edx
> +       pushl_cfi_reg ecx
> +       pushl_cfi_reg ebx
>         .endm
>
>         .macro RESTORE_ALL
> -       popl_cfi %ebx
> -       CFI_RESTORE ebx
> -       popl_cfi %ecx
> -       CFI_RESTORE ecx
> -       popl_cfi %edx
> -       CFI_RESTORE edx
> -       popl_cfi %esi
> -       CFI_RESTORE esi
> -       popl_cfi %edi
> -       CFI_RESTORE edi
> -       popl_cfi %ebp
> -       CFI_RESTORE ebp
> -       popl_cfi %eax
> -       CFI_RESTORE eax
> +       popl_cfi_reg ebx
> +       popl_cfi_reg ecx
> +       popl_cfi_reg edx
> +       popl_cfi_reg esi
> +       popl_cfi_reg edi
> +       popl_cfi_reg ebp
> +       popl_cfi_reg eax
>         .endm
>
>  #endif /* CONFIG_X86_64 */
> diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
> index f6f1598..de1cdaf 100644
> --- a/arch/x86/include/asm/dwarf2.h
> +++ b/arch/x86/include/asm/dwarf2.h
> @@ -86,11 +86,23 @@
>         CFI_ADJUST_CFA_OFFSET 8
>         .endm
>
> +       .macro pushq_cfi_reg reg
> +       pushq %\reg
> +       CFI_ADJUST_CFA_OFFSET 8
> +       CFI_REL_OFFSET \reg, 0
> +       .endm
> +
>         .macro popq_cfi reg
>         popq \reg
>         CFI_ADJUST_CFA_OFFSET -8
>         .endm
>
> +       .macro popq_cfi_reg reg
> +       popq %\reg
> +       CFI_ADJUST_CFA_OFFSET -8
> +       CFI_RESTORE \reg
> +       .endm
> +
>         .macro pushfq_cfi
>         pushfq
>         CFI_ADJUST_CFA_OFFSET 8
> @@ -116,11 +128,23 @@
>         CFI_ADJUST_CFA_OFFSET 4
>         .endm
>
> +       .macro pushl_cfi_reg reg
> +       pushl %\reg
> +       CFI_ADJUST_CFA_OFFSET 4
> +       CFI_REL_OFFSET \reg, 0
> +       .endm
> +
>         .macro popl_cfi reg
>         popl \reg
>         CFI_ADJUST_CFA_OFFSET -4
>         .endm
>
> +       .macro popl_cfi_reg reg
> +       popl %\reg
> +       CFI_ADJUST_CFA_OFFSET -4
> +       CFI_RESTORE \reg
> +       .endm
> +
>         .macro pushfl_cfi
>         pushfl
>         CFI_ADJUST_CFA_OFFSET 4
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 000d419..a4a2eaa 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1237,20 +1237,13 @@ error_code:
>         /*CFI_REL_OFFSET es, 0*/
>         pushl_cfi %ds
>         /*CFI_REL_OFFSET ds, 0*/
> -       pushl_cfi %eax
> -       CFI_REL_OFFSET eax, 0
> -       pushl_cfi %ebp
> -       CFI_REL_OFFSET ebp, 0
> -       pushl_cfi %edi
> -       CFI_REL_OFFSET edi, 0
> -       pushl_cfi %esi
> -       CFI_REL_OFFSET esi, 0
> -       pushl_cfi %edx
> -       CFI_REL_OFFSET edx, 0
> -       pushl_cfi %ecx
> -       CFI_REL_OFFSET ecx, 0
> -       pushl_cfi %ebx
> -       CFI_REL_OFFSET ebx, 0
> +       pushl_cfi_reg eax
> +       pushl_cfi_reg ebp
> +       pushl_cfi_reg edi
> +       pushl_cfi_reg esi
> +       pushl_cfi_reg edx
> +       pushl_cfi_reg ecx
> +       pushl_cfi_reg ebx
>         cld
>         movl $(__KERNEL_PERCPU), %ecx
>         movl %ecx, %fs
> diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
> index f5cc9eb..082a851 100644
> --- a/arch/x86/lib/atomic64_cx8_32.S
> +++ b/arch/x86/lib/atomic64_cx8_32.S
> @@ -13,16 +13,6 @@
>  #include <asm/alternative-asm.h>
>  #include <asm/dwarf2.h>
>
> -.macro SAVE reg
> -       pushl_cfi %\reg
> -       CFI_REL_OFFSET \reg, 0
> -.endm
> -
> -.macro RESTORE reg
> -       popl_cfi %\reg
> -       CFI_RESTORE \reg
> -.endm
> -
>  .macro read64 reg
>         movl %ebx, %eax
>         movl %ecx, %edx
> @@ -67,10 +57,10 @@ ENDPROC(atomic64_xchg_cx8)
>  .macro addsub_return func ins insc
>  ENTRY(atomic64_\func\()_return_cx8)
>         CFI_STARTPROC
> -       SAVE ebp
> -       SAVE ebx
> -       SAVE esi
> -       SAVE edi
> +       pushl_cfi_reg ebp
> +       pushl_cfi_reg ebx
> +       pushl_cfi_reg esi
> +       pushl_cfi_reg edi
>
>         movl %eax, %esi
>         movl %edx, %edi
> @@ -89,10 +79,10 @@ ENTRY(atomic64_\func\()_return_cx8)
>  10:
>         movl %ebx, %eax
>         movl %ecx, %edx
> -       RESTORE edi
> -       RESTORE esi
> -       RESTORE ebx
> -       RESTORE ebp
> +       popl_cfi_reg edi
> +       popl_cfi_reg esi
> +       popl_cfi_reg ebx
> +       popl_cfi_reg ebp
>         ret
>         CFI_ENDPROC
>  ENDPROC(atomic64_\func\()_return_cx8)
> @@ -104,7 +94,7 @@ addsub_return sub sub sbb
>  .macro incdec_return func ins insc
>  ENTRY(atomic64_\func\()_return_cx8)
>         CFI_STARTPROC
> -       SAVE ebx
> +       pushl_cfi_reg ebx
>
>         read64 %esi
>  1:
> @@ -119,7 +109,7 @@ ENTRY(atomic64_\func\()_return_cx8)
>  10:
>         movl %ebx, %eax
>         movl %ecx, %edx
> -       RESTORE ebx
> +       popl_cfi_reg ebx
>         ret
>         CFI_ENDPROC
>  ENDPROC(atomic64_\func\()_return_cx8)
> @@ -130,7 +120,7 @@ incdec_return dec sub sbb
>
>  ENTRY(atomic64_dec_if_positive_cx8)
>         CFI_STARTPROC
> -       SAVE ebx
> +       pushl_cfi_reg ebx
>
>         read64 %esi
>  1:
> @@ -146,18 +136,18 @@ ENTRY(atomic64_dec_if_positive_cx8)
>  2:
>         movl %ebx, %eax
>         movl %ecx, %edx
> -       RESTORE ebx
> +       popl_cfi_reg ebx
>         ret
>         CFI_ENDPROC
>  ENDPROC(atomic64_dec_if_positive_cx8)
>
>  ENTRY(atomic64_add_unless_cx8)
>         CFI_STARTPROC
> -       SAVE ebp
> -       SAVE ebx
> +       pushl_cfi_reg ebp
> +       pushl_cfi_reg ebx
>  /* these just push these two parameters on the stack */
> -       SAVE edi
> -       SAVE ecx
> +       pushl_cfi_reg edi
> +       pushl_cfi_reg ecx
>
>         movl %eax, %ebp
>         movl %edx, %edi
> @@ -179,8 +169,8 @@ ENTRY(atomic64_add_unless_cx8)
>  3:
>         addl $8, %esp
>         CFI_ADJUST_CFA_OFFSET -8
> -       RESTORE ebx
> -       RESTORE ebp
> +       popl_cfi_reg ebx
> +       popl_cfi_reg ebp
>         ret
>  4:
>         cmpl %edx, 4(%esp)
> @@ -192,7 +182,7 @@ ENDPROC(atomic64_add_unless_cx8)
>
>  ENTRY(atomic64_inc_not_zero_cx8)
>         CFI_STARTPROC
> -       SAVE ebx
> +       pushl_cfi_reg ebx
>
>         read64 %esi
>  1:
> @@ -209,7 +199,7 @@ ENTRY(atomic64_inc_not_zero_cx8)
>
>         movl $1, %eax
>  3:
> -       RESTORE ebx
> +       popl_cfi_reg ebx
>         ret
>         CFI_ENDPROC
>  ENDPROC(atomic64_inc_not_zero_cx8)
> diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
> index e78b8ee..c3b9953 100644
> --- a/arch/x86/lib/checksum_32.S
> +++ b/arch/x86/lib/checksum_32.S
> @@ -51,10 +51,8 @@ unsigned int csum_partial(const unsigned char * buff, int len, unsigned int sum)
>            */
>  ENTRY(csum_partial)
>         CFI_STARTPROC
> -       pushl_cfi %esi
> -       CFI_REL_OFFSET esi, 0
> -       pushl_cfi %ebx
> -       CFI_REL_OFFSET ebx, 0
> +       pushl_cfi_reg esi
> +       pushl_cfi_reg ebx
>         movl 20(%esp),%eax      # Function arg: unsigned int sum
>         movl 16(%esp),%ecx      # Function arg: int len
>         movl 12(%esp),%esi      # Function arg: unsigned char *buff
> @@ -131,10 +129,8 @@ ENTRY(csum_partial)
>         jz 8f
>         roll $8, %eax
>  8:
> -       popl_cfi %ebx
> -       CFI_RESTORE ebx
> -       popl_cfi %esi
> -       CFI_RESTORE esi
> +       popl_cfi_reg ebx
> +       popl_cfi_reg esi
>         ret
>         CFI_ENDPROC
>  ENDPROC(csum_partial)
> @@ -145,10 +141,8 @@ ENDPROC(csum_partial)
>
>  ENTRY(csum_partial)
>         CFI_STARTPROC
> -       pushl_cfi %esi
> -       CFI_REL_OFFSET esi, 0
> -       pushl_cfi %ebx
> -       CFI_REL_OFFSET ebx, 0
> +       pushl_cfi_reg esi
> +       pushl_cfi_reg ebx
>         movl 20(%esp),%eax      # Function arg: unsigned int sum
>         movl 16(%esp),%ecx      # Function arg: int len
>         movl 12(%esp),%esi      # Function arg: const unsigned char *buf
> @@ -255,10 +249,8 @@ ENTRY(csum_partial)
>         jz 90f
>         roll $8, %eax
>  90:
> -       popl_cfi %ebx
> -       CFI_RESTORE ebx
> -       popl_cfi %esi
> -       CFI_RESTORE esi
> +       popl_cfi_reg ebx
> +       popl_cfi_reg esi
>         ret
>         CFI_ENDPROC
>  ENDPROC(csum_partial)
> @@ -298,12 +290,9 @@ ENTRY(csum_partial_copy_generic)
>         CFI_STARTPROC
>         subl  $4,%esp
>         CFI_ADJUST_CFA_OFFSET 4
> -       pushl_cfi %edi
> -       CFI_REL_OFFSET edi, 0
> -       pushl_cfi %esi
> -       CFI_REL_OFFSET esi, 0
> -       pushl_cfi %ebx
> -       CFI_REL_OFFSET ebx, 0
> +       pushl_cfi_reg edi
> +       pushl_cfi_reg esi
> +       pushl_cfi_reg ebx
>         movl ARGBASE+16(%esp),%eax      # sum
>         movl ARGBASE+12(%esp),%ecx      # len
>         movl ARGBASE+4(%esp),%esi       # src
> @@ -412,12 +401,9 @@ DST(       movb %cl, (%edi)        )
>
>  .previous
>
> -       popl_cfi %ebx
> -       CFI_RESTORE ebx
> -       popl_cfi %esi
> -       CFI_RESTORE esi
> -       popl_cfi %edi
> -       CFI_RESTORE edi
> +       popl_cfi_reg ebx
> +       popl_cfi_reg esi
> +       popl_cfi_reg edi
>         popl_cfi %ecx                   # equivalent to addl $4,%esp
>         ret
>         CFI_ENDPROC
> @@ -441,12 +427,9 @@ ENDPROC(csum_partial_copy_generic)
>
>  ENTRY(csum_partial_copy_generic)
>         CFI_STARTPROC
> -       pushl_cfi %ebx
> -       CFI_REL_OFFSET ebx, 0
> -       pushl_cfi %edi
> -       CFI_REL_OFFSET edi, 0
> -       pushl_cfi %esi
> -       CFI_REL_OFFSET esi, 0
> +       pushl_cfi_reg ebx
> +       pushl_cfi_reg edi
> +       pushl_cfi_reg esi
>         movl ARGBASE+4(%esp),%esi       #src
>         movl ARGBASE+8(%esp),%edi       #dst
>         movl ARGBASE+12(%esp),%ecx      #len
> @@ -506,12 +489,9 @@ DST(       movb %dl, (%edi)         )
>         jmp  7b
>  .previous
>
> -       popl_cfi %esi
> -       CFI_RESTORE esi
> -       popl_cfi %edi
> -       CFI_RESTORE edi
> -       popl_cfi %ebx
> -       CFI_RESTORE ebx
> +       popl_cfi_reg esi
> +       popl_cfi_reg edi
> +       popl_cfi_reg ebx
>         ret
>         CFI_ENDPROC
>  ENDPROC(csum_partial_copy_generic)
> diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
> index f6d13ee..3ca5218 100644
> --- a/arch/x86/lib/msr-reg.S
> +++ b/arch/x86/lib/msr-reg.S
> @@ -14,8 +14,8 @@
>  .macro op_safe_regs op
>  ENTRY(\op\()_safe_regs)
>         CFI_STARTPROC
> -       pushq_cfi %rbx
> -       pushq_cfi %rbp
> +       pushq_cfi_reg rbx
> +       pushq_cfi_reg rbp
>         movq    %rdi, %r10      /* Save pointer */
>         xorl    %r11d, %r11d    /* Return value */
>         movl    (%rdi), %eax
> @@ -35,8 +35,8 @@ ENTRY(\op\()_safe_regs)
>         movl    %ebp, 20(%r10)
>         movl    %esi, 24(%r10)
>         movl    %edi, 28(%r10)
> -       popq_cfi %rbp
> -       popq_cfi %rbx
> +       popq_cfi_reg rbp
> +       popq_cfi_reg rbx
>         ret
>  3:
>         CFI_RESTORE_STATE
> @@ -53,10 +53,10 @@ ENDPROC(\op\()_safe_regs)
>  .macro op_safe_regs op
>  ENTRY(\op\()_safe_regs)
>         CFI_STARTPROC
> -       pushl_cfi %ebx
> -       pushl_cfi %ebp
> -       pushl_cfi %esi
> -       pushl_cfi %edi
> +       pushl_cfi_reg ebx
> +       pushl_cfi_reg ebp
> +       pushl_cfi_reg esi
> +       pushl_cfi_reg edi
>         pushl_cfi $0              /* Return value */
>         pushl_cfi %eax
>         movl    4(%eax), %ecx
> @@ -80,10 +80,10 @@ ENTRY(\op\()_safe_regs)
>         movl    %esi, 24(%eax)
>         movl    %edi, 28(%eax)
>         popl_cfi %eax
> -       popl_cfi %edi
> -       popl_cfi %esi
> -       popl_cfi %ebp
> -       popl_cfi %ebx
> +       popl_cfi_reg edi
> +       popl_cfi_reg esi
> +       popl_cfi_reg ebp
> +       popl_cfi_reg ebx
>         ret
>  3:
>         CFI_RESTORE_STATE
> diff --git a/arch/x86/lib/rwsem.S b/arch/x86/lib/rwsem.S
> index 5dff5f0..2322abe 100644
> --- a/arch/x86/lib/rwsem.S
> +++ b/arch/x86/lib/rwsem.S
> @@ -34,10 +34,10 @@
>   */
>
>  #define save_common_regs \
> -       pushl_cfi %ecx; CFI_REL_OFFSET ecx, 0
> +       pushl_cfi_reg ecx
>
>  #define restore_common_regs \
> -       popl_cfi %ecx; CFI_RESTORE ecx
> +       popl_cfi_reg ecx
>
>         /* Avoid uglifying the argument copying x86-64 needs to do. */
>         .macro movq src, dst
> @@ -64,22 +64,22 @@
>   */
>
>  #define save_common_regs \
> -       pushq_cfi %rdi; CFI_REL_OFFSET rdi, 0; \
> -       pushq_cfi %rsi; CFI_REL_OFFSET rsi, 0; \
> -       pushq_cfi %rcx; CFI_REL_OFFSET rcx, 0; \
> -       pushq_cfi %r8;  CFI_REL_OFFSET r8,  0; \
> -       pushq_cfi %r9;  CFI_REL_OFFSET r9,  0; \
> -       pushq_cfi %r10; CFI_REL_OFFSET r10, 0; \
> -       pushq_cfi %r11; CFI_REL_OFFSET r11, 0
> +       pushq_cfi_reg rdi; \
> +       pushq_cfi_reg rsi; \
> +       pushq_cfi_reg rcx; \
> +       pushq_cfi_reg r8;  \
> +       pushq_cfi_reg r9;  \
> +       pushq_cfi_reg r10; \
> +       pushq_cfi_reg r11
>
>  #define restore_common_regs \
> -       popq_cfi %r11; CFI_RESTORE r11; \
> -       popq_cfi %r10; CFI_RESTORE r10; \
> -       popq_cfi %r9;  CFI_RESTORE r9; \
> -       popq_cfi %r8;  CFI_RESTORE r8; \
> -       popq_cfi %rcx; CFI_RESTORE rcx; \
> -       popq_cfi %rsi; CFI_RESTORE rsi; \
> -       popq_cfi %rdi; CFI_RESTORE rdi
> +       popq_cfi_reg r11; \
> +       popq_cfi_reg r10; \
> +       popq_cfi_reg r9; \
> +       popq_cfi_reg r8; \
> +       popq_cfi_reg rcx; \
> +       popq_cfi_reg rsi; \
> +       popq_cfi_reg rdi
>
>  #endif
>
> @@ -87,12 +87,10 @@
>  ENTRY(call_rwsem_down_read_failed)
>         CFI_STARTPROC
>         save_common_regs
> -       __ASM_SIZE(push,_cfi) %__ASM_REG(dx)
> -       CFI_REL_OFFSET __ASM_REG(dx), 0
> +       __ASM_SIZE(push,_cfi_reg) __ASM_REG(dx)
>         movq %rax,%rdi
>         call rwsem_down_read_failed
> -       __ASM_SIZE(pop,_cfi) %__ASM_REG(dx)
> -       CFI_RESTORE __ASM_REG(dx)
> +       __ASM_SIZE(pop,_cfi_reg) __ASM_REG(dx)
>         restore_common_regs
>         ret
>         CFI_ENDPROC
> @@ -124,12 +122,10 @@ ENDPROC(call_rwsem_wake)
>  ENTRY(call_rwsem_downgrade_wake)
>         CFI_STARTPROC
>         save_common_regs
> -       __ASM_SIZE(push,_cfi) %__ASM_REG(dx)
> -       CFI_REL_OFFSET __ASM_REG(dx), 0
> +       __ASM_SIZE(push,_cfi_reg) __ASM_REG(dx)
>         movq %rax,%rdi
>         call rwsem_downgrade_wake
> -       __ASM_SIZE(pop,_cfi) %__ASM_REG(dx)
> -       CFI_RESTORE __ASM_REG(dx)
> +       __ASM_SIZE(pop,_cfi_reg) __ASM_REG(dx)
>         restore_common_regs
>         ret
>         CFI_ENDPROC
> diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
> index e28cdaf..5eb7150 100644
> --- a/arch/x86/lib/thunk_32.S
> +++ b/arch/x86/lib/thunk_32.S
> @@ -13,12 +13,9 @@
>         .globl \name
>  \name:
>         CFI_STARTPROC
> -       pushl_cfi %eax
> -       CFI_REL_OFFSET eax, 0
> -       pushl_cfi %ecx
> -       CFI_REL_OFFSET ecx, 0
> -       pushl_cfi %edx
> -       CFI_REL_OFFSET edx, 0
> +       pushl_cfi_reg eax
> +       pushl_cfi_reg ecx
> +       pushl_cfi_reg edx
>
>         .if \put_ret_addr_in_eax
>         /* Place EIP in the arg1 */
> @@ -26,12 +23,9 @@
>         .endif
>
>         call \func
> -       popl_cfi %edx
> -       CFI_RESTORE edx
> -       popl_cfi %ecx
> -       CFI_RESTORE ecx
> -       popl_cfi %eax
> -       CFI_RESTORE eax
> +       popl_cfi_reg edx
> +       popl_cfi_reg ecx
> +       popl_cfi_reg eax
>         ret
>         CFI_ENDPROC
>         _ASM_NOKPROBE(\name)
> diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
> index 8ec443a..f89ba4e9 100644
> --- a/arch/x86/lib/thunk_64.S
> +++ b/arch/x86/lib/thunk_64.S
> @@ -17,24 +17,15 @@
>         CFI_STARTPROC
>
>         /* this one pushes 9 elems, the next one would be %rIP */
> -       pushq_cfi %rdi
> -       CFI_REL_OFFSET rdi, 0
> -       pushq_cfi %rsi
> -       CFI_REL_OFFSET rsi, 0
> -       pushq_cfi %rdx
> -       CFI_REL_OFFSET rdx, 0
> -       pushq_cfi %rcx
> -       CFI_REL_OFFSET rcx, 0
> -       pushq_cfi %rax
> -       CFI_REL_OFFSET rax, 0
> -       pushq_cfi %r8
> -       CFI_REL_OFFSET r8, 0
> -       pushq_cfi %r9
> -       CFI_REL_OFFSET r9, 0
> -       pushq_cfi %r10
> -       CFI_REL_OFFSET r10, 0
> -       pushq_cfi %r11
> -       CFI_REL_OFFSET r11, 0
> +       pushq_cfi_reg rdi
> +       pushq_cfi_reg rsi
> +       pushq_cfi_reg rdx
> +       pushq_cfi_reg rcx
> +       pushq_cfi_reg rax
> +       pushq_cfi_reg r8
> +       pushq_cfi_reg r9
> +       pushq_cfi_reg r10
> +       pushq_cfi_reg r11
>
>         .if \put_ret_addr_in_rdi
>         /* 9*8(%rsp) is return addr on stack */
> @@ -69,24 +60,15 @@
>         CFI_STARTPROC
>         CFI_ADJUST_CFA_OFFSET 9*8
>  restore:
> -       popq_cfi %r11
> -       CFI_RESTORE r11
> -       popq_cfi %r10
> -       CFI_RESTORE r10
> -       popq_cfi %r9
> -       CFI_RESTORE r9
> -       popq_cfi %r8
> -       CFI_RESTORE r8
> -       popq_cfi %rax
> -       CFI_RESTORE rax
> -       popq_cfi %rcx
> -       CFI_RESTORE rcx
> -       popq_cfi %rdx
> -       CFI_RESTORE rdx
> -       popq_cfi %rsi
> -       CFI_RESTORE rsi
> -       popq_cfi %rdi
> -       CFI_RESTORE rdi
> +       popq_cfi_reg r11
> +       popq_cfi_reg r10
> +       popq_cfi_reg r9
> +       popq_cfi_reg r8
> +       popq_cfi_reg rax
> +       popq_cfi_reg rcx
> +       popq_cfi_reg rdx
> +       popq_cfi_reg rsi
> +       popq_cfi_reg rdi
>         ret
>         CFI_ENDPROC
>         _ASM_NOKPROBE(restore)
> --
> 1.8.1.4
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
