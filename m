Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab3LKLkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:40:12 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51127 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LKLkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:40:08 -0500
Date: Wed, 11 Dec 2013 12:40:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perf: POSIX CLOCK_PERF to report current time value
Message-ID: <20131211114004.GA789@gmail.com>
References: <1386707259-21725-1-git-send-email-dsahern@gmail.com>
 <20131211112526.GC25541@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211112526.GC25541@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > From: Pawel Moll <pawel.moll@arm.com>
> > 
> > To co-relate user space events with the perf events stream
> > a current (as in: "what time(stamp) is it now?") time value
> > must be made available.
> 
> So I'm wondering about your earlier approach posted here:
> 
>   https://lkml.org/lkml/2011/6/7/636
> 
> I'd modify that patch the following way: instead of tracking each 
> separate reason, perhaps only track timekeeping_update().
> 
> Such a tracepoint, combined with PERF_SAMPLE_TIME, would very 
> accurately track external changes to GTOD (xtime).
> 
> That leaves us with tracking/correlating the regular flow of time, 
> which could be achieved by another tracepoint in:
> 
>    kernel/time/timekeeping.c::do_timer()
> 
> So only two new tracepoints are needed AFAICS - and the tracepoints 
> would obviously be useful for other (debugging) purposes as well. 
> Would that solve the wall-clock correlation problem adequately?

I forgot to mention what data the new tracepoints would trace:

   - timekeeping_update() would trace the 'before' and 'after' 
     (==current) GTOD values

   - do_timer() would trace 'ticks' and the current GTOD value.

'GTOD value' is what gettimeofday() would return, which in the 
do_timer() case ought to be something like this:

   tk->xtime_sec
  (tk->xtime_nsec >> tk->shift) + get_arch_timeoffset()

(Note that this is simple and fast as there's no need to read the 
clock once again, it was just read.)

Thanks,

	Ingo
