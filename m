Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3L2Cpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:45:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55263 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444Ab3L2CK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:27 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Duan Jiong" <duanj.fnst@cn.fujitsu.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.224350176@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 150/185] ipv6: use rt6_get_dflt_router to get default
 router in  rt6_route_rcv
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

[ Upstream commit f104a567e673f382b09542a8dc3500aa689957b4 ]

As the rfc 4191 said, the Router Preference and Lifetime values in a
::/0 Route Information Option should override the preference and lifetime
values in the Router Advertisement header. But when the kernel deals with
a ::/0 Route Information Option, the rt6_get_route_info() always return
NULL, that means that overriding will not happen, because those default
routers were added without flag RTF_ROUTEINFO in rt6_add_dflt_router().

In order to deal with that condition, we should call rt6_get_dflt_router
when the prefix length is 0.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/route.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index bc9103d..1768238 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -592,8 +592,11 @@ int rt6_route_rcv(struct net_device *dev, u8 *opt, int len,
 		prefix = &prefix_buf;
 	}
 
-	rt = rt6_get_route_info(net, prefix, rinfo->prefix_len, gwaddr,
-				dev->ifindex);
+	if (rinfo->prefix_len == 0)
+		rt = rt6_get_dflt_router(gwaddr, dev);
+	else
+		rt = rt6_get_route_info(net, prefix, rinfo->prefix_len,
+					gwaddr, dev->ifindex);
 
 	if (rt && !lifetime) {
 		ip6_del_rt(rt);

