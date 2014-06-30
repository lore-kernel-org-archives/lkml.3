Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaF3GmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:42:06 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:16465
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbaF3GmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:42:04 -0400
From: Dudley Du <dudl@cypress.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "patrikf@google.com" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/14] input: cyapa: add cyapa driver runtime power
 management interfaces supported
Thread-Topic: [PATCH v2 3/14] input: cyapa: add cyapa driver runtime power
 management interfaces supported
Thread-Index: Ac+ULmPJqdmKpUt/QhG18d0bCVmQDA==
Date: Mon, 30 Jun 2014 06:42:00 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902C39@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.30.12.155]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5U6gCIA009564

Add runtime_suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the runtime power
management strategy of trackpad device as their requirements.
TEST=test on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 1dfc16d..c2b67d3 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -346,9 +346,16 @@ static int cyapa_check_is_operational(struct cyapa *cyapa)
 static irqreturn_t cyapa_irq(int irq, void *dev_id)
 {
        struct cyapa *cyapa = dev_id;
+       struct device *dev = &cyapa->client->dev;
        struct input_dev *input = cyapa->input;
        bool cont;

+       pm_runtime_get_sync(dev);
+       pm_runtime_mark_last_busy(dev);
+
+       if (device_may_wakeup(dev))
+               pm_wakeup_event(dev, 0);
+
        /* interrupt event maybe cuased by host command to trackpad device. */
        cont = true;
        if (cyapa->ops->cyapa_irq_cmd_handler)
@@ -373,6 +380,8 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)

                cyapa_state_sync_exit(cyapa);
        }
+
+       pm_runtime_put_sync_autosuspend(dev);
 out:
        return IRQ_HANDLED;
 }
@@ -574,6 +583,79 @@ static const struct attribute_group cyapa_power_wakeup_group = {
 };
 #endif /* CONFIG_PM_SLEEP */

+#ifdef CONFIG_PM_RUNTIME
+static ssize_t cyapa_show_rt_suspend_scanrate(struct device *dev,
+                                             struct device_attribute *attr,
+                                             char *buf)
+{
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+       u8 pwr_cmd = cyapa->runtime_suspend_power_mode;
+
+       if (cyapa->gen == CYAPA_GEN3)
+               return scnprintf(buf, PAGE_SIZE, "%u\n",
+                       cyapa_pwr_cmd_to_sleep_time(pwr_cmd));
+       else
+               return scnprintf(buf, PAGE_SIZE, "%u\n",
+                       cyapa->runtime_suspend_sleep_time);
+}
+
+static ssize_t cyapa_update_rt_suspend_scanrate(struct device *dev,
+                                               struct device_attribute *attr,
+                                               const char *buf, size_t count)
+{
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+       u16 time;
+
+       if (buf == NULL || count == 0 || kstrtou16(buf, 10, &time)) {
+               dev_err(dev, "invalid runtime suspend scanrate ms parameter\n");
+               return -EINVAL;
+       }
+
+       /*
+        * When the suspend scanrate is changed, pm_runtime_get to resume
+        * a potentially suspended device, update to the new pwr_cmd
+        * and then pm_runtime_put to suspend into the new power mode.
+        */
+       pm_runtime_get_sync(dev);
+       cyapa->runtime_suspend_sleep_time = cyapa_sleep_time_check(time);
+       cyapa->runtime_suspend_power_mode =
+               cyapa_sleep_time_to_pwr_cmd(cyapa->runtime_suspend_sleep_time);
+       pm_runtime_put_sync_autosuspend(dev);
+       return count;
+}
+
+static DEVICE_ATTR(runtime_suspend_scanrate_ms, S_IRUGO|S_IWUSR,
+                  cyapa_show_rt_suspend_scanrate,
+                  cyapa_update_rt_suspend_scanrate);
+
+static struct attribute *cyapa_power_runtime_entries[] = {
+       &dev_attr_runtime_suspend_scanrate_ms.attr,
+       NULL,
+};
+
+static const struct attribute_group cyapa_power_runtime_group = {
+       .name = power_group_name,
+       .attrs = cyapa_power_runtime_entries,
+};
+
+static void cyapa_start_runtime(struct cyapa *cyapa)
+{
+       struct device *dev = &cyapa->client->dev;
+
+       cyapa->runtime_suspend_power_mode = PWR_MODE_IDLE;
+       cyapa->runtime_suspend_sleep_time =
+               cyapa_pwr_cmd_to_sleep_time(cyapa->runtime_suspend_power_mode);
+       if (sysfs_merge_group(&dev->kobj, &cyapa_power_runtime_group))
+               dev_warn(dev, "error creating wakeup runtime entries.\n");
+       pm_runtime_set_active(dev);
+       pm_runtime_use_autosuspend(dev);
+       pm_runtime_set_autosuspend_delay(dev, AUTOSUSPEND_DELAY);
+       pm_runtime_enable(dev);
+}
+#else
+static void cyapa_start_runtime(struct cyapa *cyapa) {}
+#endif /* CONFIG_PM_RUNTIME */
+
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa = (struct cyapa *)data;
@@ -589,7 +671,11 @@ void cyapa_detect_async(void *data, async_cookie_t cookie)

 static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
 {
+       struct cyapa *cyapa = data;
+
        cyapa_detect_async(data, cookie);
+
+       cyapa_start_runtime(cyapa);
 }

 static int cyapa_probe(struct i2c_client *client,
@@ -675,9 +761,15 @@ static int cyapa_remove(struct i2c_client *client)
 {
        struct cyapa *cyapa = i2c_get_clientdata(client);

+       pm_runtime_disable(&client->dev);
+
 #ifdef CONFIG_PM_SLEEP
        sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
 #endif
+
+#ifdef CONFIG_PM_RUNTIME
+       sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
+#endif
        free_irq(cyapa->irq, cyapa);

        input_unregister_device(cyapa->input);
@@ -735,12 +827,54 @@ static int cyapa_resume(struct device *dev)

        async_schedule(cyapa_detect_async, cyapa);

+       /* runtime set active to reflect active state. */
+       pm_runtime_disable(dev);
+       pm_runtime_set_active(dev);
+       pm_runtime_enable(dev);
        return 0;
 }
 #endif /* CONFIG_PM_SLEEP */

+#ifdef CONFIG_PM_RUNTIME
+static int cyapa_runtime_suspend(struct device *dev)
+{
+       int ret;
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+
+       if (cyapa->ops->cyapa_set_power_mode) {
+               /* set trackpad device to idle mode */
+               ret = cyapa->ops->cyapa_set_power_mode(cyapa,
+                               cyapa->runtime_suspend_power_mode,
+                               cyapa->runtime_suspend_sleep_time);
+               if (ret)
+                       dev_err(dev, "runtime suspend failed, %d\n", ret);
+               return ret;
+       }
+
+       return 0;
+}
+
+static int cyapa_runtime_resume(struct device *dev)
+{
+       int ret;
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+
+       if (cyapa->ops->cyapa_set_power_mode) {
+               /* resume to full active mode */
+               ret = cyapa->ops->cyapa_set_power_mode(cyapa,
+                               PWR_MODE_FULL_ACTIVE, 0);
+               if (ret)
+                       dev_err(dev, "runtime resume failed, %d\n", ret);
+               return ret;
+       }
+
+       return 0;
+}
+#endif /* CONFIG_PM_RUNTIME */
+
 static const struct dev_pm_ops cyapa_pm_ops = {
        SET_SYSTEM_SLEEP_PM_OPS(cyapa_suspend, cyapa_resume)
+       SET_RUNTIME_PM_OPS(cyapa_runtime_suspend, cyapa_runtime_resume, NULL)
 };

 static const struct i2c_device_id cyapa_id_table[] = {
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 1780d82..91fb84a 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -199,6 +199,10 @@ struct cyapa {
        /* power mode settings */
        u8 suspend_power_mode;
        u16 suspend_sleep_time;
+#ifdef CONFIG_PM_RUNTIME
+       u8 runtime_suspend_power_mode;
+       u16 runtime_suspend_sleep_time;
+#endif /* CONFIG_PM_RUNTIME */

        /* read from query data region. */
        char product_id[16];
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
