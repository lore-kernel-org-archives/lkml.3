Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaKSIjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:39:53 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:60356 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaKSIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:39:50 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 06/19] input: cyapa: add runtime power management interfaces supported for the device
Date: Wed, 19 Nov 2014 16:37:38 +0800
Message-Id: <1416386271-28167-7-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
References: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add runtime_suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the runtime power
management strategy of trackpad device as their requirements.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.c | 167 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cyapa.h |   4 ++
 2 files changed, 171 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 9fc60c3..64bb067 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 #include "cyapa.h"
 
 
@@ -153,6 +154,7 @@ static void cyapa_close(struct input_dev *input)
 
 	disable_irq(cyapa->client->irq);
 	cyapa->opened = false;
+	pm_runtime_disable(&cyapa->client->dev);
 
 	if (cyapa->operational && cyapa->ops->set_power_mode)
 		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
@@ -303,6 +305,7 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 	struct device *dev = &cyapa->client->dev;
 	bool cont;
 
+	pm_runtime_get_sync(dev);
 	if (device_may_wakeup(dev))
 		pm_wakeup_event(dev, 0);
 
@@ -327,6 +330,8 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 	}
 
 out:
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_sync_autosuspend(dev);
 	return IRQ_HANDLED;
 }
 
@@ -589,6 +594,116 @@ static void cyapa_remove_power_wakeup_group(void *data)
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
+	int error;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
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
+	int error;
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
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+	cyapa->runtime_suspend_sleep_time = max_t(u16, time, 1000);
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
+	struct device *dev = &cyapa->client->dev;
+	int error;
+
+	cyapa->runtime_suspend_power_mode = PWR_MODE_IDLE;
+	cyapa->runtime_suspend_sleep_time =
+		cyapa_pwr_cmd_to_sleep_time(cyapa->runtime_suspend_power_mode);
+
+	error = sysfs_merge_group(&dev->kobj, &cyapa_power_runtime_group);
+	if (error) {
+		dev_err(dev,
+			"failed to create power runtime group: %d\n", error);
+		return error;
+	}
+
+	error = devm_add_action(dev, cyapa_remove_power_runtime_group, cyapa);
+	if (error) {
+		cyapa_remove_power_runtime_group(cyapa);
+		dev_err(dev,
+			"failed to add power runtime cleanup action: %d\n",
+			error);
+		return error;
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
@@ -681,6 +796,14 @@ static int cyapa_probe(struct i2c_client *client,
 	}
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_RUNTIME
+	error = cyapa_start_runtime(cyapa);
+	if (error) {
+		dev_err(dev, "failed to start pm_runtime: %d\n", error);
+		return error;
+	}
+#endif /* CONFIG_PM_RUNTIME */
+
 	error = devm_request_threaded_irq(dev,
 					client->irq,
 					NULL,
@@ -715,6 +838,7 @@ static int __maybe_unused cyapa_suspend(struct device *dev)
 	if (error)
 		return error;
 
+	pm_runtime_disable(dev);
 	/*
 	 * Disable IRQ to avoid the command response interrupt cause system
 	 * suspending process interrupted and failed.
@@ -738,6 +862,8 @@ static int __maybe_unused cyapa_suspend(struct device *dev)
 					error);
 	}
 
+	pm_runtime_set_suspended(dev);
+
 	if (device_may_wakeup(dev))
 		cyapa->irq_wake = (enable_irq_wake(cyapa->client->irq) == 0);
 
@@ -757,18 +883,59 @@ static int __maybe_unused cyapa_resume(struct device *dev)
 		cyapa->irq_wake = false;
 	}
 
+	/* Runtime set active to reflect active state. */
+	pm_runtime_set_active(dev);
+
 	/* Re-detect device state and reset it to active power mode. */
 	cyapa_detect(cyapa);
 
 	if (cyapa->opened)
 		enable_irq(cyapa->client->irq);
 
+	pm_runtime_enable(dev);
+
 	mutex_unlock(&cyapa->state_sync_lock);
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int cyapa_runtime_suspend(struct device *dev)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int error;
+
+	if (cyapa->operational && cyapa->ops->set_power_mode) {
+		/* Set trackpad device to idle mode. */
+		error = cyapa->ops->set_power_mode(cyapa,
+				cyapa->runtime_suspend_power_mode,
+				cyapa->runtime_suspend_sleep_time);
+		if (error)
+			dev_err(dev, "runtime suspend failed: %d\n", error);
+	}
+
+	return 0;
+}
+
+static int cyapa_runtime_resume(struct device *dev)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int error;
+
+	if (cyapa->operational && cyapa->ops->set_power_mode) {
+		/* Resume to full active mode. */
+		error = cyapa->ops->set_power_mode(cyapa,
+				PWR_MODE_FULL_ACTIVE, 0);
+		if (error)
+			dev_err(dev, "runtime resume failed: %d\n", error);
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
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 10eaff0..a1a42f2 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -263,6 +263,10 @@ struct cyapa {
 	/* power mode settings */
 	u8 suspend_power_mode;
 	u16 suspend_sleep_time;
+#ifdef CONFIG_PM_RUNTIME
+	u8 runtime_suspend_power_mode;
+	u16 runtime_suspend_sleep_time;
+#endif /* CONFIG_PM_RUNTIME */
 	u8 dev_pwr_mode;
 	u16 dev_sleep_time;
 
-- 
1.9.1

