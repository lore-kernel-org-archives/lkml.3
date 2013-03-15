Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab3COVat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:30:49 -0400
Received: from mail.ispras.ru ([83.149.199.45]:55075 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab3COVar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:30:47 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] usb: cdc-acm: fix error handling in acm_probe()
Date: Sat, 16 Mar 2013 01:30:32 +0400
Message-Id: <1363383032-13257-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acm_probe() ignores errors in tty_port_register_device()
and leaves intfdata pointing to freed memory on alloc_fail7
error path. The patch fixes the both issues.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/class/cdc-acm.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8ac25ad..c125b61 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -977,6 +977,8 @@ static int acm_probe(struct usb_interface *intf,
 	int num_rx_buf;
 	int i;
 	int combined_interfaces = 0;
+	struct device *tty_dev;
+	int rv = -ENOMEM;
 
 	/* normal quirks */
 	quirks = (unsigned long)id->driver_info;
@@ -1339,11 +1341,24 @@ skip_countries:
 	usb_set_intfdata(data_interface, acm);
 
 	usb_get_intf(control_interface);
-	tty_port_register_device(&acm->port, acm_tty_driver, minor,
+	tty_dev = tty_port_register_device(&acm->port, acm_tty_driver, minor,
 			&control_interface->dev);
+	if (IS_ERR(tty_dev)) {
+		rv = PTR_ERR(tty_dev);
+		goto alloc_fail8;
+	}
 
 	return 0;
+alloc_fail8:
+	if (acm->country_codes) {
+		device_remove_file(&acm->control->dev,
+				&dev_attr_wCountryCodes);
+		device_remove_file(&acm->control->dev,
+				&dev_attr_iCountryCodeRelDate);
+	}
+	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
 alloc_fail7:
+	usb_set_intfdata(intf, NULL);
 	for (i = 0; i < ACM_NW; i++)
 		usb_free_urb(acm->wb[i].urb);
 alloc_fail6:
@@ -1359,7 +1374,7 @@ alloc_fail2:
 	acm_release_minor(acm);
 	kfree(acm);
 alloc_fail:
-	return -ENOMEM;
+	return rv;
 }
 
 static void stop_data_traffic(struct acm *acm)
-- 
1.7.9.5

