Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab3BVSHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:07:45 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41887 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576Ab3BVSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:07:43 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] staging: comedi: drivers: usbduxfast.c: fix for DMA buffers on stack
Date: Fri, 22 Feb 2013 10:07:30 -0800
Message-Id: <1361556450-32572-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix for instances of DMA buffer on stack(being passed to usb_control_msg) for
the USB-DUXfast Board driver.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   30 ++++++++++++++++-----------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 4bf5dd0..1ba0e3d 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -436,10 +436,14 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
 {
 	int ret;
-	unsigned char local_transfer_buffer[16];
+	unsigned char *local_transfer_buffer;
+
+	local_transfer_buffer = kmalloc(1, GFP_KERNEL);
+	if (!local_transfer_buffer)
+		return -ENOMEM;
 
 	/* 7f92 to zero */
-	local_transfer_buffer[0] = 0;
+	*local_transfer_buffer = 0;
 	/* bRequest, "Firmware" */
 	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
 			      USBDUXFASTSUB_FIRMWARE,
@@ -450,22 +454,25 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
 			      local_transfer_buffer,
 			      1,      /* Length */
 			      EZTIMEOUT);    /* Timeout */
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&udfs->interface->dev,
 			"control msg failed (start)\n");
-		return ret;
-	}
 
-	return 0;
+	kfree(local_transfer_buffer);
+	return ret;
 }
 
 static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 {
 	int ret;
-	unsigned char local_transfer_buffer[16];
+	unsigned char *local_transfer_buffer;
+
+	local_transfer_buffer = kmalloc(1, GFP_KERNEL);
+	if (!local_transfer_buffer)
+		return -ENOMEM;
 
 	/* 7f92 to one */
-	local_transfer_buffer[0] = 1;
+	*local_transfer_buffer = 1;
 	/* bRequest, "Firmware" */
 	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
 			      USBDUXFASTSUB_FIRMWARE,
@@ -474,13 +481,12 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 			      0x0000,	/* Index */
 			      local_transfer_buffer, 1,	/* Length */
 			      EZTIMEOUT);	/* Timeout */
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&udfs->interface->dev,
 			"control msg failed (stop)\n");
-		return ret;
-	}
 
-	return 0;
+	kfree(local_transfer_buffer);
+	return ret;
 }
 
 static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
-- 
1.7.9.5

