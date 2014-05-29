Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652AbaE2Nzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:55:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59490 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933524AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 093/103] net: ipv6: send pkttoobig immediately if orig frag size > mtu
Date: Thu, 29 May 2014 15:49:18 +0200
Message-Id: <156439bd5ca8f99ad08e12723a5f687719815b33.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/ip6_output.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 516e136f15ca..45010f0d1167 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -323,12 +323,16 @@ static inline int ip6_forward_finish(struct sk_buff *skb)
 
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
1.9.3

