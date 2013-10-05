Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3JEVLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 17:11:51 -0400
Received: from libra.uberspace.de ([95.143.172.171]:58878 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752536Ab3JEVLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 17:11:50 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org, mail@beyermatthias.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] drivers: usb: core: hcd.c: converted busmap from struct to bitmap
Date: Sat,  5 Oct 2013 23:09:15 +0200
Message-Id: <c5e8fd9467e94ccb7f1a5ee4eed674db5fb03211.1381006895.git.mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <e5dba9e89cd8c98d7d2f2578b72482ccf0a4ea88.1380986962.git.mail@beyermatthias.de>
References: <e5dba9e89cd8c98d7d2f2578b72482ccf0a4ea88.1380986962.git.mail@beyermatthias.de>
In-Reply-To: <e5dba9e89cd8c98d7d2f2578b72482ccf0a4ea88.1380986962.git.mail@beyermatthias.de>
References: <e5dba9e89cd8c98d7d2f2578b72482ccf0a4ea88.1380986962.git.mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DECLARE_BITMAP macro should be used for declaring this bitmap.
This commit converts the busmap from a struct to a simple (static)
bitmap, using the DECLARE_BITMAP macro from linux/types.h.

Please review, as I'm new to kernel development, I don't know if this
has any hidden side effects!

Suggested by joe@perches.com

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/hcd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bbd182a..e9e1b33 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -40,6 +40,7 @@
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
 #include <linux/pm_runtime.h>
+#include <linux/types.h>
 
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
@@ -92,10 +93,7 @@ EXPORT_SYMBOL_GPL (usb_bus_list);
 
 /* used when allocating bus numbers */
 #define USB_MAXBUS		64
-struct usb_busmap {
-	unsigned long busmap[USB_MAXBUS / (8*sizeof (unsigned long))];
-};
-static struct usb_busmap busmap;
+static DECLARE_BITMAP(busmap, USB_MAXBUS);
 
 /* used when updating list of hcds */
 DEFINE_MUTEX(usb_bus_list_lock);	/* exported only for usbfs */
@@ -941,12 +939,12 @@ static int usb_register_bus(struct usb_bus *bus)
 	int busnum;
 
 	mutex_lock(&usb_bus_list_lock);
-	busnum = find_next_zero_bit (busmap.busmap, USB_MAXBUS, 1);
+	busnum = find_next_zero_bit(busmap, USB_MAXBUS, 1);
 	if (busnum >= USB_MAXBUS) {
 		printk (KERN_ERR "%s: too many buses\n", usbcore_name);
 		goto error_find_busnum;
 	}
-	set_bit (busnum, busmap.busmap);
+	set_bit(busnum, busmap);
 	bus->busnum = busnum;
 
 	/* Add it to the local list of buses */
@@ -987,7 +985,7 @@ static void usb_deregister_bus (struct usb_bus *bus)
 
 	usb_notify_remove_bus(bus);
 
-	clear_bit (bus->busnum, busmap.busmap);
+	clear_bit(bus->busnum, busmap);
 }
 
 /**
-- 
1.8.4

