Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaHRJsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:48:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42932 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaHRJfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 094/137] net: mvneta: increase the 64-bit rx/tx stats out of the hot path
Date: Mon, 18 Aug 2014 10:32:35 +0100
Message-Id: <1408354398-10226-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: willy tarreau <w@1wt.eu>

commit dc4277dd41a80fd5f29a90412ea04bc3ba54fbf1 upstream.

Better count packets and bytes in the stack and on 32 bit then
accumulate them at the end for once. This saves two memory writes
and two memory barriers per packet. The incoming packet rate was
increased by 4.7% on the Openblocks AX3 thanks to this.

Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Tested-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 1594c61d80de..64bf21be7ff9 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1358,6 +1358,8 @@ static int mvneta_rx(struct mvneta_port *pp, int rx_todo,
 {
 	struct net_device *dev = pp->dev;
 	int rx_done, rx_filled;
+	u32 rcvd_pkts = 0;
+	u32 rcvd_bytes = 0;
 
 	/* Get number of received packets */
 	rx_done = mvneta_rxq_busy_desc_num_get(pp, rxq);
@@ -1395,10 +1397,8 @@ static int mvneta_rx(struct mvneta_port *pp, int rx_todo,
 
 		rx_bytes = rx_desc->data_size -
 			(ETH_FCS_LEN + MVNETA_MH_SIZE);
-		u64_stats_update_begin(&pp->rx_stats.syncp);
-		pp->rx_stats.packets++;
-		pp->rx_stats.bytes += rx_bytes;
-		u64_stats_update_end(&pp->rx_stats.syncp);
+		rcvd_pkts++;
+		rcvd_bytes += rx_bytes;
 
 		/* Linux processing */
 		skb_reserve(skb, MVNETA_MH_SIZE);
@@ -1419,6 +1419,13 @@ static int mvneta_rx(struct mvneta_port *pp, int rx_todo,
 		}
 	}
 
+	if (rcvd_pkts) {
+		u64_stats_update_begin(&pp->rx_stats.syncp);
+		pp->rx_stats.packets += rcvd_pkts;
+		pp->rx_stats.bytes   += rcvd_bytes;
+		u64_stats_update_end(&pp->rx_stats.syncp);
+	}
+
 	/* Update rxq management counters */
 	mvneta_rxq_desc_num_update(pp, rxq, rx_done, rx_filled);
 
-- 
1.9.1

