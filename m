Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaHDNDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:03:54 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.103]:35205 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaHDNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:02:54 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 10/10] staging: ozwpan: Use list helpers
Date: Mon,  4 Aug 2014 14:54:56 +0200
Message-Id: <1407156896-3246-11-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the various list helper functions to improve readability.

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/ozwpan/ozeltbuf.c |  60 +++++++--------------
 drivers/staging/ozwpan/ozhcd.c    |  96 +++++++++++-----------------------
 drivers/staging/ozwpan/ozpd.c     | 106 ++++++++++++--------------------------
 drivers/staging/ozwpan/ozproto.c  |  15 ++----
 4 files changed, 88 insertions(+), 189 deletions(-)

diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index 81580cb..64d9fab 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -27,24 +27,12 @@ void oz_elt_buf_init(struct oz_elt_buf *buf)
  */
 void oz_elt_buf_term(struct oz_elt_buf *buf)
 {
-	struct list_head *e;
-	int i;
+	struct oz_elt_info *ei, *n;
 
-	/* Free any elements in the order or isoc lists. */
-	for (i = 0; i < 2; i++) {
-		struct list_head *list;
-		if (i)
-			list = &buf->order_list;
-		else
-			list = &buf->isoc_list;
-		e = list->next;
-		while (e != list) {
-			struct oz_elt_info *ei =
-				container_of(e, struct oz_elt_info, link_order);
-			e = e->next;
-			kfree(ei);
-		}
-	}
+	list_for_each_entry_safe(ei, n, &buf->isoc_list, link_order)
+		kfree(ei);
+	list_for_each_entry_safe(ei, n, &buf->order_list, link_order)
+		kfree(ei);
 }
 
 /*
@@ -77,16 +65,11 @@ void oz_elt_info_free(struct oz_elt_buf *buf, struct oz_elt_info *ei)
  */
 void oz_elt_info_free_chain(struct oz_elt_buf *buf, struct list_head *list)
 {
-	struct list_head *e;
+	struct oz_elt_info *ei, *n;
 
-	e = list->next;
 	spin_lock_bh(&buf->lock);
-	while (e != list) {
-		struct oz_elt_info *ei;
-		ei = container_of(e, struct oz_elt_info, link);
-		e = e->next;
+	list_for_each_entry_safe(ei, n, list->next, link)
 		oz_elt_info_free(buf, ei);
-	}
 	spin_unlock_bh(&buf->lock);
 }
 
@@ -111,14 +94,13 @@ int oz_elt_stream_create(struct oz_elt_buf *buf, u8 id, int max_buf_count)
 
 int oz_elt_stream_delete(struct oz_elt_buf *buf, u8 id)
 {
-	struct list_head *e;
+	struct list_head *e, *n;
 	struct oz_elt_stream *st = NULL;
 
 	oz_dbg(ON, "%s: (0x%x)\n", __func__, id);
 	spin_lock_bh(&buf->lock);
-	e = buf->stream_list.next;
-	while (e != &buf->stream_list) {
-		st = container_of(e, struct oz_elt_stream, link);
+	list_for_each(e, &buf->stream_list) {
+		st = list_entry(e, struct oz_elt_stream, link);
 		if (st->id == id) {
 			list_del(e);
 			break;
@@ -129,11 +111,9 @@ int oz_elt_stream_delete(struct oz_elt_buf *buf, u8 id)
 		spin_unlock_bh(&buf->lock);
 		return -1;
 	}
-	e = st->elt_list.next;
-	while (e != &st->elt_list) {
+	list_for_each_safe(e, n, &st->elt_list) {
 		struct oz_elt_info *ei =
-			container_of(e, struct oz_elt_info, link);
-		e = e->next;
+			list_entry(e, struct oz_elt_info, link);
 		list_del_init(&ei->link);
 		list_del_init(&ei->link_order);
 		st->buf_count -= ei->length;
@@ -173,7 +153,7 @@ int oz_queue_elt_info(struct oz_elt_buf *buf, u8 isoc, u8 id,
 
 	if (id) {
 		list_for_each(e, &buf->stream_list) {
-			st = container_of(e, struct oz_elt_stream, link);
+			st = list_entry(e, struct oz_elt_stream, link);
 			if (st->id == id)
 				break;
 		}
@@ -228,22 +208,18 @@ int oz_select_elts_for_tx(struct oz_elt_buf *buf, u8 isoc, unsigned *len,
 		unsigned max_len, struct list_head *list)
 {
 	int count = 0;
-	struct list_head *e;
 	struct list_head *el;
-	struct oz_elt_info *ei;
+	struct oz_elt_info *ei, *n;
 
 	spin_lock_bh(&buf->lock);
 	if (isoc)
 		el = &buf->isoc_list;
 	else
 		el = &buf->order_list;
-	e = el->next;
-	while (e != el) {
-		struct oz_app_hdr *app_hdr;
-		ei = container_of(e, struct oz_elt_info, link_order);
-		e = e->next;
+
+	list_for_each_entry_safe(ei, n, el, link_order) {
 		if ((*len + ei->length) <= max_len) {
-			app_hdr = (struct oz_app_hdr *)
+			struct oz_app_hdr *app_hdr = (struct oz_app_hdr *)
 				&ei->data[sizeof(struct oz_elt)];
 			app_hdr->elt_seq_num = buf->tx_seq_num[ei->app_id]++;
 			if (buf->tx_seq_num[ei->app_id] == 0)
@@ -271,5 +247,5 @@ int oz_select_elts_for_tx(struct oz_elt_buf *buf, u8 isoc, unsigned *len,
 
 int oz_are_elts_available(struct oz_elt_buf *buf)
 {
-	return buf->order_list.next != &buf->order_list;
+	return !list_empty(&buf->order_list);
 }
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 3b603c5..0f7fa69 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -45,10 +45,6 @@
  */
 #define OZ_PLAT_DEV_NAME	"ozwpan"
 
-/* Get endpoint object from the containing link.
- */
-#define ep_from_link(__e) container_of((__e), struct oz_endpoint, link)
-
 /*EP0 timeout before ep0 request is again added to TX queue. (13*8 = 98mSec)
  */
 #define EP0_TIMEOUT_COUNTER 13
@@ -308,12 +304,10 @@ static struct oz_urb_link *oz_uncancel_urb(struct oz_hcd *ozhcd,
 		struct urb *urb)
 {
 	struct oz_urb_link *urbl;
-	struct list_head *e;
 
-	list_for_each(e, &ozhcd->urb_cancel_list) {
-		urbl = container_of(e, struct oz_urb_link, link);
+	list_for_each_entry(urbl, &ozhcd->urb_cancel_list, link) {
 		if (urb == urbl->urb) {
-			list_del_init(e);
+			list_del_init(&urbl->link);
 			return urbl;
 		}
 	}
@@ -372,10 +366,9 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
 static void oz_ep_free(struct oz_port *port, struct oz_endpoint *ep)
 {
 	if (port) {
-		struct list_head list;
+		LIST_HEAD(list);
 		struct oz_hcd *ozhcd = port->ozhcd;
 
-		INIT_LIST_HEAD(&list);
 		if (ep->flags & OZ_F_EP_HAVE_STREAM)
 			oz_usb_stream_delete(port->hpd, ep->ep_num);
 		/* Transfer URBs to the orphanage while we hold the lock. */
@@ -521,7 +514,7 @@ static int oz_dequeue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 		struct list_head *e;
 
 		list_for_each(e, &ep->urb_list) {
-			urbl = container_of(e, struct oz_urb_link, link);
+			urbl = list_entry(e, struct oz_urb_link, link);
 			if (urbl->urb == urb) {
 				list_del_init(e);
 				break;
@@ -553,7 +546,7 @@ static struct urb *oz_find_urb_by_id(struct oz_port *port, int ep_ix,
 		struct list_head *e;
 
 		list_for_each(e, &ep->urb_list) {
-			urbl = container_of(e, struct oz_urb_link, link);
+			urbl = list_entry(e, struct oz_urb_link, link);
 			if (urbl->req_id == req_id) {
 				urb = urbl->urb;
 				list_del_init(e);
@@ -1046,21 +1039,17 @@ int oz_hcd_heartbeat(void *hport)
 	int rc = 0;
 	struct oz_port *port = (struct oz_port *)hport;
 	struct oz_hcd *ozhcd = port->ozhcd;
-	struct oz_urb_link *urbl;
-	struct list_head xfr_list;
-	struct list_head *e;
-	struct list_head *n;
+	struct oz_urb_link *urbl, *n;
+	LIST_HEAD(xfr_list);
 	struct urb *urb;
 	struct oz_endpoint *ep;
 	struct timespec ts, delta;
 
 	getrawmonotonic(&ts);
-	INIT_LIST_HEAD(&xfr_list);
 	/* Check the OUT isoc endpoints to see if any URB data can be sent.
 	 */
 	spin_lock_bh(&ozhcd->hcd_lock);
-	list_for_each(e, &port->isoc_out_ep) {
-		ep = ep_from_link(e);
+	list_for_each_entry(ep, &port->isoc_out_ep, link) {
 		if (ep->credit < 0)
 			continue;
 		delta = timespec_sub(ts, ep->timestamp);
@@ -1083,10 +1072,9 @@ int oz_hcd_heartbeat(void *hport)
 	spin_unlock_bh(&ozhcd->hcd_lock);
 	/* Send to PD and complete URBs.
 	 */
-	list_for_each_safe(e, n, &xfr_list) {
-		urbl = container_of(e, struct oz_urb_link, link);
+	list_for_each_entry_safe(urbl, n, &xfr_list, link) {
 		urb = urbl->urb;
-		list_del_init(e);
+		list_del_init(&urbl->link);
 		urb->error_count = 0;
 		urb->start_frame = oz_usb_get_frame_number();
 		oz_usb_send_isoc(port->hpd, urbl->ep_num, urb);
@@ -1096,9 +1084,7 @@ int oz_hcd_heartbeat(void *hport)
 	/* Check the IN isoc endpoints to see if any URBs can be completed.
 	 */
 	spin_lock_bh(&ozhcd->hcd_lock);
-	list_for_each(e, &port->isoc_in_ep) {
-		struct oz_endpoint *ep = ep_from_link(e);
-
+	list_for_each_entry(ep, &port->isoc_in_ep, link) {
 		if (ep->flags & OZ_F_EP_BUFFERING) {
 			if (ep->buffered_units >= OZ_IN_BUFFERING_UNITS) {
 				ep->flags &= ~OZ_F_EP_BUFFERING;
@@ -1111,10 +1097,7 @@ int oz_hcd_heartbeat(void *hport)
 		delta = timespec_sub(ts, ep->timestamp);
 		ep->credit += div_u64(timespec_to_ns(&delta), NSEC_PER_MSEC);
 		ep->timestamp = ts;
-		while (!list_empty(&ep->urb_list)) {
-			struct oz_urb_link *urbl =
-				list_first_entry(&ep->urb_list,
-					struct oz_urb_link, link);
+		list_for_each_entry_safe(urbl, n, &ep->urb_list, link) {
 			struct urb *urb = urbl->urb;
 			int len = 0;
 			int copy_len;
@@ -1161,10 +1144,9 @@ int oz_hcd_heartbeat(void *hport)
 	spin_unlock_bh(&ozhcd->hcd_lock);
 	/* Complete the filled URBs.
 	 */
-	list_for_each_safe(e, n, &xfr_list) {
-		urbl = container_of(e, struct oz_urb_link, link);
+	list_for_each_entry_safe(urbl, n, &xfr_list, link) {
 		urb = urbl->urb;
-		list_del_init(e);
+		list_del_init(&urbl->link);
 		oz_free_urb_link(urbl);
 		oz_complete_urb(port->ozhcd->hcd, urb, 0);
 	}
@@ -1173,15 +1155,11 @@ int oz_hcd_heartbeat(void *hport)
 	 */
 	ep = port->out_ep[0];
 	if (ep) {
-		struct list_head *e;
-		struct list_head *n;
-
 		spin_lock_bh(&ozhcd->hcd_lock);
-		list_for_each_safe(e, n, &ep->urb_list) {
-			urbl = container_of(e, struct oz_urb_link, link);
+		list_for_each_entry_safe(urbl, n, &ep->urb_list, link) {
 			if (urbl->submit_counter > EP0_TIMEOUT_COUNTER) {
 				oz_dbg(ON, "Request 0x%p timeout\n", urbl->urb);
-				list_move_tail(e, &xfr_list);
+				list_move_tail(&urbl->link, &xfr_list);
 				urbl->submit_counter = 0;
 			} else {
 				urbl->submit_counter++;
@@ -1190,10 +1168,7 @@ int oz_hcd_heartbeat(void *hport)
 		if (!list_empty(&ep->urb_list))
 			rc = 1;
 		spin_unlock_bh(&ozhcd->hcd_lock);
-		e = xfr_list.next;
-		while (e != &xfr_list) {
-			urbl = container_of(e, struct oz_urb_link, link);
-			e = e->next;
+		list_for_each_entry_safe(urbl, n, &xfr_list, link) {
 			oz_dbg(ON, "Resending request to PD\n");
 			oz_process_ep0_urb(ozhcd, urbl->urb, GFP_ATOMIC);
 			oz_free_urb_link(urbl);
@@ -1292,12 +1267,12 @@ static void oz_clean_endpoints_for_interface(struct usb_hcd *hcd,
 	struct oz_hcd *ozhcd = port->ozhcd;
 	unsigned mask;
 	int i;
-	struct list_head ep_list;
+	LIST_HEAD(ep_list);
+	struct oz_endpoint *ep, *n;
 
 	oz_dbg(ON, "Deleting endpoints for interface %d\n", if_ix);
 	if (if_ix >= port->num_iface)
 		return;
-	INIT_LIST_HEAD(&ep_list);
 	spin_lock_bh(&ozhcd->hcd_lock);
 	mask = port->iface[if_ix].ep_mask;
 	port->iface[if_ix].ep_mask = 0;
@@ -1321,9 +1296,7 @@ static void oz_clean_endpoints_for_interface(struct usb_hcd *hcd,
 		}
 	}
 	spin_unlock_bh(&ozhcd->hcd_lock);
-	while (!list_empty(&ep_list)) {
-		struct oz_endpoint *ep =
-			list_first_entry(&ep_list, struct oz_endpoint, link);
+	list_for_each_entry_safe(ep, n, &ep_list, link) {
 		list_del_init(&ep->link);
 		oz_ep_free(port, ep);
 	}
@@ -1594,6 +1567,7 @@ static void oz_urb_process_tasklet(unsigned long unused)
 	unsigned long irq_state;
 	struct urb *urb;
 	struct oz_hcd *ozhcd = oz_hcd_claim();
+	struct oz_urb_link *urbl, *n;
 	int rc = 0;
 
 	if (ozhcd == NULL)
@@ -1603,10 +1577,7 @@ static void oz_urb_process_tasklet(unsigned long unused)
 	 * appropriately while removing urbs.
 	 */
 	spin_lock_irqsave(&g_tasklet_lock, irq_state);
-	while (!list_empty(&ozhcd->urb_pending_list)) {
-		struct oz_urb_link *urbl =
-			list_first_entry(&ozhcd->urb_pending_list,
-				struct oz_urb_link, link);
+	list_for_each_entry_safe(urbl, n, &ozhcd->urb_pending_list, link) {
 		list_del_init(&urbl->link);
 		spin_unlock_irqrestore(&g_tasklet_lock, irq_state);
 		urb = urbl->urb;
@@ -1651,7 +1622,7 @@ static void oz_urb_cancel(struct oz_port *port, u8 ep_num, struct urb *urb)
 	 */
 	spin_lock_irqsave(&g_tasklet_lock, irq_state);
 	list_for_each(e, &ozhcd->urb_cancel_list) {
-		urbl = container_of(e, struct oz_urb_link, link);
+		urbl = list_entry(e, struct oz_urb_link, link);
 		if (urb == urbl->urb) {
 			list_del_init(e);
 			spin_unlock_irqrestore(&g_tasklet_lock, irq_state);
@@ -1665,7 +1636,7 @@ static void oz_urb_cancel(struct oz_port *port, u8 ep_num, struct urb *urb)
 	 */
 	spin_lock_irqsave(&ozhcd->hcd_lock, irq_state);
 	list_for_each(e, &ozhcd->orphanage) {
-		urbl = container_of(e, struct oz_urb_link, link);
+		urbl = list_entry(e, struct oz_urb_link, link);
 		if (urbl->urb == urb) {
 			list_del(e);
 			oz_dbg(ON, "Found urb in orphanage\n");
@@ -1695,15 +1666,13 @@ static void oz_urb_cancel_tasklet(unsigned long unused)
 {
 	unsigned long irq_state;
 	struct urb *urb;
+	struct oz_urb_link *urbl, *n;
 	struct oz_hcd *ozhcd = oz_hcd_claim();
 
 	if (ozhcd == NULL)
 		return;
 	spin_lock_irqsave(&g_tasklet_lock, irq_state);
-	while (!list_empty(&ozhcd->urb_cancel_list)) {
-		struct oz_urb_link *urbl =
-			list_first_entry(&ozhcd->urb_cancel_list,
-				struct oz_urb_link, link);
+	list_for_each_entry_safe(urbl, n, &ozhcd->urb_cancel_list, link) {
 		list_del_init(&urbl->link);
 		spin_unlock_irqrestore(&g_tasklet_lock, irq_state);
 		urb = urbl->urb;
@@ -1722,11 +1691,9 @@ static void oz_urb_cancel_tasklet(unsigned long unused)
 static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status)
 {
 	if (ozhcd) {
-		struct oz_urb_link *urbl;
+		struct oz_urb_link *urbl, *n;
 
-		while (!list_empty(&ozhcd->orphanage)) {
-			urbl = list_first_entry(&ozhcd->orphanage,
-				struct oz_urb_link, link);
+		list_for_each_entry_safe(urbl, n, &ozhcd->orphanage, link) {
 			list_del(&urbl->link);
 			oz_complete_urb(ozhcd->hcd, urbl->urb, status);
 			oz_free_urb_link(urbl);
@@ -1824,14 +1791,13 @@ static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
 				struct urb *urb)
 {
 	struct oz_urb_link *urbl;
-	struct list_head *e;
 
 	if (unlikely(ep == NULL))
 		return NULL;
-	list_for_each(e, &ep->urb_list) {
-		urbl = container_of(e, struct oz_urb_link, link);
+
+	list_for_each_entry(urbl, &ep->urb_list, link) {
 		if (urbl->urb == urb) {
-			list_del_init(e);
+			list_del_init(&urbl->link);
 			if (usb_pipeisoc(urb->pipe)) {
 				ep->credit -= urb->number_of_packets;
 				if (ep->credit < 0)
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 8048ea3..0dc475e 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -137,10 +137,7 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
  */
 static void oz_pd_free(struct work_struct *work)
 {
-	struct list_head *e;
-	struct oz_tx_frame *f;
-	struct oz_isoc_stream *st;
-	struct oz_farewell *fwell;
+	struct list_head *e, *n;
 	struct oz_pd *pd;
 
 	oz_pd_dbg(pd, ON, "Destroying PD\n");
@@ -148,33 +145,24 @@ static void oz_pd_free(struct work_struct *work)
 	/*Disable timer tasklets*/
 	tasklet_kill(&pd->heartbeat_tasklet);
 	tasklet_kill(&pd->timeout_tasklet);
-	/* Delete any streams.
-	 */
-	e = pd->stream_list.next;
-	while (e != &pd->stream_list) {
-		st = container_of(e, struct oz_isoc_stream, link);
-		e = e->next;
-		oz_isoc_stream_free(st);
-	}
-	/* Free any queued tx frames.
-	 */
-	e = pd->tx_queue.next;
-	while (e != &pd->tx_queue) {
-		f = container_of(e, struct oz_tx_frame, link);
-		e = e->next;
+
+	/* Free streams, queued tx frames and farewells. */
+
+	list_for_each_safe(e, n, &pd->stream_list)
+		oz_isoc_stream_free(list_entry(e, struct oz_isoc_stream, link));
+
+	list_for_each_safe(e, n, &pd->tx_queue) {
+		struct oz_tx_frame *f = list_entry(e, struct oz_tx_frame, link);
 		if (f->skb != NULL)
 			kfree_skb(f->skb);
 		oz_retire_frame(pd, f);
 	}
+
 	oz_elt_buf_term(&pd->elt_buff);
-	/* Free any farewells.
-	 */
-	e = pd->farewell_list.next;
-	while (e != &pd->farewell_list) {
-		fwell = container_of(e, struct oz_farewell, link);
-		e = e->next;
-		kfree(fwell);
-	}
+
+	list_for_each_safe(e, n, &pd->farewell_list)
+		kfree(list_entry(e, struct oz_farewell, link));
+
 	if (pd->net_dev)
 		dev_put(pd->net_dev);
 	kfree(pd);
@@ -418,7 +406,7 @@ static struct sk_buff *oz_build_frame(struct oz_pd *pd, struct oz_tx_frame *f)
 	struct net_device *dev = pd->net_dev;
 	struct oz_hdr *oz_hdr;
 	struct oz_elt *elt;
-	struct list_head *e;
+	struct oz_elt_info *ei;
 
 	/* Allocate skb with enough space for the lower layers as well
 	 * as the space we need.
@@ -443,9 +431,7 @@ static struct sk_buff *oz_build_frame(struct oz_pd *pd, struct oz_tx_frame *f)
 	/* Copy the elements into the frame body.
 	 */
 	elt = (struct oz_elt *)(oz_hdr+1);
-	for (e = f->elt_list.next; e != &f->elt_list; e = e->next) {
-		struct oz_elt_info *ei;
-		ei = container_of(e, struct oz_elt_info, link);
+	list_for_each_entry(ei, &f->elt_list, link) {
 		memcpy(elt, ei->data, ei->length);
 		elt = oz_next_elt(elt);
 	}
@@ -460,13 +446,9 @@ fail:
  */
 static void oz_retire_frame(struct oz_pd *pd, struct oz_tx_frame *f)
 {
-	struct list_head *e;
-	struct oz_elt_info *ei;
+	struct oz_elt_info *ei, *n;
 
-	e = f->elt_list.next;
-	while (e != &f->elt_list) {
-		ei = container_of(e, struct oz_elt_info, link);
-		e = e->next;
+	list_for_each_entry_safe(ei, n, &f->elt_list, link) {
 		list_del_init(&ei->link);
 		if (ei->callback)
 			ei->callback(pd, ei->context);
@@ -492,7 +474,7 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 		spin_unlock(&pd->tx_frame_lock);
 		return -1;
 	}
-	f = container_of(e, struct oz_tx_frame, link);
+	f = list_entry(e, struct oz_tx_frame, link);
 
 	if (f->skb != NULL) {
 		skb = f->skb;
@@ -580,15 +562,13 @@ static int oz_send_isoc_frame(struct oz_pd *pd)
 	struct net_device *dev = pd->net_dev;
 	struct oz_hdr *oz_hdr;
 	struct oz_elt *elt;
-	struct list_head *e;
-	struct list_head list;
+	struct oz_elt_info *ei;
+	LIST_HEAD(list);
 	int total_size = sizeof(struct oz_hdr);
 
-	INIT_LIST_HEAD(&list);
-
 	oz_select_elts_for_tx(&pd->elt_buff, 1, &total_size,
 		pd->max_tx_size, &list);
-	if (list.next == &list)
+	if (list_empty(&list))
 		return 0;
 	skb = alloc_skb(total_size + OZ_ALLOCATED_SPACE(dev), GFP_ATOMIC);
 	if (skb == NULL) {
@@ -610,9 +590,7 @@ static int oz_send_isoc_frame(struct oz_pd *pd)
 	oz_hdr->last_pkt_num = pd->trigger_pkt_num & OZ_LAST_PN_MASK;
 	elt = (struct oz_elt *)(oz_hdr+1);
 
-	for (e = list.next; e != &list; e = e->next) {
-		struct oz_elt_info *ei;
-		ei = container_of(e, struct oz_elt_info, link);
+	list_for_each_entry(ei, &list, link) {
 		memcpy(elt, ei->data, ei->length);
 		elt = oz_next_elt(elt);
 	}
@@ -626,41 +604,30 @@ static int oz_send_isoc_frame(struct oz_pd *pd)
  */
 void oz_retire_tx_frames(struct oz_pd *pd, u8 lpn)
 {
-	struct list_head *e;
-	struct oz_tx_frame *f;
-	struct list_head *first = NULL;
-	struct list_head *last = NULL;
+	struct oz_tx_frame *f, *tmp = NULL;
 	u8 diff;
 	u32 pkt_num;
 
+	LIST_HEAD(list);
+
 	spin_lock(&pd->tx_frame_lock);
-	e = pd->tx_queue.next;
-	while (e != &pd->tx_queue) {
-		f = container_of(e, struct oz_tx_frame, link);
+	list_for_each_entry(f, &pd->tx_queue, link) {
 		pkt_num = le32_to_cpu(get_unaligned(&f->hdr.pkt_num));
 		diff = (lpn - (pkt_num & OZ_LAST_PN_MASK)) & OZ_LAST_PN_MASK;
 		if ((diff > OZ_LAST_PN_HALF_CYCLE) || (pkt_num == 0))
 			break;
 		oz_dbg(TX_FRAMES, "Releasing pkt_num= %u, nb= %d\n",
 		       pkt_num, pd->nb_queued_frames);
-		if (first == NULL)
-			first = e;
-		last = e;
-		e = e->next;
+		tmp = f;
 		pd->nb_queued_frames--;
 	}
-	if (first) {
-		last->next->prev = &pd->tx_queue;
-		pd->tx_queue.next = last->next;
-		last->next = NULL;
-	}
+	if (tmp)
+		list_cut_position(&list, &pd->tx_queue, &tmp->link);
 	pd->last_sent_frame = &pd->tx_queue;
 	spin_unlock(&pd->tx_frame_lock);
-	while (first) {
-		f = container_of(first, struct oz_tx_frame, link);
-		first = first->next;
+
+	list_for_each_entry_safe(f, tmp, &list, link)
 		oz_retire_frame(pd, f);
-	}
 }
 
 /*
@@ -669,11 +636,9 @@ void oz_retire_tx_frames(struct oz_pd *pd, u8 lpn)
  */
 static struct oz_isoc_stream *pd_stream_find(struct oz_pd *pd, u8 ep_num)
 {
-	struct list_head *e;
 	struct oz_isoc_stream *st;
 
-	list_for_each(e, &pd->stream_list) {
-		st = container_of(e, struct oz_isoc_stream, link);
+	list_for_each_entry(st, &pd->stream_list, link) {
 		if (st->ep_num == ep_num)
 			return st;
 	}
@@ -810,14 +775,11 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 			struct oz_tx_frame *isoc_unit = NULL;
 			int nb = pd->nb_queued_isoc_frames;
 			if (nb >= pd->isoc_latency) {
-				struct list_head *e;
 				struct oz_tx_frame *f;
 				oz_dbg(TX_FRAMES, "Dropping ISOC Unit nb= %d\n",
 				       nb);
 				spin_lock(&pd->tx_frame_lock);
-				list_for_each(e, &pd->tx_queue) {
-					f = container_of(e, struct oz_tx_frame,
-									link);
+				list_for_each_entry(f, &pd->tx_queue, link) {
 					if (f->skb != NULL) {
 						oz_tx_isoc_free(pd, f);
 						break;
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index c1fb442..fc010ae 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -185,7 +185,7 @@ static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
 		getnstimeofday(&pd->last_rx_timestamp);
 		spin_lock_bh(&g_polling_lock);
 		list_for_each(e, &g_pd_list) {
-			pd2 = container_of(e, struct oz_pd, link);
+			pd2 = list_entry(e, struct oz_pd, link);
 			if (ether_addr_equal(pd2->mac_addr, pd_addr)) {
 				free_pd = pd;
 				pd = pd2;
@@ -601,13 +601,11 @@ void oz_pd_request_heartbeat(struct oz_pd *pd)
 struct oz_pd *oz_pd_find(const u8 *mac_addr)
 {
 	struct oz_pd *pd;
-	struct list_head *e;
 
 	spin_lock_bh(&g_polling_lock);
-	list_for_each(e, &g_pd_list) {
-		pd = container_of(e, struct oz_pd, link);
+	list_for_each_entry(pd, &g_pd_list, link) {
 		if (ether_addr_equal(pd->mac_addr, mac_addr)) {
-			atomic_inc(&pd->ref_count);
+			oz_pd_get(pd);
 			spin_unlock_bh(&g_polling_lock);
 			return pd;
 		}
@@ -700,11 +698,10 @@ void oz_binding_add(const char *net_dev)
  */
 static void pd_stop_all_for_device(struct net_device *net_dev)
 {
-	struct list_head h;
+	LIST_HEAD(h);
 	struct oz_pd *pd;
 	struct oz_pd *n;
 
-	INIT_LIST_HEAD(&h);
 	spin_lock_bh(&g_polling_lock);
 	list_for_each_entry_safe(pd, n, &g_pd_list, link) {
 		if (pd->net_dev == net_dev) {
@@ -799,14 +796,12 @@ int oz_protocol_init(char *devs)
 int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
 {
 	struct oz_pd *pd;
-	struct list_head *e;
 	int count = 0;
 
 	spin_lock_bh(&g_polling_lock);
-	list_for_each(e, &g_pd_list) {
+	list_for_each_entry(pd, &g_pd_list, link) {
 		if (count >= max_count)
 			break;
-		pd = container_of(e, struct oz_pd, link);
 		ether_addr_copy((u8 *)&addr[count++], pd->mac_addr);
 	}
 	spin_unlock_bh(&g_polling_lock);
-- 
1.9.1

