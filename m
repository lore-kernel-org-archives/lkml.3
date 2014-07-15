Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaGOStT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:49:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbaGOSqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:46:03 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 15/23] Input - wacom: register the input devices on top of the HID one
Date: Tue, 15 Jul 2014 14:45:38 -0400
Message-Id: <1405449946-11515-16-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matches the current behavior of the HID subsystem and removes one more
dependency over USB.

The current user space clients which relies on this to fetch the
LEDs path need an update. However, we already break them in the
kernel v3.11 for the Bluetooth Wacom devices. They are going to be fixed
soon.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Jason Gerecke <killertofu@gmail.com>
Tested-by: Jason Gerecke <killertofu@gmail.com>
---

no changes in v2

 drivers/input/tablet/wacom.h     |  1 -
 drivers/input/tablet/wacom_sys.c | 15 ++++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index b921239..dd67b7d 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -112,7 +112,6 @@ struct wacom {
 	struct hid_device *hdev;
 	struct mutex lock;
 	struct work_struct work;
-	char phys[32];
 	struct wacom_led {
 		u8 select[2]; /* status led selector (0..3) */
 		u8 llv;       /* status led brightness no button (1..127) */
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 6e21064..2650443 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -986,8 +986,7 @@ static void wacom_destroy_battery(struct wacom *wacom)
 static struct input_dev *wacom_allocate_input(struct wacom *wacom)
 {
 	struct input_dev *input_dev;
-	struct usb_interface *intf = wacom->intf;
-	struct usb_device *dev = interface_to_usbdev(intf);
+	struct hid_device *hdev = wacom->hdev;
 	struct wacom_wac *wacom_wac = &(wacom->wacom_wac);
 
 	input_dev = input_allocate_device();
@@ -995,11 +994,15 @@ static struct input_dev *wacom_allocate_input(struct wacom *wacom)
 		return NULL;
 
 	input_dev->name = wacom_wac->name;
-	input_dev->phys = wacom->phys;
-	input_dev->dev.parent = &intf->dev;
+	input_dev->phys = hdev->phys;
+	input_dev->dev.parent = &hdev->dev;
 	input_dev->open = wacom_open;
 	input_dev->close = wacom_close;
-	usb_to_input_id(dev, &input_dev->id);
+	input_dev->uniq = hdev->uniq;
+	input_dev->id.bustype = hdev->bus;
+	input_dev->id.vendor  = hdev->vendor;
+	input_dev->id.product = hdev->product;
+	input_dev->id.version = hdev->version;
 	input_set_drvdata(input_dev, wacom);
 
 	return input_dev;
@@ -1266,8 +1269,6 @@ static int wacom_probe(struct hid_device *hdev,
 	wacom->intf = intf;
 	mutex_init(&wacom->lock);
 	INIT_WORK(&wacom->work, wacom_wireless_work);
-	usb_make_path(dev, wacom->phys, sizeof(wacom->phys));
-	strlcat(wacom->phys, "/input0", sizeof(wacom->phys));
 
 	/* set the default size in case we do not get them from hid */
 	wacom_set_default_phy(features);
-- 
2.0.0

