Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaGKRKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:10:00 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:15836 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753507AbaGKRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:09:59 -0400
Date: Fri, 11 Jul 2014 18:09:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Fix preemption disable in iwmmxt_task_enable()
Message-ID: <20140711170935.GG16321@arm.com>
References: <20140706080845.723e9787@armhf>
 <1405069813-9270-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405069813-9270-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 10:10:13AM +0100, Sebastian Hesselbarth wrote:
> commit 431a84b1a4f7d1a0085d5b91330c5053cc8e8b12
>  ("ARM: 8034/1: Disable preemption in iwmmxt_task_enable()")
> introduced macros {inc,dec}_preempt_count to iwmmxt_task_enable
> to make it run with preemption disabled.
> 
> Unfortunately, other functions in iwmmxt.S also use concan_{save,dump,load}
> sections located in iwmmxt_task_enable() to deal with iWMMXt coprocessor.
> This causes an unbalanced preempt_count due to excessive dec_preempt_count
> and destroyed return addresses in callers of concan_ labels due to a register
> collision:

Indeed, I missed this part completely.

> --- a/arch/arm/kernel/iwmmxt.S
> +++ b/arch/arm/kernel/iwmmxt.S
> @@ -94,13 +94,19 @@ ENTRY(iwmmxt_task_enable)
>  
>  	mrc	p15, 0, r2, c2, c0, 0
>  	mov	r2, r2				@ cpwait
> +	bl	concan_save
>  
> -	teq	r1, #0				@ test for last ownership
> -	mov	lr, r9				@ normal exit from exception
> -	beq	concan_load			@ no owner, skip save
> +#ifdef CONFIG_PREEMPT_COUNT
> +	get_thread_info r10
> +#endif
> +4:	dec_preempt_count r10, r3
> +	mov	pc, r9				@ normal exit from exception
>  
>  concan_save:
>  
> +	teq	r1, #0				@ test for last ownership
> +	beq	concan_load			@ no owner, skip save
> +
>  	tmrc	r2, wCon
>  
>  	@ CUP? wCx
> @@ -175,10 +181,6 @@ concan_load:
>  	tmcr	wCon, r2
>  
>  3:
> -#ifdef CONFIG_PREEMPT_COUNT
> -	get_thread_info r10
> -#endif
> -4:	dec_preempt_count r10, r3
>  	mov	pc, lr

It looks fine to me. One optimisation you could do is to replace a
couple of beq 3f with moveq pc, lr.

-- 
Catalin
