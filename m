Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390Ab3BSSyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:54:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934384Ab3BSSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:54:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Daley <mattjd@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 64/81] xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.
Date: Tue, 19 Feb 2013 15:49:27 -0300
Message-Id: <1361299784-8830-65-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Daley <mattjd@gmail.com>

commit 7d5145d8eb2b9791533ffe4dc003b129b9696c48 upstream.

Signed-off-by: Matthew Daley <mattjd@gmail.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/xen-netback/netback.c |   38 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index ae321c0..e7913e0 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -146,7 +146,8 @@ void xen_netbk_remove_xenvif(struct xenvif *vif)
 	atomic_dec(&netbk->netfront_count);
 }
 
-static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx);
+static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
+				  u8 status);
 static void make_tx_response(struct xenvif *vif,
 			     struct xen_netif_tx_request *txp,
 			     s8       st);
@@ -978,30 +979,20 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
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
 
@@ -1010,16 +1001,12 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
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
@@ -1027,10 +1014,10 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
 
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
@@ -1064,7 +1051,7 @@ static void xen_netbk_fill_frags(struct xen_netbk *netbk, struct sk_buff *skb)
 
 		/* Take an extra reference to offset xen_netbk_idx_release */
 		get_page(netbk->mmap_pages[pending_idx]);
-		xen_netbk_idx_release(netbk, pending_idx);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 	}
 }
 
@@ -1447,7 +1434,7 @@ static void xen_netbk_tx_submit(struct xen_netbk *netbk)
 			txp->size -= data_len;
 		} else {
 			/* Schedule a response immediately. */
-			xen_netbk_idx_release(netbk, pending_idx);
+			xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		}
 
 		if (txp->flags & XEN_NETTXF_csum_blank)
@@ -1502,7 +1489,8 @@ static void xen_netbk_tx_action(struct xen_netbk *netbk)
 
 }
 
-static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx)
+static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
+				  u8 status)
 {
 	struct xenvif *vif;
 	struct pending_tx_info *pending_tx_info;
@@ -1516,7 +1504,7 @@ static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx)
 
 	vif = pending_tx_info->vif;
 
-	make_tx_response(vif, &pending_tx_info->req, XEN_NETIF_RSP_OKAY);
+	make_tx_response(vif, &pending_tx_info->req, status);
 
 	index = pending_index(netbk->pending_prod++);
 	netbk->pending_ring[index] = pending_idx;
-- 
1.7.9.5

