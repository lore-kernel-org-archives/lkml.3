Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaCXTbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:31:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:37813 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753790AbaCXTbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:31:32 -0400
Date: Mon, 24 Mar 2014 15:31:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 09/26] x86: Call exception_enter after kprobes
 handled
Message-ID: <20140324153129.4149f316@gandalf.local.home>
In-Reply-To: <20140305115946.22766.73261.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115946.22766.73261.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

This one's for you.

Looks good as the exception_enter() is to catch when userspace causes
the exception which wouldn't be the case for kprobes. When kprobes
needs to do work, it would have already been in the kernel and the
NO_HZ_FULL and RCU should be aware of that.

But for me:

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


On Wed, 05 Mar 2014 20:59:46 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Move exception_enter() call after kprobes handler
> is done. Since the exception_enter() involves
> many other functions (like printk), it can cause
> recursive int3/break loop when kprobes probe such
> functions.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  arch/x86/kernel/traps.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index e5d4a70..ba9abe9 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -327,7 +327,6 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>  	if (poke_int3_handler(regs))
>  		return;
>  
> -	prev_state = exception_enter();
>  #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
>  	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
>  				SIGTRAP) == NOTIFY_STOP)
> @@ -338,6 +337,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>  	if (kprobe_int3_handler(regs))
>  		return;
>  #endif
> +	prev_state = exception_enter();
>  
>  	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
>  			SIGTRAP) == NOTIFY_STOP)
> @@ -415,8 +415,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  	unsigned long dr6;
>  	int si_code;
>  
> -	prev_state = exception_enter();
> -
>  	get_debugreg(dr6, 6);
>  
>  	/* Filter out all the reserved bits which are preset to 1 */
> @@ -449,6 +447,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  	if (kprobe_debug_handler(regs))
>  		goto exit;
>  #endif
> +	prev_state = exception_enter();
>  
>  	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
>  							SIGTRAP) == NOTIFY_STOP)
> 

