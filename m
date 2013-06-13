Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab3FMSeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:34:01 -0400
Received: from etezian.org ([198.101.225.253]:56455 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941Ab3FMS27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:59 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 12/19] bh1770glc: Introduced dynamic threshold
Date: Thu, 13 Jun 2013 20:20:46 +0200
Message-Id: <d2235b552395343b1af1170ffe54ca3c2cdfafed.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

Added dynamic threshold capability to the driver and removed
constant threshold value setting, thresh_above1_value, from
the sysfs interface.

Only one threshold value is visible and configurable through
the sysfs interface now; it is prox0_threshold_value. According
to the actual status of the proximity interrupt, the threshold
is set dynamically using a newly introduced hysteresis value.
Hysteresis is a configurable parameter.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c      |   96 +++++++++++++++++++++++++----------------
 include/linux/i2c/bh1770glc.h |    3 ++
 2 files changed, 61 insertions(+), 38 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index eec799e..fe49964 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -165,8 +165,10 @@ struct bh1770_chip {
 	u8	prox_persistence_counter;
 	u8	prox_data;
 	u8	prox_threshold;
+	u8	prox_calib_threshold;
+	u8	prox_min_threshold;
+	u8	prox_hysteresis;
 	bool	prox_force_update;
-	u8	prox_abs_thres;
 	u8	prox_led;
 
 	struct input_dev *input_dev;
@@ -476,25 +478,45 @@ static int bh1770_prox_read_result(struct bh1770_chip *chip)
 	else
 		above = false;
 
-	/* Strong proximity level or force mode requires immediate response */
-	if (chip->prox_data >= chip->prox_abs_thres ||
-	    chip->prox_force_update)
+	/* Forced mode requires immediate response */
+	if (chip->prox_force_update)
 		chip->prox_persistence_counter = chip->prox_persistence;
 
 	chip->prox_force_update = false;
 
-	/* Persistence filttering to reduce false proximity events */
+	/* Persistence filtering to reduce false proximity events */
 	if (likely(above)) {
 		if (chip->prox_persistence_counter < chip->prox_persistence) {
 			chip->prox_persistence_counter++;
 			ret = -ENODATA;
 		} else {
 			mode = PROX_ABOVE_THRESHOLD;
+
+			/*
+			 * When above the threshold, reset the threshold value
+			 * to a lower value defined by the given hysteresis
+			 * The lowest value allowed is the min value
+			 **/
+			if ((chip->prox_calib_threshold - chip->prox_hysteresis)
+				>= chip->prox_min_threshold) {
+				chip->prox_threshold =
+					chip->prox_calib_threshold -
+					chip->prox_hysteresis;
+				bh1770_prox_set_threshold(chip);
+			}
+			chip->prox_persistence_counter = 0;
 			ret = 0;
 		}
 	} else {
 		chip->prox_persistence_counter = 0;
 		mode = PROX_BELOW_THRESHOLD;
+
+		/*
+		 * When below the threshold, reset the threshold value
+		 * to the calibration value
+		 */
+		chip->prox_threshold = chip->prox_calib_threshold;
+		bh1770_prox_set_threshold(chip);
 		ret = 0;
 	}
 
@@ -528,11 +550,20 @@ static int bh1770_detect(struct bh1770_chip *chip)
 	chip->prox_coef = BH1770_COEF_SCALER;
 	chip->prox_const = 0;
 	chip->lux_cf = BH1770_NEUTRAL_CF;
+	chip->prox_min_threshold = BH1770_PROX_DEF_THRES;
 
 	if ((manu == BH1770_MANUFACT_ROHM) &&
 	    ((part & BH1770_PART_MASK) == BH1770_PART)) {
 		snprintf(chip->chipname, sizeof(chip->chipname), "BH1770GLC");
 		chip->lux_cf = chip->pdata->als_scf_BH1770;
+
+		/* apply minimum threshold value only after verifying it */
+		if ((chip->pdata->prox_min_thresh_BH1770 > 0) &&
+			(chip->pdata->prox_min_thresh_BH1770 <
+							BH1770_PROX_RANGE)) {
+			chip->prox_min_threshold =
+				chip->pdata->prox_min_thresh_BH1770;
+		}
 		return 0;
 	}
 
@@ -540,6 +571,14 @@ static int bh1770_detect(struct bh1770_chip *chip)
 	    ((part & BH1770_PART_MASK) == BH1770_PART)) {
 		snprintf(chip->chipname, sizeof(chip->chipname), "SFH7770");
 		chip->lux_cf = chip->pdata->als_scf_SFH7770;
+
+		/* apply minimum threshold value only after verifying it */
+		if ((chip->pdata->prox_min_thresh_SFH7770 > 0) &&
+			(chip->pdata->prox_min_thresh_SFH7770 <
+							BH1770_PROX_RANGE)) {
+			chip->prox_min_threshold =
+				chip->pdata->prox_min_thresh_SFH7770;
+		}
 		return 0;
 	}
 
@@ -929,6 +968,8 @@ static ssize_t bh1770_set_prox_thres(struct device *dev,
 	mutex_unlock(&chip->mutex);
 	if (ret < 0)
 		return ret;
+	/* Remember the calibrated threshold value */
+	chip->prox_calib_threshold = chip->prox_threshold;
 	return count;
 }
 
@@ -958,31 +999,6 @@ static ssize_t bh1770_prox_persistence_store(struct device *dev,
 	return len;
 }
 
-static ssize_t bh1770_prox_abs_thres_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct bh1770_chip *chip = dev_get_drvdata(dev);
-	return sprintf(buf, "%u\n", chip->prox_abs_thres);
-}
-
-static ssize_t bh1770_prox_abs_thres_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t len)
-{
-	struct bh1770_chip *chip = dev_get_drvdata(dev);
-	unsigned long value;
-
-	if (kstrtoul(buf, 0, &value))
-		return -EINVAL;
-
-	if (value > BH1770_PROX_RANGE)
-		return -EINVAL;
-
-	chip->prox_abs_thres = value;
-
-	return len;
-}
-
 static ssize_t bh1770_chip_id_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1162,10 +1178,7 @@ static ssize_t bh1770_set_lux_thresh_below(struct device *dev,
 
 static DEVICE_ATTR(prox0_raw_en, S_IRUGO | S_IWUSR, bh1770_prox_enable_show,
 						bh1770_prox_enable_store);
-static DEVICE_ATTR(prox0_thresh_above1_value, S_IRUGO | S_IWUSR,
-						bh1770_prox_abs_thres_show,
-						bh1770_prox_abs_thres_store);
-static DEVICE_ATTR(prox0_thresh_above0_value, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(prox0_threshold_value, S_IRUGO | S_IWUSR,
 						bh1770_get_prox_thres,
 						bh1770_set_prox_thres);
 static DEVICE_ATTR(prox0_raw, S_IRUGO, bh1770_prox_result_show, NULL);
@@ -1225,8 +1238,7 @@ static struct attribute *sysfs_attrs[] = {
 	&dev_attr_prox0_rate_above.attr,
 	&dev_attr_prox0_rate_below.attr,
 	&dev_attr_prox0_rate_avail.attr,
-	&dev_attr_prox0_thresh_above0_value.attr,
-	&dev_attr_prox0_thresh_above1_value.attr,
+	&dev_attr_prox0_threshold_value.attr,
 	&dev_attr_chip_id.attr,
 	&dev_attr_power_state.attr,
 	NULL
@@ -1270,13 +1282,18 @@ static int bh1770_probe(struct i2c_client *client,
 	else
 		chip->lux_ga = chip->pdata->glass_attenuation;
 
-	chip->prox_threshold	= BH1770_PROX_DEF_THRES;
 	chip->prox_led		= chip->pdata->led_def_curr;
-	chip->prox_abs_thres	= BH1770_PROX_DEF_ABS_THRES;
 	chip->prox_persistence	= BH1770_DEFAULT_PERSISTENCE;
 	chip->prox_rate_threshold = BH1770_PROX_DEF_RATE_THRESH;
 	chip->prox_rate		= BH1770_PROX_DEFAULT_RATE;
 	chip->prox_data		= 0;
+	/* Make sure that the given hysteresis value is in range */
+	if ((chip->pdata->prox_hysteresis > BH1770_PROX_RANGE) ||
+		(chip->pdata->prox_hysteresis < 0)) {
+		chip->prox_hysteresis = 0;
+	} else {
+		chip->prox_hysteresis = chip->pdata->prox_hysteresis;
+	}
 
 	chip->regs[0].supply = reg_vcc;
 	chip->regs[1].supply = reg_vleds;
@@ -1300,6 +1317,9 @@ static int bh1770_probe(struct i2c_client *client,
 	if (err < 0)
 		goto fail3;
 
+	chip->prox_threshold		= chip->prox_min_threshold;
+	chip->prox_calib_threshold	= chip->prox_threshold;
+
 	/* Start chip */
 	bh1770_chip_on(chip);
 	pm_runtime_set_active(&client->dev);
diff --git a/include/linux/i2c/bh1770glc.h b/include/linux/i2c/bh1770glc.h
index a08060a..ed670dd 100644
--- a/include/linux/i2c/bh1770glc.h
+++ b/include/linux/i2c/bh1770glc.h
@@ -49,6 +49,9 @@ struct bh1770_platform_data {
 	__u32 glass_attenuation;
 	__u32 als_scf_BH1770;
 	__u32 als_scf_SFH7770;
+	u8 prox_hysteresis;
+	u8 prox_min_thresh_BH1770;
+	u8 prox_min_thresh_SFH7770;
 	int (*setup_resources)(void);
 	int (*release_resources)(void);
 };
-- 
1.7.10.4

