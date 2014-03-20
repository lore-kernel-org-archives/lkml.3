Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311AbaCTTdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:33:00 -0400
Received: from smtp.citrix.com ([66.165.176.89]:44806 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbaCTTcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:32:55 -0400
X-IronPort-AV: E=Sophos;i="4.97,697,1389744000"; 
   d="scan'208";a="113403995"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>
CC: <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>,
        Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next] xen-netback: Follow-up patch for grant mapping series
Date: Thu, 20 Mar 2014 19:32:41 +0000
Message-ID: <1395343961-4744-2-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395343961-4744-1-git-send-email-zoltan.kiss@citrix.com>
References: <1395343961-4744-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian made some late comments about the grant mapping series, I incorporated the
outcomes into this patch. Additional comments, refactoring etc.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 6837bfc..fa19538 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -576,15 +576,15 @@ void xenvif_disconnect(struct xenvif *vif)
 void xenvif_free(struct xenvif *vif)
 {
 	int i, unmap_timeout = 0;
-	/* Here we want to avoid timeout messages if an skb can be legitimatly
-	 * stucked somewhere else. Realisticly this could be an another vif's
+	/* Here we want to avoid timeout messages if an skb can be legitimately
+	 * stuck somewhere else. Realistically this could be an another vif's
 	 * internal or QDisc queue. That another vif also has this
 	 * rx_drain_timeout_msecs timeout, but the timer only ditches the
 	 * internal queue. After that, the QDisc queue can put in worst case
 	 * XEN_NETIF_RX_RING_SIZE / MAX_SKB_FRAGS skbs into that another vif's
 	 * internal queue, so we need several rounds of such timeouts until we
 	 * can be sure that no another vif should have skb's from us. We are
-	 * not sending more skb's, so newly stucked packets are not interesting
+	 * not sending more skb's, so newly stuck packets are not interesting
 	 * for us here.
 	 */
 	unsigned int worst_case_skb_lifetime = (rx_drain_timeout_msecs/1000) *
@@ -599,6 +599,13 @@ void xenvif_free(struct xenvif *vif)
 				netdev_err(vif->dev,
 					   "Page still granted! Index: %x\n",
 					   i);
+			/* If there are still unmapped pages, reset the loop to
+			 * start mchecking again. We shouldn't exit here until
+			 * dealloc thread and NAPI instance release all the
+			 * pages. If a kernel bug cause the skbs stall
+			 * somewhere, the interface couldn't be brought down
+			 * properly.
+			 */
 			i = -1;
 		}
 	}
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1c336f6..0e46184b 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -56,7 +56,7 @@ bool separate_tx_rx_irq = 1;
 module_param(separate_tx_rx_irq, bool, 0644);
 
 /* When guest ring is filled up, qdisc queues the packets for us, but we have
- * to timeout them, otherwise other guests' packets can get stucked there
+ * to timeout them, otherwise other guests' packets can get stuck there
  */
 unsigned int rx_drain_timeout_msecs = 10000;
 module_param(rx_drain_timeout_msecs, uint, 0444);
@@ -99,6 +99,9 @@ static inline unsigned long idx_to_kaddr(struct xenvif *vif,
 	return (unsigned long)pfn_to_kaddr(idx_to_pfn(vif, idx));
 }
 
+#define callback_param(vif, pending_idx) \
+	(vif->pending_tx_info[pending_idx].callback_struct)
+
 /* Find the containing VIF's structure from a pointer in pending_tx_info array
  */
 static inline struct xenvif* ubuf_to_vif(struct ubuf_info *ubuf)
@@ -1025,12 +1028,12 @@ static void xenvif_fill_frags(struct xenvif *vif, struct sk_buff *skb)
 		/* If this is not the first frag, chain it to the previous*/
 		if (unlikely(prev_pending_idx == INVALID_PENDING_IDX))
 			skb_shinfo(skb)->destructor_arg =
-				&vif->pending_tx_info[pending_idx].callback_struct;
+				&callback_param(vif, pending_idx);
 		else if (likely(pending_idx != prev_pending_idx))
-			vif->pending_tx_info[prev_pending_idx].callback_struct.ctx =
-				&(vif->pending_tx_info[pending_idx].callback_struct);
+			callback_param(vif, prev_pending_idx).ctx =
+				&callback_param(vif, pending_idx);
 
-		vif->pending_tx_info[pending_idx].callback_struct.ctx = NULL;
+		callback_param(vif, pending_idx).ctx = NULL;
 		prev_pending_idx = pending_idx;
 
 		txp = &vif->pending_tx_info[pending_idx].req;
@@ -1400,13 +1403,13 @@ static int xenvif_tx_submit(struct xenvif *vif)
 		memcpy(skb->data,
 		       (void *)(idx_to_kaddr(vif, pending_idx)|txp->offset),
 		       data_len);
-		vif->pending_tx_info[pending_idx].callback_struct.ctx = NULL;
+		callback_param(vif, pending_idx).ctx = NULL;
 		if (data_len < txp->size) {
 			/* Append the packet payload as a fragment. */
 			txp->offset += data_len;
 			txp->size -= data_len;
 			skb_shinfo(skb)->destructor_arg =
-				&vif->pending_tx_info[pending_idx].callback_struct;
+				&callback_param(vif, pending_idx);
 		} else {
 			/* Schedule a response immediately. */
 			xenvif_idx_unmap(vif, pending_idx);
@@ -1550,7 +1553,6 @@ static inline void xenvif_tx_dealloc_action(struct xenvif *vif)
 					    idx_to_kaddr(vif, pending_idx),
 					    GNTMAP_host_map,
 					    vif->grant_tx_handle[pending_idx]);
-			/* Btw. already unmapped? */
 			xenvif_grant_handle_reset(vif, pending_idx);
 			++gop;
 		}
@@ -1683,12 +1685,20 @@ void xenvif_idx_unmap(struct xenvif *vif, u16 pending_idx)
 			    idx_to_kaddr(vif, pending_idx),
 			    GNTMAP_host_map,
 			    vif->grant_tx_handle[pending_idx]);
-	/* Btw. already unmapped? */
 	xenvif_grant_handle_reset(vif, pending_idx);
 
 	ret = gnttab_unmap_refs(&tx_unmap_op, NULL,
 				&vif->mmap_pages[pending_idx], 1);
-	BUG_ON(ret);
+	if (ret) {
+		netdev_err(vif->dev,
+			   "Unmap fail: ret: %d pending_idx: %d host_addr: %llx handle: %x status: %d\n",
+			   ret,
+			   pending_idx,
+			   tx_unmap_op.host_addr,
+			   tx_unmap_op.handle,
+			   tx_unmap_op.status);
+		BUG();
+	}
 
 	xenvif_idx_release(vif, pending_idx, XEN_NETIF_RSP_OKAY);
 }
