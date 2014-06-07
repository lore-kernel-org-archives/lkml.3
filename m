Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaFGB0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:26:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36161 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbaFGBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alexander Duyck" <alexander.h.duyck@intel.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.542421898@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 25/92] skb: Add inline helper for getting the skb end
 offset  from head
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexander.h.duyck@intel.com>

[ Upstream commit ec47ea82477404631d49b8e568c71826c9b663ac ]

With the recent changes for how we compute the skb truesize it occurs to me
we are probably going to have a lot of calls to skb_end_pointer -
skb->head.  Instead of running all over the place doing that it would make
more sense to just make it a separate inline skb_end_offset(skb) that way
we can return the correct value without having gcc having to do all the
optimization to cancel out skb->head - skb->head.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/atm/ambassador.c             |  2 +-
 drivers/atm/idt77252.c               |  2 +-
 drivers/net/wimax/i2400m/usb-rx.c    |  2 +-
 drivers/staging/octeon/ethernet-tx.c |  2 +-
 include/linux/skbuff.h               | 12 +++++++++++-
 net/core/skbuff.c                    |  9 ++++-----
 6 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index f8f41e0..89b30f3 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -802,7 +802,7 @@ static void fill_rx_pool (amb_dev * dev, unsigned char pool,
     }
     // cast needed as there is no %? for pointer differences
     PRINTD (DBG_SKB, "allocated skb at %p, head %p, area %li",
-	    skb, skb->head, (long) (skb_end_pointer(skb) - skb->head));
+	    skb, skb->head, (long) skb_end_offset(skb));
     rx.handle = virt_to_bus (skb);
     rx.host_address = cpu_to_be32 (virt_to_bus (skb->data));
     if (rx_give (dev, &rx, pool))
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index b0e75ce..81845fa 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -1258,7 +1258,7 @@ idt77252_rx_raw(struct idt77252_dev *card)
 	tail = readl(SAR_REG_RAWCT);
 
 	pci_dma_sync_single_for_cpu(card->pcidev, IDT77252_PRV_PADDR(queue),
-				    skb_end_pointer(queue) - queue->head - 16,
+				    skb_end_offset(queue) - 16,
 				    PCI_DMA_FROMDEVICE);
 
 	while (head != tail) {
diff --git a/drivers/net/wimax/i2400m/usb-rx.c b/drivers/net/wimax/i2400m/usb-rx.c
index e325768..b78ee67 100644
--- a/drivers/net/wimax/i2400m/usb-rx.c
+++ b/drivers/net/wimax/i2400m/usb-rx.c
@@ -277,7 +277,7 @@ retry:
 		d_printf(1, dev, "RX: size changed to %d, received %d, "
 			 "copied %d, capacity %ld\n",
 			 rx_size, read_size, rx_skb->len,
-			 (long) (skb_end_pointer(new_skb) - new_skb->head));
+			 (long) skb_end_offset(new_skb));
 		goto retry;
 	}
 		/* In most cases, it happens due to the hardware scheduling a
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 2542c37..c5da0d2 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -344,7 +344,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 	if (unlikely
 	    (skb->truesize !=
-	     sizeof(*skb) + skb_end_pointer(skb) - skb->head)) {
+	     sizeof(*skb) + skb_end_offset(skb))) {
 		/*
 		   printk("TX buffer truesize has been changed\n");
 		 */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 13bd6d0..c445e52 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -617,11 +617,21 @@ static inline unsigned char *skb_end_pointer(const struct sk_buff *skb)
 {
 	return skb->head + skb->end;
 }
+
+static inline unsigned int skb_end_offset(const struct sk_buff *skb)
+{
+	return skb->end;
+}
 #else
 static inline unsigned char *skb_end_pointer(const struct sk_buff *skb)
 {
 	return skb->end;
 }
+
+static inline unsigned int skb_end_offset(const struct sk_buff *skb)
+{
+	return skb->end - skb->head;
+}
 #endif
 
 /* Internal */
@@ -2549,7 +2559,7 @@ static inline bool skb_is_recycleable(const struct sk_buff *skb, int skb_size)
 		return false;
 
 	skb_size = SKB_DATA_ALIGN(skb_size + NET_SKB_PAD);
-	if (skb_end_pointer(skb) - skb->head < skb_size)
+	if (skb_end_offset(skb) < skb_size)
 		return false;
 
 	if (skb_shared(skb) || skb_cloned(skb))
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8ae2e43..9204d9b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -743,7 +743,7 @@ static void copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
 {
 	int headerlen = skb_headroom(skb);
-	unsigned int size = (skb_end_pointer(skb) - skb->head) + skb->data_len;
+	unsigned int size = skb_end_offset(skb) + skb->data_len;
 	struct sk_buff *n = alloc_skb(size, gfp_mask);
 
 	if (!n)
@@ -843,7 +843,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 {
 	int i;
 	u8 *data;
-	int size = nhead + (skb_end_pointer(skb) - skb->head) + ntail;
+	int size = nhead + skb_end_offset(skb) + ntail;
 	long off;
 	bool fastpath;
 
@@ -2642,14 +2642,13 @@ struct sk_buff *skb_segment(struct sk_buff *skb, u32 features)
 			if (unlikely(!nskb))
 				goto err;
 
-			hsize = skb_end_pointer(nskb) - nskb->head;
+			hsize = skb_end_offset(nskb);
 			if (skb_cow_head(nskb, doffset + headroom)) {
 				kfree_skb(nskb);
 				goto err;
 			}
 
-			nskb->truesize += skb_end_pointer(nskb) - nskb->head -
-					  hsize;
+			nskb->truesize += skb_end_offset(nskb) - hsize;
 			skb_release_head_state(nskb);
 			__skb_push(nskb, doffset);
 		} else {

