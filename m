Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbaCDTUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:20:17 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34075 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaCDTUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:20:15 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ly80toro@cip.cs.fau.de, ke42caxa@cip.cs.fau.de, eladwexler77@yahoo.com,
        oat.elena@gmail.com, josh@joshtriplett.org, himangi774@gmail.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH] staging: usbip: let client choose device configuration
Date: Tue,  4 Mar 2014 21:20:02 +0200
Message-Id: <1393960802-21626-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since usbip-host is now a device driver and the client
has full access to the shared device, it makes sense to
let the client choose device configuration.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/stub_dev.c | 10 +---------
 drivers/staging/usbip/stub_rx.c  | 26 +++++++-------------------
 2 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 60a3e3f..1bd13cf 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -337,7 +337,7 @@ static int stub_probe(struct usb_device *udev)
 {
 	struct stub_device *sdev = NULL;
 	const char *udev_busid = dev_name(&udev->dev);
-	int err = 0, config;
+	int err = 0;
 	struct bus_id_priv *busid_priv;
 
 	dev_dbg(&udev->dev, "Enter\n");
@@ -383,14 +383,6 @@ static int stub_probe(struct usb_device *udev)
 
 	busid_priv->shutdown_busid = 0;
 
-	config = usb_choose_configuration(udev);
-	if (config >= 0) {
-		err = usb_set_configuration(udev, config);
-		if (err && err != -ENODEV)
-			dev_err(&udev->dev, "can't set config #%d, error %d\n",
-				config, err);
-	}
-
 	/* set private data to usb_device */
 	dev_set_drvdata(&udev->dev, sdev);
 	busid_priv->sdev = sdev;
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 76e44d9..e0b6d6b 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -142,31 +142,19 @@ static int tweak_set_interface_cmd(struct urb *urb)
 
 static int tweak_set_configuration_cmd(struct urb *urb)
 {
+	struct stub_priv *priv = (struct stub_priv *) urb->context;
+	struct stub_device *sdev = priv->sdev;
 	struct usb_ctrlrequest *req;
 	__u16 config;
+	int err;
 
 	req = (struct usb_ctrlrequest *) urb->setup_packet;
 	config = le16_to_cpu(req->wValue);
 
-	/*
-	 * I have never seen a multi-config device. Very rare.
-	 * For most devices, this will be called to choose a default
-	 * configuration only once in an initialization phase.
-	 *
-	 * set_configuration may change a device configuration and its device
-	 * drivers will be unbound and assigned for a new device configuration.
-	 * This means this usbip driver will be also unbound when called, then
-	 * eventually reassigned to the device as far as driver matching
-	 * condition is kept.
-	 *
-	 * Unfortunately, an existing usbip connection will be dropped
-	 * due to this driver unbinding. So, skip here.
-	 * A user may need to set a special configuration value before
-	 * exporting the device.
-	 */
-	dev_info(&urb->dev->dev, "usb_set_configuration %d to %s... skip!\n",
-		 config, dev_name(&urb->dev->dev));
-
+	err = usb_set_configuration(sdev->udev, config);
+	if (err && err != -ENODEV)
+		dev_err(&sdev->udev->dev, "can't set config #%d, error %d\n",
+			config, err);
 	return 0;
 }
 
-- 
1.8.1.2

