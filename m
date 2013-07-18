Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338Ab3GRVmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:42:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37479 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab3GRVmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:42:49 -0400
From: Mark Brown <broonie@kernel.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Thu, 18 Jul 2013 22:42:22 +0100
Message-Id: <1374183742-6678-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] extcon: arizona: Use power efficient workqueue
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

None of the delayed work the driver schedules has particularly short delays
and it is not performance sensitive so let the scheduler run it wherever
is most efficient rather than in a per CPU workqueue by using the system
power efficient workqueue.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/extcon/extcon-arizona.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 7a1b4a7..e557130 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -890,8 +890,9 @@ static void arizona_micd_detect(struct work_struct *work)
 
 handled:
 	if (info->detecting)
-		schedule_delayed_work(&info->micd_timeout_work,
-				      msecs_to_jiffies(info->micd_timeout));
+		queue_delayed_work(system_power_efficient_wq,
+				   &info->micd_timeout_work,
+				   msecs_to_jiffies(info->micd_timeout));
 
 	pm_runtime_mark_last_busy(info->dev);
 	mutex_unlock(&info->lock);
@@ -912,8 +913,9 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 	mutex_unlock(&info->lock);
 
 	if (debounce)
-		schedule_delayed_work(&info->micd_detect_work,
-				      msecs_to_jiffies(debounce));
+		queue_delayed_work(system_power_efficient_wq,
+				   &info->micd_detect_work,
+				   msecs_to_jiffies(debounce));
 	else
 		arizona_micd_detect(&info->micd_detect_work.work);
 
@@ -967,12 +969,14 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 	if (val == info->last_jackdet) {
 		dev_dbg(arizona->dev, "Suppressing duplicate JACKDET\n");
 		if (cancelled_hp)
-			schedule_delayed_work(&info->hpdet_work,
-					      msecs_to_jiffies(HPDET_DEBOUNCE));
+			queue_delayed_work(system_power_efficient_wq,
+					   &info->hpdet_work,
+					   msecs_to_jiffies(HPDET_DEBOUNCE));
 
 		if (cancelled_mic)
-			schedule_delayed_work(&info->micd_timeout_work,
-					      msecs_to_jiffies(info->micd_timeout));
+			queue_delayed_work(system_power_efficient_wq,
+					   &info->micd_timeout_work,
+					   msecs_to_jiffies(info->micd_timeout));
 
 		goto out;
 	}
@@ -994,8 +998,9 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 
 			arizona_start_mic(info);
 		} else {
-			schedule_delayed_work(&info->hpdet_work,
-					      msecs_to_jiffies(HPDET_DEBOUNCE));
+			queue_delayed_work(system_power_efficient_wq,
+					   &info->hpdet_work,
+					   msecs_to_jiffies(HPDET_DEBOUNCE));
 		}
 
 		regmap_update_bits(arizona->regmap,
-- 
1.8.3.2

