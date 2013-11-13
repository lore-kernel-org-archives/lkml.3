Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab3KMST5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:19:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39284 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522Ab3KMSTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:19:50 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 1/7] extcon: arizona: Add defines for microphone detection levels
Date: Wed, 13 Nov 2013 18:04:31 +0000
Message-Id: <1384365877-12355-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve readability by creating a define for each microphone detection
level.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c       |   19 ++++++++++++++-----
 include/linux/mfd/arizona/registers.h |    9 +++++++++
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 3c55ec8..8810da1 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -44,6 +44,15 @@
 #define HPDET_DEBOUNCE 500
 #define DEFAULT_MICD_TIMEOUT 2000
 
+#define MICD_LVL_1_TO_7 (ARIZONA_MICD_LVL_1 | ARIZONA_MICD_LVL_2 | \
+			 ARIZONA_MICD_LVL_3 | ARIZONA_MICD_LVL_4 | \
+			 ARIZONA_MICD_LVL_5 | ARIZONA_MICD_LVL_6 | \
+			 ARIZONA_MICD_LVL_7)
+
+#define MICD_LVL_0_TO_7 (ARIZONA_MICD_LVL_0 | MICD_LVL_1_TO_7)
+
+#define MICD_LVL_0_TO_8 (MICD_LVL_0_TO_7 | ARIZONA_MICD_LVL_8)
+
 struct arizona_extcon_info {
 	struct device *dev;
 	struct arizona *arizona;
@@ -765,7 +774,7 @@ static void arizona_micd_detect(struct work_struct *work)
 
 	mutex_lock(&info->lock);
 
-	for (i = 0; i < 10 && !(val & 0x7fc); i++) {
+	for (i = 0; i < 10 && !(val & MICD_LVL_0_TO_8); i++) {
 		ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
 		if (ret != 0) {
 			dev_err(arizona->dev,
@@ -784,7 +793,7 @@ static void arizona_micd_detect(struct work_struct *work)
 		}
 	}
 
-	if (i == 10 && !(val & 0x7fc)) {
+	if (i == 10 && !(val & MICD_LVL_0_TO_8)) {
 		dev_err(arizona->dev, "Failed to get valid MICDET value\n");
 		mutex_unlock(&info->lock);
 		return;
@@ -798,7 +807,7 @@ static void arizona_micd_detect(struct work_struct *work)
 	}
 
 	/* If we got a high impedence we should have a headset, report it. */
-	if (info->detecting && (val & 0x400)) {
+	if (info->detecting && (val & ARIZONA_MICD_LVL_8)) {
 		arizona_identify_headphone(info);
 
 		ret = extcon_update_state(&info->edev,
@@ -827,7 +836,7 @@ static void arizona_micd_detect(struct work_struct *work)
 	 * plain headphones.  If both polarities report a low
 	 * impedence then give up and report headphones.
 	 */
-	if (info->detecting && (val & 0x3f8)) {
+	if (info->detecting && (val & MICD_LVL_1_TO_7)) {
 		if (info->jack_flips >= info->micd_num_modes * 10) {
 			dev_dbg(arizona->dev, "Detected HP/line\n");
 			arizona_identify_headphone(info);
@@ -851,7 +860,7 @@ static void arizona_micd_detect(struct work_struct *work)
 	 * If we're still detecting and we detect a short then we've
 	 * got a headphone.  Otherwise it's a button press.
 	 */
-	if (val & 0x3fc) {
+	if (val & MICD_LVL_0_TO_7) {
 		if (info->mic) {
 			dev_dbg(arizona->dev, "Mic button detected\n");
 
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 4706d3d..10d9e70 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -2196,6 +2196,15 @@
 /*
  * R677 (0x2A5) - Mic Detect 3
  */
+#define ARIZONA_MICD_LVL_0                       0x0004  /* MICD_LVL - [2] */
+#define ARIZONA_MICD_LVL_1                       0x0008  /* MICD_LVL - [3] */
+#define ARIZONA_MICD_LVL_2                       0x0010  /* MICD_LVL - [4] */
+#define ARIZONA_MICD_LVL_3                       0x0020  /* MICD_LVL - [5] */
+#define ARIZONA_MICD_LVL_4                       0x0040  /* MICD_LVL - [6] */
+#define ARIZONA_MICD_LVL_5                       0x0080  /* MICD_LVL - [7] */
+#define ARIZONA_MICD_LVL_6                       0x0100  /* MICD_LVL - [8] */
+#define ARIZONA_MICD_LVL_7                       0x0200  /* MICD_LVL - [9] */
+#define ARIZONA_MICD_LVL_8                       0x0400  /* MICD_LVL - [10] */
 #define ARIZONA_MICD_LVL_MASK                    0x07FC  /* MICD_LVL - [10:2] */
 #define ARIZONA_MICD_LVL_SHIFT                        2  /* MICD_LVL - [10:2] */
 #define ARIZONA_MICD_LVL_WIDTH                        9  /* MICD_LVL - [10:2] */
-- 
1.7.2.5

