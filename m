Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab3D2TfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:35:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524Ab3D2TCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>, Dmitri Epshtein <dima@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 34/42] net: mvneta: fix improper tx queue usage in mvneta_tx()
Date: Mon, 29 Apr 2013 12:02:16 -0700
Message-Id: <20130429184756.234610070@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Willy Tarreau <w@1wt.eu>

[ Upstream commit ee40a116ebf139f900c3d2e6febb8388738e96d0 ]

mvneta_tx() was using a static tx queue number causing crashes as
soon as a little bit of traffic was sent via the interface, because
it is normally expected that the same queue should be used as in
dev_queue_xmit().

As suggested by Ben Hutchings, let's use skb_get_queue_mapping() to
get the proper Tx queue number, and use alloc_etherdev_mqs() instead
of alloc_etherdev_mq() to create the queues.

Both my Mirabox and my OpenBlocks AX3 used to crash without this patch
and don't anymore with it. The issue appeared in 3.8 but became more
visible after the fix allowing GSO to be enabled.

Original work was done by Dmitri Epshtein and Thomas Petazzoni. I
just adapted it to take care of Ben's comments.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Cc: Dmitri Epshtein <dima@marvell.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -375,7 +375,6 @@ static int rxq_number = 8;
 static int txq_number = 8;
 
 static int rxq_def;
-static int txq_def;
 
 #define MVNETA_DRIVER_NAME "mvneta"
 #define MVNETA_DRIVER_VERSION "1.0"
@@ -1476,7 +1475,8 @@ error:
 static int mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
-	struct mvneta_tx_queue *txq = &pp->txqs[txq_def];
+	u16 txq_id = skb_get_queue_mapping(skb);
+	struct mvneta_tx_queue *txq = &pp->txqs[txq_id];
 	struct mvneta_tx_desc *tx_desc;
 	struct netdev_queue *nq;
 	int frags = 0;
@@ -1486,7 +1486,7 @@ static int mvneta_tx(struct sk_buff *skb
 		goto out;
 
 	frags = skb_shinfo(skb)->nr_frags + 1;
-	nq    = netdev_get_tx_queue(dev, txq_def);
+	nq    = netdev_get_tx_queue(dev, txq_id);
 
 	/* Get a descriptor for the first part of the packet */
 	tx_desc = mvneta_txq_next_desc_get(txq);
@@ -2690,7 +2690,7 @@ static int mvneta_probe(struct platform_
 		return -EINVAL;
 	}
 
-	dev = alloc_etherdev_mq(sizeof(struct mvneta_port), 8);
+	dev = alloc_etherdev_mqs(sizeof(struct mvneta_port), txq_number, rxq_number);
 	if (!dev)
 		return -ENOMEM;
 
@@ -2844,4 +2844,3 @@ module_param(rxq_number, int, S_IRUGO);
 module_param(txq_number, int, S_IRUGO);
 
 module_param(rxq_def, int, S_IRUGO);
-module_param(txq_def, int, S_IRUGO);


