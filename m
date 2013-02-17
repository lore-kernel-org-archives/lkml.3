Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab3BQXGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:06:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45705 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab3BQWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:26 -0500
Message-Id: <20130217225007.450605139@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [ 50/66] ipv6: do not create neighbor entries for local  delivery
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Ricardo Leitner <mleitner@redhat.com>

[ Upstream commit bd30e947207e2ea0ff2c08f5b4a03025ddce48d3 ]

They will be created at output, if ever needed. This avoids creating
empty neighbor entries when TPROXYing/Forwarding packets for addresses
that are not even directly reachable.

Note that IPv4 already handles it this way. No neighbor entries are
created for local input.

Tested by myself and customer.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 19724bd..791c1fa 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -819,7 +819,8 @@ restart:
 	dst_hold(&rt->dst);
 	read_unlock_bh(&table->tb6_lock);
 
-	if (!dst_get_neighbour_raw(&rt->dst) && !(rt->rt6i_flags & RTF_NONEXTHOP))
+	if (!dst_get_neighbour_raw(&rt->dst)
+	    && !(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL)))
 		nrt = rt6_alloc_cow(rt, &fl6->daddr, &fl6->saddr);
 	else if (!(rt->dst.flags & DST_HOST))
 		nrt = rt6_alloc_clone(rt, &fl6->daddr);


