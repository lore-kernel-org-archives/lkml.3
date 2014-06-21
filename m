Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaFUPE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 11:04:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45848 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaFUPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:04:27 -0400
Date: Sat, 21 Jun 2014 20:34:09 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Henk de Groot <pe1dnn@amsat.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] staging: wlags49_h2: Fix use of skb after netif_rx
Message-ID: <20140621150408.GA3340@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves a call to netif_rx(skb) after a subsequent reference to
skb, because netif_rx may call kfree_skb via enqueue_to_backlog on its
argument.

This was found using the following semantic match.

// <smpl>
@@
expression skb, e,e1;
@@

(
 netif_rx(skb);
|
 netif_rx_ni(skb);
)
  ... when != skb = e
(
  skb = e1
|
* skb
)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/staging/wlags49_h2/wl_netdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index a10d014..60701d43 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -888,8 +888,6 @@ int wl_rx(struct net_device *dev)
 				GET_PACKET(skb->dev, skb, pktlen);
 
 				if (status == HCF_SUCCESS) {
-					netif_rx(skb);
-
 					if (port == 0) {
 						lp->stats.rx_packets++;
 						lp->stats.rx_bytes += pktlen;
@@ -918,6 +916,7 @@ int wl_rx(struct net_device *dev)
 					}
 #endif /* WIRELESS_SPY */
 #endif /* WIRELESS_EXT */
+					netif_rx(skb);
 				} else {
 					DBG_ERROR(DbgInfo,
 						  "Rx request to card FAILED\n");
-- 
1.9.1

