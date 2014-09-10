Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaIJEjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:39:36 -0400
Received: from bay004-omc1s22.hotmail.com ([65.54.190.33]:49788 "EHLO
	BAY004-OMC1S22.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186AbaIJEje convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:39:34 -0400
X-TMN: [DPRbcDCM+fKU6ZTiRbasOde34TSvWwpg]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS11EE3CB0452DEB0B00E867BDCF0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 03/13] input: cyapa: add cyapa driver runtime power management interfaces support
Date: Wed, 10 Sep 2014 12:34:27 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/MsIGBpq5Qb9DnRmyaAQxtzfaMVA==
Content-Language: zh-cn
X-OriginalArrivalTime: 10 Sep 2014 04:34:28.0682 (UTC) FILETIME=[822532A0:01CFCCB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add runtime_suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the runtime power
management strategy of trackpad device as their requirements.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 142 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index d61ccbc..eb3a5a8 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -271,9 +271,16 @@ static int cyapa_check_is_operational(struct cyapa *cyapa)
 static irqreturn_t cyapa_irq(int irq, void *dev_id)
 {
 	struct cyapa *cyapa = dev_id;
+	struct device *dev = &cyapa->client->dev;
 	struct input_dev *input = cyapa->input;
 	bool cont;
 
+	pm_runtime_get_sync(dev);
+	pm_runtime_mark_last_busy(dev);
+
+	if (device_may_wakeup(dev))
+		pm_wakeup_event(dev, 0);
+
 	/* Interrupt event maybe cuased by host command to trackpad device. */
 	cont = true;
 	if (cyapa->ops->irq_cmd_handler)
@@ -297,6 +304,8 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 
 		mutex_unlock(&cyapa->state_sync_lock);
 	}
+
+	pm_runtime_put_sync_autosuspend(dev);
 out:
 	return IRQ_HANDLED;
 }
@@ -503,6 +512,86 @@ static const struct attribute_group cyapa_power_wakeup_group = {
 };
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_RUNTIME
+static ssize_t cyapa_show_rt_suspend_scanrate(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	u8 pwr_cmd;
+	u16 sleep_time;
+
+	mutex_lock(&cyapa->state_sync_lock);
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
+	mutex_lock(&cyapa->state_sync_lock);
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
+static void cyapa_start_runtime(struct cyapa *cyapa)
+{
+	struct device *dev = &cyapa->client->dev;
+
+	cyapa->runtime_suspend_power_mode = PWR_MODE_IDLE;
+	cyapa->runtime_suspend_sleep_time =
+		cyapa_pwr_cmd_to_sleep_time(cyapa->runtime_suspend_power_mode);
+	if (sysfs_merge_group(&dev->kobj, &cyapa_power_runtime_group))
+		dev_warn(dev, "error creating wakeup runtime entries.\n");
+	pm_runtime_set_active(dev);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, AUTOSUSPEND_DELAY);
+	pm_runtime_enable(dev);
+}
+#else
+static void cyapa_start_runtime(struct cyapa *cyapa) {}
+#endif /* CONFIG_PM_RUNTIME */
+
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
 	struct cyapa *cyapa = (struct cyapa *)data;
@@ -521,7 +610,11 @@ void cyapa_detect_async(void *data, async_cookie_t cookie)
 
 static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
 {
+	struct cyapa *cyapa = data;
+
 	cyapa_detect_async(data, cookie);
+
+	cyapa_start_runtime(cyapa);
 }
 
 static int cyapa_tp_modules_init(struct cyapa *cyapa)
@@ -625,9 +718,16 @@ static int cyapa_remove(struct i2c_client *client)
 	cyapa->removed = true;
 	mutex_unlock(&cyapa->state_sync_lock);
 
+	pm_runtime_disable(&client->dev);
+
 #ifdef CONFIG_PM_SLEEP
 	sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
 #endif
+
+#ifdef CONFIG_PM_RUNTIME
+	sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
+#endif
+
 	free_irq(cyapa->irq, cyapa);
 
 	input_unregister_device(cyapa->input);
@@ -694,12 +794,54 @@ static int cyapa_resume(struct device *dev)
 
 	async_schedule(cyapa_detect_async, cyapa);
 
+	/* Update runtime power management to reflect active state. */
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_RUNTIME
+static int cyapa_runtime_suspend(struct device *dev)
+{
+	int ret;
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+
+	if (cyapa->ops->set_power_mode) {
+		/* Set trackpad device to idle mode. */
+		ret = cyapa->ops->set_power_mode(cyapa,
+				cyapa->runtime_suspend_power_mode,
+				cyapa->runtime_suspend_sleep_time);
+		if (ret)
+			dev_err(dev, "runtime suspend failed, %d\n", ret);
+		return ret;
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
+	if (cyapa->ops->set_power_mode) {
+		/* Resume to full active mode. */
+		ret = cyapa->ops->set_power_mode(cyapa,
+				PWR_MODE_FULL_ACTIVE, 0);
+		if (ret)
+			dev_err(dev, "runtime resume failed, %d\n", ret);
+		return ret;
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


