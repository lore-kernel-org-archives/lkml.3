Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab3FMSeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:34:07 -0400
Received: from etezian.org ([198.101.225.253]:56453 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902Ab3FMS27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:59 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 06/19] bh1770glc: removed proximity adjustement
Date: Thu, 13 Jun 2013 20:20:40 +0200
Message-Id: <d25d18b95b7788712d2c7cd999a589c2b1e0c9d6.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proximity sensor doesn't need to be adjusted; removed all the
overcode used for the proximity coefficients

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |   39 ++-------------------------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 53f3c17..05769e3 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -165,7 +165,6 @@ struct bh1770_chip {
 	u8	prox_persistence_counter;
 	u8	prox_data;
 	u8	prox_threshold;
-	u8	prox_threshold_hw;
 	bool	prox_force_update;
 	u8	prox_abs_thres;
 	u8	prox_led;
@@ -254,33 +253,6 @@ static inline int bh1770_led_cfg(struct bh1770_chip *chip)
 					chip->prox_led);
 }
 
-/*
- * Following two functions converts raw ps values from HW to normalized
- * values. Purpose is to compensate differences between different sensor
- * versions and variants so that result means about the same between
- * versions.
- */
-static inline u8 bh1770_psraw_to_adjusted(struct bh1770_chip *chip, u8 psraw)
-{
-	u16 adjusted;
-	adjusted = (u16)(((u32)(psraw + chip->prox_const) * chip->prox_coef) /
-		BH1770_COEF_SCALER);
-	if (adjusted > BH1770_PROX_RANGE)
-		adjusted = BH1770_PROX_RANGE;
-	return adjusted;
-}
-
-static inline u8 bh1770_psadjusted_to_raw(struct bh1770_chip *chip, u8 ps)
-{
-	u16 raw;
-
-	raw = (((u32)ps * BH1770_COEF_SCALER) / chip->prox_coef);
-	if (raw > chip->prox_const)
-		raw = raw - chip->prox_const;
-	else
-		raw = 0;
-	return raw;
-}
 
 /*
  * Following two functions converts raw lux values from HW to normalized
@@ -290,17 +262,12 @@ static inline u8 bh1770_psadjusted_to_raw(struct bh1770_chip *chip, u8 ps)
  */
 static int bh1770_prox_set_threshold(struct bh1770_chip *chip)
 {
-	u8 tmp = 0;
-
 	/* sysfs may call this when the chip is powered off */
 	if (pm_runtime_suspended(&chip->client->dev))
 		return 0;
 
-	tmp = bh1770_psadjusted_to_raw(chip, chip->prox_threshold);
-	chip->prox_threshold_hw = tmp;
-
 	return	i2c_smbus_write_byte_data(chip->client, BH1770_PS_TH_LED1,
-					tmp);
+					chip->prox_threshold);
 }
 
 static inline u16 bh1770_lux_raw_to_adjusted(struct bh1770_chip *chip, u16 raw)
@@ -487,7 +454,7 @@ static int bh1770_prox_read_result(struct bh1770_chip *chip)
 	if (ret < 0)
 		goto out;
 
-	if (ret > chip->prox_threshold_hw)
+	if (ret > chip->prox_threshold)
 		above = true;
 	else
 		above = false;
@@ -500,8 +467,6 @@ static int bh1770_prox_read_result(struct bh1770_chip *chip)
 	if (chip->lux_data_raw > PROX_IGNORE_LUX_LIMIT)
 		ret = 0;
 
-	chip->prox_data = bh1770_psraw_to_adjusted(chip, ret);
-
 	/* Strong proximity level or force mode requires immediate response */
 	if (chip->prox_data >= chip->prox_abs_thres ||
 	    chip->prox_force_update)
-- 
1.7.10.4

