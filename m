Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3JUJdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:33:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39291 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab3JUIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Ding Tianhong" <dingtianhong@huawei.com>,
        "YOSHIFUJI Hideaki" <yoshfuji@linux-ipv6.org>,
        "P J P" <ppandit@redhat.com>, "George Kargiotakis" <kargig@void.gr>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.194004417@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 009/149] ipv6: remove max_addresses check from 
 ipv6_create_tempaddr
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/addrconf.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 314bda2..5d41293 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -913,12 +913,10 @@ retry:
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

