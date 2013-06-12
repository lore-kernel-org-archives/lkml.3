Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3FLNBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:01:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:32085 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3FLNBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:01:11 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 01/01] staging: ozwpan: remove event tracing code.
Date: Wed, 12 Jun 2013 14:00:52 +0100
Message-ID: <1371042052-13463-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371042052-13463-1-git-send-email-rupesh.gujare@atmel.com>
References: <1371042052-13463-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes event tracing code as it can be replaced
by in-kernel tracing infrastructure.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/Kbuild       |    3 +-
 drivers/staging/ozwpan/ozappif.h    |    2 -
 drivers/staging/ozwpan/ozcdev.c     |    5 -
 drivers/staging/ozwpan/ozconfig.h   |    1 -
 drivers/staging/ozwpan/ozevent.c    |  195 -----------------------------------
 drivers/staging/ozwpan/ozevent.h    |   32 ------
 drivers/staging/ozwpan/ozeventdef.h |   40 -------
 drivers/staging/ozwpan/ozhcd.c      |   47 ---------
 drivers/staging/ozwpan/ozmain.c     |    9 --
 drivers/staging/ozwpan/ozpd.c       |   23 +----
 drivers/staging/ozwpan/ozproto.c    |   17 ---
 drivers/staging/ozwpan/ozusbsvc.c   |    5 -
 drivers/staging/ozwpan/ozusbsvc1.c  |    5 -
 13 files changed, 4 insertions(+), 380 deletions(-)
 delete mode 100644 drivers/staging/ozwpan/ozevent.c
 delete mode 100644 drivers/staging/ozwpan/ozevent.h
 delete mode 100644 drivers/staging/ozwpan/ozeventdef.h

diff --git a/drivers/staging/ozwpan/Kbuild b/drivers/staging/ozwpan/Kbuild
index 6cc84cb..1766a26 100644
--- a/drivers/staging/ozwpan/Kbuild
+++ b/drivers/staging/ozwpan/Kbuild
@@ -13,7 +13,6 @@ ozwpan-y := \
 	ozproto.o \
 	ozcdev.o \
 	ozurbparanoia.o \
-	oztrace.o \
-	ozevent.o
+	oztrace.o
 
 
diff --git a/drivers/staging/ozwpan/ozappif.h b/drivers/staging/ozwpan/ozappif.h
index 449a6ba..ea1b271 100644
--- a/drivers/staging/ozwpan/ozappif.h
+++ b/drivers/staging/ozwpan/ozappif.h
@@ -6,8 +6,6 @@
 #ifndef _OZAPPIF_H
 #define _OZAPPIF_H
 
-#include "ozeventdef.h"
-
 #define OZ_IOCTL_MAGIC	0xf4
 
 struct oz_mac_addr {
diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 8dc24ea..374fdc3 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -18,7 +18,6 @@
 #include "ozeltbuf.h"
 #include "ozpd.h"
 #include "ozproto.h"
-#include "ozevent.h"
 #include "ozcdev.h"
 /*------------------------------------------------------------------------------
  */
@@ -390,7 +389,6 @@ int oz_cdev_deregister(void)
  */
 int oz_cdev_init(void)
 {
-	oz_event_log(OZ_EVT_SERVICE, 1, OZ_APPID_SERIAL, NULL, 0);
 	oz_app_enable(OZ_APPID_SERIAL, 1);
 	return 0;
 }
@@ -399,7 +397,6 @@ int oz_cdev_init(void)
  */
 void oz_cdev_term(void)
 {
-	oz_event_log(OZ_EVT_SERVICE, 2, OZ_APPID_SERIAL, NULL, 0);
 	oz_app_enable(OZ_APPID_SERIAL, 0);
 }
 /*------------------------------------------------------------------------------
@@ -409,7 +406,6 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
 {
 	struct oz_serial_ctx *ctx;
 	struct oz_serial_ctx *old_ctx;
-	oz_event_log(OZ_EVT_SERVICE, 3, OZ_APPID_SERIAL, NULL, resume);
 	if (resume) {
 		oz_trace("Serial service resumed.\n");
 		return 0;
@@ -445,7 +441,6 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
 void oz_cdev_stop(struct oz_pd *pd, int pause)
 {
 	struct oz_serial_ctx *ctx;
-	oz_event_log(OZ_EVT_SERVICE, 4, OZ_APPID_SERIAL, NULL, pause);
 	if (pause) {
 		oz_trace("Serial service paused.\n");
 		return;
diff --git a/drivers/staging/ozwpan/ozconfig.h b/drivers/staging/ozwpan/ozconfig.h
index 43e6373..087c322 100644
--- a/drivers/staging/ozwpan/ozconfig.h
+++ b/drivers/staging/ozwpan/ozconfig.h
@@ -12,7 +12,6 @@
 /* #define WANT_URB_PARANOIA */
 
 /* #define WANT_PRE_2_6_39 */
-#define WANT_EVENT_TRACE
 
 /* These defines determine what verbose trace is displayed. */
 #ifdef WANT_VERBOSE_TRACE
diff --git a/drivers/staging/ozwpan/ozevent.c b/drivers/staging/ozwpan/ozevent.c
deleted file mode 100644
index 77e8675..0000000
--- a/drivers/staging/ozwpan/ozevent.c
+++ /dev/null
@@ -1,195 +0,0 @@
-/* -----------------------------------------------------------------------------
- * Copyright (c) 2011 Ozmo Inc
- * Released under the GNU General Public License Version 2 (GPLv2).
- * -----------------------------------------------------------------------------
- */
-#include "ozconfig.h"
-#ifdef WANT_EVENT_TRACE
-#include <linux/module.h>
-#include <linux/debugfs.h>
-#include <linux/jiffies.h>
-#include <linux/uaccess.h>
-#include "oztrace.h"
-#include "ozevent.h"
-#include "ozappif.h"
-/*------------------------------------------------------------------------------
- * Although the event mask is logically part of the oz_evtdev structure, it is
- * needed outside of this file so define it separately to avoid the need to
- * export definition of struct oz_evtdev.
- */
-u32 g_evt_mask;
-/*------------------------------------------------------------------------------
- */
-#define OZ_MAX_EVTS	2048	/* Must be power of 2 */
-struct oz_evtdev {
-	struct dentry *root_dir;
-	int evt_in;
-	int evt_out;
-	int missed_events;
-	int present;
-	atomic_t users;
-	spinlock_t lock;
-	struct oz_event evts[OZ_MAX_EVTS];
-};
-
-static struct oz_evtdev g_evtdev;
-
-/*------------------------------------------------------------------------------
- * Context: process
- */
-void oz_event_init(void)
-{
-	/* Because g_evtdev is static external all fields initially zero so no
-	 * need to reinitialized those.
-	 */
-	oz_trace("Event tracing initialized\n");
-	spin_lock_init(&g_evtdev.lock);
-	atomic_set(&g_evtdev.users, 0);
-}
-/*------------------------------------------------------------------------------
- * Context: process
- */
-void oz_event_term(void)
-{
-	oz_trace("Event tracing terminated\n");
-}
-/*------------------------------------------------------------------------------
- * Context: any
- */
-void oz_event_log2(u8 evt, u8 ctx1, u16 ctx2, void *ctx3, unsigned ctx4)
-{
-	unsigned long irqstate;
-	int ix;
-	spin_lock_irqsave(&g_evtdev.lock, irqstate);
-	ix = (g_evtdev.evt_in + 1) & (OZ_MAX_EVTS - 1);
-	if (ix != g_evtdev.evt_out) {
-		struct oz_event *e = &g_evtdev.evts[g_evtdev.evt_in];
-		e->jiffies = jiffies;
-		e->evt = evt;
-		e->ctx1 = ctx1;
-		e->ctx2 = ctx2;
-		e->ctx3 = (__u32)(unsigned long)ctx3;
-		e->ctx4 = ctx4;
-		g_evtdev.evt_in = ix;
-	} else {
-		g_evtdev.missed_events++;
-	}
-	spin_unlock_irqrestore(&g_evtdev.lock, irqstate);
-}
-/*------------------------------------------------------------------------------
- * Context: process
- */
-#ifdef CONFIG_DEBUG_FS
-static void oz_events_clear(struct oz_evtdev *dev)
-{
-	unsigned long irqstate;
-	oz_trace("Clearing events\n");
-	spin_lock_irqsave(&dev->lock, irqstate);
-	dev->evt_in = dev->evt_out = 0;
-	dev->missed_events = 0;
-	spin_unlock_irqrestore(&dev->lock, irqstate);
-}
-/*------------------------------------------------------------------------------
- * Context: process
- */
-static int oz_events_open(struct inode *inode, struct file *filp)
-{
-	oz_trace("oz_evt_open()\n");
-	oz_trace("Open flags: 0x%x\n", filp->f_flags);
-	if (atomic_add_return(1, &g_evtdev.users) == 1) {
-		oz_events_clear(&g_evtdev);
-		return nonseekable_open(inode, filp);
-	} else {
-		atomic_dec(&g_evtdev.users);
-		return -EBUSY;
-	}
-}
-/*------------------------------------------------------------------------------
- * Context: process
- */
-static int oz_events_release(struct inode *inode, struct file *filp)
-{
-	oz_events_clear(&g_evtdev);
-	atomic_dec(&g_evtdev.users);
-	g_evt_mask = 0;
-	oz_trace("oz_evt_release()\n");
-	return 0;
-}
-/*------------------------------------------------------------------------------
- * Context: process
- */
-static ssize_t oz_events_read(struct file *filp, char __user *buf, size_t count,
-		loff_t *fpos)
-{
-	struct oz_evtdev *dev = &g_evtdev;
-	int rc = 0;
-	int nb_evts = count / sizeof(struct oz_event);
-	int n;
-	int sz;
-
-	n = dev->evt_in - dev->evt_out;
-	if (n < 0)
-		n += OZ_MAX_EVTS;
-	if (nb_evts > n)
-		nb_evts = n;
-	if (nb_evts == 0)
-		goto out;
-	n = OZ_MAX_EVTS - dev->evt_out;
-	if (n > nb_evts)
-		n = nb_evts;
-	sz = n * sizeof(struct oz_event);
-	if (copy_to_user(buf, &dev->evts[dev->evt_out], sz)) {
-		rc = -EFAULT;
-		goto out;
-	}
-	if (n == nb_evts)
-		goto out2;
-	n = nb_evts - n;
-	if (copy_to_user(buf + sz, dev->evts, n * sizeof(struct oz_event))) {
-		rc = -EFAULT;
-		goto out;
-	}
-out2:
-	dev->evt_out = (dev->evt_out + nb_evts) & (OZ_MAX_EVTS - 1);
-	rc = nb_evts * sizeof(struct oz_event);
-out:
-	return rc;
-}
-/*------------------------------------------------------------------------------
- */
-static const struct file_operations oz_events_fops = {
-	.owner =	THIS_MODULE,
-	.open =		oz_events_open,
-	.release =	oz_events_release,
-	.read =		oz_events_read,
-};
-/*------------------------------------------------------------------------------
- * Context: process
- */
-void oz_debugfs_init(void)
-{
-	struct dentry *parent;
-
-	parent = debugfs_create_dir("ozwpan", NULL);
-	if (parent  == NULL) {
-		oz_trace("Failed to create debugfs directory ozmo\n");
-		return;
-	} else {
-		g_evtdev.root_dir = parent;
-		if (debugfs_create_file("events", S_IRUSR, parent, NULL,
-						&oz_events_fops) == NULL)
-			oz_trace("Failed to create file ozmo/events\n");
-		if (debugfs_create_x32("event_mask", S_IRUSR | S_IWUSR, parent,
-							&g_evt_mask) == NULL)
-			oz_trace("Failed to create file ozmo/event_mask\n");
-	}
-}
-/*------------------------------------------------------------------------------
- * Context: process
- */
-void oz_debugfs_remove(void)
-{
-	debugfs_remove_recursive(g_evtdev.root_dir);
-}
-#endif /* CONFIG_DEBUG_FS */
-#endif /* WANT_EVENT_TRACE */
diff --git a/drivers/staging/ozwpan/ozevent.h b/drivers/staging/ozwpan/ozevent.h
deleted file mode 100644
index 32f6f98..0000000
--- a/drivers/staging/ozwpan/ozevent.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* -----------------------------------------------------------------------------
- * Copyright (c) 2011 Ozmo Inc
- * Released under the GNU General Public License Version 2 (GPLv2).
- * -----------------------------------------------------------------------------
- */
-#ifndef _OZEVENT_H
-#define _OZEVENT_H
-#include "ozconfig.h"
-#include "ozeventdef.h"
-
-#ifdef WANT_EVENT_TRACE
-extern u32 g_evt_mask;
-void oz_event_init(void);
-void oz_event_term(void);
-void oz_event_log2(u8 evt, u8 ctx1, u16 ctx2, void *ctx3, unsigned ctx4);
-void oz_debugfs_init(void);
-void oz_debugfs_remove(void);
-#define oz_event_log(__evt, __ctx1, __ctx2, __ctx3, __ctx4) \
-	do { \
-		if ((1<<(__evt)) & g_evt_mask) \
-			oz_event_log2(__evt, __ctx1, __ctx2, __ctx3, __ctx4); \
-	} while (0)
-
-#else
-#define oz_event_init()
-#define oz_event_term()
-#define oz_event_log(__evt, __ctx1, __ctx2, __ctx3, __ctx4)
-#define oz_debugfs_init()
-#define oz_debugfs_remove()
-#endif /* WANT_EVENT_TRACE */
-
-#endif /* _OZEVENT_H */
diff --git a/drivers/staging/ozwpan/ozeventdef.h b/drivers/staging/ozwpan/ozeventdef.h
deleted file mode 100644
index 4b93898..0000000
--- a/drivers/staging/ozwpan/ozeventdef.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* -----------------------------------------------------------------------------
- * Copyright (c) 2011 Ozmo Inc
- * Released under the GNU General Public License Version 2 (GPLv2).
- * -----------------------------------------------------------------------------
- */
-#ifndef _OZEVENTDEF_H
-#define _OZEVENTDEF_H
-
-#define OZ_EVT_RX_FRAME		0
-#define OZ_EVT_RX_PROCESS	1
-#define OZ_EVT_TX_FRAME		2
-#define OZ_EVT_TX_ISOC		3
-#define OZ_EVT_URB_SUBMIT	4
-#define OZ_EVT_URB_DONE		5
-#define OZ_EVT_URB_CANCEL	6
-#define OZ_EVT_CTRL_REQ		7
-#define OZ_EVT_CTRL_CNF		8
-#define OZ_EVT_CTRL_LOCAL	9
-#define OZ_EVT_CONNECT_REQ	10
-#define OZ_EVT_CONNECT_RSP	11
-#define OZ_EVT_EP_CREDIT	12
-#define OZ_EVT_EP_BUFFERING	13
-#define OZ_EVT_TX_ISOC_DONE	14
-#define OZ_EVT_TX_ISOC_DROP	15
-#define OZ_EVT_TIMER_CTRL	16
-#define OZ_EVT_TIMER		17
-#define OZ_EVT_PD_STATE		18
-#define OZ_EVT_SERVICE		19
-#define OZ_EVT_DEBUG		20
-
-struct oz_event {
-	__u32 jiffies;
-	__u8 evt;
-	__u8 ctx1;
-	__u16 ctx2;
-	__u32 ctx3;
-	__u32 ctx4;
-};
-
-#endif /* _OZEVENTDEF_H */
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 5487a3a..d68d63a 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -35,7 +35,6 @@
 #include "ozusbif.h"
 #include "oztrace.h"
 #include "ozurbparanoia.h"
-#include "ozevent.h"
 #include "ozhcd.h"
 /*------------------------------------------------------------------------------
  * Number of units of buffering to capture for an isochronous IN endpoint before
@@ -381,7 +380,6 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
 			jiffies, urb, status, jiffies-submit_jiffies,
 			jiffies-last_time, atomic_read(&g_pending_urbs));
 		last_time = jiffies;
-		oz_event_log(OZ_EVT_URB_DONE, 0, 0, urb, status);
 		usb_hcd_giveback_urb(hcd, urb, status);
 	}
 	spin_lock(&g_tasklet_lock);
@@ -508,8 +506,6 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 		if (!in_dir && ep_addr && (ep->credit < 0)) {
 			ep->last_jiffies = jiffies;
 			ep->credit = 0;
-			oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num,
-					0, NULL, ep->credit);
 		}
 	} else {
 		err = -EPIPE;
@@ -766,7 +762,6 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 	struct urb *urb;
 	int err = 0;
 
-	oz_event_log(OZ_EVT_CTRL_CNF, 0, req_id, NULL, status);
 	oz_trace("oz_hcd_get_desc_cnf length = %d offs = %d tot_size = %d\n",
 			length, offset, total_size);
 	urb = oz_find_urb_by_id(port, 0, req_id);
@@ -905,7 +900,6 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 	unsigned windex;
 	unsigned wvalue;
 
-	oz_event_log(OZ_EVT_CTRL_CNF, 0, req_id, NULL, rcode);
 	oz_trace("oz_hcd_control_cnf rcode=%u len=%d\n", rcode, data_len);
 	urb = oz_find_urb_by_id(port, 0, req_id);
 	if (!urb) {
@@ -1059,8 +1053,6 @@ int oz_hcd_heartbeat(void *hport)
 		ep->credit += jiffies_to_msecs(now - ep->last_jiffies);
 		if (ep->credit > ep->credit_ceiling)
 			ep->credit = ep->credit_ceiling;
-		oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num, 0, NULL,
-			     ep->credit);
 		ep->last_jiffies = now;
 		while (ep->credit && !list_empty(&ep->urb_list)) {
 			urbl = list_first_entry(&ep->urb_list,
@@ -1069,8 +1061,6 @@ int oz_hcd_heartbeat(void *hport)
 			if ((ep->credit + 1) < urb->number_of_packets)
 				break;
 			ep->credit -= urb->number_of_packets;
-			oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num, 0, NULL,
-				     ep->credit);
 			list_move_tail(&urbl->link, &xfr_list);
 		}
 	}
@@ -1098,19 +1088,12 @@ int oz_hcd_heartbeat(void *hport)
 			if (ep->buffered_units >= OZ_IN_BUFFERING_UNITS) {
 				ep->flags &= ~OZ_F_EP_BUFFERING;
 				ep->credit = 0;
-				oz_event_log(OZ_EVT_EP_CREDIT,
-					ep->ep_num | USB_DIR_IN,
-					0, NULL, ep->credit);
 				ep->last_jiffies = now;
 				ep->start_frame = 0;
-				oz_event_log(OZ_EVT_EP_BUFFERING,
-					ep->ep_num | USB_DIR_IN, 0, NULL, 0);
 			}
 			continue;
 		}
 		ep->credit += jiffies_to_msecs(now - ep->last_jiffies);
-		oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num | USB_DIR_IN,
-			0, NULL, ep->credit);
 		ep->last_jiffies = now;
 		while (!list_empty(&ep->urb_list)) {
 			struct oz_urb_link *urbl =
@@ -1154,8 +1137,6 @@ int oz_hcd_heartbeat(void *hport)
 			ep->start_frame += urb->number_of_packets;
 			list_move_tail(&urbl->link, &xfr_list);
 			ep->credit -= urb->number_of_packets;
-			oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num | USB_DIR_IN,
-				0, NULL, ep->credit);
 		}
 	}
 	if (!list_empty(&port->isoc_out_ep) || !list_empty(&port->isoc_in_ep))
@@ -1247,8 +1228,6 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 			ep->credit_ceiling = 200;
 			if (ep_addr & USB_ENDPOINT_DIR_MASK) {
 				ep->flags |= OZ_F_EP_BUFFERING;
-				oz_event_log(OZ_EVT_EP_BUFFERING,
-					ep->ep_num | USB_DIR_IN, 1, NULL, 0);
 			} else {
 				ep->flags |= OZ_F_EP_HAVE_STREAM;
 				if (oz_usb_stream_create(port->hpd, ep_num))
@@ -1455,8 +1434,6 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 			oz_trace("USB_REQ_GET_DESCRIPTOR - req\n");
 			break;
 		case USB_REQ_SET_ADDRESS:
-			oz_event_log(OZ_EVT_CTRL_LOCAL, setup->bRequest,
-				0, NULL, setup->bRequestType);
 			oz_trace("USB_REQ_SET_ADDRESS - req\n");
 			oz_trace("Port %d address is 0x%x\n", ozhcd->conn_port,
 				(u8)le16_to_cpu(setup->wValue));
@@ -1477,8 +1454,6 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 			/* We short circuit this case and reply directly since
 			 * we have the selected configuration number cached.
 			 */
-			oz_event_log(OZ_EVT_CTRL_LOCAL, setup->bRequest, 0,
-				     NULL, setup->bRequestType);
 			oz_trace("USB_REQ_GET_CONFIGURATION - reply now\n");
 			if (urb->transfer_buffer_length >= 1) {
 				urb->actual_length = 1;
@@ -1493,8 +1468,6 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 			/* We short circuit this case and reply directly since
 			 * we have the selected interface alternative cached.
 			 */
-			oz_event_log(OZ_EVT_CTRL_LOCAL, setup->bRequest, 0,
-				     NULL, setup->bRequestType);
 			oz_trace("USB_REQ_GET_INTERFACE - reply now\n");
 			if (urb->transfer_buffer_length >= 1) {
 				urb->actual_length = 1;
@@ -1744,20 +1717,6 @@ static void oz_hcd_shutdown(struct usb_hcd *hcd)
 	oz_trace("oz_hcd_shutdown()\n");
 }
 /*------------------------------------------------------------------------------
- * Context: any
- */
-#ifdef WANT_EVENT_TRACE
-static u8 oz_get_irq_ctx(void)
-{
-	u8 irq_info = 0;
-	if (in_interrupt())
-		irq_info |= 1;
-	if (in_irq())
-		irq_info |= 2;
-	return irq_info;
-}
-#endif /* WANT_EVENT_TRACE */
-/*------------------------------------------------------------------------------
  * Called to queue an urb for the device.
  * This function should return a non-zero error code if it fails the urb but
  * should not call usb_hcd_giveback_urb().
@@ -1774,8 +1733,6 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	struct oz_urb_link *urbl;
 	oz_trace2(OZ_TRACE_URB, "%lu: oz_hcd_urb_enqueue(%p)\n",
 		jiffies, urb);
-	oz_event_log(OZ_EVT_URB_SUBMIT, oz_get_irq_ctx(),
-		(u16)urb->number_of_packets, urb, urb->pipe);
 	if (unlikely(ozhcd == NULL)) {
 		oz_trace2(OZ_TRACE_URB, "%lu: Refused urb(%p) not ozhcd.\n",
 			jiffies, urb);
@@ -1835,10 +1792,6 @@ static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
 				ep->credit -= urb->number_of_packets;
 				if (ep->credit < 0)
 					ep->credit = 0;
-				oz_event_log(OZ_EVT_EP_CREDIT,
-					usb_pipein(urb->pipe) ?
-					(ep->ep_num | USB_DIR_IN) : ep->ep_num,
-					0, NULL, ep->credit);
 			}
 			return urbl;
 		}
diff --git a/drivers/staging/ozwpan/ozmain.c b/drivers/staging/ozwpan/ozmain.c
index 57a0cbd..51fe9e9 100644
--- a/drivers/staging/ozwpan/ozmain.c
+++ b/drivers/staging/ozwpan/ozmain.c
@@ -15,7 +15,6 @@
 #include "ozproto.h"
 #include "ozcdev.h"
 #include "oztrace.h"
-#include "ozevent.h"
 /*------------------------------------------------------------------------------
  * The name of the 802.11 mac device. Empty string is the default value but a
  * value can be supplied as a parameter to the module. An empty string means
@@ -28,14 +27,10 @@ static char *g_net_dev = "";
  */
 static int __init ozwpan_init(void)
 {
-	oz_event_init();
 	oz_cdev_register();
 	oz_protocol_init(g_net_dev);
 	oz_app_enable(OZ_APPID_USB, 1);
 	oz_apps_init();
-#ifdef CONFIG_DEBUG_FS
-	oz_debugfs_init();
-#endif
 	return 0;
 }
 /*------------------------------------------------------------------------------
@@ -46,10 +41,6 @@ static void __exit ozwpan_exit(void)
 	oz_protocol_term();
 	oz_apps_term();
 	oz_cdev_deregister();
-	oz_event_term();
-#ifdef CONFIG_DEBUG_FS
-	oz_debugfs_remove();
-#endif
 }
 /*------------------------------------------------------------------------------
  */
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index f8b9da0..d67dff2 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -15,7 +15,6 @@
 #include "ozpd.h"
 #include "ozproto.h"
 #include "oztrace.h"
-#include "ozevent.h"
 #include "ozcdev.h"
 #include "ozusbsvc.h"
 #include <asm/unaligned.h>
@@ -121,7 +120,6 @@ static void oz_def_app_rx(struct oz_pd *pd, struct oz_elt *elt)
 void oz_pd_set_state(struct oz_pd *pd, unsigned state)
 {
 	pd->state = state;
-	oz_event_log(OZ_EVT_PD_STATE, 0, 0, NULL, state);
 #ifdef WANT_TRACE
 	switch (state) {
 	case OZ_PD_S_IDLE:
@@ -544,7 +542,6 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 			if (dev_queue_xmit(skb) < 0) {
 				oz_trace2(OZ_TRACE_TX_FRAMES,
 						"Dropping ISOC Frame\n");
-				oz_event_log(OZ_EVT_TX_ISOC_DROP, 0, 0, NULL, 0);
 				return -1;
 			}
 			atomic_inc(&g_submitted_isoc);
@@ -555,7 +552,6 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 		} else {
 			kfree_skb(skb);
 			oz_trace2(OZ_TRACE_TX_FRAMES, "Dropping ISOC Frame>\n");
-			oz_event_log(OZ_EVT_TX_ISOC_DROP, 0, 0, NULL, 0);
 			return -1;
 		}
 	}
@@ -567,10 +563,6 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 		oz_set_more_bit(skb);
 	oz_trace2(OZ_TRACE_TX_FRAMES, "TX frame PN=0x%x\n", f->hdr.pkt_num);
 	if (skb) {
-		oz_event_log(OZ_EVT_TX_FRAME,
-			0,
-			(((u16)f->hdr.control)<<8)|f->hdr.last_pkt_num,
-			NULL, f->hdr.pkt_num);
 		if (dev_queue_xmit(skb) < 0)
 			return -1;
 
@@ -659,7 +651,6 @@ static int oz_send_isoc_frame(struct oz_pd *pd)
 		memcpy(elt, ei->data, ei->length);
 		elt = oz_next_elt(elt);
 	}
-	oz_event_log(OZ_EVT_TX_ISOC, 0, 0, NULL, 0);
 	dev_queue_xmit(skb);
 	oz_elt_info_free_chain(&pd->elt_buff, &list);
 	return 0;
@@ -768,8 +759,6 @@ int oz_isoc_stream_delete(struct oz_pd *pd, u8 ep_num)
 static void oz_isoc_destructor(struct sk_buff *skb)
 {
 	atomic_dec(&g_submitted_isoc);
-	oz_event_log(OZ_EVT_TX_ISOC_DONE, atomic_read(&g_submitted_isoc),
-		0, skb, 0);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq
@@ -863,25 +852,19 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 			oz_trace2(OZ_TRACE_TX_FRAMES,
 			"Added ISOC Frame to Tx Queue isoc_nb= %d, nb= %d\n",
 			pd->nb_queued_isoc_frames, pd->nb_queued_frames);
-			oz_event_log(OZ_EVT_TX_ISOC, nb_units, iso.frame_number,
-					skb, atomic_read(&g_submitted_isoc));
 			return 0;
 		}
 
 		/*In ANYTIME mode Xmit unit immediately*/
 		if (atomic_read(&g_submitted_isoc) < OZ_MAX_SUBMITTED_ISOC) {
 			atomic_inc(&g_submitted_isoc);
-			oz_event_log(OZ_EVT_TX_ISOC, nb_units, iso.frame_number,
-					skb, atomic_read(&g_submitted_isoc));
-			if (dev_queue_xmit(skb) < 0) {
-				oz_event_log(OZ_EVT_TX_ISOC_DROP, 0, 0, NULL, 0);
+			if (dev_queue_xmit(skb) < 0)
 				return -1;
-			} else
+			else
 				return 0;
 		}
 
-out:	oz_event_log(OZ_EVT_TX_ISOC_DROP, 0, 0, NULL, 0);
-	kfree_skb(skb);
+out:	kfree_skb(skb);
 	return -1;
 
 	}
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 3badf15..79ac7b5 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -18,7 +18,6 @@
 #include "ozusbsvc.h"
 #include "oztrace.h"
 #include "ozappif.h"
-#include "ozevent.h"
 #include <asm/unaligned.h>
 #include <linux/uaccess.h>
 #include <net/psnap.h>
@@ -116,7 +115,6 @@ static void oz_send_conn_rsp(struct oz_pd *pd, u8 status)
 	oz_hdr->control = (OZ_PROTOCOL_VERSION<<OZ_VERSION_SHIFT);
 	oz_hdr->last_pkt_num = 0;
 	put_unaligned(0, &oz_hdr->pkt_num);
-	oz_event_log(OZ_EVT_CONNECT_RSP, 0, 0, NULL, 0);
 	elt->type = OZ_ELT_CONNECT_RSP;
 	elt->length = sizeof(struct oz_elt_connect_rsp);
 	memset(body, 0, sizeof(struct oz_elt_connect_rsp));
@@ -345,9 +343,6 @@ static void oz_rx_frame(struct sk_buff *skb)
 	int dup = 0;
 	u32 pkt_num;
 
-	oz_event_log(OZ_EVT_RX_PROCESS, 0,
-		(((u16)oz_hdr->control)<<8)|oz_hdr->last_pkt_num,
-		NULL, oz_hdr->pkt_num);
 	oz_trace2(OZ_TRACE_RX_FRAMES,
 		"RX frame PN=0x%x LPN=0x%x control=0x%x\n",
 		oz_hdr->pkt_num, oz_hdr->last_pkt_num, oz_hdr->control);
@@ -402,7 +397,6 @@ static void oz_rx_frame(struct sk_buff *skb)
 			break;
 		switch (elt->type) {
 		case OZ_ELT_CONNECT_REQ:
-			oz_event_log(OZ_EVT_CONNECT_REQ, 0, 0, NULL, 0);
 			oz_trace("RX: OZ_ELT_CONNECT_REQ\n");
 			pd = oz_connect_req(pd, elt, src_addr, skb->dev);
 			break;
@@ -534,7 +528,6 @@ static void oz_protocol_timer(unsigned long arg)
 		/* This happens if we remove the current timer but can't stop
 		 * the timer from firing. In this case just get out.
 		 */
-		oz_event_log(OZ_EVT_TIMER, 0, 0, NULL, 0);
 		spin_unlock_bh(&g_polling_lock);
 		return;
 	}
@@ -545,7 +538,6 @@ static void oz_protocol_timer(unsigned long arg)
 	spin_unlock_bh(&g_polling_lock);
 	do {
 		pd = t->pd;
-		oz_event_log(OZ_EVT_TIMER, 0, t->type, NULL, 0);
 		oz_pd_handle_timer(pd, t->type);
 		spin_lock_bh(&g_polling_lock);
 		if (g_timer_pool_count < OZ_MAX_TIMER_POOL_SIZE) {
@@ -582,14 +574,8 @@ static void oz_protocol_timer_start(void)
 		g_cur_timer =
 			container_of(g_timer_list.next, struct oz_timer, link);
 		if (g_timer_state == OZ_TIMER_SET) {
-			oz_event_log(OZ_EVT_TIMER_CTRL, 3,
-				(u16)g_cur_timer->type, NULL,
-				(unsigned)g_cur_timer->due_time);
 			mod_timer(&g_timer, g_cur_timer->due_time);
 		} else {
-			oz_event_log(OZ_EVT_TIMER_CTRL, 4,
-				(u16)g_cur_timer->type, NULL,
-				(unsigned)g_cur_timer->due_time);
 			g_timer.expires = g_cur_timer->due_time;
 			g_timer.function = oz_protocol_timer;
 			g_timer.data = 0;
@@ -610,7 +596,6 @@ void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time,
 	struct list_head *e;
 	struct oz_timer *t = NULL;
 	int restart_needed = 0;
-	oz_event_log(OZ_EVT_TIMER_CTRL, 1, (u16)type, NULL, (unsigned)due_time);
 	spin_lock(&g_polling_lock);
 	if (remove) {
 		list_for_each(e, &g_timer_list) {
@@ -673,7 +658,6 @@ void oz_timer_delete(struct oz_pd *pd, int type)
 	struct oz_timer *n;
 	int restart_needed = 0;
 	int release = 0;
-	oz_event_log(OZ_EVT_TIMER_CTRL, 2, (u16)type, NULL, 0);
 	spin_lock(&g_polling_lock);
 	list_for_each_entry_safe(t, n, &g_timer_list, link) {
 		if ((t->pd == pd) && ((type == 0) || (t->type == type))) {
@@ -770,7 +754,6 @@ void oz_app_enable(int app_id, int enable)
 static int oz_pkt_recv(struct sk_buff *skb, struct net_device *dev,
 		struct packet_type *pt, struct net_device *orig_dev)
 {
-	oz_event_log(OZ_EVT_RX_FRAME, 0, 0, NULL, 0);
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (skb == NULL)
 		return 0;
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index 543a941..1676328 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -27,14 +27,12 @@
 #include "ozhcd.h"
 #include "oztrace.h"
 #include "ozusbsvc.h"
-#include "ozevent.h"
 /*------------------------------------------------------------------------------
  * This is called once when the driver is loaded to initialise the USB service.
  * Context: process
  */
 int oz_usb_init(void)
 {
-	oz_event_log(OZ_EVT_SERVICE, 1, OZ_APPID_USB, NULL, 0);
 	return oz_hcd_init();
 }
 /*------------------------------------------------------------------------------
@@ -43,7 +41,6 @@ int oz_usb_init(void)
  */
 void oz_usb_term(void)
 {
-	oz_event_log(OZ_EVT_SERVICE, 2, OZ_APPID_USB, NULL, 0);
 	oz_hcd_term();
 }
 /*------------------------------------------------------------------------------
@@ -55,7 +52,6 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 	int rc = 0;
 	struct oz_usb_ctx *usb_ctx;
 	struct oz_usb_ctx *old_ctx;
-	oz_event_log(OZ_EVT_SERVICE, 3, OZ_APPID_USB, NULL, resume);
 	if (resume) {
 		oz_trace("USB service resumed.\n");
 		return 0;
@@ -117,7 +113,6 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 void oz_usb_stop(struct oz_pd *pd, int pause)
 {
 	struct oz_usb_ctx *usb_ctx;
-	oz_event_log(OZ_EVT_SERVICE, 4, OZ_APPID_USB, NULL, pause);
 	if (pause) {
 		oz_trace("USB service paused.\n");
 		return;
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index 4e4b650..16e6078 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -22,7 +22,6 @@
 #include "ozhcd.h"
 #include "oztrace.h"
 #include "ozusbsvc.h"
-#include "ozevent.h"
 /*------------------------------------------------------------------------------
  */
 #define MAX_ISOC_FIXED_DATA	(253-sizeof(struct oz_isoc_fixed))
@@ -190,10 +189,6 @@ int oz_usb_control_req(void *hpd, u8 req_id, struct usb_ctrlrequest *setup,
 	unsigned windex = le16_to_cpu(setup->wIndex);
 	unsigned wlength = le16_to_cpu(setup->wLength);
 	int rc = 0;
-	oz_event_log(OZ_EVT_CTRL_REQ, setup->bRequest, req_id,
-		(void *)(((unsigned long)(setup->wValue))<<16 |
-			((unsigned long)setup->wIndex)),
-		setup->bRequestType);
 	if ((setup->bRequestType & USB_TYPE_MASK) == USB_TYPE_STANDARD) {
 		switch (setup->bRequest) {
 		case USB_REQ_GET_DESCRIPTOR:
-- 
1.7.9.5

