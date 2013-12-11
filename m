Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3LKCGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:06:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:52785 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3LKCGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:06:04 -0500
Date: Wed, 11 Dec 2013 03:05:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
In-Reply-To: <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>  <1386478624.4748.19.camel@marge.simpson.net>  <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>  <1386559014.4875.16.camel@marge.simpson.net>
 <1386652637.5374.72.camel@marge.simpson.net> <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Thomas Gleixner wrote:
> On Tue, 10 Dec 2013, Mike Galbraith wrote:
> > vogelweide:~/:[130]# turbostat -P -i 60
> > pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6 CTMP   %pc3   %pc6
> >              0.02 2.12 2.26   0  43.40  56.57   0.00   53  33.81   0.00
> >  0   0   0   0.23 2.10 2.26   5  65.47  34.30   0.00   52  10.69   0.00
> 
> ...
>  
> > That, vs solid >99% pc3 for old 3.0 enterprise kernel.  What happened,
> > dunno, kernel called itself master.  Whatever, I don't like test bogons,
> > and this is one, so I thought I should let you know.  DL980 refuses to
> > come close to the previous result.
> 
> Hmm, that's very similar to the issue Len is seing on his quad socket WM.
> 
> But I can't see it on my dual socket SNB, neither does PeterZ on his
> dual socket WM machine. Heisenbugs ....
> 
> Can you offline all cpus except core 0, enable all trace events (nop
> tracer), run "sleep 100" and stop and grab the trace? Please make sure
> that your tracebuffer is big enough to cover the full thing.

So Boris found a quad socket WM which shows the issue and he also
confirmed that dual socket ones cannot reproduce it...

The trace Boris provided shows similar bogosity as you and Len are
seing. Decoding it shows:

Sleep time	state=1	state=2	state=3	state=4
  0 -  49 ms:	202	  6	 32	948
 50 -  99 ms:	 15	  0	  0	 66
100 - 149 ms:	  3	  0	  0	 12
150 - 199 ms:	  1	  0	  0	  0

So we actually sleep for more than 150ms in C1!?! Lets look at the
trace:

          <idle>-0     [000] d...  1977.728444: cpu_idle: state=4 cpu_id=0
          <idle>-0     [000] ....  1977.728446: cpu_idle: state=4294967295 cpu_id=0
          <idle>-0     [000] d...  1977.728448: cpu_idle: state=4 cpu_id=0
          <idle>-0     [000] ....  1977.728450: cpu_idle: state=4294967295 cpu_id=0
          <idle>-0     [000] d...  1977.728452: cpu_idle: state=4 cpu_id=0
          <idle>-0     [000] ....  1977.728453: cpu_idle: state=4294967295 cpu_id=0
          <idle>-0     [000] d...  1977.728455: cpu_idle: state=4 cpu_id=0
          <idle>-0     [000] ....  1977.728456: cpu_idle: state=4294967295 cpu_id=0
          <idle>-0     [000] d...  1977.728458: cpu_idle: state=4 cpu_id=0
          <idle>-0     [000] ....  1977.728460: cpu_idle: state=4294967295 cpu_id=0
          <idle>-0     [000] d...  1977.728462: cpu_idle: state=4 cpu_id=0
          <idle>-0     [000] ....  1977.728463: cpu_idle: state=4294967295 cpu_id=0
          <idle>-0     [000] d...  1977.728465: cpu_idle: state=1 cpu_id=0
          <idle>-0     [000] d.h.  1977.891539: local_timer_entry: vector=239

So what happens is that SIX consecutive calls into the idle machinery
with state=4 return right away. That means either need_resched() is
set, which is nowhere indicated by the trace and would be causing a
reschedule in between. And after that the idle governor decides to go
into state=1 where we stay for a whopping 163ms.

Now I wanted to analyze that a bit more and asked Boris to apply the
debug patch below.

Drumroll, then laugther and then banging the head against the wall:

Sleep time	state=1	state=2	state=3	state=4
  0 -  49 ms:	  8	  3	112	2849
 50 -  99 ms:	  0	  0	  0 	 419
100 - 149 ms:	  0	  0	  0	  84
150 - 199 ms:	  0	  0	  0	  21
200 - 249 ms:	  0	  0	  0	   3

Also turbostat confirms that the machine is staying in its deepest
power state as much as it can.

I neither can observe similar massive bouncing in and out of a state
as in the above trace. There are a few lonely ones, but they do not
do any damage.

Now what does this patch change?

Nothing in the logic, it merily changes the timing of that idle
code by adding trace_printks.

And what did the x86 -> generic idle code change do ?

 Lets ignore the subtle SMP issues vs. the polling flag which are
 fixed in current mainline and completely irrelevant for an idle UP
 machine. And all the traces are from an UP machine (all cores
 offlined except 0)

 It changed the timing as well.

So the trace addons making the issue go away AND the fact that nobody
can reproduce the issue on a dual socket machine makes me wonder even
more.

Now there is an important data point:

  The problem is timing sensitive and the issue is only exposed on
  quad socket machines.

So I looked at the code pathes once more and the only way we can
bounce out of that is that the mwait in intel_idle() comes back
prematurely.

Now what makes mwait come back early? Especially in a situation where
only a single core is involved in code execution?

Definitely not a change in the idle code, which is relating to UP
exacly ZERO, except the fact that we touch the cpu local nmi watchdog
variable via touch_nmi_watchdog() inside the irq disabled region
instead of the previous irq enabled region.

So what makes mwait come back right away?

Lets look at a snippet of the trace which was taken with the debug
patch applied:

<idle>-0  [000] d... 1747.667184: menu_select: expected_us: 39875 predicted_us: 22697

So we have according to the nohz code 39875 usec idle time ahead. The
governer heuristics make that: 22697 predicted time.

<idle>-0  [000] d... 1747.667187: menu_select: Trying idle state 1 s->dis 0 su->dis 0
<idle>-0  [000] d... 1747.667188: menu_select: residency 6
<idle>-0  [000] d... 1747.667188: menu_select: exit_latency 3 vs. 2000000000 multiplier 1
<idle>-0  [000] d... 1747.667189: menu_select: Trying idle state 2 s->dis 0 su->dis 0
<idle>-0  [000] d... 1747.667190: menu_select: residency 20
<idle>-0  [000] d... 1747.667191: menu_select: exit_latency 10 vs. 2000000000 multiplier 1
<idle>-0  [000] d... 1747.667191: menu_select: Trying idle state 3 s->dis 0 su->dis 0
<idle>-0  [000] d... 1747.667192: menu_select: residency 80
<idle>-0  [000] d... 1747.667193: menu_select: exit_latency 20 vs. 2000000000 multiplier 1
<idle>-0  [000] d... 1747.667194: menu_select: Trying idle state 4 s->dis 0 su->dis 0
<idle>-0  [000] d... 1747.667194: menu_select: residency 800
<idle>-0  [000] d... 1747.667195: menu_select: exit_latency 200 vs. 2000000000 multiplier 1
<idle>-0  [000] d... 1747.667195: cpu_idle: state=4 cpu_id=0

So the governor settles on state=4 which is the deepest one on this machine.

<idle>-0  [000] .... 1747.667197: cpuidle_idle_call: coupled 0: entered state 4

And TWO micro seconds later we are out of that state, but
need_resched() is NOT set and we did not get an interrupt and nothing
could have fiddled with the thread_info->state cacheline simply
because there is only ONE cpu online, i.e. CPU0 the very cpu which
trace we are staring at.

<idle>-0  [000] .... 1747.667198: cpu_idle: state=4294967295 cpu_id=0
<idle>-0  [000] d... 1747.667199: menu_select: expected_us: 39875 predicted_us: 19860

So we still have an expected 39875 usec sleep time ahead, which is
nonsense, but understandable because the nohz idle code did not go
through an update. But of course the immediate return takes the
residence of about 0 usec in state=4 into account and reduces the
predicted_us to 19860 usec

<idle>-0  [000] d... 1747.667201: menu_select: Trying idle state 1 s->dis 0 su->dis 0
<idle>-0  [000] d... 1747.667201: menu_select: residency 6
<idle>-0  [000] d... 1747.667202: menu_select: exit_latency 3 vs. 2000000000 multiplier 1
<idle>-0  [000] d... 1747.667203: menu_select: Trying idle state 2 s->dis 0 su->dis 0
<idle>-0  [000] d... 1747.667204: menu_select: residency 20
<idle>-0  [000] d... 1747.667204: menu_select: exit_latency 10 vs. 2000000000 multiplier 1
<idle>-0  [000] d... 1747.667205: menu_select: Trying idle state 3 s->dis 0 su->dis 0
<idle>-0  [000] d... 1747.667206: menu_select: residency 80
<idle>-0  [000] d... 1747.667206: menu_select: exit_latency 20 vs. 2000000000 multiplier 1
<idle>-0  [000] d... 1747.667207: menu_select: Trying idle state 4 s->dis 0 su->dis 0
<idle>-0  [000] d... 1747.667208: menu_select: residency 800
<idle>-0  [000] d... 1747.667208: menu_select: exit_latency 200 vs. 2000000000 multiplier 1
<idle>-0  [000] d... 1747.667209: cpu_idle: state=4 cpu_id=0

Now here we get lucky for whatever reasons and actually stay in state
4 until a real reason for leaving it happens.

<idle>-0  [000] d.h.  1747.669851: irq_handler_entry: irq=120 name=eth0-TxRx-0

So now the subtle difference between the old x86 idle code and the
generic one is that the new code fiddles with the polling state in
thread_info->state more than necessary. We need to fix that, but
nevertheless this whole mwait thing seems to be broken in some way or
the other and ever worked by chance.

So the difference boils down to:

+ modify(idle->thread_info->status)
  
  <some random code>
 
  mwait(idle->thread_info->status)

So on an UP machine the only CPU which cares about that state is that
very same idle thread which goes to sleep. Now there are a few
questions:

1) Why does writing to that cacheline from the very same cpu just
   before going to sleep cause an issue?

2) Why does it come back less often if the timing is different,
   e.g.when the debug patch is active?

3) Why does adding a mb() instead of the trace printks make the thing
   NOT go away?

   Is it really just timing related? I'm going to ask Boris to replace
   the mb() with a plain udelay(10) tomorrow.

4) Why can't we observe that on dual socket machines?

And for the record, I have analyzed traces before the switch to the
generic idle code which show the same drop in/ drop out issue on an UP
environment:

  <idle>-0     [000] d...   307.256288: cpu_idle: state=4 cpu_id=0
  <idle>-0     [000] ....   307.256289: cpu_idle: state=4294967295 cpu_id=0
  <idle>-0     [000] d...   307.256291: cpu_idle: state=4 cpu_id=0
  <idle>-0     [000] d.h.   307.257337: irq_handler_entry: irq=21 name=ata_piix

Yes, it does not cause the same issue as you can observe with the
current code, but definitely there is something extremly fishy in an
UP situation also there.

So it boils down to the following:

If something fiddles with the cache line which is monitored by mwait()
close before the mwait() happens then mwait() is playing silly
buggers. And that sillyness depends on the number of sockets.

And what's even worse is that we get a regression report for probably
exposing hardware sillyness. Something which should have been known
already - but unfortunately never has been documented as a requirement
for this mwait() stuff to work proper.

Sorry to be blunt about that. If stuff like this happens:

  <idle>-0     [000] d...   307.256288: cpu_idle: state=4 cpu_id=0
  <idle>-0     [000] ....   307.256289: cpu_idle: state=4294967295 cpu_id=0
  <idle>-0     [000] d...   307.256291: cpu_idle: state=4 cpu_id=0

on a kernel prior to that change in an UP scenario, then someone
should have investigated that years ago. But the preferred solution
was obviously to ignore that because it did not do substantial damage.

Now that the damage comes to light you cry murder for the completely
wrong reason.

The change exposes a shortcoming in mwait() rather than the more
obvious performance issue which mwait() is supposed to avoid in the
first place. Mike DID notice it and it got fixed, but of course it did
not heal the now obvious shortcomings of mwait()

Thanks,

	tglx
---

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a55e68f..b6399af 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -118,7 +118,7 @@ int cpuidle_idle_call(void)
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv;
 	int next_state, entered_state;
-	bool broadcast;
+	bool broadcast, coupled = false;
 
 	if (off || !initialized)
 		return -ENODEV;
@@ -147,15 +147,18 @@ int cpuidle_idle_call(void)
 	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
 
-	if (cpuidle_state_is_coupled(dev, drv, next_state))
+	if (cpuidle_state_is_coupled(dev, drv, next_state)) {
 		entered_state = cpuidle_enter_state_coupled(dev, drv,
 							    next_state);
-	else
+		coupled = true;
+	} else
 		entered_state = cpuidle_enter_state(dev, drv, next_state);
 
 	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
+	trace_printk("coupled %d: entered state %d\n", coupled, entered_state);
+
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 
 	/* give the governor an opportunity to reflect on the outcome */
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index cf7f2f0..9de7ee2 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -309,7 +309,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	data->expected_us =
 		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
 
-
 	data->bucket = which_bucket(data->expected_us);
 
 	multiplier = performance_multiplier();
@@ -330,6 +329,9 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 					 data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
+	trace_printk("expected_us: %d predicted_us: %d\n", data->expected_us,
+		     data->predicted_us);
+
 	get_typical_interval(data);
 
 	/*
@@ -349,10 +351,15 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		struct cpuidle_state *s = &drv->states[i];
 		struct cpuidle_state_usage *su = &dev->states_usage[i];
 
+		trace_printk("Trying idle state %d s->dis %d su->dis %d\n", i,
+			     s->disabled, su->disable);
 		if (s->disabled || su->disable)
 			continue;
+		trace_printk("residency %d\n", s->target_residency);
 		if (s->target_residency > data->predicted_us)
 			continue;
+		trace_printk("exit_latency %d vs. %d multiplier %d\n",
+			     s->exit_latency, latency_req, multiplier);
 		if (s->exit_latency > latency_req)
 			continue;
 		if (s->exit_latency * multiplier > data->predicted_us)

