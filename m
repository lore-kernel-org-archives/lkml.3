Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab3FMS3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:29:03 -0400
Received: from etezian.org ([198.101.225.253]:56444 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758753Ab3FMS26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:58 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 07/19] bh1770glc: split read result function
Date: Thu, 13 Jun 2013 20:20:41 +0200
Message-Id: <530c51681f03abe931846912cde1d59af4ea1b55.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prox_read_result() has been split in two functions:
 - ps_get_result(): reads the proximity value from the register
 - prox_read_result(): applies the logic above the proximity value

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |   53 +++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 05769e3..ac6d0c8 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -253,13 +253,6 @@ static inline int bh1770_led_cfg(struct bh1770_chip *chip)
 					chip->prox_led);
 }
 
-
-/*
- * Following two functions converts raw lux values from HW to normalized
- * values. Purpose is to compensate differences between different sensor
- * versions and variants so that result means about the same between
- * versions. Chip->mutex is kept when this is called.
- */
 static int bh1770_prox_set_threshold(struct bh1770_chip *chip)
 {
 	/* sysfs may call this when the chip is powered off */
@@ -270,6 +263,12 @@ static int bh1770_prox_set_threshold(struct bh1770_chip *chip)
 					chip->prox_threshold);
 }
 
+/*
+ * Following two functions converts raw lux values from HW to normalized
+ * values. Purpose is to compensate differences between different sensor
+ * versions and variants so that result means about the same between
+ * versions. Chip->mutex is kept when this is called.
+ */
 static inline u16 bh1770_lux_raw_to_adjusted(struct bh1770_chip *chip, u16 raw)
 {
 	u32 lux;
@@ -343,6 +342,30 @@ static int bh1770_lux_get_result(struct bh1770_chip *chip)
 	return 0;
 }
 
+static int bh1770_ps_get_result(struct bh1770_chip *chip)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(chip->client, BH1770_PS_DATA_LED1);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * when ALS levels goes above limit, proximity result may be
+	 * false proximity. Thus ignore the result. With real proximity
+	 * there is a shadow causing low als levels.
+	*/
+	if (chip->lux_data_raw > PROX_IGNORE_LUX_LIMIT)
+		return 0;
+
+	if (ret > BH1770_PROX_RANGE)
+		chip->prox_data = BH1770_PROX_RANGE;
+	else
+		chip->prox_data = ret;
+
+	return 0;
+}
+
 /* Calculate correction value which contains chip and device specific parts */
 static u32 bh1770_get_corr_value(struct bh1770_chip *chip)
 {
@@ -450,23 +473,15 @@ static int bh1770_prox_read_result(struct bh1770_chip *chip)
 	bool above;
 	u8 mode;
 
-	ret = i2c_smbus_read_byte_data(chip->client, BH1770_PS_DATA_LED1);
+	ret = bh1770_ps_get_result(chip);
 	if (ret < 0)
-		goto out;
+		return ret;
 
-	if (ret > chip->prox_threshold)
+	if (chip->prox_data > chip->prox_threshold)
 		above = true;
 	else
 		above = false;
 
-	/*
-	 * when ALS levels goes above limit, proximity result may be
-	 * false proximity. Thus ignore the result. With real proximity
-	 * there is a shadow causing low als levels.
-	 */
-	if (chip->lux_data_raw > PROX_IGNORE_LUX_LIMIT)
-		ret = 0;
-
 	/* Strong proximity level or force mode requires immediate response */
 	if (chip->prox_data >= chip->prox_abs_thres ||
 	    chip->prox_force_update)
@@ -495,7 +510,7 @@ static int bh1770_prox_read_result(struct bh1770_chip *chip)
 		bh1770_report_input_value(chip, mode);
 		sysfs_notify(&chip->client->dev.kobj, NULL, "prox0_raw");
 	}
-out:
+
 	return ret;
 }
 
-- 
1.7.10.4

