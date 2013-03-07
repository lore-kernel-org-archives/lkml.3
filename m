Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab3CGQeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:34:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3CGQeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:34:19 -0500
Date: Thu, 7 Mar 2013 08:33:07 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-d2348fb6fdc6d671ad45b62db237f76c8c115603@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1362219013-18173-3-git-send-email-daniel.lezcano@linaro.org>
References: <1362219013-18173-3-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick: Dynamically set broadcast irq affinity
Git-Commit-ID: d2348fb6fdc6d671ad45b62db237f76c8c115603
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 07 Mar 2013 08:33:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2348fb6fdc6d671ad45b62db237f76c8c115603
Gitweb:     http://git.kernel.org/tip/d2348fb6fdc6d671ad45b62db237f76c8c115603
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Sat, 2 Mar 2013 11:10:11 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 7 Mar 2013 16:13:26 +0100

tick: Dynamically set broadcast irq affinity

When a cpu goes to a deep idle state where its local timer is
shutdown, it notifies the time frame work to use the broadcast timer
instead.  Unfortunately, the broadcast device could wake up any CPU,
including an idle one which is not concerned by the wake up at all. So
in the worst case an idle CPU will wake up to send an IPI to the CPU
whose timer expired.

Provide an opt-in feature CLOCK_EVT_FEAT_DYNIRQ which tells the core
that is should set the interrupt affinity of the broadcast interrupt
to the cpu which has the earliest expiry time. This avoids unnecessary
spurious wakeups and IPIs.

[ tglx: Adopted to cpumask rework, silenced an uninitialized warning,
  massaged changelog ]

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: viresh.kumar@linaro.org
Cc: jacob.jun.pan@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: santosh.shilimkar@ti.com
Cc: linaro-kernel@lists.linaro.org
Cc: patches@linaro.org
Cc: rickard.andersson@stericsson.com
Cc: vincent.guittot@linaro.org
Cc: linus.walleij@stericsson.com
Cc: john.stultz@linaro.org
Link: http://lkml.kernel.org/r/1362219013-18173-3-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h   |  5 +++++
 kernel/time/tick-broadcast.c | 39 +++++++++++++++++++++++++++++++--------
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 6634652..494d33e 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -55,6 +55,11 @@ enum clock_event_nofitiers {
 #define CLOCK_EVT_FEAT_C3STOP		0x000008
 #define CLOCK_EVT_FEAT_DUMMY		0x000010
 
+/*
+ * Core shall set the interrupt affinity dynamically in broadcast mode
+ */
+#define CLOCK_EVT_FEAT_DYNIRQ		0x000020
+
 /**
  * struct clock_event_device - clock event device descriptor
  * @event_handler:	Assigned by the framework to be called by the low
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 70dd98c..380910d 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -401,13 +401,34 @@ struct cpumask *tick_get_broadcast_oneshot_mask(void)
 	return tick_broadcast_oneshot_mask;
 }
 
-static int tick_broadcast_set_event(struct clock_event_device *bc,
+/*
+ * Set broadcast interrupt affinity
+ */
+static void tick_broadcast_set_affinity(struct clock_event_device *bc,
+					const struct cpumask *cpumask)
+{
+	if (!(bc->features & CLOCK_EVT_FEAT_DYNIRQ))
+		return;
+
+	if (cpumask_equal(bc->cpumask, cpumask))
+		return;
+
+	bc->cpumask = cpumask;
+	irq_set_affinity(bc->irq, bc->cpumask);
+}
+
+static int tick_broadcast_set_event(struct clock_event_device *bc, int cpu,
 				    ktime_t expires, int force)
 {
+	int ret;
+
 	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
-	return clockevents_program_event(bc, expires, force);
+	ret = clockevents_program_event(bc, expires, force);
+	if (!ret)
+		tick_broadcast_set_affinity(bc, cpumask_of(cpu));
+	return ret;
 }
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
@@ -436,7 +457,7 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 {
 	struct tick_device *td;
 	ktime_t now, next_event;
-	int cpu;
+	int cpu, next_cpu = 0;
 
 	raw_spin_lock(&tick_broadcast_lock);
 again:
@@ -447,10 +468,12 @@ again:
 	/* Find all expired events */
 	for_each_cpu(cpu, tick_broadcast_oneshot_mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
-		if (td->evtdev->next_event.tv64 <= now.tv64)
+		if (td->evtdev->next_event.tv64 <= now.tv64) {
 			cpumask_set_cpu(cpu, tmpmask);
-		else if (td->evtdev->next_event.tv64 < next_event.tv64)
+		} else if (td->evtdev->next_event.tv64 < next_event.tv64) {
 			next_event.tv64 = td->evtdev->next_event.tv64;
+			next_cpu = cpu;
+		}
 	}
 
 	/*
@@ -473,7 +496,7 @@ again:
 		 * Rearm the broadcast device. If event expired,
 		 * repeat the above
 		 */
-		if (tick_broadcast_set_event(dev, next_event, 0))
+		if (tick_broadcast_set_event(dev, next_cpu, next_event, 0))
 			goto again;
 	}
 	raw_spin_unlock(&tick_broadcast_lock);
@@ -515,7 +538,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(bc, dev->next_event, 1);
+				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
 		}
 	} else {
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
@@ -581,7 +604,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 			tick_broadcast_init_next_event(tmpmask,
 						       tick_next_period);
-			tick_broadcast_set_event(bc, tick_next_period, 1);
+			tick_broadcast_set_event(bc, cpu, tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
 	} else {
