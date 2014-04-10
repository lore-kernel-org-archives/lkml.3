Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161056AbaDJNoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:44:09 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47910 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030816AbaDJNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:44:07 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rafael.j.wysocki@intel.com, tuukka.tikkanen@linaro.org,
        daniel.lezcano@linaro.org,
        Chander Kashyap <chander.kashyap@linaro.org>
Subject: [PATCH] cpuidle: governor: menu: move repeated correction factor check to init
Date: Thu, 10 Apr 2014 19:13:53 +0530
Message-Id: <1397137433-19106-1-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In menu_select function we check for correction factor every time.
If it is zero we are initializing to unity. Hence move it to init function
and initialise by unity, hence avoid repeated comparisons.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
---
 drivers/cpuidle/governors/menu.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index cf7f2f0..048f6d9 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -315,13 +315,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	multiplier = performance_multiplier();
 
 	/*
-	 * if the correction factor is 0 (eg first time init or cpu hotplug
-	 * etc), we actually want to start out with a unity factor.
-	 */
-	if (data->correction_factor[data->bucket] == 0)
-		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
-
-	/*
 	 * Force the result of multiplication to be 64 bits even if both
 	 * operands are 32 bits.
 	 * Make sure to round up for half microseconds.
@@ -453,9 +446,17 @@ static int menu_enable_device(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev)
 {
 	struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
+	int i;
 
 	memset(data, 0, sizeof(struct menu_device));
 
+	/*
+	 * if the correction factor is 0 (eg first time init or cpu hotplug
+	 * etc), we actually want to start out with a unity factor.
+	 */
+	for(i = 0; i < BUCKETS; i++)
+		data->correction_factor[i] = RESOLUTION * DECAY;
+
 	return 0;
 }
 
-- 
1.7.9.5

