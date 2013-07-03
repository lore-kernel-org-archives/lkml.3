Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab3GCSoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:44:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab3GCSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:10 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=vep89UUYZ68A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=1cJQfhlvqFIA:10 a=tHz9FfFoAAAA:8 a=iox4zFpeAAAA:8 a=J1Y8HTJGAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=6O0IECtVFhoA:10 a=n9GBPR9yFnkA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184055.100034417@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Beulich <jbeulich@suse.com>, Wei Liu <wei.liu2@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [063/141] xen-netback: avoid allocating variable size array on stack
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0063-xen-netback-avoid-allocating-variable-size-array-on-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

[ Upstream commit 59ccb4ebbc35e36a3c143f2d1355deb75c2e628f ]

Tune xen_netbk_count_requests to not touch working array beyond limit, so that
we can make working array size constant.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/xen-netback/netback.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index b78839e..4925188 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -905,11 +905,14 @@ static int netbk_count_requests(struct xenvif *vif,
 	RING_IDX cons = vif->tx.req_cons;
 	int slots = 0;
 	int drop_err = 0;
+	int more_data;
 
 	if (!(first->flags & XEN_NETTXF_more_data))
 		return 0;
 
 	do {
+		struct xen_netif_tx_request dropped_tx = { 0 };
+
 		if (slots >= work_to_do) {
 			netdev_err(vif->dev,
 				   "Asked for %d slots but exceeds this limit\n",
@@ -943,6 +946,9 @@ static int netbk_count_requests(struct xenvif *vif,
 			drop_err = -E2BIG;
 		}
 
+		if (drop_err)
+			txp = &dropped_tx;
+
 		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + slots),
 		       sizeof(*txp));
 
@@ -972,7 +978,13 @@ static int netbk_count_requests(struct xenvif *vif,
 			netbk_fatal_tx_err(vif);
 			return -EINVAL;
 		}
-	} while ((txp++)->flags & XEN_NETTXF_more_data);
+
+		more_data = txp->flags & XEN_NETTXF_more_data;
+
+		if (!drop_err)
+			txp++;
+
+	} while (more_data);
 
 	if (drop_err) {
 		netbk_tx_err(vif, first, cons + slots);
@@ -1384,7 +1396,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 		!list_empty(&netbk->net_schedule_list)) {
 		struct xenvif *vif;
 		struct xen_netif_tx_request txreq;
-		struct xen_netif_tx_request txfrags[max_skb_slots];
+		struct xen_netif_tx_request txfrags[XEN_NETIF_NR_SLOTS_MIN];
 		struct page *page;
 		struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX-1];
 		u16 pending_idx;
-- 
1.7.10.4


