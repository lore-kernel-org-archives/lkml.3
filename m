Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaARXYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 18:24:39 -0500
Received: from mail.ispras.ru ([83.149.199.45]:44903 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaARXYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 18:24:37 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] USB: input: gtco.c: fix usb_dev leak
Date: Sun, 19 Jan 2014 03:24:26 +0400
Message-Id: <1390087466-9898-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is usb_get_dev() in gtco_probe(), but there is no usb_put_dev()
anywhere in the driver.

The patch adds usb_get_dev() to failure handling code of gtco_probe()
and to gtco_disconnect(().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/input/tablet/gtco.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index 29e01ab6859f..6ec8a3a04672 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -858,7 +858,7 @@ static int gtco_probe(struct usb_interface *usbinterface,
 	if (!gtco->buffer) {
 		dev_err(&usbinterface->dev, "No more memory for us buffers\n");
 		error = -ENOMEM;
-		goto err_free_devs;
+		goto err_put_usb;
 	}
 
 	/* Allocate URB for reports */
@@ -990,6 +990,8 @@ static int gtco_probe(struct usb_interface *usbinterface,
  err_free_buf:
 	usb_free_coherent(gtco->usbdev, REPORT_MAX_SIZE,
 			  gtco->buffer, gtco->buf_dma);
+ err_put_usb:
+	usb_put_dev(gtco->usbdev);
  err_free_devs:
 	input_free_device(input_dev);
 	kfree(gtco);
@@ -1013,6 +1015,7 @@ static void gtco_disconnect(struct usb_interface *interface)
 		usb_free_urb(gtco->urbinfo);
 		usb_free_coherent(gtco->usbdev, REPORT_MAX_SIZE,
 				  gtco->buffer, gtco->buf_dma);
+		usb_put_dev(gtco->usbdev);
 		kfree(gtco);
 	}
 
-- 
1.8.3.2

