Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3CZR5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:57:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15455 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3CZRgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:10 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0mr359wiF70A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=f5l90i51NqcA:10 a=tHz9FfFoAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=6O0IECtVFhoA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173604.539883851@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 29/86] xen/netback: free already allocated memory on failure in
 xen_netbk_get_requests
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0029-xen-netback-free-already-allocated-memory-on-failure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

[ Upstream commit 4cc7c1cb7b11b6f3515bd9075527576a1eecc4aa ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/xen-netback/netback.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 68a94cf..7e18de2 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -949,7 +949,7 @@ static struct gnttab_copy *xen_netbk_get_requests(struct xen_netbk *netbk,
 		pending_idx = netbk->pending_ring[index];
 		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
 		if (!page)
-			return NULL;
+			goto err;
 
 		gop->source.u.ref = txp->gref;
 		gop->source.domid = vif->domid;
@@ -971,6 +971,17 @@ static struct gnttab_copy *xen_netbk_get_requests(struct xen_netbk *netbk,
 	}
 
 	return gop;
+err:
+	/* Unwind, freeing all pages and sending error responses. */
+	while (i-- > start) {
+		xen_netbk_idx_release(netbk, frag_get_pending_idx(&frags[i]),
+				      XEN_NETIF_RSP_ERROR);
+	}
+	/* The head too, if necessary. */
+	if (start)
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
+
+	return NULL;
 }
 
 static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
-- 
1.7.10.4


