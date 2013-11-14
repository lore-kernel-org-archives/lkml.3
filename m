Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3KNQe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:34:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46511 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127Ab3KNQdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:33:54 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v3 6/7] extcon: arizona: Factor out different headphone detection IPs
Date: Thu, 14 Nov 2013 16:18:26 +0000
Message-Id: <1384445907-12859-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factors out each headphone detection IP in a seperate
function this makes the code a little more readable and prevents us
getting to excessive levels of indentation.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |  215 +++++++++++++++++++++++---------------
 1 files changed, 130 insertions(+), 85 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index f4fe2d1..d71a738 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -354,7 +354,31 @@ static struct {
 	{ 1000, 10000 },
 };
 
-static int arizona_hpdet_read(struct arizona_extcon_info *info)
+static int arizona_hpdet_read_ip0(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_2, &val);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read HPDET status: %d\n",
+			ret);
+		return ret;
+	}
+
+
+	if (!(val & ARIZONA_HP_DONE)) {
+		dev_err(arizona->dev, "HPDET did not complete: %x\n", val);
+		return -EAGAIN;
+	}
+
+	val &= ARIZONA_HP_LVL_MASK;
+
+	return val;
+}
+
+static int arizona_hpdet_read_ip1(struct arizona_extcon_info *info)
 {
 	struct arizona *arizona = info->arizona;
 	unsigned int val, range;
@@ -367,106 +391,127 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		return ret;
 	}
 
-	switch (info->hpdet_ip) {
-	case 0:
-		if (!(val & ARIZONA_HP_DONE)) {
-			dev_err(arizona->dev, "HPDET did not complete: %x\n",
-				val);
-			return -EAGAIN;
-		}
+	if (!(val & ARIZONA_HP_DONE_B)) {
+		dev_err(arizona->dev, "HPDET did not complete: %x\n", val);
+		return -EAGAIN;
+	}
 
-		val &= ARIZONA_HP_LVL_MASK;
-		break;
+	ret = regmap_read(arizona->regmap, ARIZONA_HP_DACVAL, &val);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read HP value: %d\n", ret);
+		return -EAGAIN;
+	}
 
-	case 1:
-		if (!(val & ARIZONA_HP_DONE_B)) {
-			dev_err(arizona->dev, "HPDET did not complete: %x\n",
-				val);
-			return -EAGAIN;
-		}
+	regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
+	range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
+		   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
 
-		ret = regmap_read(arizona->regmap, ARIZONA_HP_DACVAL, &val);
-		if (ret != 0) {
-			dev_err(arizona->dev, "Failed to read HP value: %d\n",
-				ret);
-			return -EAGAIN;
-		}
+	if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
+	    (val < 100 || val >= 0x3fb)) {
+		range++;
+		dev_dbg(arizona->dev, "Moving to HPDET range %d\n", range);
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_HEADPHONE_DETECT_1,
+				   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
+				   range <<
+				   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
+		return -EAGAIN;
+	}
 
-		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
-			    &range);
-		range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
-			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
+	/* If we go out of range report top of range */
+	if (val < 100 || val >= 0x3fb) {
+		dev_dbg(arizona->dev, "Measurement out of range\n");
+		return ARIZONA_HPDET_MAX;
+	}
 
-		if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
-		    (val < 100 || val >= 0x3fb)) {
-			range++;
-			dev_dbg(arizona->dev, "Moving to HPDET range %d\n",
-				range);
-			regmap_update_bits(arizona->regmap,
-					   ARIZONA_HEADPHONE_DETECT_1,
-					   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
-					   range <<
-					   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
-			return -EAGAIN;
-		}
+	dev_dbg(arizona->dev, "HPDET read %d in range %d\n", val, range);
 
-		/* If we go out of range report top of range */
-		if (val < 100 || val >= 0x3fb) {
-			dev_dbg(arizona->dev, "Measurement out of range\n");
-			return ARIZONA_HPDET_MAX;
-		}
+	val = arizona_hpdet_b_ranges[range].factor_b
+		/ ((val * 100) - arizona_hpdet_b_ranges[range].factor_a);
+
+	return val;
+}
+
+static int arizona_hpdet_read_ip2(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	unsigned int val, range;
+	int ret;
+
+	ret = regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_2, &val);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read HPDET status: %d\n",
+			ret);
+		return ret;
+	}
+
+	if (!(val & ARIZONA_HP_DONE_B)) {
+		dev_err(arizona->dev, "HPDET did not complete: %x\n", val);
+		return -EAGAIN;
+	}
+
+	val &= ARIZONA_HP_LVL_B_MASK;
+	/* Convert to ohms, the value is in 0.5 ohm increments */
+	val /= 2;
+
+	regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
+	range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
+		   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
+
+	/* Skip up a range, or report? */
+	if (range < ARRAY_SIZE(arizona_hpdet_c_ranges) - 1 &&
+	    (val >= arizona_hpdet_c_ranges[range].max)) {
+		range++;
+		dev_dbg(arizona->dev, "Moving to HPDET range %d-%d\n",
+			arizona_hpdet_c_ranges[range].min,
+			arizona_hpdet_c_ranges[range].max);
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_HEADPHONE_DETECT_1,
+				   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
+				   range <<
+				   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
+		return -EAGAIN;
+	}
+
+	if (range && (val < arizona_hpdet_c_ranges[range].min)) {
+		dev_dbg(arizona->dev, "Reporting range boundary %d\n",
+			arizona_hpdet_c_ranges[range].min);
+		val = arizona_hpdet_c_ranges[range].min;
+	}
+
+	return val;
+}
 
-		dev_dbg(arizona->dev, "HPDET read %d in range %d\n",
-			val, range);
+static int arizona_hpdet_read(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	int ret = 0;
 
-		val = arizona_hpdet_b_ranges[range].factor_b
-			/ ((val * 100) -
-			   arizona_hpdet_b_ranges[range].factor_a);
+	switch (info->hpdet_ip) {
+	case 0:
+		ret = arizona_hpdet_read_ip0(info);
+		if (ret < 0)
+			return ret;
+		break;
+
+	case 1:
+		ret = arizona_hpdet_read_ip1(info);
+		if (ret < 0)
+			return ret;
 		break;
 
 	default:
 		dev_warn(arizona->dev, "Unknown HPDET IP revision %d\n",
 			 info->hpdet_ip);
 	case 2:
-		if (!(val & ARIZONA_HP_DONE_B)) {
-			dev_err(arizona->dev, "HPDET did not complete: %x\n",
-				val);
-			return -EAGAIN;
-		}
-
-		val &= ARIZONA_HP_LVL_B_MASK;
-		/* Convert to ohms, the value is in 0.5 ohm increments */
-		val /= 2;
-
-		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
-			    &range);
-		range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
-			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
-
-		/* Skip up a range, or report? */
-		if (range < ARRAY_SIZE(arizona_hpdet_c_ranges) - 1 &&
-		    (val >= arizona_hpdet_c_ranges[range].max)) {
-			range++;
-			dev_dbg(arizona->dev, "Moving to HPDET range %d-%d\n",
-				arizona_hpdet_c_ranges[range].min,
-				arizona_hpdet_c_ranges[range].max);
-			regmap_update_bits(arizona->regmap,
-					   ARIZONA_HEADPHONE_DETECT_1,
-					   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
-					   range <<
-					   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
-			return -EAGAIN;
-		}
-
-		if (range && (val < arizona_hpdet_c_ranges[range].min)) {
-			dev_dbg(arizona->dev, "Reporting range boundary %d\n",
-				arizona_hpdet_c_ranges[range].min);
-			val = arizona_hpdet_c_ranges[range].min;
-		}
+		ret = arizona_hpdet_read_ip2(info);
+		if (ret < 0)
+			return ret;
+		break;
 	}
 
-	dev_dbg(arizona->dev, "HP impedance %d ohms\n", val);
-	return val;
+	dev_dbg(arizona->dev, "HP impedance %d ohms\n", ret);
+	return ret;
 }
 
 static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
-- 
1.7.2.5

