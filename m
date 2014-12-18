Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaLRF5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 00:57:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbaLRF5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 00:57:31 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] net: drop the packet when fails to do software segmentation or header check
Date: Thu, 18 Dec 2014 13:57:19 +0800
Message-Id: <1418882239-6720-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cecda693a969816bac5e470e1d9c9c0ef5567bca ("net: keep original skb
which only needs header checking during software GSO") keeps the original
skb for packets that only needs header check, but it doesn't drop the
packet if software segmentation or header check were failed.

Fixes cecda693a969816bac5e470e1d9c9c0ef5567bca
(net: keep original skb which only needs header checking during software GSO)

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Stable candidate for 3.17 and above.
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f411c28..a989f85 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2673,7 +2673,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR(segs)) {
-			segs = NULL;
+			goto out_kfree_skb;
 		} else if (segs) {
 			consume_skb(skb);
 			skb = segs;
-- 
1.9.1

