Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656Ab3DBLdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:33:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46556 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760311Ab3DBLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 16/16] extcon: arizona: Make mic detection timeout configurable
Date: Tue,  2 Apr 2013 12:32:48 +0100
Message-Id: <1364902368-1123-16-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |   13 ++++++++++---
 include/linux/mfd/arizona/pdata.h |    3 +++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index c7f8eb4..7a1b4a7 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -42,7 +42,7 @@
 #define ARIZONA_HPDET_MAX 10000
 
 #define HPDET_DEBOUNCE 500
-#define MICD_TIMEOUT 2000
+#define DEFAULT_MICD_TIMEOUT 2000
 
 struct arizona_extcon_info {
 	struct device *dev;
@@ -60,6 +60,8 @@ struct arizona_extcon_info {
 	const struct arizona_micd_range *micd_ranges;
 	int num_micd_ranges;
 
+	int micd_timeout;
+
 	bool micd_reva;
 	bool micd_clamp;
 
@@ -889,7 +891,7 @@ static void arizona_micd_detect(struct work_struct *work)
 handled:
 	if (info->detecting)
 		schedule_delayed_work(&info->micd_timeout_work,
-				      msecs_to_jiffies(MICD_TIMEOUT));
+				      msecs_to_jiffies(info->micd_timeout));
 
 	pm_runtime_mark_last_busy(info->dev);
 	mutex_unlock(&info->lock);
@@ -970,7 +972,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 
 		if (cancelled_mic)
 			schedule_delayed_work(&info->micd_timeout_work,
-					      msecs_to_jiffies(MICD_TIMEOUT));
+					      msecs_to_jiffies(info->micd_timeout));
 
 		goto out;
 	}
@@ -1027,6 +1029,11 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 				   ARIZONA_MICD_CLAMP_DB | ARIZONA_JD1_DB);
 	}
 
+	if (arizona->pdata.micd_timeout)
+		info->micd_timeout = arizona->pdata.micd_timeout;
+	else
+		info->micd_timeout = DEFAULT_MICD_TIMEOUT;
+
 	/* Clear trig_sts to make sure DCVDD is not forced up */
 	regmap_write(arizona->regmap, ARIZONA_AOD_WKUP_AND_TRIG,
 		     ARIZONA_MICD_CLAMP_FALL_TRIG_STS |
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 3ef300b..a0f9409 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -149,6 +149,9 @@ struct arizona_pdata {
 	/** Mic detect debounce level */
 	int micd_dbtime;
 
+	/** Mic detect timeout (ms) */
+	int micd_timeout;
+
 	/** Force MICBIAS on for mic detect */
 	bool micd_force_micbias;
 
-- 
1.7.10.4

