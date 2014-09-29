Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaI2Ppa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:45:30 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39079 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbaI2Pp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:45:27 -0400
Message-ID: <1412005518.3817.23.camel@hornet>
Subject: Re: [PATCH 1/2] perf: Add sampling of the raw monotonic clock
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 29 Sep 2014 16:45:18 +0100
In-Reply-To: <20140929152832.GL4140@worktop.programming.kicks-ass.net>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
	 <1411050873-9310-2-git-send-email-pawel.moll@arm.com>
	 <20140929152832.GL4140@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 16:28 +0100, Peter Zijlstra wrote:
> On Thu, Sep 18, 2014 at 03:34:32PM +0100, Pawel Moll wrote:
> > @@ -4456,6 +4459,13 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
> >  		data->cpu_entry.cpu	 = raw_smp_processor_id();
> >  		data->cpu_entry.reserved = 0;
> >  	}
> > +
> > +	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC) {
> > +		struct timespec now;
> > +
> > +		getrawmonotonic(&now);
> > +		data->clock_raw_monotonic = timespec_to_ns(&now);
> > +	}
> >  }
> >  
> 
> This cannot work, getrawmonotonic() isn't NMI-safe and there's
> nothing stopping this being used from NMI context.
> 
> Also getrawmonotonic() + timespec_to_ns() will make tglx sad, he's just
> done a tree-wide eradication of silly conversions and now you're adding
> a ns -> timespec -> ns dance right back.

Last thing I want is to make Thomas sad... For obvious reasons ;-)

> I _think_ you want ktime_get_mono_fast_ns(), 

With pleasure, it's exactly what I need.

> but this does bring us
> right back to the question/discussion on which timebase you'd want to
> sync again. MONO does make sense for most cases, but I think we've had
> fairly sane stories for people wanting to sync against other clocks.

Yes. I've asked the same question somewhere in the thread.

ftrace has got a switch and a selection of trace_clocks in
kernel/trace/trace.c - do we want something similar (in integer form
probably, though) in perf_events.h with an additional "flag" in struct
perf_event_attr? It could be used to pick a time source for
PERF_SAMPLE_CLOCK (PERF_SAMPLE_TRACE_CLOCK?) sample.

Pawel

