Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3HWVZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:25:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab3HWVZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:25:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 10/15] USB: serial: convert bus code to use drv_groups
Date: Fri, 23 Aug 2013 14:24:36 -0700
Message-Id: <1377293081-10957-10-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drv_attrs field of struct bus_type is going away soon, drv_groups
should be used instead.  This converts the USB serial bus code to use
the correct field.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/bus.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/bus.c b/drivers/usb/serial/bus.c
index f053b302..24624339 100644
--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -122,7 +122,7 @@ static int usb_serial_device_remove(struct device *dev)
 	return retval;
 }
 
-static ssize_t store_new_id(struct device_driver *driver,
+static ssize_t new_id_store(struct device_driver *driver,
 			    const char *buf, size_t count)
 {
 	struct usb_serial_driver *usb_drv = to_usb_serial_driver(driver);
@@ -135,17 +135,19 @@ static ssize_t store_new_id(struct device_driver *driver,
 	return retval;
 }
 
-static ssize_t show_dynids(struct device_driver *driver, char *buf)
+static ssize_t new_id_show(struct device_driver *driver, char *buf)
 {
 	struct usb_serial_driver *usb_drv = to_usb_serial_driver(driver);
 
 	return usb_show_dynids(&usb_drv->dynids, buf);
 }
+static DRIVER_ATTR_RW(new_id);
 
-static struct driver_attribute drv_attrs[] = {
-	__ATTR(new_id, S_IRUGO | S_IWUSR, show_dynids, store_new_id),
-	__ATTR_NULL,
+static struct attribute *usb_serial_drv_attrs[] = {
+	&driver_attr_new_id.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(usb_serial_drv);
 
 static void free_dynids(struct usb_serial_driver *drv)
 {
@@ -164,7 +166,7 @@ struct bus_type usb_serial_bus_type = {
 	.match =	usb_serial_device_match,
 	.probe =	usb_serial_device_probe,
 	.remove =	usb_serial_device_remove,
-	.drv_attrs = 	drv_attrs,
+	.drv_groups = 	usb_serial_drv_groups,
 };
 
 int usb_serial_bus_register(struct usb_serial_driver *driver)
-- 
1.8.3.rc0.20.gb99dd2e

