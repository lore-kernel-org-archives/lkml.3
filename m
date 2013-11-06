Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3KFQhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:37:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20760 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750739Ab3KFQhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:37:07 -0500
Date: Wed, 6 Nov 2013 11:37:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131106113704.41b6ed5c@gandalf.local.home>
In-Reply-To: <20130927152908.GE15690@laptop.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
	<20130927091427.GE24743@yliu-dev.sh.intel.com>
	<20130927152908.GE15690@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013 17:29:08 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri Sep 27 17:11:00 CEST 2013
> 
> Since we now have two need_resched states; trace the two so we can
> observe discrepancies.

I see this is dependent on the addition of tif_need_resched() and
friends.

> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/trace/trace.c        |    3 ++-
>  kernel/trace/trace.h        |    1 +
>  kernel/trace/trace_output.c |   13 +++++++++++--
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1509,7 +1509,8 @@ tracing_generic_entry_update(struct trac
>  #endif
>  		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
>  		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
> -		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
> +		(tif_need_resched() ? TRACE_FLAG_NEED_RESCHED : 0) |
> +		(test_preempt_need_resched() ? TRACE_FLAG_PREEMPT_RESCHED : 0);
>  }
>  EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
>  
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -124,6 +124,7 @@ enum trace_flag_type {
>  	TRACE_FLAG_NEED_RESCHED		= 0x04,
>  	TRACE_FLAG_HARDIRQ		= 0x08,
>  	TRACE_FLAG_SOFTIRQ		= 0x10,
> +	TRACE_FLAG_PREEMPT_RESCHED	= 0x20,
>  };
>  
>  #define TRACE_BUF_SIZE		1024
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -618,8 +618,17 @@ int trace_print_lat_fmt(struct trace_seq
>  		(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
>  		(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' :
>  		'.';
> -	need_resched =
> -		(entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.';
> +
> +	if ((entry->flags & TRACE_FLAG_NEED_RESCHED) &&
> +	    (entry->flags & TRACE_FLAG_PREEMPT_RESCHED))
> +		need_resched = 'N';
> +	else if (entry->flags & TRACE_FLAG_NEED_RESCHED)
> +		need_resched = 'n';
> +	else if (entry->flags & TRACE_FLAG_PREEMPT_RESCHED)
> +		need_resched = 'p';
> +	else
> +		need_resched = '.';

Perhaps we should make this a switch statement?

	switch (entry->flags & (TRACE_FLAG_NEED_RESCHED |
				TRACE_FLAG_PREEMPT_RESCHED)) {
	case TRACE_FLAG_NEED_RESCHED | TRACE_FLAG_PREEMPT_RESCHED:
		need_resched = 'N';
		break;
	case TRACE_FLAG_NEED_RESCHED:
		need_resched = 'n';
		break;
	case TRACE_FLAG_PREEMPT_RESCHED:
		need_resched = 'p';
		break;
	default:
		need_resched = '.';
		break;
	}

Simply because I find switch statements easier to read than else if
statements.

-- Steve

> +
>  	hardsoft_irq =
>  		(hardirq && softirq) ? 'H' :
>  		hardirq ? 'h' :

