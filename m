Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117Ab3FMSaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:30:07 -0400
Received: from etezian.org ([198.101.225.253]:56451 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758963Ab3FMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:29:00 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 17/19] bh1770glc: Implemented switch for interrupt operation
Date: Thu, 13 Jun 2013 20:20:51 +0200
Message-Id: <b687a7151f78b66d7a013930935b4507fb31c663.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

The als_int_enable switch decides whether the sensor interrupt
signal is triggered by both proximity and the ambient light
sensors or only by the proximity sensor.

The low and high threshold values are set to their minimum and
maximum in order to disable ALS interrupt.

If als_int_enable is set to 0, then the INT output signal of the
sensor will not be used by the ALS, but only by the proximity
sensor.

The interrupt setting can be changed during runtime by defining
new threshold values for the ambient light sensor.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c      |   10 ++++++++++
 include/linux/i2c/bh1770glc.h |    1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 383cefe..526cdb6 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -1280,6 +1280,16 @@ static int bh1770_probe(struct i2c_client *client,
 	chip->lux_threshold_lo	= BH1770_LUX_DEF_THRES;
 	chip->lux_threshold_hi	= BH1770_LUX_DEF_THRES;
 
+	/* Modify the ALS threshold values
+	 * only if ALS interrupt is disabled by the platform data.
+	 * Setting the low threshold and the high threshold to the
+	 * lowest and highest values, respectively, disables the IRQ for ALS.
+	 */
+	if (chip->pdata->als_int_enable == 0) {
+		chip->lux_threshold_lo	= 0;
+		chip->lux_threshold_hi	= BH1770_LUX_RANGE;
+	}
+
 	if (chip->pdata->glass_attenuation == 0)
 		chip->lux_ga = BH1770_NEUTRAL_GA;
 	else
diff --git a/include/linux/i2c/bh1770glc.h b/include/linux/i2c/bh1770glc.h
index aaf0906..6fb4488 100644
--- a/include/linux/i2c/bh1770glc.h
+++ b/include/linux/i2c/bh1770glc.h
@@ -53,6 +53,7 @@ struct bh1770_platform_data {
 	u8 prox_hysteresis;
 	u8 prox_min_thresh_BH1770;
 	u8 prox_min_thresh_SFH7770;
+	u8 als_int_enable;
 	int (*setup_resources)(void);
 	int (*release_resources)(void);
 };
-- 
1.7.10.4

