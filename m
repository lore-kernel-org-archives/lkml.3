Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaBLIlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:41:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50050 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbaBLINs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:48 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Brett Ciphery" <brett.ciphery@windriver.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.206777558@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 03/79] ipv6: don't count addrconf generated routes
 against gc  limit
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit a3300ef4bbb1f1e33ff0400e1e6cf7733d988f4f ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/route.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1768238..9a4f437 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2058,15 +2058,11 @@ struct rt6_info *addrconf_dst_alloc(struct inet6_dev *idev,
 {
 	struct net *net = dev_net(idev->dev);
 	struct rt6_info *rt = ip6_dst_alloc(&net->ipv6.ip6_dst_ops,
-					    net->loopback_dev, 0);
+					    net->loopback_dev, DST_NOCOUNT);
 	struct neighbour *neigh;
 
-	if (rt == NULL) {
-		if (net_ratelimit())
-			pr_warning("IPv6:  Maximum number of routes reached,"
-				   " consider increasing route/max_size.\n");
+	if (rt == NULL)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	in6_dev_hold(idev);
 

