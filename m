Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaLDBDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:03:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:56413 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaLDBDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:03:13 -0500
Date: Thu, 4 Dec 2014 02:02:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFyaRByi2NLb7YZ_jHnHc6VTb-Ht748ZVVfa-XC7sdqL-g@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412040120460.16275@nanos>
References: <20141203184111.GA32005@redhat.com> <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com> <20141203190045.GB32005@redhat.com> <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com> <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com>
 <20141203200906.GA3118@redhat.com> <CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com> <alpine.DEB.2.11.1412032141040.16275@nanos> <CA+55aFw8L06BxpsVnbdiNaU2WSFo=tafND25uV_SHUig=CC1AA@mail.gmail.com> <alpine.DEB.2.11.1412032249050.16275@nanos>
 <20141203232115.GA13266@redhat.com> <alpine.DEB.2.11.1412040043170.16275@nanos> <CA+55aFyaRByi2NLb7YZ_jHnHc6VTb-Ht748ZVVfa-XC7sdqL-g@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Linus Torvalds wrote:
> On Wed, Dec 3, 2014 at 3:49 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Bah. Would have been too simple ....
> 
> I do think you tend to trust the hpet too much.
> 
> Yes, we've had issues with people doing bad things to the tsc, but on
> the whole I really would tend to trust the internal CPU counter a
> _lot_ more than the external hpet.
> 
> So I think it's equally (if not more) likely that switching from tsc
> to hpet causes trouble, because I'd trust the tsc more than the hpet.

Given my experience I trust neither of them too much which makes it
admittedly weird to assign one as the supervisor of the other.

But yes, on newer machines the TSC tends to be halfways reliable when
you are not exposed to the never ending supply of BIOS bugs.

Though, that still does not explain the softlock watchdog issue as
that is completely independent of HPET.

But in the case that the clocksource switches to HPET it is not
completely independent because the hrtimer event programming depends
on it. But that would require the following scenario:

 hrtimer_start(timer) /* timer is first to expire timer */
     clockevents_program_event(timer->expires)
       delta = expires - ktime_get();
       evtdev->set_next_event(delta);

 So if ktime_get() returns an insane value in the past then delta can
 become large and of course nothing is going to reprogramm the clock
 event device unless there is a timer started which is earlier than
 the one which programmed the large delta.

 But ktime_get() cannot return a time which is before the last update
 of the timekeeper. It might return something in the future, but that
 would expire the timer earlier not later.

So there is something else here. If the programmed next event does not
fire _AND_ there is no earlier timer queued, then nothing which
depends on queued timers (hrtimer/timerlist) is going to be
scheduled. In the case of highres timers or nohz enabled not even the
scheduler tick on that cpu would kick in. We've seen that before and
it causes interesting failures ...

Now that machine has tsc_deadline_timer. I haven't seen bug reports
for that one yet, but it might be worthwhile to disable that for a
test.

But then that does not explain the post 3.16 issue at all.

More questions than answers, sigh.

> DaveJ, do this:
> 
> > Could you please run Ingos time-warp test on that machine for a while?
> 
> but perhaps also boot with "tsc=reliable", which _should_ get rid of
> that CLOCK_SOURCE_MUST_VERIFY, and the clocksource watchdog should do
> nothing.
> 
> Thomas? Am I misreading that?

No, that's what it is supposed to do and I actually know that it works.

Now we could also do it the other way round and boot with
"clocksource=hpet", which should show potential HPET wreckage right
away when exposed to Ingos time warp test.

Thanks,

	tglx


