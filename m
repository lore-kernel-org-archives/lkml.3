Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbaE2Ef6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbaE2Efw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Timo=20Ter=E4s?= <timo.teras@iki.fi>,
        Tom Herbert <therbert@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 110/140] ipv4: ip_tunnels: disable cache for nbma gre tunnels
Date: Wed, 28 May 2014 21:34:09 -0700
Message-Id: <20140529043103.740161463@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>

[ Upstream commit 22fb22eaebf4d16987f3fd9c3484c436ee0badf2 ]

The connected check fails to check for ip_gre nbma mode tunnels
properly. ip_gre creates temporary tnl_params with daddr specified
to pass-in the actual target on per-packet basis from neighbor
layer. Detect these tunnels by inspecting the actual tunnel
configuration.

Minimal test case:
 ip route add 192.168.1.1/32 via 10.0.0.1
 ip route add 192.168.1.2/32 via 10.0.0.2
 ip tunnel add nbma0 mode gre key 1 tos c0
 ip addr add 172.17.0.0/16 dev nbma0
 ip link set nbma0 up
 ip neigh add 172.17.0.1 lladdr 192.168.1.1 dev nbma0
 ip neigh add 172.17.0.2 lladdr 192.168.1.2 dev nbma0
 ping 172.17.0.1
 ping 172.17.0.2

The second ping should be going to 192.168.1.2 and head 10.0.0.2;
but cached gre tunnel level route is used and it's actually going
to 192.168.1.1 via 10.0.0.1.

The lladdr's need to go to separate dst for the bug to trigger.
Test case uses separate route entries, but this can also happen
when the route entry is same: if there is a nexthop exception or
the GRE tunnel is IPsec'ed in which case the dst points to xfrm
bundle unique to the gre lladdr.

Fixes: 7d442fab0a67 ("ipv4: Cache dst in tunnels")
Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Cc: Tom Herbert <therbert@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -536,9 +536,10 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	unsigned int max_headroom;	/* The extra header space needed */
 	__be32 dst;
 	int err;
-	bool connected = true;
+	bool connected;
 
 	inner_iph = (const struct iphdr *)skb_inner_network_header(skb);
+	connected = (tunnel->parms.iph.daddr != 0);
 
 	dst = tnl_params->daddr;
 	if (dst == 0) {


