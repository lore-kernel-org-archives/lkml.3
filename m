Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3KRSqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:46:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KRSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:42:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Schmitt <peter.schmitt82@yahoo.de>,
        Pravin B Shelar <pshelar@nicira.com>
Subject: [PATCH 3.10 01/24] ip_gre: Fix WCCPv2 header parsing.
Date: Mon, 18 Nov 2013 10:42:11 -0800
Message-Id: <20131118184222.158956366@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184222.017393843@linuxfoundation.org>
References: <20131118184222.017393843@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

[ No applicable upstream commit, the upstream implementation is
  now completely different and doesn't have this bug. ]

In case of WCCPv2 GRE header has extra four bytes.  Following
patch pull those extra four bytes so that skb offsets are set
correctly.

CC: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: Peter Schmitt <peter.schmitt82@yahoo.de>
Tested-by: Peter Schmitt <peter.schmitt82@yahoo.de>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_tunnels.h |    2 +-
 net/ipv4/ip_gre.c        |    2 +-
 net/ipv4/ip_tunnel.c     |    4 ++--
 net/ipv4/ipip.c          |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -113,7 +113,7 @@ struct ip_tunnel *ip_tunnel_lookup(struc
 				   __be32 key);
 
 int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
-		  const struct tnl_ptk_info *tpi, bool log_ecn_error);
+		  const struct tnl_ptk_info *tpi, int hdr_len, bool log_ecn_error);
 int ip_tunnel_changelink(struct net_device *dev, struct nlattr *tb[],
 			 struct ip_tunnel_parm *p);
 int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -335,7 +335,7 @@ static int ipgre_rcv(struct sk_buff *skb
 				  iph->saddr, iph->daddr, tpi.key);
 
 	if (tunnel) {
-		ip_tunnel_rcv(tunnel, skb, &tpi, log_ecn_error);
+		ip_tunnel_rcv(tunnel, skb, &tpi, hdr_len, log_ecn_error);
 		return 0;
 	}
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -402,7 +402,7 @@ static struct ip_tunnel *ip_tunnel_creat
 }
 
 int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
-		  const struct tnl_ptk_info *tpi, bool log_ecn_error)
+		  const struct tnl_ptk_info *tpi, int hdr_len, bool log_ecn_error)
 {
 	struct pcpu_tstats *tstats;
 	const struct iphdr *iph = ip_hdr(skb);
@@ -413,7 +413,7 @@ int ip_tunnel_rcv(struct ip_tunnel *tunn
 	skb->protocol = tpi->proto;
 
 	skb->mac_header = skb->network_header;
-	__pskb_pull(skb, tunnel->hlen);
+	__pskb_pull(skb, hdr_len);
 	skb_postpull_rcsum(skb, skb_transport_header(skb), tunnel->hlen);
 #ifdef CONFIG_NET_IPGRE_BROADCAST
 	if (ipv4_is_multicast(iph->daddr)) {
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -195,7 +195,7 @@ static int ipip_rcv(struct sk_buff *skb)
 	if (tunnel) {
 		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 			goto drop;
-		return ip_tunnel_rcv(tunnel, skb, &tpi, log_ecn_error);
+		return ip_tunnel_rcv(tunnel, skb, &tpi, 0, log_ecn_error);
 	}
 
 	return -1;


