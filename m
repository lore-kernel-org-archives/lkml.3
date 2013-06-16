Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3FPWXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:23:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46401 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777Ab3FPWIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wei Liu" <wei.liu2@citrix.com>,
        "Jan Beulich" <jbeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.682991000@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [21/83] xen-netback: avoid allocating variable size array on stack
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit 59ccb4ebbc35e36a3c143f2d1355deb75c2e628f upstream.

Tune xen_netbk_count_requests to not touch working array beyond limit, so that
we can make working array size constant.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/xen-netback/netback.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -906,11 +906,14 @@ static int netbk_count_requests(struct x
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
@@ -944,6 +947,9 @@ static int netbk_count_requests(struct x
 			drop_err = -E2BIG;
 		}
 
+		if (drop_err)
+			txp = &dropped_tx;
+
 		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + slots),
 		       sizeof(*txp));
 
@@ -973,7 +979,13 @@ static int netbk_count_requests(struct x
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
@@ -1385,7 +1397,7 @@ static unsigned xen_netbk_tx_build_gops(
 		!list_empty(&netbk->net_schedule_list)) {
 		struct xenvif *vif;
 		struct xen_netif_tx_request txreq;
-		struct xen_netif_tx_request txfrags[max_skb_slots];
+		struct xen_netif_tx_request txfrags[XEN_NETIF_NR_SLOTS_MIN];
 		struct page *page;
 		struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX-1];
 		u16 pending_idx;

