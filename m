Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507Ab3DBLdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:33:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46553 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760236Ab3DBLdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 12/16] extcon: arizona: Simplify HPDET based identification
Date: Tue,  2 Apr 2013 12:32:44 +0100
Message-Id: <1364902368-1123-12-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than measuring both HP channels we can simply directly measure the
microphone impedance and then rely on MICDET for final confirmation of the
presence of a suitable microphone. This improves the overall performance
of the identification process.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |   46 ++++++++++++++++++++-----------------
 include/linux/mfd/arizona/pdata.h |    3 +++
 2 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 7c4ce81..a83ca27a 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -459,7 +459,8 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 	return val;
 }
 
-static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
+static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
+			       bool *mic)
 {
 	struct arizona *arizona = info->arizona;
 	int id_gpio = arizona->pdata.hpdet_id_gpio;
@@ -470,11 +471,9 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 	 */
 	if (arizona->pdata.hpdet_acc_id) {
 		info->hpdet_res[info->num_hpdet_res++] = *reading;
-		info->hpdet_res[info->num_hpdet_res++] = *reading;
 
 		/* Only check the mic directly if we didn't already ID it */
-		if (id_gpio && info->num_hpdet_res == 2 &&
-		    !((info->hpdet_res[0] > info->hpdet_res[1] * 2))) {
+		if (id_gpio && info->num_hpdet_res == 1) {
 			dev_dbg(arizona->dev, "Measuring mic\n");
 
 			regmap_update_bits(arizona->regmap,
@@ -493,10 +492,8 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 		}
 
 		/* OK, got both.  Now, compare... */
-		dev_dbg(arizona->dev, "HPDET measured %d %d %d\n",
-			info->hpdet_res[0], info->hpdet_res[1],
-			info->hpdet_res[2]);
-
+		dev_dbg(arizona->dev, "HPDET measured %d %d\n",
+			info->hpdet_res[0], info->hpdet_res[1]);
 
 		/* Take the headphone impedance for the main report */
 		*reading = info->hpdet_res[0];
@@ -512,13 +509,11 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 		}
 
 		/*
-		 * Either the two grounds measure differently or we
-		 * measure the mic as high impedance.
+		 * If we measure the mic as 
 		 */
-		if ((info->hpdet_res[0] > info->hpdet_res[1] * 2) ||
-		    (id_gpio && info->hpdet_res[2] > 1257)) {
+		if (!id_gpio || info->hpdet_res[1] > 50) {
 			dev_dbg(arizona->dev, "Detected mic\n");
-			info->mic = true;
+			*mic = true;
 			info->detecting = true;
 		} else {
 			dev_dbg(arizona->dev, "Detected headphone\n");
@@ -541,6 +536,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	int id_gpio = arizona->pdata.hpdet_id_gpio;
 	int report = ARIZONA_CABLE_HEADPHONE;
 	int ret, reading;
+	bool mic = false;
 
 	mutex_lock(&info->lock);
 
@@ -576,7 +572,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 			   ARIZONA_HP_IMPEDANCE_RANGE_MASK | ARIZONA_HP_POLL,
 			   0);
 
-	ret = arizona_hpdet_do_id(info, &reading);
+	ret = arizona_hpdet_do_id(info, &reading, &mic);
 	if (ret == -EAGAIN) {
 		goto out;
 	} else if (ret < 0) {
@@ -606,7 +602,7 @@ done:
 			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
 
 	/* If we have a mic then reenable MICDET */
-	if (info->mic)
+	if (mic || info->mic)
 		arizona_start_mic(info);
 
 	if (info->hpdet_active) {
@@ -681,6 +677,8 @@ err:
 static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 {
 	struct arizona *arizona = info->arizona;
+	int hp_reading = 32;
+	bool mic;
 	int ret;
 
 	dev_dbg(arizona->dev, "Starting identification via HPDET\n");
@@ -702,12 +700,18 @@ static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 		goto err;
 	}
 
-	ret = regmap_update_bits(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
-				 ARIZONA_HP_POLL, ARIZONA_HP_POLL);
-	if (ret != 0) {
-		dev_err(arizona->dev, "Can't start HPDETL measurement: %d\n",
-			ret);
-		goto err;
+	if (arizona->pdata.hpdet_acc_id_line) {
+		ret = regmap_update_bits(arizona->regmap,
+					 ARIZONA_HEADPHONE_DETECT_1,
+					 ARIZONA_HP_POLL, ARIZONA_HP_POLL);
+		if (ret != 0) {
+			dev_err(arizona->dev,
+				"Can't start HPDETL measurement: %d\n",
+				ret);
+			goto err;
+		}
+	} else {
+		arizona_hpdet_do_id(info, &hp_reading, &mic);
 	}
 
 	return;
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 008b8c4..45c8477 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -128,6 +128,9 @@ struct arizona_pdata {
 	/** Use the headphone detect circuit to identify the accessory */
 	bool hpdet_acc_id;
 
+	/** Check for line output with HPDET method */
+	bool hpdet_acc_id_line;
+
 	/** GPIO used for mic isolation with HPDET */
 	int hpdet_id_gpio;
 
-- 
1.7.10.4

