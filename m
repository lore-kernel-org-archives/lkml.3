Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3H3LFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:05:24 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:35073 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3H3LFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:05:22 -0400
Date: Fri, 30 Aug 2013 13:05:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [RFC PATCH 6/6] timekeeping: Debug missing timekeeping updates
Message-ID: <20130830110517.GB7806@somewhere>
References: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
 <1377103341-15235-7-git-send-email-fweisbec@gmail.com>
 <5214F825.8010504@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5214F825.8010504@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:25:57AM -0700, John Stultz wrote:
> On 08/21/2013 09:42 AM, Frederic Weisbecker wrote:
> > With the full dynticks feature and the tricky full system idle
> > detection code that is coming soon, it becomes necessary to have
> > some debug code that makes sure that the timekeeping is always
> > maintained and moving forward as expected.
> >
> > This provides a simple detection of missing timekeeping updates
> > inspired by the lockup detector's use of CPU cycles clock.
> >
> > The jiffies are compared to the cpu clock after several snapshots taken
> > from NMIs that trigger after arbitrary CPU cycles period overflow.
> >
> > If the jiffies progression appears to drift too far away from the CPU
> > clock's, this triggers a warning.
> >
> > We just make sure not to account the tiny code on irq entry that
> > may have stale jiffies values before tick_check_nohz() is called
> > after the CPU is woken up while the system went full idle for some
> > time.
> >
> > Same goes for idle exit in case the tick were stopped but idle
> > was polling on need_resched().
> 
> So you're using sched_clock to try to detect timekeeping
> inconsistencies. Hrm.. Do you have some examples of where this debug
> infrastructure helped out?

Yeah, currently the full dynticks implies to keep a CPU with the tick alive all
the time. This way we make sure that busy CPUs have a reliable timekeeping even
when they run tickless.

We could make the timekeeper go to sleep when the system is fully idle and wake
it up when there is at least a full dynticks CPU alive. But the simple concept of
full idle detection is actually not that obvious. We need to maintain some atomic
counter of busy CPUs, send an IPI to the timekeeper when a single CPU wakes up, and
order all that correctly.

But maintaining such atomic counter is bad for scalability.

So Paul MckKenney is working on a full system idle detection that reuse the RCU
extended grace period detection infrastructure. He enhanced it with a state machine
based on smp barriers and atomic ops. The thing appears to be much more scalable
that a single busy CPU counters.

All in one it makes sure that timekeeping is always well maintained while keeping
reasonable power consumption by allowing the timekeeper to sleep when it considers
that it's time to do so.

I don't understand the state macchine completely though, so my brain takes it as a lemma.
And in any case it's a quite complicated piece on which the timekeeping progression depends.

So I thought we really need to start adding some automated detection of missing timekeeping.

> 
> A few thoughts:
> 
> 1) Why are you using jiffies as the timekeeping reference instead of
> reading some of actual timekeeping values? Jiffies usage has been
> intentionally on the decline, and since the dynticks infrastructure
> landed, jiffies are just derived from the timekeeping core, so its so
> its sort of strange to see it used for this.

That's because it's a simple counter so it's simpler to compute diffs and
comparisons on top of it. I prefered to use it instead of gtod values to
keep the NMI fast check path simple enough.

> 
> 2) This seems very similar to the old lost-ticks compensation code we
> had prior to the clocksource infrastructure, and seems like it might
> suffer from some of the issues seen there. For instance, sched_clock has
> been historically looser in its correctness requirements then the
> timekeeping code, so using it to validate the more strict timekeeping
> code, makes me worry we might see cases of false positives.

Yeah I was worried about that too. That's why that detection allows large
drifts between jiffies and sched clock (around 0.5 secs).

Do you think of other clock base I could use instead? sched clock also has
the advantage to be fast and NMI-safe, at least in x86.

> 
> 3) I'm also curious (maybe skeptical) as if sched_clock is reliable
> enough to use for validating time, then we likely are using that same
> hardware as the timekeeping clocksource. Thus cases where I'd suspect
> you'd see likely issues w/ nohz, like clocksource counter overflows
> being missed on quick wrapping clcoksources wouldn't really apply.

Hmm, but I thought timekeeping_max_deferment would takes care of clocksource
overflows?

> 
> 
> Personally, I've been thinking the timekeeping update code could use
> some improvements/warnings around cases where update delay is larger
> then the clocksource max_deferment - possibly falling back to a slower
> overflow-proof multiply as is done in the CLOCK_SOURCE_SUSPEND_NONSTOP
> resume case. This would allow more robust behaivor in cases like kvm
> guests being paused for unreasonable lengths of time, and could also
> provide very similar NOHZ debug warnings (assuming the clocksource
> doesn't wrap quickly - but again, in those cases, I'm not confident we
> can trust sched_clock either).

May be. I don't know enough the details of timekeeping to debate there :)

Thanks.
