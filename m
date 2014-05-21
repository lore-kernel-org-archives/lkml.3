Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaEUPQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:16:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaEUPQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:16:07 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Andrew Duggan <aduggan@synaptics.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] HID: rmi: do not handle touchscreens through hid-rmi
Date: Wed, 21 May 2014 11:15:56 -0400
Message-Id: <1400685356-6126-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, hid-rmi drives every Synaptics product, but the touchscreens
on the Windows tablets should be handled through hid-multitouch.

Instead of providing a long list of PIDs, rely on the scan_report
capability to detect which should go to hid-multitouch, and which
should not go to hid-rmi.

related bug:
https://bugzilla.kernel.org/show_bug.cgi?id=74241
https://bugzilla.redhat.com/show_bug.cgi?id=1089583

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Changes in v2:
- use HID_GROUP_RMI instead of HID_GROUP_HAVE_SPECIAL_DRIVER
- match all the HID devices with the proper group in hid-rmi instead of only the
  Synaptics ones (we already spoted one Razer laptop with this touchpad which has
  a different VID/PID)

 drivers/hid/hid-core.c | 10 ++++++++--
 drivers/hid/hid-rmi.c  |  3 +--
 include/linux/hid.h    |  8 ++++++++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5b74dab..bb43525 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -779,6 +779,14 @@ static int hid_scan_report(struct hid_device *hid)
 	    (hid->group == HID_GROUP_MULTITOUCH))
 		hid->group = HID_GROUP_MULTITOUCH_WIN_8;
 
+	/*
+	* Vendor specific handlings
+	*/
+	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
+	    (hid->group == HID_GROUP_GENERIC))
+		/* hid-rmi should take care of them, not hid-generic */
+		hid->group = HID_GROUP_RMI;
+
 	vfree(parser);
 	return 0;
 }
@@ -1888,8 +1896,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_SRWS1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
-	{ HID_I2C_DEVICE(USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THINGM, USB_DEVICE_ID_BLINK1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index c529b03..2451c7e 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -894,8 +894,7 @@ static void rmi_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id rmi_id[] = {
-	{ HID_I2C_DEVICE(USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, HID_ANY_ID) },
+	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_RMI, HID_ANY_ID, HID_ANY_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, rmi_id);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 54f855b..8ce9ff4 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -299,6 +299,9 @@ struct hid_item {
 
 /*
  * HID device groups
+ *
+ * Note: HID_GROUP_ANY is declared in linux/mod_devicetable.h
+ * and has a value of 0x0000
  */
 #define HID_GROUP_GENERIC			0x0001
 #define HID_GROUP_MULTITOUCH			0x0002
@@ -306,6 +309,11 @@ struct hid_item {
 #define HID_GROUP_MULTITOUCH_WIN_8		0x0004
 
 /*
+ * Vendor specific HID device groups
+ */
+#define HID_GROUP_RMI				0x0100
+
+/*
  * This is the global environment of the parser. This information is
  * persistent for main-items. The global environment can be saved and
  * restored with PUSH/POP statements.
-- 
1.9.0

