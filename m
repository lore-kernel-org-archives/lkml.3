Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaF3GqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:46:19 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:23859
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398AbaF3GpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:45:04 -0400
From: Dudley Du <dudl@cypress.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "patrikf@google.com" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 14/14] input: cyapa: add function to monitor LID close
 event to off trackpad device
Thread-Topic: [PATCH v2 14/14] input: cyapa: add function to monitor LID
 close event to off trackpad device
Thread-Index: Ac+ULtAuSHFK/6WKTq6U5R51JSrGqA==
Date: Mon, 30 Jun 2014 06:45:02 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902CE3@S04-MBX01-01.s04.local>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5U6kOg8009626

Add the function to monitor lid close event to suspend and resume
trackpad device.
Because system suspend takes some time to trigger from user space,
and in that time, the lid panel of the laptop may couple with the
active trackpad. This may generate stray input events, which may
in turn cancel the suspend if the drivers use pm_wakup_event(), and
those input events may trigger something unwanted in the UI.
So this patch adds the function to do off the trackpad device quickly.
When the lid is closed, as soon as possible, the trakcpad device must
be off. And furthermore, the policy on lid close is not always to
enter suspend (lid closed with external display), and at this time,
the trackpad device must be disabled as well as again to avoid the
risk of generating stray events.
TEST=test on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 8d37032..760a43b 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -1166,6 +1166,140 @@ static const struct attribute_group cyapa_sysfs_group = {
        .attrs = cyapa_sysfs_entries,
 };

+
+/*
+ * We rely on EV_SW and SW_LID bits to identify a LID device, and hook
+ * up our filter to listen for SW_LID events to enable/disable touchpad when
+ * LID is open/closed.
+ */
+static const struct input_device_id lid_device_ids[] = {
+       {
+               .flags = INPUT_DEVICE_ID_MATCH_EVBIT |
+                        INPUT_DEVICE_ID_MATCH_SWBIT,
+               .evbit = { BIT_MASK(EV_SW) },
+               .swbit = { BIT_MASK(SW_LID) },
+       },
+       { },
+};
+
+static int lid_device_connect(struct input_handler *handler,
+                             struct input_dev *dev,
+                             const struct input_device_id *id)
+{
+       struct input_handle *lid_handle;
+       int error;
+
+       pr_info("cyapa: LID device: '%s' connected\n", dev->name);
+       lid_handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+       if (!lid_handle)
+               return -ENOMEM;
+
+       lid_handle->dev = dev;
+       lid_handle->handler = handler;
+       lid_handle->name = "lid_event_handler";
+       lid_handle->private = handler->private;
+
+       error = input_register_handle(lid_handle);
+       if (error) {
+               pr_err("Failed to register lid_event_handler, error %d\n",
+                      error);
+               goto err_free;
+       }
+
+       error = input_open_device(lid_handle);
+       if (error) {
+               pr_err("Failed to open input device, error %d\n", error);
+               goto err_unregister;
+       }
+
+       return 0;
+err_unregister:
+       input_unregister_handle(lid_handle);
+err_free:
+       kfree(lid_handle);
+       return error;
+}
+
+static void lid_device_disconnect(struct input_handle *handle)
+{
+       input_close_device(handle);
+       input_unregister_handle(handle);
+       kfree(handle);
+}
+
+static bool lid_event_filter(struct input_handle *handle,
+                            unsigned int type, unsigned int code, int value)
+{
+       struct cyapa *cyapa = handle->private;
+       struct device *dev = &cyapa->client->dev;
+
+       if (type == EV_SW && code == SW_LID) {
+               pr_info("cyapa %s: %s touch device\n",
+                       dev_name(&cyapa->client->dev),
+                       (value ? "disable" : "enable"));
+               if (cyapa->suspended) {
+                       /*
+                        * If the lid event filter is called while suspended,
+                        * there is no guarantee that the underlying i2cs are
+                        * resumed at this point, so it is not safe to issue
+                        * the command to change power modes.
+                        * Instead, rely on cyapa_resume to set us back to
+                        * PWR_MODE_FULL_ACTIVE.
+                        */
+                       pr_info("cyapa %s: skipping lid pm change in suspend\n",
+                               dev_name(&cyapa->client->dev));
+                       return false;
+               }
+               if (value == 0) {
+                       if (cyapa->ops->cyapa_set_power_mode)
+                               cyapa->ops->cyapa_set_power_mode(cyapa,
+                                               PWR_MODE_FULL_ACTIVE, 0);
+                       pm_runtime_set_active(dev);
+                       pm_runtime_enable(dev);
+               } else {
+                       pm_runtime_disable(dev);
+                       if (cyapa->ops->cyapa_set_power_mode)
+                               cyapa->ops->cyapa_set_power_mode(cyapa,
+                                               PWR_MODE_OFF, 0);
+               }
+       }
+
+       return false;
+}
+
+static void lid_event_register_handler(struct cyapa *cyapa)
+{
+       int error;
+       struct input_handler *lid_handler = &cyapa->lid_handler;
+
+       if (cyapa->lid_handler_registered) {
+               pr_err("lid handler is registered already\n");
+               return;
+       }
+
+       lid_handler->filter     = lid_event_filter;
+       lid_handler->connect    = lid_device_connect;
+       lid_handler->disconnect = lid_device_disconnect;
+       lid_handler->name       = "cyapa_lid_event_handler";
+       lid_handler->id_table   = lid_device_ids;
+       lid_handler->private    = cyapa;
+
+       error = input_register_handler(lid_handler);
+       if (error) {
+               pr_err("Failed to register lid handler(%d)\n", error);
+               return;
+       }
+       cyapa->lid_handler_registered = true;
+}
+
+static void lid_event_unregister_handler(struct cyapa *cyapa)
+{
+       if (cyapa->lid_handler_registered) {
+               input_unregister_handler(&cyapa->lid_handler);
+               cyapa->lid_handler_registered = false;
+       }
+}
+
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa = (struct cyapa *)data;
@@ -1186,6 +1320,7 @@ static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
        cyapa_detect_async(data, cookie);

        cyapa_start_runtime(cyapa);
+       lid_event_register_handler(cyapa);
 }

 static int cyapa_probe(struct i2c_client *client,
@@ -1324,6 +1459,7 @@ static int cyapa_remove(struct i2c_client *client)
        mutex_destroy(&cyapa->debugfs_mutex);

        input_unregister_device(cyapa->input);
+       lid_event_unregister_handler(cyapa);
        if (cyapa->ops->cyapa_set_power_mode)
                cyapa->ops->cyapa_set_power_mode(cyapa, PWR_MODE_OFF, 0);
        i2c_set_clientdata(client, NULL);
@@ -1340,6 +1476,7 @@ static int cyapa_suspend(struct device *dev)
        struct cyapa *cyapa = dev_get_drvdata(dev);

        cyapa_disable_irq(cyapa);
+       cyapa->suspended = true;

        /*
         * Set trackpad device to idle mode if wakeup is allowed,
@@ -1382,6 +1519,7 @@ static int cyapa_resume(struct device *dev)
        pm_runtime_disable(dev);
        pm_runtime_set_active(dev);
        pm_runtime_enable(dev);
+       cyapa->suspended = false;
        return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 7f8c3d4..616db23 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -219,6 +219,7 @@ struct cyapa {
        u8 runtime_suspend_power_mode;
        u16 runtime_suspend_sleep_time;
 #endif /* CONFIG_PM_RUNTIME */
+       bool suspended;

        /* read from query data region. */
        char product_id[16];
@@ -259,6 +260,9 @@ struct cyapa {
        size_t tp_raw_data_size;

        const struct cyapa_dev_ops *ops;
+
+       bool lid_handler_registered;
+       struct input_handler lid_handler;
 };


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
