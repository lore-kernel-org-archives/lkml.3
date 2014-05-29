Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832AbaE2FIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:08:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbaE2Efy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 113/140] net: ipv6: send pkttoobig immediately if orig frag size > mtu
Date: Wed, 28 May 2014 21:34:12 -0700
Message-Id: <20140529043104.127821384@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -344,12 +344,16 @@ static unsigned int ip6_dst_mtu_forward(
 
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
 


