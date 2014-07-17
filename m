Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbaGQXWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:22:39 -0400
Received: from us-mx2.synaptics.com ([192.147.44.131]:32990 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbaGQXWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:22:36 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 17 Jul 2014 16:31:03 -0700
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: rmi: only bind the hid-rmi driver to the mouse interface of composite USB devices
Date: Thu, 17 Jul 2014 16:14:45 -0700
Message-ID: <1405638885-8014-2-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405638885-8014-1-git-send-email-aduggan@synaptics.com>
References: <1405638885-8014-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.2.20.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On composite HID devices there may be multiple HID devices on separate interfaces, but hid-rmi
should only bind to the mouse interface. One example is the Dell Venue 11 Pro's keyboard dock
which contains a composite USB device with a HID touchpad and HID keyboard on separate intefaces.
Since the USB Vendor ID is Synaptic's, hid-core is currently trying to bind hid-rmi to all\of
the HID devices. This patch ensures that hid-rmi only binds to the mouse interface.

related bug:
https://bugzilla.kernel.org/show_bug.cgi?id=80091

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8ed66fd..f10e768 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -783,7 +783,9 @@ static int hid_scan_report(struct hid_device *hid)
 	* Vendor specific handlings
 	*/
 	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
-	    (hid->group == HID_GROUP_GENERIC))
+	    (hid->group == HID_GROUP_GENERIC) &&
+	    /* only bind to the mouse interface of composite USB devices */
+	    (hid->bus != BUS_USB || hid->type == HID_TYPE_USBMOUSE))
 		/* hid-rmi should take care of them, not hid-generic */
 		hid->group = HID_GROUP_RMI;
 
-- 
1.9.1

