Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaLCUhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:37:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:55481 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLCUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:37:39 -0500
Date: Wed, 3 Dec 2014 21:37:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CANcMJZA1NXUMLEveA2k5njFnWc1pCSwSeAOQH7VQCOR-QtiR8g@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412032126130.16275@nanos>
References: <547bbe36.48548c0a.105c.779c@mx.google.com> <20141201191431.GA17385@linux.vnet.ibm.com> <547ccf74.a5198c0a.25de.26d9@mx.google.com> <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com> <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net> <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com> <1417540493.21136.3@mail.thefacebook.com> <20141203184111.GA32005@redhat.com> <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141203190045.GB32005@redhat.com> <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com> <CANcMJZA1NXUMLEveA2k5njFnWc1pCSwSeAOQH7VQCOR-QtiR8g@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, John Stultz wrote:
> On Wed, Dec 3, 2014 at 11:25 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Wed, Dec 3, 2014 at 11:00 AM, Dave Jones <davej@redhat.com> wrote:
> >>
> >> So right after sending my last mail, I rebooted, and restarted the run
> >> on the same kernel again.
> >>
> >> As I was writing this mail, this happened.
> >>
> >> [  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c178:20182]
> >>
> >> and that's all that made it over the console. I couldn't log in via ssh,
> >> and thought "ah-ha, so it IS bad".  I walked over to reboot it, and
> >> found I could actually log in on the console. check out this dmesg..
> >>
> >> [  503.683055] Clocksource tsc unstable (delta = -95946009388 ns)
> >> [  503.692038] Switched to clocksource hpet
> >> [  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c178:20182]
> >
> > Interesting. That whole NMI watchdog thing happens pretty much 22s
> > after the "TSC unstable" message.
> >
> > Have you ever seen that TSC issue before? The watchdog relies on
> > comparing get_timestamp() differences, so if the timestamp was
> > incorrect...
> >
> > Maybe that whole "clocksource_watchdog()" is bogus. That delta is
> > about 96 seconds, sounds very odd. I'm not seeing how the TSC could
> > actually scew up that badly, so I'd almost be more likely to blame the
> > "watchdog" clock.
> >
> > I don't know. This piece of code:
> >
> >         delta = clocksource_delta(wdnow, cs->wd_last, watchdog->mask);
> >
> > makes no sense to me. Shouldn't it be
> >
> >         delta = clocksource_delta(wdnow, watchdog->wd_last, watchdog->mask);
> 
> So we store wdnow value in the cs->wd_last a few lines below, so I
> don't think that's problematic.
> 
> I do recall seeing problematic watchdog behavior back in the day w/
> PREEMPT_RT when a high priority task really starved the watchdog for a
> long time. When we came back the hpet had wrapped, making the wd_delta
> look quite small relative to the TSC delta, causing improper
> disqualification of the TSC.

Right, that resulted in a delta > 0. I have no idea how we could
create a negative delta via wrapping the HPET around, i.e. HPET being
96 seconds ahead of TSC.

This looks more like a genuine TSC wreckage. So we have these possible
causes:

   1) SMI

   2) Power states

   3) Writing to the wrong MSR

So I assume that 1/2 are a non issue. They should surface in normal
non fuzzed operation as well.

Dave, does that TSC unstable thing always happen AFTER you started
fuzzing? If yes, what is the fuzzer doing this time?

Thanks,

	tglx
