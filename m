Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab3GDMf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:35:58 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51918 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab3GDMfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:35:53 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <joe@perches.com>, <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH v2 2/5] staging: ozwpan: Replace oz_trace with oz_dbg
Date: Thu, 4 Jul 2013 13:35:28 +0100
Message-ID: <1372941331-9586-3-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372255013.2076.4.camel@joe-AO722>
References: <1372255013.2076.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozcdev.c        |   48 +++---
 drivers/staging/ozwpan/ozdbg.h         |   54 +++++++
 drivers/staging/ozwpan/ozeltbuf.c      |   30 ++--
 drivers/staging/ozwpan/ozhcd.c         |  261 ++++++++++++++++----------------
 drivers/staging/ozwpan/ozpd.c          |   61 ++++----
 drivers/staging/ozwpan/ozproto.c       |   56 +++----
 drivers/staging/ozwpan/ozproto.h       |    2 +-
 drivers/staging/ozwpan/ozurbparanoia.c |    9 +-
 drivers/staging/ozwpan/ozusbsvc.c      |   21 +--
 drivers/staging/ozwpan/ozusbsvc1.c     |   17 ++-
 10 files changed, 307 insertions(+), 252 deletions(-)
 create mode 100644 drivers/staging/ozwpan/ozdbg.h

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 284c26d..87c3131 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -12,6 +12,7 @@
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include "ozconfig.h"
+#include "ozdbg.h"
 #include "ozprotocol.h"
 #include "oztrace.h"
 #include "ozappif.h"
@@ -63,7 +64,7 @@ static struct oz_serial_ctx *oz_cdev_claim_ctx(struct oz_pd *pd)
 static void oz_cdev_release_ctx(struct oz_serial_ctx *ctx)
 {
 	if (atomic_dec_and_test(&ctx->ref_count)) {
-		oz_trace("Dealloc serial context.\n");
+		oz_dbg(ON, "Dealloc serial context\n");
 		kfree(ctx);
 	}
 }
@@ -72,9 +73,10 @@ static void oz_cdev_release_ctx(struct oz_serial_ctx *ctx)
  */
 static int oz_cdev_open(struct inode *inode, struct file *filp)
 {
-	struct oz_cdev *dev;
-	oz_trace("major = %d minor = %d\n", imajor(inode), iminor(inode));
-	dev = container_of(inode->i_cdev, struct oz_cdev, cdev);
+	struct oz_cdev *dev = container_of(inode->i_cdev, struct oz_cdev, cdev);
+
+	oz_dbg(ON, "major = %d minor = %d\n", imajor(inode), iminor(inode));
+
 	filp->private_data = dev;
 	return 0;
 }
@@ -249,7 +251,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 	switch (cmd) {
 	case OZ_IOCTL_GET_PD_LIST: {
 			struct oz_pd_list list;
-			oz_trace("OZ_IOCTL_GET_PD_LIST\n");
+			oz_dbg(ON, "OZ_IOCTL_GET_PD_LIST\n");
 			memset(&list, 0, sizeof(list));
 			list.count = oz_get_pd_list(list.addr, OZ_MAX_PDS);
 			if (copy_to_user((void __user *)arg, &list,
@@ -259,7 +261,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 		break;
 	case OZ_IOCTL_SET_ACTIVE_PD: {
 			u8 addr[ETH_ALEN];
-			oz_trace("OZ_IOCTL_SET_ACTIVE_PD\n");
+			oz_dbg(ON, "OZ_IOCTL_SET_ACTIVE_PD\n");
 			if (copy_from_user(addr, (void __user *)arg, ETH_ALEN))
 				return -EFAULT;
 			rc = oz_set_active_pd(addr);
@@ -267,7 +269,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 		break;
 	case OZ_IOCTL_GET_ACTIVE_PD: {
 			u8 addr[ETH_ALEN];
-			oz_trace("OZ_IOCTL_GET_ACTIVE_PD\n");
+			oz_dbg(ON, "OZ_IOCTL_GET_ACTIVE_PD\n");
 			spin_lock_bh(&g_cdev.lock);
 			memcpy(addr, g_cdev.active_addr, ETH_ALEN);
 			spin_unlock_bh(&g_cdev.lock);
@@ -300,7 +302,7 @@ static unsigned int oz_cdev_poll(struct file *filp, poll_table *wait)
 {
 	unsigned int ret = 0;
 	struct oz_cdev *dev = filp->private_data;
-	oz_trace("Poll called wait = %p\n", wait);
+	oz_dbg(ON, "Poll called wait = %p\n", wait);
 	spin_lock_bh(&dev->lock);
 	if (dev->active_pd) {
 		struct oz_serial_ctx *ctx = oz_cdev_claim_ctx(dev->active_pd);
@@ -337,8 +339,8 @@ int oz_cdev_register(void)
 	err = alloc_chrdev_region(&g_cdev.devnum, 0, 1, "ozwpan");
 	if (err < 0)
 		goto out3;
-	oz_trace("Alloc dev number %d:%d\n", MAJOR(g_cdev.devnum),
-			MINOR(g_cdev.devnum));
+	oz_dbg(ON, "Alloc dev number %d:%d\n",
+	       MAJOR(g_cdev.devnum), MINOR(g_cdev.devnum));
 	cdev_init(&g_cdev.cdev, &oz_fops);
 	g_cdev.cdev.owner = THIS_MODULE;
 	g_cdev.cdev.ops = &oz_fops;
@@ -346,18 +348,18 @@ int oz_cdev_register(void)
 	init_waitqueue_head(&g_cdev.rdq);
 	err = cdev_add(&g_cdev.cdev, g_cdev.devnum, 1);
 	if (err < 0) {
-		oz_trace("Failed to add cdev\n");
+		oz_dbg(ON, "Failed to add cdev\n");
 		goto out2;
 	}
 	g_oz_class = class_create(THIS_MODULE, "ozmo_wpan");
 	if (IS_ERR(g_oz_class)) {
-		oz_trace("Failed to register ozmo_wpan class\n");
+		oz_dbg(ON, "Failed to register ozmo_wpan class\n");
 		err = PTR_ERR(g_oz_class);
 		goto out1;
 	}
 	dev = device_create(g_oz_class, NULL, g_cdev.devnum, NULL, "ozwpan");
 	if (IS_ERR(dev)) {
-		oz_trace("Failed to create sysfs entry for cdev\n");
+		oz_dbg(ON, "Failed to create sysfs entry for cdev\n");
 		err = PTR_ERR(dev);
 		goto out1;
 	}
@@ -405,7 +407,7 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
 	struct oz_serial_ctx *ctx;
 	struct oz_serial_ctx *old_ctx;
 	if (resume) {
-		oz_trace("Serial service resumed.\n");
+		oz_dbg(ON, "Serial service resumed\n");
 		return 0;
 	}
 	ctx = kzalloc(sizeof(struct oz_serial_ctx), GFP_ATOMIC);
@@ -427,10 +429,10 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
 		(memcmp(pd->mac_addr, g_cdev.active_addr, ETH_ALEN) == 0)) {
 		oz_pd_get(pd);
 		g_cdev.active_pd = pd;
-		oz_trace("Active PD arrived.\n");
+		oz_dbg(ON, "Active PD arrived\n");
 	}
 	spin_unlock(&g_cdev.lock);
-	oz_trace("Serial service started.\n");
+	oz_dbg(ON, "Serial service started\n");
 	return 0;
 }
 /*------------------------------------------------------------------------------
@@ -440,7 +442,7 @@ void oz_cdev_stop(struct oz_pd *pd, int pause)
 {
 	struct oz_serial_ctx *ctx;
 	if (pause) {
-		oz_trace("Serial service paused.\n");
+		oz_dbg(ON, "Serial service paused\n");
 		return;
 	}
 	spin_lock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
@@ -457,9 +459,9 @@ void oz_cdev_stop(struct oz_pd *pd, int pause)
 	spin_unlock(&g_cdev.lock);
 	if (pd) {
 		oz_pd_put(pd);
-		oz_trace("Active PD departed.\n");
+		oz_dbg(ON, "Active PD departed\n");
 	}
-	oz_trace("Serial service stopped.\n");
+	oz_dbg(ON, "Serial service stopped\n");
 }
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
@@ -476,7 +478,7 @@ void oz_cdev_rx(struct oz_pd *pd, struct oz_elt *elt)
 
 	ctx = oz_cdev_claim_ctx(pd);
 	if (ctx == NULL) {
-		oz_trace("Cannot claim serial context.\n");
+		oz_dbg(ON, "Cannot claim serial context\n");
 		return;
 	}
 
@@ -486,8 +488,8 @@ void oz_cdev_rx(struct oz_pd *pd, struct oz_elt *elt)
 	if (app_hdr->elt_seq_num != 0) {
 		if (((ctx->rx_seq_num - app_hdr->elt_seq_num) & 0x80) == 0) {
 			/* Reject duplicate element. */
-			oz_trace("Duplicate element:%02x %02x\n",
-				app_hdr->elt_seq_num, ctx->rx_seq_num);
+			oz_dbg(ON, "Duplicate element:%02x %02x\n",
+			       app_hdr->elt_seq_num, ctx->rx_seq_num);
 			goto out;
 		}
 	}
@@ -500,7 +502,7 @@ void oz_cdev_rx(struct oz_pd *pd, struct oz_elt *elt)
 	if (space < 0)
 		space += OZ_RD_BUF_SZ;
 	if (len > space) {
-		oz_trace("Not enough space:%d %d\n", len, space);
+		oz_dbg(ON, "Not enough space:%d %d\n", len, space);
 		len = space;
 	}
 	ix = ctx->rd_in;
diff --git a/drivers/staging/ozwpan/ozdbg.h b/drivers/staging/ozwpan/ozdbg.h
new file mode 100644
index 0000000..b86a2b7
--- /dev/null
+++ b/drivers/staging/ozwpan/ozdbg.h
@@ -0,0 +1,54 @@
+/* -----------------------------------------------------------------------------
+ * Copyright (c) 2011 Ozmo Inc
+ * Released under the GNU General Public License Version 2 (GPLv2).
+ * ---------------------------------------------------------------------------*/
+
+#ifndef _OZDBG_H
+#define _OZDBG_H
+
+#define OZ_WANT_DBG 0
+#define OZ_WANT_VERBOSE_DBG 1
+
+#define OZ_DBG_ON		0x0
+#define OZ_DBG_STREAM		0x1
+#define OZ_DBG_URB		0x2
+#define OZ_DBG_CTRL_DETAIL	0x4
+#define OZ_DBG_HUB		0x8
+#define OZ_DBG_RX_FRAMES	0x10
+#define OZ_DBG_TX_FRAMES	0x20
+
+#define OZ_DEFAULT_DBG_MASK			\
+	(					\
+	/* OZ_DBG_STREAM | */			\
+	/* OZ_DBG_URB | */			\
+	/* OZ_DBG_CTRL_DETAIL | */		\
+	OZ_DBG_HUB |				\
+	/* OZ_DBG_RX_FRAMES | */		\
+	/* OZ_DBG_TX_FRAMES | */		\
+	0)
+
+extern unsigned int oz_dbg_mask;
+
+#define oz_want_dbg(mask)						\
+	((OZ_WANT_DBG && (OZ_DBG_##mask == OZ_DBG_ON)) ||		\
+	 (OZ_WANT_VERBOSE_DBG && (OZ_DBG_##mask & oz_dbg_mask)))
+
+#define oz_dbg(mask, fmt, ...)						\
+do {									\
+	if (oz_want_dbg(mask))						\
+		pr_debug(fmt, ##__VA_ARGS__);				\
+} while (0)
+
+#define oz_cdev_dbg(cdev, mask, fmt, ...)				\
+do {									\
+	if (oz_want_dbg(mask))						\
+		netdev_dbg((cdev)->dev, fmt, ##__VA_ARGS__);		\
+} while (0)
+
+#define oz_pd_dbg(pd, mask, fmt, ...)					\
+do {									\
+	if (oz_want_dbg(mask))						\
+		pr_debug(fmt, ##__VA_ARGS__);				\
+} while (0)
+
+#endif /* _OZDBG_H */
diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index ac90fc7..bf280aa 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -7,10 +7,12 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include "ozconfig.h"
+#include "ozdbg.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
 #include "ozpd.h"
 #include "oztrace.h"
+
 /*------------------------------------------------------------------------------
  */
 #define OZ_ELT_INFO_MAGIC_USED	0x35791057
@@ -72,8 +74,8 @@ struct oz_elt_info *oz_elt_info_alloc(struct oz_elt_buf *buf)
 		buf->free_elts--;
 		spin_unlock_bh(&buf->lock);
 		if (ei->magic != OZ_ELT_INFO_MAGIC_FREE) {
-			oz_trace("oz_elt_info_alloc: ei with bad magic: 0x%x\n",
-				ei->magic);
+			oz_dbg(ON, "%s: ei with bad magic: 0x%x\n",
+			       __func__, ei->magic);
 		}
 	} else {
 		spin_unlock_bh(&buf->lock);
@@ -104,9 +106,8 @@ void oz_elt_info_free(struct oz_elt_buf *buf, struct oz_elt_info *ei)
 			buf->elt_pool = &ei->link;
 			ei->magic = OZ_ELT_INFO_MAGIC_FREE;
 		} else {
-			oz_trace("oz_elt_info_free: bad magic ei: %p"
-				" magic: 0x%x\n",
-				ei, ei->magic);
+			oz_dbg(ON, "%s: bad magic ei: %p magic: 0x%x\n",
+			       __func__, ei, ei->magic);
 		}
 	}
 }
@@ -132,7 +133,7 @@ int oz_elt_stream_create(struct oz_elt_buf *buf, u8 id, int max_buf_count)
 {
 	struct oz_elt_stream *st;
 
-	oz_trace("oz_elt_stream_create(0x%x)\n", id);
+	oz_dbg(ON, "%s: (0x%x)\n", __func__, id);
 
 	st = kzalloc(sizeof(struct oz_elt_stream), GFP_ATOMIC | __GFP_ZERO);
 	if (st == NULL)
@@ -152,7 +153,7 @@ int oz_elt_stream_delete(struct oz_elt_buf *buf, u8 id)
 {
 	struct list_head *e;
 	struct oz_elt_stream *st = NULL;
-	oz_trace("oz_elt_stream_delete(0x%x)\n", id);
+	oz_dbg(ON, "%s: (0x%x)\n", __func__, id);
 	spin_lock_bh(&buf->lock);
 	e = buf->stream_list.next;
 	while (e != &buf->stream_list) {
@@ -175,9 +176,8 @@ int oz_elt_stream_delete(struct oz_elt_buf *buf, u8 id)
 		list_del_init(&ei->link);
 		list_del_init(&ei->link_order);
 		st->buf_count -= ei->length;
-		oz_trace2(OZ_TRACE_STREAM, "Stream down: %d  %d %d\n",
-			st->buf_count,
-			ei->length, atomic_read(&st->ref_count));
+		oz_dbg(STREAM, "Stream down: %d %d %d\n",
+		       st->buf_count, ei->length, atomic_read(&st->ref_count));
 		oz_elt_stream_put(st);
 		oz_elt_info_free(buf, ei);
 	}
@@ -196,7 +196,7 @@ void oz_elt_stream_get(struct oz_elt_stream *st)
 void oz_elt_stream_put(struct oz_elt_stream *st)
 {
 	if (atomic_dec_and_test(&st->ref_count)) {
-		oz_trace("Stream destroyed\n");
+		oz_dbg(ON, "Stream destroyed\n");
 		kfree(st);
 	}
 }
@@ -242,8 +242,7 @@ int oz_queue_elt_info(struct oz_elt_buf *buf, u8 isoc, u8 id,
 		st->buf_count += ei->length;
 		/* Add to list in stream. */
 		list_add_tail(&ei->link, &st->elt_list);
-		oz_trace2(OZ_TRACE_STREAM, "Stream up: %d  %d\n",
-			st->buf_count, ei->length);
+		oz_dbg(STREAM, "Stream up: %d %d\n", st->buf_count, ei->length);
 		/* Check if we have too much buffered for this stream. If so
 		 * start dropping elements until we are back in bounds.
 		 */
@@ -293,9 +292,8 @@ int oz_select_elts_for_tx(struct oz_elt_buf *buf, u8 isoc, unsigned *len,
 			list_del(&ei->link_order);
 			if (ei->stream) {
 				ei->stream->buf_count -= ei->length;
-				oz_trace2(OZ_TRACE_STREAM,
-					"Stream down: %d  %d\n",
-					ei->stream->buf_count, ei->length);
+				oz_dbg(STREAM, "Stream down: %d %d\n",
+				       ei->stream->buf_count, ei->length);
 				oz_elt_stream_put(ei->stream);
 				ei->stream = NULL;
 			}
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 9d1bd44..fece2da 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -31,6 +31,7 @@
 #include <linux/export.h>
 #include "linux/usb/hcd.h"
 #include <asm/unaligned.h>
+#include "ozdbg.h"
 #include "ozconfig.h"
 #include "ozusbif.h"
 #include "oztrace.h"
@@ -371,14 +372,13 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
 	 */
 	spin_unlock(&g_tasklet_lock);
 	if (oz_forget_urb(urb)) {
-		oz_trace("OZWPAN: ERROR Unknown URB %p\n", urb);
+		oz_dbg(ON, "ERROR Unknown URB %p\n", urb);
 	} else {
 		static unsigned long last_time;
 		atomic_dec(&g_pending_urbs);
-		oz_trace2(OZ_TRACE_URB,
-			"%lu: giveback_urb(%p,%x) %lu %lu pending:%d\n",
-			jiffies, urb, status, jiffies-submit_jiffies,
-			jiffies-last_time, atomic_read(&g_pending_urbs));
+		oz_dbg(URB, "%lu: giveback_urb(%p,%x) %lu %lu pending:%d\n",
+		       jiffies, urb, status, jiffies-submit_jiffies,
+		       jiffies-last_time, atomic_read(&g_pending_urbs));
 		last_time = jiffies;
 		usb_hcd_giveback_urb(hcd, urb, status);
 	}
@@ -408,7 +408,7 @@ static void oz_ep_free(struct oz_port *port, struct oz_endpoint *ep)
 		list_splice_tail(&list, &ozhcd->orphanage);
 		spin_unlock_bh(&ozhcd->hcd_lock);
 	}
-	oz_trace("Freeing endpoint memory\n");
+	oz_dbg(ON, "Freeing endpoint memory\n");
 	kfree(ep);
 }
 /*------------------------------------------------------------------------------
@@ -445,8 +445,8 @@ static void oz_complete_buffered_urb(struct oz_port *port,
 		ep->out_ix = 0;
 
 	ep->buffered_units--;
-	oz_trace("Trying to give back buffered frame of size=%d\n",
-						available_space);
+	oz_dbg(ON, "Trying to give back buffered frame of size=%d\n",
+	       available_space);
 	oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
 }
 
@@ -460,7 +460,7 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 	struct oz_endpoint *ep;
 	int err = 0;
 	if (ep_addr >= OZ_NB_ENDPOINTS) {
-		oz_trace("Invalid endpoint number in oz_enqueue_ep_urb().\n");
+		oz_dbg(ON, "%s: Invalid endpoint number\n", __func__);
 		return -EINVAL;
 	}
 	urbl = oz_alloc_urb_link();
@@ -479,7 +479,7 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 	 */
 	if (urb->unlinked) {
 		spin_unlock_bh(&port->ozhcd->hcd_lock);
-		oz_trace("urb %p unlinked so complete immediately\n", urb);
+		oz_dbg(ON, "urb %p unlinked so complete immediately\n", urb);
 		oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
 		oz_free_urb_link(urbl);
 		return 0;
@@ -640,7 +640,7 @@ void *oz_hcd_pd_arrived(void *hpd)
 	spin_lock_bh(&ozhcd->hcd_lock);
 	if (ozhcd->conn_port >= 0) {
 		spin_unlock_bh(&ozhcd->hcd_lock);
-		oz_trace("conn_port >= 0\n");
+		oz_dbg(ON, "conn_port >= 0\n");
 		goto out;
 	}
 	for (i = 0; i < OZ_NB_PORTS; i++) {
@@ -654,7 +654,7 @@ void *oz_hcd_pd_arrived(void *hpd)
 		spin_unlock(&port->port_lock);
 	}
 	if (i < OZ_NB_PORTS) {
-		oz_trace("Setting conn_port = %d\n", i);
+		oz_dbg(ON, "Setting conn_port = %d\n", i);
 		ozhcd->conn_port = i;
 		/* Attach out endpoint 0.
 		 */
@@ -663,7 +663,7 @@ void *oz_hcd_pd_arrived(void *hpd)
 		hport = &ozhcd->ports[i];
 		spin_unlock_bh(&ozhcd->hcd_lock);
 		if (ozhcd->flags & OZ_HDC_F_SUSPENDED) {
-			oz_trace("Resuming root hub\n");
+			oz_dbg(ON, "Resuming root hub\n");
 			usb_hcd_resume_root_hub(ozhcd->hcd);
 		}
 		usb_hcd_poll_rh_status(ozhcd->hcd);
@@ -690,7 +690,7 @@ void oz_hcd_pd_departed(void *hport)
 	struct oz_endpoint *ep = NULL;
 
 	if (port == NULL) {
-		oz_trace("oz_hcd_pd_departed() port = 0\n");
+		oz_dbg(ON, "%s: port = 0\n", __func__);
 		return;
 	}
 	ozhcd = port->ozhcd;
@@ -701,7 +701,7 @@ void oz_hcd_pd_departed(void *hport)
 	spin_lock_bh(&ozhcd->hcd_lock);
 	if ((ozhcd->conn_port >= 0) &&
 		(port == &ozhcd->ports[ozhcd->conn_port])) {
-		oz_trace("Clearing conn_port\n");
+		oz_dbg(ON, "Clearing conn_port\n");
 		ozhcd->conn_port = -1;
 	}
 	spin_lock(&port->port_lock);
@@ -740,7 +740,7 @@ void oz_hcd_pd_reset(void *hpd, void *hport)
 	 */
 	struct oz_port *port = (struct oz_port *)hport;
 	struct oz_hcd *ozhcd = port->ozhcd;
-	oz_trace("PD Reset\n");
+	oz_dbg(ON, "PD Reset\n");
 	spin_lock_bh(&port->port_lock);
 	port->flags |= OZ_PORT_F_CHANGED;
 	port->status |= USB_PORT_STAT_RESET;
@@ -759,8 +759,8 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 	struct urb *urb;
 	int err = 0;
 
-	oz_trace("oz_hcd_get_desc_cnf length = %d offs = %d tot_size = %d\n",
-			length, offset, total_size);
+	oz_dbg(ON, "oz_hcd_get_desc_cnf length = %d offs = %d tot_size = %d\n",
+	       length, offset, total_size);
 	urb = oz_find_urb_by_id(port, 0, req_id);
 	if (!urb)
 		return;
@@ -802,37 +802,37 @@ static void oz_display_conf_type(u8 t)
 {
 	switch (t) {
 	case USB_REQ_GET_STATUS:
-		oz_trace("USB_REQ_GET_STATUS - cnf\n");
+		oz_dbg(ON, "USB_REQ_GET_STATUS - cnf\n");
 		break;
 	case USB_REQ_CLEAR_FEATURE:
-		oz_trace("USB_REQ_CLEAR_FEATURE - cnf\n");
+		oz_dbg(ON, "USB_REQ_CLEAR_FEATURE - cnf\n");
 		break;
 	case USB_REQ_SET_FEATURE:
-		oz_trace("USB_REQ_SET_FEATURE - cnf\n");
+		oz_dbg(ON, "USB_REQ_SET_FEATURE - cnf\n");
 		break;
 	case USB_REQ_SET_ADDRESS:
-		oz_trace("USB_REQ_SET_ADDRESS - cnf\n");
+		oz_dbg(ON, "USB_REQ_SET_ADDRESS - cnf\n");
 		break;
 	case USB_REQ_GET_DESCRIPTOR:
-		oz_trace("USB_REQ_GET_DESCRIPTOR - cnf\n");
+		oz_dbg(ON, "USB_REQ_GET_DESCRIPTOR - cnf\n");
 		break;
 	case USB_REQ_SET_DESCRIPTOR:
-		oz_trace("USB_REQ_SET_DESCRIPTOR - cnf\n");
+		oz_dbg(ON, "USB_REQ_SET_DESCRIPTOR - cnf\n");
 		break;
 	case USB_REQ_GET_CONFIGURATION:
-		oz_trace("USB_REQ_GET_CONFIGURATION - cnf\n");
+		oz_dbg(ON, "USB_REQ_GET_CONFIGURATION - cnf\n");
 		break;
 	case USB_REQ_SET_CONFIGURATION:
-		oz_trace("USB_REQ_SET_CONFIGURATION - cnf\n");
+		oz_dbg(ON, "USB_REQ_SET_CONFIGURATION - cnf\n");
 		break;
 	case USB_REQ_GET_INTERFACE:
-		oz_trace("USB_REQ_GET_INTERFACE - cnf\n");
+		oz_dbg(ON, "USB_REQ_GET_INTERFACE - cnf\n");
 		break;
 	case USB_REQ_SET_INTERFACE:
-		oz_trace("USB_REQ_SET_INTERFACE - cnf\n");
+		oz_dbg(ON, "USB_REQ_SET_INTERFACE - cnf\n");
 		break;
 	case USB_REQ_SYNCH_FRAME:
-		oz_trace("USB_REQ_SYNCH_FRAME - cnf\n");
+		oz_dbg(ON, "USB_REQ_SYNCH_FRAME - cnf\n");
 		break;
 	}
 }
@@ -870,7 +870,7 @@ static void oz_hcd_complete_set_interface(struct oz_port *port, struct urb *urb,
 	if (rcode == 0) {
 		struct usb_host_config *config;
 		struct usb_host_interface *intf;
-		oz_trace("Set interface %d alt %d\n", if_num, alt);
+		oz_dbg(ON, "Set interface %d alt %d\n", if_num, alt);
 		oz_clean_endpoints_for_interface(hcd, port, if_num);
 		config = &urb->dev->config[port->config_num-1];
 		intf = &config->intf_cache[if_num]->altsetting[alt];
@@ -897,10 +897,10 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 	unsigned windex;
 	unsigned wvalue;
 
-	oz_trace("oz_hcd_control_cnf rcode=%u len=%d\n", rcode, data_len);
+	oz_dbg(ON, "oz_hcd_control_cnf rcode=%u len=%d\n", rcode, data_len);
 	urb = oz_find_urb_by_id(port, 0, req_id);
 	if (!urb) {
-		oz_trace("URB not found\n");
+		oz_dbg(ON, "URB not found\n");
 		return;
 	}
 	setup = (struct usb_ctrlrequest *)urb->setup_packet;
@@ -924,7 +924,7 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 
 	} else {
 		int copy_len;
-		oz_trace("VENDOR-CLASS - cnf\n");
+		oz_dbg(ON, "VENDOR-CLASS - cnf\n");
 		if (data_len) {
 			if (data_len <= urb->transfer_buffer_length)
 				copy_len = data_len;
@@ -950,7 +950,7 @@ static int oz_hcd_buffer_data(struct oz_endpoint *ep, const u8 *data,
 	if (space < 0)
 		space += ep->buffer_size;
 	if (space < (data_len+1)) {
-		oz_trace("Buffer full\n");
+		oz_dbg(ON, "Buffer full\n");
 		return -1;
 	}
 	ep->buffer[ep->in_ix] = (u8)data_len;
@@ -1006,7 +1006,7 @@ void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
 			oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
 			return;
 		} else {
-			oz_trace("buffering frame as URB is not available\n");
+			oz_dbg(ON, "buffering frame as URB is not available\n");
 			oz_hcd_buffer_data(ep, data, data_len);
 		}
 		break;
@@ -1159,8 +1159,8 @@ int oz_hcd_heartbeat(void *hport)
 		list_for_each_safe(e, n, &ep->urb_list) {
 			urbl = container_of(e, struct oz_urb_link, link);
 			if (time_after(now, urbl->submit_jiffies+HZ/2)) {
-				oz_trace("%ld: Request 0x%p timeout\n",
-						now, urbl->urb);
+				oz_dbg(ON, "%ld: Request 0x%p timeout\n",
+				       now, urbl->urb);
 				urbl->submit_jiffies = now;
 				list_move_tail(e, &xfr_list);
 			}
@@ -1172,7 +1172,7 @@ int oz_hcd_heartbeat(void *hport)
 		while (e != &xfr_list) {
 			urbl = container_of(e, struct oz_urb_link, link);
 			e = e->next;
-			oz_trace("Resending request to PD.\n");
+			oz_dbg(ON, "Resending request to PD\n");
 			oz_process_ep0_urb(ozhcd, urbl->urb, GFP_ATOMIC);
 			oz_free_urb_link(urbl);
 		}
@@ -1190,7 +1190,7 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 	int i;
 	int if_ix = intf->desc.bInterfaceNumber;
 	int request_heartbeat = 0;
-	oz_trace("interface[%d] = %p\n", if_ix, intf);
+	oz_dbg(ON, "interface[%d] = %p\n", if_ix, intf);
 	for (i = 0; i < intf->desc.bNumEndpoints; i++) {
 		struct usb_host_endpoint *hep = &intf->endpoint[i];
 		u8 ep_addr = hep->desc.bEndpointAddress;
@@ -1198,7 +1198,7 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 		struct oz_endpoint *ep;
 		int buffer_size = 0;
 
-		oz_trace("%d bEndpointAddress = %x\n", i, ep_addr);
+		oz_dbg(ON, "%d bEndpointAddress = %x\n", i, ep_addr);
 		if (ep_addr & USB_ENDPOINT_DIR_MASK) {
 			switch (hep->desc.bmAttributes &
 						USB_ENDPOINT_XFERTYPE_MASK) {
@@ -1220,8 +1220,8 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 		ep->ep_num = ep_num;
 		if ((ep->attrib & USB_ENDPOINT_XFERTYPE_MASK)
 			== USB_ENDPOINT_XFER_ISOC) {
-			oz_trace("wMaxPacketSize = %d\n",
-				usb_endpoint_maxp(&hep->desc));
+			oz_dbg(ON, "wMaxPacketSize = %d\n",
+			       usb_endpoint_maxp(&hep->desc));
 			ep->credit_ceiling = 200;
 			if (ep_addr & USB_ENDPOINT_DIR_MASK) {
 				ep->flags |= OZ_F_EP_BUFFERING;
@@ -1267,7 +1267,7 @@ static void oz_clean_endpoints_for_interface(struct usb_hcd *hcd,
 	int i;
 	struct list_head ep_list;
 
-	oz_trace("Deleting endpoints for interface %d\n", if_ix);
+	oz_dbg(ON, "Deleting endpoints for interface %d\n", if_ix);
 	if (if_ix >= port->num_iface)
 		return;
 	INIT_LIST_HEAD(&ep_list);
@@ -1343,12 +1343,12 @@ static void oz_clean_endpoints_for_config(struct usb_hcd *hcd,
 {
 	struct oz_hcd *ozhcd = port->ozhcd;
 	int i;
-	oz_trace("Deleting endpoints for configuration.\n");
+	oz_dbg(ON, "Deleting endpoints for configuration\n");
 	for (i = 0; i < port->num_iface; i++)
 		oz_clean_endpoints_for_interface(hcd, port, i);
 	spin_lock_bh(&ozhcd->hcd_lock);
 	if (port->iface) {
-		oz_trace("Freeing interfaces object.\n");
+		oz_dbg(ON, "Freeing interfaces object\n");
 		kfree(port->iface);
 		port->iface = NULL;
 	}
@@ -1387,7 +1387,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 	int port_ix = -1;
 	struct oz_port *port = NULL;
 
-	oz_trace2(OZ_TRACE_URB, "%lu: oz_process_ep0_urb(%p)\n", jiffies, urb);
+	oz_dbg(URB, "%lu: %s: (%p)\n", jiffies, __func__, urb);
 	port_ix = oz_get_port_from_addr(ozhcd, urb->dev->devnum);
 	if (port_ix < 0) {
 		rc = -EPIPE;
@@ -1396,8 +1396,8 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 	port =  &ozhcd->ports[port_ix];
 	if (((port->flags & OZ_PORT_F_PRESENT) == 0)
 		|| (port->flags & OZ_PORT_F_DYING)) {
-		oz_trace("Refusing URB port_ix = %d devnum = %d\n",
-			port_ix, urb->dev->devnum);
+		oz_dbg(ON, "Refusing URB port_ix = %d devnum = %d\n",
+		       port_ix, urb->dev->devnum);
 		rc = -EPIPE;
 		goto out;
 	}
@@ -1408,17 +1408,16 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 	windex = le16_to_cpu(setup->wIndex);
 	wvalue = le16_to_cpu(setup->wValue);
 	wlength = le16_to_cpu(setup->wLength);
-	oz_trace2(OZ_TRACE_CTRL_DETAIL, "bRequestType = %x\n",
-		setup->bRequestType);
-	oz_trace2(OZ_TRACE_CTRL_DETAIL, "bRequest = %x\n", setup->bRequest);
-	oz_trace2(OZ_TRACE_CTRL_DETAIL, "wValue = %x\n", wvalue);
-	oz_trace2(OZ_TRACE_CTRL_DETAIL, "wIndex = %x\n", windex);
-	oz_trace2(OZ_TRACE_CTRL_DETAIL, "wLength = %x\n", wlength);
+	oz_dbg(CTRL_DETAIL, "bRequestType = %x\n", setup->bRequestType);
+	oz_dbg(CTRL_DETAIL, "bRequest = %x\n", setup->bRequest);
+	oz_dbg(CTRL_DETAIL, "wValue = %x\n", wvalue);
+	oz_dbg(CTRL_DETAIL, "wIndex = %x\n", windex);
+	oz_dbg(CTRL_DETAIL, "wLength = %x\n", wlength);
 
 	req_id = port->next_req_id++;
 	hpd = oz_claim_hpd(port);
 	if (hpd == NULL) {
-		oz_trace("Cannot claim port\n");
+		oz_dbg(ON, "Cannot claim port\n");
 		rc = -EPIPE;
 		goto out;
 	}
@@ -1428,30 +1427,31 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 		 */
 		switch (setup->bRequest) {
 		case USB_REQ_GET_DESCRIPTOR:
-			oz_trace("USB_REQ_GET_DESCRIPTOR - req\n");
+			oz_dbg(ON, "USB_REQ_GET_DESCRIPTOR - req\n");
 			break;
 		case USB_REQ_SET_ADDRESS:
-			oz_trace("USB_REQ_SET_ADDRESS - req\n");
-			oz_trace("Port %d address is 0x%x\n", ozhcd->conn_port,
-				(u8)le16_to_cpu(setup->wValue));
+			oz_dbg(ON, "USB_REQ_SET_ADDRESS - req\n");
+			oz_dbg(ON, "Port %d address is 0x%x\n",
+			       ozhcd->conn_port,
+			       (u8)le16_to_cpu(setup->wValue));
 			spin_lock_bh(&ozhcd->hcd_lock);
 			if (ozhcd->conn_port >= 0) {
 				ozhcd->ports[ozhcd->conn_port].bus_addr =
 					(u8)le16_to_cpu(setup->wValue);
-				oz_trace("Clearing conn_port\n");
+				oz_dbg(ON, "Clearing conn_port\n");
 				ozhcd->conn_port = -1;
 			}
 			spin_unlock_bh(&ozhcd->hcd_lock);
 			complete = 1;
 			break;
 		case USB_REQ_SET_CONFIGURATION:
-			oz_trace("USB_REQ_SET_CONFIGURATION - req\n");
+			oz_dbg(ON, "USB_REQ_SET_CONFIGURATION - req\n");
 			break;
 		case USB_REQ_GET_CONFIGURATION:
 			/* We short circuit this case and reply directly since
 			 * we have the selected configuration number cached.
 			 */
-			oz_trace("USB_REQ_GET_CONFIGURATION - reply now\n");
+			oz_dbg(ON, "USB_REQ_GET_CONFIGURATION - reply now\n");
 			if (urb->transfer_buffer_length >= 1) {
 				urb->actual_length = 1;
 				*((u8 *)urb->transfer_buffer) =
@@ -1465,20 +1465,20 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 			/* We short circuit this case and reply directly since
 			 * we have the selected interface alternative cached.
 			 */
-			oz_trace("USB_REQ_GET_INTERFACE - reply now\n");
+			oz_dbg(ON, "USB_REQ_GET_INTERFACE - reply now\n");
 			if (urb->transfer_buffer_length >= 1) {
 				urb->actual_length = 1;
 				*((u8 *)urb->transfer_buffer) =
 					port->iface[(u8)windex].alt;
-				oz_trace("interface = %d alt = %d\n",
-					windex, port->iface[(u8)windex].alt);
+				oz_dbg(ON, "interface = %d alt = %d\n",
+				       windex, port->iface[(u8)windex].alt);
 				complete = 1;
 			} else {
 				rc = -EPIPE;
 			}
 			break;
 		case USB_REQ_SET_INTERFACE:
-			oz_trace("USB_REQ_SET_INTERFACE - req\n");
+			oz_dbg(ON, "USB_REQ_SET_INTERFACE - req\n");
 			break;
 		}
 	}
@@ -1509,7 +1509,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 	oz_usb_put(hpd);
 out:
 	if (rc || complete) {
-		oz_trace("Completing request locally\n");
+		oz_dbg(ON, "Completing request locally\n");
 		oz_complete_urb(ozhcd->hcd, urb, rc, 0);
 	} else {
 		oz_usb_request_heartbeat(port->hpd);
@@ -1597,12 +1597,12 @@ static void oz_urb_cancel(struct oz_port *port, u8 ep_num, struct urb *urb)
 	unsigned long irq_state;
 	u8 ix;
 	if (port == NULL) {
-		oz_trace("ERRORERROR: oz_urb_cancel(%p) port is null\n", urb);
+		oz_dbg(ON, "%s: ERROR: (%p) port is null\n", __func__, urb);
 		return;
 	}
 	ozhcd = port->ozhcd;
 	if (ozhcd == NULL) {
-		oz_trace("ERRORERROR: oz_urb_cancel(%p) ozhcd is null\n", urb);
+		oz_dbg(ON, "%s; ERROR: (%p) ozhcd is null\n", __func__, urb);
 		return;
 	}
 
@@ -1627,7 +1627,7 @@ static void oz_urb_cancel(struct oz_port *port, u8 ep_num, struct urb *urb)
 		urbl = container_of(e, struct oz_urb_link, link);
 		if (urbl->urb == urb) {
 			list_del(e);
-			oz_trace("Found urb in orphanage\n");
+			oz_dbg(ON, "Found urb in orphanage\n");
 			goto out;
 		}
 	}
@@ -1725,16 +1725,14 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	struct oz_port *port;
 	unsigned long irq_state;
 	struct oz_urb_link *urbl;
-	oz_trace2(OZ_TRACE_URB, "%lu: oz_hcd_urb_enqueue(%p)\n",
-		jiffies, urb);
+	oz_dbg(URB, "%lu: %s: (%p)\n", jiffies, __func__, urb);
 	if (unlikely(ozhcd == NULL)) {
-		oz_trace2(OZ_TRACE_URB, "%lu: Refused urb(%p) not ozhcd.\n",
-			jiffies, urb);
+		oz_dbg(URB, "%lu: Refused urb(%p) not ozhcd\n", jiffies, urb);
 		return -EPIPE;
 	}
 	if (unlikely(hcd->state != HC_STATE_RUNNING)) {
-		oz_trace2(OZ_TRACE_URB, "%lu: Refused urb(%p) not running.\n",
-			jiffies, urb);
+		oz_dbg(URB, "%lu: Refused urb(%p) not running\n",
+		       jiffies, urb);
 		return -EPIPE;
 	}
 	port_ix = oz_get_port_from_addr(ozhcd, urb->dev->devnum);
@@ -1744,8 +1742,8 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	if (port == NULL)
 		return -EPIPE;
 	if ((port->flags & OZ_PORT_F_PRESENT) == 0) {
-		oz_trace("Refusing URB port_ix = %d devnum = %d\n",
-			port_ix, urb->dev->devnum);
+		oz_dbg(ON, "Refusing URB port_ix = %d devnum = %d\n",
+		       port_ix, urb->dev->devnum);
 		return -EPIPE;
 	}
 	urb->hcpriv = port;
@@ -1802,7 +1800,7 @@ static int oz_hcd_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	struct oz_urb_link *urbl = NULL;
 	int rc;
 	unsigned long irq_state;
-	oz_trace2(OZ_TRACE_URB, "%lu: oz_hcd_urb_dequeue(%p)\n", jiffies, urb);
+	oz_dbg(URB, "%lu: %s: (%p)\n", jiffies, __func__, urb);
 	urbl = oz_alloc_urb_link();
 	if (unlikely(urbl == NULL))
 		return -ENOMEM;
@@ -1851,7 +1849,7 @@ static void oz_hcd_endpoint_reset(struct usb_hcd *hcd,
  */
 static int oz_hcd_get_frame_number(struct usb_hcd *hcd)
 {
-	oz_trace("oz_hcd_get_frame_number\n");
+	oz_dbg(ON, "oz_hcd_get_frame_number\n");
 	return oz_usb_get_frame_number();
 }
 /*------------------------------------------------------------------------------
@@ -1869,7 +1867,7 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
 	spin_lock_bh(&ozhcd->hcd_lock);
 	for (i = 0; i < OZ_NB_PORTS; i++) {
 		if (ozhcd->ports[i].flags & OZ_PORT_F_CHANGED) {
-			oz_trace2(OZ_TRACE_HUB, "Port %d changed\n", i);
+			oz_dbg(HUB, "Port %d changed\n", i);
 			ozhcd->ports[i].flags &= ~OZ_PORT_F_CHANGED;
 			buf[0] |= 1<<(i+1);
 		}
@@ -1907,53 +1905,53 @@ static int oz_set_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 	port = &ozhcd->ports[port_id-1];
 	switch (wvalue) {
 	case USB_PORT_FEAT_CONNECTION:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_CONNECTION\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_CONNECTION\n");
 		break;
 	case USB_PORT_FEAT_ENABLE:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_ENABLE\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_ENABLE\n");
 		break;
 	case USB_PORT_FEAT_SUSPEND:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_SUSPEND\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_SUSPEND\n");
 		break;
 	case USB_PORT_FEAT_OVER_CURRENT:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_OVER_CURRENT\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_OVER_CURRENT\n");
 		break;
 	case USB_PORT_FEAT_RESET:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_RESET\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_RESET\n");
 		set_bits = USB_PORT_STAT_ENABLE | (USB_PORT_STAT_C_RESET<<16);
 		clear_bits = USB_PORT_STAT_RESET;
 		ozhcd->ports[port_id-1].bus_addr = 0;
 		break;
 	case USB_PORT_FEAT_POWER:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_POWER\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_POWER\n");
 		set_bits |= USB_PORT_STAT_POWER;
 		break;
 	case USB_PORT_FEAT_LOWSPEED:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_LOWSPEED\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_LOWSPEED\n");
 		break;
 	case USB_PORT_FEAT_C_CONNECTION:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_CONNECTION\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_CONNECTION\n");
 		break;
 	case USB_PORT_FEAT_C_ENABLE:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_ENABLE\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_ENABLE\n");
 		break;
 	case USB_PORT_FEAT_C_SUSPEND:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_SUSPEND\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_SUSPEND\n");
 		break;
 	case USB_PORT_FEAT_C_OVER_CURRENT:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_OVER_CURRENT\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_OVER_CURRENT\n");
 		break;
 	case USB_PORT_FEAT_C_RESET:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_RESET\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_RESET\n");
 		break;
 	case USB_PORT_FEAT_TEST:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_TEST\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_TEST\n");
 		break;
 	case USB_PORT_FEAT_INDICATOR:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_INDICATOR\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_INDICATOR\n");
 		break;
 	default:
-		oz_trace2(OZ_TRACE_HUB, "Other %d\n", wvalue);
+		oz_dbg(HUB, "Other %d\n", wvalue);
 		break;
 	}
 	if (set_bits || clear_bits) {
@@ -1962,8 +1960,7 @@ static int oz_set_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 		port->status |= set_bits;
 		spin_unlock_bh(&port->port_lock);
 	}
-	oz_trace2(OZ_TRACE_HUB, "Port[%d] status = 0x%x\n", port_id,
-		port->status);
+	oz_dbg(HUB, "Port[%d] status = 0x%x\n", port_id, port->status);
 	return err;
 }
 /*------------------------------------------------------------------------------
@@ -1982,54 +1979,54 @@ static int oz_clear_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 	port = &ozhcd->ports[port_id-1];
 	switch (wvalue) {
 	case USB_PORT_FEAT_CONNECTION:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_CONNECTION\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_CONNECTION\n");
 		break;
 	case USB_PORT_FEAT_ENABLE:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_ENABLE\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_ENABLE\n");
 		clear_bits = USB_PORT_STAT_ENABLE;
 		break;
 	case USB_PORT_FEAT_SUSPEND:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_SUSPEND\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_SUSPEND\n");
 		break;
 	case USB_PORT_FEAT_OVER_CURRENT:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_OVER_CURRENT\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_OVER_CURRENT\n");
 		break;
 	case USB_PORT_FEAT_RESET:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_RESET\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_RESET\n");
 		break;
 	case USB_PORT_FEAT_POWER:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_POWER\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_POWER\n");
 		clear_bits |= USB_PORT_STAT_POWER;
 		break;
 	case USB_PORT_FEAT_LOWSPEED:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_LOWSPEED\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_LOWSPEED\n");
 		break;
 	case USB_PORT_FEAT_C_CONNECTION:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_CONNECTION\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_CONNECTION\n");
 		clear_bits = (USB_PORT_STAT_C_CONNECTION << 16);
 		break;
 	case USB_PORT_FEAT_C_ENABLE:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_ENABLE\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_ENABLE\n");
 		clear_bits = (USB_PORT_STAT_C_ENABLE << 16);
 		break;
 	case USB_PORT_FEAT_C_SUSPEND:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_SUSPEND\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_SUSPEND\n");
 		break;
 	case USB_PORT_FEAT_C_OVER_CURRENT:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_OVER_CURRENT\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_OVER_CURRENT\n");
 		break;
 	case USB_PORT_FEAT_C_RESET:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_C_RESET\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_C_RESET\n");
 		clear_bits = (USB_PORT_FEAT_C_RESET << 16);
 		break;
 	case USB_PORT_FEAT_TEST:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_TEST\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_TEST\n");
 		break;
 	case USB_PORT_FEAT_INDICATOR:
-		oz_trace2(OZ_TRACE_HUB, "USB_PORT_FEAT_INDICATOR\n");
+		oz_dbg(HUB, "USB_PORT_FEAT_INDICATOR\n");
 		break;
 	default:
-		oz_trace2(OZ_TRACE_HUB, "Other %d\n", wvalue);
+		oz_dbg(HUB, "Other %d\n", wvalue);
 		break;
 	}
 	if (clear_bits) {
@@ -2037,8 +2034,8 @@ static int oz_clear_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 		port->status &= ~clear_bits;
 		spin_unlock_bh(&port->port_lock);
 	}
-	oz_trace2(OZ_TRACE_HUB, "Port[%d] status = 0x%x\n", port_id,
-		ozhcd->ports[port_id-1].status);
+	oz_dbg(HUB, "Port[%d] status = 0x%x\n",
+	       port_id, ozhcd->ports[port_id-1].status);
 	return err;
 }
 /*------------------------------------------------------------------------------
@@ -2051,10 +2048,10 @@ static int oz_get_port_status(struct usb_hcd *hcd, u16 windex, char *buf)
 	if ((windex < 1) || (windex > OZ_NB_PORTS))
 		return -EPIPE;
 	ozhcd = oz_hcd_private(hcd);
-	oz_trace2(OZ_TRACE_HUB, "GetPortStatus windex = %d\n", windex);
+	oz_dbg(HUB, "GetPortStatus windex = %d\n", windex);
 	status = ozhcd->ports[windex-1].status;
 	put_unaligned(cpu_to_le32(status), (__le32 *)buf);
-	oz_trace2(OZ_TRACE_HUB, "Port[%d] status = %x\n", windex, status);
+	oz_dbg(HUB, "Port[%d] status = %x\n", windex, status);
 	return 0;
 }
 /*------------------------------------------------------------------------------
@@ -2067,7 +2064,7 @@ static int oz_hcd_hub_control(struct usb_hcd *hcd, u16 req_type, u16 wvalue,
 
 	switch (req_type) {
 	case ClearHubFeature:
-		oz_trace2(OZ_TRACE_HUB, "ClearHubFeature: %d\n", req_type);
+		oz_dbg(HUB, "ClearHubFeature: %d\n", req_type);
 		break;
 	case ClearPortFeature:
 		err = oz_clear_port_feature(hcd, wvalue, windex);
@@ -2076,21 +2073,20 @@ static int oz_hcd_hub_control(struct usb_hcd *hcd, u16 req_type, u16 wvalue,
 		oz_get_hub_descriptor(hcd, (struct usb_hub_descriptor *)buf);
 		break;
 	case GetHubStatus:
-		oz_trace2(OZ_TRACE_HUB, "GetHubStatus: req_type = 0x%x\n",
-			req_type);
+		oz_dbg(HUB, "GetHubStatus: req_type = 0x%x\n", req_type);
 		put_unaligned(__constant_cpu_to_le32(0), (__le32 *)buf);
 		break;
 	case GetPortStatus:
 		err = oz_get_port_status(hcd, windex, buf);
 		break;
 	case SetHubFeature:
-		oz_trace2(OZ_TRACE_HUB, "SetHubFeature: %d\n", req_type);
+		oz_dbg(HUB, "SetHubFeature: %d\n", req_type);
 		break;
 	case SetPortFeature:
 		err = oz_set_port_feature(hcd, wvalue, windex);
 		break;
 	default:
-		oz_trace2(OZ_TRACE_HUB, "Other: %d\n", req_type);
+		oz_dbg(HUB, "Other: %d\n", req_type);
 		break;
 	}
 	return err;
@@ -2141,7 +2137,7 @@ static int oz_plat_probe(struct platform_device *dev)
 
 	hcd = usb_create_hcd(&g_oz_hc_drv, &dev->dev, dev_name(&dev->dev));
 	if (hcd == NULL) {
-		oz_trace("Failed to created hcd object OK\n");
+		oz_dbg(ON, "Failed to created hcd object OK\n");
 		return -ENOMEM;
 	}
 	ozhcd = oz_hcd_private(hcd);
@@ -2162,7 +2158,7 @@ static int oz_plat_probe(struct platform_device *dev)
 	}
 	err = usb_add_hcd(hcd, 0, 0);
 	if (err) {
-		oz_trace("Failed to add hcd object OK\n");
+		oz_dbg(ON, "Failed to add hcd object OK\n");
 		usb_put_hcd(hcd);
 		return -1;
 	}
@@ -2186,14 +2182,15 @@ static int oz_plat_remove(struct platform_device *dev)
 	if (ozhcd == g_ozhcd)
 		g_ozhcd = NULL;
 	spin_unlock_bh(&g_hcdlock);
-	oz_trace("Clearing orphanage\n");
+	oz_dbg(ON, "Clearing orphanage\n");
 	oz_hcd_clear_orphanage(ozhcd, -EPIPE);
-	oz_trace("Removing hcd\n");
+	oz_dbg(ON, "Removing hcd\n");
 	usb_remove_hcd(hcd);
 	usb_put_hcd(hcd);
 	oz_empty_link_pool();
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -2201,6 +2198,7 @@ static int oz_plat_suspend(struct platform_device *dev, pm_message_t msg)
 {
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -2208,6 +2206,7 @@ static int oz_plat_resume(struct platform_device *dev)
 {
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -2219,7 +2218,7 @@ int oz_hcd_init(void)
 	tasklet_init(&g_urb_process_tasklet, oz_urb_process_tasklet, 0);
 	tasklet_init(&g_urb_cancel_tasklet, oz_urb_cancel_tasklet, 0);
 	err = platform_driver_register(&g_oz_plat_drv);
-	oz_trace("platform_driver_register() returned %d\n", err);
+	oz_dbg(ON, "platform_driver_register() returned %d\n", err);
 	if (err)
 		goto error;
 	g_plat_dev = platform_device_alloc(OZ_PLAT_DEV_NAME, -1);
@@ -2227,11 +2226,11 @@ int oz_hcd_init(void)
 		err = -ENOMEM;
 		goto error1;
 	}
-	oz_trace("platform_device_alloc() succeeded\n");
+	oz_dbg(ON, "platform_device_alloc() succeeded\n");
 	err = platform_device_add(g_plat_dev);
 	if (err)
 		goto error2;
-	oz_trace("platform_device_add() succeeded\n");
+	oz_dbg(ON, "platform_device_add() succeeded\n");
 	return 0;
 error2:
 	platform_device_put(g_plat_dev);
@@ -2240,7 +2239,7 @@ error1:
 error:
 	tasklet_disable(&g_urb_process_tasklet);
 	tasklet_disable(&g_urb_cancel_tasklet);
-	oz_trace("oz_hcd_init() failed %d\n", err);
+	oz_dbg(ON, "oz_hcd_init() failed %d\n", err);
 	return err;
 }
 /*------------------------------------------------------------------------------
@@ -2252,5 +2251,5 @@ void oz_hcd_term(void)
 	tasklet_kill(&g_urb_cancel_tasklet);
 	platform_device_unregister(g_plat_dev);
 	platform_driver_unregister(&g_oz_plat_drv);
-	oz_trace("Pending urbs:%d\n", atomic_read(&g_pending_urbs));
+	oz_dbg(ON, "Pending urbs:%d\n", atomic_read(&g_pending_urbs));
 }
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index d67dff2..28adbb4 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/netdevice.h>
 #include <linux/errno.h>
+#include "ozdbg.h"
 #include "ozconfig.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
@@ -123,16 +124,16 @@ void oz_pd_set_state(struct oz_pd *pd, unsigned state)
 #ifdef WANT_TRACE
 	switch (state) {
 	case OZ_PD_S_IDLE:
-		oz_trace("PD State: OZ_PD_S_IDLE\n");
+		oz_pd_dbg(pd, ON, "PD State: OZ_PD_S_IDLE\n");
 		break;
 	case OZ_PD_S_CONNECTED:
-		oz_trace("PD State: OZ_PD_S_CONNECTED\n");
+		oz_pd_dbg(pd, ON, "PD State: OZ_PD_S_CONNECTED\n");
 		break;
 	case OZ_PD_S_STOPPED:
-		oz_trace("PD State: OZ_PD_S_STOPPED\n");
+		oz_pd_dbg(pd, ON, "PD State: OZ_PD_S_STOPPED\n");
 		break;
 	case OZ_PD_S_SLEEP:
-		oz_trace("PD State: OZ_PD_S_SLEEP\n");
+		oz_pd_dbg(pd, ON, "PD State: OZ_PD_S_SLEEP\n");
 		break;
 	}
 #endif /* WANT_TRACE */
@@ -189,7 +190,7 @@ void oz_pd_destroy(struct oz_pd *pd)
 	struct oz_tx_frame *f;
 	struct oz_isoc_stream *st;
 	struct oz_farewell *fwell;
-	oz_trace("Destroying PD\n");
+	oz_pd_dbg(pd, ON, "Destroying PD\n");
 	/* Delete any streams.
 	 */
 	e = pd->stream_list.next;
@@ -235,13 +236,14 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
 {
 	const struct oz_app_if *ai;
 	int rc = 0;
-	oz_trace("oz_services_start(0x%x) resume(%d)\n", apps, resume);
+	oz_pd_dbg(pd, ON, "%s: (0x%x) resume(%d)\n", __func__, apps, resume);
 	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
 		if (apps & (1<<ai->app_id)) {
 			if (ai->start(pd, resume)) {
 				rc = -1;
-				oz_trace("Unabled to start service %d\n",
-					ai->app_id);
+				oz_pd_dbg(pd, ON,
+					  "Unable to start service %d\n",
+					  ai->app_id);
 				break;
 			}
 			oz_polling_lock_bh();
@@ -259,7 +261,7 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
 void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
 {
 	const struct oz_app_if *ai;
-	oz_trace("oz_stop_services(0x%x) pause(%d)\n", apps, pause);
+	oz_pd_dbg(pd, ON, "%s: (0x%x) pause(%d)\n", __func__, apps, pause);
 	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
 		if (apps & (1<<ai->app_id)) {
 			oz_polling_lock_bh();
@@ -301,7 +303,7 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 void oz_pd_stop(struct oz_pd *pd)
 {
 	u16 stop_apps = 0;
-	oz_trace("oz_pd_stop() State = 0x%x\n", pd->state);
+	oz_dbg(ON, "oz_pd_stop() State = 0x%x\n", pd->state);
 	oz_pd_indicate_farewells(pd);
 	oz_polling_lock_bh();
 	stop_apps = pd->total_apps;
@@ -314,7 +316,7 @@ void oz_pd_stop(struct oz_pd *pd)
 	/* Remove from PD list.*/
 	list_del(&pd->link);
 	oz_polling_unlock_bh();
-	oz_trace("pd ref count = %d\n", atomic_read(&pd->ref_count));
+	oz_dbg(ON, "pd ref count = %d\n", atomic_read(&pd->ref_count));
 	oz_timer_delete(pd, 0);
 	oz_pd_put(pd);
 }
@@ -333,8 +335,8 @@ int oz_pd_sleep(struct oz_pd *pd)
 	if (pd->keep_alive_j && pd->session_id) {
 		oz_pd_set_state(pd, OZ_PD_S_SLEEP);
 		pd->pulse_time_j = jiffies + pd->keep_alive_j;
-		oz_trace("Sleep Now %lu until %lu\n",
-			jiffies, pd->pulse_time_j);
+		oz_dbg(ON, "Sleep Now %lu until %lu\n",
+		       jiffies, pd->pulse_time_j);
 	} else {
 		do_stop = 1;
 	}
@@ -384,8 +386,8 @@ static void oz_tx_isoc_free(struct oz_pd *pd, struct oz_tx_frame *f)
 	} else {
 		kfree(f);
 	}
-	oz_trace2(OZ_TRACE_TX_FRAMES, "Releasing ISOC Frame isoc_nb= %d\n",
-						pd->nb_queued_isoc_frames);
+	oz_dbg(TX_FRAMES, "Releasing ISOC Frame isoc_nb= %d\n",
+	       pd->nb_queued_isoc_frames);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq or process
@@ -540,18 +542,16 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 		if ((int)atomic_read(&g_submitted_isoc) <
 							OZ_MAX_SUBMITTED_ISOC) {
 			if (dev_queue_xmit(skb) < 0) {
-				oz_trace2(OZ_TRACE_TX_FRAMES,
-						"Dropping ISOC Frame\n");
+				oz_dbg(TX_FRAMES, "Dropping ISOC Frame\n");
 				return -1;
 			}
 			atomic_inc(&g_submitted_isoc);
-			oz_trace2(OZ_TRACE_TX_FRAMES,
-					"Sending ISOC Frame, nb_isoc= %d\n",
-						pd->nb_queued_isoc_frames);
+			oz_dbg(TX_FRAMES, "Sending ISOC Frame, nb_isoc= %d\n",
+			       pd->nb_queued_isoc_frames);
 			return 0;
 		} else {
 			kfree_skb(skb);
-			oz_trace2(OZ_TRACE_TX_FRAMES, "Dropping ISOC Frame>\n");
+			oz_dbg(TX_FRAMES, "Dropping ISOC Frame>\n");
 			return -1;
 		}
 	}
@@ -561,7 +561,7 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 	spin_unlock(&pd->tx_frame_lock);
 	if (more_data)
 		oz_set_more_bit(skb);
-	oz_trace2(OZ_TRACE_TX_FRAMES, "TX frame PN=0x%x\n", f->hdr.pkt_num);
+	oz_dbg(TX_FRAMES, "TX frame PN=0x%x\n", f->hdr.pkt_num);
 	if (skb) {
 		if (dev_queue_xmit(skb) < 0)
 			return -1;
@@ -627,7 +627,7 @@ static int oz_send_isoc_frame(struct oz_pd *pd)
 		return 0;
 	skb = alloc_skb(total_size + OZ_ALLOCATED_SPACE(dev), GFP_ATOMIC);
 	if (skb == NULL) {
-		oz_trace("Cannot alloc skb\n");
+		oz_dbg(ON, "Cannot alloc skb\n");
 		oz_elt_info_free_chain(&pd->elt_buff, &list);
 		return -1;
 	}
@@ -675,8 +675,8 @@ void oz_retire_tx_frames(struct oz_pd *pd, u8 lpn)
 		diff = (lpn - (pkt_num & OZ_LAST_PN_MASK)) & OZ_LAST_PN_MASK;
 		if ((diff > OZ_LAST_PN_HALF_CYCLE) || (pkt_num == 0))
 			break;
-		oz_trace2(OZ_TRACE_TX_FRAMES, "Releasing pkt_num= %u, nb= %d\n",
-						 pkt_num, pd->nb_queued_frames);
+		oz_dbg(TX_FRAMES, "Releasing pkt_num= %u, nb= %d\n",
+		       pkt_num, pd->nb_queued_frames);
 		if (first == NULL)
 			first = e;
 		last = e;
@@ -835,9 +835,8 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 			struct oz_tx_frame *isoc_unit = NULL;
 			int nb = pd->nb_queued_isoc_frames;
 			if (nb >= pd->isoc_latency) {
-				oz_trace2(OZ_TRACE_TX_FRAMES,
-						"Dropping ISOC Unit nb= %d\n",
-									nb);
+				oz_dbg(TX_FRAMES, "Dropping ISOC Unit nb= %d\n",
+				       nb);
 				goto out;
 			}
 			isoc_unit = oz_tx_frame_alloc(pd);
@@ -849,9 +848,9 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 			list_add_tail(&isoc_unit->link, &pd->tx_queue);
 			pd->nb_queued_isoc_frames++;
 			spin_unlock_bh(&pd->tx_frame_lock);
-			oz_trace2(OZ_TRACE_TX_FRAMES,
-			"Added ISOC Frame to Tx Queue isoc_nb= %d, nb= %d\n",
-			pd->nb_queued_isoc_frames, pd->nb_queued_frames);
+			oz_dbg(TX_FRAMES,
+			       "Added ISOC Frame to Tx Queue isoc_nb= %d, nb= %d\n",
+			       pd->nb_queued_isoc_frames, pd->nb_queued_frames);
 			return 0;
 		}
 
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 79ac7b5..494236e 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 #include <linux/errno.h>
 #include <linux/ieee80211.h>
+#include "ozdbg.h"
 #include "ozconfig.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
@@ -124,7 +125,7 @@ static void oz_send_conn_rsp(struct oz_pd *pd, u8 status)
 		body->session_id = pd->session_id;
 		put_unaligned(cpu_to_le16(pd->total_apps), &body->apps);
 	}
-	oz_trace("TX: OZ_ELT_CONNECT_RSP %d", status);
+	oz_dbg(ON, "TX: OZ_ELT_CONNECT_RSP %d", status);
 	dev_queue_xmit(skb);
 	return;
 }
@@ -152,7 +153,7 @@ static void pd_set_keepalive(struct oz_pd *pd, u8 kalive)
 	default:
 		pd->keep_alive_j = 0;
 	}
-	oz_trace("Keepalive = %lu jiffies\n", pd->keep_alive_j);
+	oz_dbg(ON, "Keepalive = %lu jiffies\n", pd->keep_alive_j);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
@@ -163,7 +164,7 @@ static void pd_set_presleep(struct oz_pd *pd, u8 presleep)
 		pd->presleep_j = oz_ms_to_jiffies(presleep*100);
 	else
 		pd->presleep_j = OZ_PRESLEEP_TOUT_J;
-	oz_trace("Presleep time = %lu jiffies\n", pd->presleep_j);
+	oz_dbg(ON, "Presleep time = %lu jiffies\n", pd->presleep_j);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
@@ -210,7 +211,7 @@ static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
 		dev_hold(net_dev);
 		pd->net_dev = net_dev;
 	}
-	oz_trace("Host vendor: %d\n", body->host_vendor);
+	oz_dbg(ON, "Host vendor: %d\n", body->host_vendor);
 	pd->max_tx_size = OZ_MAX_TX_SIZE;
 	pd->mode = body->mode;
 	pd->pd_info = body->pd_info;
@@ -234,8 +235,8 @@ static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
 	}
 	if (body->max_len_div16)
 		pd->max_tx_size = ((u16)body->max_len_div16)<<4;
-	oz_trace("Max frame:%u Ms per isoc:%u\n",
-		pd->max_tx_size, pd->ms_per_isoc);
+	oz_dbg(ON, "Max frame:%u Ms per isoc:%u\n",
+	       pd->max_tx_size, pd->ms_per_isoc);
 	pd->max_stream_buffering = 3*1024;
 	pd->timeout_time_j = jiffies + OZ_CONNECTION_TOUT_J;
 	pd->pulse_period_j = OZ_QUANTUM_J;
@@ -272,8 +273,8 @@ done:
 		spin_unlock_bh(&g_polling_lock);
 		oz_pd_set_state(pd, OZ_PD_S_CONNECTED);
 		oz_timer_delete(pd, OZ_TIMER_STOP);
-		oz_trace("new_apps=0x%x total_apps=0x%x paused_apps=0x%x\n",
-			new_apps, pd->total_apps, pd->paused_apps);
+		oz_dbg(ON, "new_apps=0x%x total_apps=0x%x paused_apps=0x%x\n",
+		       new_apps, pd->total_apps, pd->paused_apps);
 		if (start_apps) {
 			if (oz_services_start(pd, start_apps, 0))
 				rsp_status = OZ_STATUS_TOO_MANY_PDS;
@@ -315,7 +316,7 @@ static void oz_add_farewell(struct oz_pd *pd, u8 ep_num, u8 index,
 	f->ep_num = ep_num;
 	f->index = index;
 	memcpy(f->report, report, len);
-	oz_trace("RX: Adding farewell report\n");
+	oz_dbg(ON, "RX: Adding farewell report\n");
 	spin_lock(&g_polling_lock);
 	list_for_each_entry(f2, &pd->farewell_list, link) {
 		if ((f2->ep_num == ep_num) && (f2->index == index)) {
@@ -343,17 +344,16 @@ static void oz_rx_frame(struct sk_buff *skb)
 	int dup = 0;
 	u32 pkt_num;
 
-	oz_trace2(OZ_TRACE_RX_FRAMES,
-		"RX frame PN=0x%x LPN=0x%x control=0x%x\n",
-		oz_hdr->pkt_num, oz_hdr->last_pkt_num, oz_hdr->control);
+	oz_dbg(RX_FRAMES, "RX frame PN=0x%x LPN=0x%x control=0x%x\n",
+	       oz_hdr->pkt_num, oz_hdr->last_pkt_num, oz_hdr->control);
 	mac_hdr = skb_mac_header(skb);
 	src_addr = &mac_hdr[ETH_ALEN] ;
 	length = skb->len;
 
 	/* Check the version field */
 	if (oz_get_prot_ver(oz_hdr->control) != OZ_PROTOCOL_VERSION) {
-		oz_trace("Incorrect protocol version: %d\n",
-			oz_get_prot_ver(oz_hdr->control));
+		oz_dbg(ON, "Incorrect protocol version: %d\n",
+		       oz_get_prot_ver(oz_hdr->control));
 		goto done;
 	}
 
@@ -368,12 +368,12 @@ static void oz_rx_frame(struct sk_buff *skb)
 			pd->last_rx_pkt_num = pkt_num;
 		} else {
 			dup = 1;
-			oz_trace("Duplicate frame\n");
+			oz_dbg(ON, "Duplicate frame\n");
 		}
 	}
 
 	if (pd && !dup && ((pd->mode & OZ_MODE_MASK) == OZ_MODE_TRIGGERED)) {
-		oz_trace2(OZ_TRACE_RX_FRAMES, "Received TRIGGER Frame\n");
+		oz_dbg(RX_FRAMES, "Received TRIGGER Frame\n");
 		pd->last_sent_frame = &pd->tx_queue;
 		if (oz_hdr->control & OZ_F_ACK) {
 			/* Retire completed frames */
@@ -397,18 +397,18 @@ static void oz_rx_frame(struct sk_buff *skb)
 			break;
 		switch (elt->type) {
 		case OZ_ELT_CONNECT_REQ:
-			oz_trace("RX: OZ_ELT_CONNECT_REQ\n");
+			oz_dbg(ON, "RX: OZ_ELT_CONNECT_REQ\n");
 			pd = oz_connect_req(pd, elt, src_addr, skb->dev);
 			break;
 		case OZ_ELT_DISCONNECT:
-			oz_trace("RX: OZ_ELT_DISCONNECT\n");
+			oz_dbg(ON, "RX: OZ_ELT_DISCONNECT\n");
 			if (pd)
 				oz_pd_sleep(pd);
 			break;
 		case OZ_ELT_UPDATE_PARAM_REQ: {
 				struct oz_elt_update_param *body =
 					(struct oz_elt_update_param *)(elt + 1);
-				oz_trace("RX: OZ_ELT_UPDATE_PARAM_REQ\n");
+				oz_dbg(ON, "RX: OZ_ELT_UPDATE_PARAM_REQ\n");
 				if (pd && (pd->state & OZ_PD_S_CONNECTED)) {
 					spin_lock(&g_polling_lock);
 					pd_set_keepalive(pd, body->keepalive);
@@ -420,7 +420,7 @@ static void oz_rx_frame(struct sk_buff *skb)
 		case OZ_ELT_FAREWELL_REQ: {
 				struct oz_elt_farewell *body =
 					(struct oz_elt_farewell *)(elt + 1);
-				oz_trace("RX: OZ_ELT_FAREWELL_REQ\n");
+				oz_dbg(ON, "RX: OZ_ELT_FAREWELL_REQ\n");
 				oz_add_farewell(pd, body->ep_num,
 					body->index, body->report,
 					elt->length + 1 - sizeof(*body));
@@ -436,7 +436,7 @@ static void oz_rx_frame(struct sk_buff *skb)
 			}
 			break;
 		default:
-			oz_trace("RX: Unknown elt %02x\n", elt->type);
+			oz_dbg(ON, "RX: Unknown elt %02x\n", elt->type);
 		}
 		elt = oz_next_elt(elt);
 	}
@@ -488,7 +488,7 @@ void oz_protocol_term(void)
 		chain = chain->next;
 		kfree(t);
 	}
-	oz_trace("Protocol stopped\n");
+	oz_dbg(ON, "Protocol stopped\n");
 }
 /*------------------------------------------------------------------------------
  * Context: softirq
@@ -583,7 +583,7 @@ static void oz_protocol_timer_start(void)
 		}
 		g_timer_state = OZ_TIMER_SET;
 	} else {
-		oz_trace("No queued timers\n");
+		oz_dbg(ON, "No queued timers\n");
 	}
 	spin_unlock_bh(&g_polling_lock);
 }
@@ -795,16 +795,16 @@ void oz_binding_add(char *net_dev)
 		binding->ptype.func = oz_pkt_recv;
 		memcpy(binding->name, net_dev, OZ_MAX_BINDING_LEN);
 		if (net_dev && *net_dev) {
-			oz_trace("Adding binding: %s\n", net_dev);
+			oz_dbg(ON, "Adding binding: %s\n", net_dev);
 			binding->ptype.dev =
 				dev_get_by_name(&init_net, net_dev);
 			if (binding->ptype.dev == NULL) {
-				oz_trace("Netdev %s not found\n", net_dev);
+				oz_dbg(ON, "Netdev %s not found\n", net_dev);
 				kfree(binding);
 				binding = NULL;
 			}
 		} else {
-			oz_trace("Binding to all netcards\n");
+			oz_dbg(ON, "Binding to all netcards\n");
 			binding->ptype.dev = NULL;
 		}
 		if (binding) {
@@ -861,13 +861,13 @@ void oz_binding_remove(char *net_dev)
 {
 	struct oz_binding *binding;
 	struct oz_binding **link;
-	oz_trace("Removing binding: %s\n", net_dev);
+	oz_dbg(ON, "Removing binding: %s\n", net_dev);
 	spin_lock_bh(&g_binding_lock);
 	binding = g_binding;
 	link = &g_binding;
 	while (binding) {
 		if (compare_binding_name(binding->name, net_dev)) {
-			oz_trace("Binding '%s' found\n", net_dev);
+			oz_dbg(ON, "Binding '%s' found\n", net_dev);
 			*link = binding->next;
 			break;
 		} else {
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index 93bb4c0..9bb0a6a 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -7,7 +7,7 @@
 #define _OZPROTO_H
 
 #include <asm/byteorder.h>
-#include "ozconfig.h"
+#include "ozdbg.h"
 #include "ozappif.h"
 
 #define OZ_ALLOCATED_SPACE(__x)	(LL_RESERVED_SPACE(__x)+(__x)->needed_tailroom)
diff --git a/drivers/staging/ozwpan/ozurbparanoia.c b/drivers/staging/ozwpan/ozurbparanoia.c
index 55b9afb..387d9da 100644
--- a/drivers/staging/ozwpan/ozurbparanoia.c
+++ b/drivers/staging/ozwpan/ozurbparanoia.c
@@ -4,6 +4,7 @@
  * -----------------------------------------------------------------------------
  */
 #include <linux/usb.h>
+#include "ozdbg.h"
 #include "ozconfig.h"
 #ifdef WANT_URB_PARANOIA
 #include "ozurbparanoia.h"
@@ -22,9 +23,9 @@ void oz_remember_urb(struct urb *urb)
 	spin_lock_irqsave(&g_urb_mem_lock, irq_state);
 	if (g_nb_urbs < OZ_MAX_URBS) {
 		g_urb_memory[g_nb_urbs++] = urb;
-		oz_trace("%lu: urb up = %d %p\n", jiffies, g_nb_urbs, urb);
+		oz_dbg(ON, "%lu: urb up = %d %p\n", jiffies, g_nb_urbs, urb);
 	} else {
-		oz_trace("ERROR urb buffer full\n");
+		oz_dbg(ON, "ERROR urb buffer full\n");
 	}
 	spin_unlock_irqrestore(&g_urb_mem_lock, irq_state);
 }
@@ -42,8 +43,8 @@ int oz_forget_urb(struct urb *urb)
 			if (--g_nb_urbs > i)
 				memcpy(&g_urb_memory[i], &g_urb_memory[i+1],
 					(g_nb_urbs - i) * sizeof(struct urb *));
-			oz_trace("%lu: urb down = %d %p\n",
-				jiffies, g_nb_urbs, urb);
+			oz_dbg(ON, "%lu: urb down = %d %p\n",
+			       jiffies, g_nb_urbs, urb);
 		}
 	}
 	spin_unlock_irqrestore(&g_urb_mem_lock, irq_state);
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index 1676328..b4aebdb 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/input.h>
 #include <asm/unaligned.h>
+#include "ozdbg.h"
 #include "ozconfig.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
@@ -53,10 +54,10 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 	struct oz_usb_ctx *usb_ctx;
 	struct oz_usb_ctx *old_ctx;
 	if (resume) {
-		oz_trace("USB service resumed.\n");
+		oz_dbg(ON, "USB service resumed\n");
 		return 0;
 	}
-	oz_trace("USB service started.\n");
+	oz_dbg(ON, "USB service started\n");
 	/* Create a USB context in case we need one. If we find the PD already
 	 * has a USB context then we will destroy it.
 	 */
@@ -77,7 +78,7 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 	oz_usb_get(pd->app_ctx[OZ_APPID_USB-1]);
 	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
 	if (old_ctx) {
-		oz_trace("Already have USB context.\n");
+		oz_dbg(ON, "Already have USB context\n");
 		kfree(usb_ctx);
 		usb_ctx = old_ctx;
 	} else if (usb_ctx) {
@@ -95,7 +96,7 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 	} else {
 		usb_ctx->hport = oz_hcd_pd_arrived(usb_ctx);
 		if (usb_ctx->hport == NULL) {
-			oz_trace("USB hub returned null port.\n");
+			oz_dbg(ON, "USB hub returned null port\n");
 			spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
 			pd->app_ctx[OZ_APPID_USB-1] = NULL;
 			spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
@@ -114,7 +115,7 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 {
 	struct oz_usb_ctx *usb_ctx;
 	if (pause) {
-		oz_trace("USB service paused.\n");
+		oz_dbg(ON, "USB service paused\n");
 		return;
 	}
 	spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
@@ -123,7 +124,7 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
 	if (usb_ctx) {
 		unsigned long tout = jiffies + HZ;
-		oz_trace("USB service stopping...\n");
+		oz_dbg(ON, "USB service stopping...\n");
 		usb_ctx->stopped = 1;
 		/* At this point the reference count on the usb context should
 		 * be 2 - one from when we created it and one from the hcd
@@ -134,7 +135,7 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 		while ((atomic_read(&usb_ctx->ref_count) > 2) &&
 			time_before(jiffies, tout))
 			;
-		oz_trace("USB service stopped.\n");
+		oz_dbg(ON, "USB service stopped\n");
 		oz_hcd_pd_departed(usb_ctx->hport);
 		/* Release the reference taken in oz_usb_start.
 		 */
@@ -160,7 +161,7 @@ void oz_usb_put(void *hpd)
 {
 	struct oz_usb_ctx *usb_ctx = (struct oz_usb_ctx *)hpd;
 	if (atomic_dec_and_test(&usb_ctx->ref_count)) {
-		oz_trace("Dealloc USB context.\n");
+		oz_dbg(ON, "Dealloc USB context\n");
 		oz_pd_put(usb_ctx->pd);
 		kfree(usb_ctx);
 	}
@@ -195,7 +196,7 @@ int oz_usb_stream_create(void *hpd, u8 ep_num)
 {
 	struct oz_usb_ctx *usb_ctx = (struct oz_usb_ctx *)hpd;
 	struct oz_pd *pd = usb_ctx->pd;
-	oz_trace("oz_usb_stream_create(0x%x)\n", ep_num);
+	oz_dbg(ON, "%s: (0x%x)\n", __func__, ep_num);
 	if (pd->mode & OZ_F_ISOC_NO_ELTS) {
 		oz_isoc_stream_create(pd, ep_num);
 	} else {
@@ -217,7 +218,7 @@ int oz_usb_stream_delete(void *hpd, u8 ep_num)
 	if (usb_ctx) {
 		struct oz_pd *pd = usb_ctx->pd;
 		if (pd) {
-			oz_trace("oz_usb_stream_delete(0x%x)\n", ep_num);
+			oz_dbg(ON, "%s: (0x%x)\n", __func__, ep_num);
 			if (pd->mode & OZ_F_ISOC_NO_ELTS) {
 				oz_isoc_stream_delete(pd, ep_num);
 			} else {
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index 16e6078..ab2c641 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/input.h>
 #include <asm/unaligned.h>
+#include "ozdbg.h"
 #include "ozconfig.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
@@ -62,12 +63,12 @@ int oz_usb_get_desc_req(void *hpd, u8 req_id, u8 req_type, u8 desc_type,
 	struct oz_get_desc_req *body;
 	struct oz_elt_buf *eb = &pd->elt_buff;
 	struct oz_elt_info *ei = oz_elt_info_alloc(&pd->elt_buff);
-	oz_trace("    req_type = 0x%x\n", req_type);
-	oz_trace("    desc_type = 0x%x\n", desc_type);
-	oz_trace("    index = 0x%x\n", index);
-	oz_trace("    windex = 0x%x\n", windex);
-	oz_trace("    offset = 0x%x\n", offset);
-	oz_trace("    len = 0x%x\n", len);
+	oz_dbg(ON, "    req_type = 0x%x\n", req_type);
+	oz_dbg(ON, "    desc_type = 0x%x\n", desc_type);
+	oz_dbg(ON, "    index = 0x%x\n", index);
+	oz_dbg(ON, "    windex = 0x%x\n", windex);
+	oz_dbg(ON, "    offset = 0x%x\n", offset);
+	oz_dbg(ON, "    len = 0x%x\n", len);
 	if (len > 200)
 		len = 200;
 	if (ei == NULL)
@@ -376,7 +377,7 @@ void oz_usb_rx(struct oz_pd *pd, struct oz_elt *elt)
 			u16 offs = le16_to_cpu(get_unaligned(&body->offset));
 			u16 total_size =
 				le16_to_cpu(get_unaligned(&body->total_size));
-			oz_trace("USB_REQ_GET_DESCRIPTOR - cnf\n");
+			oz_dbg(ON, "USB_REQ_GET_DESCRIPTOR - cnf\n");
 			oz_hcd_get_desc_cnf(usb_ctx->hport, body->req_id,
 					body->rcode, body->data,
 					data_len, offs, total_size);
@@ -425,7 +426,7 @@ void oz_usb_farewell(struct oz_pd *pd, u8 ep_num, u8 *data, u8 len)
 	if (usb_ctx == NULL)
 		return; /* Context has gone so nothing to do. */
 	if (!usb_ctx->stopped) {
-		oz_trace("Farewell indicated ep = 0x%x\n", ep_num);
+		oz_dbg(ON, "Farewell indicated ep = 0x%x\n", ep_num);
 		oz_hcd_data_ind(usb_ctx->hport, ep_num, data, len);
 	}
 	oz_usb_put(usb_ctx);
-- 
1.7.9.5

