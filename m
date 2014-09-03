Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbaICKNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:13:05 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57315 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753530AbaICJ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        James P Michels III <james.p.michels@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 05/56] usb-core bInterval quirk
Date: Wed,  3 Sep 2014 11:26:24 +0200
Message-Id: <c877de31fe78ee82855a2c1049c7b755128f481c.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James P Michels III <james.p.michels@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cd83ce9e6195aa3ea15ab4db92892802c20df5d0 upstream.

This patch adds a usb quirk to support devices with interupt endpoints
and bInterval values expressed as microframes. The quirk causes the
parse endpoint function to modify the reported bInterval to a standards
conforming value.

There is currently code in the endpoint parser that checks for
bIntervals that are outside of the valid range (1-16 for USB 2+ high
speed and super speed interupt endpoints). In this case, the code assumes
the bInterval is being reported in 1ms frames. As well, the correction
is only applied if the original bInterval value is out of the 1-16 range.

With this quirk applied to the device, the bInterval will be
accurately adjusted from microframes to an exponent.

Signed-off-by: James P Michels III <james.p.michels@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/core/config.c  | 11 +++++++++++
 drivers/usb/core/quirks.c  |  4 ++++
 include/linux/usb/quirks.h | 11 +++++++++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 652438325197..98cb09617b20 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -201,6 +201,17 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
 			if (n == 0)
 				n = 9;	/* 32 ms = 2^(9-1) uframes */
 			j = 16;
+
+			/*
+			 * Adjust bInterval for quirked devices.
+			 * This quirk fixes bIntervals reported in
+			 * linear microframes.
+			 */
+			if (to_usb_device(ddev)->quirks &
+				USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL) {
+				n = clamp(fls(d->bInterval), i, j);
+				i = j = n;
+			}
 			break;
 		default:		/* USB_SPEED_FULL or _LOW */
 			/* For low-speed, 10 ms is the official minimum.
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 31f7ebf55868..6fd22252273c 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -147,6 +147,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* SKYMEDI USB_DRIVE */
 	{ USB_DEVICE(0x1516, 0x8628), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Razer - Razer Blade Keyboard */
+	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
+			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
+
 	/* BUILDWIN Photo Frame */
 	{ USB_DEVICE(0x1908, 0x1315), .driver_info =
 			USB_QUIRK_HONOR_BNUMINTERFACES },
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index 52f944dfe2fd..55a17b188daa 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -30,4 +30,15 @@
    descriptor */
 #define USB_QUIRK_DELAY_INIT		0x00000040
 
+/*
+ * For high speed and super speed interupt endpoints, the USB 2.0 and
+ * USB 3.0 spec require the interval in microframes
+ * (1 microframe = 125 microseconds) to be calculated as
+ * interval = 2 ^ (bInterval-1).
+ *
+ * Devices with this quirk report their bInterval as the result of this
+ * calculation instead of the exponent variable used in the calculation.
+ */
+#define USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL	0x00000080
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
2.1.0

