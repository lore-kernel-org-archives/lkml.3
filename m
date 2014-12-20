Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaLTBBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:01:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:36369 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLTBBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:01:16 -0500
Date: Sat, 20 Dec 2014 02:00:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFx4zjAVHN5DrSCh1_MJjqf4fxoAVT3RmC+1QGP6bq7b0Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412200100130.17382@nanos>
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com> <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com> <20141218051327.GA31988@redhat.com> <1418918059.17358.6@mail.thefacebook.com> <20141218161230.GA6042@redhat.com>
 <20141219024549.GB1671@redhat.com> <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com> <20141219035859.GA20022@redhat.com> <20141219040308.GB20022@redhat.com> <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
 <20141219145528.GC13404@redhat.com> <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com> <alpine.DEB.2.11.1412192201520.17382@nanos> <CA+55aFx4zjAVHN5DrSCh1_MJjqf4fxoAVT3RmC+1QGP6bq7b0Q@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Linus Torvalds wrote:
> On Fri, Dec 19, 2014 at 3:14 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Now that all looks correct. So there is something else going on. After
> > staring some more at it, I think we are looking at it from the wrong
> > angle.
> >
> > The watchdog always detects CPU1 as stuck and we got completely
> > fixated on the csd_wait() in the stack trace on CPU1. Now we have
> > stack traces which show a different picture, i.e. CPU1 makes progress
> > after a gazillion of seconds.
> 
> .. but that doesn't explain why CPU0 ends up always being at that
> *exact* same instruction in the NMI backtrace.

Up to the point where it exposes different instructions and completely
different code pathes. I'm not agreeing with your theory that after
the RT throttler hit the watchdog and everything else goes completely
bonkers. And even before that happens we see a different backtrace on
CPU0:

[25149.982766] RIP: 0010:[<ffffffff810cf1db>]  [<ffffffff810cf1db>] invoke_rcu_core+0x2b/0x50

Though I have to admit that this "very same instruction" pattern
puzzled me for quite a while as well.

> While a fairly tight loop, together with "mmio read is very expensive
> and synchronizing" would explain it. An MMIO read can easily be as
> expensive as several thousand instructions.

The watchdog timer runs on a fully periodic schedule. It's self
rearming via

	 hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));

So if that aligns with the equally periodic tick interrupt on the
other CPU then you might get into that situation due to the fully
synchronizing and serializing nature of HPET reads.

That can drift apart over time because the timer device (apic or that
new fangled tscdeadline timer) are not frequency corrected versus
timekeeping.

> > I think we really need to look at CPU1 itself.
> 
> Not so fast. Take another look at CPU0.
> 
> [24998.083577]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
> [24998.084450]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
> [24998.085315]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
> [24998.086173]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
> [24998.087025]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
> [24998.087877]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
> [24998.088732]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
> [24998.089583]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
> [24998.090435]  <EOI>
> [24998.091279]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
> [24998.092118]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
> [24998.092951]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
> [24998.093779]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
> 
> 
> Really. None of that changed. NONE. The likelihood that we hit the
> exact same instruction every time? Over a timefraem of more than a
> minute?
> 
> The only way I see that happening is (a) NMI is completely buggered,
> and the backtrace is just random crap that is always the same.  Or (b)
> it's really a fairly tight loop.
> 
> The fact that you had a hrtimer interrupt happen in the *middle* of
> __remove_hrtimer() is really another fairly strong hint. That smells
> like "__remove_hrtimer() has a race with hrtimer interrupts".

That __remove_hrtimer has a '?' in front of it. So its not a reliable
trace entry.

There is NO hrtimer related operation in the msgget() syscall at all
and SyS_msgget() is the only reliable entry on that stack trace.

So that __remove_hrtimer operation happened before that msgget()
syscall and is just a stack artifact. poll/select/nanosleep whatever.

> And that race results in a basically endless loop (which perhaps ends
> when the HRtimer overflows, in what, a few minutes?)

hrtimers overflow in about 584 years
 
> I really don't think you should look at CPU1. Not when CPU0 has such
> an interesting pattern that you dismissed just because the HPET is
> making progress.

No. I did not dismiss it because HPET is making progress. I looked at
it from a different angle.

So lets assume there is that hrtimer_remove race (I'm certainly going
to stare at that tomorrow with fully awake brain. It's past beer
o'clock here). How do you explain that:

1) the watchdog always triggers on CPU1?

2) the race only ever happens on CPU0?

3) the hrtimer interrupt took too long message never appears?

   If that timer interrupt loops forever then it will complain about
   that. And it leaves that code for sure as the backtrace of CPU0
   hits user space later on.

4) the RT throttler hit?

   Admittetly we dont know from which CPU and which task that comes
   but that's very simple to figure out. Debug patch below.

5) that the system makes progress afterwards?

6) ....

If my assumption about an interrupt storm turns out to be true, then
it explain all of the above. I might be wrong as usual, but I still
think its worth to have a look.

Thanks,

	tglx
---

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index ee15f5a0d1c1..d9e4153d405b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -895,7 +895,8 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 		 */
 		if (likely(rt_b->rt_runtime)) {
 			rt_rq->rt_throttled = 1;
-			printk_deferred_once("sched: RT throttling activated\n");
+			printk_deferred_once("sched: RT throttling activated cpu %d task %s %d\n",
+					     smp_processor_id(), current->comm, current->pid);
 		} else {
 			/*
 			 * In case we did anyway, make it go away,
