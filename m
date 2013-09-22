Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3IVBWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:22:31 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38603 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3IVBW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:22:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/21] cpuidle: reduce code duplication inside cpuidle_idle_call()
Date: Sun, 22 Sep 2013 06:51:02 +0530
Message-Id: <5e4629515deb76208df205210a77b1e8a9984f79.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are doing this twice in cpuidle_idle_call() routine:
	drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP

Would be better if we actually store this in a local variable and use that. That
would remove code duplication as well as make this piece of code run fast (in
case compiler wasn't able to optimize it earlier)

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/cpuidle.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index b8c63cb..ed67e3c 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -118,6 +118,7 @@ int cpuidle_idle_call(void)
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv;
 	int next_state, entered_state;
+	bool broadcast;
 
 	if (cpuidle_disabled() || !initialized)
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

