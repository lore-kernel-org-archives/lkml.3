Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3LSL4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:56:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44591 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3LSL4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 042/208] ipv6: fix possible seqlock deadlock in ip6_finish_output2
Date: Thu, 19 Dec 2013 11:52:20 +0000
Message-Id: <1387454106-19326-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 7f88c6b23afbd31545c676dea77ba9593a1a14bf upstream.

IPv6 stats are 64 bits and thus are protected with a seqlock. By not
disabling bottom-half we could deadlock here if we don't disable bh and
a softirq reentrantly updates the same mib.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f80f2fa..e50a9e3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -141,8 +141,8 @@ static int ip6_finish_output2(struct sk_buff *skb)
 	}
 	rcu_read_unlock_bh();
 
-	IP6_INC_STATS_BH(dev_net(dst->dev),
-			 ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
+	IP6_INC_STATS(dev_net(dst->dev),
+		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
 	kfree_skb(skb);
 	return -EINVAL;
 }
-- 
1.8.3.2

