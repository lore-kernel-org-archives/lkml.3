Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301Ab3BLOxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:53:42 -0500
Received: from science.horizon.com ([71.41.210.146]:57503 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761256Ab3BLOxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:37 -0500
MBOX-Line: From 4b684002d80ec5d05df2c4d34c164330143e82d5 Mon Sep 17 00:00:00 2001
Message-Id: <4b684002d80ec5d05df2c4d34c164330143e82d5.1360677367.git.linux@horizon.com>
In-Reply-To: <cover.1360677367.git.linux@horizon.com>
References: <cover.1360677367.git.linux@horizon.com>
From: George Spelvin <linux@horizon.com>
Date: Sun, 10 Feb 2013 04:08:32 -0500
Subject: [PATCH v2 1/9] pps: Add pps_lookup_dev() function
To: linux-serial@vger.kernel.org, peter@hurleysoftware.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, giometti@linux.it, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PPS serial line discipline wants to attach a PPS device to a tty
without changing the tty code to add a struct pps_device * pointer.

Since the number of PPS devices in a typical system is generally very low
(n=1 is by far the most common), it's practical to search the entire list
of allocated pps devices.  (We capture the timestamp before the lookup,
so the timing isn't affected.)

It is a bit ugly that this function, which is part of the in-kernel
PPS API, has to be in pps.c as opposed to kapi,c, but that's not
something that affects users.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/pps/pps.c          | 33 +++++++++++++++++++++++++++++++++
 include/linux/pps_kernel.h | 17 ++++++++++++++---
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2420d5a..a70e384 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -352,11 +352,44 @@ free_idr:
 
 void pps_unregister_cdev(struct pps_device *pps)
 {
+	pps->lookup_cookie = NULL;
 	device_destroy(pps_class, pps->dev->devt);
 	cdev_del(&pps->cdev);
 }
 
 /*
+ * Look up a pps device by magic cookie.
+ * The cookie is usually a pointer to some enclosing device, but this
+ * code doesn't care; you should never be dereferencing it.
+ *
+ * This is a bit of a kludge that is currently used only by the PPS
+ * serial line discipline.  It may need to be tweaked when a second user
+ * is found.
+ *
+ * There is no function interface for setting the lookup_cookie field.
+ * It's initialized to NULL when the pps device is created, and if a
+ * client wants to use it, just fill it in afterward.
+ *
+ * The cookie is automatically set to NULL in pps_unregister_source()
+ * so that it will not be used again, even if the pps device cannot
+ * be removed from the idr due to pending references holding the minor
+ * number in use.
+ */
+struct pps_device *pps_lookup_dev(void const *cookie)
+{
+	struct pps_device *pps;
+	unsigned id;
+
+	rcu_read_lock();
+	idr_for_each_entry(&pps_idr, pps, id)
+		if (cookie == pps->lookup_cookie)
+			break;
+	rcu_read_unlock();
+	return pps;
+}
+EXPORT_SYMBOL(pps_lookup_dev);
+
+/*
  * Module stuff
  */
 
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index 0cc45ae..7db3eb9 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -43,7 +43,7 @@ struct pps_source_info {
 			int event, void *data);	/* PPS echo function */
 
 	struct module *owner;
-	struct device *dev;
+	struct device *dev;		/* Parent device for device_create */
 };
 
 struct pps_event_time {
@@ -69,6 +69,7 @@ struct pps_device {
 	wait_queue_head_t queue;		/* PPS event queue */
 
 	unsigned int id;			/* PPS source unique ID */
+	void const *lookup_cookie;		/* pps_lookup_dev only */
 	struct cdev cdev;
 	struct device *dev;
 	struct fasync_struct *async_queue;	/* fasync method */
@@ -82,16 +83,26 @@ struct pps_device {
 extern struct device_attribute pps_attrs[];
 
 /*
+ * Internal functions.
+ *
+ * These are not actually part of the exported API, but this is a
+ * convenient header file to put them in.
+ */
+
+extern int pps_register_cdev(struct pps_device *pps);
+extern void pps_unregister_cdev(struct pps_device *pps);
+
+/*
  * Exported functions
  */
 
 extern struct pps_device *pps_register_source(
 		struct pps_source_info *info, int default_params);
 extern void pps_unregister_source(struct pps_device *pps);
-extern int pps_register_cdev(struct pps_device *pps);
-extern void pps_unregister_cdev(struct pps_device *pps);
 extern void pps_event(struct pps_device *pps,
 		struct pps_event_time *ts, int event, void *data);
+/* Look up a pps device by magic cookie */
+struct pps_device *pps_lookup_dev(void const *cookie);
 
 static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
 		struct timespec ts)
-- 
1.8.1.3

