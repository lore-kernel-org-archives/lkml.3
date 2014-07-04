Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965004AbaGDKpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:45:22 -0400
Received: from smtpfreer210.163vip.net ([61.135.158.117]:47573 "HELO
	smtp.tom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752622AbaGDKpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:45:21 -0400
Authentication-Results: bjzjm-antispam1 smtp.user=dudlx@tom.com; auth=pass (LOGIN)
From: "Dudley Du" <dudlx@tom.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Benson Leung" <bleung@google.com>,
        "Patrik Fimml" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Dudley Du" <dudl@cypress.com>
Subject: [PATCH v3 3/14] input: cyapa: add cyapa driver runtime power management interfaces support
Date: Fri, 4 Jul 2014 18:45:06 +0800
Message-ID: <001b01cf9775$0c7f4970$257ddc50$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac+XdQSiSfE8fTrHRaShz0UY98hyEg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add runtime_suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the runtime power
management strategy of trackpad device as their requirements.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c |  146 +++++++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cyapa.h |    4 ++
 2 files changed, 150 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 992e02f..6ed1df7 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -348,9 +348,16 @@ static int cyapa_check_is_operational(struct cyapa *cyapa)
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
 	/* interrupt event maybe cuased by host command to trackpad device. */
 	cont = true;
 	if (cyapa->ops->irq_cmd_handler)
@@ -375,6 +382,8 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 
 		cyapa_state_sync_exit(cyapa);
 	}
+
+	pm_runtime_put_sync_autosuspend(dev);
 out:
 	return IRQ_HANDLED;
 }
@@ -586,6 +595,91 @@ static const struct attribute_group cyapa_power_wakeup_group = {
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
+	if (!cyapa_state_sync_enter(cyapa))
+		return -EBUSY;
+	pwr_cmd = cyapa->runtime_suspend_power_mode;
+	sleep_time = cyapa->runtime_suspend_sleep_time;
+	cyapa_state_sync_exit(cyapa);
+
+	if (cyapa->gen == CYAPA_GEN3)
+		return scnprintf(buf, PAGE_SIZE, "%u\n",
+			cyapa_pwr_cmd_to_sleep_time(pwr_cmd));
+	else
+		return scnprintf(buf, PAGE_SIZE, "%u\n", sleep_time);
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
+	if (!cyapa_state_sync_enter(cyapa)) {
+		pm_runtime_put_sync_autosuspend(dev);
+		return -EBUSY;
+	}
+	cyapa->runtime_suspend_sleep_time = cyapa_clamp_sleep_time(time);
+	cyapa->runtime_suspend_power_mode =
+		cyapa_sleep_time_to_pwr_cmd(cyapa->runtime_suspend_sleep_time);
+	cyapa_state_sync_exit(cyapa);
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
@@ -601,7 +695,11 @@ void cyapa_detect_async(void *data, async_cookie_t cookie)
 
 static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
 {
+	struct cyapa *cyapa = data;
+
 	cyapa_detect_async(data, cookie);
+
+	cyapa_start_runtime(cyapa);
 }
 
 static int cyapa_tp_modules_init(struct cyapa *cyapa)
@@ -703,9 +801,15 @@ static int cyapa_remove(struct i2c_client *client)
 {
 	struct cyapa *cyapa = i2c_get_clientdata(client);
 
+	pm_runtime_disable(&client->dev);
+
 #ifdef CONFIG_PM_SLEEP
 	sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
 #endif
+
+#ifdef CONFIG_PM_RUNTIME
+	sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
+#endif
 	free_irq(cyapa->irq, cyapa);
 
 	input_unregister_device(cyapa->input);
@@ -764,12 +868,54 @@ static int cyapa_resume(struct device *dev)
 
 	async_schedule(cyapa_detect_async, cyapa);
 
+	/* runtime set active to reflect active state. */
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
+		/* set trackpad device to idle mode */
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
+		/* resume to full active mode */
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
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index b0ccb56..05f0178 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -210,6 +210,10 @@ struct cyapa {
 	/* power mode settings */
 	u8 suspend_power_mode;
 	u16 suspend_sleep_time;
+#ifdef CONFIG_PM_RUNTIME
+	u8 runtime_suspend_power_mode;
+	u16 runtime_suspend_sleep_time;
+#endif /* CONFIG_PM_RUNTIME */
 
 	/* read from query data region. */
 	char product_id[16];
-- 
1.7.9.5


