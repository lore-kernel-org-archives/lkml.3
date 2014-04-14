Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaDNQ2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:28:20 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39849 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDNQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:28:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 37/38] tick-broadcast: merge tick_do_broadcast_on_off() into tick_broadcast_on_off()
Date: Mon, 14 Apr 2014 21:53:59 +0530
Message-Id: <38d340f0c559f1ab9475228234c6cc4f0a50e7b6.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have added a wrapper around tick_do_broadcast_on_off() which doesn't have
anything so special that we should keep it. It just had a check if cpu is online
or not. Just merge these two routines and keep one: tick_broadcast_on_off().
This would get rid of an extra function call that we are doing currently.

This also replaces printk(KERN_ERR "**"); with pr_err("**");

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-broadcast.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index ec86227..9d81a81 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -327,13 +327,19 @@ unlock:
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
  */
-static void tick_do_broadcast_on_off(unsigned long *reason)
+void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
 	struct tick_device *td = tick_get_cpu_device();
 	struct clock_event_device *bc, *dev = td->evtdev;
 	int cpu = smp_processor_id(), bc_stopped;
 	unsigned long flags;
 
+	if (!cpumask_test_cpu(*oncpu, cpu_online_mask)) {
+		pr_err("tick-broadcast: ignoring broadcast for offline CPU #%d\n",
+		       *oncpu);
+		return;
+	}
+
 	/*
 	 * Is the device not affected by the powerstate ?
 	 */
@@ -347,7 +353,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	bc = tick_broadcast_device.evtdev;
 	bc_stopped = cpumask_empty(tick_broadcast_mask);
 
-	switch (*reason) {
+	switch (reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		tick_broadcast_force = 1;
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
@@ -383,19 +389,6 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 }
 
 /*
- * Powerstate information: The system enters/leaves a state, where
- * affected devices might stop.
- */
-void tick_broadcast_on_off(unsigned long reason, int *oncpu)
-{
-	if (!cpumask_test_cpu(*oncpu, cpu_online_mask))
-		printk(KERN_ERR "tick-broadcast: ignoring broadcast for offline CPU #%d\n",
-		       *oncpu);
-	else
-		tick_do_broadcast_on_off(&reason);
-}
-
-/*
  * Set the periodic handler depending on broadcast on/off
  */
 void tick_set_periodic_handler(struct clock_event_device *dev, int broadcast)
-- 
1.7.12.rc2.18.g61b472e

