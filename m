Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaCFKvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:51:21 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:57299 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750829AbaCFKvT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:51:19 -0500
Date: Thu, 6 Mar 2014 05:51:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Fernando Luis =?UTF-8?B?VsOhenF1ZXo=?= Cao 
	<fernando_b1@lab.ntt.co.jp>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/clock: prevent tracing recursion in
 sched_clock_cpu()
Message-ID: <20140306055113.2306397d@gandalf.local.home>
In-Reply-To: <1394083528.4524.3.camel@nexus>
References: <1394083528.4524.3.camel@nexus>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2014 14:25:28 +0900
Fernando Luis Vázquez Cao <fernando_b1@lab.ntt.co.jp> wrote:

> From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> 
> Prevent tracing of preempt_disable/enable() in sched_clock_cpu().
> When CONFIG_DEBUG_PREEMPT is enabled, preempt_disable/enable() are
> traced and this causes trace_clock() users (and probably others) to
> go into an infinite recursion. Systems with a stable sched_clock()
> are not affected.
> 
> This problem is similar to that fixed by upstream commit 95ef1e52922
> ("KVM guest: prevent tracing recursion with kvmclock").

Also similar to: 569d6557ab957.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-3.14-rc5-orig/kernel/sched/clock.c linux-3.14-rc5/kernel/sched/clock.c
> --- linux-3.14-rc5-orig/kernel/sched/clock.c	2014-03-06 13:37:43.567720550 +0900
> +++ linux-3.14-rc5/kernel/sched/clock.c	2014-03-06 13:41:56.937100949 +0900
> @@ -301,14 +301,14 @@ u64 sched_clock_cpu(int cpu)
>  	if (unlikely(!sched_clock_running))
>  		return 0ull;
>  
> -	preempt_disable();
> +	preempt_disable_notrace();
>  	scd = cpu_sdc(cpu);
>  
>  	if (cpu != smp_processor_id())
>  		clock = sched_clock_remote(scd);
>  	else
>  		clock = sched_clock_local(scd);
> -	preempt_enable();
> +	preempt_enable_notrace();
>  
>  	return clock;
>  }
> 

