Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbaEMGHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:07:47 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57416 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaEMGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:07:45 -0400
Message-ID: <5371B6AA.7060508@hitachi.com>
Date: Tue, 13 May 2014 15:07:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: can't we kill DIE_GPF ? (Was: x86/traps: cleanup DO_ERROR*()
 to prepare for uprobes fixes)
References: <20140508191140.GA16892@redhat.com> <20140509140723.GA22532@redhat.com>
In-Reply-To: <20140509140723.GA22532@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/09 23:07), Oleg Nesterov wrote:
> On 05/08, Oleg Nesterov wrote:
>>
>> For example, after this series
>> we can convert math_error() into the "normal" DO_ERROR() user, and most probably
>> we can do the same with do_general_protection().
> 
> As for do_general_protection(), the problem is DIE_GPF.
> 
> Masami, could you explain why it is needed ? kprobe_exceptions_notify()
> is the only user, can't it use DIE_TRAP and check trapnr = X86_TRAP_GP ?

Actually, this may be only for something which will happen on
single-stepping out-of-line. And yes, I can move it onto the DIE_TRAP :)

> 
> And if it can, probably we can do notify_die() at the start like other
> DO_ERROR() functions do ?

Agreed, it seems OK to me. (and seems better, since we can handle GPF
before changing task->thread struct)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks a lot!

> 
> IOW, any reason why the patch below is wrong?
> 
> Oleg.
> 
> --- x/arch/x86/include/asm/kdebug.h
> +++ x/arch/x86/include/asm/kdebug.h
> @@ -15,7 +15,6 @@ enum die_val {
>  	DIE_DIE,
>  	DIE_KERNELDEBUG,
>  	DIE_TRAP,
> -	DIE_GPF,
>  	DIE_CALL,
>  	DIE_PAGE_FAULT,
>  	DIE_NMIUNKNOWN,
> --- x/arch/x86/kernel/traps.c
> +++ x/arch/x86/kernel/traps.c
> @@ -283,6 +283,9 @@ do_general_protection(struct pt_regs *re
>  	enum ctx_state prev_state;
>  
>  	prev_state = exception_enter();
> +	if (notify_die(DIE_TRAP, "general protection fault", regs, error_code,
> +			X86_TRAP_GP, SIGSEGV) == NOTIFY_STOP)
> +		goto exit;
>  	conditional_sti(regs);
>  
>  #ifdef CONFIG_X86_32
> @@ -300,10 +303,7 @@ do_general_protection(struct pt_regs *re
>  
>  		tsk->thread.error_code = error_code;
>  		tsk->thread.trap_nr = X86_TRAP_GP;
> -		if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
> -			       X86_TRAP_GP, SIGSEGV) != NOTIFY_STOP)
> -			die("general protection fault", regs, error_code);
> -		goto exit;
> +		die("general protection fault", regs, error_code);
>  	}
>  
>  	tsk->thread.error_code = error_code;
> --- x/arch/x86/kernel/kprobes/core.c
> +++ x/arch/x86/kernel/kprobes/core.c
> @@ -979,13 +979,14 @@ kprobe_exceptions_notify(struct notifier
>  			ret = NOTIFY_STOP;
>  		}
>  		break;
> -	case DIE_GPF:
> +	case DIE_TRAP:
>  		/*
>  		 * To be potentially processing a kprobe fault and to
>  		 * trust the result from kprobe_running(), we have
>  		 * be non-preemptible.
>  		 */
> -		if (!preemptible() && kprobe_running() &&
> +		if (args->trapnr == X86_TRAP_GP &&
> +		    !preemptible() && kprobe_running() &&
>  		    kprobe_fault_handler(args->regs, args->trapnr))
>  			ret = NOTIFY_STOP;
>  		break;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


