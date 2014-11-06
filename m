Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaKFXZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:25:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaKFWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 005/162] sit: Fix ipip6_tunnel_lookup device matching criteria
Date: Thu,  6 Nov 2014 14:34:29 -0800
Message-Id: <1415313426-9622-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/sit.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 8f59675..9568c1f 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -101,19 +101,19 @@ static struct ip_tunnel *ipip6_tunnel_lookup(struct net *net,
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
-- 
1.9.1

