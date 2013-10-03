Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3JCP6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:58:38 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64202 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3JCP6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:58:35 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 14/16] cpuidle: don't calculate time-diff if entered_state < 0
Date: Thu,  3 Oct 2013 21:26:53 +0530
Message-Id: <0a0c8e4c6fbf681d375f25b0c0eba036b8eaadf7.1380815504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If entered_state < 0, we don't need to set dev->last_residency to 'diff' as we
will be setting it to zero without using its new value.

And so move calculation of diff also inside the "if" statement.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/cpuidle.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index b45257a..1a6e9f5 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -77,23 +77,22 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 
 	struct cpuidle_state *target_state = &drv->states[index];
 	ktime_t time_start, time_end;
-	s64 diff;
 
 	time_start = ktime_get();
 
 	entered_state = target_state->enter(dev, drv, index);
 
-	time_end = ktime_get();
+	if (entered_state >= 0) {
+		s64 diff;
 
-	local_irq_enable();
+		time_end = ktime_get();
+		diff = ktime_to_us(ktime_sub(time_end, time_start));
 
-	diff = ktime_to_us(ktime_sub(time_end, time_start));
-	if (diff > INT_MAX)
-		diff = INT_MAX;
+		if (diff > INT_MAX)
+			diff = INT_MAX;
 
-	dev->last_residency = (int) diff;
+		dev->last_residency = (int) diff;
 
-	if (entered_state >= 0) {
 		/* Update cpuidle counters */
 		/* This can be moved to within driver enter routine
 		 * but that results in multiple copies of same code.
@@ -104,6 +103,8 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 		dev->last_residency = 0;
 	}
 
+	local_irq_enable();
+
 	return entered_state;
 }
 
-- 
1.7.12.rc2.18.g61b472e

