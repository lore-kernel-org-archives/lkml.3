Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3KNQek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:34:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46508 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755165Ab3KNQdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:33:55 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v3 7/7] extcon: arizona: Improve headphone detection error handling
Date: Thu, 14 Nov 2013 16:18:27 +0000
Message-Id: <1384445907-12859-7-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In several places the return value of regmap operations is not checked
whilst handling headphone detection. This patch adds checks for these
return values. Additionally, failing to read/write a register is a
serious enough error we should abort the headphone detection process so
correct a couple of cases where this was not the case.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   82 ++++++++++++++++++++++++++++----------
 1 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index d71a738..321dcc9 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -399,22 +399,32 @@ static int arizona_hpdet_read_ip1(struct arizona_extcon_info *info)
 	ret = regmap_read(arizona->regmap, ARIZONA_HP_DACVAL, &val);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to read HP value: %d\n", ret);
-		return -EAGAIN;
+		return ret;
 	}
 
-	regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
+	ret = regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
 	range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
 		   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read HP range: %d\n", ret);
+		return ret;
+	}
 
 	if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
 	    (val < 100 || val >= 0x3fb)) {
 		range++;
 		dev_dbg(arizona->dev, "Moving to HPDET range %d\n", range);
-		regmap_update_bits(arizona->regmap,
-				   ARIZONA_HEADPHONE_DETECT_1,
-				   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
-				   range <<
-				   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
+		ret = regmap_update_bits(arizona->regmap,
+					 ARIZONA_HEADPHONE_DETECT_1,
+					 ARIZONA_HP_IMPEDANCE_RANGE_MASK,
+					 range <<
+					 ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
+		if (ret != 0) {
+			dev_err(arizona->dev,
+				"Failed to move range (%d): %d\n",
+				range, ret);
+			return ret;
+		}
 		return -EAGAIN;
 	}
 
@@ -454,7 +464,11 @@ static int arizona_hpdet_read_ip2(struct arizona_extcon_info *info)
 	/* Convert to ohms, the value is in 0.5 ohm increments */
 	val /= 2;
 
-	regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
+	ret = regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read HP range: %d\n", ret);
+		return ret;
+	}
 	range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
 		   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
 
@@ -465,11 +479,17 @@ static int arizona_hpdet_read_ip2(struct arizona_extcon_info *info)
 		dev_dbg(arizona->dev, "Moving to HPDET range %d-%d\n",
 			arizona_hpdet_c_ranges[range].min,
 			arizona_hpdet_c_ranges[range].max);
-		regmap_update_bits(arizona->regmap,
+		ret = regmap_update_bits(arizona->regmap,
 				   ARIZONA_HEADPHONE_DETECT_1,
 				   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
 				   range <<
 				   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
+		if (ret != 0) {
+			dev_err(arizona->dev,
+				"Failed to move range (%d): %d\n",
+				range, ret);
+			return ret;
+		}
 		return -EAGAIN;
 	}
 
@@ -519,6 +539,7 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
 {
 	struct arizona *arizona = info->arizona;
 	int id_gpio = arizona->pdata.hpdet_id_gpio;
+	int ret;
 
 	/*
 	 * If we're using HPDET for accessory identification we need
@@ -531,18 +552,30 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
 		if (id_gpio && info->num_hpdet_res == 1) {
 			dev_dbg(arizona->dev, "Measuring mic\n");
 
-			regmap_update_bits(arizona->regmap,
-					   ARIZONA_ACCESSORY_DETECT_MODE_1,
-					   ARIZONA_ACCDET_MODE_MASK |
-					   ARIZONA_ACCDET_SRC,
-					   ARIZONA_ACCDET_MODE_HPR |
-					   info->micd_modes[0].src);
+			ret = regmap_update_bits(arizona->regmap,
+					ARIZONA_ACCESSORY_DETECT_MODE_1,
+					ARIZONA_ACCDET_MODE_MASK |
+					ARIZONA_ACCDET_SRC,
+					ARIZONA_ACCDET_MODE_HPR |
+					info->micd_modes[0].src);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to change HPDET source: %d\n",
+					ret);
+				return ret;
+			}
 
 			gpio_set_value_cansleep(id_gpio, 1);
 
-			regmap_update_bits(arizona->regmap,
-					   ARIZONA_HEADPHONE_DETECT_1,
-					   ARIZONA_HP_POLL, ARIZONA_HP_POLL);
+			ret = regmap_update_bits(arizona->regmap,
+					ARIZONA_HEADPHONE_DETECT_1,
+					ARIZONA_HP_POLL, ARIZONA_HP_POLL);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to re-enable HPDET: %d\n",
+					ret);
+				return ret;
+			}
 			return -EAGAIN;
 		}
 
@@ -575,10 +608,15 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
 		}
 
 		/* Make sure everything is reset back to the real polarity */
-		regmap_update_bits(arizona->regmap,
-				   ARIZONA_ACCESSORY_DETECT_MODE_1,
-				   ARIZONA_ACCDET_SRC,
-				   info->micd_modes[0].src);
+		ret = regmap_update_bits(arizona->regmap,
+					 ARIZONA_ACCESSORY_DETECT_MODE_1,
+					 ARIZONA_ACCDET_SRC,
+					 info->micd_modes[0].src);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to reset polarity: %d\n",
+				ret);
+			return ret;
+		}
 	}
 
 	return 0;
-- 
1.7.2.5

