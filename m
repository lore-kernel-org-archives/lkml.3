Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364AbaKSW3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:29:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbaKSUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Slawomir Gajzner <slawomir.gajzner@gmail.com>,
        Julien DAscenzio <jdascenzio@yahoo.fr>,
        Karl Beldan <karl.beldan@rivierawaves.com>,
        Ian Campbell <ijc@hellion.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 008/141] net: mv643xx_eth: reclaim TX skbs only when released by the HW
Date: Wed, 19 Nov 2014 12:50:31 -0800
Message-Id: <20141119205150.954960197@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Beldan <karl.beldan@rivierawaves.com>

[ Upstream commit 2c2a9cbd64387d6b70ac5db013e9bfe9412c7354 ]

ATM, txq_reclaim will dequeue and free an skb for each tx desc released
by the hw that has TX_LAST_DESC set. However, in case of TSO, each
hw desc embedding the last part of a segment has TX_LAST_DESC set,
losing the one-to-one 'last skb frag'/'TX_LAST_DESC set' correspondance,
which causes data corruption.

Fix this by checking TX_ENABLE_INTERRUPT instead of TX_LAST_DESC, and
warn when trying to dequeue from an empty txq (which can be symptomatic
of releasing skbs prematurely).

Fixes: 3ae8f4e0b98 ('net: mv643xx_eth: Implement software TSO')
Reported-by: Slawomir Gajzner <slawomir.gajzner@gmail.com>
Reported-by: Julien D'Ascenzio <jdascenzio@yahoo.fr>
Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Ian Campbell <ijc@hellion.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1047,7 +1047,6 @@ static int txq_reclaim(struct tx_queue *
 		int tx_index;
 		struct tx_desc *desc;
 		u32 cmd_sts;
-		struct sk_buff *skb;
 
 		tx_index = txq->tx_used_desc;
 		desc = &txq->tx_desc_area[tx_index];
@@ -1066,19 +1065,22 @@ static int txq_reclaim(struct tx_queue *
 		reclaimed++;
 		txq->tx_desc_count--;
 
-		skb = NULL;
-		if (cmd_sts & TX_LAST_DESC)
-			skb = __skb_dequeue(&txq->tx_skb);
+		if (!IS_TSO_HEADER(txq, desc->buf_ptr))
+			dma_unmap_single(mp->dev->dev.parent, desc->buf_ptr,
+					 desc->byte_cnt, DMA_TO_DEVICE);
+
+		if (cmd_sts & TX_ENABLE_INTERRUPT) {
+			struct sk_buff *skb = __skb_dequeue(&txq->tx_skb);
+
+			if (!WARN_ON(!skb))
+				dev_kfree_skb(skb);
+		}
 
 		if (cmd_sts & ERROR_SUMMARY) {
 			netdev_info(mp->dev, "tx error\n");
 			mp->dev->stats.tx_errors++;
 		}
 
-		if (!IS_TSO_HEADER(txq, desc->buf_ptr))
-			dma_unmap_single(mp->dev->dev.parent, desc->buf_ptr,
-					 desc->byte_cnt, DMA_TO_DEVICE);
-		dev_kfree_skb(skb);
 	}
 
 	__netif_tx_unlock_bh(nq);


