Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaELBng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:36 -0400
Received: from 1wt.eu ([62.212.114.60]:34732 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbaELBn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:29 -0400
Message-Id: <20140512003203.503852885@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 069/143] ipv6: drop packets with multiple fragmentation headers
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit f46078cfcd77fa5165bf849f5e568a7ac5fa569c ]

It is not allowed for an ipv6 packet to contain multiple fragmentation
headers. So discard packets which were already reassembled by
fragmentation logic and send back a parameter problem icmp.

The updates for RFC 6980 will come in later, I have to do a bit more
research here.

Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/ipv6.h  | 1 +
 net/ipv6/reassembly.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index c662efa..5bf3324 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -248,6 +248,7 @@ struct inet6_skb_parm {
 
 #define IP6SKB_XFRM_TRANSFORMED	1
 #define IP6SKB_FORWARDED	2
+#define IP6SKB_FRAGMENTED      16
 };
 
 #define IP6CB(skb)	((struct inet6_skb_parm*)((skb)->cb))
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 105de22..0c09d8e 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -503,6 +503,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 	head->tstamp = fq->q.stamp;
 	ipv6_hdr(head)->payload_len = htons(payload_len);
 	IP6CB(head)->nhoff = nhoff;
+	IP6CB(head)->flags |= IP6SKB_FRAGMENTED;
 
 	/* Yes, and fold redundant checksum back. 8) */
 	if (head->ip_summed == CHECKSUM_COMPLETE)
@@ -537,6 +538,9 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct net *net = dev_net(skb_dst(skb)->dev);
 
+	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
+		goto fail_hdr;
+
 	IP6_INC_STATS_BH(net, ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_REASMREQDS);
 
 	/* Jumbo payload inhibits frag. header */
@@ -557,6 +561,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 				 ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_REASMOKS);
 
 		IP6CB(skb)->nhoff = (u8 *)fhdr - skb_network_header(skb);
+		IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
 		return 1;
 	}
 
-- 
1.7.12.2.21.g234cd45.dirty



