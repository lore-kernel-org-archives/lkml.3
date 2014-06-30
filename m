Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaF3Gll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:41:41 -0400
Received: from relay-s04-hub001.domainlocalhost.com ([74.115.207.100]:19556
	"EHLO relay-S04-HUB001.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438AbaF3Gl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:41:26 -0400
From: Dudley Du <dudl@cypress.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "patrikf@google.com" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/14] input: cyapa: add cyapa driver power management
 interfaces supported
Thread-Topic: [PATCH v2 2/14] input: cyapa: add cyapa driver power
 management interfaces supported
Thread-Index: Ac+ULk6rkjvnGkFiRfST7BFFVYey3g==
Date: Mon, 30 Jun 2014 06:41:23 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902C12@S04-MBX01-01.s04.local>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5U6flNn009556

Add suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the power management
strategy of trackpad device as their requirements.
TEST=test on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index d5adee8..1dfc16d 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -462,6 +462,10 @@ static void cyapa_detect(struct cyapa *cyapa)
 }

 /*
+ * Sysfs Interface.
+ */
+
+/*
  * cyapa_sleep_time_to_pwr_cmd and cyapa_pwr_cmd_to_sleep_time
  *
  * These are helper functions that convert to and from integer idle
@@ -495,6 +499,81 @@ u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode)
                                   : (encoded_time - 5) * 20;
 }

+#ifdef CONFIG_PM_SLEEP
+static ssize_t cyapa_show_suspend_scanrate(struct device *dev,
+                                          struct device_attribute *attr,
+                                          char *buf)
+{
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+       u8 pwr_cmd = cyapa->suspend_power_mode;
+       u16 sleep_time;
+       int len;
+
+       if (pwr_cmd == PWR_MODE_BTN_ONLY)
+               len = scnprintf(buf, PAGE_SIZE, "%s\n", BTN_ONLY_MODE_NAME);
+       else if (pwr_cmd == PWR_MODE_OFF)
+               len = scnprintf(buf, PAGE_SIZE, "%s\n", OFF_MODE_NAME);
+       else {
+               if (cyapa->gen == CYAPA_GEN3)
+                       sleep_time = cyapa_pwr_cmd_to_sleep_time(pwr_cmd);
+               else
+                       sleep_time = cyapa->suspend_sleep_time;
+               len = scnprintf(buf, PAGE_SIZE, "%u\n", sleep_time);
+       }
+
+       return len;
+}
+
+static int cyapa_sleep_time_check(u16 sleep_time)
+{
+       if (sleep_time > 1000)
+               sleep_time = 1000;
+       return sleep_time;
+}
+
+static ssize_t cyapa_update_suspend_scanrate(struct device *dev,
+                                            struct device_attribute *attr,
+                                            const char *buf, size_t count)
+{
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+       u16 sleep_time;
+
+       if (buf == NULL || count == 0)
+               goto invalidparam;
+
+       if (sysfs_streq(buf, BTN_ONLY_MODE_NAME))
+               cyapa->suspend_power_mode = PWR_MODE_BTN_ONLY;
+       else if (sysfs_streq(buf, OFF_MODE_NAME))
+               cyapa->suspend_power_mode = PWR_MODE_OFF;
+       else if (!kstrtou16(buf, 10, &sleep_time)) {
+               cyapa->suspend_sleep_time = cyapa_sleep_time_check(sleep_time);
+               cyapa->suspend_power_mode =
+                       cyapa_sleep_time_to_pwr_cmd(cyapa->suspend_sleep_time);
+       } else
+               goto invalidparam;
+
+       return count;
+
+invalidparam:
+       dev_err(dev, "invalid suspend scanrate ms parameters\n");
+       return -EINVAL;
+}
+
+static DEVICE_ATTR(suspend_scanrate_ms, S_IRUGO|S_IWUSR,
+                  cyapa_show_suspend_scanrate,
+                  cyapa_update_suspend_scanrate);
+
+static struct attribute *cyapa_power_wakeup_entries[] = {
+       &dev_attr_suspend_scanrate_ms.attr,
+       NULL,
+};
+
+static const struct attribute_group cyapa_power_wakeup_group = {
+       .name = power_group_name,
+       .attrs = cyapa_power_wakeup_entries,
+};
+#endif /* CONFIG_PM_SLEEP */
+
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa = (struct cyapa *)data;
@@ -575,6 +654,12 @@ static int cyapa_probe(struct i2c_client *client,
        }
        cyapa_disable_irq(cyapa);

+#ifdef CONFIG_PM_SLEEP
+       if (device_can_wakeup(dev) &&
+           sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group))
+               dev_warn(dev, "error creating wakeup power entries.\n");
+#endif /* CONFIG_PM_SLEEP */
+
        async_schedule(cyapa_detect_and_start, cyapa);
        return 0;

@@ -590,6 +675,9 @@ static int cyapa_remove(struct i2c_client *client)
 {
        struct cyapa *cyapa = i2c_get_clientdata(client);

+#ifdef CONFIG_PM_SLEEP
+       sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
+#endif
        free_irq(cyapa->irq, cyapa);

        input_unregister_device(cyapa->input);
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
