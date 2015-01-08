Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbbAHTh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:37:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbbAHTh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:37:27 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Peter Wu <peter@lekensteyn.nl>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] HID: logitech-hidpp: store the name of the device in struct hidpp
Date: Thu,  8 Jan 2015 14:37:12 -0500
Message-Id: <1420745832-7549-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a disconnect occurs while getting the actual name of the device
(which can take several HID transactions), the name of the device will
be the hid name, provided by the Unifying Receiver.
This means that in some cases, the user space will see a different
name that what it usually sees when there is no disconnect.

We should store the name of the device in the struct hidpp. That way,
if a disconnect occurs while we are accessing the name,
hidpp_connect_event() can fail, and the input node is not created.

The input node will be created only if we have a connection which
lasts long enough to retrieve all the requested information:
name, protocol, and specific configuration.

Reviewed-by: Peter Wu <peter@lekensteyn.nl>
Tested-by: Peter Wu <peter@lekensteyn.nl>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi,

sorry for the delay.
Peter, I amended the patch to add a comment in the declaration of .name.
If this is not what you had in mind (or if it is not sufficient), please tell
me. I still kept your tested and S-o-b lines, but feel free to retract yourself :)

Cheers,
Benjamin

 drivers/hid/hid-logitech-hidpp.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index c8af315..e77658c 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -89,6 +89,7 @@ struct hidpp_device {
 	struct hid_device *hid_dev;
 	struct mutex send_mutex;
 	void *send_receive_buf;
+	char *name;		/* will never be NULL and should not be freed */
 	wait_queue_head_t wait;
 	bool answer_available;
 	u8 protocol_major;
@@ -1087,6 +1088,7 @@ static void hidpp_input_close(struct input_dev *dev)
 static struct input_dev *hidpp_allocate_input(struct hid_device *hdev)
 {
 	struct input_dev *input_dev = devm_input_allocate_device(&hdev->dev);
+	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
 
 	if (!input_dev)
 		return NULL;
@@ -1095,7 +1097,7 @@ static struct input_dev *hidpp_allocate_input(struct hid_device *hdev)
 	input_dev->open = hidpp_input_open;
 	input_dev->close = hidpp_input_close;
 
-	input_dev->name = hdev->name;
+	input_dev->name = hidpp->name;
 	input_dev->phys = hdev->phys;
 	input_dev->uniq = hdev->uniq;
 	input_dev->id.bustype = hdev->bus;
@@ -1137,22 +1139,28 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
 	hid_info(hdev, "HID++ %u.%u device connected.\n",
 		 hidpp->protocol_major, hidpp->protocol_minor);
 
+	if (!hidpp->name || hidpp->name == hdev->name) {
+		name = hidpp_get_device_name(hidpp);
+		if (!name) {
+			hid_err(hdev,
+				"unable to retrieve the name of the device");
+			return;
+		}
+
+		devm_name = devm_kasprintf(&hdev->dev, GFP_KERNEL, "%s", name);
+		kfree(name);
+		if (!devm_name)
+			return;
+
+		hidpp->name = devm_name;
+	}
+
 	input = hidpp_allocate_input(hdev);
 	if (!input) {
 		hid_err(hdev, "cannot allocate new input device: %d\n", ret);
 		return;
 	}
 
-	name = hidpp_get_device_name(hidpp);
-	if (!name) {
-		hid_err(hdev, "unable to retrieve the name of the device");
-	} else {
-		devm_name = devm_kasprintf(&hdev->dev, GFP_KERNEL, "%s", name);
-		if (devm_name)
-			input->name = devm_name;
-		kfree(name);
-	}
-
 	hidpp_populate_input(hidpp, input, false);
 
 	ret = input_register_device(input);
@@ -1175,6 +1183,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return -ENOMEM;
 
 	hidpp->hid_dev = hdev;
+	hidpp->name = hdev->name;
 	hid_set_drvdata(hdev, hidpp);
 
 	hidpp->quirks = id->driver_data;
-- 
2.1.0

