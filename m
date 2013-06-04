Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3FDOJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:09:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46978 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3FDOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Liu <wei.liu2@citrix.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 68/70] xen-netfront: remove unused variable `extra'
Date: Tue,  4 Jun 2013 15:07:24 +0100
Message-Id: <1370354846-14213-69-git-send-email-luis.henriques@canonical.com>
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

commit e2d617c0ccf658a55552955f07018ecfa0135210 upstream.

This variable is supposed to hold reference to the last extra_info in the
loop. However there is only type of extra info here and the loop to process
extra info is missing, so this variable is never used and causes confusion.

Remove it at the moment. We can add it back when necessary.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netfront.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 3089990..0ab0da4 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -481,7 +481,6 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netfront_info *np = netdev_priv(dev);
 	struct netfront_stats *stats = this_cpu_ptr(np->stats);
 	struct xen_netif_tx_request *tx;
-	struct xen_netif_extra_info *extra;
 	char *data = skb->data;
 	RING_IDX i;
 	grant_ref_t ref;
@@ -525,7 +524,6 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx->gref = np->grant_tx_ref[id] = ref;
 	tx->offset = offset;
 	tx->size = len;
-	extra = NULL;
 
 	tx->flags = 0;
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
@@ -541,10 +539,7 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		gso = (struct xen_netif_extra_info *)
 			RING_GET_REQUEST(&np->tx, ++i);
 
-		if (extra)
-			extra->flags |= XEN_NETIF_EXTRA_FLAG_MORE;
-		else
-			tx->flags |= XEN_NETTXF_extra_info;
+		tx->flags |= XEN_NETTXF_extra_info;
 
 		gso->u.gso.size = skb_shinfo(skb)->gso_size;
 		gso->u.gso.type = XEN_NETIF_GSO_TYPE_TCPV4;
@@ -553,7 +548,6 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		gso->type = XEN_NETIF_EXTRA_TYPE_GSO;
 		gso->flags = 0;
-		extra = gso;
 	}
 
 	np->tx.req_prod_pvt = i + 1;
-- 
1.8.1.2

