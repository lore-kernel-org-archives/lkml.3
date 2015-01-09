Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbbAIKzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:55:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50330 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867AbbAIKzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:55:45 -0500
Date: Fri, 9 Jan 2015 11:55:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
Message-ID: <20150109105541.GC13637@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 05:25:14PM +0100, Denys Vlasenko wrote:
> This is a preparatory patch for change in "struct pt_regs"
> handling in entry_64.S.
> 
> trace_hardirqs thunks were (ab)using a part of pt_regs
> handling code, namely SAVE_ARGS/RESTORE_ARGS macros,
> to save/restore registers across C function calls.
> 
> Since SAVE_ARGS is going to be changed, open-code
> register saving/restoring here.
> 
> Incidentally, this removes a bit of dead code:
> one SAVE_ARGS was used just to emit a CFI annotation,
> but it also generated unreachable assembly insns.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
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
>  arch/x86/lib/thunk_64.S | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
> index b30b5eb..03a3883 100644
> --- a/arch/x86/lib/thunk_64.S
> +++ b/arch/x86/lib/thunk_64.S
> @@ -16,10 +16,20 @@
>  \name:
>  	CFI_STARTPROC
>  
> -	/* this one pushes 9 elems, the next one would be %rIP */
> -	SAVE_ARGS
> +	subq  $9*8, %rsp
> +	CFI_ADJUST_CFA_OFFSET 9*8
> +	movq_cfi r11, 0*8
> +	movq_cfi r10, 1*8
> +	movq_cfi r9,  2*8
> +	movq_cfi r8,  3*8
> +	movq_cfi rax, 4*8
> +	movq_cfi rcx, 5*8
> +	movq_cfi rdx, 6*8
> +	movq_cfi rsi, 7*8
> +	movq_cfi rdi, 8*8
>  
>  	.if \put_ret_addr_in_rdi
> +	/* 9*8(%rsp) is return addr on stack */
>  	movq_cfi_restore 9*8, rdi
>  	.endif
>  
> @@ -45,11 +55,20 @@
>  #endif
>  #endif
>  
> -	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
>  	CFI_STARTPROC
> -	SAVE_ARGS
> +	CFI_ADJUST_CFA_OFFSET 9*8
>  restore:
> -	RESTORE_ARGS
> +	movq_cfi_restore 0*8, r11
> +	movq_cfi_restore 1*8, r10
> +	movq_cfi_restore 2*8, r9
> +	movq_cfi_restore 3*8, r8
> +	movq_cfi_restore 4*8, rax
> +	movq_cfi_restore 5*8, rcx
> +	movq_cfi_restore 6*8, rdx
> +	movq_cfi_restore 7*8, rsi
> +	movq_cfi_restore 8*8, rdi
> +	addq 9*8, %rsp
> +	CFI_ADJUST_CFA_OFFSET -9*8

The only nitpick I'd have with this is can we keep the register
saving/restoring order in the code the same as in the SAVE_/RESTORE_ARGS
macros?

SAVE_ARGS starts with the highest offset 9*8, rdi and ends at 0*8 and
r11 and RESTORE_ARGS does that in reverse.

Also, can you post the struct pt_regs change too so that we know where
this is going?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
