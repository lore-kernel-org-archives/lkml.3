Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3J2SJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59610 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3J2SJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Kozlov <xeb@mail.ru>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 52/81] ipv6: gre: correct calculation of max_headroom
Date: Tue, 29 Oct 2013 11:04:13 -0700
Message-Id: <1383069882-11437-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 3da812d860755925da890e8c713f2d2e2d7b1bae ]

gre_hlen already accounts for sizeof(struct ipv6_hdr) + gre header,
so initialize max_headroom to zero. Otherwise the

	if (encap_limit >= 0) {
		max_headroom += 8;
		mtu -= 8;
	}

increments an uninitialized variable before max_headroom was reset.

Found with coverity: 728539

Cc: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_gre.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index a4c5ae7..be42860 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -659,7 +659,7 @@ static netdev_tx_t ip6gre_xmit2(struct sk_buff *skb,
 	struct ip6_tnl *tunnel = netdev_priv(dev);
 	struct net_device *tdev;    /* Device to other host */
 	struct ipv6hdr  *ipv6h;     /* Our new IP header */
-	unsigned int max_headroom;  /* The extra header space needed */
+	unsigned int max_headroom = 0; /* The extra header space needed */
 	int    gre_hlen;
 	struct ipv6_tel_txoption opt;
 	int    mtu;
@@ -733,7 +733,7 @@ static netdev_tx_t ip6gre_xmit2(struct sk_buff *skb,
 			tunnel->err_count = 0;
 	}
 
-	max_headroom = LL_RESERVED_SPACE(tdev) + gre_hlen + dst->header_len;
+	max_headroom += LL_RESERVED_SPACE(tdev) + gre_hlen + dst->header_len;
 
 	if (skb_headroom(skb) < max_headroom || skb_shared(skb) ||
 	    (skb_cloned(skb) && !skb_clone_writable(skb, 0))) {
-- 
1.8.1.2

