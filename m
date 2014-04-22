Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaDVMiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:38:20 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41247 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbaDVMiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:38:18 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: rjw@rjwysocki.net
Cc: tuukka.tikkanen@linaro.org, rafael.j.wysocki@intel.com,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chander Kashyap <chander.kashyap@linaro.org>
Subject: [RESEND][PATCH] cpuidle: governor: menu: move repeated correction factor check to init
Date: Tue, 22 Apr 2014 18:08:04 +0530
Message-Id: <1398170284-7551-1-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CANuQgHFdYhTc8YZ2MbQv0r_CsJGDLwHOqy9NuVDEfVUOTsbRpA@mail.gmail.com>
References: <CANuQgHFdYhTc8YZ2MbQv0r_CsJGDLwHOqy9NuVDEfVUOTsbRpA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In menu_select function we check for correction factor every time.
If it is zero we are initializing to unity. Hence move it to init function
and initialise by unity, hence avoid repeated comparisons.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
Reviewed-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 71b5232..9b7918c 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -311,13 +311,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	data->bucket = which_bucket(data->next_timer_us);
 
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
@@ -466,9 +459,17 @@ static int menu_enable_device(struct cpuidle_driver *drv,
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

