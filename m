Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3CDDyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:54:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33068 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756919Ab3CDDo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:28 -0500
Message-Id: <20130304033712.861646866@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:00 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, George Spelvin <linux@horizon.com>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 053/153] pps: Add pps_lookup_dev() function
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Spelvin <linux@horizon.com>

commit 513b032c98b4b9414aa4e9b4a315cb1bf0380101 upstream.

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
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pps/pps.c          |   33 +++++++++++++++++++++++++++++++++
 include/linux/pps_kernel.h |   17 ++++++++++++++---
 2 files changed, 47 insertions(+), 3 deletions(-)

--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -350,11 +350,44 @@ free_idr:
 
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


