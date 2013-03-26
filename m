Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558Ab3CZPkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:40:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49960 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965170Ab3CZPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:40:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] extcon: arizona: Factor out magic application
Date: Tue, 26 Mar 2013 15:40:31 +0000
Message-Id: <1364312433-589-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130326154014.GD18316@opensource.wolfsonmicro.com>
References: <20130326154014.GD18316@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a very similar sequence doing magic writes in several places
(one of which missed an update to interlock with the CODEC driver) so
factor it out into a function.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   91 ++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 55 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index dc357a4..896a923 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -100,6 +100,39 @@ static const char *arizona_cable[] = {
 	NULL,
 };
 
+static void arizona_extcon_do_magic(struct arizona_extcon_info *info,
+				    unsigned int magic)
+{
+	struct arizona *arizona = info->arizona;
+	unsigned int val;
+	int ret;
+
+	mutex_lock(&arizona->dapm->card->dapm_mutex);
+
+	ret = regmap_read(arizona->regmap, ARIZONA_OUTPUT_ENABLES_1, &val);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read output enables: %d\n",
+			ret);
+		val = 0;
+	}
+
+	if (!(val & (ARIZONA_OUT1L_ENA | ARIZONA_OUT1R_ENA))) {
+		ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000,
+					 magic);
+		if (ret != 0)
+			dev_warn(arizona->dev, "Failed to do magic: %d\n",
+				 ret);
+
+		ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000,
+					 magic);
+		if (ret != 0)
+			dev_warn(arizona->dev, "Failed to do magic: %d\n",
+				 ret);
+	}
+
+	mutex_unlock(&arizona->dapm->card->dapm_mutex);
+}
+
 static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 {
 	struct arizona *arizona = info->arizona;
@@ -484,7 +517,6 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	struct arizona *arizona = info->arizona;
 	int id_gpio = arizona->pdata.hpdet_id_gpio;
 	int report = ARIZONA_CABLE_HEADPHONE;
-	unsigned int val;
 	int ret, reading;
 
 	mutex_lock(&info->lock);
@@ -539,28 +571,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 		dev_err(arizona->dev, "Failed to report HP/line: %d\n",
 			ret);
 
-	mutex_lock(&arizona->dapm->card->dapm_mutex);
-
-	ret = regmap_read(arizona->regmap, ARIZONA_OUTPUT_ENABLES_1, &val);
-	if (ret != 0) {
-		dev_err(arizona->dev, "Failed to read output enables: %d\n",
-			ret);
-		val = 0;
-	}
-
-	if (!(val & (ARIZONA_OUT1L_ENA | ARIZONA_OUT1R_ENA))) {
-		ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0);
-		if (ret != 0)
-			dev_warn(arizona->dev, "Failed to undo magic: %d\n",
-				 ret);
-
-		ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000, 0);
-		if (ret != 0)
-			dev_warn(arizona->dev, "Failed to undo magic: %d\n",
-				 ret);
-	}
-
-	mutex_unlock(&arizona->dapm->card->dapm_mutex);
+	arizona_extcon_do_magic(info, 0);
 
 done:
 	if (id_gpio)
@@ -606,13 +617,7 @@ static void arizona_identify_headphone(struct arizona_extcon_info *info)
 	if (info->mic)
 		arizona_stop_mic(info);
 
-	ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0x4000);
-	if (ret != 0)
-		dev_warn(arizona->dev, "Failed to do magic: %d\n", ret);
-
-	ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000, 0x4000);
-	if (ret != 0)
-		dev_warn(arizona->dev, "Failed to do magic: %d\n", ret);
+	arizona_extcon_do_magic(info, 0x4000);
 
 	ret = regmap_update_bits(arizona->regmap,
 				 ARIZONA_ACCESSORY_DETECT_MODE_1,
@@ -653,7 +658,6 @@ err:
 static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 {
 	struct arizona *arizona = info->arizona;
-	unsigned int val;
 	int ret;
 
 	dev_dbg(arizona->dev, "Starting identification via HPDET\n");
@@ -665,30 +669,7 @@ static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 
 	arizona_extcon_pulse_micbias(info);
 
-	mutex_lock(&arizona->dapm->card->dapm_mutex);
-
-	ret = regmap_read(arizona->regmap, ARIZONA_OUTPUT_ENABLES_1, &val);
-	if (ret != 0) {
-		dev_err(arizona->dev, "Failed to read output enables: %d\n",
-			ret);
-		val = 0;
-	}
-
-	if (!(val & (ARIZONA_OUT1L_ENA | ARIZONA_OUT1R_ENA))) {
-		ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000,
-					 0x4000);
-		if (ret != 0)
-			dev_warn(arizona->dev, "Failed to do magic: %d\n",
-				 ret);
-
-		ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000,
-					 0x4000);
-		if (ret != 0)
-			dev_warn(arizona->dev, "Failed to do magic: %d\n",
-				 ret);
-	}
-
-	mutex_unlock(&arizona->dapm->card->dapm_mutex);
+	arizona_extcon_do_magic(info, 0x4000);
 
 	ret = regmap_update_bits(arizona->regmap,
 				 ARIZONA_ACCESSORY_DETECT_MODE_1,
-- 
1.7.10.4

