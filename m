Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaLaBVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:21:24 -0500
Received: from smtp1.cypress.com ([157.95.67.100]:60387 "EHLO
	smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaLaBR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:17:57 -0500
From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, jmmahler@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v17 03/12] input: cyapa: add power management interfaces support for the device
Date: Wed, 31 Dec 2014 09:16:52 +0800
Message-Id: <1419988621-2919-4-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419988621-2919-1-git-send-email-dudl@cypress.com>
References: <1419988621-2919-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the power management
strategy of trackpad device as their requirements.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 127 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 725c84a..46d3830 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -604,6 +604,127 @@ out:
 	return IRQ_HANDLED;
 }
 
+/*
+ **************************************************************
+ * sysfs interface
+ **************************************************************
+*/
+#ifdef CONFIG_PM_SLEEP
+static ssize_t cyapa_show_suspend_scanrate(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	u8 pwr_cmd = cyapa->suspend_power_mode;
+	u16 sleep_time;
+	int len;
+	int error;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+	pwr_cmd = cyapa->suspend_power_mode;
+	sleep_time = cyapa->suspend_sleep_time;
+	mutex_unlock(&cyapa->state_sync_lock);
+
+	if (pwr_cmd == PWR_MODE_BTN_ONLY) {
+		len = scnprintf(buf, PAGE_SIZE, "%s\n", BTN_ONLY_MODE_NAME);
+	} else if (pwr_cmd == PWR_MODE_OFF) {
+		len = scnprintf(buf, PAGE_SIZE, "%s\n", OFF_MODE_NAME);
+	} else {
+		if (cyapa->gen == CYAPA_GEN3)
+			sleep_time = cyapa_pwr_cmd_to_sleep_time(pwr_cmd);
+		len = scnprintf(buf, PAGE_SIZE, "%u\n", sleep_time);
+	}
+
+	return len;
+}
+
+static ssize_t cyapa_update_suspend_scanrate(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	u16 sleep_time;
+	int error;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+
+	if (sysfs_streq(buf, BTN_ONLY_MODE_NAME)) {
+		cyapa->suspend_power_mode = PWR_MODE_BTN_ONLY;
+	} else if (sysfs_streq(buf, OFF_MODE_NAME)) {
+		cyapa->suspend_power_mode = PWR_MODE_OFF;
+	} else if (!kstrtou16(buf, 10, &sleep_time)) {
+		cyapa->suspend_sleep_time = max_t(u16, sleep_time, 1000);
+		cyapa->suspend_power_mode =
+			cyapa_sleep_time_to_pwr_cmd(cyapa->suspend_sleep_time);
+	} else {
+		count = 0;
+	}
+
+	mutex_unlock(&cyapa->state_sync_lock);
+
+	return count ? count : -EINVAL;
+}
+
+static DEVICE_ATTR(suspend_scanrate_ms, S_IRUGO|S_IWUSR,
+		   cyapa_show_suspend_scanrate,
+		   cyapa_update_suspend_scanrate);
+
+static struct attribute *cyapa_power_wakeup_entries[] = {
+	&dev_attr_suspend_scanrate_ms.attr,
+	NULL,
+};
+
+static const struct attribute_group cyapa_power_wakeup_group = {
+	.name = power_group_name,
+	.attrs = cyapa_power_wakeup_entries,
+};
+
+static void cyapa_remove_power_wakeup_group(void *data)
+{
+	struct cyapa *cyapa = data;
+
+	sysfs_unmerge_group(&cyapa->client->dev.kobj,
+				&cyapa_power_wakeup_group);
+}
+
+static int cyapa_prepare_wakeup_controls(struct cyapa *cyapa)
+{
+	struct i2c_client *client = cyapa->client;
+	struct device *dev = &client->dev;
+	int error;
+
+	if (device_can_wakeup(dev)) {
+		error = sysfs_merge_group(&client->dev.kobj,
+					&cyapa_power_wakeup_group);
+		if (error) {
+			dev_err(dev, "failed to add power wakeup group: %d\n",
+				error);
+			return error;
+		}
+
+		error = devm_add_action(dev,
+				cyapa_remove_power_wakeup_group, cyapa);
+		if (error) {
+			cyapa_remove_power_wakeup_group(cyapa);
+			dev_err(dev, "failed to add power cleanup action: %d\n",
+				error);
+			return error;
+		}
+	}
+
+	return 0;
+}
+#else
+static inline int cyapa_prepare_wakeup_controls(struct cyapa *cyapa)
+{
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
 static int cyapa_probe(struct i2c_client *client,
 		       const struct i2c_device_id *dev_id)
 {
@@ -643,6 +764,12 @@ static int cyapa_probe(struct i2c_client *client,
 		return error;
 	}
 
+	error = cyapa_prepare_wakeup_controls(cyapa);
+	if (error) {
+		dev_err(dev, "failed to prepare wakeup controls: %d\n", error);
+		return error;
+	}
+
 	error = devm_request_threaded_irq(dev, client->irq,
 					  NULL, cyapa_irq,
 					  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-- 
1.9.1

