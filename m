Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3FYSjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:39:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3FYSjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:39:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 12/17] ipv6: assign rt6_info to inet6_ifaddr in init_loopback
Date: Tue, 25 Jun 2013 11:39:27 -0700
Message-Id: <20130625183916.821800449@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183915.443950649@linuxfoundation.org>
References: <20130625183915.443950649@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2360,8 +2360,10 @@ static void init_loopback(struct net_dev
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


