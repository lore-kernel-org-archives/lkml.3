Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763097Ab3DCSjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763060Ab3DCSjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:39:11 -0400
Message-ID: <515C7720.2020503@redhat.com>
Date: Wed, 03 Apr 2013 11:38:24 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sourceware.org>
Subject: Re: systemtap broken by removal of register_timer_hook
References: <20130403075017.GA2534@suse.de> <CAFTL4hyYezB2ZxM-GJ70VoxOeRSG64V6u+nX2hTuhF30R-GdPg__32168.962484184$1364986928$gmane$org@mail.gmail.com> <y0mvc83u79f.fsf@fche.csb> <CAFTL4hxx_GHoa4uguSAtY0A=cC43qJPKvpqaoguS-WAjFj+HSw@mail.gmail.com> <20130403144428.GA15432@redhat.com>
In-Reply-To: <20130403144428.GA15432@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 07:44 AM, Frank Ch. Eigler wrote:
> Hi -
> 
> On Wed, Apr 03, 2013 at 02:49:53PM +0200, Frederic Weisbecker wrote:
> 
>> Sounds good, would you like to propose a version? We are also
>> interested in a timer tick event tracepoint for dynticks debugging.
> 
> How about this?
> 
> Author: Frank Ch. Eigler <fche@redhat.com>
> Date:   Wed Apr 3 10:35:21 2013 -0400
> 
>     profiling: add profile_tick tracepoint
>     
>     Commit ba6fdda4 removed the timer_hook mechanism for modules to listen
>     to profiling timer ticks (without having to set up more complicated
>     perf mechanisms).  To reduce the impact on out-of-tree users, a
>     TRACE_EVENT-flavoured tracepoint is added in its place.  Tested with
>     perf and systemtap.

One nice benefit over register_timer_hook() is that a tracepoint allows
multiple consumers, like the old register_profile_notifier() did.

>     
>     Cc: Frederic Weisbecker <fweisbec@gmail.com>
>     Cc: Ingo Molnar <mingo@kernel.org>
>     Cc: Mel Gorman <mgorman@suse.de>
>     Signed-off-by: Frank Ch. Eigler <fche@redhat.com>
> 
> diff --git a/include/trace/events/profile.h b/include/trace/events/profile.h
> new file mode 100644
> index 0000000..b48b6fe
> --- /dev/null
> +++ b/include/trace/events/profile.h
> @@ -0,0 +1,35 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM profile
> +
> +#if !defined(_TRACE_PROFILE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_PROFILE_H
> +
> +#include <linux/tracepoint.h>
> +
> +
> +struct pt_regs;
> +
> +/**
> + * profile_tick - called when the profiling timer ticks
> + * @regs:	pointer to struct pt_regs*
> + */
> +
> +TRACE_EVENT(profile_tick,
> +	TP_PROTO(int type, struct pt_regs *regs),
> +	TP_ARGS(type, regs),
> +	TP_STRUCT__entry(
> +		__field( int,			type	)
> +		__field( struct pt_regs*,	regs	)
> +	),
> +	TP_fast_assign(
> +		__entry->type	= type;
> +		__entry->regs	= regs;
> +	),
> +	TP_printk("type=%d regs=%p", __entry->type, __entry->regs)
> +);

I agree that full regs are good for the tracepoint in general, but I
doubt that this pointer is useful for the printk.  Maybe instead print
instruction_pointer(__entry->regs)?

> +
> +
> +#endif /*  _TRACE_PROFILE_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/kernel/profile.c b/kernel/profile.c
> index dc3384e..d61f921 100644
> --- a/kernel/profile.c
> +++ b/kernel/profile.c
> @@ -29,6 +29,9 @@
>  #include <asm/irq_regs.h>
>  #include <asm/ptrace.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/profile.h>
> +
>  struct profile_hit {
>  	u32 pc, hits;
>  };
> @@ -414,6 +417,8 @@ void profile_tick(int type)
>  {
>  	struct pt_regs *regs = get_irq_regs();
>  
> +	trace_profile_tick(type, regs);
> +
>  	if (!user_mode(regs) && prof_cpu_mask != NULL &&
>  	    cpumask_test_cpu(smp_processor_id(), prof_cpu_mask))
>  		profile_hit(type, (void *)profile_pc(regs));
> 

