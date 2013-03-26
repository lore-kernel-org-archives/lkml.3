Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839Ab3CZR6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:58:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3CZRgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:08 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=dXjRoFMubuQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=EP8OPaZ_EHYA:10 a=tHz9FfFoAAAA:8 a=yPCof4ZbAAAA:8 a=iox4zFpeAAAA:8 a=J1Y8HTJGAAAA:8 a=nywi_pbTftgfIPgTl4UA:9 a=6O0IECtVFhoA:10 a=7DSvI1NPTFQA:10 a=n9GBPR9yFnkA:10 a=4N9Db7Z2_RYA:10 a=8nmVhzYJBMWZpd8U:21 a=MJIvAuH91PMblnMH:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173604.209769776@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 27/86] xen/netback: shutdown the ring if it contains garbage.
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0027-xen-netback-shutdown-the-ring-if-it-contains-garbage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

[ Upstream commit 48856286b64e4b66ec62b94e504d0b29c1ade664 ]

A buggy or malicious frontend should not be able to confuse netback.
If we spot anything which is not as it should be then shutdown the
device and don't try to continue with the ring in a potentially
hostile state. Well behaved and non-hostile frontends will not be
penalised.

As well as making the existing checks for such errors fatal also add a
new check that ensures that there isn't an insane number of requests
on the ring (i.e. more than would fit in the ring). If the ring
contains garbage then previously is was possible to loop over this
insane number, getting an error each time and therefore not generating
any more pending requests and therefore not exiting the loop in
xen_netbk_tx_build_gops for an externded period.

Also turn various netdev_dbg calls which no precipitate a fatal error
into netdev_err, they are rate limited because the device is shutdown
afterwards.

This fixes at least one known DoS/softlockup of the backend domain.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/xen-netback/common.h    |    3 ++
 drivers/net/xen-netback/interface.c |   23 ++++++++-----
 drivers/net/xen-netback/netback.c   |   62 +++++++++++++++++++++++++----------
 3 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 94b79c3..9d7f172 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -151,6 +151,9 @@ void xen_netbk_queue_tx_skb(struct xenvif *vif, struct sk_buff *skb);
 /* Notify xenvif that ring now has space to send an skb to the frontend */
 void xenvif_notify_tx_completion(struct xenvif *vif);
 
+/* Prevent the device from generating any further traffic. */
+void xenvif_carrier_off(struct xenvif *vif);
+
 /* Returns number of ring slots required to send an skb to the frontend */
 unsigned int xen_netbk_count_skb_slots(struct xenvif *vif, struct sk_buff *skb);
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index b7d41f8..b8c5193 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -343,17 +343,22 @@ err:
 	return err;
 }
 
-void xenvif_disconnect(struct xenvif *vif)
+void xenvif_carrier_off(struct xenvif *vif)
 {
 	struct net_device *dev = vif->dev;
-	if (netif_carrier_ok(dev)) {
-		rtnl_lock();
-		netif_carrier_off(dev); /* discard queued packets */
-		if (netif_running(dev))
-			xenvif_down(vif);
-		rtnl_unlock();
-		xenvif_put(vif);
-	}
+
+	rtnl_lock();
+	netif_carrier_off(dev); /* discard queued packets */
+	if (netif_running(dev))
+		xenvif_down(vif);
+	rtnl_unlock();
+	xenvif_put(vif);
+}
+
+void xenvif_disconnect(struct xenvif *vif)
+{
+	if (netif_carrier_ok(vif->dev))
+		xenvif_carrier_off(vif);
 
 	atomic_dec(&vif->refcnt);
 	wait_event(vif->waiting_to_free, atomic_read(&vif->refcnt) == 0);
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 682633b..efdbf8f 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -859,6 +859,13 @@ static void netbk_tx_err(struct xenvif *vif,
 	xenvif_put(vif);
 }
 
+static void netbk_fatal_tx_err(struct xenvif *vif)
+{
+	netdev_err(vif->dev, "fatal error; disabling device\n");
+	xenvif_carrier_off(vif);
+	xenvif_put(vif);
+}
+
 static int netbk_count_requests(struct xenvif *vif,
 				struct xen_netif_tx_request *first,
 				struct xen_netif_tx_request *txp,
@@ -872,19 +879,22 @@ static int netbk_count_requests(struct xenvif *vif,
 
 	do {
 		if (frags >= work_to_do) {
-			netdev_dbg(vif->dev, "Need more frags\n");
+			netdev_err(vif->dev, "Need more frags\n");
+			netbk_fatal_tx_err(vif);
 			return -frags;
 		}
 
 		if (unlikely(frags >= MAX_SKB_FRAGS)) {
-			netdev_dbg(vif->dev, "Too many frags\n");
+			netdev_err(vif->dev, "Too many frags\n");
+			netbk_fatal_tx_err(vif);
 			return -frags;
 		}
 
 		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + frags),
 		       sizeof(*txp));
 		if (txp->size > first->size) {
-			netdev_dbg(vif->dev, "Frags galore\n");
+			netdev_err(vif->dev, "Frag is bigger than frame.\n");
+			netbk_fatal_tx_err(vif);
 			return -frags;
 		}
 
@@ -892,8 +902,9 @@ static int netbk_count_requests(struct xenvif *vif,
 		frags++;
 
 		if (unlikely((txp->offset + txp->size) > PAGE_SIZE)) {
-			netdev_dbg(vif->dev, "txp->offset: %x, size: %u\n",
+			netdev_err(vif->dev, "txp->offset: %x, size: %u\n",
 				 txp->offset, txp->size);
+			netbk_fatal_tx_err(vif);
 			return -frags;
 		}
 	} while ((txp++)->flags & XEN_NETTXF_more_data);
@@ -1066,7 +1077,8 @@ static int xen_netbk_get_extras(struct xenvif *vif,
 
 	do {
 		if (unlikely(work_to_do-- <= 0)) {
-			netdev_dbg(vif->dev, "Missing extra info\n");
+			netdev_err(vif->dev, "Missing extra info\n");
+			netbk_fatal_tx_err(vif);
 			return -EBADR;
 		}
 
@@ -1075,8 +1087,9 @@ static int xen_netbk_get_extras(struct xenvif *vif,
 		if (unlikely(!extra.type ||
 			     extra.type >= XEN_NETIF_EXTRA_TYPE_MAX)) {
 			vif->tx.req_cons = ++cons;
-			netdev_dbg(vif->dev,
+			netdev_err(vif->dev,
 				   "Invalid extra type: %d\n", extra.type);
+			netbk_fatal_tx_err(vif);
 			return -EINVAL;
 		}
 
@@ -1092,13 +1105,15 @@ static int netbk_set_skb_gso(struct xenvif *vif,
 			     struct xen_netif_extra_info *gso)
 {
 	if (!gso->u.gso.size) {
-		netdev_dbg(vif->dev, "GSO size must not be zero.\n");
+		netdev_err(vif->dev, "GSO size must not be zero.\n");
+		netbk_fatal_tx_err(vif);
 		return -EINVAL;
 	}
 
 	/* Currently only TCPv4 S.O. is supported. */
 	if (gso->u.gso.type != XEN_NETIF_GSO_TYPE_TCPV4) {
-		netdev_dbg(vif->dev, "Bad GSO type %d.\n", gso->u.gso.type);
+		netdev_err(vif->dev, "Bad GSO type %d.\n", gso->u.gso.type);
+		netbk_fatal_tx_err(vif);
 		return -EINVAL;
 	}
 
@@ -1235,9 +1250,25 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 
 		/* Get a netif from the list with work to do. */
 		vif = poll_net_schedule_list(netbk);
+		/* This can sometimes happen because the test of
+		 * list_empty(net_schedule_list) at the top of the
+		 * loop is unlocked.  Just go back and have another
+		 * look.
+		 */
 		if (!vif)
 			continue;
 
+		if (vif->tx.sring->req_prod - vif->tx.req_cons >
+		    XEN_NETIF_TX_RING_SIZE) {
+			netdev_err(vif->dev,
+				   "Impossible number of requests. "
+				   "req_prod %d, req_cons %d, size %ld\n",
+				   vif->tx.sring->req_prod, vif->tx.req_cons,
+				   XEN_NETIF_TX_RING_SIZE);
+			netbk_fatal_tx_err(vif);
+			continue;
+		}
+
 		RING_FINAL_CHECK_FOR_REQUESTS(&vif->tx, work_to_do);
 		if (!work_to_do) {
 			xenvif_put(vif);
@@ -1265,17 +1296,14 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 			work_to_do = xen_netbk_get_extras(vif, extras,
 							  work_to_do);
 			idx = vif->tx.req_cons;
-			if (unlikely(work_to_do < 0)) {
-				netbk_tx_err(vif, &txreq, idx);
+			if (unlikely(work_to_do < 0))
 				continue;
-			}
 		}
 
 		ret = netbk_count_requests(vif, &txreq, txfrags, work_to_do);
-		if (unlikely(ret < 0)) {
-			netbk_tx_err(vif, &txreq, idx - ret);
+		if (unlikely(ret < 0))
 			continue;
-		}
+
 		idx += ret;
 
 		if (unlikely(txreq.size < ETH_HLEN)) {
@@ -1287,11 +1315,11 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 
 		/* No crossing a page as the payload mustn't fragment. */
 		if (unlikely((txreq.offset + txreq.size) > PAGE_SIZE)) {
-			netdev_dbg(vif->dev,
+			netdev_err(vif->dev,
 				   "txreq.offset: %x, size: %u, end: %lu\n",
 				   txreq.offset, txreq.size,
 				   (txreq.offset&~PAGE_MASK) + txreq.size);
-			netbk_tx_err(vif, &txreq, idx);
+			netbk_fatal_tx_err(vif);
 			continue;
 		}
 
@@ -1319,8 +1347,8 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 			gso = &extras[XEN_NETIF_EXTRA_TYPE_GSO - 1];
 
 			if (netbk_set_skb_gso(vif, skb, gso)) {
+				/* Failure in netbk_set_skb_gso is fatal. */
 				kfree_skb(skb);
-				netbk_tx_err(vif, &txreq, idx);
 				continue;
 			}
 		}
-- 
1.7.10.4


