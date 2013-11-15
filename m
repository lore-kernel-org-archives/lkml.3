Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3KOUqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 15:46:42 -0500
Received: from mail.ispras.ru ([83.149.199.45]:49859 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3KOUqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 15:46:38 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: gdm724x: fix leak at failure path in gdm_usb_probe()
Date: Sat, 16 Nov 2013 00:46:24 +0400
Message-Id: <1384548384-3835-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling code in gdm_usb_probe() deallocates all resources,
but calls usb_get_dev(usbdev) and returns error code after that.

The patch fixes it and, by the way, several other issues:
- no need to use GFP_ATOMIC in probe();
- return -ENODEV instead of -1;
- kmalloc+memset -> kzalloc

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/gdm724x/gdm_usb.c | 40 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_usb.c b/drivers/staging/gdm724x/gdm_usb.c
index 781134af69d1..33458a583142 100644
--- a/drivers/staging/gdm724x/gdm_usb.c
+++ b/drivers/staging/gdm724x/gdm_usb.c
@@ -830,24 +830,19 @@ static int gdm_usb_probe(struct usb_interface *intf, const struct usb_device_id
 
 	if (bInterfaceNumber > NETWORK_INTERFACE) {
 		pr_info("not a network device\n");
-		return -1;
+		return -ENODEV;
 	}
 
-	phy_dev = kmalloc(sizeof(struct phy_dev), GFP_ATOMIC);
-	if (!phy_dev) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	phy_dev = kzalloc(sizeof(struct phy_dev), GFP_KERNEL);
+	if (!phy_dev)
+		return -ENOMEM;
 
-	udev = kmalloc(sizeof(struct lte_udev), GFP_ATOMIC);
+	udev = kzalloc(sizeof(struct lte_udev), GFP_KERNEL);
 	if (!udev) {
 		ret = -ENOMEM;
-		goto out;
+		goto err_udev;
 	}
 
-	memset(phy_dev, 0, sizeof(struct phy_dev));
-	memset(udev, 0, sizeof(struct lte_udev));
-
 	phy_dev->priv_dev = (void *)udev;
 	phy_dev->send_hci_func = gdm_usb_hci_send;
 	phy_dev->send_sdu_func = gdm_usb_sdu_send;
@@ -858,7 +853,7 @@ static int gdm_usb_probe(struct usb_interface *intf, const struct usb_device_id
 	ret = init_usb(udev);
 	if (ret < 0) {
 		pr_err("init_usb func failed\n");
-		goto out;
+		goto err_init_usb;
 	}
 	udev->intf = intf;
 
@@ -875,23 +870,22 @@ static int gdm_usb_probe(struct usb_interface *intf, const struct usb_device_id
 	ret = request_mac_address(udev);
 	if (ret < 0) {
 		pr_err("request Mac address failed\n");
-		goto out;
+		goto err_mac_address;
 	}
 
 	start_rx_proc(phy_dev);
-out:
-
-	if (ret < 0) {
-		kfree(phy_dev);
-		if (udev) {
-			release_usb(udev);
-			kfree(udev);
-		}
-	}
-
 	usb_get_dev(usbdev);
 	usb_set_intfdata(intf, phy_dev);
 
+	return 0;
+
+err_mac_address:
+	release_usb(udev);
+err_init_usb:
+	kfree(udev);
+err_udev:
+	kfree(phy_dev);
+
 	return ret;
 }
 
-- 
1.8.1.2

