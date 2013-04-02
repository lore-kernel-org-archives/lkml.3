Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595Ab3DBLed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:34:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46554 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760293Ab3DBLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 15/16] extcon: arizona: Allow additional debounce during microphone detection
Date: Tue,  2 Apr 2013 12:32:47 +0100
Message-Id: <1364902368-1123-15-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Help mitigate against mechanical bounce during the initial detection by
allowing the configuration of an additional debounce on top of that the
hardware does during the initial phase of microphone detection operation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |   35 ++++++++++++++++++++++++++++++-----
 include/linux/mfd/arizona/pdata.h |    3 +++
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 26f9a1a..c7f8eb4 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -64,6 +64,7 @@ struct arizona_extcon_info {
 	bool micd_clamp;
 
 	struct delayed_work hpdet_work;
+	struct delayed_work micd_detect_work;
 	struct delayed_work micd_timeout_work;
 
 	bool hpdet_active;
@@ -750,9 +751,11 @@ static void arizona_micd_timeout_work(struct work_struct *work)
 	mutex_unlock(&info->lock);
 }
 
-static irqreturn_t arizona_micdet(int irq, void *data)
+static void arizona_micd_detect(struct work_struct *work)
 {
-	struct arizona_extcon_info *info = data;
+	struct arizona_extcon_info *info = container_of(work,
+							struct arizona_extcon_info,
+							micd_detect_work.work);
 	struct arizona *arizona = info->arizona;
 	unsigned int val = 0, lvl;
 	int ret, i, key;
@@ -766,7 +769,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to read MICDET: %d\n", ret);
 			mutex_unlock(&info->lock);
-			return IRQ_NONE;
+			return;
 		}
 
 		dev_dbg(arizona->dev, "MICDET: %x\n", val);
@@ -774,14 +777,14 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 		if (!(val & ARIZONA_MICD_VALID)) {
 			dev_warn(arizona->dev, "Microphone detection state invalid\n");
 			mutex_unlock(&info->lock);
-			return IRQ_NONE;
+			return;
 		}
 	}
 
 	if (i == 10 && !(val & 0x7fc)) {
 		dev_err(arizona->dev, "Failed to get valid MICDET value\n");
 		mutex_unlock(&info->lock);
-		return IRQ_NONE;
+		return;
 	}
 
 	/* Due to jack detect this should never happen */
@@ -890,6 +893,27 @@ handled:
 
 	pm_runtime_mark_last_busy(info->dev);
 	mutex_unlock(&info->lock);
+}
+
+static irqreturn_t arizona_micdet(int irq, void *data)
+{
+	struct arizona_extcon_info *info = data;
+	struct arizona *arizona = info->arizona;
+	int debounce = arizona->pdata.micd_detect_debounce;
+
+	cancel_delayed_work_sync(&info->micd_detect_work);
+	cancel_delayed_work_sync(&info->micd_timeout_work);
+
+	mutex_lock(&info->lock);
+	if (!info->detecting)
+		debounce = 0;
+	mutex_unlock(&info->lock);
+
+	if (debounce)
+		schedule_delayed_work(&info->micd_detect_work,
+				      msecs_to_jiffies(debounce));
+	else
+		arizona_micd_detect(&info->micd_detect_work.work);
 
 	return IRQ_HANDLED;
 }
@@ -1072,6 +1096,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	info->dev = &pdev->dev;
 	info->last_jackdet = ~(ARIZONA_MICD_CLAMP_STS | ARIZONA_JD1_STS);
 	INIT_DELAYED_WORK(&info->hpdet_work, arizona_hpdet_work);
+	INIT_DELAYED_WORK(&info->micd_detect_work, arizona_micd_detect);
 	INIT_DELAYED_WORK(&info->micd_timeout_work, arizona_micd_timeout_work);
 	platform_set_drvdata(pdev, info);
 
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 45c8477..3ef300b 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -134,6 +134,9 @@ struct arizona_pdata {
 	/** GPIO used for mic isolation with HPDET */
 	int hpdet_id_gpio;
 
+	/** Extra debounce timeout used during initial mic detection (ms) */
+	int micd_detect_debounce;
+
 	/** GPIO for mic detection polarity */
 	int micd_pol_gpio;
 
-- 
1.7.10.4

