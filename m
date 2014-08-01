Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaHAWw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:52:27 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:44677 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaHAWwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:52:25 -0400
Date: Sat, 2 Aug 2014 00:52:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
 pt_regs"
Message-ID: <20140801225214.GA26491@localhost.localdomain>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:48:17PM +0200, Denys Vlasenko wrote:
> 64-bit code was using six stack slots fewer by not saving/restoring
> registers which a callee-preserved according to C ABI,
> and not allocating space for them.
> 
> Only when syscall needed a complete "struct pt_regs",
> the complete area was allocated and filled in.
> 
> This proved to be a source of significant obfuscation and subtle bugs.
> For example, stub_fork had to pop the return address,
> extend the struct, save registers, and push return address back. Ugly.
> ia32_ptregs_common pops return address and "returns" via jmp insn,
> throwing a wrench into CPU return stack cache.
> 
> This patch changes code to always allocate a complete "struct pt_regs".
> The saving of registers is still done lazily.
> 
> Macros which manipulate "struct pt_regs" on stack are reworked:
> ALLOC_PTREGS_ON_STACK allocates the structure.
> SAVE_C_REGS saves to it those registers which are clobbered by C code.
> SAVE_EXTRA_REGS saves to it all other registers.
> Corresponding RESTORE_* and REMOVE_PTREGS_FROM_STACK macros reverse it.
> 
> ia32_ptregs_common, stub_fork and friends lost their ugly dance with
> return pointer.
> 
> LOAD_ARGS32 in ia32entry.S now uses a symbolic stack offsets
> instead of magic numbers.
> 
> Misleading and slightly wrong comments in "struct pt_regs" are fixed
> (four instances).
> 
> Patch was run-tested: 64-bit executables, 32-bit executables,
> strace works.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: X86 ML <x86@kernel.org>
> CC: Alexei Starovoitov <ast@plumgrid.com>
> CC: Will Drewry <wad@chromium.org>
> CC: Kees Cook <keescook@chromium.org>
> CC: linux-kernel@vger.kernel.org
> ---
>  arch/x86/ia32/ia32entry.S              |  47 +++----
>  arch/x86/include/asm/calling.h         | 224 ++++++++++++++++-----------------
>  arch/x86/include/asm/irqflags.h        |   4 +-
>  arch/x86/include/asm/ptrace.h          |  13 +-
>  arch/x86/include/uapi/asm/ptrace-abi.h |  16 ++-
>  arch/x86/include/uapi/asm/ptrace.h     |  13 +-
>  arch/x86/kernel/entry_64.S             | 132 ++++++++-----------
>  arch/x86/kernel/preempt.S              |  16 ++-
>  8 files changed, 232 insertions(+), 233 deletions(-)
> 
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 4299eb0..ef9ee16 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -62,12 +62,12 @@
>  	 */
>  	.macro LOAD_ARGS32 offset, _r9=0
>  	.if \_r9
> -	movl \offset+16(%rsp),%r9d
> +	movl \offset+R9(%rsp),%r9d
>  	.endif
> -	movl \offset+40(%rsp),%ecx
> -	movl \offset+48(%rsp),%edx
> -	movl \offset+56(%rsp),%esi
> -	movl \offset+64(%rsp),%edi
> +	movl \offset+RCX(%rsp),%ecx
> +	movl \offset+RDX(%rsp),%edx
> +	movl \offset+RSI(%rsp),%esi
> +	movl \offset+RDI(%rsp),%edi
>  	movl %eax,%eax			/* zero extension */
>  	.endm
>  	
> @@ -144,7 +144,8 @@ ENTRY(ia32_sysenter_target)
>  	CFI_REL_OFFSET rip,0
>  	pushq_cfi %rax
>  	cld
> -	SAVE_ARGS 0,1,0
> +	ALLOC_PTREGS_ON_STACK
> +	SAVE_C_REGS_EXCEPT_R891011
>   	/* no need to do an access_ok check here because rbp has been
>   	   32bit zero extended */ 
>  	ASM_STAC
> @@ -172,7 +173,8 @@ sysexit_from_sys_call:
>  	andl  $~0x200,EFLAGS-R11(%rsp) 
>  	movl	RIP-R11(%rsp),%edx		/* User %eip */
>  	CFI_REGISTER rip,rdx
> -	RESTORE_ARGS 0,24,0,0,0,0
> +	RESTORE_RSI_RDI

I heard there will be a v2 so I'll probably wait for it to review this patch
which really requires 0db where I sit.

But the macro names like above look much clearer as well!
