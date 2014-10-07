Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaJGXir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:38:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbaJGXTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.16 19/26] uas: Disable uas on ASM1051 devices
Date: Tue,  7 Oct 2014 16:19:35 -0700
Message-Id: <20141007231849.054467707@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit a9c54caa456dccba938005f6479892b589975e6a upstream.

There are a large numbers of issues with ASM1051 devices in uas mode:

1) They do not support REPORT SUPPORTED OPERATION CODES

2) They use out of spec 8 byte status iu-s when they have no sense data,
   switching to normal 16 byte status iu-s when they do have sense data.

3) They hang / crash when combined with some disks, e.g. a Crucial M500 ssd.

4) They hang / crash when stressed (through e.g. sg_reset --bus) with disks
   with which then normally do work (once 1 & 2 are worked around).

Where as in BOT mode they appear to work fine, so the best way forward with
these devices is to just blacklist them for uas usage.

Unfortunately this is easier said then done. as older versions of the ASM1053
(which works fine) use the same usb-id as the ASM1051.

When connected over USB-3 the 2 can be told apart by the number of streams
they support. So this patch adds some less then pretty code to disable uas for
the ASM1051. When connected over USB-2, simply disable uas alltogether for
devices with the shared usb-id.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas-detect.h |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -59,10 +59,6 @@ static int uas_use_uas_driver(struct usb
 	unsigned long flags = id->driver_info;
 	int r, alt;
 
-	usb_stor_adjust_quirks(udev, &flags);
-
-	if (flags & US_FL_IGNORE_UAS)
-		return 0;
 
 	alt = uas_find_uas_alt_setting(intf);
 	if (alt < 0)
@@ -72,6 +68,29 @@ static int uas_use_uas_driver(struct usb
 	if (r < 0)
 		return 0;
 
+	/*
+	 * ASM1051 and older ASM1053 devices have the same usb-id, and UAS is
+	 * broken on the ASM1051, use the number of streams to differentiate.
+	 * New ASM1053-s also support 32 streams, but have a different prod-id.
+	 */
+	if (udev->descriptor.idVendor == 0x174c &&
+			udev->descriptor.idProduct == 0x55aa) {
+		if (udev->speed < USB_SPEED_SUPER) {
+			/* No streams info, assume ASM1051 */
+			flags |= US_FL_IGNORE_UAS;
+		} else if (usb_ss_max_streams(&eps[1]->ss_ep_comp) == 32) {
+			flags |= US_FL_IGNORE_UAS;
+		}
+	}
+
+	usb_stor_adjust_quirks(udev, &flags);
+
+	if (flags & US_FL_IGNORE_UAS) {
+		dev_warn(&udev->dev,
+			"UAS is blacklisted for this device, using usb-storage instead\n");
+		return 0;
+	}
+
 	if (udev->bus->sg_tablesize == 0) {
 		dev_warn(&udev->dev,
 			"The driver for the USB controller %s does not support scatter-gather which is\n",


