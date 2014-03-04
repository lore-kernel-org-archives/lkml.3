Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbaCDVXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:23:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbaCDUDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Eric Dumazet <edumazet@google.com>, Arnaud Ebalard <arno@natisbad.org>,
        Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 057/172] net: mvneta: increase the 64-bit rx/tx stats out of the hot path
Date: Tue,  4 Mar 2014 12:02:21 -0800
Message-Id: <20140304200301.553810257@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: willy tarreau <w@1wt.eu>

[ Upstream commit dc4277dd41a80fd5f29a90412ea04bc3ba54fbf1 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1391,6 +1391,8 @@ static int mvneta_rx(struct mvneta_port
 {
 	struct net_device *dev = pp->dev;
 	int rx_done, rx_filled;
+	u32 rcvd_pkts = 0;
+	u32 rcvd_bytes = 0;
 
 	/* Get number of received packets */
 	rx_done = mvneta_rxq_busy_desc_num_get(pp, rxq);
@@ -1428,10 +1430,8 @@ static int mvneta_rx(struct mvneta_port
 
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
@@ -1452,6 +1452,13 @@ static int mvneta_rx(struct mvneta_port
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
 


