Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab3HMQEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:04:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25171 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab3HMP6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:32 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=mInUbHif3t4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ZobJRoBlAnYA:10 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155827.394733965@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [24/88] ipv6: assign rt6_info to inet6_ifaddr in init_loopback
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0024-ipv6-assign-rt6_info-to-inet6_ifaddr-in-init_loopbac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 534c877928a16ae5f9776436a497109639bf67dc ]

Commit 25fb6ca4ed9cad72f14f61629b68dc03c0d9713f
"net IPv6 : Fix broken IPv6 routing table after loopback down-up"
forgot to assign rt6_info to the inet6_ifaddr.
When disable the net device, the rt6_info which allocated
in init_loopback will not be destroied in __ipv6_ifa_notify.

This will trigger the waring message below
[23527.916091] unregister_netdevice: waiting for tap0 to become free. Usage count = 1

Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv6/addrconf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dd8549a..72d9dea 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2430,8 +2430,10 @@ static void init_loopback(struct net_device *dev)
 			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
 
 			/* Failure cases are ignored */
-			if (!IS_ERR(sp_rt))
+			if (!IS_ERR(sp_rt)) {
+				sp_ifa->rt = sp_rt;
 				ip6_ins_rt(sp_rt);
+			}
 		}
 		read_unlock_bh(&idev->lock);
 	}
-- 
1.7.10.4


