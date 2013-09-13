Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3IMSU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:20:26 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46141 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751079Ab3IMSUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:20:25 -0400
Date: Fri, 13 Sep 2013 14:20:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] Introduce timekeeper latch synchronization
Message-ID: <20130913182020.GB32317@Krystal>
References: <20130913025253.GA17218@Krystal> <alpine.DEB.2.02.1309131803360.4089@ionos.tec.linutronix.de> <523345EC.8070206@efficios.com> <52334E5A.4050609@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52334E5A.4050609@linaro.org>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John Stultz (john.stultz@linaro.org) wrote:
> On 09/13/2013 10:05 AM, Mathieu Desnoyers wrote:
> > On 13/09/13 09:13 AM, Thomas Gleixner wrote:
> >> On Thu, 12 Sep 2013, Mathieu Desnoyers wrote:
> >>> * Peter Zijlstra (peterz@infradead.org) wrote:
> >>> [...]
> >>>> Yep, that's good. I suppose if there's multiple use sites we can jump
> >>>> through another few hoops to get rid of the specific struct foo
> >>>> assumptions by storing sizeof() whatever we do use and playing pointer
> >>>> math games.
> >>>>
> >>>> But for now with the time stuff as only user this looks ok.
> >>> OK! Here is the full implementation of the idea against Linux
> >>> timekeeper, ntp, and PPS. It appears that ntp and PPS were relying on
> >>> the timekeeper seqlock too. And guess what, after booting my laptop with
> >>> this kernel there still no smoke coming out of it after a good 5 minutes
> >>> of testing. ;-)
> >>>
> >>> Comments are welcome.
> >> First of all this needs to be split into several patches.
> > How about:
> > - three patches refactoring data structures into objects (no
> > synchronization changes whatsoever). timekeeper, ntp and pps each done
> > in separate patches,
> > - one patch to introduce the new synchronization scheme along with the
> > usage site changes. This patch would include the removal of the
> > shadow_timekeeper variable, which is made pointless by the introduction
> > of this mixed-rcu-seqcount synchronization scheme.
> >
> > is that enough, or you see a more fine-grained breakdown ?
> 
> I think that would be a good start (btw, sorry, doing some prep for
> Plumbers next week, and haven't had a chance to do a detailed review of
> the design here - when I asked for ideas I didn't expect folks to start
> sending code the next day! ;).
> 
> Another thing to consider to possibly avoid the extra costs that Peter
> mentioned is partitioning the timekeeper structure up a little bit as
> well, as there are some values that are basically only used at update
> time vs the values we use at read time. I suspect we can trim down the
> amount of duplicated data. This is similar to what we do w/ vdso update.
> 
> For instance, to read the time we probably need:
> 
> The base calculation for CLOCK_REALTIME:
>     struct clocksource    *clock;
>     u32            mult;
>     u32            shift;
>     cycle_t        cycle_last;
>     u64            xtime_sec;
>     u64            xtime_nsec;
> 
> Along with the various offsets from CLOCK_REALTIME:
>     struct timespec    wall_to_monotonic;
>     ktime_t            offs_real;
>     struct timespec    total_sleep_time;
>     ktime_t            offs_boot;
>     s32                tai_offset;
>     ktime_t            offs_tai;
>     struct timespec    raw_time;
> 
> Can be separate from the internal accounting details used at update time
> to adjust the above:
>     cycle_t            cycle_interval;
>     u64                xtime_interval;
>     s64                xtime_remainder;
>     u32                raw_interval;
>     s64                ntp_error;
>     u32                ntp_error_shift;

This looks to me like interesting optimisation work that should be
considered after the following question is answered: does the added
update-side cost actually matter that much ?

Thanks,

Mathieu

> 
> thanks
> -john
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
