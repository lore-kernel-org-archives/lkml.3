Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab3JKTlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3JKTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 039/135] ip_tunnel: Do not use stale inner_iph pointer.
Date: Fri, 11 Oct 2013 12:38:40 -0700
Message-Id: <20131011193949.486759705@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

[ Upstream commit d4a71b155c12d0d429c6b69d94076d6d57e2a7a7 ]

While sending packet skb_cow_head() can change skb header which
invalidates inner_iph pointer to skb header. Following patch
avoid using it. Found by code inspection.

This bug was introduced by commit 0e6fbc5b6c6218 (ip_tunnels: extend
iptunnel_xmit()).

Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -626,6 +626,7 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 			tunnel->err_count = 0;
 	}
 
+	tos = ip_tunnel_ecn_encap(tos, inner_iph, skb);
 	ttl = tnl_params->ttl;
 	if (ttl == 0) {
 		if (skb->protocol == htons(ETH_P_IP))
@@ -655,7 +656,7 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 
 	err = iptunnel_xmit(dev_net(dev), rt, skb,
 			    fl4.saddr, fl4.daddr, protocol,
-			    ip_tunnel_ecn_encap(tos, inner_iph, skb), ttl, df);
+			    tos, ttl, df);
 	iptunnel_xmit_stats(err, &dev->stats, dev->tstats);
 
 	return;


