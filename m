Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3JGVGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:06:38 -0400
Received: from mail.ispras.ru ([83.149.199.45]:56116 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab3JGVGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:06:34 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] cx231xx: fix double free and leaks on failure path in cx231xx_usb_probe()
Date: Tue,  8 Oct 2013 01:06:04 +0400
Message-Id: <1381179964-16451-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are numerous issues in error handling code of cx231xx initialization.
Double free (when cx231xx_init_dev() calls kfree(dev) via cx231xx_release_resources()
and then cx231xx_usb_probe() does the same) and memory leaks
(e.g. usb_get_dev() before (ifnum != 1) check in cx231xx_usb_probe())
are just a few of them.

The patch fixes the issues in cx231xx_usb_probe() and cx231xx_init_dev()
by moving usb_get_dev(interface_to_usbdev(interface)) below in code and
implementing proper error handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 110 ++++++++++++++++--------------
 1 file changed, 57 insertions(+), 53 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index a384f80..e9d017b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -978,7 +978,6 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 			    int minor)
 {
 	int retval = -ENOMEM;
-	int errCode;
 	unsigned int maxh, maxw;
 
 	dev->udev = udev;
@@ -1014,8 +1013,8 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	/* Cx231xx pre card setup */
 	cx231xx_pre_card_setup(dev);
 
-	errCode = cx231xx_config(dev);
-	if (errCode) {
+	retval = cx231xx_config(dev);
+	if (retval) {
 		cx231xx_errdev("error configuring device\n");
 		return -ENOMEM;
 	}
@@ -1024,12 +1023,11 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	dev->norm = dev->board.norm;
 
 	/* register i2c bus */
-	errCode = cx231xx_dev_init(dev);
-	if (errCode < 0) {
-		cx231xx_dev_uninit(dev);
+	retval = cx231xx_dev_init(dev);
+	if (retval) {
 		cx231xx_errdev("%s: cx231xx_i2c_register - errCode [%d]!\n",
-			       __func__, errCode);
-		return errCode;
+			       __func__, retval);
+		goto err_dev_init;
 	}
 
 	/* Do board specific init */
@@ -1047,11 +1045,11 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	dev->interlaced = 0;
 	dev->video_input = 0;
 
-	errCode = cx231xx_config(dev);
-	if (errCode < 0) {
+	retval = cx231xx_config(dev);
+	if (retval) {
 		cx231xx_errdev("%s: cx231xx_config - errCode [%d]!\n",
-			       __func__, errCode);
-		return errCode;
+			       __func__, retval);
+		goto err_dev_init;
 	}
 
 	/* init video dma queues */
@@ -1075,9 +1073,9 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	}
 
 	retval = cx231xx_register_analog_devices(dev);
-	if (retval < 0) {
-		cx231xx_release_resources(dev);
-		return retval;
+	if (retval) {
+		cx231xx_release_analog_resources(dev);
+		goto err_analog;
 	}
 
 	cx231xx_ir_init(dev);
@@ -1085,6 +1083,11 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	cx231xx_init_extension(dev);
 
 	return 0;
+err_analog:
+	cx231xx_remove_from_devlist(dev);
+err_dev_init:
+	cx231xx_dev_uninit(dev);
+	return retval;
 }
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
@@ -1132,7 +1135,6 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	char *speed;
 	struct usb_interface_assoc_descriptor *assoc_desc;
 
-	udev = usb_get_dev(interface_to_usbdev(interface));
 	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 
 	/*
@@ -1161,6 +1163,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		return -ENOMEM;
 	}
 
+	udev = usb_get_dev(interface_to_usbdev(interface));
+
 	snprintf(dev->name, 29, "cx231xx #%d", nr);
 	dev->devno = nr;
 	dev->model = id->driver_info;
@@ -1223,10 +1227,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	if (assoc_desc->bFirstInterface != ifnum) {
 		cx231xx_err(DRIVER_NAME ": Not found "
 			    "matching IAD interface\n");
-		clear_bit(dev->devno, &cx231xx_devused);
-		kfree(dev);
-		dev = NULL;
-		return -ENODEV;
+		retval = -ENODEV;
+		goto err_if;
 	}
 
 	cx231xx_info("registering interface %d\n", ifnum);
@@ -1242,22 +1244,13 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		cx231xx_errdev("v4l2_device_register failed\n");
-		clear_bit(dev->devno, &cx231xx_devused);
-		kfree(dev);
-		dev = NULL;
-		return -EIO;
+		retval = -EIO;
+		goto err_v4l2;
 	}
 	/* allocate device struct */
 	retval = cx231xx_init_dev(dev, udev, nr);
-	if (retval) {
-		clear_bit(dev->devno, &cx231xx_devused);
-		v4l2_device_unregister(&dev->v4l2_dev);
-		kfree(dev);
-		dev = NULL;
-		usb_set_intfdata(interface, NULL);
-
-		return retval;
-	}
+	if (retval)
+		goto err_init;
 
 	/* compute alternate max packet sizes for video */
 	uif = udev->actconfig->interface[dev->current_pcb_config.
@@ -1275,11 +1268,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	if (dev->video_mode.alt_max_pkt_size == NULL) {
 		cx231xx_errdev("out of memory!\n");
-		clear_bit(dev->devno, &cx231xx_devused);
-		v4l2_device_unregister(&dev->v4l2_dev);
-		kfree(dev);
-		dev = NULL;
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_video_alt;
 	}
 
 	for (i = 0; i < dev->video_mode.num_alt; i++) {
@@ -1309,11 +1299,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	if (dev->vbi_mode.alt_max_pkt_size == NULL) {
 		cx231xx_errdev("out of memory!\n");
-		clear_bit(dev->devno, &cx231xx_devused);
-		v4l2_device_unregister(&dev->v4l2_dev);
-		kfree(dev);
-		dev = NULL;
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_vbi_alt;
 	}
 
 	for (i = 0; i < dev->vbi_mode.num_alt; i++) {
@@ -1344,11 +1331,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL) {
 		cx231xx_errdev("out of memory!\n");
-		clear_bit(dev->devno, &cx231xx_devused);
-		v4l2_device_unregister(&dev->v4l2_dev);
-		kfree(dev);
-		dev = NULL;
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_sliced_cc_alt;
 	}
 
 	for (i = 0; i < dev->sliced_cc_mode.num_alt; i++) {
@@ -1380,11 +1364,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 		if (dev->ts1_mode.alt_max_pkt_size == NULL) {
 			cx231xx_errdev("out of memory!\n");
-			clear_bit(dev->devno, &cx231xx_devused);
-			v4l2_device_unregister(&dev->v4l2_dev);
-			kfree(dev);
-			dev = NULL;
-			return -ENOMEM;
+			retval = -ENOMEM;
+			goto err_ts1_alt;
 		}
 
 		for (i = 0; i < dev->ts1_mode.num_alt; i++) {
@@ -1411,6 +1392,29 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	request_modules(dev);
 
 	return 0;
+err_ts1_alt:
+	kfree(dev->sliced_cc_mode.alt_max_pkt_size);
+err_sliced_cc_alt:
+	kfree(dev->vbi_mode.alt_max_pkt_size);
+err_vbi_alt:
+	kfree(dev->video_mode.alt_max_pkt_size);
+err_video_alt:
+	/* cx231xx_uninit_dev: */
+	cx231xx_close_extension(dev);
+	cx231xx_ir_exit(dev);
+	cx231xx_release_analog_resources(dev);
+	cx231xx_417_unregister(dev);
+	cx231xx_remove_from_devlist(dev);
+	cx231xx_dev_uninit(dev);
+err_init:
+	v4l2_device_unregister(&dev->v4l2_dev);
+err_v4l2:
+	usb_set_intfdata(interface, NULL);
+err_if:
+	usb_put_dev(udev);
+	kfree(dev);
+	clear_bit(dev->devno, &cx231xx_devused);
+	return retval;
 }
 
 /*
-- 
1.8.1.2

