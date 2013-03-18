Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3CRVNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:13:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab3CRVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lorenzo Colitti <lorenzo@google.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 33/40] net: ipv6: Dont purge default router if accept_ra=2
Date: Mon, 18 Mar 2013 14:11:11 -0700
Message-Id: <20130318211018.627949528@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Lorenzo Colitti <lorenzo@google.com>

[ Upstream commit 3e8b0ac3e41e3c882222a5522d5df7212438ab51 ]

Setting net.ipv6.conf.<interface>.accept_ra=2 causes the kernel
to accept RAs even when forwarding is enabled. However, enabling
forwarding purges all default routes on the system, breaking
connectivity until the next RA is received. Fix this by not
purging default routes on interfaces that have accept_ra=2.

Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1885,7 +1885,8 @@ void rt6_purge_dflt_routers(struct net *
 restart:
 	read_lock_bh(&table->tb6_lock);
 	for (rt = table->tb6_root.leaf; rt; rt = rt->dst.rt6_next) {
-		if (rt->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) {
+		if (rt->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF) &&
+		    (!rt->rt6i_idev || rt->rt6i_idev->cnf.accept_ra != 2)) {
 			dst_hold(&rt->dst);
 			read_unlock_bh(&table->tb6_lock);
 			ip6_del_rt(rt);


