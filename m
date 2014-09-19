Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaISIE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:04:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbaISIEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:04:54 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next V2] net: keep original skb which only needs header checking during software GSO
Date: Fri, 19 Sep 2014 16:04:38 +0800
Message-Id: <1411113878-11910-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ce93718fb7cdbc064c3000ff59e4d3200bdfa744 ("net: Don't keep
around original SKB when we software segment GSO frames") frees the
original skb after software GSO even for dodgy gso skbs. This breaks
the stream throughput from untrusted sources, since only header
checking was done during software GSO instead of a true
segmentation. This patch fixes this by freeing the original gso skb
only when it was really segmented by software.

Fixes ce93718fb7cdbc064c3000ff59e4d3200bdfa744 ("net: Don't keep
around original SKB when we software segment GSO frames.")

Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- use consume_skb() instead of kfree_skb()
- fix coding style
---
 net/core/dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e916ba8..52cd71a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2694,10 +2694,12 @@ struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device *dev)
 		struct sk_buff *segs;
 
 		segs = skb_gso_segment(skb, features);
-		kfree_skb(skb);
-		if (IS_ERR(segs))
+		if (IS_ERR(segs)) {
 			segs = NULL;
-		skb = segs;
+		} else if (segs) {
+			consume_skb(skb);
+			skb = segs;
+		}
 	} else {
 		if (skb_needs_linearize(skb, features) &&
 		    __skb_linearize(skb))
-- 
1.9.1

