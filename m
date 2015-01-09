Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296AbbAIKu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:50:26 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44531 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757422AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 08/78] net: mvneta: fix race condition in mvneta_tx()
Date: Fri,  9 Jan 2015 11:31:17 +0100
Message-Id: <2ffe53f9735a9fb7be8a2a1f78487db8bd603f53.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5f478b41033606d325e420df693162e2524c2b94 ]

mvneta_tx() dereferences skb to get skb->len too late,
as hardware might have completed the transmit and TX completion
could have freed the skb from another cpu.

Fixes: 71f6d1b31fb1 ("net: mvneta: replace Tx timer with a real interrupt")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0e38db6469fb..9c66d3168911 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1524,6 +1524,7 @@ static int mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 	struct mvneta_tx_queue *txq = &pp->txqs[txq_id];
 	struct mvneta_tx_desc *tx_desc;
 	struct netdev_queue *nq;
+	int len = skb->len;
 	int frags = 0;
 	u32 tx_cmd;
 
@@ -1584,7 +1585,7 @@ out:
 	if (frags > 0) {
 		u64_stats_update_begin(&pp->tx_stats.syncp);
 		pp->tx_stats.packets++;
-		pp->tx_stats.bytes += skb->len;
+		pp->tx_stats.bytes += len;
 		u64_stats_update_end(&pp->tx_stats.syncp);
 
 	} else {
-- 
2.2.1

