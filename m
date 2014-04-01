Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaDAQJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44357 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaDAQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 10/86] ipv4: fix counter in_slow_tot
Date: Tue,  1 Apr 2014 09:07:23 -0700
Message-Id: <1396368519-12728-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

[ Upstream commit a6254864c08109c66a194612585afc0439005286 ]

since commit 89aef8921bf("ipv4: Delete routing cache."), the counter
in_slow_tot can't work correctly.

The counter in_slow_tot increase by one when fib_lookup() return successfully
in ip_route_input_slow(), but actually the dst struct maybe not be created and
cached, so we can increase in_slow_tot after the dst struct is created.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index c219f8b..fde4930 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1548,6 +1548,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	rth->rt_gateway	= 0;
 	rth->rt_uses_gateway = 0;
 	INIT_LIST_HEAD(&rth->rt_uncached);
+	RT_CACHE_STAT_INC(in_slow_tot);
 
 	rth->dst.input = ip_forward;
 	rth->dst.output = ip_output;
@@ -1649,8 +1650,6 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (err != 0)
 		goto no_route;
 
-	RT_CACHE_STAT_INC(in_slow_tot);
-
 	if (res.type == RTN_BROADCAST)
 		goto brd_input;
 
@@ -1719,6 +1718,7 @@ local_input:
 	rth->rt_gateway	= 0;
 	rth->rt_uses_gateway = 0;
 	INIT_LIST_HEAD(&rth->rt_uncached);
+	RT_CACHE_STAT_INC(in_slow_tot);
 	if (res.type == RTN_UNREACHABLE) {
 		rth->dst.input= ip_error;
 		rth->dst.error= -err;
-- 
1.8.3.2

