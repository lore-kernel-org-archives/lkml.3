Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab3FMSfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:35:22 -0400
Received: from etezian.org ([198.101.225.253]:56451 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888Ab3FMS27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:59 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 19/19] bh1770glc: Proximity sensor LED current update
Date: Thu, 13 Jun 2013 20:20:53 +0200
Message-Id: <c78389521bb3d8526df9d9c686e4522005914a06.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

Instead of using a constant value, the LED current
of the proximity sensor is now made individually
configurable for each product.

bh1770glc reads the platform-defined data and sets
the most suitable current value accordingly.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c      |   11 ++++++++++-
 include/linux/i2c/bh1770glc.h |    1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index ef1ab49..0af50bf 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -1256,6 +1256,7 @@ static int bh1770_probe(struct i2c_client *client,
 {
 	struct bh1770_chip *chip;
 	int err;
+	u8 i;
 
 	chip = kzalloc(sizeof *chip, GFP_KERNEL);
 	if (!chip)
@@ -1274,7 +1275,15 @@ static int bh1770_probe(struct i2c_client *client,
 		goto fail1;
 	}
 
-	chip->pdata		= client->dev.platform_data;
+	/* Set the proximity sensor LED current according to the
+	 * platform data. If the given value is out of range,
+	 * use the closest supported current per default.
+	 */
+	for (i = ARRAY_SIZE(prox_curr_ma)-1; i > 0; i--) {
+		if (chip->pdata->led1_def_curr_ma >= prox_curr_ma[i])
+			break;
+	}
+	chip->prox_led		= i;
 	chip->lux_calib		= BH1770_LUX_NEUTRAL_CALIB_VALUE;
 	chip->lux_rate_index	= BH1770_LUX_DEFAULT_RATE;
 	chip->lux_threshold_lo	= BH1770_LUX_DEF_THRES;
diff --git a/include/linux/i2c/bh1770glc.h b/include/linux/i2c/bh1770glc.h
index 6fb4488..9c081a8 100644
--- a/include/linux/i2c/bh1770glc.h
+++ b/include/linux/i2c/bh1770glc.h
@@ -47,6 +47,7 @@
 
 struct bh1770_platform_data {
 	u8 led_def_curr;
+	u8 led1_def_curr_ma;
 	u32 glass_attenuation;
 	u32 als_scf_BH1770;
 	u32 als_scf_SFH7770;
-- 
1.7.10.4

