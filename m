Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaABRHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:07:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaABRHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:07:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 36/91] ipv6: fix possible seqlock deadlock in ip6_finish_output2
Date: Thu,  2 Jan 2014 09:04:11 -0800
Message-Id: <1388682306-30859-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 7f88c6b23afbd31545c676dea77ba9593a1a14bf ]

IPv6 stats are 64 bits and thus are protected with a seqlock. By not
disabling bottom-half we could deadlock here if we don't disable bh and
a softirq reentrantly updates the same mib.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ac9f072..09cf37e 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -128,8 +128,8 @@ static int ip6_finish_output2(struct sk_buff *skb)
 	if (neigh)
 		return dst_neigh_output(dst, neigh, skb);
 
-	IP6_INC_STATS_BH(dev_net(dst->dev),
-			 ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
+	IP6_INC_STATS(dev_net(dst->dev),
+		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
 	kfree_skb(skb);
 	return -EINVAL;
 }
-- 
1.8.3.2

