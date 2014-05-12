Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaELBoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:37 -0400
Received: from 1wt.eu ([62.212.114.60]:34799 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbaELBob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:31 -0400
Message-Id: <20140512003203.709572568@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 074/143] ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/route.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e307517..5af0d1e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -495,8 +495,11 @@ int rt6_route_rcv(struct net_device *dev, u8 *opt, int len,
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
-- 
1.7.12.2.21.g234cd45.dirty



