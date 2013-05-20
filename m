Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3ETK6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:58:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56417 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab3ETKyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 098/115] xfrm6: release dev before returning error
Date: Mon, 20 May 2013 11:51:38 +0100
Message-Id: <1369047116-9378-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

commit 84c4a9dfbf430861e7588d95ae3ff61535dca351 upstream.

We forget to call dev_put() on error path in xfrm6_fill_dst(),
its caller doesn't handle this.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/xfrm6_policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 8625fba..1cfb9a4 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -96,8 +96,10 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	dev_hold(dev);
 
 	xdst->u.rt6.rt6i_idev = in6_dev_get(dev);
-	if (!xdst->u.rt6.rt6i_idev)
+	if (!xdst->u.rt6.rt6i_idev) {
+		dev_put(dev);
 		return -ENODEV;
+	}
 
 	xdst->u.rt6.rt6i_peer = rt->rt6i_peer;
 	if (rt->rt6i_peer)
-- 
1.8.1.2

