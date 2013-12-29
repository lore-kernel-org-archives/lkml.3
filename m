Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3L2V6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:58:41 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:31762 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798Ab3L2Vvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:51:54 -0500
X-IronPort-AV: E=Sophos;i="4.95,570,1384297200"; 
   d="scan'208";a="50832527"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Geoff Levand <geoff@infradead.org>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/25] net: fix error return code
Date: Sun, 29 Dec 2013 23:47:22 +0100
Message-Id: <1388357260-4843-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to propagate any error code as done elsewhere in
the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/net/ethernet/toshiba/ps3_gelic_net.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index f7f2ef4..d899d00 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1739,12 +1739,14 @@ static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
 		GELIC_CARD_PORT_STATUS_CHANGED;
 
 
-	if (gelic_card_init_chain(card, &card->tx_chain,
-			card->descr, GELIC_NET_TX_DESCRIPTORS))
+	result = gelic_card_init_chain(card, &card->tx_chain,
+				       card->descr, GELIC_NET_TX_DESCRIPTORS);
+	if (result)
 		goto fail_alloc_tx;
-	if (gelic_card_init_chain(card, &card->rx_chain,
-				 card->descr + GELIC_NET_TX_DESCRIPTORS,
-				 GELIC_NET_RX_DESCRIPTORS))
+	result = gelic_card_init_chain(card, &card->rx_chain,
+				       card->descr + GELIC_NET_TX_DESCRIPTORS,
+				       GELIC_NET_RX_DESCRIPTORS);
+	if (result)
 		goto fail_alloc_rx;
 
 	/* head of chain */
@@ -1754,7 +1756,8 @@ static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
 		card->rx_top, card->tx_top, sizeof(struct gelic_descr),
 		GELIC_NET_RX_DESCRIPTORS);
 	/* allocate rx skbs */
-	if (gelic_card_alloc_rx_skbs(card))
+	result = gelic_card_alloc_rx_skbs(card);
+	if (result)
 		goto fail_alloc_skbs;
 
 	spin_lock_init(&card->tx_lock);
@@ -1772,7 +1775,8 @@ static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
 	}
 
 #ifdef CONFIG_GELIC_WIRELESS
-	if (gelic_wl_driver_probe(card)) {
+	result = gelic_wl_driver_probe(card);
+	if (result) {
 		dev_dbg(&dev->core, "%s: WL init failed\n", __func__);
 		goto fail_setup_netdev;
 	}

