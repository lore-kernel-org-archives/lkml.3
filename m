Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaLQKBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:01:53 -0500
Received: from bay004-omc1s11.hotmail.com ([65.54.190.22]:49818 "EHLO
	BAY004-OMC1S11.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185AbaLQKBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:01:51 -0500
X-TMN: [NRDyfUp5lO0UCR8e+fk00p48tr/3AuNp]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY407-EAS96B6648AE092ACB76E358DBD6D0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <jmmahler@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v16 03/12] input: cyapa: add power management interfaces support
Date: Wed, 17 Dec 2014 17:56:49 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AdAZ3p2+9Tlkxz9LQiaB5sP5jTaqmQ==
Content-Language: zh-cn
X-OriginalArrivalTime: 17 Dec 2014 09:56:50.0703 (UTC) FILETIME=[C75EE1F0:01D019DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the power management
strategy of trackpad device as their requirements.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.c | 111 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index d4560a3..73f6817 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -575,6 +575,96 @@ out:
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
+	if (!count)
+		dev_err(dev, "invalid suspend scanrate ms parameters\n");
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
+#endif /* CONFIG_PM_SLEEP */
+
 static int cyapa_probe(struct i2c_client *client,
 		       const struct i2c_device_id *dev_id)
 {
@@ -614,6 +704,27 @@ static int cyapa_probe(struct i2c_client *client,
 		return error;
 	}
 
+#ifdef CONFIG_PM_SLEEP
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
+#endif /* CONFIG_PM_SLEEP */
+
 	error = devm_request_threaded_irq(dev, client->irq,
 					  NULL, cyapa_irq,
 					  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-- 
1.9.1

