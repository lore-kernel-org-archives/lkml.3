Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaAMQOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:14:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaAMQFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gao feng <gaofeng@cn.fujitsu.com>, Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 185/208] ipv6: always set the new created dst's from in ip6_rt_copy
Date: Mon, 13 Jan 2014 16:00:26 +0000
Message-Id: <1389628849-1614-186-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

commit 24f5b855e17df7e355eacd6c4a12cc4d6a6c9ff0 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/route.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9e0f8e1..2a0f219 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1861,9 +1861,7 @@ static struct rt6_info *ip6_rt_copy(struct rt6_info *ort,
 		else
 			rt->rt6i_gateway = *dest;
 		rt->rt6i_flags = ort->rt6i_flags;
-		if ((ort->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) ==
-		    (RTF_DEFAULT | RTF_ADDRCONF))
-			rt6_set_from(rt, ort);
+		rt6_set_from(rt, ort);
 		rt->rt6i_metric = 0;
 
 #ifdef CONFIG_IPV6_SUBTREES
-- 
1.8.3.2

