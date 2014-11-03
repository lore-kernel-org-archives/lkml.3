Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaKCIfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:35:39 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51756 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaKCIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:35:35 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 06/18] input: cyapa: add runtime power management interfaces supported for the device
Date: Mon,  3 Nov 2014 16:32:58 +0800
Message-Id: <1415003590-30485-7-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003590-30485-1-git-send-email-dudl@cypress.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add runtime_suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the runtime power
management strategy of trackpad device as their requirements.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 168 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 420696d..d4b7c42 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 #include "cyapa.h"
 
 
@@ -259,6 +260,7 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 	bool cont;
 	int ret;
 
+	pm_runtime_get_sync(dev);
 	if (device_may_wakeup(dev))
 		pm_wakeup_event(dev, 0);
 
@@ -282,6 +284,8 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 	}
 
 out:
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_sync_autosuspend(dev);
 	return IRQ_HANDLED;
 }
 
@@ -595,6 +599,116 @@ static void cyapa_remove_power_wakeup_group(void *data)
 }
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_RUNTIME
+static ssize_t cyapa_show_rt_suspend_scanrate(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	u8 pwr_cmd;
+	u16 sleep_time;
+	int ret;
+
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
+	pwr_cmd = cyapa->runtime_suspend_power_mode;
+	sleep_time = cyapa->runtime_suspend_sleep_time;
+	mutex_unlock(&cyapa->state_sync_lock);
+
+	if (cyapa->gen == CYAPA_GEN3)
+		return scnprintf(buf, PAGE_SIZE, "%u\n",
+			cyapa_pwr_cmd_to_sleep_time(pwr_cmd));
+	return scnprintf(buf, PAGE_SIZE, "%u\n", sleep_time);
+}
+
+static ssize_t cyapa_update_rt_suspend_scanrate(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	u16 time;
+	int ret;
+
+	if (buf == NULL || count == 0 || kstrtou16(buf, 10, &time)) {
+		dev_err(dev, "invalid runtime suspend scanrate ms parameter\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * When the suspend scanrate is changed, pm_runtime_get to resume
+	 * a potentially suspended device, update to the new pwr_cmd
+	 * and then pm_runtime_put to suspend into the new power mode.
+	 */
+	pm_runtime_get_sync(dev);
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
+	cyapa->runtime_suspend_sleep_time = cyapa_clamp_sleep_time(time);
+	cyapa->runtime_suspend_power_mode =
+		cyapa_sleep_time_to_pwr_cmd(cyapa->runtime_suspend_sleep_time);
+	mutex_unlock(&cyapa->state_sync_lock);
+	pm_runtime_put_sync_autosuspend(dev);
+
+	return count;
+}
+
+static DEVICE_ATTR(runtime_suspend_scanrate_ms, S_IRUGO|S_IWUSR,
+		   cyapa_show_rt_suspend_scanrate,
+		   cyapa_update_rt_suspend_scanrate);
+
+static struct attribute *cyapa_power_runtime_entries[] = {
+	&dev_attr_runtime_suspend_scanrate_ms.attr,
+	NULL,
+};
+
+static const struct attribute_group cyapa_power_runtime_group = {
+	.name = power_group_name,
+	.attrs = cyapa_power_runtime_entries,
+};
+
+static void cyapa_remove_power_runtime_group(void *data)
+{
+	struct cyapa *cyapa = data;
+
+	sysfs_unmerge_group(&cyapa->client->dev.kobj,
+				&cyapa_power_runtime_group);
+}
+
+static int cyapa_start_runtime(struct cyapa *cyapa)
+{
+	int ret;
+	struct device *dev = &cyapa->client->dev;
+
+	cyapa->runtime_suspend_power_mode = PWR_MODE_IDLE;
+	cyapa->runtime_suspend_sleep_time =
+		cyapa_pwr_cmd_to_sleep_time(cyapa->runtime_suspend_power_mode);
+
+	ret = sysfs_merge_group(&dev->kobj, &cyapa_power_runtime_group);
+	if (ret) {
+		dev_err(dev,
+			"failed to create power runtime group, %d\n", ret);
+		return ret;
+	}
+
+	ret = devm_add_action(dev, cyapa_remove_power_runtime_group, cyapa);
+	if (ret) {
+		cyapa_remove_power_runtime_group(cyapa);
+		dev_err(dev,
+			"failed to add power runtime cleanup action, (%d)\n",
+			ret);
+		return ret;
+	}
+
+	pm_runtime_set_active(dev);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, AUTOSUSPEND_DELAY);
+	pm_runtime_enable(dev);
+
+	return 0;
+}
+#endif /* CONFIG_PM_RUNTIME */
+
 /*
  * Returns:
  *   0    Driver and device initialization successfully done.
@@ -700,6 +814,14 @@ static int cyapa_probe(struct i2c_client *client,
 	}
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_RUNTIME
+	ret = cyapa_start_runtime(cyapa);
+	if (ret) {
+		dev_err(dev, "failed to start pm_runtime, (%d)\n, ", ret);
+		return ret;
+	}
+#endif /* CONFIG_PM_RUNTIME */
+
 	return 0;
 }
 
@@ -712,6 +834,8 @@ static int cyapa_remove(struct i2c_client *client)
 	if (cyapa->ops->set_power_mode)
 		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
 
+	pm_runtime_disable(&client->dev);
+
 	return 0;
 }
 
@@ -728,6 +852,7 @@ static int cyapa_suspend(struct device *dev)
 		return ret;
 	}
 
+	pm_runtime_disable(dev);
 	/*
 	 * Disable IRQ to avoid the command response interrupt cause system
 	 * suspending process interrupted and failed.
@@ -750,6 +875,8 @@ static int cyapa_suspend(struct device *dev)
 					ret);
 	}
 
+	pm_runtime_set_suspended(dev);
+
 	if (device_may_wakeup(dev))
 		cyapa->irq_wake = (enable_irq_wake(cyapa->client->irq) == 0);
 
@@ -771,19 +898,60 @@ static int cyapa_resume(struct device *dev)
 		cyapa->irq_wake = false;
 	}
 
+	/* Runtime set active to reflect active state. */
+	pm_runtime_set_active(dev);
+
 	/* Reset to active power state after re-detected. */
 	cyapa_detect(cyapa);
 
 	enable_irq(cyapa->client->irq);
 
+	pm_runtime_enable(dev);
+
 	if (!ret)
 		mutex_unlock(&cyapa->state_sync_lock);
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_RUNTIME
+static int cyapa_runtime_suspend(struct device *dev)
+{
+	int ret;
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+
+	if (cyapa->input && cyapa->ops->set_power_mode) {
+		/* Set trackpad device to idle mode. */
+		ret = cyapa->ops->set_power_mode(cyapa,
+				cyapa->runtime_suspend_power_mode,
+				cyapa->runtime_suspend_sleep_time);
+		if (ret)
+			dev_err(dev, "runtime suspend failed, %d\n", ret);
+	}
+
+	return 0;
+}
+
+static int cyapa_runtime_resume(struct device *dev)
+{
+	int ret;
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+
+	if (cyapa->input && cyapa->ops->set_power_mode) {
+		/* Resume to full active mode. */
+		ret = cyapa->ops->set_power_mode(cyapa,
+				PWR_MODE_FULL_ACTIVE, 0);
+		if (ret)
+			dev_err(dev, "runtime resume failed, %d\n", ret);
+	}
+
+	return 0;
+}
+#endif /* CONFIG_PM_RUNTIME */
+
 static const struct dev_pm_ops cyapa_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(cyapa_suspend, cyapa_resume)
+	SET_RUNTIME_PM_OPS(cyapa_runtime_suspend, cyapa_runtime_resume, NULL)
 };
 
 static const struct i2c_device_id cyapa_id_table[] = {
-- 
1.9.1

