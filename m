Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3CZRoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:44:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab3CZRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:24 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=c6cH9FFDCqgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4SWGh5JxyX0A:10 a=1XWaLZrsAAAA:8 a=h1aNt0RaAAAA:8 a=J1Y8HTJGAAAA:8 a=_9B7Tu4NL9n9XWRaZBIA:9 a=UTB_XpHje0EA:10 a=9n0VZpmWo7gA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173607.644637377@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lorenzo Colitti <lorenzo@google.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 48/86] net: ipv6: Dont purge default router if accept_ra=2
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0048-net-ipv6-Don-t-purge-default-router-if-accept_ra-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 net/ipv6/route.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2ffaa7a..db30daf 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1943,7 +1943,8 @@ void rt6_purge_dflt_routers(struct net *net)
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
1.7.10.4


