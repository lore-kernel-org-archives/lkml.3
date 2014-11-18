Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbaKRP2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:28:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbaKROJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 008/206] vxlan: fix a use after free in vxlan_encap_bypass
Date: Tue, 18 Nov 2014 15:06:03 +0100
Message-Id: <ef0444ff81e4aa1580725d7f485a38760e799b22.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li RongQing <roy.qing.li@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit ce6502a8f9572179f044a4d62667c4645256d6e4 ]

when netif_rx() is done, the netif_rx handled skb maybe be freed,
and should not be used.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/vxlan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index f1735fb61362..637e5ad186ef 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1683,6 +1683,8 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 	struct pcpu_tstats *rx_stats = this_cpu_ptr(dst_vxlan->dev->tstats);
 	union vxlan_addr loopback;
 	union vxlan_addr *remote_ip = &dst_vxlan->default_dst.remote_ip;
+	struct net_device *dev = skb->dev;
+	int len = skb->len;
 
 	skb->pkt_type = PACKET_HOST;
 	skb->encapsulation = 0;
@@ -1704,16 +1706,16 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 
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
2.1.3

