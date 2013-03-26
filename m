Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3CZR60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:58:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3CZRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:07 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6lS5EthwVwQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=P-j6PyRU9tAA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=tHz9FfFoAAAA:8 a=iox4zFpeAAAA:8 a=J1Y8HTJGAAAA:8 a=wzubOOdo9ZbHJ76fWjwA:9 a=MSl-tDqOz04A:10 a=7DSvI1NPTFQA:10 a=6O0IECtVFhoA:10 a=n9GBPR9yFnkA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173604.373374707@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matthew Daley <mattjd@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 28/86] xen/netback: dont leak pages on failure in xen_netbk_tx_check_gop.
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0028-xen-netback-don-t-leak-pages-on-failure-in-xen_netbk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Matthew Daley <mattjd@gmail.com>

[ Upstream commit 7d5145d8eb2b9791533ffe4dc003b129b9696c48 ]

Signed-off-by: Matthew Daley <mattjd@gmail.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/xen-netback/netback.c |   38 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index efdbf8f..68a94cf 100644
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
1.7.10.4


