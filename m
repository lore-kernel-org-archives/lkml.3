Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3I3K27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:28:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3I3KMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        George Kargiotakis <kargig@void.gr>, P J P <ppandit@redhat.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 049/104] ipv6: remove max_addresses check from ipv6_create_tempaddr
Date: Mon, 30 Sep 2013 11:10:26 +0100
Message-Id: <1380535881-9239-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 4b08a8f1bd8cb4541c93ec170027b4d0782dab52 upstream.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/addrconf.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 5e23f99..f4d2364 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -909,12 +909,10 @@ retry:
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
 		pr_info("%s: retry temporary address regeneration\n", __func__);
-- 
1.8.3.2

