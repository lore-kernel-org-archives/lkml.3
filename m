Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3JCP6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:58:08 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42700 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab3JCP6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:58:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 09/16] cpuidle: reduce code duplication inside cpuidle_idle_call()
Date: Thu,  3 Oct 2013 21:26:48 +0530
Message-Id: <fcc808789f01e07d7ce93c9959df50a667390c7c.1380815504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are doing this twice in cpuidle_idle_call() routine:
	drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP

Would be better if we actually store this in a local variable and use that. That
would remove code duplication as well as make this piece of code run fast (in
case compiler wasn't able to optimize it earlier)

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/cpuidle.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 518b542..ffc637a 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -118,6 +118,7 @@ int cpuidle_idle_call(void)
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv;
 	int next_state, entered_state;
+	bool broadcast;
 
 	if (off || !initialized)
 		return -ENODEV;
@@ -141,7 +142,9 @@ int cpuidle_idle_call(void)
 
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
-	if (drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP)
+	broadcast = drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP;
+
+	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
 				   &dev->cpu);
 
@@ -151,7 +154,7 @@ int cpuidle_idle_call(void)
 	else
 		entered_state = cpuidle_enter_state(dev, drv, next_state);
 
-	if (drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP)
+	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
 				   &dev->cpu);
 
-- 
1.7.12.rc2.18.g61b472e

