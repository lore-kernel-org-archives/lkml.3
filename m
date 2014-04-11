Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbaDKQj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:39:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422832AbaDKQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>, Pravin B Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 41/65] ip_tunnel: Fix dst ref-count.
Date: Fri, 11 Apr 2014 09:11:13 -0700
Message-Id: <20140411161003.365561626@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

[ Upstream commit fbd02dd405d0724a0f25897ed4a6813297c9b96f ]

Commit 10ddceb22ba (ip_tunnel:multicast process cause panic due
to skb->_skb_refdst NULL pointer) removed dst-drop call from
ip-tunnel-recv.

Following commit reintroduce dst-drop and fix the original bug by
checking loopback packet before releasing dst.
Original bug: https://bugzilla.kernel.org/show_bug.cgi?id=70681

CC: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/gre_demux.c      |    8 ++++++++
 net/ipv4/ip_tunnel.c      |    3 ---
 net/ipv4/ip_tunnel_core.c |    1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -182,6 +182,14 @@ static int gre_cisco_rcv(struct sk_buff
 	int i;
 	bool csum_err = false;
 
+#ifdef CONFIG_NET_IPGRE_BROADCAST
+	if (ipv4_is_multicast(ip_hdr(skb)->daddr)) {
+		/* Looped back packet, drop it! */
+		if (rt_is_output_route(skb_rtable(skb)))
+			goto drop;
+	}
+#endif
+
 	if (parse_gre_header(skb, &tpi, &csum_err) < 0)
 		goto drop;
 
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -411,9 +411,6 @@ int ip_tunnel_rcv(struct ip_tunnel *tunn
 
 #ifdef CONFIG_NET_IPGRE_BROADCAST
 	if (ipv4_is_multicast(iph->daddr)) {
-		/* Looped back packet, drop it! */
-		if (rt_is_output_route(skb_rtable(skb)))
-			goto drop;
 		tunnel->dev->stats.multicast++;
 		skb->pkt_type = PACKET_BROADCAST;
 	}
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -109,6 +109,7 @@ int iptunnel_pull_header(struct sk_buff
 	secpath_reset(skb);
 	if (!skb->l4_rxhash)
 		skb->rxhash = 0;
+	skb_dst_drop(skb);
 	skb->vlan_tci = 0;
 	skb_set_queue_mapping(skb, 0);
 	skb->pkt_type = PACKET_HOST;


