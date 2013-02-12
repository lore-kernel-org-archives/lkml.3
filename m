Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3BLUgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:36:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3BLUgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Daley <mattjd@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 40/61] xen/netback: dont leak pages on failure in xen_netbk_tx_check_gop.
Date: Tue, 12 Feb 2013 12:35:00 -0800
Message-Id: <20130212203423.502488186@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Matthew Daley <mattjd@gmail.com>

[ Upstream commit 7d5145d8eb2b9791533ffe4dc003b129b9696c48 ]

Signed-off-by: Matthew Daley <mattjd@gmail.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -147,7 +147,8 @@ void xen_netbk_remove_xenvif(struct xenv
 	atomic_dec(&netbk->netfront_count);
 }
 
-static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx);
+static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
+				  u8 status);
 static void make_tx_response(struct xenvif *vif,
 			     struct xen_netif_tx_request *txp,
 			     s8       st);
@@ -1007,30 +1008,20 @@ static int xen_netbk_tx_check_gop(struct
 {
 	struct gnttab_copy *gop = *gopp;
 	u16 pending_idx = *((u16 *)skb->data);
-	struct pending_tx_info *pending_tx_info = netbk->pending_tx_info;
-	struct xenvif *vif = pending_tx_info[pending_idx].vif;
-	struct xen_netif_tx_request *txp;
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	int nr_frags = shinfo->nr_frags;
 	int i, err, start;
 
 	/* Check status of header. */
 	err = gop->status;
-	if (unlikely(err)) {
-		pending_ring_idx_t index;
-		index = pending_index(netbk->pending_prod++);
-		txp = &pending_tx_info[pending_idx].req;
-		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		netbk->pending_ring[index] = pending_idx;
-		xenvif_put(vif);
-	}
+	if (unlikely(err))
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
 
 	/* Skip first skb fragment if it is on same page as header fragment. */
 	start = (frag_get_pending_idx(&shinfo->frags[0]) == pending_idx);
 
 	for (i = start; i < nr_frags; i++) {
 		int j, newerr;
-		pending_ring_idx_t index;
 
 		pending_idx = frag_get_pending_idx(&shinfo->frags[i]);
 
@@ -1039,16 +1030,12 @@ static int xen_netbk_tx_check_gop(struct
 		if (likely(!newerr)) {
 			/* Had a previous error? Invalidate this fragment. */
 			if (unlikely(err))
-				xen_netbk_idx_release(netbk, pending_idx);
+				xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 			continue;
 		}
 
 		/* Error on this fragment: respond to client with an error. */
-		txp = &netbk->pending_tx_info[pending_idx].req;
-		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		index = pending_index(netbk->pending_prod++);
-		netbk->pending_ring[index] = pending_idx;
-		xenvif_put(vif);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
 
 		/* Not the first error? Preceding frags already invalidated. */
 		if (err)
@@ -1056,10 +1043,10 @@ static int xen_netbk_tx_check_gop(struct
 
 		/* First error: invalidate header and preceding fragments. */
 		pending_idx = *((u16 *)skb->data);
-		xen_netbk_idx_release(netbk, pending_idx);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		for (j = start; j < i; j++) {
 			pending_idx = frag_get_pending_idx(&shinfo->frags[j]);
-			xen_netbk_idx_release(netbk, pending_idx);
+			xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		}
 
 		/* Remember the error: invalidate all subsequent fragments. */
@@ -1093,7 +1080,7 @@ static void xen_netbk_fill_frags(struct
 
 		/* Take an extra reference to offset xen_netbk_idx_release */
 		get_page(netbk->mmap_pages[pending_idx]);
-		xen_netbk_idx_release(netbk, pending_idx);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 	}
 }
 
@@ -1476,7 +1463,7 @@ static void xen_netbk_tx_submit(struct x
 			txp->size -= data_len;
 		} else {
 			/* Schedule a response immediately. */
-			xen_netbk_idx_release(netbk, pending_idx);
+			xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		}
 
 		if (txp->flags & XEN_NETTXF_csum_blank)
@@ -1528,7 +1515,8 @@ static void xen_netbk_tx_action(struct x
 	xen_netbk_tx_submit(netbk);
 }
 
-static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx)
+static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
+				  u8 status)
 {
 	struct xenvif *vif;
 	struct pending_tx_info *pending_tx_info;
@@ -1542,7 +1530,7 @@ static void xen_netbk_idx_release(struct
 
 	vif = pending_tx_info->vif;
 
-	make_tx_response(vif, &pending_tx_info->req, XEN_NETIF_RSP_OKAY);
+	make_tx_response(vif, &pending_tx_info->req, status);
 
 	index = pending_index(netbk->pending_prod++);
 	netbk->pending_ring[index] = pending_idx;


