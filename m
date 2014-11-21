Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaKUSOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:14:54 -0500
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:38609 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751014AbaKUSOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:14:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:327:355:379:541:599:960:965:966:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2559:2562:2693:2729:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4225:4250:4321:4385:4390:4395:4605:5007:6119:6261:7875:7903:8603:9010:9040:10004:10848:11026:11232:11233:11473:11658:11914:12043:12291:12294:12296:12438:12517:12519:12555:12679:12683:12740:13255:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dock81_6451c017b7657
X-Filterd-Recvd-Size: 23748
Message-ID: <1416593688.6651.39.camel@perches.com>
Subject: Re: thunderbolt: Deletion of unnecessary checks before the function
 call "ring_free"
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Fri, 21 Nov 2014 10:14:48 -0800
In-Reply-To: <546F2E50.5040804@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <546F16A5.8030405@users.sourceforge.net>
	 <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com>
	 <546F2E50.5040804@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 13:21 +0100, SF Markus Elfring wrote:
> 2. Are any additional prefixes appropriate so that further name space
>    conflicts can be better avoided?

To avoid possible external naming conflicts, add tb_ prefix to
various ring_<foo> structs and functions.

Other miscellanea:

o typo/spelling fixes (releated/related, loose/lose)
o argument alignment
o comment formatting

---
Perhaps something like this?

unsigned/compiled/untested

 drivers/thunderbolt/ctl.c      |  41 ++++++-------
 drivers/thunderbolt/nhi.c      | 133 +++++++++++++++++++++--------------------
 drivers/thunderbolt/nhi.h      |  47 ++++++++-------
 drivers/thunderbolt/nhi_regs.h |  16 ++---
 4 files changed, 121 insertions(+), 116 deletions(-)

diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index 799634b..52783e0 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -17,7 +17,7 @@
 struct ctl_pkg {
 	struct tb_ctl *ctl;
 	void *buffer;
-	struct ring_frame frame;
+	struct tb_ring_frame frame;
 };
 
 #define TB_CTL_RX_PKG_COUNT 10
@@ -319,8 +319,8 @@ static struct ctl_pkg *tb_ctl_pkg_alloc(struct tb_ctl *ctl)
 
 /* RX/TX handling */
 
-static void tb_ctl_tx_callback(struct tb_ring *ring, struct ring_frame *frame,
-			       bool canceled)
+static void tb_ctl_tx_callback(struct tb_ring *ring,
+			       struct tb_ring_frame *frame, bool canceled)
 {
 	struct ctl_pkg *pkg = container_of(frame, typeof(*pkg), frame);
 	tb_ctl_pkg_free(pkg);
@@ -357,7 +357,7 @@ static int tb_ctl_tx(struct tb_ctl *ctl, void *data, size_t len,
 	cpu_to_be32_array(pkg->buffer, data, len / 4);
 	*(__be32 *) (pkg->buffer + len) = tb_crc(pkg->buffer, len);
 
-	res = ring_tx(ctl->tx, &pkg->frame);
+	res = tb_ring_tx(ctl->tx, &pkg->frame);
 	if (res) /* ring is stopped */
 		tb_ctl_pkg_free(pkg);
 	return res;
@@ -386,16 +386,16 @@ static void tb_ctl_handle_plug_event(struct tb_ctl *ctl,
 
 static void tb_ctl_rx_submit(struct ctl_pkg *pkg)
 {
-	ring_rx(pkg->ctl->rx, &pkg->frame); /*
-					     * We ignore failures during stop.
-					     * All rx packets are referenced
-					     * from ctl->rx_packets, so we do
-					     * not loose them.
-					     */
+	tb_ring_rx(pkg->ctl->rx, &pkg->frame);
+	/*
+	 * We ignore failures during stop.
+	 * All rx packets are referenced from ctl->rx_packets,
+	 * so we do not lose them.
+	 */
 }
 
-static void tb_ctl_rx_callback(struct tb_ring *ring, struct ring_frame *frame,
-			       bool canceled)
+static void tb_ctl_rx_callback(struct tb_ring *ring,
+			       struct tb_ring_frame *frame, bool canceled)
 {
 	struct ctl_pkg *pkg = container_of(frame, typeof(*pkg), frame);
 
@@ -488,11 +488,11 @@ struct tb_ctl *tb_ctl_alloc(struct tb_nhi *nhi, hotplug_cb cb, void *cb_data)
 	if (!ctl->frame_pool)
 		goto err;
 
-	ctl->tx = ring_alloc_tx(nhi, 0, 10);
+	ctl->tx = tb_ring_alloc_tx(nhi, 0, 10);
 	if (!ctl->tx)
 		goto err;
 
-	ctl->rx = ring_alloc_rx(nhi, 0, 10);
+	ctl->rx = tb_ring_alloc_rx(nhi, 0, 10);
 	if (!ctl->rx)
 		goto err;
 
@@ -521,9 +521,9 @@ void tb_ctl_free(struct tb_ctl *ctl)
 {
 	int i;
 	if (ctl->rx)
-		ring_free(ctl->rx);
+		tb_ring_free(ctl->rx);
 	if (ctl->tx)
-		ring_free(ctl->tx);
+		tb_ring_free(ctl->tx);
 
 	/* free RX packets */
 	for (i = 0; i < TB_CTL_RX_PKG_COUNT; i++)
@@ -542,8 +542,9 @@ void tb_ctl_start(struct tb_ctl *ctl)
 {
 	int i;
 	tb_ctl_info(ctl, "control channel starting...\n");
-	ring_start(ctl->tx); /* is used to ack hotplug packets, start first */
-	ring_start(ctl->rx);
+	/* is used to ack hotplug packets, start first */
+	tb_ring_start(ctl->tx);
+	tb_ring_start(ctl->rx);
 	for (i = 0; i < TB_CTL_RX_PKG_COUNT; i++)
 		tb_ctl_rx_submit(ctl->rx_packets[i]);
 }
@@ -558,8 +559,8 @@ void tb_ctl_start(struct tb_ctl *ctl)
  */
 void tb_ctl_stop(struct tb_ctl *ctl)
 {
-	ring_stop(ctl->rx);
-	ring_stop(ctl->tx);
+	tb_ring_stop(ctl->rx);
+	tb_ring_stop(ctl->tx);
 
 	if (!kfifo_is_empty(&ctl->response_fifo))
 		tb_ctl_WARN(ctl, "dangling response in response_fifo\n");
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index c68fe12..552683f 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -22,7 +22,7 @@
 #define RING_TYPE(ring) ((ring)->is_tx ? "TX ring" : "RX ring")
 
 
-static int ring_interrupt_index(struct tb_ring *ring)
+static int tb_ring_interrupt_index(struct tb_ring *ring)
 {
 	int bit = ring->hop;
 	if (!ring->is_tx)
@@ -31,14 +31,14 @@ static int ring_interrupt_index(struct tb_ring *ring)
 }
 
 /**
- * ring_interrupt_active() - activate/deactivate interrupts for a single ring
+ * tb_ring_interrupt_active() - activate/deactivate interrupts for a single ring
  *
  * ring->nhi->lock must be held.
  */
-static void ring_interrupt_active(struct tb_ring *ring, bool active)
+static void tb_ring_interrupt_active(struct tb_ring *ring, bool active)
 {
-	int reg = REG_RING_INTERRUPT_BASE + ring_interrupt_index(ring) / 32;
-	int bit = ring_interrupt_index(ring) & 31;
+	int reg = REG_RING_INTERRUPT_BASE + tb_ring_interrupt_index(ring) / 32;
+	int bit = tb_ring_interrupt_index(ring) & 31;
 	int mask = 1 << bit;
 	u32 old, new;
 	old = ioread32(ring->nhi->iobase + reg);
@@ -78,7 +78,7 @@ static void nhi_disable_interrupts(struct tb_nhi *nhi)
 
 /* ring helper methods */
 
-static void __iomem *ring_desc_base(struct tb_ring *ring)
+static void __iomem *tb_ring_desc_base(struct tb_ring *ring)
 {
 	void __iomem *io = ring->nhi->iobase;
 	io += ring->is_tx ? REG_TX_RING_BASE : REG_RX_RING_BASE;
@@ -86,7 +86,7 @@ static void __iomem *ring_desc_base(struct tb_ring *ring)
 	return io;
 }
 
-static void __iomem *ring_options_base(struct tb_ring *ring)
+static void __iomem *tb_ring_options_base(struct tb_ring *ring)
 {
 	void __iomem *io = ring->nhi->iobase;
 	io += ring->is_tx ? REG_TX_OPTIONS_BASE : REG_RX_OPTIONS_BASE;
@@ -94,48 +94,49 @@ static void __iomem *ring_options_base(struct tb_ring *ring)
 	return io;
 }
 
-static void ring_iowrite16desc(struct tb_ring *ring, u32 value, u32 offset)
+static void tb_ring_iowrite16desc(struct tb_ring *ring, u32 value, u32 offset)
 {
-	iowrite16(value, ring_desc_base(ring) + offset);
+	iowrite16(value, tb_ring_desc_base(ring) + offset);
 }
 
-static void ring_iowrite32desc(struct tb_ring *ring, u32 value, u32 offset)
+static void tb_ring_iowrite32desc(struct tb_ring *ring, u32 value, u32 offset)
 {
-	iowrite32(value, ring_desc_base(ring) + offset);
+	iowrite32(value, tb_ring_desc_base(ring) + offset);
 }
 
-static void ring_iowrite64desc(struct tb_ring *ring, u64 value, u32 offset)
+static void tb_ring_iowrite64desc(struct tb_ring *ring, u64 value, u32 offset)
 {
-	iowrite32(value, ring_desc_base(ring) + offset);
-	iowrite32(value >> 32, ring_desc_base(ring) + offset + 4);
+	iowrite32(value, tb_ring_desc_base(ring) + offset);
+	iowrite32(value >> 32, tb_ring_desc_base(ring) + offset + 4);
 }
 
-static void ring_iowrite32options(struct tb_ring *ring, u32 value, u32 offset)
+static void tb_ring_iowrite32options(struct tb_ring *ring, u32 value,
+				     u32 offset)
 {
-	iowrite32(value, ring_options_base(ring) + offset);
+	iowrite32(value, tb_ring_options_base(ring) + offset);
 }
 
-static bool ring_full(struct tb_ring *ring)
+static bool tb_ring_full(struct tb_ring *ring)
 {
 	return ((ring->head + 1) % ring->size) == ring->tail;
 }
 
-static bool ring_empty(struct tb_ring *ring)
+static bool tb_ring_empty(struct tb_ring *ring)
 {
 	return ring->head == ring->tail;
 }
 
 /**
- * ring_write_descriptors() - post frames from ring->queue to the controller
+ * tb_ring_write_descriptors() - post frames from ring->queue to the controller
  *
  * ring->lock is held.
  */
-static void ring_write_descriptors(struct tb_ring *ring)
+static void tb_ring_write_descriptors(struct tb_ring *ring)
 {
-	struct ring_frame *frame, *n;
-	struct ring_desc *descriptor;
+	struct tb_ring_frame *frame, *n;
+	struct tb_ring_desc *descriptor;
 	list_for_each_entry_safe(frame, n, &ring->queue, list) {
-		if (ring_full(ring))
+		if (tb_ring_full(ring))
 			break;
 		list_move_tail(&frame->list, &ring->in_flight);
 		descriptor = &ring->descriptors[ring->head];
@@ -148,12 +149,12 @@ static void ring_write_descriptors(struct tb_ring *ring)
 			descriptor->sof = frame->sof;
 		}
 		ring->head = (ring->head + 1) % ring->size;
-		ring_iowrite16desc(ring, ring->head, ring->is_tx ? 10 : 8);
+		tb_ring_iowrite16desc(ring, ring->head, ring->is_tx ? 10 : 8);
 	}
 }
 
 /**
- * ring_work() - progress completed frames
+ * tb_ring_work() - progress completed frames
  *
  * If the ring is shutting down then all frames are marked as canceled and
  * their callbacks are invoked.
@@ -161,10 +162,10 @@ static void ring_write_descriptors(struct tb_ring *ring)
  * Otherwise we collect all completed frame from the ring buffer, write new
  * frame to the ring buffer and invoke the callbacks for the completed frames.
  */
-static void ring_work(struct work_struct *work)
+static void tb_ring_work(struct work_struct *work)
 {
 	struct tb_ring *ring = container_of(work, typeof(*ring), work);
-	struct ring_frame *frame;
+	struct tb_ring_frame *frame;
 	bool canceled = false;
 	LIST_HEAD(done);
 	mutex_lock(&ring->lock);
@@ -177,7 +178,7 @@ static void ring_work(struct work_struct *work)
 		goto invoke_callback;
 	}
 
-	while (!ring_empty(ring)) {
+	while (!tb_ring_empty(ring)) {
 		if (!(ring->descriptors[ring->tail].flags
 				& RING_DESC_COMPLETED))
 			break;
@@ -209,7 +210,7 @@ static void ring_work(struct work_struct *work)
 		}
 		ring->tail = (ring->tail + 1) % ring->size;
 	}
-	ring_write_descriptors(ring);
+	tb_ring_write_descriptors(ring);
 
 invoke_callback:
 	mutex_unlock(&ring->lock); /* allow callbacks to schedule new work */
@@ -224,13 +225,13 @@ invoke_callback:
 	}
 }
 
-int __ring_enqueue(struct tb_ring *ring, struct ring_frame *frame)
+int __tb_ring_enqueue(struct tb_ring *ring, struct tb_ring_frame *frame)
 {
 	int ret = 0;
 	mutex_lock(&ring->lock);
 	if (ring->running) {
 		list_add_tail(&frame->list, &ring->queue);
-		ring_write_descriptors(ring);
+		tb_ring_write_descriptors(ring);
 	} else {
 		ret = -ESHUTDOWN;
 	}
@@ -238,8 +239,8 @@ int __ring_enqueue(struct tb_ring *ring, struct ring_frame *frame)
 	return ret;
 }
 
-static struct tb_ring *ring_alloc(struct tb_nhi *nhi, u32 hop, int size,
-				  bool transmit)
+static struct tb_ring *tb_ring_alloc(struct tb_nhi *nhi, u32 hop, int size,
+				     bool transmit)
 {
 	struct tb_ring *ring = NULL;
 	dev_info(&nhi->pdev->dev, "allocating %s ring %d of size %d\n",
@@ -264,7 +265,7 @@ static struct tb_ring *ring_alloc(struct tb_nhi *nhi, u32 hop, int size,
 	mutex_init(&ring->lock);
 	INIT_LIST_HEAD(&ring->queue);
 	INIT_LIST_HEAD(&ring->in_flight);
-	INIT_WORK(&ring->work, ring_work);
+	INIT_WORK(&ring->work, tb_ring_work);
 
 	ring->nhi = nhi;
 	ring->hop = hop;
@@ -294,22 +295,22 @@ err:
 	return NULL;
 }
 
-struct tb_ring *ring_alloc_tx(struct tb_nhi *nhi, int hop, int size)
+struct tb_ring *tb_ring_alloc_tx(struct tb_nhi *nhi, int hop, int size)
 {
-	return ring_alloc(nhi, hop, size, true);
+	return tb_ring_alloc(nhi, hop, size, true);
 }
 
-struct tb_ring *ring_alloc_rx(struct tb_nhi *nhi, int hop, int size)
+struct tb_ring *tb_ring_alloc_rx(struct tb_nhi *nhi, int hop, int size)
 {
-	return ring_alloc(nhi, hop, size, false);
+	return tb_ring_alloc(nhi, hop, size, false);
 }
 
 /**
- * ring_start() - enable a ring
+ * tb_ring_start() - enable a ring
  *
- * Must not be invoked in parallel with ring_stop().
+ * Must not be invoked in parallel with tb_ring_stop().
  */
-void ring_start(struct tb_ring *ring)
+void tb_ring_start(struct tb_ring *ring)
 {
 	mutex_lock(&ring->nhi->lock);
 	mutex_lock(&ring->lock);
@@ -320,20 +321,21 @@ void ring_start(struct tb_ring *ring)
 	dev_info(&ring->nhi->pdev->dev, "starting %s %d\n",
 		 RING_TYPE(ring), ring->hop);
 
-	ring_iowrite64desc(ring, ring->descriptors_dma, 0);
+	tb_ring_iowrite64desc(ring, ring->descriptors_dma, 0);
 	if (ring->is_tx) {
-		ring_iowrite32desc(ring, ring->size, 12);
-		ring_iowrite32options(ring, 0, 4); /* time releated ? */
-		ring_iowrite32options(ring,
-				      RING_FLAG_ENABLE | RING_FLAG_RAW, 0);
+		tb_ring_iowrite32desc(ring, ring->size, 12);
+		tb_ring_iowrite32options(ring, 0, 4); /* time related ? */
+		tb_ring_iowrite32options(ring,
+					 RING_FLAG_ENABLE | RING_FLAG_RAW, 0);
 	} else {
-		ring_iowrite32desc(ring,
-				   (TB_FRAME_SIZE << 16) | ring->size, 12);
-		ring_iowrite32options(ring, 0xffffffff, 4); /* SOF EOF mask */
-		ring_iowrite32options(ring,
-				      RING_FLAG_ENABLE | RING_FLAG_RAW, 0);
+		tb_ring_iowrite32desc(ring,
+				      (TB_FRAME_SIZE << 16) | ring->size, 12);
+		/* SOF EOF mask */
+		tb_ring_iowrite32options(ring, 0xffffffff, 4);
+		tb_ring_iowrite32options(ring,
+					 RING_FLAG_ENABLE | RING_FLAG_RAW, 0);
 	}
-	ring_interrupt_active(ring, true);
+	tb_ring_interrupt_active(ring, true);
 	ring->running = true;
 err:
 	mutex_unlock(&ring->lock);
@@ -342,18 +344,19 @@ err:
 
 
 /**
- * ring_stop() - shutdown a ring
+ * tb_ring_stop() - shutdown a ring
  *
  * Must not be invoked from a callback.
  *
- * This method will disable the ring. Further calls to ring_tx/ring_rx will
- * return -ESHUTDOWN until ring_stop has been called.
+ * This method will disable the ring.
+ * Further calls to tb_ring_tx/tb_ring_rx will return -ESHUTDOWN
+ * until tb_ring_stop has been called.
  *
  * All enqueued frames will be canceled and their callbacks will be executed
  * with frame->canceled set to true (on the callback thread). This method
  * returns only after all callback invocations have finished.
  */
-void ring_stop(struct tb_ring *ring)
+void tb_ring_stop(struct tb_ring *ring)
 {
 	mutex_lock(&ring->nhi->lock);
 	mutex_lock(&ring->lock);
@@ -364,12 +367,12 @@ void ring_stop(struct tb_ring *ring)
 			 RING_TYPE(ring), ring->hop);
 		goto err;
 	}
-	ring_interrupt_active(ring, false);
+	tb_ring_interrupt_active(ring, false);
 
-	ring_iowrite32options(ring, 0, 0);
-	ring_iowrite64desc(ring, 0, 0);
-	ring_iowrite16desc(ring, 0, ring->is_tx ? 10 : 8);
-	ring_iowrite32desc(ring, 0, 12);
+	tb_ring_iowrite32options(ring, 0, 0);
+	tb_ring_iowrite64desc(ring, 0, 0);
+	tb_ring_iowrite16desc(ring, 0, ring->is_tx ? 10 : 8);
+	tb_ring_iowrite32desc(ring, 0, 12);
 	ring->head = 0;
 	ring->tail = 0;
 	ring->running = false;
@@ -386,16 +389,16 @@ err:
 }
 
 /*
- * ring_free() - free ring
+ * tb_ring_free() - free ring
  *
  * When this method returns all invocations of ring->callback will have
  * finished.
  *
  * Ring must be stopped.
  *
- * Must NOT be called from ring_frame->callback!
+ * Must NOT be called from tb_ring_frame->callback!
  */
-void ring_free(struct tb_ring *ring)
+void tb_ring_free(struct tb_ring *ring)
 {
 	mutex_lock(&ring->nhi->lock);
 	/*
@@ -428,7 +431,7 @@ void ring_free(struct tb_ring *ring)
 	mutex_unlock(&ring->nhi->lock);
 	/**
 	 * ring->work can no longer be scheduled (it is scheduled only by
-	 * nhi_interrupt_work and ring_stop). Wait for it to finish before
+	 * nhi_interrupt_work and tb_ring_stop). Wait for it to finish before
 	 * freeing the ring.
 	 */
 	flush_work(&ring->work);
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 3172429..98f57d5 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -37,7 +37,7 @@ struct tb_ring {
 	int hop;
 	int head; /* write next descriptor here */
 	int tail; /* complete next descriptor here */
-	struct ring_desc *descriptors;
+	struct tb_ring_desc *descriptors;
 	dma_addr_t descriptors_dma;
 	struct list_head queue;
 	struct list_head in_flight;
@@ -46,15 +46,16 @@ struct tb_ring {
 	bool running:1;
 };
 
-struct ring_frame;
-typedef void (*ring_cb)(struct tb_ring*, struct ring_frame*, bool canceled);
+struct tb_ring_frame;
+typedef void (*tb_ring_cb)(struct tb_ring *ring, struct tb_ring_frame *frame,
+			   bool canceled);
 
 /**
- * struct ring_frame - for use with ring_rx/ring_tx
+ * struct tb_ring_frame - for use with tb_ring_rx/tb_ring_tx
  */
-struct ring_frame {
+struct tb_ring_frame {
 	dma_addr_t buffer_phy;
-	ring_cb callback;
+	tb_ring_cb callback;
 	struct list_head list;
 	u32 size:12; /* TX: in, RX: out*/
 	u32 flags:12; /* RX: out */
@@ -62,18 +63,18 @@ struct ring_frame {
 	u32 sof:4; /* TX:in, RX: out */
 };
 
-#define TB_FRAME_SIZE 0x100    /* minimum size for ring_rx */
+#define TB_FRAME_SIZE 0x100    /* minimum size for tb_ring_rx */
 
-struct tb_ring *ring_alloc_tx(struct tb_nhi *nhi, int hop, int size);
-struct tb_ring *ring_alloc_rx(struct tb_nhi *nhi, int hop, int size);
-void ring_start(struct tb_ring *ring);
-void ring_stop(struct tb_ring *ring);
-void ring_free(struct tb_ring *ring);
+struct tb_ring *tb_ring_alloc_tx(struct tb_nhi *nhi, int hop, int size);
+struct tb_ring *tb_ring_alloc_rx(struct tb_nhi *nhi, int hop, int size);
+void tb_ring_start(struct tb_ring *ring);
+void tb_ring_stop(struct tb_ring *ring);
+void tb_ring_free(struct tb_ring *ring);
 
-int __ring_enqueue(struct tb_ring *ring, struct ring_frame *frame);
+int __tb_ring_enqueue(struct tb_ring *ring, struct tb_ring_frame *frame);
 
 /**
- * ring_rx() - enqueue a frame on an RX ring
+ * tb_ring_rx() - enqueue a frame on an RX ring
  *
  * frame->buffer, frame->buffer_phy and frame->callback have to be set. The
  * buffer must contain at least TB_FRAME_SIZE bytes.
@@ -81,34 +82,34 @@ int __ring_enqueue(struct tb_ring *ring, struct ring_frame *frame);
  * frame->callback will be invoked with frame->size, frame->flags, frame->eof,
  * frame->sof set once the frame has been received.
  *
- * If ring_stop is called after the packet has been enqueued frame->callback
+ * If tb_ring_stop is called after the packet has been enqueued frame->callback
  * will be called with canceled set to true.
  *
- * Return: Returns ESHUTDOWN if ring_stop has been called. Zero otherwise.
+ * Return: Returns ESHUTDOWN if tb_ring_stop has been called. Zero otherwise.
  */
-static inline int ring_rx(struct tb_ring *ring, struct ring_frame *frame)
+static inline int tb_ring_rx(struct tb_ring *ring, struct tb_ring_frame *frame)
 {
 	WARN_ON(ring->is_tx);
-	return __ring_enqueue(ring, frame);
+	return __tb_ring_enqueue(ring, frame);
 }
 
 /**
- * ring_tx() - enqueue a frame on an TX ring
+ * tb_ring_tx() - enqueue a frame on an TX ring
  *
  * frame->buffer, frame->buffer_phy, frame->callback, frame->size, frame->eof
  * and frame->sof have to be set.
  *
  * frame->callback will be invoked with once the frame has been transmitted.
  *
- * If ring_stop is called after the packet has been enqueued frame->callback
+ * If tb_ring_stop is called after the packet has been enqueued frame->callback
  * will be called with canceled set to true.
  *
- * Return: Returns ESHUTDOWN if ring_stop has been called. Zero otherwise.
+ * Return: Returns ESHUTDOWN if tb_ring_stop has been called. Zero otherwise.
  */
-static inline int ring_tx(struct tb_ring *ring, struct ring_frame *frame)
+static inline int tb_ring_tx(struct tb_ring *ring, struct tb_ring_frame *frame)
 {
 	WARN_ON(!ring->is_tx);
-	return __ring_enqueue(ring, frame);
+	return __tb_ring_enqueue(ring, frame);
 }
 
 #endif
diff --git a/drivers/thunderbolt/nhi_regs.h b/drivers/thunderbolt/nhi_regs.h
index 86b996c..23b7059 100644
--- a/drivers/thunderbolt/nhi_regs.h
+++ b/drivers/thunderbolt/nhi_regs.h
@@ -9,7 +9,7 @@
 
 #include <linux/types.h>
 
-enum ring_flags {
+enum tb_ring_flags {
 	RING_FLAG_ISOCH_ENABLE = 1 << 27, /* TX only? */
 	RING_FLAG_E2E_FLOW_CONTROL = 1 << 28,
 	RING_FLAG_PCI_NO_SNOOP = 1 << 29,
@@ -17,7 +17,7 @@ enum ring_flags {
 	RING_FLAG_ENABLE = 1 << 31,
 };
 
-enum ring_desc_flags {
+enum tb_ring_desc_flags {
 	RING_DESC_ISOCH = 0x1, /* TX only? */
 	RING_DESC_COMPLETED = 0x2, /* set by NHI */
 	RING_DESC_POSTED = 0x4, /* always set this */
@@ -25,17 +25,17 @@ enum ring_desc_flags {
 };
 
 /**
- * struct ring_desc - TX/RX ring entry
+ * struct tb_ring_desc - TX/RX ring entry
  *
  * For TX set length/eof/sof.
  * For RX length/eof/sof are set by the NHI.
  */
-struct ring_desc {
+struct tb_ring_desc {
 	u64 phys;
 	u32 length:12;
 	u32 eof:4;
 	u32 sof:4;
-	enum ring_desc_flags flags:12;
+	enum tb_ring_desc_flags flags:12;
 	u32 time; /* write zero */
 } __packed;
 
@@ -43,7 +43,7 @@ struct ring_desc {
 
 /*
  * 16 bytes per entry, one entry for every hop (REG_HOP_COUNT)
- * 00: physical pointer to an array of struct ring_desc
+ * 00: physical pointer to an array of struct tb_ring_desc
  * 08: ring tail (set by NHI)
  * 10: ring head (index of first non posted descriptor)
  * 12: descriptor count
@@ -52,7 +52,7 @@ struct ring_desc {
 
 /*
  * 16 bytes per entry, one entry for every hop (REG_HOP_COUNT)
- * 00: physical pointer to an array of struct ring_desc
+ * 00: physical pointer to an array of struct tb_ring_desc
  * 08: ring head (index of first not posted descriptor)
  * 10: ring tail (set by NHI)
  * 12: descriptor count
@@ -70,7 +70,7 @@ struct ring_desc {
 
 /*
  * 32 bytes per entry, one entry for every hop (REG_HOP_COUNT)
- * 00: enum ring_flags
+ * 00: enum tb_ring_flags
  *     If RING_FLAG_E2E_FLOW_CONTROL is set then bits 13-23 must be set to
  *     the corresponding TX hop id.
  * 04: EOF/SOF mask (ignored for RING_FLAG_RAW rings)


