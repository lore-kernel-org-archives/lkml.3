Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab3FMS3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:29:05 -0400
Received: from etezian.org ([198.101.225.253]:56449 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786Ab3FMS26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:58 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 04/19] bh1770glc: Added raw lux output file for ALS to sysfs
Date: Thu, 13 Jun 2013 20:20:38 +0200
Message-Id: <3621e6eb47c287eeffaef7bf68521d0d1740a296.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

"lux0_raw" file gives the raw Ambient Light Sensor (ALS) value,
before adjusting it with the calibration coefficients, whereas
"lux0_input"returns the calibrated ALS value.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 82c30e7..d8d6526 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -395,6 +395,12 @@ static int bh1770_lux_read_result(struct bh1770_chip *chip)
 	return bh1770_lux_raw_to_adjusted(chip, chip->lux_data_raw);
 }
 
+static int bh1770_lux_read_raw_result(struct bh1770_chip *chip)
+{
+	bh1770_lux_get_result(chip);
+	return chip->lux_data_raw;
+}
+
 /*
  * Chip on / off functions are called while keeping mutex except probe
  * or remove phase
@@ -725,6 +731,29 @@ static ssize_t bh1770_lux_result_show(struct device *dev,
 	return ret;
 }
 
+static ssize_t bh1770_lux_raw_result_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct bh1770_chip *chip =  dev_get_drvdata(dev);
+	ssize_t ret;
+	long timeout;
+
+	if (pm_runtime_suspended(dev))
+		return -EIO; /* Chip is not enabled at all */
+
+	timeout = wait_event_interruptible_timeout(chip->wait,
+					!chip->lux_wait_result,
+					msecs_to_jiffies(BH1770_TIMEOUT));
+	if (!timeout)
+		return -EIO;
+
+	mutex_lock(&chip->mutex);
+	ret = sprintf(buf, "%d\n", bh1770_lux_read_raw_result(chip));
+	mutex_unlock(&chip->mutex);
+
+	return ret;
+}
+
 static ssize_t bh1770_lux_range_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1184,6 +1213,7 @@ static DEVICE_ATTR(lux0_glass_factor, S_IRUGO, bh1770_lux_glass_factor_show,
 						NULL);
 static DEVICE_ATTR(lux0_sensor_comp_factor, S_IRUGO, bh1770_lux_scf_show, NULL);
 static DEVICE_ATTR(lux0_input, S_IRUGO, bh1770_lux_result_show, NULL);
+static DEVICE_ATTR(lux0_raw, S_IRUGO, bh1770_lux_raw_result_show, NULL);
 static DEVICE_ATTR(lux0_sensor_range, S_IRUGO, bh1770_lux_range_show, NULL);
 static DEVICE_ATTR(lux0_rate, S_IRUGO | S_IWUSR, bh1770_get_lux_rate,
 						bh1770_set_lux_rate);
@@ -1205,6 +1235,7 @@ static struct attribute *sysfs_attrs[] = {
 	&dev_attr_lux0_glass_factor.attr,
 	&dev_attr_lux0_sensor_comp_factor.attr,
 	&dev_attr_lux0_input.attr,
+	&dev_attr_lux0_raw.attr,
 	&dev_attr_lux0_sensor_range.attr,
 	&dev_attr_lux0_rate.attr,
 	&dev_attr_lux0_rate_avail.attr,
-- 
1.7.10.4

