Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaCYAAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:00:34 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:17834 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaCYAAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:00:32 -0400
X-IronPort-AV: E=Sophos;i="4.97,723,1389744000"; 
   d="scan'208";a="113177681"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>
CC: <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>,
        Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next v3 2/3] xen-netback: Non-functional follow-up patch for grant mapping series
Date: Mon, 24 Mar 2014 23:59:50 +0000
Message-ID: <1395705591-23976-2-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395705591-23976-1-git-send-email-zoltan.kiss@citrix.com>
References: <1395705591-23976-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian made some late comments about the grant mapping series, I incorporated the
non-functional outcomes into this patch:

- typo fixes in a comment of xenvif_free(), and add another one there as well
- typo fix for comment of rx_drain_timeout_msecs
- remove stale comment before calling xenvif_grant_handle_reset()

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
v2:
- expand commit message and split this into 2 patch
- fix typos

v3: Change the subject

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index e71fb1a..cdc298e 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -574,15 +574,15 @@ void xenvif_disconnect(struct xenvif *vif)
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
@@ -597,6 +597,13 @@ void xenvif_free(struct xenvif *vif)
 				netdev_err(vif->dev,
 					   "Page still granted! Index: %x\n",
 					   i);
+			/* If there are still unmapped pages, reset the loop to
+			 * start checking again. We shouldn't exit here until
+			 * dealloc thread and NAPI instance release all the
+			 * pages. If a kernel bug causes the skbs to stall
+			 * somewhere, the interface cannot be brought down
+			 * properly.
+			 */
 			i = -1;
 		}
 	}
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index f5c440b..684c10b 100644
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
@@ -1545,7 +1545,6 @@ static inline void xenvif_tx_dealloc_action(struct xenvif *vif)
 					    idx_to_kaddr(vif, pending_idx),
 					    GNTMAP_host_map,
 					    vif->grant_tx_handle[pending_idx]);
-			/* Btw. already unmapped? */
 			xenvif_grant_handle_reset(vif, pending_idx);
 			++gop;
 		}
@@ -1678,7 +1677,6 @@ void xenvif_idx_unmap(struct xenvif *vif, u16 pending_idx)
 			    idx_to_kaddr(vif, pending_idx),
 			    GNTMAP_host_map,
 			    vif->grant_tx_handle[pending_idx]);
-	/* Btw. already unmapped? */
 	xenvif_grant_handle_reset(vif, pending_idx);
 
 	ret = gnttab_unmap_refs(&tx_unmap_op, NULL,
