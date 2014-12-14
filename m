Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaLNU1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:27:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaLNUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:25:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 39/47] net: mvneta: fix race condition in mvneta_tx()
Date: Sun, 14 Dec 2014 12:21:14 -0800
Message-Id: <20141214201820.044152013@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5f478b41033606d325e420df693162e2524c2b94 ]

mvneta_tx() dereferences skb to get skb->len too late,
as hardware might have completed the transmit and TX completion
could have freed the skb from another cpu.

Fixes: 71f6d1b31fb1 ("net: mvneta: replace Tx timer with a real interrupt")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1721,6 +1721,7 @@ static int mvneta_tx(struct sk_buff *skb
 	u16 txq_id = skb_get_queue_mapping(skb);
 	struct mvneta_tx_queue *txq = &pp->txqs[txq_id];
 	struct mvneta_tx_desc *tx_desc;
+	int len = skb->len;
 	int frags = 0;
 	u32 tx_cmd;
 
@@ -1788,7 +1789,7 @@ out:
 
 		u64_stats_update_begin(&stats->syncp);
 		stats->tx_packets++;
-		stats->tx_bytes  += skb->len;
+		stats->tx_bytes  += len;
 		u64_stats_update_end(&stats->syncp);
 	} else {
 		dev->stats.tx_dropped++;


