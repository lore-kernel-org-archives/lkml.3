Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaH2Ifo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:35:44 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59956 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaH2Ifk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:35:40 -0400
Message-ID: <54003b5a.ac26460a.73fc.ffffe939@mx.google.com>
X-Google-Original-Message-ID: <000001cfc364$34f374b0$9eda5e10$@dulixin@gmail.com>
From: "Dudley Du" <dudley.dulixin@gmail.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
Cc: <bleung@google.com>, <patrik@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V5 14/14] input: cyapa: add function to monitor LID close event to off trackpad device
Date: Fri, 29 Aug 2014 16:35:27 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/DWK+pW9Q185MNSeyEGSdDVv9r0w==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cyrpess.com>
---
 drivers/input/mouse/cyapa.c | 136 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cyapa.h |   3 +
 2 files changed, 139 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 385523d..f980888 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -1082,6 +1082,140 @@ static const struct attribute_group cyapa_sysfs_group = {
 	.attrs = cyapa_sysfs_entries,
 };
 
+
+/*
+ * We rely on EV_SW and SW_LID bits to identify a LID device, and hook
+ * up our filter to listen for SW_LID events to enable/disable touchpad when
+ * LID is open/closed.
+ */
+static const struct input_device_id lid_device_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
+			 INPUT_DEVICE_ID_MATCH_SWBIT,
+		.evbit = { BIT_MASK(EV_SW) },
+		.swbit = { BIT_MASK(SW_LID) },
+	},
+	{ },
+};
+
+static int lid_device_connect(struct input_handler *handler,
+			      struct input_dev *dev,
+			      const struct input_device_id *id)
+{
+	struct input_handle *lid_handle;
+	int error;
+
+	pr_info("cyapa: LID device: '%s' connected\n", dev->name);
+	lid_handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+	if (!lid_handle)
+		return -ENOMEM;
+
+	lid_handle->dev = dev;
+	lid_handle->handler = handler;
+	lid_handle->name = "lid_event_handler";
+	lid_handle->private = handler->private;
+
+	error = input_register_handle(lid_handle);
+	if (error) {
+		pr_err("Failed to register lid_event_handler, error %d\n",
+		       error);
+		goto err_free;
+	}
+
+	error = input_open_device(lid_handle);
+	if (error) {
+		pr_err("Failed to open input device, error %d\n", error);
+		goto err_unregister;
+	}
+
+	return 0;
+err_unregister:
+	input_unregister_handle(lid_handle);
+err_free:
+	kfree(lid_handle);
+	return error;
+}
+
+static void lid_device_disconnect(struct input_handle *handle)
+{
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(handle);
+}
+
+static bool lid_event_filter(struct input_handle *handle,
+			     unsigned int type, unsigned int code, int value)
+{
+	struct cyapa *cyapa = handle->private;
+	struct device *dev = &cyapa->client->dev;
+
+	if (type == EV_SW && code == SW_LID) {
+		pr_info("cyapa %s: %s touch device\n",
+			dev_name(&cyapa->client->dev),
+			(value ? "disable" : "enable"));
+		if (cyapa->suspended) {
+			/*
+			 * If the lid event filter is called while suspended,
+			 * there is no guarantee that the underlying i2cs are
+			 * resumed at this point, so it is not safe to issue
+			 * the command to change power modes.
+			 * Instead, rely on cyapa_resume to set us back to
+			 * PWR_MODE_FULL_ACTIVE.
+			 */
+			pr_info("cyapa %s: skipping lid pm change in suspend\n",
+				dev_name(&cyapa->client->dev));
+			return false;
+		}
+		if (value == 0) {
+			if (cyapa->ops->set_power_mode)
+				cyapa->ops->set_power_mode(cyapa,
+						PWR_MODE_FULL_ACTIVE, 0);
+			pm_runtime_set_active(dev);
+			pm_runtime_enable(dev);
+		} else {
+			pm_runtime_disable(dev);
+			if (cyapa->ops->set_power_mode)
+				cyapa->ops->set_power_mode(cyapa,
+						PWR_MODE_OFF, 0);
+		}
+	}
+
+	return false;
+}
+
+static void lid_event_register_handler(struct cyapa *cyapa)
+{
+	int error;
+	struct input_handler *lid_handler = &cyapa->lid_handler;
+
+	if (cyapa->lid_handler_registered) {
+		pr_err("lid handler is registered already\n");
+		return;
+	}
+
+	lid_handler->filter	= lid_event_filter;
+	lid_handler->connect	= lid_device_connect;
+	lid_handler->disconnect	= lid_device_disconnect;
+	lid_handler->name	= "cyapa_lid_event_handler";
+	lid_handler->id_table	= lid_device_ids;
+	lid_handler->private	= cyapa;
+
+	error = input_register_handler(lid_handler);
+	if (error) {
+		pr_err("Failed to register lid handler(%d)\n", error);
+		return;
+	}
+	cyapa->lid_handler_registered = true;
+}
+
+static void lid_event_unregister_handler(struct cyapa *cyapa)
+{
+	if (cyapa->lid_handler_registered) {
+		input_unregister_handler(&cyapa->lid_handler);
+		cyapa->lid_handler_registered = false;
+	}
+}
+
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
 	struct cyapa *cyapa = (struct cyapa *)data;
@@ -1105,6 +1239,7 @@ static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
 	cyapa_detect_async(data, cookie);
 
 	cyapa_start_runtime(cyapa);
+	lid_event_register_handler(cyapa);
 }
 
 static int cyapa_tp_modules_init(struct cyapa *cyapa)
@@ -1252,6 +1387,7 @@ static int cyapa_remove(struct i2c_client *client)
 	cyapa->tp_raw_data_size = 0;
 
 	input_unregister_device(cyapa->input);
+	lid_event_unregister_handler(cyapa);
 	if (cyapa->ops->set_power_mode)
 		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
 	cyapa_tp_modules_uninit(cyapa);
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 36e87c3..c5ee300 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -272,6 +272,9 @@ struct cyapa {
 	size_t tp_raw_data_size;
 
 	const struct cyapa_dev_ops *ops;
+
+	bool lid_handler_registered;
+	struct input_handler lid_handler;
 };
 
 
-- 
1.9.1


