Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbaKZNCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:02:52 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39721 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKZNCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:02:51 -0500
Date: Wed, 26 Nov 2014 13:02:52 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 2/6] arm64: ptrace: allow tracer to skip a system call
Message-ID: <20141126130252.GI14866@arm.com>
References: <1416977391-24231-1-git-send-email-takahiro.akashi@linaro.org>
 <1416977391-24231-3-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416977391-24231-3-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 04:49:47AM +0000, AKASHI Takahiro wrote:
> If tracer modifies a syscall number to -1, this traced system call should
> be skipped with a return value specified in x0.
> This patch implements this semantics.
> 
> Please note:
> * syscall entry tracing and syscall exit tracing (ftrace tracepoint and
>   audit) are always executed, if enabled, even when skipping a system call
>   (that is, -1).
>   In this way, we can avoid a potential bug where audit_syscall_entry()
>   might be called without audit_syscall_exit() at the previous system call
>   being called, that would cause OOPs in audit_syscall_entry().
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/kernel/entry.S |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 726b910..946ec52 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -161,6 +161,7 @@
>   */
>  sc_nr	.req	x25		// number of system calls
>  scno	.req	x26		// syscall number
> +scno_w	.req	w26		// syscall number (lower 32 bits)
>  stbl	.req	x27		// syscall table pointer
>  tsk	.req	x28		// current thread_info
>  
> @@ -668,8 +669,14 @@ ENDPROC(el0_svc)
>  	 * switches, and waiting for our parent to respond.
>  	 */
>  __sys_trace:
> -	mov	x0, sp
> +	cmp     scno_w, #-1			// set default errno for

I hate that we have to use scno_w, but the only alternative I can think of
is using w8 directly, which isn't any better and doesn't work for compat.
Ho-hum, I guess we'll stick with what you have.

> +	b.ne	1f				// user-issued syscall(-1)
> +	mov	x0, #-ENOSYS
> +	str	x0, [sp]

Can you use #S_X0 here for clarity, please?

> +1:	mov	x0, sp
>  	bl	syscall_trace_enter
> +	cmp	w0, #-1				// skip the syscall?
> +	b.eq	__sys_trace_return_skipped
>  	adr	lr, __sys_trace_return		// return address
>  	uxtw	scno, w0			// syscall number (possibly new)
>  	mov	x1, sp				// pointer to regs
> @@ -684,6 +691,7 @@ __sys_trace:
>  
>  __sys_trace_return:
>  	str	x0, [sp]			// save returned x0

and update this guy too.

Will
