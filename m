Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbbAENpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:45:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:47012 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbbAENpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:45:31 -0500
Date: Mon, 5 Jan 2015 14:45:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
Message-ID: <20150105134514.GS30905@twins.programming.kicks-ass.net>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
 <1415292718-19785-4-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415292718-19785-4-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:51:58PM +0000, Pawel Moll wrote:
> Currently three clocks are implemented: CLOCK_REALITME = 0,
> CLOCK_MONOTONIC = 1 and CLOCK_MONOTONIC_RAW = 2. The clock field is
> 5 bits wide to allow for future extension to custom, non-POSIX clock
> sources(MAX_CLOCK for those is 16, see include/uapi/linux/time.h) like
> ARM CoreSight (hardware trace) timestamp generator.

> @@ -304,7 +305,16 @@ struct perf_event_attr {
>  				mmap2          :  1, /* include mmap with inode data     */
>  				comm_exec      :  1, /* flag comm events that are due to an exec */
>  				uevents        :  1, /* allow uevents into the buffer */
> -				__reserved_1   : 38;
> +
> +				/*
> +				 * clock: one of the POSIX clock IDs:
> +				 *
> +				 * 0 - CLOCK_REALTIME
> +				 * 1 - CLOCK_MONOTONIC
> +				 * 4 - CLOCK_MONOTONIC_RAW
> +				 */
> +				clock          :  5, /* clock type */
> +				__reserved_1   : 33;
>  
>  	union {
>  		__u32		wakeup_events;	  /* wakeup every n events */

This would put a constraint on actually changing MAX_CLOCKS, are the
time people OK with that? Thomas, John?

I'm also not quite sure of using the >MAX_CLOCKS space for 'special'
clocks, preferably those would register themselves with the POSIX clock
interface.

> @@ -4631,6 +4637,24 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
>  		data->cpu_entry.cpu	 = raw_smp_processor_id();
>  		data->cpu_entry.reserved = 0;
>  	}
> +
> +	if (sample_type & PERF_SAMPLE_CLOCK) {
> +		switch (event->attr.clock) {
> +		case CLOCK_REALTIME:
> +			data->clock = ktime_get_real_ns();
> +			break;
> +		case CLOCK_MONOTONIC:
> +			data->clock = ktime_get_mono_fast_ns();
> +			break;
> +		case CLOCK_MONOTONIC_RAW:
> +			data->clock = ktime_get_raw_ns();
> +			break;
> +		default:
> +			data->clock = 0;
> +			break;
> +		}
> +	}
> +
>  }

This is broken. There is nothing stopping this from being called from
NMI context and only the MONO one is NMI safe.

Also, one would expect something like:

	default: {
		struct k_clock *kc = clockid_to_kclock(event->attr.clock);
		struct timespec ts;
		if (kc) {
			kc->clock_get(event->attr.clock, &ts);
			data->clock = ktime_to_ns(timespec_to_ktime(ts));
		} else {
			data->clock = 0;
		}
	}

Albeit preferably slightly less horrible -- of course, one would first
need to deal with the NMI issue.
