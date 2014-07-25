Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaGYFNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 01:13:31 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49601 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGYFNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 01:13:30 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-input@vger.kernel.org, jkosina@suse.cz,
        srinivas.pandruvada@linux.intel.com, linux-kernel@vger.kernel.org
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH] hid: usbhid: Use flag HID_DISCONNECTED when a usb device is removed
Date: Fri, 25 Jul 2014 00:13:01 -0500
Message-Id: <1406265181-4009-1-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set disconnected flag in struct usbhid when a usb device
is removed. Check for disconnected flag before sending urb
requests. This prevents a kernel panic when a hid driver calls
hid_hw_request() after removing a usb device.

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 drivers/hid/usbhid/hid-core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 7b88f4c..c8fa957 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -536,7 +536,8 @@ static void __usbhid_submit_report(struct hid_device *hid, struct hid_report *re
 	int head;
 	struct usbhid_device *usbhid = hid->driver_data;
 
-	if ((hid->quirks & HID_QUIRK_NOGET) && dir == USB_DIR_IN)
+	if (((hid->quirks & HID_QUIRK_NOGET) && dir == USB_DIR_IN) ||
+		test_bit(HID_DISCONNECTED, &usbhid->iofl))
 		return;
 
 	if (usbhid->urbout && dir == USB_DIR_OUT && report->type == HID_OUTPUT_REPORT) {
@@ -1366,6 +1367,9 @@ static void usbhid_disconnect(struct usb_interface *intf)
 		return;
 
 	usbhid = hid->driver_data;
+	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
+	set_bit(HID_DISCONNECTED, &usbhid->iofl);
+	spin_unlock_irq(&usbhid->lock);
 	hid_destroy_device(hid);
 	kfree(usbhid);
 }
-- 
1.9.3

