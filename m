Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaDRJbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:31:03 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45997 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbaDRJWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@nicira.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 56/72] ip_tunnel: Fix dst ref-count.
Date: Fri, 18 Apr 2014 11:22:29 +0200
Message-Id: <71986b40bf31e6d726846409722b1ec91ada162c.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pravin B Shelar <pshelar@nicira.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/gre_demux.c      | 8 ++++++++
 net/ipv4/ip_tunnel.c      | 3 ---
 net/ipv4/ip_tunnel_core.c | 1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index 736c9fc3ef93..0c0c1f09fd17 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -211,6 +211,14 @@ static int gre_cisco_rcv(struct sk_buff *skb)
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
 
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 995a0bb33a65..3bedb26cfb53 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -411,9 +411,6 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 
 #ifdef CONFIG_NET_IPGRE_BROADCAST
 	if (ipv4_is_multicast(iph->daddr)) {
-		/* Looped back packet, drop it! */
-		if (rt_is_output_route(skb_rtable(skb)))
-			goto drop;
 		tunnel->dev->stats.multicast++;
 		skb->pkt_type = PACKET_BROADCAST;
 	}
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index ba22cc3a5a53..c31e3ad98ef2 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -109,6 +109,7 @@ int iptunnel_pull_header(struct sk_buff *skb, int hdr_len, __be16 inner_proto)
 	secpath_reset(skb);
 	if (!skb->l4_rxhash)
 		skb->rxhash = 0;
+	skb_dst_drop(skb);
 	skb->vlan_tci = 0;
 	skb_set_queue_mapping(skb, 0);
 	skb->pkt_type = PACKET_HOST;
-- 
1.9.2

