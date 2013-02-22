Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3BVGHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:07:51 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55756 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3BVGHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:07:49 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2] staging: comedi: drivers: usbduxsigma.c: fix DMA buffers on stack
Date: Thu, 21 Feb 2013 22:07:08 -0800
Message-Id: <1361513228-8897-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an instance of DMA buffer on stack(being passed to
usb_control_msg)for the USB-DUXsigma Board driver. Found using smatch.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxsigma.c |   27 ++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index dc6b017..9e99a4b 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -681,7 +681,11 @@ static void usbduxsub_ao_IsocIrq(struct urb *urb)
 static int usbduxsub_start(struct usbduxsub *usbduxsub)
 {
 	int errcode = 0;
-	uint8_t local_transfer_buffer[16];
+	uint8_t *local_transfer_buffer;
+
+	local_transfer_buffer = kmalloc(16, GFP_KERNEL);
+	if (!local_transfer_buffer)
+		return -ENOMEM;
 
 	/* 7f92 to zero */
 	local_transfer_buffer[0] = 0;
@@ -702,19 +706,22 @@ static int usbduxsub_start(struct usbduxsub *usbduxsub)
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
+	local_transfer_buffer = kmalloc(16, GFP_KERNEL);
+	if (!local_transfer_buffer)
+		return -ENOMEM;
 
 	/* 7f92 to one */
 	local_transfer_buffer[0] = 1;
@@ -732,12 +739,12 @@ static int usbduxsub_stop(struct usbduxsub *usbduxsub)
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

