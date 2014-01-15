Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaAOW36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:29:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40947 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaAOV5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 147/166] ipv6: don't count addrconf generated routes against gc limit
Date: Wed, 15 Jan 2014 13:52:41 -0800
Message-Id: <1389822780-4729-148-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/route.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9b530eb..7352014 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2128,13 +2128,12 @@ struct rt6_info *addrconf_dst_alloc(struct inet6_dev *idev,
 				    bool anycast)
 {
 	struct net *net = dev_net(idev->dev);
-	struct rt6_info *rt = ip6_dst_alloc(net, net->loopback_dev, 0, NULL);
+	struct rt6_info *rt = ip6_dst_alloc(net, net->loopback_dev,
+					    DST_NOCOUNT, NULL);
 	int err;
 
-	if (!rt) {
-		net_warn_ratelimited("Maximum number of routes reached, consider increasing route/max_size\n");
+	if (!rt)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	in6_dev_hold(idev);
 
-- 
1.8.3.2

