Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936701Ab3DHKZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:25:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935730Ab3DHKZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:25:29 -0400
Date: Mon, 8 Apr 2013 03:24:55 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a1cbcaa9ea87b87a96b9fc465951dcf36e459ca2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, Siegfried.Wulsch@rovema.de, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Siegfried.Wulsch@rovema.de, rostedt@goodmis.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.02.1304051544160.21884@ionos>
References: <alpine.LFD.2.02.1304051544160.21884@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched_clock:
  Prevent 64bit inatomicity on 32bit systems
Git-Commit-ID: a1cbcaa9ea87b87a96b9fc465951dcf36e459ca2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 03:25:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1cbcaa9ea87b87a96b9fc465951dcf36e459ca2
Gitweb:     http://git.kernel.org/tip/a1cbcaa9ea87b87a96b9fc465951dcf36e459ca2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 6 Apr 2013 10:10:27 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 11:50:44 +0200

sched_clock: Prevent 64bit inatomicity on 32bit systems

The sched_clock_remote() implementation has the following inatomicity
problem on 32bit systems when accessing the remote scd->clock, which
is a 64bit value.

CPU0			CPU1

sched_clock_local()	sched_clock_remote(CPU0)
...
			remote_clock = scd[CPU0]->clock
			    read_low32bit(scd[CPU0]->clock)
cmpxchg64(scd->clock,...)
			    read_high32bit(scd[CPU0]->clock)

While the update of scd->clock is using an atomic64 mechanism, the
readout on the remote cpu is not, which can cause completely bogus
readouts.

It is a quite rare problem, because it requires the update to hit the
narrow race window between the low/high readout and the update must go
across the 32bit boundary.

The resulting misbehaviour is, that CPU1 will see the sched_clock on
CPU1 ~4 seconds ahead of it's own and update CPU1s sched_clock value
to this bogus timestamp. This stays that way due to the clamping
implementation for about 4 seconds until the synchronization with
CLOCK_MONOTONIC undoes the problem.

The issue is hard to observe, because it might only result in a less
accurate SCHED_OTHER timeslicing behaviour. To create observable
damage on realtime scheduling classes, it is necessary that the bogus
update of CPU1 sched_clock happens in the context of an realtime
thread, which then gets charged 4 seconds of RT runtime, which results
in the RT throttler mechanism to trigger and prevent scheduling of RT
tasks for a little less than 4 seconds. So this is quite unlikely as
well.

The issue was quite hard to decode as the reproduction time is between
2 days and 3 weeks and intrusive tracing makes it less likely, but the
following trace recorded with trace_clock=global, which uses
sched_clock_local(), gave the final hint:

  <idle>-0   0d..30 400269.477150: hrtimer_cancel: hrtimer=0xf7061e80
  <idle>-0   0d..30 400269.477151: hrtimer_start:  hrtimer=0xf7061e80 ...
irq/20-S-587 1d..32 400273.772118: sched_wakeup:   comm= ... target_cpu=0
  <idle>-0   0dN.30 400273.772118: hrtimer_cancel: hrtimer=0xf7061e80

What happens is that CPU0 goes idle and invokes
sched_clock_idle_sleep_event() which invokes sched_clock_local() and
CPU1 runs a remote wakeup for CPU0 at the same time, which invokes
sched_remote_clock(). The time jump gets propagated to CPU0 via
sched_remote_clock() and stays stale on both cores for ~4 seconds.

There are only two other possibilities, which could cause a stale
sched clock:

1) ktime_get() which reads out CLOCK_MONOTONIC returns a sporadic
   wrong value.

2) sched_clock() which reads the TSC returns a sporadic wrong value.

#1 can be excluded because sched_clock would continue to increase for
   one jiffy and then go stale.

#2 can be excluded because it would not make the clock jump
   forward. It would just result in a stale sched_clock for one jiffy.

After quite some brain twisting and finding the same pattern on other
traces, sched_clock_remote() remained the only place which could cause
such a problem and as explained above it's indeed racy on 32bit
systems.

So while on 64bit systems the readout is atomic, we need to verify the
remote readout on 32bit machines. We need to protect the local->clock
readout in sched_clock_remote() on 32bit as well because an NMI could
hit between the low and the high readout, call sched_clock_local() and
modify local->clock.

Thanks to Siegfried Wulsch for bearing with my debug requests and
going through the tedious tasks of running a bunch of reproducer
systems to generate the debug information which let me decode the
issue.

Reported-by: Siegfried Wulsch <Siegfried.Wulsch@rovema.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1304051544160.21884@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org

---
 kernel/sched/clock.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c685e31..c3ae144 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -176,10 +176,36 @@ static u64 sched_clock_remote(struct sched_clock_data *scd)
 	u64 this_clock, remote_clock;
 	u64 *ptr, old_val, val;
 
+#if BITS_PER_LONG != 64
+again:
+	/*
+	 * Careful here: The local and the remote clock values need to
+	 * be read out atomic as we need to compare the values and
+	 * then update either the local or the remote side. So the
+	 * cmpxchg64 below only protects one readout.
+	 *
+	 * We must reread via sched_clock_local() in the retry case on
+	 * 32bit as an NMI could use sched_clock_local() via the
+	 * tracer and hit between the readout of
+	 * the low32bit and the high 32bit portion.
+	 */
+	this_clock = sched_clock_local(my_scd);
+	/*
+	 * We must enforce atomic readout on 32bit, otherwise the
+	 * update on the remote cpu can hit inbetween the readout of
+	 * the low32bit and the high 32bit portion.
+	 */
+	remote_clock = cmpxchg64(&scd->clock, 0, 0);
+#else
+	/*
+	 * On 64bit the read of [my]scd->clock is atomic versus the
+	 * update, so we can avoid the above 32bit dance.
+	 */
 	sched_clock_local(my_scd);
 again:
 	this_clock = my_scd->clock;
 	remote_clock = scd->clock;
+#endif
 
 	/*
 	 * Use the opportunity that we have both locks
