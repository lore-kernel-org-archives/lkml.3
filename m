Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376Ab3CZNpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:45:03 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63888 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3CZNpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:45:00 -0400
Message-ID: <5151A658.5040702@gmail.com>
Date: Tue, 26 Mar 2013 07:44:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] timekeeping: Add tracepoints for xtime changes - v2
References: <1363710477-4203-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1363710477-4203-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping... any comments or opinions on the tracepoints?

On 3/19/13 10:27 AM, David Ahern wrote:
> One component of tracking perf_clock timestamps to time-of-day is
> updates to xtime by a user or ntpd. To that end this patch adds
> tracepoints to the timekeeping code as suggested by Thomas:
> https://lkml.org/lkml/2011/3/2/186
>
> v2: use timekeeping_get_ns to retrieve nsec component
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>   include/trace/events/timekeeping.h |   51 ++++++++++++++++++++++++++++++++++++
>   kernel/time/timekeeping.c          |   11 ++++++++
>   2 files changed, 62 insertions(+)
>   create mode 100644 include/trace/events/timekeeping.h
>
> diff --git a/include/trace/events/timekeeping.h b/include/trace/events/timekeeping.h
> new file mode 100644
> index 0000000..ff7a631
> --- /dev/null
> +++ b/include/trace/events/timekeeping.h
> @@ -0,0 +1,51 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM timekeeping
> +
> +#if !defined(_TRACE_TIMEKEEP_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_TIMEKEEP_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/time.h>
> +
> +DECLARE_EVENT_CLASS(xtime_template,
> +
> +	TP_PROTO(u64 sec, u64 nsec),
> +
> +	TP_ARGS(sec, nsec),
> +
> +	TP_STRUCT__entry(
> +		__field( u64,	sec)
> +		__field( u64,	nsec)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->sec  = sec;
> +		__entry->nsec = nsec;
> +	),
> +
> +	TP_printk("sec=%Lu nsec=%Lu", __entry->sec, __entry->nsec)
> +);
> +
> +DEFINE_EVENT(xtime_template, do_settimeofday,
> +	TP_PROTO(u64 sec, u64 nsec),
> +	TP_ARGS(sec, nsec));
> +
> +DEFINE_EVENT(xtime_template, timekeeping_inject_offset,
> +	TP_PROTO(u64 sec, u64 nsec),
> +	TP_ARGS(sec, nsec));
> +
> +DEFINE_EVENT(xtime_template, timekeeping_inject_sleeptime,
> +	TP_PROTO(u64 sec, u64 nsec),
> +	TP_ARGS(sec, nsec));
> +
> +DEFINE_EVENT(xtime_template, timekeeping_resume,
> +	TP_PROTO(u64 sec, u64 nsec),
> +	TP_ARGS(sec, nsec));
> +
> +DEFINE_EVENT(xtime_template, change_clocksource,
> +	TP_PROTO(u64 sec, u64 nsec),
> +	TP_ARGS(sec, nsec));
> +#endif /*  _TRACE_TIMEKEEP_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 9a0bc98..0ce45ec 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -23,6 +23,8 @@
>   #include <linux/stop_machine.h>
>   #include <linux/pvclock_gtod.h>
>
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/timekeeping.h>
>
>   static struct timekeeper timekeeper;
>
> @@ -462,6 +464,8 @@ int do_settimeofday(const struct timespec *tv)
>
>   	timekeeping_update(tk, true);
>
> +	trace_do_settimeofday(tk->xtime_sec, timekeeping_get_ns(tk));
> +
>   	write_sequnlock_irqrestore(&tk->lock, flags);
>
>   	/* signal hrtimers about time change */
> @@ -504,6 +508,8 @@ int timekeeping_inject_offset(struct timespec *ts)
>   error: /* even if we error out, we forwarded the time, so call update */
>   	timekeeping_update(tk, true);
>
> +	trace_timekeeping_inject_offset(tk->xtime_sec, timekeeping_get_ns(tk));
> +
>   	write_sequnlock_irqrestore(&tk->lock, flags);
>
>   	/* signal hrtimers about time change */
> @@ -536,6 +542,7 @@ static int change_clocksource(void *data)
>   			old->disable(old);
>   	}
>   	timekeeping_update(tk, true);
> +	trace_change_clocksource(tk->xtime_sec, timekeeping_get_ns(tk));
>
>   	write_sequnlock_irqrestore(&tk->lock, flags);
>
> @@ -772,6 +779,9 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
>
>   	timekeeping_update(tk, true);
>
> +	trace_timekeeping_inject_sleeptime(tk->xtime_sec,
> +					   timekeeping_get_ns(tk));
> +
>   	write_sequnlock_irqrestore(&tk->lock, flags);
>
>   	/* signal hrtimers about time change */
> @@ -807,6 +817,7 @@ static void timekeeping_resume(void)
>   	tk->ntp_error = 0;
>   	timekeeping_suspended = 0;
>   	timekeeping_update(tk, false);
> +	trace_timekeeping_resume(tk->xtime_sec, timekeeping_get_ns(tk));
>   	write_sequnlock_irqrestore(&tk->lock, flags);
>
>   	touch_softlockup_watchdog();
>

