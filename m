Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbaFCLm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:42:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893AbaFCLmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 119/138] net: ipv6: send pkttoobig immediately if orig frag size > mtu
Date: Tue,  3 Jun 2014 12:39:25 +0100
Message-Id: <1401795584-22664-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 418a31561d594a2b636c1e2fa94ecd9e1245abb1 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_output.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index d18c00a36fde..fe0bc8e0e866 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -348,12 +348,16 @@ static inline int ip6_forward_finish(struct sk_buff *skb)
 
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

