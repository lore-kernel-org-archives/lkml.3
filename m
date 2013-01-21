Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3AUMJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:09:55 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51886 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3AUMEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:30 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Michel JAOUEN <michel.jaouen@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Subject: [PATCH 04/24] ab8500-btemp: Adaptation to AB8505 and AB9540 platforms
Date: Mon, 21 Jan 2013 12:03:40 +0000
Message-Id: <1358769840-4763-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Add AB9540 and AB8505 support to ABx500 BTEMP driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_btemp.c         |   67 +++++++++++++++++++++++++++-------
 include/linux/mfd/abx500/ab8500-bm.h |    2 +
 2 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 8ccf359..301a9ad 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -39,6 +39,9 @@
 #define BTEMP_BATCTRL_CURR_SRC_7UA	7
 #define BTEMP_BATCTRL_CURR_SRC_20UA	20
 
+#define BTEMP_BATCTRL_CURR_SRC_16UA	16
+#define BTEMP_BATCTRL_CURR_SRC_18UA	18
+
 #define to_ab8500_btemp_device_info(x) container_of((x), \
 	struct ab8500_btemp, btemp_psy);
 
@@ -212,10 +215,18 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 
 	/* Only do this for batteries with internal NTC */
 	if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL && enable) {
-		if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_7UA)
-			curr = BAT_CTRL_7U_ENA;
-		else
-			curr = BAT_CTRL_20U_ENA;
+
+		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_16UA)
+				curr = BAT_CTRL_16U_ENA;
+			else
+				curr = BAT_CTRL_18U_ENA;
+		} else {
+			if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_7UA)
+				curr = BAT_CTRL_7U_ENA;
+			else
+				curr = BAT_CTRL_20U_ENA;
+		}
 
 		dev_dbg(di->dev, "Set BATCTRL %duA\n", di->curr_source);
 
@@ -246,11 +257,22 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 	} else if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL && !enable) {
 		dev_dbg(di->dev, "Disable BATCTRL curr source\n");
 
-		/* Write 0 to the curr bits */
-		ret = abx500_mask_and_set_register_interruptible(di->dev,
-			AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
-			BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA,
-			~(BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA));
+		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			/* Write 0 to the curr bits */
+			ret = abx500_mask_and_set_register_interruptible(
+				di->dev,
+				AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
+				BAT_CTRL_16U_ENA | BAT_CTRL_18U_ENA,
+				~(BAT_CTRL_16U_ENA | BAT_CTRL_18U_ENA));
+		} else {
+			/* Write 0 to the curr bits */
+			ret = abx500_mask_and_set_register_interruptible(
+				di->dev,
+				AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
+				BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA,
+				~(BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA));
+		}
+
 		if (ret) {
 			dev_err(di->dev, "%s failed disabling current source\n",
 				__func__);
@@ -292,11 +314,20 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 	 * if we got an error above
 	 */
 disable_curr_source:
-	/* Write 0 to the curr bits */
-	ret = abx500_mask_and_set_register_interruptible(di->dev,
+	if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+		/* Write 0 to the curr bits */
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
+			BAT_CTRL_16U_ENA | BAT_CTRL_18U_ENA,
+			~(BAT_CTRL_16U_ENA | BAT_CTRL_18U_ENA));
+	} else {
+		/* Write 0 to the curr bits */
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
 			AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
 			BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA,
 			~(BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA));
+	}
+
 	if (ret) {
 		dev_err(di->dev, "%s failed disabling current source\n",
 			__func__);
@@ -510,8 +541,11 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 {
 	int res;
 	u8 i;
+	if (is_ab9540(di->parent) || is_ab8505(di->parent))
+		di->curr_source = BTEMP_BATCTRL_CURR_SRC_16UA;
+	else
+		di->curr_source = BTEMP_BATCTRL_CURR_SRC_7UA;
 
-	di->curr_source = BTEMP_BATCTRL_CURR_SRC_7UA;
 	di->bm->batt_id = BATTERY_UNKNOWN;
 
 	res =  ab8500_btemp_get_batctrl_res(di);
@@ -549,8 +583,13 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 	 */
 	if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL &&
 			di->bm->batt_id == 1) {
-		dev_dbg(di->dev, "Set BATCTRL current source to 20uA\n");
-		di->curr_source = BTEMP_BATCTRL_CURR_SRC_20UA;
+		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			dev_dbg(di->dev, "Set BATCTRL current source to 16uA\n");
+			di->curr_source = BTEMP_BATCTRL_CURR_SRC_16UA;
+		} else {
+			dev_dbg(di->dev, "Set BATCTRL current source to 20uA\n");
+			di->curr_source = BTEMP_BATCTRL_CURR_SRC_20UA;
+		}
 	}
 
 	return di->bm->batt_id;
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index a03d4fd..ec796c7 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -226,6 +226,8 @@
 /* BatCtrl Current Source Constants */
 #define BAT_CTRL_7U_ENA			0x01
 #define BAT_CTRL_20U_ENA		0x02
+#define BAT_CTRL_18U_ENA		0x01
+#define BAT_CTRL_16U_ENA		0x02
 #define BAT_CTRL_CMP_ENA		0x04
 #define FORCE_BAT_CTRL_CMP_HIGH		0x08
 #define BAT_CTRL_PULL_UP_ENA		0x10
-- 
1.7.9.5

