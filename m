Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbaJIOAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:00:17 -0400
Received: from w-smtp-out-7.wedos.net ([46.28.106.5]:48310 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752327AbaJIOAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:00:13 -0400
X-Greylist: delayed 728 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2014 10:00:12 EDT
Date: Thu, 9 Oct 2014 15:47:54 +0200
From: Josef Gajdusek <atx@atx.name>
To: linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: Do not re-read descriptors for wired devices in
 usb_authorize_device()
Message-ID: <20141009134754.GA3209@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the usb_authorize_device() function such as that it does
not reload the device descriptor for wired devices. The reasons for this
are as follows:

* Some devices dislike the master requesting the descriptor from them twice,
  failing on the usb_get_device_descriptor() call with -ETIMEOUT. Observed this
  on my Pretec 16GB flash drive (4146:ba65).

* Malicious device could send two different descriptors - one before
  authorization, used by userspace to determine whether to authorize it and
  second to be actually used by the kernel when determining which drivers to
  bind.

Signed-off-by: Josef Gajdusek <atx@atx.name>
---
 drivers/usb/core/hub.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 11e80ac..c096a1a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2543,11 +2543,14 @@ int usb_authorize_device(struct usb_device *usb_dev)
 			"can't autoresume for authorization: %d\n", result);
 		goto error_autoresume;
 	}
-	result = usb_get_device_descriptor(usb_dev, sizeof(usb_dev->descriptor));
-	if (result < 0) {
-		dev_err(&usb_dev->dev, "can't re-read device descriptor for "
-			"authorization: %d\n", result);
-		goto error_device_descriptor;
+
+	if (usb_dev->wusb) {
+		result = usb_get_device_descriptor(usb_dev, sizeof(usb_dev->descriptor));
+		if (result < 0) {
+			dev_err(&usb_dev->dev, "can't re-read device descriptor for "
+				"authorization: %d\n", result);
+			goto error_device_descriptor;
+		}
 	}
 
 	usb_dev->authorized = 1;
-- 
2.0.4

