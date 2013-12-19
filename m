Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab3LSNLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:11:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3LSLzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 007/208] ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv
Date: Thu, 19 Dec 2013 11:51:45 +0000
Message-Id: <1387454106-19326-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

commit f104a567e673f382b09542a8dc3500aa689957b4 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/route.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c9bd97b..b297e11 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -732,8 +732,11 @@ int rt6_route_rcv(struct net_device *dev, u8 *opt, int len,
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
1.8.3.2

