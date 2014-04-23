Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbaDWOcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbaDWOcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:32:05 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: rmi: do not handle touchscreens through hid-rmi
Date: Wed, 23 Apr 2014 10:31:54 -0400
Message-Id: <1398263514-7281-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, hid-rmi drives every Synaptics product, but the touchscreens
on the Windows tablets should be handled through hid-multitouch.

Instead of providing a long list of PIDs, rely on the scan_report
capability to detect which should go to hid-multitouch, and which
should not go to hid-rmi.

We introduce a generic HID_GROUP_HAVE_SPECIAL_DRIVER which can be reused
amoung other drivers if they want to have a catch rule but still
have multitouch devices handled through hid-multitouch.

related bug:
https://bugzilla.kernel.org/show_bug.cgi?id=74241
https://bugzilla.redhat.com/show_bug.cgi?id=1089583

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

well, this is the patch we are going to carry in Fedora as we are already
carrying hid-rmi.
Still, I am not 100% happy with it, especially the HID_GROUP_HAVE_SPECIAL_DRIVER
thing.

I would also say we should re-think the way the scanning is called in
hid_add_device because I am starting using more and more the scanning capability
to decide if the device should be handled by generic, a special driver or simply
ignored.

Anyway, this could be decided later. If you prefer me to use a hid-rmi specific
group like HID_GROUP_RMI instead of HID_GROUP_HAVE_SPECIAL_DRIVER, I can also
update the patch.

Cheers,
Benjamin

 drivers/hid/hid-core.c | 10 ++++++++--
 drivers/hid/hid-rmi.c  |  6 ++++--
 include/linux/hid.h    | 13 +++++++++++++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f05255d..46b27f3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -776,6 +776,14 @@ static int hid_scan_report(struct hid_device *hid)
 	    (hid->group == HID_GROUP_MULTITOUCH))
 		hid->group = HID_GROUP_MULTITOUCH_WIN_8;
 
+	/*
+	* Vendor specific handlings
+	*/
+	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
+	    (hid->group == HID_GROUP_GENERIC))
+		/* hid-rmi should take care of them, not hid-generic */
+		hid->group = HID_GROUP_HAVE_SPECIAL_DRIVER;
+
 	vfree(parser);
 	return 0;
 }
@@ -1882,8 +1890,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_SRWS1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
-	{ HID_I2C_DEVICE(USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THINGM, USB_DEVICE_ID_BLINK1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 7da9509..3980955 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -861,8 +861,10 @@ static void rmi_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id rmi_id[] = {
-	{ HID_I2C_DEVICE(USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
+	{ HID_DEVICE(BUS_I2C, HID_GROUP_HAVE_SPECIAL_DRIVER,
+		USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_HAVE_SPECIAL_DRIVER,
+		USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, rmi_id);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 54f855b..888acfd 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -304,6 +304,19 @@ struct hid_item {
 #define HID_GROUP_MULTITOUCH			0x0002
 #define HID_GROUP_SENSOR_HUB			0x0003
 #define HID_GROUP_MULTITOUCH_WIN_8		0x0004
+#define HID_GROUP_HAVE_SPECIAL_DRIVER		0xffff
+/*
+ * HID_GROUP_HAVE_SPECIAL_DRIVER should be used when the device needs to be
+ * scanned in case it is handled by either hid-multitouch, hid-generic,
+ * hid-sensor-hub or any other generic hid driver.
+ *
+ * Devices declared in hid_have_special_driver[] in hid-core.c can use
+ * HID_GROUP_ANY instead because there will be not overlap between their
+ * specific driver and a generic one.
+ *
+ * Note: HID_GROUP_ANY is declared in linux/mod_devicetable.h
+ * and has a value of 0x0000
+ */
 
 /*
  * This is the global environment of the parser. This information is
-- 
1.9.0

