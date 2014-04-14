Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaDNQ2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:28:08 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36457 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDNQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:28:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 35/38] tick-broadcast: do checks before taking locks in tick_do_broadcast_on_off()
Date: Mon, 14 Apr 2014 21:53:57 +0530
Message-Id: <6dd682c8bb0c56f0b40a4ff5ca94acfb536b109f.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the checks which may force tick_do_broadcast_on_off() to return early
can be done before taking locks. This would make these codepaths faster.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-broadcast.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 1597d03..3b07569 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -329,27 +329,22 @@ unlock:
  */
 static void tick_do_broadcast_on_off(unsigned long *reason)
 {
-	struct clock_event_device *bc, *dev;
-	struct tick_device *td;
+	struct tick_device *td = tick_get_cpu_device();
+	struct clock_event_device *bc, *dev = td->evtdev;
+	int cpu = smp_processor_id(), bc_stopped;
 	unsigned long flags;
-	int cpu, bc_stopped;
-
-	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
-
-	cpu = smp_processor_id();
-	td = tick_get_device(cpu);
-	dev = td->evtdev;
-	bc = tick_broadcast_device.evtdev;
 
 	/*
 	 * Is the device not affected by the powerstate ?
 	 */
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_C3STOP))
-		goto out;
+		return;
 
 	if (!tick_device_is_functional(dev))
-		goto out;
+		return;
 
+	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
+	bc = tick_broadcast_device.evtdev;
 	bc_stopped = cpumask_empty(tick_broadcast_mask);
 
 	switch (*reason) {
@@ -385,7 +380,6 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 		else
 			tick_broadcast_setup_oneshot(bc);
 	}
-out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
-- 
1.7.12.rc2.18.g61b472e

