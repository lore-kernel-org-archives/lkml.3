Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaCDWdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:33:11 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:46434 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaCDWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:33:09 -0500
X-IronPort-AV: E=Sophos;i="4.97,588,1389744000"; 
   d="scan'208";a="106598772"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>, Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next v6 1/10] xen-netback: Use skb->cb for pending_idx
Date: Tue, 4 Mar 2014 22:32:12 +0000
Message-ID: <1393972341-21135-2-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393972341-21135-1-git-send-email-zoltan.kiss@citrix.com>
References: <1393972341-21135-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Storing the pending_idx at the first byte of the linear buffer never looked
good, skb->cb is a more proper place for this. It also prevents the header to
be directly grant copied there, and we don't have the pending_idx after we
copied the header here, so it's time to change it.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 drivers/net/xen-netback/netback.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index e5284bc..5944f87 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -779,7 +779,7 @@ static struct gnttab_copy *xenvif_get_requests(struct xenvif *vif,
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	skb_frag_t *frags = shinfo->frags;
-	u16 pending_idx = *((u16 *)skb->data);
+	u16 pending_idx = *((u16 *)skb->cb);
 	u16 head_idx = 0;
 	int slot, start;
 	struct page *page;
@@ -897,7 +897,7 @@ static int xenvif_tx_check_gop(struct xenvif *vif,
 			       struct gnttab_copy **gopp)
 {
 	struct gnttab_copy *gop = *gopp;
-	u16 pending_idx = *((u16 *)skb->data);
+	u16 pending_idx = *((u16 *)skb->cb);
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	struct pending_tx_info *tx_info;
 	int nr_frags = shinfo->nr_frags;
@@ -944,7 +944,7 @@ static int xenvif_tx_check_gop(struct xenvif *vif,
 			continue;
 
 		/* First error: invalidate header and preceding fragments. */
-		pending_idx = *((u16 *)skb->data);
+		pending_idx = *((u16 *)skb->cb);
 		xenvif_idx_release(vif, pending_idx, XEN_NETIF_RSP_OKAY);
 		for (j = start; j < i; j++) {
 			pending_idx = frag_get_pending_idx(&shinfo->frags[j]);
@@ -1236,7 +1236,7 @@ static unsigned xenvif_tx_build_gops(struct xenvif *vif, int budget)
 		memcpy(&vif->pending_tx_info[pending_idx].req,
 		       &txreq, sizeof(txreq));
 		vif->pending_tx_info[pending_idx].head = index;
-		*((u16 *)skb->data) = pending_idx;
+		*((u16 *)skb->cb) = pending_idx;
 
 		__skb_put(skb, data_len);
 
@@ -1283,7 +1283,7 @@ static int xenvif_tx_submit(struct xenvif *vif)
 		u16 pending_idx;
 		unsigned data_len;
 
-		pending_idx = *((u16 *)skb->data);
+		pending_idx = *((u16 *)skb->cb);
 		txp = &vif->pending_tx_info[pending_idx].req;
 
 		/* Check the remap error code. */
