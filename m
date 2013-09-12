Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3ILSVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:21:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab3ILR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Ding Tianhong <dingtianhong@huawei.com>,
        George Kargiotakis <kargig@void.gr>, P J P <ppandit@redhat.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 20/46] ipv6: remove max_addresses check from ipv6_create_tempaddr
Date: Thu, 12 Sep 2013 10:58:31 -0700
Message-Id: <20130912175723.226673291@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: George Kargiotakis <kargig@void.gr>
Cc: P J P <ppandit@redhat.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Acked-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1124,12 +1124,10 @@ retry:
 	if (ifp->flags & IFA_F_OPTIMISTIC)
 		addr_flags |= IFA_F_OPTIMISTIC;
 
-	ift = !max_addresses ||
-	      ipv6_count_addresses(idev) < max_addresses ?
-		ipv6_add_addr(idev, &addr, tmp_plen,
-			      ipv6_addr_type(&addr)&IPV6_ADDR_SCOPE_MASK,
-			      addr_flags) : NULL;
-	if (IS_ERR_OR_NULL(ift)) {
+	ift = ipv6_add_addr(idev, &addr, tmp_plen,
+			    ipv6_addr_type(&addr)&IPV6_ADDR_SCOPE_MASK,
+			    addr_flags);
+	if (IS_ERR(ift)) {
 		in6_ifa_put(ifp);
 		in6_dev_put(idev);
 		pr_info("%s: retry temporary address regeneration\n", __func__);


