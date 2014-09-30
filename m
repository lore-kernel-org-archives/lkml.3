Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaI3RSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:18:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbaI3RSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:46 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 01/13] HID: fix merge from wacom into the HID tree
Date: Tue, 30 Sep 2014 13:18:23 -0400
Message-Id: <1412097515-17241-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While merging wacom from the input to the hid tree, some
comments have been duplicated. We can also integrate the
test for Synaptics devices in the switch case below, so
it is clear that there will be only one place for such
quirks.

No functional changes are expected in this commit.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c | 17 +++++++----------
 include/linux/hid.h    |  4 ----
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eb50818..6cfecb8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -780,22 +780,19 @@ static int hid_scan_report(struct hid_device *hid)
 		hid->group = HID_GROUP_MULTITOUCH_WIN_8;
 
 	/*
-	* Vendor specific handlings
-	*/
-	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
-	    (hid->group == HID_GROUP_GENERIC) &&
-	    /* only bind to the mouse interface of composite USB devices */
-	    (hid->bus != BUS_USB || hid->type == HID_TYPE_USBMOUSE))
-		/* hid-rmi should take care of them, not hid-generic */
-		hid->group = HID_GROUP_RMI;
-
-	/*
 	 * Vendor specific handlings
 	 */
 	switch (hid->vendor) {
 	case USB_VENDOR_ID_WACOM:
 		hid->group = HID_GROUP_WACOM;
 		break;
+	case USB_VENDOR_ID_SYNAPTICS:
+		if ((hid->group == HID_GROUP_GENERIC) &&
+		    (hid->bus != BUS_USB || hid->type == HID_TYPE_USBMOUSE))
+			/* hid-rmi should only bind to the mouse interface of
+			 * composite USB devices */
+			hid->group = HID_GROUP_RMI;
+		break;
 	}
 
 	vfree(parser);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 26ee25f..0da2711 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -311,10 +311,6 @@ struct hid_item {
  * Vendor specific HID device groups
  */
 #define HID_GROUP_RMI				0x0100
-
-/*
- * Vendor specific HID device groups
- */
 #define HID_GROUP_WACOM				0x0101
 
 /*
-- 
2.1.0

