Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570Ab3CZPkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:40:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49970 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965244Ab3CZPkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:40:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] extcon: arizona: Fix interaction between headphone outputs and identification
Date: Tue, 26 Mar 2013 15:40:33 +0000
Message-Id: <1364312433-589-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364312433-589-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130326154014.GD18316@opensource.wolfsonmicro.com>
 <1364312433-589-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running HPDET while the headphone outputs are enabled can disrupt the
operation of HPDET. In order to avoid this HPDET needs to disable the
headphone outputs and ASoC needs to not enable them while HPDET is
running.

For extcon instead of checking if the headphone output is enabled when
doing magic application unconditionally disable the output and restore
the state which ASoC wants set when undoing the magic.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   44 ++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 896a923..b289279 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -104,29 +104,45 @@ static void arizona_extcon_do_magic(struct arizona_extcon_info *info,
 				    unsigned int magic)
 {
 	struct arizona *arizona = info->arizona;
-	unsigned int val;
 	int ret;
 
 	mutex_lock(&arizona->dapm->card->dapm_mutex);
 
-	ret = regmap_read(arizona->regmap, ARIZONA_OUTPUT_ENABLES_1, &val);
-	if (ret != 0) {
-		dev_err(arizona->dev, "Failed to read output enables: %d\n",
-			ret);
-		val = 0;
-	}
+	arizona->hpdet_magic = magic;
 
-	if (!(val & (ARIZONA_OUT1L_ENA | ARIZONA_OUT1R_ENA))) {
-		ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000,
-					 magic);
+	/* Keep the HP output stages disabled while doing the magic */
+	if (magic) {
+		ret = regmap_update_bits(arizona->regmap,
+					 ARIZONA_OUTPUT_ENABLES_1,
+					 ARIZONA_OUT1L_ENA |
+					 ARIZONA_OUT1R_ENA, 0);
 		if (ret != 0)
-			dev_warn(arizona->dev, "Failed to do magic: %d\n",
+			dev_warn(arizona->dev,
+				"Failed to disable headphone outputs: %d\n",
+				 ret);
+	}
+
+	ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000,
+				 magic);
+	if (ret != 0)
+		dev_warn(arizona->dev, "Failed to do magic: %d\n",
 				 ret);
 
-		ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000,
-					 magic);
+	ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000,
+				 magic);
+	if (ret != 0)
+		dev_warn(arizona->dev, "Failed to do magic: %d\n",
+			 ret);
+
+	/* Restore the desired state while not doing the magic */
+	if (!magic) {
+		ret = regmap_update_bits(arizona->regmap,
+					 ARIZONA_OUTPUT_ENABLES_1,
+					 ARIZONA_OUT1L_ENA |
+					 ARIZONA_OUT1R_ENA, arizona->hp_ena);
 		if (ret != 0)
-			dev_warn(arizona->dev, "Failed to do magic: %d\n",
+			dev_warn(arizona->dev,
+				 "Failed to restore headphone outputs: %d\n",
 				 ret);
 	}
 
-- 
1.7.10.4

