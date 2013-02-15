Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717Ab3BOM4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:56:44 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34817 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161320Ab3BOMpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:50 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/40] ab8500-fg: Add power cut feature for ab8505 and ab8540
Date: Fri, 15 Feb 2013 12:44:34 +0000
Message-Id: <1360932310-30065-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for a power cut feature which allows user to
configure when ab8505 and ab8540 based platforms should shut
down system due to low battery.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c            |   36 +++
 drivers/power/ab8500_bmdata.c        |    5 +
 drivers/power/ab8500_fg.c            |  426 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/abx500.h           |   10 +
 include/linux/mfd/abx500/ab8500-bm.h |   18 ++
 5 files changed, 495 insertions(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 4c4aa19..4011d40 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -109,6 +109,7 @@
 #define AB8500_SWITCH_OFF_STATUS	0x00
 
 #define AB8500_TURN_ON_STATUS		0x00
+#define AB8505_TURN_ON_STATUS_2	0x04
 
 static bool no_bm; /* No battery management */
 module_param(no_bm, bool, S_IRUGO);
@@ -1147,6 +1148,21 @@ static ssize_t show_turn_on_status(struct device *dev,
 	return sprintf(buf, "%#x\n", value);
 }
 
+static ssize_t show_turn_on_status_2(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int ret;
+	u8 value;
+	struct ab8500 *ab8500;
+
+	ab8500 = dev_get_drvdata(dev);
+	ret = get_register_interruptible(ab8500, AB8500_SYS_CTRL1_BLOCK,
+		AB8505_TURN_ON_STATUS_2, &value);
+	if (ret < 0)
+		return ret;
+	return sprintf(buf, "%#x\n", (value & 0x1));
+}
+
 static ssize_t show_ab9540_dbbrstn(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -1203,6 +1219,7 @@ exit:
 static DEVICE_ATTR(chip_id, S_IRUGO, show_chip_id, NULL);
 static DEVICE_ATTR(switch_off_status, S_IRUGO, show_switch_off_status, NULL);
 static DEVICE_ATTR(turn_on_status, S_IRUGO, show_turn_on_status, NULL);
+static DEVICE_ATTR(turn_on_status_2, S_IRUGO, show_turn_on_status_2, NULL);
 static DEVICE_ATTR(dbbrstn, S_IRUGO | S_IWUSR,
 			show_ab9540_dbbrstn, store_ab9540_dbbrstn);
 
@@ -1213,6 +1230,11 @@ static struct attribute *ab8500_sysfs_entries[] = {
 	NULL,
 };
 
+static struct attribute *ab8505_sysfs_entries[] = {
+	&dev_attr_turn_on_status_2.attr,
+	NULL,
+};
+
 static struct attribute *ab9540_sysfs_entries[] = {
 	&dev_attr_chip_id.attr,
 	&dev_attr_switch_off_status.attr,
@@ -1225,6 +1247,10 @@ static struct attribute_group ab8500_attr_group = {
 	.attrs	= ab8500_sysfs_entries,
 };
 
+static struct attribute_group ab8505_attr_group = {
+	.attrs	= ab8505_sysfs_entries,
+};
+
 static struct attribute_group ab9540_attr_group = {
 	.attrs	= ab9540_sysfs_entries,
 };
@@ -1434,6 +1460,12 @@ static int ab8500_probe(struct platform_device *pdev)
 	else
 		ret = sysfs_create_group(&ab8500->dev->kobj,
 					&ab8500_attr_group);
+
+	if ((is_ab8505(ab8500) || is_ab9540(ab8500)) &&
+			ab8500->chip_id >= AB8500_CUT2P0)
+		ret = sysfs_create_group(&ab8500->dev->kobj,
+					 &ab8505_attr_group);
+
 	if (ret)
 		dev_err(ab8500->dev, "error creating sysfs entries\n");
 
@@ -1449,6 +1481,10 @@ static int ab8500_remove(struct platform_device *pdev)
 	else
 		sysfs_remove_group(&ab8500->dev->kobj, &ab8500_attr_group);
 
+	if ((is_ab8505(ab8500) || is_ab9540(ab8500)) &&
+			ab8500->chip_id >= AB8500_CUT2P0)
+		sysfs_remove_group(&ab8500->dev->kobj, &ab8505_attr_group);
+
 	mfd_remove_devices(ab8500->dev);
 
 	return 0;
diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index 20c157b..17744d9 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -407,6 +407,11 @@ static const struct abx500_fg_parameters fg = {
 	.battok_raising_th_sel1 = 2860,
 	.maint_thres = 95,
 	.user_cap_limit = 15,
+	.pcut_enable = 1,
+	.pcut_max_time = 127,
+	.pcut_flag_time = 112,
+	.pcut_max_restart = 15,
+	.pcut_debounce_time = 2,
 };
 
 static const struct abx500_maxim_parameters maxi_params = {
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 25dae4c..9d33546 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2344,6 +2344,50 @@ static int ab8500_fg_init_hw_registers(struct ab8500_fg *di)
 		dev_err(di->dev, "BattOk init write failed.\n");
 		goto out;
 	}
+
+	if (((is_ab8505(di->parent) || is_ab9540(di->parent)) &&
+			abx500_get_chip_id(di->dev) >= AB8500_CUT2P0)
+			|| is_ab8540(di->parent)) {
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_MAX_TIME_REG, di->bm->fg_params->pcut_max_time);
+
+		if (ret) {
+			dev_err(di->dev, "%s write failed AB8505_RTC_PCUT_MAX_TIME_REG\n", __func__);
+			goto out;
+		};
+
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_FLAG_TIME_REG, di->bm->fg_params->pcut_flag_time);
+
+		if (ret) {
+			dev_err(di->dev, "%s write failed AB8505_RTC_PCUT_FLAG_TIME_REG\n", __func__);
+			goto out;
+		};
+
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_RESTART_REG, di->bm->fg_params->pcut_max_restart);
+
+		if (ret) {
+			dev_err(di->dev, "%s write failed AB8505_RTC_PCUT_RESTART_REG\n", __func__);
+			goto out;
+		};
+
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_DEBOUNCE_REG, di->bm->fg_params->pcut_debounce_time);
+
+		if (ret) {
+			dev_err(di->dev, "%s write failed AB8505_RTC_PCUT_DEBOUNCE_REG\n", __func__);
+			goto out;
+		};
+
+		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+			AB8505_RTC_PCUT_CTL_STATUS_REG, di->bm->fg_params->pcut_enable);
+
+		if (ret) {
+			dev_err(di->dev, "%s write failed AB8505_RTC_PCUT_CTL_STATUS_REG\n", __func__);
+			goto out;
+		};
+	}
 out:
 	return ret;
 }
@@ -2546,6 +2590,388 @@ static int ab8500_fg_sysfs_init(struct ab8500_fg *di)
 
 	return ret;
 }
+
+static ssize_t ab8505_powercut_flagtime_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_FLAG_TIME_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_FLAG_TIME_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7F));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_flagtime_write(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+	long unsigned reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	reg_value = simple_strtoul(buf, NULL, 10);
+
+	if (reg_value > 0x7F) {
+		dev_err(dev, "Incorrect parameter, echo 0 (1.98s) - 127 (15.625ms) for flagtime\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_FLAG_TIME_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_FLAG_TIME_REG\n");
+
+fail:
+	return count;
+}
+
+static ssize_t ab8505_powercut_maxtime_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_MAX_TIME_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_MAX_TIME_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7F));
+
+fail:
+	return ret;
+
+}
+
+static ssize_t ab8505_powercut_maxtime_write(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+	int reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	reg_value = simple_strtoul(buf, NULL, 10);
+	if (reg_value > 0x7F) {
+		dev_err(dev, "Incorrect parameter, echo 0 (0.0s) - 127 (1.98s) for maxtime\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_MAX_TIME_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_MAX_TIME_REG\n");
+
+fail:
+	return count;
+}
+
+static ssize_t ab8505_powercut_restart_read(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+		AB8505_RTC_PCUT_RESTART_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_RESTART_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0xF));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_restart_write(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	int ret;
+	int reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	reg_value = simple_strtoul(buf, NULL, 10);
+	if (reg_value > 0xF) {
+		dev_err(dev, "Incorrect parameter, echo 0 - 15 for number of restart\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+						AB8505_RTC_PCUT_RESTART_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_RESTART_REG\n");
+
+fail:
+	return count;
+
+}
+
+static ssize_t ab8505_powercut_timer_read(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+						AB8505_RTC_PCUT_TIME_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_TIME_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7F));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_restart_counter_read(struct device *dev,
+						    struct device_attribute *attr,
+						    char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+						AB8505_RTC_PCUT_RESTART_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_RESTART_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0xF0) >> 4);
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_read(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+						AB8505_RTC_PCUT_CTL_STATUS_REG, &reg_value);
+
+	if (ret < 0)
+		goto fail;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x1));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_write(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	int ret;
+	int reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	reg_value = simple_strtoul(buf, NULL, 10);
+	if (reg_value > 0x1) {
+		dev_err(dev, "Incorrect parameter, echo 0/1 to disable/enable Pcut feature\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+						AB8505_RTC_PCUT_CTL_STATUS_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_CTL_STATUS_REG\n");
+
+fail:
+	return count;
+}
+
+static ssize_t ab8505_powercut_flag_read(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+						AB8505_RTC_PCUT_CTL_STATUS_REG,  &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_CTL_STATUS_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", ((reg_value & 0x10) >> 4));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_debounce_read(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+						AB8505_RTC_PCUT_DEBOUNCE_REG,  &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_DEBOUNCE_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7));
+
+fail:
+	return ret;
+}
+
+static ssize_t ab8505_powercut_debounce_write(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf, size_t count)
+{
+	int ret;
+	int reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	reg_value = simple_strtoul(buf, NULL, 10);
+	if (reg_value > 0x7) {
+		dev_err(dev, "Incorrect parameter, echo 0 to 7 for debounce setting\n");
+		goto fail;
+	}
+
+	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
+						AB8505_RTC_PCUT_DEBOUNCE_REG, (u8)reg_value);
+
+	if (ret < 0)
+		dev_err(dev, "Failed to set AB8505_RTC_PCUT_DEBOUNCE_REG\n");
+
+fail:
+	return count;
+}
+
+static ssize_t ab8505_powercut_enable_status_read(struct device *dev,
+						  struct device_attribute *attr,
+						  char *buf)
+{
+	int ret;
+	u8 reg_value;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
+						AB8505_RTC_PCUT_CTL_STATUS_REG, &reg_value);
+
+	if (ret < 0) {
+		dev_err(dev, "Failed to read AB8505_RTC_PCUT_CTL_STATUS_REG\n");
+		goto fail;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", ((reg_value & 0x20) >> 5));
+
+fail:
+	return ret;
+}
+
+static struct device_attribute ab8505_fg_sysfs_psy_attrs[] = {
+	__ATTR(powercut_flagtime, (S_IRUGO | S_IWUSR | S_IWGRP),
+		ab8505_powercut_flagtime_read, ab8505_powercut_flagtime_write),
+	__ATTR(powercut_maxtime, (S_IRUGO | S_IWUSR | S_IWGRP),
+		ab8505_powercut_maxtime_read, ab8505_powercut_maxtime_write),
+	__ATTR(powercut_restart_max, (S_IRUGO | S_IWUSR | S_IWGRP),
+		ab8505_powercut_restart_read, ab8505_powercut_restart_write),
+	__ATTR(powercut_timer, S_IRUGO, ab8505_powercut_timer_read, NULL),
+	__ATTR(powercut_restart_counter, S_IRUGO,
+		ab8505_powercut_restart_counter_read, NULL),
+	__ATTR(powercut_enable, (S_IRUGO | S_IWUSR | S_IWGRP),
+		ab8505_powercut_read, ab8505_powercut_write),
+	__ATTR(powercut_flag, S_IRUGO, ab8505_powercut_flag_read, NULL),
+	__ATTR(powercut_debounce_time, (S_IRUGO | S_IWUSR | S_IWGRP),
+		ab8505_powercut_debounce_read, ab8505_powercut_debounce_write),
+	__ATTR(powercut_enable_status, S_IRUGO,
+		ab8505_powercut_enable_status_read, NULL),
+};
+
 /* Exposure to the sysfs interface <<END>> */
 
 #if defined(CONFIG_PM)
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 1beaa05..21b3f67 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -89,6 +89,11 @@ struct abx500_fg;
  *				points.
  * @maint_thres			This is the threshold where we stop reporting
  *				battery full while in maintenance, in per cent
+ * @pcut_enable:			Enable power cut feature in ab8505
+ * @pcut_max_time:		Max time threshold
+ * @pcut_flag_time:		Flagtime threshold
+ * @pcut_max_restart:		Max number of restarts
+ * @pcut_debounce_time:		Sets battery debounce time
  */
 struct abx500_fg_parameters {
 	int recovery_sleep_timer;
@@ -106,6 +111,11 @@ struct abx500_fg_parameters {
 	int battok_raising_th_sel1;
 	int user_cap_limit;
 	int maint_thres;
+	bool pcut_enable;
+	u8 pcut_max_time;
+	u8 pcut_flag_time;
+	u8 pcut_max_restart;
+	u8 pcut_debounce_time;
 };
 
 /**
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 345bc15..ff2ac0b 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -235,6 +235,14 @@
 /* Battery type */
 #define BATTERY_UNKNOWN			00
 
+/* Registers for pcut feature in ab8505 and ab9540 */
+#define AB8505_RTC_PCUT_CTL_STATUS_REG	0x12
+#define AB8505_RTC_PCUT_TIME_REG	0x13
+#define AB8505_RTC_PCUT_MAX_TIME_REG	0x14
+#define AB8505_RTC_PCUT_FLAG_TIME_REG	0x15
+#define AB8505_RTC_PCUT_RESTART_REG	0x16
+#define AB8505_RTC_PCUT_DEBOUNCE_REG	0x17
+
 /**
  * struct res_to_temp - defines one point in a temp to res curve. To
  * be used in battery packs that combines the identification resistor with a
@@ -283,6 +291,11 @@ struct ab8500_fg;
  *				points.
  * @maint_thres			This is the threshold where we stop reporting
  *				battery full while in maintenance, in per cent
+ * @pcut_enable:			Enable power cut feature in ab8505
+ * @pcut_max_time:		Max time threshold
+ * @pcut_flag_time:		Flagtime threshold
+ * @pcut_max_restart:		Max number of restarts
+ * @pcut_debunce_time:	Sets battery debounce time
  */
 struct ab8500_fg_parameters {
 	int recovery_sleep_timer;
@@ -299,6 +312,11 @@ struct ab8500_fg_parameters {
 	int battok_raising_th_sel1;
 	int user_cap_limit;
 	int maint_thres;
+	bool pcut_enable;
+	u8 pcut_max_time;
+	u8 pcut_flag_time;
+	u8 pcut_max_restart;
+	u8 pcut_debunce_time;
 };
 
 /**
-- 
1.7.10.4

