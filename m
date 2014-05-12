Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaELBx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:53:57 -0400
Received: from 1wt.eu ([62.212.114.60]:34719 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbaELBnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:22 -0400
Message-Id: <20140512003203.463380974@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        George Kargiotakis <kargig@void.gr>, P J P <ppandit@redhat.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 068/143] ipv6: remove max_addresses check from ipv6_create_tempaddr
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 4b08a8f1bd8cb4541c93ec170027b4d0782dab52 ]

Because of the max_addresses check attackers were able to disable privacy
extensions on an interface by creating enough autoconfigured addresses:

<http://seclists.org/oss-sec/2012/q4/292>

But the check is not actually needed: max_addresses protects the
kernel to install too many ipv6 addresses on an interface and guards
addrconf_prefix_rcv to install further addresses as soon as this limit
is reached. We only generate temporary addresses in direct response of
a new address showing up. As soon as we filled up the maximum number of
addresses of an interface, we stop installing more addresses and thus
also stop generating more temp addresses.

Even if the attacker tries to generate a lot of temporary addresses
by announcing a prefix and removing it again (lifetime == 0) we won't
install more temp addresses, because the temporary addresses do count
to the maximum number of addresses, thus we would stop installing new
autoconfigured addresses when the limit is reached.

This patch fixes CVE-2013-0343 (but other layer-2 attacks are still
possible).

Thanks to Ding Tianhong to bring this topic up again.

Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: George Kargiotakis <kargig@void.gr>
Cc: P J P <ppandit@redhat.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/addrconf.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 8ac3d09..e8c4fd9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -920,12 +920,10 @@ retry:
 	if (ifp->flags & IFA_F_OPTIMISTIC)
 		addr_flags |= IFA_F_OPTIMISTIC;
 
-	ift = !max_addresses ||
-	      ipv6_count_addresses(idev) < max_addresses ?
-		ipv6_add_addr(idev, &addr, tmp_plen,
-			      ipv6_addr_type(&addr)&IPV6_ADDR_SCOPE_MASK,
-			      addr_flags) : NULL;
-	if (!ift || IS_ERR(ift)) {
+	ift = ipv6_add_addr(idev, &addr, tmp_plen,
+			    ipv6_addr_type(&addr)&IPV6_ADDR_SCOPE_MASK,
+			    addr_flags);
+	if (IS_ERR(ift)) {
 		in6_ifa_put(ifp);
 		in6_dev_put(idev);
 		printk(KERN_INFO
-- 
1.7.12.2.21.g234cd45.dirty



