Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaGaQqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:46:36 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57149 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaGaQqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:46:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] nohz: Fix spurious periodic tick behaviour in low-res dynticks mode
Date: Thu, 31 Jul 2014 18:45:55 +0200
Message-Id: <1406825156-11901-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406825156-11901-1-git-send-email-fweisbec@gmail.com>
References: <1406825156-11901-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

When we reach the end of the tick handler, we unconditionally reschedule
the next tick to the next jiffy. Then on irq exit, the nohz code
overrides that setting if needed and defers the next tick as far away in
the future as possible.

Now in the best dynticks case, when we actually don't need any tick in
the future (ie: expires == KTIME_MAX), low-res and high-res behave
differently. What we want in this case is to cancel the next tick
programmed by the previous one. That's what we do in high-res mode. OTOH
we lack a low-res mode equivalent of hrtimer_cancel() so we simply don't
do anything in this case and the next tick remains scheduled to jiffies + 1.

As a result, in low-res mode, when the dynticks code determines that no
tick is needed in the future, we can recursively get a spurious tick
every jiffy because then the next tick is always reprogrammed from the
tick handler and is never cancelled. And this can happen indefinetly
until some subsystem actually needs a precise tick in the future and only
then we eventually overwrite the previous tick handler setting to defer
the next tick.

We are fixing this by introducing the ONESHOT_STOPPED mode which will
let us pause a clockevent when no further interrupt is needed. Meanwhile
we can't expect all drivers to support this new mode.

So lets reduce much of the symptoms by skipping the nohz-blind tick
rescheduling from the tick-handler when the CPU is in dynticks mode.
That tick rescheduling wrongly assumed periodicity and the low-res
dynticks code can't cancel such decision. This breaks the recursive (and
thus the worst) part of the problem. In the worst case now, we'll get
only one extra tick due to uncancelled tick scheduled before we entered
dynticks mode.

This also removes a needless clockevent write on idle ticks. Since those
clock write are usually considered to be slow, it's a general win.

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6558b7a..b07ba8e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -956,6 +956,10 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	tick_sched_do_timer(now);
 	tick_sched_handle(ts, regs);
 
+	/* Skip reprogramming next event if we are running tickless  */
+	if (unlikely(ts->tick_stopped))
+		return;
+
 	while (tick_nohz_reprogram(ts, now)) {
 		now = ktime_get();
 		tick_do_update_jiffies64(now);
-- 
1.8.3.1

