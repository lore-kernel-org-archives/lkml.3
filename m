Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbbAPGfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 01:35:42 -0500
Received: from smtp1.cypress.com ([157.95.67.100]:49105 "EHLO
	smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbbAPGfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 01:35:10 -0500
From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, jmmahler@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v18 04/12] input: cyapa: add runtime power management interfaces support for the device
Date: Fri, 16 Jan 2015 14:34:07 +0800
Message-Id: <1421390055-32760-5-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421390055-32760-1-git-send-email-dudl@cypress.com>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add runtime_suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the runtime power
management strategy of trackpad device as their requirements.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 184 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/input/mouse/cyapa.h |   4 +
 2 files changed, 187 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index eb0e515..43fa0cb 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 #include "cyapa.h"
 
 
@@ -357,6 +358,10 @@ static int cyapa_open(struct input_dev *input)
 	}
 
 	enable_irq(client->irq);
+	if (!pm_runtime_enabled(&client->dev)) {
+		pm_runtime_set_active(&client->dev);
+		pm_runtime_enable(&client->dev);
+	}
 out:
 	mutex_unlock(&cyapa->state_sync_lock);
 	return error;
@@ -370,6 +375,10 @@ static void cyapa_close(struct input_dev *input)
 	mutex_lock(&cyapa->state_sync_lock);
 
 	disable_irq(client->irq);
+	if (pm_runtime_enabled(&client->dev))
+		pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+
 	if (cyapa->operational)
 		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
 
@@ -539,6 +548,9 @@ static int cyapa_reinitialize(struct cyapa *cyapa)
 	struct input_dev *input = cyapa->input;
 	int error;
 
+	if (pm_runtime_enabled(dev))
+		pm_runtime_disable(dev);
+
 	/* Avoid command failures when TP was in OFF state. */
 	if (cyapa->operational)
 		cyapa->ops->set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE, 0);
@@ -561,6 +573,13 @@ out:
 		/* Reset to power OFF state to save power when no user open. */
 		if (cyapa->operational)
 			cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
+	} else if (!error && cyapa->operational) {
+		/*
+		 * Make sure only enable runtime PM when device is
+		 * in operational mode and input->users > 0.
+		 */
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
 	}
 
 	return error;
@@ -571,6 +590,7 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 	struct cyapa *cyapa = dev_id;
 	struct device *dev = &cyapa->client->dev;
 
+	pm_runtime_get_sync(dev);
 	if (device_may_wakeup(dev))
 		pm_wakeup_event(dev, 0);
 
@@ -601,6 +621,8 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 	}
 
 out:
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_sync_autosuspend(dev);
 	return IRQ_HANDLED;
 }
 
@@ -725,6 +747,118 @@ static inline int cyapa_prepare_wakeup_controls(struct cyapa *cyapa)
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
+	/* runtime is enabled until device is operational and opened. */
+	pm_runtime_set_suspended(dev);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, AUTOSUSPEND_DELAY);
+
+	return 0;
+}
+#else
+static inline int cyapa_start_runtime(struct cyapa *cyapa) { return 0; }
+#endif /* CONFIG_PM_RUNTIME */
+
 static int cyapa_probe(struct i2c_client *client,
 		       const struct i2c_device_id *dev_id)
 {
@@ -770,6 +904,12 @@ static int cyapa_probe(struct i2c_client *client,
 		return error;
 	}
 
+	error = cyapa_start_runtime(cyapa);
+	if (error) {
+		dev_err(dev, "failed to start pm_runtime: %d\n", error);
+		return error;
+	}
+
 	error = devm_request_threaded_irq(dev, client->irq,
 					  NULL, cyapa_irq,
 					  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
@@ -810,6 +950,13 @@ static int __maybe_unused cyapa_suspend(struct device *dev)
 	if (error)
 		return error;
 
+	/*
+	 * Runtime PM is enable only when device is in operational mode and
+	 * users in use, so need check it before disable it to
+	 * avoid unbalance warning.
+	 */
+	if (pm_runtime_enabled(dev))
+		pm_runtime_disable(dev);
 	disable_irq(client->irq);
 
 	/*
@@ -846,6 +993,7 @@ static int __maybe_unused cyapa_resume(struct device *dev)
 		cyapa->irq_wake = false;
 	}
 
+	/* Update device states and runtime PM states. */
 	error = cyapa_reinitialize(cyapa);
 	if (error)
 		dev_warn(dev, "failed to reinitialize TP device: %d\n", error);
@@ -856,7 +1004,41 @@ static int __maybe_unused cyapa_resume(struct device *dev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(cyapa_pm_ops, cyapa_suspend, cyapa_resume);
+#ifdef CONFIG_PM_RUNTIME
+static int cyapa_runtime_suspend(struct device *dev)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int error;
+
+	error = cyapa->ops->set_power_mode(cyapa,
+			cyapa->runtime_suspend_power_mode,
+			cyapa->runtime_suspend_sleep_time);
+	if (error)
+		dev_warn(dev, "runtime suspend failed: %d\n", error);
+
+	return 0;
+}
+
+static int cyapa_runtime_resume(struct device *dev)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int error;
+
+	error = cyapa->ops->set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE, 0);
+	if (error)
+		dev_warn(dev, "runtime resume failed: %d\n", error);
+
+	return 0;
+}
+#else
+static inline int cyapa_runtime_suspend(struct device *dev) { return 0; }
+static inline int cyapa_runtime_resume(struct device *dev) { return 0; }
+#endif /* CONFIG_PM_RUNTIME */
+
+static const struct dev_pm_ops cyapa_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(cyapa_suspend, cyapa_resume)
+	SET_RUNTIME_PM_OPS(cyapa_runtime_suspend, cyapa_runtime_resume, NULL)
+};
 
 static const struct i2c_device_id cyapa_id_table[] = {
 	{ "cyapa", 0 },
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 481a60d..f5a2c22 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -242,6 +242,10 @@ struct cyapa {
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

