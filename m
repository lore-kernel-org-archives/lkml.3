Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab3BUWB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:01:56 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45531 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3BUWB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:01:28 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: santosh.shilimkar@ti.com, linux-pm@vger.kernel.org, fweisbec@gmail.com,
        john.stultz@linaro.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 1/2] time : pass broadcast device parameter
Date: Thu, 21 Feb 2013 23:01:22 +0100
Message-Id: <1361484083-5906-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <5123C299.3080005@linaro.org>
References: <5123C299.3080005@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The broadcast timer could be passed as parameter to the function
instead of using again tick_broadcast_device.evtdev which was
previously used in the caller function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/time/tick-broadcast.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..baf9b0e7 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -370,10 +370,9 @@ struct cpumask *tick_get_broadcast_oneshot_mask(void)
 	return to_cpumask(tick_broadcast_oneshot_mask);
 }
 
-static int tick_broadcast_set_event(ktime_t expires, int force)
+static int tick_broadcast_set_event(struct clock_event_device *bc,
+				    ktime_t expires, int force)
 {
-	struct clock_event_device *bc = tick_broadcast_device.evtdev;
-
 	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
@@ -443,7 +442,7 @@ again:
 		 * Rearm the broadcast device. If event expired,
 		 * repeat the above
 		 */
-		if (tick_broadcast_set_event(next_event, 0))
+		if (tick_broadcast_set_event(dev, next_event, 0))
 			goto again;
 	}
 	raw_spin_unlock(&tick_broadcast_lock);
@@ -486,7 +485,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(dev->next_event, 1);
+				tick_broadcast_set_event(bc, dev->next_event, 1);
 		}
 	} else {
 		if (cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
@@ -555,7 +554,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 			tick_broadcast_init_next_event(to_cpumask(tmpmask),
 						       tick_next_period);
-			tick_broadcast_set_event(tick_next_period, 1);
+			tick_broadcast_set_event(bc, tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
 	} else {
-- 
1.7.9.5

