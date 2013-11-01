Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3KAVuC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:50:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab3KAVny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:43:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Debabrata Banerjee <dbavatar@gmail.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [ 10/32] ipv6: restrict neighbor entry creation to output flow
Date: Fri,  1 Nov 2013 14:43:21 -0700
Message-Id: <20131101214316.134394705@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101214313.735463599@linuxfoundation.org>
References: <20131101214313.735463599@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -818,7 +818,7 @@ static struct rt6_info *rt6_alloc_clone(
 }
 
 static struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table, int oif,
-				      struct flowi6 *fl6, int flags)
+				      struct flowi6 *fl6, int flags, bool input)
 {
 	struct fib6_node *fn;
 	struct rt6_info *rt, *nrt;
@@ -826,8 +826,11 @@ static struct rt6_info *ip6_pol_route(st
 	int attempts = 3;
 	int err;
 	int reachable = net->ipv6.devconf_all->forwarding ? 0 : RT6_LOOKUP_F_REACHABLE;
+	int local = RTF_NONEXTHOP;
 
 	strict |= flags & RT6_LOOKUP_F_IFACE;
+	if (input)
+		local |= RTF_LOCAL;
 
 relookup:
 	read_lock_bh(&table->tb6_lock);
@@ -847,7 +850,7 @@ restart:
 	read_unlock_bh(&table->tb6_lock);
 
 	if (!dst_get_neighbour_noref_raw(&rt->dst) &&
-	    !(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL)))
+	    !(rt->rt6i_flags & local))
 		nrt = rt6_alloc_cow(rt, &fl6->daddr, &fl6->saddr);
 	else if (!(rt->dst.flags & DST_HOST))
 		nrt = rt6_alloc_clone(rt, &fl6->daddr);
@@ -891,7 +894,7 @@ out2:
 static struct rt6_info *ip6_pol_route_input(struct net *net, struct fib6_table *table,
 					    struct flowi6 *fl6, int flags)
 {
-	return ip6_pol_route(net, table, fl6->flowi6_iif, fl6, flags);
+	return ip6_pol_route(net, table, fl6->flowi6_iif, fl6, flags, true);
 }
 
 static struct dst_entry *ip6_route_input_lookup(struct net *net,
@@ -924,7 +927,7 @@ void ip6_route_input(struct sk_buff *skb
 static struct rt6_info *ip6_pol_route_output(struct net *net, struct fib6_table *table,
 					     struct flowi6 *fl6, int flags)
 {
-	return ip6_pol_route(net, table, fl6->flowi6_oif, fl6, flags);
+	return ip6_pol_route(net, table, fl6->flowi6_oif, fl6, flags, false);
 }
 
 struct dst_entry * ip6_route_output(struct net *net, const struct sock *sk,


