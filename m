Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaAOV7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:59:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaAOV7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:32 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gao feng <gaofeng@cn.fujitsu.com>, Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 156/166] ipv6: always set the new created dst's from in ip6_rt_copy
Date: Wed, 15 Jan 2014 13:52:50 -0800
Message-Id: <1389822780-4729-157-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 24f5b855e17df7e355eacd6c4a12cc4d6a6c9ff0 ]

ip6_rt_copy only sets dst.from if ort has flag RTF_ADDRCONF and RTF_DEFAULT.
but the prefix routes which did get installed by hand locally can have an
expiration, and no any flag combination which can ensure a potential from
does never expire, so we should always set the new created dst's from.

This also fixes the new created dst is always expired since the ort, which
is created by RA, maybe has RTF_EXPIRES and RTF_ADDRCONF, but no RTF_DEFAULT.

Suggested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/route.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7352014..d8ba7c5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1867,9 +1867,7 @@ static struct rt6_info *ip6_rt_copy(struct rt6_info *ort,
 
 		rt->rt6i_gateway = ort->rt6i_gateway;
 		rt->rt6i_flags = ort->rt6i_flags;
-		if ((ort->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) ==
-		    (RTF_DEFAULT | RTF_ADDRCONF))
-			rt6_set_from(rt, ort);
+		rt6_set_from(rt, ort);
 		rt->rt6i_metric = 0;
 
 #ifdef CONFIG_IPV6_SUBTREES
-- 
1.8.3.2

