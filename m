Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807Ab3KMSUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:20:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39303 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759201Ab3KMSTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:19:54 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 4/7] extcon: arizona: No need to switch back down HPDET ranges
Date: Wed, 13 Nov 2013 18:04:34 +0000
Message-Id: <1384365877-12355-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384365877-12355-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384365877-12355-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in revisiting ranges the detection will be no more accurate
the second time simply report that the resistance is right on the
range boundry.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 1bae23e..e311c52 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -441,20 +441,7 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
 			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
 
-		/* Skip up or down a range? */
-		if (range && (val < arizona_hpdet_c_ranges[range].min)) {
-			range--;
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
+		/* Skip up a range, or report? */
 		if (range < ARRAY_SIZE(arizona_hpdet_c_ranges) - 1 &&
 		    (val >= arizona_hpdet_c_ranges[range].max)) {
 			range++;
@@ -468,6 +455,12 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 					   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
 			return -EAGAIN;
 		}
+
+		if (range && (val < arizona_hpdet_c_ranges[range].min)) {
+			dev_dbg(arizona->dev, "Reporting range boundary %d\n",
+				arizona_hpdet_c_ranges[range].min);
+			val = arizona_hpdet_c_ranges[range].min;
+		}
 	}
 
 	dev_dbg(arizona->dev, "HP impedance %d ohms\n", val);
-- 
1.7.2.5

