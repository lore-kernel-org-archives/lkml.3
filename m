Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab3LFWmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:42:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894Ab3LFVw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Isaku Yamahata <yamahatanetdev@gmail.com>,
        Maciej Zenczykowski <zenczykowski@gmail.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 13/83] core/dev: do not ignore dmac in dev_forward_skb()
Date: Fri,  6 Dec 2013 13:51:03 -0800
Message-Id: <20131206214641.300582962@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

[ Upstream commit 81b9eab5ebbf0d5d54da4fc168cfb02c2adc76b8 ]

commit 06a23fe31ca3
("core/dev: set pkt_type after eth_type_trans() in dev_forward_skb()")
and refactoring 64261f230a91
("dev: move skb_scrub_packet() after eth_type_trans()")

are forcing pkt_type to be PACKET_HOST when skb traverses veth.

which means that ip forwarding will kick in inside netns
even if skb->eth->h_dest != dev->dev_addr

Fix order of eth_type_trans() and skb_scrub_packet() in dev_forward_skb()
and in ip_tunnel_rcv()

Fixes: 06a23fe31ca3 ("core/dev: set pkt_type after eth_type_trans() in dev_forward_skb()")
CC: Isaku Yamahata <yamahatanetdev@gmail.com>
CC: Maciej Zenczykowski <zenczykowski@gmail.com>
CC: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c       |    6 +-----
 net/ipv4/ip_tunnel.c |    4 ++--
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1691,13 +1691,9 @@ int dev_forward_skb(struct net_device *d
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
-	skb->protocol = eth_type_trans(skb, dev);
 
-	/* eth_type_trans() can set pkt_type.
-	 * call skb_scrub_packet() after it to clear pkt_type _after_ calling
-	 * eth_type_trans().
-	 */
 	skb_scrub_packet(skb, true);
+	skb->protocol = eth_type_trans(skb, dev);
 
 	return netif_rx(skb);
 }
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -454,6 +454,8 @@ int ip_tunnel_rcv(struct ip_tunnel *tunn
 	tstats->rx_bytes += skb->len;
 	u64_stats_update_end(&tstats->syncp);
 
+	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(tunnel->dev)));
+
 	if (tunnel->dev->type == ARPHRD_ETHER) {
 		skb->protocol = eth_type_trans(skb, tunnel->dev);
 		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
@@ -461,8 +463,6 @@ int ip_tunnel_rcv(struct ip_tunnel *tunn
 		skb->dev = tunnel->dev;
 	}
 
-	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(tunnel->dev)));
-
 	gro_cells_receive(&tunnel->gro_cells, skb);
 	return 0;
 


