Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab3BKQ2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:28:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35480 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757967Ab3BKQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 08/11] extcon: arizona: Don't HPDET magic when headphones are enabled
Date: Mon, 11 Feb 2013 16:27:03 +0000
Message-Id: <1360600026-16878-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130211162614.GH4607@opensource.wolfsonmicro.com>
 <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The magic is already done as part of enabling the headphone output so
does not need to be done when the headphone outputs are enabled. We hold
the DAPM lock so the headphone status can't be changed underneath us.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   58 +++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 2ad0e4a..cfd206c 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -489,6 +489,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	struct arizona *arizona = info->arizona;
 	int id_gpio = arizona->pdata.hpdet_id_gpio;
 	int report = ARIZONA_CABLE_HEADPHONE;
+	unsigned int val;
 	int ret, reading;
 
 	mutex_lock(&info->lock);
@@ -543,13 +544,28 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 		dev_err(arizona->dev, "Failed to report HP/line: %d\n",
 			ret);
 
-	ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0);
-	if (ret != 0)
-		dev_warn(arizona->dev, "Failed to undo magic: %d\n", ret);
+	mutex_lock(&arizona->dapm->card->dapm_mutex);
 
-	ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000, 0);
-	if (ret != 0)
-		dev_warn(arizona->dev, "Failed to undo magic: %d\n", ret);
+	ret = regmap_read(arizona->regmap, ARIZONA_OUTPUT_ENABLES_1, &val);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read output enables: %d\n",
+			ret);
+		val = 0;
+	}
+
+	if (!(val & (ARIZONA_OUT1L_ENA | ARIZONA_OUT1R_ENA))) {
+		ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0);
+		if (ret != 0)
+			dev_warn(arizona->dev, "Failed to undo magic: %d\n",
+				 ret);
+
+		ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000, 0);
+		if (ret != 0)
+			dev_warn(arizona->dev, "Failed to undo magic: %d\n",
+				 ret);
+	}
+
+	mutex_unlock(&arizona->dapm->card->dapm_mutex);
 
 done:
 	if (id_gpio)
@@ -637,6 +653,7 @@ err:
 static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 {
 	struct arizona *arizona = info->arizona;
+	unsigned int val;
 	int ret;
 
 	dev_dbg(arizona->dev, "Starting identification via HPDET\n");
@@ -648,13 +665,30 @@ static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 
 	arizona_extcon_pulse_micbias(info);
 
-	ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0x4000);
-	if (ret != 0)
-		dev_warn(arizona->dev, "Failed to do magic: %d\n", ret);
+	mutex_lock(&arizona->dapm->card->dapm_mutex);
 
-	ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000, 0x4000);
-	if (ret != 0)
-		dev_warn(arizona->dev, "Failed to do magic: %d\n", ret);
+	ret = regmap_read(arizona->regmap, ARIZONA_OUTPUT_ENABLES_1, &val);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read output enables: %d\n",
+			ret);
+		val = 0;
+	}
+
+	if (!(val & (ARIZONA_OUT1L_ENA | ARIZONA_OUT1R_ENA))) {
+		ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000,
+					 0x4000);
+		if (ret != 0)
+			dev_warn(arizona->dev, "Failed to do magic: %d\n",
+				 ret);
+
+		ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000,
+					 0x4000);
+		if (ret != 0)
+			dev_warn(arizona->dev, "Failed to do magic: %d\n",
+				 ret);
+	}
+
+	mutex_unlock(&arizona->dapm->card->dapm_mutex);
 
 	ret = regmap_update_bits(arizona->regmap,
 				 ARIZONA_ACCESSORY_DETECT_MODE_1,
-- 
1.7.10.4

