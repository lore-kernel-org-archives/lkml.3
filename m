Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3BURr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:47:29 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53518 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3BURrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:47:25 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: usbduxsigma.c: fix DMA buffers on stack
Date: Thu, 21 Feb 2013 09:47:06 -0800
Message-Id: <1361468826-12053-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an instance of DMA buffer on stack(being passed to
usb_control_msg)for the USB-DUXsigma Board driver. Found using smatch.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxsigma.c |   37 +++++++++++++++++---------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index dc6b017..46137e8 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -681,10 +681,14 @@ static void usbduxsub_ao_IsocIrq(struct urb *urb)
 static int usbduxsub_start(struct usbduxsub *usbduxsub)
 {
 	int errcode = 0;
-	uint8_t local_transfer_buffer[16];
-
+	uint8_t *local_transfer_buffer;
+	local_transfer_buffer = kmalloc(16, GFP_KERNEL);
+	if (!local_transfer_buffer) {
+		errcode = -ENOMEM;
+		goto exit;
+	}
 	/* 7f92 to zero */
-	local_transfer_buffer[0] = 0;
+	*local_transfer_buffer = 0;
 	errcode = usb_control_msg(usbduxsub->usbdev,
 				  /* create a pipe for a control transfer */
 				  usb_sndctrlpipe(usbduxsub->usbdev, 0),
@@ -702,22 +706,28 @@ static int usbduxsub_start(struct usbduxsub *usbduxsub)
 				  1,
 				  /* Timeout */
 				  BULK_TIMEOUT);
-	if (errcode < 0) {
+	if (errcode < 0)
 		dev_err(&usbduxsub->interface->dev,
 			"comedi_: control msg failed (start)\n");
-		return errcode;
-	}
-	return 0;
+
+	kfree(local_transfer_buffer);
+exit:
+	return errcode;
 }
 
 static int usbduxsub_stop(struct usbduxsub *usbduxsub)
 {
 	int errcode = 0;
 
-	uint8_t local_transfer_buffer[16];
+	uint8_t *local_transfer_buffer;
+	local_transfer_buffer = kmalloc(16, GFP_KERNEL);
+	if (!local_transfer_buffer) {
+		errcode = -ENOMEM;
+		goto exit;
+	}
 
 	/* 7f92 to one */
-	local_transfer_buffer[0] = 1;
+	*local_transfer_buffer = 1;
 	errcode = usb_control_msg(usbduxsub->usbdev,
 				  usb_sndctrlpipe(usbduxsub->usbdev, 0),
 				  /* bRequest, "Firmware" */
@@ -732,12 +742,13 @@ static int usbduxsub_stop(struct usbduxsub *usbduxsub)
 				  1,
 				  /* Timeout */
 				  BULK_TIMEOUT);
-	if (errcode < 0) {
+	if (errcode < 0)
 		dev_err(&usbduxsub->interface->dev,
 			"comedi_: control msg failed (stop)\n");
-		return errcode;
-	}
-	return 0;
+
+	kfree(local_transfer_buffer);
+exit:
+	return errcode;
 }
 
 static int usbduxsub_upload(struct usbduxsub *usbduxsub,
-- 
1.7.9.5

