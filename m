Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab3FMSaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:30:00 -0400
Received: from etezian.org ([198.101.225.253]:56453 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758984Ab3FMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:29:00 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 03/19] bh1770glc: lux0_glass_factor & lux0_comp_factor on sysfs
Date: Thu, 13 Jun 2013 20:20:37 +0200
Message-Id: <0336a23507f74f1dcf7c2f7d08ddf77c7d83df26.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

Introduced lux0_glass_factor and lux0_comp_factor on sysfs

lux0_glass_factor and lux0_sensor_comp_factor are provided as
read-only files on the sysfs structure of the bh1770glc optical sensor.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index d60b317..82c30e7 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -467,6 +467,7 @@ static int bh1770_prox_mode_control(struct bh1770_chip *chip)
 static void bh1770_report_input_value(struct bh1770_chip *chip, int val)
 {
 	input_report_switch(chip->input_dev, SW_FRONT_PROXIMITY, val);
+	input_sync(chip->input_dev);
 }
 
 /* chip->mutex is kept when this is called */
@@ -551,6 +552,7 @@ static int bh1770_detect(struct bh1770_chip *chip)
 	if ((manu == BH1770_MANUFACT_ROHM) &&
 	    ((part & BH1770_PART_MASK) == BH1770_PART)) {
 		snprintf(chip->chipname, sizeof(chip->chipname), "BH1770GLC");
+		chip->lux_cf = chip->pdata->als_scf_BH1770;
 		return 0;
 	}
 
@@ -560,6 +562,7 @@ static int bh1770_detect(struct bh1770_chip *chip)
 		/* Values selected by comparing different versions */
 		chip->prox_coef = 819; /* 0.8 * BH1770_COEF_SCALER */
 		chip->prox_const = 40;
+		chip->lux_cf = chip->pdata->als_scf_SFH7770;
 		return 0;
 	}
 
@@ -1030,6 +1033,20 @@ static ssize_t bh1770_lux_calib_store(struct device *dev,
 	return len;
 }
 
+static ssize_t bh1770_lux_glass_factor_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct bh1770_chip *chip = dev_get_drvdata(dev);
+	return sprintf(buf, "%u\n", chip->lux_ga);
+}
+
+static ssize_t bh1770_lux_scf_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct bh1770_chip *chip = dev_get_drvdata(dev);
+	return sprintf(buf, "%u\n", chip->lux_cf);
+}
+
 static ssize_t bh1770_get_lux_rate_avail(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1163,6 +1180,9 @@ static DEVICE_ATTR(lux0_calibscale, S_IRUGO | S_IWUSR, bh1770_lux_calib_show,
 static DEVICE_ATTR(lux0_calibscale_default, S_IRUGO,
 						bh1770_lux_calib_default_show,
 						NULL);
+static DEVICE_ATTR(lux0_glass_factor, S_IRUGO, bh1770_lux_glass_factor_show,
+						NULL);
+static DEVICE_ATTR(lux0_sensor_comp_factor, S_IRUGO, bh1770_lux_scf_show, NULL);
 static DEVICE_ATTR(lux0_input, S_IRUGO, bh1770_lux_result_show, NULL);
 static DEVICE_ATTR(lux0_sensor_range, S_IRUGO, bh1770_lux_range_show, NULL);
 static DEVICE_ATTR(lux0_rate, S_IRUGO | S_IWUSR, bh1770_get_lux_rate,
@@ -1182,6 +1202,8 @@ static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR, bh1770_power_state_show,
 static struct attribute *sysfs_attrs[] = {
 	&dev_attr_lux0_calibscale.attr,
 	&dev_attr_lux0_calibscale_default.attr,
+	&dev_attr_lux0_glass_factor.attr,
+	&dev_attr_lux0_sensor_comp_factor.attr,
 	&dev_attr_lux0_input.attr,
 	&dev_attr_lux0_sensor_range.attr,
 	&dev_attr_lux0_rate.attr,
-- 
1.7.10.4

