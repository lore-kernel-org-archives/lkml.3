Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaG3Mjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:39:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36672 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbaG3MP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Popov <ixaphire@qrator.net>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 31/94] ip_tunnel: fix ip_tunnel_lookup
Date: Wed, 30 Jul 2014 14:14:20 +0200
Message-Id: <a1258d5375d479c6391391e0a86a118c1819fe4c.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit e0056593b61253f1a8a9941dacda22e73b963cdc ]

This patch fixes 3 similar bugs where incoming packets might be routed into
wrong non-wildcard tunnels:

1) Consider the following setup:
    ip address add 1.1.1.1/24 dev eth0
    ip address add 1.1.1.2/24 dev eth0
    ip tunnel add ipip1 remote 2.2.2.2 local 1.1.1.1 mode ipip dev eth0
    ip link set ipip1 up

Incoming ipip packets from 2.2.2.2 were routed into ipip1 even if it has dst =
1.1.1.2. Moreover even if there was wildcard tunnel like
   ip tunnel add ipip0 remote 2.2.2.2 local any mode ipip dev eth0
but it was created before explicit one (with local 1.1.1.1), incoming ipip
packets with src = 2.2.2.2 and dst = 1.1.1.2 were still routed into ipip1.

Same issue existed with all tunnels that use ip_tunnel_lookup (gre, vti)

2)  ip address add 1.1.1.1/24 dev eth0
    ip tunnel add ipip1 remote 2.2.146.85 local 1.1.1.1 mode ipip dev eth0
    ip link set ipip1 up

Incoming ipip packets with dst = 1.1.1.1 were routed into ipip1, no matter what
src address is. Any remote ip address which has ip_tunnel_hash = 0 raised this
issue, 2.2.146.85 is just an example, there are more than 4 million of them.
And again, wildcard tunnel like
   ip tunnel add ipip0 remote any local 1.1.1.1 mode ipip dev eth0
wouldn't be ever matched if it was created before explicit tunnel like above.

Gre & vti tunnels had the same issue.

3)  ip address add 1.1.1.1/24 dev eth0
    ip tunnel add gre1 remote 2.2.146.84 local 1.1.1.1 key 1 mode gre dev eth0
    ip link set gre1 up

Any incoming gre packet with key = 1 were routed into gre1, no matter what
src/dst addresses are. Any remote ip address which has ip_tunnel_hash = 0 raised
the issue, 2.2.146.84 is just an example, there are more than 4 million of them.
Wildcard tunnel like
   ip tunnel add gre2 remote any local any key 1 mode gre dev eth0
wouldn't be ever matched if it was created before explicit tunnel like above.

All this stuff happened because while looking for a wildcard tunnel we didn't
check that matched tunnel is a wildcard one. Fixed.

Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/ip_tunnel.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index d9dbe0f78612..edd5a8171357 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -166,6 +166,7 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 
 	hlist_for_each_entry_rcu(t, head, hash_node) {
 		if (remote != t->parms.iph.daddr ||
+		    t->parms.iph.saddr != 0 ||
 		    !(t->dev->flags & IFF_UP))
 			continue;
 
@@ -182,10 +183,11 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 	head = &itn->tunnels[hash];
 
 	hlist_for_each_entry_rcu(t, head, hash_node) {
-		if ((local != t->parms.iph.saddr &&
-		     (local != t->parms.iph.daddr ||
-		      !ipv4_is_multicast(local))) ||
-		    !(t->dev->flags & IFF_UP))
+		if ((local != t->parms.iph.saddr || t->parms.iph.daddr != 0) &&
+		    (local != t->parms.iph.daddr || !ipv4_is_multicast(local)))
+			continue;
+
+		if (!(t->dev->flags & IFF_UP))
 			continue;
 
 		if (!ip_tunnel_key_match(&t->parms, flags, key))
@@ -202,6 +204,8 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 
 	hlist_for_each_entry_rcu(t, head, hash_node) {
 		if (t->parms.i_key != key ||
+		    t->parms.iph.saddr != 0 ||
+		    t->parms.iph.daddr != 0 ||
 		    !(t->dev->flags & IFF_UP))
 			continue;
 
-- 
2.0.1

