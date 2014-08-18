Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaHRJgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:36:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43003 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaHRJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sabrina Dubroca <sd@queasysnail.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Weilong Chen <chenweilong@huawei.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 100/137] ipv6: reallocate addrconf router for ipv6 address when lo device up
Date: Mon, 18 Aug 2014 10:32:41 +0100
Message-Id: <1408354398-10226-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

commit 33d99113b1102c2d2f8603b9ba72d89d915c13f5 upstream.

commit 25fb6ca4ed9cad72f14f61629b68dc03c0d9713f
"net IPv6 : Fix broken IPv6 routing table after loopback down-up"
allocates addrconf router for ipv6 address when lo device up.
but commit a881ae1f625c599b460cc8f8a7fcb1c438f699ad
"ipv6:don't call addrconf_dst_alloc again when enable lo" breaks
this behavior.

Since the addrconf router is moved to the garbage list when
lo device down, we should release this router and rellocate
a new one for ipv6 address when lo device up.

This patch solves bug 67951 on bugzilla
https://bugzilla.kernel.org/show_bug.cgi?id=67951

change from v1:
use ip6_rt_put to repleace ip6_del_rt, thanks Hannes!
change code style, suggested by Sergei.

CC: Sabrina Dubroca <sd@queasysnail.net>
CC: Hannes Frederic Sowa <hannes@stressinduktion.org>
Reported-by: Weilong Chen <chenweilong@huawei.com>
Signed-off-by: Weilong Chen <chenweilong@huawei.com>
Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/addrconf.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a6ddced9d535..e90ae34ae7ff 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2685,8 +2685,18 @@ static void init_loopback(struct net_device *dev)
 			if (sp_ifa->flags & (IFA_F_DADFAILED | IFA_F_TENTATIVE))
 				continue;
 
-			if (sp_ifa->rt)
-				continue;
+			if (sp_ifa->rt) {
+				/* This dst has been added to garbage list when
+				 * lo device down, release this obsolete dst and
+				 * reallocate a new router for ifa.
+				 */
+				if (sp_ifa->rt->dst.obsolete > 0) {
+					ip6_rt_put(sp_ifa->rt);
+					sp_ifa->rt = NULL;
+				} else {
+					continue;
+				}
+			}
 
 			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
 
-- 
1.9.1

