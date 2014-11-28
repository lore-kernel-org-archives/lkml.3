Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaK1W32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:29:28 -0500
Received: from mail.ispras.ru ([83.149.199.45]:58035 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaK1W31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:29:27 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] usbip: fix error handling in stub_probe()
Date: Sat, 29 Nov 2014 01:29:10 +0300
Message-Id: <1417213750-8856-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If usb_hub_claim_port() fails, no resources are deallocated and
if stub_add_files() fails, port is not released.

The patch fixes these issues and rearranges error handling code.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/usbip/stub_dev.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index fac20e0434c0..a3ec49bdc1e6 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -311,7 +311,6 @@ static int stub_probe(struct usb_device *udev)
 {
 	struct stub_device *sdev = NULL;
 	const char *udev_busid = dev_name(&udev->dev);
-	int err = 0;
 	struct bus_id_priv *busid_priv;
 	int rc;
 
@@ -372,23 +371,28 @@ static int stub_probe(struct usb_device *udev)
 			(struct usb_dev_state *) udev);
 	if (rc) {
 		dev_dbg(&udev->dev, "unable to claim port\n");
-		return rc;
+		goto err_port;
 	}
 
-	err = stub_add_files(&udev->dev);
-	if (err) {
+	rc = stub_add_files(&udev->dev);
+	if (rc) {
 		dev_err(&udev->dev, "stub_add_files for %s\n", udev_busid);
-		dev_set_drvdata(&udev->dev, NULL);
-		usb_put_dev(udev);
-		kthread_stop_put(sdev->ud.eh);
-
-		busid_priv->sdev = NULL;
-		stub_device_free(sdev);
-		return err;
+		goto err_files;
 	}
 	busid_priv->status = STUB_BUSID_ALLOC;
 
 	return 0;
+err_files:
+	usb_hub_release_port(udev->parent, udev->portnum,
+			     (struct usb_dev_state *) udev);
+err_port:
+	dev_set_drvdata(&udev->dev, NULL);
+	usb_put_dev(udev);
+	kthread_stop_put(sdev->ud.eh);
+
+	busid_priv->sdev = NULL;
+	stub_device_free(sdev);
+	return rc;
 }
 
 static void shutdown_busid(struct bus_id_priv *busid_priv)
-- 
1.9.1

