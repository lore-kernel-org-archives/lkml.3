Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3LTMnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:43:20 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38656 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab3LTMj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:28 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 20/26] drbd: Turn drbd_printk() into a polymorphic macro
Date: Fri, 20 Dec 2013 13:29:17 +0100
Message-Id: <1387542563-6833-21-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

This allows drbd_alert(), drbd_err(), drbd_warn(), and drbd_info() to work for
a resource, device, or connection so that we don't have to introduce three
separate sets of macros for that.

The drbd_printk() macro itself is pretty ugly, but that problem is limited to
one place in the code.  Using drbd_printk() on an object type which it doesn't
understand results in an undefined drbd_printk_with_wrong_object_type symbol.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h |   58 ++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 50a68e1..934cdab 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -99,21 +99,49 @@ extern char usermode_helper[];
 struct drbd_device;
 struct drbd_connection;
 
-#define drbd_printk(level, device, fmt, args...) \
-	dev_printk(level, disk_to_dev(device->vdisk), fmt, ## args)
-
-#define drbd_dbg(device, fmt, args...) \
-	drbd_printk(KERN_DEBUG, device, fmt, ## args)
-#define drbd_alert(device, fmt, args...) \
-	drbd_printk(KERN_ALERT, device, fmt, ## args)
-#define drbd_err(device, fmt, args...) \
-	drbd_printk(KERN_ERR, device, fmt, ## args)
-#define drbd_warn(device, fmt, args...) \
-	drbd_printk(KERN_WARNING, device, fmt, ## args)
-#define drbd_info(device, fmt, args...) \
-	drbd_printk(KERN_INFO, device, fmt, ## args)
-#define drbd_emerg(device, fmt, args...) \
-	drbd_printk(KERN_EMERG, device, fmt, ## args)
+#define __drbd_printk_device(level, device, fmt, args...) \
+	dev_printk(level, disk_to_dev((device)->vdisk), fmt, ## args)
+#define __drbd_printk_peer_device(level, peer_device, fmt, args...) \
+	dev_printk(level, disk_to_dev((peer_device)->device->vdisk), fmt, ## args)
+#define __drbd_printk_resource(level, resource, fmt, args...) \
+	printk(level "drbd %s: " fmt, (resource)->name, ## args)
+#define __drbd_printk_connection(level, connection, fmt, args...) \
+	printk(level "drbd %s: " fmt, (connection)->resource->name, ## args)
+
+void drbd_printk_with_wrong_object_type(void);
+
+#define __drbd_printk_if_same_type(obj, type, func, level, fmt, args...) \
+	(__builtin_types_compatible_p(typeof(obj), type) || \
+	 __builtin_types_compatible_p(typeof(obj), const type)), \
+	func(level, (const type)(obj), fmt, ## args)
+
+#define drbd_printk(level, obj, fmt, args...) \
+	__builtin_choose_expr( \
+	  __drbd_printk_if_same_type(obj, struct drbd_device *, \
+			     __drbd_printk_device, level, fmt, ## args), \
+	  __builtin_choose_expr( \
+	    __drbd_printk_if_same_type(obj, struct drbd_resource *, \
+			       __drbd_printk_resource, level, fmt, ## args), \
+	    __builtin_choose_expr( \
+	      __drbd_printk_if_same_type(obj, struct drbd_connection *, \
+				 __drbd_printk_connection, level, fmt, ## args), \
+	      __builtin_choose_expr( \
+		__drbd_printk_if_same_type(obj, struct drbd_peer_device *, \
+				 __drbd_printk_peer_device, level, fmt, ## args), \
+		drbd_printk_with_wrong_object_type()))))
+
+#define drbd_dbg(obj, fmt, args...) \
+	drbd_printk(KERN_DEBUG, obj, fmt, ## args)
+#define drbd_alert(obj, fmt, args...) \
+	drbd_printk(KERN_ALERT, obj, fmt, ## args)
+#define drbd_err(obj, fmt, args...) \
+	drbd_printk(KERN_ERR, obj, fmt, ## args)
+#define drbd_warn(obj, fmt, args...) \
+	drbd_printk(KERN_WARNING, obj, fmt, ## args)
+#define drbd_info(obj, fmt, args...) \
+	drbd_printk(KERN_INFO, obj, fmt, ## args)
+#define drbd_emerg(obj, fmt, args...) \
+	drbd_printk(KERN_EMERG, obj, fmt, ## args)
 
 #define dynamic_drbd_dbg(device, fmt, args...) \
 	dynamic_dev_dbg(disk_to_dev(device->vdisk), fmt, ## args)
-- 
1.7.9.5

