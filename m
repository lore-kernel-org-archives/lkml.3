Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaJMCyz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:54:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbaJMC0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 07/37] sit: Fix ipip6_tunnel_lookup device matching criteria
Date: Mon, 13 Oct 2014 04:24:04 +0200
Message-Id: <20141013022400.604067609@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shmulik Ladkani <shmulik.ladkani@gmail.com>

[ Upstream commit bc8fc7b8f825ef17a0fb9e68c18ce94fa66ab337 ]

As of 4fddbf5d78 ("sit: strictly restrict incoming traffic to tunnel link device"),
when looking up a tunnel, tunnel's underlying interface (t->parms.link)
is verified to match incoming traffic's ingress device.

However the comparison was incorrectly based on skb->dev->iflink.

Instead, dev->ifindex should be used, which correctly represents the
interface from which the IP stack hands the ipip6 packets.

This allows setting up sit tunnels bound to vlan interfaces (otherwise
incoming ipip6 traffic on the vlan interface was dropped due to
ipip6_tunnel_lookup match failure).

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -101,19 +101,19 @@ static struct ip_tunnel *ipip6_tunnel_lo
 	for_each_ip_tunnel_rcu(t, sitn->tunnels_r_l[h0 ^ h1]) {
 		if (local == t->parms.iph.saddr &&
 		    remote == t->parms.iph.daddr &&
-		    (!dev || !t->parms.link || dev->iflink == t->parms.link) &&
+		    (!dev || !t->parms.link || dev->ifindex == t->parms.link) &&
 		    (t->dev->flags & IFF_UP))
 			return t;
 	}
 	for_each_ip_tunnel_rcu(t, sitn->tunnels_r[h0]) {
 		if (remote == t->parms.iph.daddr &&
-		    (!dev || !t->parms.link || dev->iflink == t->parms.link) &&
+		    (!dev || !t->parms.link || dev->ifindex == t->parms.link) &&
 		    (t->dev->flags & IFF_UP))
 			return t;
 	}
 	for_each_ip_tunnel_rcu(t, sitn->tunnels_l[h1]) {
 		if (local == t->parms.iph.saddr &&
-		    (!dev || !t->parms.link || dev->iflink == t->parms.link) &&
+		    (!dev || !t->parms.link || dev->ifindex == t->parms.link) &&
 		    (t->dev->flags & IFF_UP))
 			return t;
 	}


