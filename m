Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaKLBVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:21:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaKLBVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:21:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 005/319] vxlan: fix a use after free in vxlan_encap_bypass
Date: Wed, 12 Nov 2014 10:12:23 +0900
Message-Id: <20141112010953.493331597@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit ce6502a8f9572179f044a4d62667c4645256d6e4 ]

when netif_rx() is done, the netif_rx handled skb maybe be freed,
and should not be used.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1717,6 +1717,8 @@ static void vxlan_encap_bypass(struct sk
 	struct pcpu_sw_netstats *tx_stats, *rx_stats;
 	union vxlan_addr loopback;
 	union vxlan_addr *remote_ip = &dst_vxlan->default_dst.remote_ip;
+	struct net_device *dev = skb->dev;
+	int len = skb->len;
 
 	tx_stats = this_cpu_ptr(src_vxlan->dev->tstats);
 	rx_stats = this_cpu_ptr(dst_vxlan->dev->tstats);
@@ -1740,16 +1742,16 @@ static void vxlan_encap_bypass(struct sk
 
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
 


