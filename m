Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab3BVSHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:07:21 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:34131 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab3BVSHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:07:19 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] staging: comedi: drivers: usbdux.c: fix DMA buffers on stack
Date: Fri, 22 Feb 2013 10:07:03 -0800
Message-Id: <1361556423-32538-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix for instances of DMA buffer on stack(being passed to usb_control_msg) for
the USB-DUX-D Board driver.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/comedi/drivers/usbdux.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 1a0062a..6aac1f6 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -730,10 +730,14 @@ static void usbduxsub_ao_IsocIrq(struct urb *urb)
 static int usbduxsub_start(struct usbduxsub *usbduxsub)
 {
 	int errcode = 0;
-	uint8_t local_transfer_buffer[16];
+	uint8_t *local_transfer_buffer;
+
+	local_transfer_buffer = kmalloc(1, GFP_KERNEL);
+	if (!local_transfer_buffer)
+		return -ENOMEM;
 
 	/* 7f92 to zero */
-	local_transfer_buffer[0] = 0;
+	*local_transfer_buffer = 0;
 	errcode = usb_control_msg(usbduxsub->usbdev,
 				  /* create a pipe for a control transfer */
 				  usb_sndctrlpipe(usbduxsub->usbdev, 0),
@@ -751,22 +755,25 @@ static int usbduxsub_start(struct usbduxsub *usbduxsub)
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
+	return errcode;
 }
 
 static int usbduxsub_stop(struct usbduxsub *usbduxsub)
 {
 	int errcode = 0;
+	uint8_t *local_transfer_buffer;
 
-	uint8_t local_transfer_buffer[16];
+	local_transfer_buffer = kmalloc(1, GFP_KERNEL);
+	if (!local_transfer_buffer)
+		return -ENOMEM;
 
 	/* 7f92 to one */
-	local_transfer_buffer[0] = 1;
+	*local_transfer_buffer = 1;
 	errcode = usb_control_msg(usbduxsub->usbdev,
 				  usb_sndctrlpipe(usbduxsub->usbdev, 0),
 				  /* bRequest, "Firmware" */
@@ -781,12 +788,12 @@ static int usbduxsub_stop(struct usbduxsub *usbduxsub)
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
+	return errcode;
 }
 
 static int usbduxsub_upload(struct usbduxsub *usbduxsub,
-- 
1.7.9.5

