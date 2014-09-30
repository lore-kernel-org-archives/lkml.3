Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaI3RV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbaI3RSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:48 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 06/13] HID: logitech: move dj devices to the HID++ module
Date: Tue, 30 Sep 2014 13:18:28 -0400
Message-Id: <1412097515-17241-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices connected through the Logitech Wireless Receiver are HID++ devices.
We can handle them here to benefit from this new module and activate
enhaced support of the various wireless touchpad or mice with touch
sensors on them.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/Kconfig              |  1 +
 drivers/hid/hid-logitech-dj.c    | 42 +---------------------------------------
 drivers/hid/hid-logitech-hidpp.c | 21 ++++++++++++--------
 3 files changed, 15 insertions(+), 49 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 6f299cd..dd49a9b 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -371,6 +371,7 @@ config HID_LOGITECH_DJ
 	tristate "Logitech Unifying receivers full support"
 	depends on HIDRAW
 	depends on HID_LOGITECH
+	select HID_LOGITECH_HIDPP
 	---help---
 	Say Y if you want support for Logitech Unifying receivers and devices.
 	Unifying receivers are capable of pairing up to 6 Logitech compliant
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 6aea16d..45a7eac 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -977,48 +977,8 @@ static struct hid_driver logi_djreceiver_driver = {
 #endif
 };
 
+module_hid_driver(logi_djreceiver_driver);
 
-static const struct hid_device_id logi_dj_devices[] = {
-	{ HID_DEVICE(BUS_USB, HID_GROUP_LOGITECH_DJ_DEVICE,
-		USB_VENDOR_ID_LOGITECH, HID_ANY_ID)},
-	{}
-};
-
-static struct hid_driver logi_djdevice_driver = {
-	.name = "logitech-djdevice",
-	.id_table = logi_dj_devices,
-};
-
-
-static int __init logi_dj_init(void)
-{
-	int retval;
-
-	dbg_hid("Logitech-DJ:%s\n", __func__);
-
-	retval = hid_register_driver(&logi_djreceiver_driver);
-	if (retval)
-		return retval;
-
-	retval = hid_register_driver(&logi_djdevice_driver);
-	if (retval)
-		hid_unregister_driver(&logi_djreceiver_driver);
-
-	return retval;
-
-}
-
-static void __exit logi_dj_exit(void)
-{
-	dbg_hid("Logitech-DJ:%s\n", __func__);
-
-	hid_unregister_driver(&logi_djdevice_driver);
-	hid_unregister_driver(&logi_djreceiver_driver);
-
-}
-
-module_init(logi_dj_init);
-module_exit(logi_dj_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Logitech");
 MODULE_AUTHOR("Nestor Lopez Casado");
diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 7dd9163..48dec39 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -777,15 +777,17 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	hid_device_io_start(hdev);
 
 	connected = hidpp_is_connected(hidpp);
-	if (!connected) {
-		hid_err(hdev, "Device not connected");
-		goto hid_parse_fail;
-	}
+	if (id->group != HID_GROUP_LOGITECH_DJ_DEVICE) {
+		if (!connected) {
+			hid_err(hdev, "Device not connected");
+			goto hid_parse_fail;
+		}
 
-	/* the device is connected, we can ask for its name */
-	hid_info(hdev, "HID++ %u.%u device connected.\n",
-		 hidpp->protocol_major, hidpp->protocol_minor);
-	hidpp_overwrite_name(hdev);
+		/* the device is connected, we can ask for its name */
+		hid_info(hdev, "HID++ %u.%u device connected.\n",
+			 hidpp->protocol_major, hidpp->protocol_minor);
+		hidpp_overwrite_name(hdev);
+	}
 
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
 		ret = wtp_get_config(hidpp);
@@ -824,6 +826,9 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_T651),
 	  .driver_data = HIDPP_QUIRK_CLASS_WTP },
+
+	{ HID_DEVICE(BUS_USB, HID_GROUP_LOGITECH_DJ_DEVICE,
+		USB_VENDOR_ID_LOGITECH, HID_ANY_ID)},
 	{}
 };
 
-- 
2.1.0

