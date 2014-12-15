Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaLOTxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:53:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaLOT1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:27:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 04/96] vxlan: fix a use after free in vxlan_encap_bypass
Date: Mon, 15 Dec 2014 11:25:24 -0800
Message-Id: <1418671616-25482-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit ce6502a8f9572179f044a4d62667c4645256d6e4 ]

when netif_rx() is done, the netif_rx handled skb maybe be freed,
and should not be used.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/vxlan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5543eb1..311d63d 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1679,6 +1679,8 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 	struct pcpu_tstats *rx_stats = this_cpu_ptr(dst_vxlan->dev->tstats);
 	union vxlan_addr loopback;
 	union vxlan_addr *remote_ip = &dst_vxlan->default_dst.remote_ip;
+	struct net_device *dev = skb->dev;
+	int len = skb->len;
 
 	skb->pkt_type = PACKET_HOST;
 	skb->encapsulation = 0;
@@ -1700,16 +1702,16 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 
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
1.9.1

