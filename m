Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab3BUWBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:01:34 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:60730 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3BUWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:01:30 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: santosh.shilimkar@ti.com, linux-pm@vger.kernel.org, fweisbec@gmail.com,
        john.stultz@linaro.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 2/2][RFC] time : set broadcast irq affinity
Date: Thu, 21 Feb 2013 23:01:23 +0100
Message-Id: <1361484083-5906-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361484083-5906-1-git-send-email-daniel.lezcano@linaro.org>
References: <5123C299.3080005@linaro.org>
 <1361484083-5906-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cpu goes to a deep idle state where its local timer is shutdown,
it notifies the time frame work to use the broadcast timer instead.

Unfortunately, the broadcast device could wake up any CPU, including an
idle one which is not concerned by the wake up at all.

This implies, in the worst case, an idle CPU will wake up to send an IPI
to another idle cpu.

This patch solves this by setting the irq affinity to the cpu concerned
by the nearest timer event, by this way, the CPU which is wake up is
guarantee to be the one concerned by the next event and we are safe with
unnecessary wakeup for another idle CPU.

As the irq affinity is not supported by all the archs, a flag is needed
to specify which clocksource can handle it.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 include/linux/clockchips.h   |    1 +
 kernel/time/tick-broadcast.c |   39 ++++++++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 8a7096f..5cedb27 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -54,6 +54,7 @@ enum clock_event_nofitiers {
  */
 #define CLOCK_EVT_FEAT_C3STOP		0x000008
 #define CLOCK_EVT_FEAT_DUMMY		0x000010
+#define CLOCK_EVT_FEAT_DYNIRQ		0x000020
 
 /**
  * struct clock_event_device - clock event device descriptor
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index baf9b0e7..cbd6737 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -370,13 +370,36 @@ struct cpumask *tick_get_broadcast_oneshot_mask(void)
 	return to_cpumask(tick_broadcast_oneshot_mask);
 }
 
-static int tick_broadcast_set_event(struct clock_event_device *bc,
+/*
+ * Set broadcast interrupt affinity
+ */
+static void tick_broadcast_set_affinity(struct clock_event_device *bc, int cpu)
+{
+	struct cpumask cpumask;
+
+	if (!(bc->features & CLOCK_EVT_FEAT_DYNIRQ))
+		return;
+
+	cpumask_clear(&cpumask);
+	cpumask_set_cpu(cpu, &cpumask);
+	irq_set_affinity(bc->irq, &cpumask);
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
+	if (ret)
+		return ret;
+
+	tick_broadcast_set_affinity(bc, cpu);
+
+	return 0;
 }
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
@@ -405,7 +428,7 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 {
 	struct tick_device *td;
 	ktime_t now, next_event;
-	int cpu;
+	int cpu, next_cpu;
 
 	raw_spin_lock(&tick_broadcast_lock);
 again:
@@ -418,8 +441,10 @@ again:
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
 			cpumask_set_cpu(cpu, to_cpumask(tmpmask));
-		else if (td->evtdev->next_event.tv64 < next_event.tv64)
+		else if (td->evtdev->next_event.tv64 < next_event.tv64) {
 			next_event.tv64 = td->evtdev->next_event.tv64;
+			next_cpu = cpu;
+		}
 	}
 
 	/*
@@ -442,7 +467,7 @@ again:
 		 * Rearm the broadcast device. If event expired,
 		 * repeat the above
 		 */
-		if (tick_broadcast_set_event(dev, next_event, 0))
+		if (tick_broadcast_set_event(dev, next_cpu, next_event, 0))
 			goto again;
 	}
 	raw_spin_unlock(&tick_broadcast_lock);
@@ -485,7 +510,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(bc, dev->next_event, 1);
+				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
 		}
 	} else {
 		if (cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
@@ -554,7 +579,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 			tick_broadcast_init_next_event(to_cpumask(tmpmask),
 						       tick_next_period);
-			tick_broadcast_set_event(bc, tick_next_period, 1);
+			tick_broadcast_set_event(bc, cpu, tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
 	} else {
-- 
1.7.9.5

