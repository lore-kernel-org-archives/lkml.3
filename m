Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3JRVuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 17:50:09 -0400
Received: from mail.ispras.ru ([83.149.199.45]:55629 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab3JRVuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 17:50:07 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] USB: wusbcore: fix usb_dev leaks
Date: Sat, 19 Oct 2013 01:49:38 +0400
Message-Id: <1382132978-29782-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cbaf_probe() does cbaf->usb_dev = usb_get_dev(interface_to_usbdev(iface)),
but there is no usb_put_dev() anywhere in cbaf.

The patch adds usb_put_dev() to cbaf_disconnect() and to an error path in cbaf_probe().
Also it adds missed usb_put_intf(iface) to the error path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/wusbcore/cbaf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/wusbcore/cbaf.c b/drivers/usb/wusbcore/cbaf.c
index 7f78f30..4035004 100644
--- a/drivers/usb/wusbcore/cbaf.c
+++ b/drivers/usb/wusbcore/cbaf.c
@@ -623,6 +623,8 @@ static int cbaf_probe(struct usb_interface *iface,
 
 error_create_group:
 error_check:
+	usb_put_intf(iface);
+	usb_put_dev(cbaf->usb_dev);
 	kfree(cbaf->buffer);
 error_kmalloc_buffer:
 	kfree(cbaf);
@@ -637,6 +639,7 @@ static void cbaf_disconnect(struct usb_interface *iface)
 	sysfs_remove_group(&dev->kobj, &cbaf_dev_attr_group);
 	usb_set_intfdata(iface, NULL);
 	usb_put_intf(iface);
+	usb_put_dev(cbaf->usb_dev);
 	kfree(cbaf->buffer);
 	/* paranoia: clean up crypto keys */
 	kzfree(cbaf);
-- 
1.8.1.2

