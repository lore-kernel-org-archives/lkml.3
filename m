Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3JDMG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:06:58 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:53777 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3JDMG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:06:56 -0400
MIME-Version: 1.0
In-Reply-To: <1378895123.5476.83.camel@marge.simpson.net>
References: <24EECBCC-F655-404F-8946-73CC36095A5F@gmail.com>
	<1378362989.18435.2.camel@marge.simpson.net>
	<20130905111428.GB23362@gmail.com>
	<1378386697.6567.9.camel@marge.simpson.net>
	<20130905133750.GA26637@gmail.com>
	<1378445942.5434.31.camel@marge.simpson.net>
	<20130909122325.GX31370@twins.programming.kicks-ass.net>
	<1378730538.5586.30.camel@marge.simpson.net>
	<20130909133044.GB31370@twins.programming.kicks-ass.net>
	<20130909134635.GB26785@twins.programming.kicks-ass.net>
	<20130911085643.GS26785@twins.programming.kicks-ass.net>
	<1378895123.5476.83.camel@marge.simpson.net>
Date: Fri, 4 Oct 2013 20:06:55 +0800
Message-ID: <CABawtvMo+NtTv3a3jj=YTg-Om=MzHhVDARdtTA-DtTMzNeNAJA@mail.gmail.com>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rjw@sisk.pl,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org, lenb@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike, Peter,
   Seems lots of work has been done these days, studious guys. those
patches merged in last stable/dev branch (fix performance regression
caused by extra rtimer programming and rescheduling IPI,confusing
idle... etc) ? So I could just do a lazy pull for test with my
environment.  I need catch up with other mail loops with my vacation
again.

Thanks,
Ethan

On Wed, Sep 11, 2013 at 6:25 PM, Mike Galbraith <bitbucket@online.de> wrote:
> On Wed, 2013-09-11 at 10:56 +0200, Peter Zijlstra wrote:
>> On Mon, Sep 09, 2013 at 03:46:35PM +0200, Peter Zijlstra wrote:
>> > On Mon, Sep 09, 2013 at 03:30:44PM +0200, Peter Zijlstra wrote:
>> > > diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
>> > > index fa6964d..486c0ba 100644
>> > > --- a/drivers/idle/intel_idle.c
>> > > +++ b/drivers/idle/intel_idle.c
>> > > @@ -359,6 +359,14 @@ static int intel_idle(struct cpuidle_device *dev,
>> > >   if (!(lapic_timer_reliable_states & (1 << (cstate))))
>> > >           clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
>> > >
>> > > + current_thread_into()->status |= TS_POLLING;
>> > > +
>> > > + /*
>> > > +  * Order against setting of TS_POLLING against the reading of
>> > > +  * NEED_RESCHED, matched by resched_task().
>> > > +  */
>> > > + smp_mb();
>> > > +
>> > >   if (!need_resched()) {
>> > >
>> > >           __monitor((void *)&current_thread_info()->flags, 0, 0);
>> > > @@ -367,6 +375,8 @@ static int intel_idle(struct cpuidle_device *dev,
>> > >                   __mwait(eax, ecx);
>> > >   }
>> > >
>> > > + current_thread_into()->status &= ~TS_POLLING;
>> > > +
>> > >   if (!(lapic_timer_reliable_states & (1 << (cstate))))
>> > >           clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
>> >
>> > Hmm, arguably it would be better to set this from
>> > intel_idle_cpuidle_driver_init() and clear it whenever this goes away.
>> > Not sure how all that works, the cpuidle driver framework seems 'weird'.
>>
>> OK, so I went over the idle stuff again, and we do set TS_POLLING like
>> stuff, it got hidden in current_{clr,set}_polling().
>>
>> Still if that patch causes extra IPIs its bound to be broken in some
>> creative way.. I'll prod.
>
> (thanks, when I get a break from testing/poking this'n'that, I'll take a
> peek too...  well, good_intentions++ anyway;)
>
