Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaAMQRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:17:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbaAMQEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 173/208] ipv6: don't count addrconf generated routes against gc limit
Date: Mon, 13 Jan 2014 16:00:14 +0000
Message-Id: <1389628849-1614-174-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/route.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ff3223c..9e0f8e1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2122,12 +2122,10 @@ struct rt6_info *addrconf_dst_alloc(struct inet6_dev *idev,
 				    bool anycast)
 {
 	struct net *net = dev_net(idev->dev);
-	struct rt6_info *rt = ip6_dst_alloc(net, net->loopback_dev, 0, NULL);
-
-	if (!rt) {
-		net_warn_ratelimited("Maximum number of routes reached, consider increasing route/max_size\n");
+	struct rt6_info *rt = ip6_dst_alloc(net, net->loopback_dev,
+					    DST_NOCOUNT, NULL);
+	if (!rt)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	in6_dev_hold(idev);
 
-- 
1.8.3.2

