Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbbAURND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:13:03 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40322 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbbAURMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:12:55 -0500
Message-ID: <1421860365.14076.91.camel@arm.com>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Wed, 21 Jan 2015 17:12:45 +0000
In-Reply-To: <20150105134514.GS30905@twins.programming.kicks-ass.net>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-4-git-send-email-pawel.moll@arm.com>
	 <20150105134514.GS30905@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.10-0ubuntu1~14.10.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 13:45 +0000, Peter Zijlstra wrote:
> On Thu, Nov 06, 2014 at 04:51:58PM +0000, Pawel Moll wrote:
> > Currently three clocks are implemented: CLOCK_REALITME = 0,
> > CLOCK_MONOTONIC = 1 and CLOCK_MONOTONIC_RAW = 2. The clock field is
> > 5 bits wide to allow for future extension to custom, non-POSIX clock
> > sources(MAX_CLOCK for those is 16, see include/uapi/linux/time.h) like
> > ARM CoreSight (hardware trace) timestamp generator.
> 
> > @@ -304,7 +305,16 @@ struct perf_event_attr {
> >  				mmap2          :  1, /* include mmap with inode data     */
> >  				comm_exec      :  1, /* flag comm events that are due to an exec */
> >  				uevents        :  1, /* allow uevents into the buffer */
> > -				__reserved_1   : 38;
> > +
> > +				/*
> > +				 * clock: one of the POSIX clock IDs:
> > +				 *
> > +				 * 0 - CLOCK_REALTIME
> > +				 * 1 - CLOCK_MONOTONIC
> > +				 * 4 - CLOCK_MONOTONIC_RAW
> > +				 */
> > +				clock          :  5, /* clock type */
> > +				__reserved_1   : 33;
> >  
> >  	union {
> >  		__u32		wakeup_events;	  /* wakeup every n events */
> 
> This would put a constraint on actually changing MAX_CLOCKS, are the
> time people OK with that? Thomas, John?

I admit I have some doubts about it myself. But I don't think we can
afford full int for the clock id, can we?

> I'm also not quite sure of using the >MAX_CLOCKS space for 'special'
> clocks, preferably those would register themselves with the POSIX clock
> interface.

That may be a hard sell - John never was particularly keen on extending
the hard-coded clocks with random sources. And the hardware trace clock
I had on mind would be probably one of them - its meaning depends a lot
on the . Of course I'm looking forward to being surprised :-)

> > @@ -4631,6 +4637,24 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
> >  		data->cpu_entry.cpu	 = raw_smp_processor_id();
> >  		data->cpu_entry.reserved = 0;
> >  	}
> > +
> > +	if (sample_type & PERF_SAMPLE_CLOCK) {
> > +		switch (event->attr.clock) {
> > +		case CLOCK_REALTIME:
> > +			data->clock = ktime_get_real_ns();
> > +			break;
> > +		case CLOCK_MONOTONIC:
> > +			data->clock = ktime_get_mono_fast_ns();
> > +			break;
> > +		case CLOCK_MONOTONIC_RAW:
> > +			data->clock = ktime_get_raw_ns();
> > +			break;
> > +		default:
> > +			data->clock = 0;
> > +			break;
> > +		}
> > +	}
> > +
> >  }
> 
> This is broken. There is nothing stopping this from being called from
> NMI context and only the MONO one is NMI safe.

Uh, right. 

> Also, one would expect something like:
> 
> 	default: {
> 		struct k_clock *kc = clockid_to_kclock(event->attr.clock);
> 		struct timespec ts;
> 		if (kc) {
> 			kc->clock_get(event->attr.clock, &ts);
> 			data->clock = ktime_to_ns(timespec_to_ktime(ts));
> 		} else {
> 			data->clock = 0;
> 		}
> 	}
> 
> Albeit preferably slightly less horrible -- of course, one would first
> need to deal with the NMI issue.

Ok, generally this patch clearly needs more work. I'll have to revisit
what Thomas did with the monotonic clock to understand the potential
solutions.

Maybe, in this case, giving such a wide choice of clocks to be sampled
is not the right thing after all? Maybe, when we face the issue of a
trace clock for real, simple "PERF_SAMPLE_TRACE_CLOCK" will suffice?
With the monotonic clock as a normal time base merged (hopefully
soon :-) the correlation between kernel and user space (which was the
original reason for having this change) won't be an issue any more.

Pawel

