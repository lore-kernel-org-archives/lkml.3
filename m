Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3ATC6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 21:58:25 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:43291 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3ATC6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 21:58:24 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] usb: gadget: nokia: Add mass storage driver to g_nokia
Date: Sun, 20 Jan 2013 03:58:13 +0100
Message-Id: <1358650693-29971-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/usb/gadget/nokia.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/usb/gadget/nokia.c b/drivers/usb/gadget/nokia.c
index 661600a..56409ee 100644
--- a/drivers/usb/gadget/nokia.c
+++ b/drivers/usb/gadget/nokia.c
@@ -38,6 +38,7 @@
  * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
  */
 #include "u_serial.c"
+#include "f_mass_storage.c"
 #include "f_acm.c"
 #include "f_ecm.c"
 #include "f_obex.c"
@@ -99,6 +100,17 @@ MODULE_LICENSE("GPL");
 
 /*-------------------------------------------------------------------------*/
 
+static struct fsg_module_parameters fsg_mod_data = {
+	.stall = 0,
+	.luns = 2,
+	.removable_count = 2,
+	.removable = { 1, 1, },
+};
+
+FSG_MODULE_PARAMETERS(/* no prefix */, fsg_mod_data);
+
+static struct fsg_common fsg_common;
+
 static u8 hostaddr[ETH_ALEN];
 
 static int __init nokia_bind_config(struct usb_configuration *c)
@@ -125,6 +137,11 @@ static int __init nokia_bind_config(struct usb_configuration *c)
 	if (status)
 		printk(KERN_DEBUG "could not bind ecm config\n");
 
+	status = fsg_bind_config(c->cdev, c, &fsg_common);
+	if (status)
+		printk(KERN_DEBUG "could not bind fsg config\n");
+	fsg_common_put(&fsg_common);
+
 	return status;
 }
 
@@ -148,6 +165,8 @@ static int __init nokia_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget	*gadget = cdev->gadget;
 	int			status;
+	void			*retp;
+	struct fsg_config	fsg_cfg;
 
 	status = gphonet_setup(cdev->gadget);
 	if (status < 0)
@@ -161,6 +180,15 @@ static int __init nokia_bind(struct usb_composite_dev *cdev)
 	if (status < 0)
 		goto err_ether;
 
+	fsg_config_from_params(&fsg_cfg, &fsg_mod_data);
+	fsg_cfg.vendor_name = "Nokia";
+	fsg_cfg.product_name = "N900";
+	retp = fsg_common_init(&fsg_common, cdev, &fsg_cfg);
+	if (IS_ERR(retp)) {
+		status = PTR_ERR(retp);
+		goto err_fsg;
+	}
+
 	status = usb_string_ids_tab(cdev, strings_dev);
 	if (status < 0)
 		goto err_usb;
@@ -190,6 +218,8 @@ static int __init nokia_bind(struct usb_composite_dev *cdev)
 	return 0;
 
 err_usb:
+	fsg_common_put(&fsg_common);
+err_fsg:
 	gether_cleanup();
 err_ether:
 	gserial_cleanup();
-- 
1.7.10.4

