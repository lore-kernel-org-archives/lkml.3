Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3KYNyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:54:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58847 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681Ab3KYNxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:44 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcelo Ricardo Leitner" <mleitner@redhat.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "Debabrata Banerjee" <dbavatar@gmail.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.450756093@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 08/87] ipv6: restrict neighbor entry creation to
 output flow
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Ricardo Leitner <mleitner@redhat.com>

This patch is based on 3.2.y branch, the one used by reporter. Please let me
know if it should be different. Thanks.

The patch which introduced the regression was applied on stables:
3.0.64 3.4.31 3.7.8 3.2.39

The patch which introduced the regression was for stable trees only.

---8<---

Commit 0d6a77079c475033cb622c07c5a880b392ef664e "ipv6: do not create
neighbor entries for local delivery" introduced a regression on
which routes to local delivery would not work anymore. Like this:

    $ ip -6 route add local 2001::/64 dev lo
    $ ping6 -c1 2001::9
    PING 2001::9(2001::9) 56 data bytes
    ping: sendmsg: Invalid argument

As this is a local delivery, that commit would not allow the creation of a
neighbor entry and thus the packet cannot be sent.

But as TPROXY scenario actually needs to avoid the neighbor entry creation only
for input flow, this patch now limits previous patch to input flow, keeping
output as before that patch.

Reported-by: Debabrata Banerjee <dbavatar@gmail.com>
Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/route.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 18ea73c..bc9103d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -791,7 +791,7 @@ static struct rt6_info *rt6_alloc_clone(struct rt6_info *ort,
 }
 
 static struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table, int oif,
-				      struct flowi6 *fl6, int flags)
+				      struct flowi6 *fl6, int flags, bool input)
 {
 	struct fib6_node *fn;
 	struct rt6_info *rt, *nrt;
@@ -799,8 +799,11 @@ static struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 	int attempts = 3;
 	int err;
 	int reachable = net->ipv6.devconf_all->forwarding ? 0 : RT6_LOOKUP_F_REACHABLE;
+	int local = RTF_NONEXTHOP;
 
 	strict |= flags & RT6_LOOKUP_F_IFACE;
+	if (input)
+		local |= RTF_LOCAL;
 
 relookup:
 	read_lock_bh(&table->tb6_lock);
@@ -820,7 +823,7 @@ restart:
 	read_unlock_bh(&table->tb6_lock);
 
 	if (!dst_get_neighbour_raw(&rt->dst)
-	    && !(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL)))
+	    && !(rt->rt6i_flags & local))
 		nrt = rt6_alloc_cow(rt, &fl6->daddr, &fl6->saddr);
 	else if (!(rt->dst.flags & DST_HOST))
 		nrt = rt6_alloc_clone(rt, &fl6->daddr);
@@ -864,7 +867,7 @@ out2:
 static struct rt6_info *ip6_pol_route_input(struct net *net, struct fib6_table *table,
 					    struct flowi6 *fl6, int flags)
 {
-	return ip6_pol_route(net, table, fl6->flowi6_iif, fl6, flags);
+	return ip6_pol_route(net, table, fl6->flowi6_iif, fl6, flags, true);
 }
 
 void ip6_route_input(struct sk_buff *skb)
@@ -890,7 +893,7 @@ void ip6_route_input(struct sk_buff *skb)
 static struct rt6_info *ip6_pol_route_output(struct net *net, struct fib6_table *table,
 					     struct flowi6 *fl6, int flags)
 {
-	return ip6_pol_route(net, table, fl6->flowi6_oif, fl6, flags);
+	return ip6_pol_route(net, table, fl6->flowi6_oif, fl6, flags, false);
 }
 
 struct dst_entry * ip6_route_output(struct net *net, const struct sock *sk,

