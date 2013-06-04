Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3FDOJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:09:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab3FDOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Liu <wei.liu2@citrix.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 66/70] xen-netback: avoid allocating variable size array on stack
Date: Tue,  4 Jun 2013 15:07:22 +0100
Message-Id: <1370354846-14213-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit 59ccb4ebbc35e36a3c143f2d1355deb75c2e628f upstream.

Tune xen_netbk_count_requests to not touch working array beyond limit, so that
we can make working array size constant.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netback/netback.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index bc812b7..aea1604 100644
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
1.8.1.2

