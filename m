Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaI3RUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:20:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbaI3RSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:51 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 10/13] HID: logitech-hidpp: late bind the input device on wireless connection
Date: Tue, 30 Sep 2014 13:18:32 -0400
Message-Id: <1412097515-17241-11-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the receiver forwards the connect/disconnect events, we can
know when the device is available to communicate with us.

When it is ready, we can for instance retrieve its full name, which
guarantee that we always have the same name for the DJ device (the DJ
name is somewhat shorter than the HID++ name).

This mechanism is mandatory for the touchpads line, which has the
min/max information stored in the device. This information can only
be retrieved when the device is connected. So we can not populate
the input device until we are sure that the device is connected.

This patch creates a new input device for such devices. However,
this input is not bound to hid directly, so the various drivers
which wants to use it are required to process completely the
incoming reports in .raw_event().

Note that the patch in itself just adds the bits for the next
ones, and this feature is disabled by default.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-hidpp.c | 155 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 147 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index e748e45..9561a1f 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -36,6 +36,9 @@ MODULE_AUTHOR("Nestor Lopez Casado <nlopezcasad@logitech.com>");
 
 #define HIDPP_QUIRK_CLASS_WTP			BIT(0)
 
+/* bits 1..20 are reserved for classes */
+#define HIDPP_QUIRK_DELAYED_INIT		BIT(21)
+
 /*
  * There are two hidpp protocols in use, the first version hidpp10 is known
  * as register access protocol or RAP, the second version hidpp20 is known as
@@ -91,6 +94,11 @@ struct hidpp_device {
 
 	void *private_data;
 
+	struct work_struct work;
+	struct kfifo delayed_work_fifo;
+	atomic_t connected;
+	struct input_dev *delayed_input;
+
 	unsigned long quirks;
 };
 
@@ -110,6 +118,8 @@ struct hidpp_device {
 #define HIDPP_ERROR_INVALID_PARAM_VALUE		0x0b
 #define HIDPP_ERROR_WRONG_PIN_CODE		0x0c
 
+static void hidpp_connect_event(struct hidpp_device *hidpp_dev);
+
 static int __hidpp_send_report(struct hid_device *hdev,
 				struct hidpp_report *hidpp_report)
 {
@@ -230,6 +240,13 @@ static int hidpp_send_rap_command_sync(struct hidpp_device *hidpp_dev,
 	return ret;
 }
 
+static void delayed_work_cb(struct work_struct *work)
+{
+	struct hidpp_device *hidpp = container_of(work, struct hidpp_device,
+							work);
+	hidpp_connect_event(hidpp);
+}
+
 static inline bool hidpp_match_answer(struct hidpp_report *question,
 		struct hidpp_report *answer)
 {
@@ -245,6 +262,12 @@ static inline bool hidpp_match_error(struct hidpp_report *question,
 	    (answer->fap.params[0] == question->fap.funcindex_clientid);
 }
 
+static inline bool hidpp_report_is_connect_event(struct hidpp_report *report)
+{
+	return (report->report_id == REPORT_ID_HIDPP_SHORT) &&
+		(report->rap.sub_id == 0x41);
+}
+
 /* -------------------------------------------------------------------------- */
 /* HIDP++ 1.0 commands                                                        */
 /* -------------------------------------------------------------------------- */
@@ -535,12 +558,10 @@ static int wtp_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	return -1;
 }
 
-static void wtp_input_configured(struct hid_device *hdev,
-				struct hid_input *hidinput)
+static void wtp_populate_input(struct hidpp_device *hidpp,
+		struct input_dev *input_dev, bool origin_is_hid_core)
 {
-	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
 	struct wtp_data *wd = hidpp->private_data;
-	struct input_dev *input_dev = hidinput->input;
 
 	__set_bit(EV_ABS, input_dev->evbit);
 	__set_bit(EV_KEY, input_dev->evbit);
@@ -716,13 +737,20 @@ static int hidpp_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	return 0;
 }
 
+static void hidpp_populate_input(struct hidpp_device *hidpp,
+		struct input_dev *input, bool origin_is_hid_core)
+{
+	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
+		wtp_populate_input(hidpp, input, origin_is_hid_core);
+}
+
 static void hidpp_input_configured(struct hid_device *hdev,
 				struct hid_input *hidinput)
 {
 	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
+	struct input_dev *input = hidinput->input;
 
-	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
-		wtp_input_configured(hdev, hidinput);
+	hidpp_populate_input(hidpp, input, true);
 }
 
 static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
@@ -756,6 +784,15 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 		}
 	}
 
+	if (unlikely(hidpp_report_is_connect_event(report))) {
+		atomic_set(&hidpp->connected,
+				!(report->rap.params[0] & (1 << 6)));
+		if ((hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT) &&
+		    (schedule_work(&hidpp->work) == 0))
+			dbg_hid("%s: connect event already queued\n", __func__);
+		return 1;
+	}
+
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
 		return wtp_raw_event(hidpp->hid_dev, data, size);
 
@@ -814,11 +851,99 @@ static void hidpp_overwrite_name(struct hid_device *hdev, bool use_unifying)
 	kfree(name);
 }
 
+static int hidpp_input_open(struct input_dev *dev)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+
+	return hid_hw_open(hid);
+}
+
+static void hidpp_input_close(struct input_dev *dev)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+
+	hid_hw_close(hid);
+}
+
+static struct input_dev *hidpp_allocate_input(struct hid_device *hdev)
+{
+	struct input_dev *input_dev = devm_input_allocate_device(&hdev->dev);
+
+	if (!input_dev)
+		return NULL;
+
+	input_set_drvdata(input_dev, hdev);
+	input_dev->open = hidpp_input_open;
+	input_dev->close = hidpp_input_close;
+
+	input_dev->name = hdev->name;
+	input_dev->phys = hdev->phys;
+	input_dev->uniq = hdev->uniq;
+	input_dev->id.bustype = hdev->bus;
+	input_dev->id.vendor  = hdev->vendor;
+	input_dev->id.product = hdev->product;
+	input_dev->id.version = hdev->version;
+	input_dev->dev.parent = &hdev->dev;
+
+	return input_dev;
+}
+
+static void hidpp_connect_event(struct hidpp_device *hidpp)
+{
+	struct hid_device *hdev = hidpp->hid_dev;
+	int ret = 0;
+	bool connected = atomic_read(&hidpp->connected);
+	struct input_dev *input;
+	char *name, *devm_name;
+	u8 name_length;
+
+	if (!connected || hidpp->delayed_input)
+		return;
+
+	if (!hidpp->protocol_major) {
+		ret = !hidpp_is_connected(hidpp);
+		if (ret) {
+			hid_err(hdev, "Can not get the protocol version.\n");
+			return;
+		}
+	}
+
+	/* the device is already connected, we can ask for its name and
+	 * protocol */
+	hid_info(hdev, "HID++ %u.%u device connected.\n",
+		 hidpp->protocol_major, hidpp->protocol_minor);
+
+	input = hidpp_allocate_input(hdev);
+	if (!input) {
+		hid_err(hdev, "cannot allocate new input device: %d\n", ret);
+		return;
+	}
+
+	name = hidpp_get_device_name(hidpp, &name_length);
+	if (!name) {
+		hid_err(hdev, "unable to retrieve the name of the device");
+	} else {
+		devm_name = devm_kasprintf(&hdev->dev, GFP_KERNEL, "%s", name);
+		if (devm_name)
+			input->name = devm_name;
+		kfree(name);
+	}
+
+	hidpp_populate_input(hidpp, input, false);
+
+	ret = input_register_device(input);
+	if (ret)
+		input_free_device(input);
+
+	hidpp->delayed_input = input;
+}
+
 static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	struct hidpp_device *hidpp;
 	int ret;
 	bool connected;
+	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 
 	hidpp = devm_kzalloc(&hdev->dev, sizeof(struct hidpp_device),
 			GFP_KERNEL);
@@ -836,6 +961,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			return ret;
 	}
 
+	INIT_WORK(&hidpp->work, delayed_work_cb);
 	mutex_init(&hidpp->send_mutex);
 	init_waitqueue_head(&hidpp->wait);
 
@@ -860,8 +986,9 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	hidpp_overwrite_name(hdev, id->group == HID_GROUP_LOGITECH_DJ_DEVICE);
+	atomic_set(&hidpp->connected, connected);
 
-	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
+	if (connected && (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)) {
 		ret = wtp_get_config(hidpp);
 		if (ret)
 			goto hid_parse_fail;
@@ -870,16 +997,27 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	/* Block incoming packets */
 	hid_device_io_stop(hdev);
 
-	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT)
+		connect_mask &= ~HID_CONNECT_HIDINPUT;
+
+	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
 		hid_err(hdev, "%s:hid_hw_start returned error\n", __func__);
 		goto hid_hw_start_fail;
 	}
 
+	if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT) {
+		/* Allow incoming packets */
+		hid_device_io_start(hdev);
+
+		hidpp_connect_event(hidpp);
+	}
+
 	return ret;
 
 hid_hw_start_fail:
 hid_parse_fail:
+	cancel_work_sync(&hidpp->work);
 	mutex_destroy(&hidpp->send_mutex);
 	hid_set_drvdata(hdev, NULL);
 	return ret;
@@ -889,6 +1027,7 @@ static void hidpp_remove(struct hid_device *hdev)
 {
 	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
 
+	cancel_work_sync(&hidpp->work);
 	mutex_destroy(&hidpp->send_mutex);
 	hid_hw_stop(hdev);
 }
-- 
2.1.0

