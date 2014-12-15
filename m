Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaLOObx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:31:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39053 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaLOO3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 162/168] net: mvneta: fix race condition in mvneta_tx()
Date: Mon, 15 Dec 2014 14:26:56 +0000
Message-Id: <1418653622-21105-163-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 5f478b41033606d325e420df693162e2524c2b94 upstream.

mvneta_tx() dereferences skb to get skb->len too late,
as hardware might have completed the transmit and TX completion
could have freed the skb from another cpu.

Fixes: 71f6d1b31fb1 ("net: mvneta: replace Tx timer with a real interrupt")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 626aa88644b8..393d49202f23 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1719,6 +1719,7 @@ static int mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 	u16 txq_id = skb_get_queue_mapping(skb);
 	struct mvneta_tx_queue *txq = &pp->txqs[txq_id];
 	struct mvneta_tx_desc *tx_desc;
+	int len = skb->len;
 	int frags = 0;
 	u32 tx_cmd;
 
@@ -1786,7 +1787,7 @@ out:
 
 		u64_stats_update_begin(&stats->syncp);
 		stats->tx_packets++;
-		stats->tx_bytes  += skb->len;
+		stats->tx_bytes  += len;
 		u64_stats_update_end(&stats->syncp);
 	} else {
 		dev->stats.tx_dropped++;
-- 
2.1.3

