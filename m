Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaJOHU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:20:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57293 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaJOHUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:20:24 -0400
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com, patrikf@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] input: cyapa: add cyapa driver power management interfaces support
Date: Wed, 15 Oct 2014 15:19:16 +0800
Message-Id: <1413357567-26177-3-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413357567-26177-1-git-send-email-dudl@cypress.com>
References: <1413357567-26177-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the power management
strategy of trackpad device as their requirements.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 112 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 4468e42..cf2fcc4 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -458,6 +458,96 @@ u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode)
 				   : (encoded_time - 5) * 20;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static ssize_t cyapa_show_suspend_scanrate(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	u8 pwr_cmd = cyapa->suspend_power_mode;
+	u16 sleep_time;
+	int len;
+	int ret;
+
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
+	pwr_cmd = cyapa->suspend_power_mode;
+	sleep_time = cyapa->suspend_sleep_time;
+	mutex_unlock(&cyapa->state_sync_lock);
+
+	if (pwr_cmd == PWR_MODE_BTN_ONLY)
+		len = scnprintf(buf, PAGE_SIZE, "%s\n", BTN_ONLY_MODE_NAME);
+	else if (pwr_cmd == PWR_MODE_OFF)
+		len = scnprintf(buf, PAGE_SIZE, "%s\n", OFF_MODE_NAME);
+	else {
+		if (cyapa->gen == CYAPA_GEN3)
+			sleep_time = cyapa_pwr_cmd_to_sleep_time(pwr_cmd);
+		len = scnprintf(buf, PAGE_SIZE, "%u\n", sleep_time);
+	}
+
+	return len;
+}
+
+static u16 cyapa_clamp_sleep_time(u16 sleep_time)
+{
+	if (sleep_time > 1000)
+		sleep_time = 1000;
+	return sleep_time;
+}
+
+static ssize_t cyapa_update_suspend_scanrate(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	u16 sleep_time;
+	int ret;
+
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
+
+	if (sysfs_streq(buf, BTN_ONLY_MODE_NAME))
+		cyapa->suspend_power_mode = PWR_MODE_BTN_ONLY;
+	else if (sysfs_streq(buf, OFF_MODE_NAME))
+		cyapa->suspend_power_mode = PWR_MODE_OFF;
+	else if (!kstrtou16(buf, 10, &sleep_time)) {
+		cyapa->suspend_sleep_time = cyapa_clamp_sleep_time(sleep_time);
+		cyapa->suspend_power_mode =
+			cyapa_sleep_time_to_pwr_cmd(cyapa->suspend_sleep_time);
+	} else
+		count = 0;
+
+	mutex_unlock(&cyapa->state_sync_lock);
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
 void cyapa_sync_detect(void *data, async_cookie_t cookie)
 {
 	cyapa_detect_with_lock((struct cyapa *)data);
@@ -576,6 +666,28 @@ static int cyapa_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
+#ifdef CONFIG_PM_SLEEP
+	if (device_can_wakeup(dev)) {
+		ret = sysfs_merge_group(&client->dev.kobj,
+					&cyapa_power_wakeup_group);
+		if (ret) {
+			dev_err(dev, "failed to add power wakeup group, (%d)\n",
+				ret);
+			return ret;
+		}
+
+		ret = devm_add_action(dev,
+				cyapa_remove_power_wakeup_group, cyapa);
+		if (ret) {
+			cyapa_remove_power_wakeup_group(cyapa);
+			dev_err(dev,
+				"failed to add power cleanup action, (%d)\n",
+				ret);
+			return ret;
+		}
+	}
+#endif /* CONFIG_PM_SLEEP */
+
 	return 0;
 }
 
-- 
1.9.1

