Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaAMOjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:39:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51563 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaAMO0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 80/96] ipv6: don't count addrconf generated routes against gc limit
Date: Mon, 13 Jan 2014 14:24:43 +0000
Message-Id: <1389623099-18783-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit a3300ef4bbb1f1e33ff0400e1e6cf7733d988f4f upstream.

Brett Ciphery reported that new ipv6 addresses failed to get installed
because the addrconf generated dsts where counted against the dst gc
limit. We don't need to count those routes like we currently don't count
administratively added routes.

Because the max_addresses check enforces a limit on unbounded address
generation first in case someone plays with router advertisments, we
are still safe here.

Reported-by: Brett Ciphery <brett.ciphery@windriver.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/route.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2367444..5b8eac8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2112,13 +2112,11 @@ struct rt6_info *addrconf_dst_alloc(struct inet6_dev *idev,
 {
 	struct net *net = dev_net(idev->dev);
 	struct rt6_info *rt = ip6_dst_alloc(&net->ipv6.ip6_dst_ops,
-					    net->loopback_dev, 0);
+					    net->loopback_dev, DST_NOCOUNT);
 	int err;
 
-	if (!rt) {
-		net_warn_ratelimited("Maximum number of routes reached, consider increasing route/max_size\n");
+	if (!rt)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	in6_dev_hold(idev);
 
-- 
1.8.3.2

