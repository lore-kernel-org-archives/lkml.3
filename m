Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaKKLKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57444 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaKKLKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 070/170] vxlan: fix a use after free in vxlan_encap_bypass
Date: Tue, 11 Nov 2014 11:07:09 +0000
Message-Id: <1415704129-12709-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

commit ce6502a8f9572179f044a4d62667c4645256d6e4 upstream.

when netif_rx() is done, the netif_rx handled skb maybe be freed,
and should not be used.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/vxlan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 31a7ad0d7d5f..a5da8d49a824 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1734,6 +1734,8 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 	struct pcpu_sw_netstats *tx_stats, *rx_stats;
 	union vxlan_addr loopback;
 	union vxlan_addr *remote_ip = &dst_vxlan->default_dst.remote_ip;
+	struct net_device *dev = skb->dev;
+	int len = skb->len;
 
 	tx_stats = this_cpu_ptr(src_vxlan->dev->tstats);
 	rx_stats = this_cpu_ptr(dst_vxlan->dev->tstats);
@@ -1757,16 +1759,16 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->tx_packets++;
-	tx_stats->tx_bytes += skb->len;
+	tx_stats->tx_bytes += len;
 	u64_stats_update_end(&tx_stats->syncp);
 
 	if (netif_rx(skb) == NET_RX_SUCCESS) {
 		u64_stats_update_begin(&rx_stats->syncp);
 		rx_stats->rx_packets++;
-		rx_stats->rx_bytes += skb->len;
+		rx_stats->rx_bytes += len;
 		u64_stats_update_end(&rx_stats->syncp);
 	} else {
-		skb->dev->stats.rx_dropped++;
+		dev->stats.rx_dropped++;
 	}
 }
 
-- 
2.1.0

