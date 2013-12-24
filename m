Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab3LXEfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 23:35:12 -0500
Received: from smtphost-2000.fit.edu ([163.118.131.50]:54501 "EHLO
	smtphost-2000.fit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab3LXEfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 23:35:09 -0500
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Dec 2013 23:35:08 EST
From: "Marius  Silaghi" <msilaghi@fit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Xenia Ragiadakou" <burzalodowa@gmail.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] usbcore: fix BABBLE failed enumeration of legacy USB2
 devices on USB3 bus
Thread-Topic: [PATCH] usbcore: fix BABBLE failed enumeration of legacy USB2
 devices on USB3 bus
Thread-Index: AQHPAFzcYZtWgZLIz0KQ9y3GFuGqZA==
Date: Tue, 24 Dec 2013 04:19:18 +0000
Message-ID: <02270BA454DB7548ABE8E2EBF31D46D96FC7B4C5@EX10-BE1.fit.edu>
Accept-Language: en-US, ro-RO
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.88.117.201]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marius C Silaghi <msilaghi@fit.edu>

This patch is generated against the last kernel version in the github kernel repository.
Some older families of USB2 cameras (STC-XXXXXUSB) do not support querying only the first 8 bytes of their 
device descriptor and therefore fail at enumeration on USB3 HCDs, with babble error -75 as they send more than
the expected 8 bytes. The proposed patch extends the mechanism used for non USB3 HCDs in the first part of 
the same function, and  successively tries to query both the 8 byte prefix of the device descriptor, as well as 
the whole device descriptor (in case the old style query of the 8 byte prefix fails).
In fact, for the cameras I try to fix, the preferred condition is the negation of the one in the proposed patch,  
"if (!USE_NEW_SCHEME(retry_counter))", to try first the version successful on this case, but I keep the 
current order of the "if" branches to ensure clean continuation of support for other supported devices.

Signed-off-by: Marius C Silaghi <msilaghi@fit.edu>
---
--- linux/drivers/usb/core/hub.c.orig	2013-12-23 22:09:50.545093470 -0500
+++ linux/drivers/usb/core/hub.c	2013-12-23 22:29:40.521043702 -0500
@@ -4197,7 +4197,19 @@ hub_port_init (struct usb_hub *hub, stru
 				break;
 		}
 
-		retval = usb_get_device_descriptor(udev, 8);
+		/*  Try first the old 8-byte query (since it may be expected
+		 *  by some devices), but then give at least a chance to the
+		 *  new form (retrieving the whole descriptor)!
+		 *  Querying the content of the whole structure is required
+		 *  for older USB2 video cameras which do not support partial
+		 *  descriptor queries, like the STC-XXXUSB family.
+		 *  Windows also supports them.
+		 */
+		if (USE_NEW_SCHEME(retry_counter))
+			retval = usb_get_device_descriptor(udev, 8);
+		else
+			retval = usb_get_device_descriptor(udev,
+				       sizeof(struct usb_device_descriptor));
 		if (retval < 8) {
 			if (retval != -ENODEV)
 				dev_err(&udev->dev,

