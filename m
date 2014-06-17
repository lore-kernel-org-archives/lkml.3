Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbaFQQ0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:26:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50991 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242AbaFQQ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:26:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 070/121] net: ipv6: send pkttoobig immediately if orig frag size > mtu
Date: Tue, 17 Jun 2014 09:17:28 -0700
Message-Id: <1403021899-16708-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 418a31561d594a2b636c1e2fa94ecd9e1245abb1 ]

If conntrack defragments incoming ipv6 frags it stores largest original
frag size in ip6cb and sets ->local_df.

We must thus first test the largest original frag size vs. mtu, and not
vice versa.

Without this patch PKTTOOBIG is still generated in ip6_fragment() later
in the stack, but

1) IPSTATS_MIB_INTOOBIGERRORS won't increment
2) packet did (needlessly) traverse netfilter postrouting hook.

Fixes: fe6cc55f3a9 ("net: ip, ipv6: handle gso skbs in forwarding path")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_output.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 64809bd..41abcf7 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -368,12 +368,16 @@ static inline int ip6_forward_finish(struct sk_buff *skb)
 
 static bool ip6_pkt_too_big(const struct sk_buff *skb, unsigned int mtu)
 {
-	if (skb->len <= mtu || skb->local_df)
+	if (skb->len <= mtu)
 		return false;
 
+	/* ipv6 conntrack defrag sets max_frag_size + local_df */
 	if (IP6CB(skb)->frag_max_size && IP6CB(skb)->frag_max_size > mtu)
 		return true;
 
+	if (skb->local_df)
+		return false;
+
 	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)
 		return false;
 
-- 
1.9.1

