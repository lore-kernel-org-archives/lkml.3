Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab3FEVgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:36:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab3FEVgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>, Wei Liu <wei.liu2@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 123/127] xen-netback: avoid allocating variable size array on stack
Date: Wed,  5 Jun 2013 14:34:50 -0700
Message-Id: <20130605213231.953827076@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit 59ccb4ebbc35e36a3c143f2d1355deb75c2e628f upstream.

Tune xen_netbk_count_requests to not touch working array beyond limit, so that
we can make working array size constant.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netback/netback.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -934,11 +934,14 @@ static int netbk_count_requests(struct x
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
@@ -972,6 +975,9 @@ static int netbk_count_requests(struct x
 			drop_err = -E2BIG;
 		}
 
+		if (drop_err)
+			txp = &dropped_tx;
+
 		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + slots),
 		       sizeof(*txp));
 
@@ -1001,7 +1007,13 @@ static int netbk_count_requests(struct x
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
@@ -1413,7 +1425,7 @@ static unsigned xen_netbk_tx_build_gops(
 		!list_empty(&netbk->net_schedule_list)) {
 		struct xenvif *vif;
 		struct xen_netif_tx_request txreq;
-		struct xen_netif_tx_request txfrags[max_skb_slots];
+		struct xen_netif_tx_request txfrags[XEN_NETIF_NR_SLOTS_MIN];
 		struct page *page;
 		struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX-1];
 		u16 pending_idx;


