Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaLOTkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:40:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaLOTc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:32:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 94/96] net: mvneta: fix race condition in mvneta_tx()
Date: Mon, 15 Dec 2014 11:26:54 -0800
Message-Id: <1418671616-25482-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5f478b41033606d325e420df693162e2524c2b94 ]

mvneta_tx() dereferences skb to get skb->len too late,
as hardware might have completed the transmit and TX completion
could have freed the skb from another cpu.

Fixes: 71f6d1b31fb1 ("net: mvneta: replace Tx timer with a real interrupt")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 03ff7c2..453437b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1562,6 +1562,7 @@ static int mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 	u16 txq_id = skb_get_queue_mapping(skb);
 	struct mvneta_tx_queue *txq = &pp->txqs[txq_id];
 	struct mvneta_tx_desc *tx_desc;
+	int len = skb->len;
 	struct netdev_queue *nq;
 	int frags = 0;
 	u32 tx_cmd;
@@ -1625,7 +1626,7 @@ out:
 
 		u64_stats_update_begin(&stats->syncp);
 		stats->tx_packets++;
-		stats->tx_bytes  += skb->len;
+		stats->tx_bytes  += len;
 		u64_stats_update_end(&stats->syncp);
 	} else {
 		dev->stats.tx_dropped++;
-- 
1.9.1

