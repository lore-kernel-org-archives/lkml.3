Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932Ab3CZPWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964912Ab3CZPWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lorenzo Colitti <lorenzo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 039/150] net: ipv6: Don't purge default router if accept_ra=2
Date: Tue, 26 Mar 2013 15:18:58 +0000
Message-Id: <1364311249-14454-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Colitti <lorenzo@google.com>

commit 3e8b0ac3e41e3c882222a5522d5df7212438ab51 upstream.

Setting net.ipv6.conf.<interface>.accept_ra=2 causes the kernel
to accept RAs even when forwarding is enabled. However, enabling
forwarding purges all default routes on the system, breaking
connectivity until the next RA is received. Fix this by not
purging default routes on interfaces that have accept_ra=2.

Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 08c149c..577bb2f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1971,7 +1971,8 @@ void rt6_purge_dflt_routers(struct net *net)
 restart:
 	read_lock_bh(&table->tb6_lock);
 	for (rt = table->tb6_root.leaf; rt; rt = rt->dst.rt6_next) {
-		if (rt->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) {
+		if (rt->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF) &&
+		    (!rt->rt6i_idev || rt->rt6i_idev->cnf.accept_ra != 2)) {
 			dst_hold(&rt->dst);
 			read_unlock_bh(&table->tb6_lock);
 			ip6_del_rt(rt);
-- 
1.8.1.2

