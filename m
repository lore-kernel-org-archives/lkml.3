Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaHESdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:33:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaHESaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:30:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Weilong Chen <chenweilong@huawei.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 19/19] ipv6: reallocate addrconf router for ipv6 address when lo device up
Date: Tue,  5 Aug 2014 11:29:43 -0700
Message-Id: <20140805182934.619752104@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805182934.022406678@linuxfoundation.org>
References: <20140805182934.022406678@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[weilong: s/ip6_rt_put/dst_release]
Signed-off-by: Chen Weilong <chenweilong@huawei.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/addrconf.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2438,8 +2438,18 @@ static void init_loopback(struct net_dev
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
+					dst_release(sp_ifa->rt);
+					sp_ifa->rt = NULL;
+				} else {
+					continue;
+				}
+			}
 
 			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
 


