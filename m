Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3I3K3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:29:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab3I3KMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 050/104] ipv6: drop packets with multiple fragmentation headers
Date: Mon, 30 Sep 2013 11:10:27 +0100
Message-Id: <1380535881-9239-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit f46078cfcd77fa5165bf849f5e568a7ac5fa569c upstream.

It is not allowed for an ipv6 packet to contain multiple fragmentation
headers. So discard packets which were already reassembled by
fragmentation logic and send back a parameter problem icmp.

The updates for RFC 6980 will come in later, I have to do a bit more
research here.

Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/ipv6.h  | 1 +
 net/ipv6/reassembly.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 8260ef7..e6412ee 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -260,6 +260,7 @@ struct inet6_skb_parm {
 #define IP6SKB_XFRM_TRANSFORMED	1
 #define IP6SKB_FORWARDED	2
 #define IP6SKB_REROUTED		4
+#define IP6SKB_FRAGMENTED      16
 };
 
 #define IP6CB(skb)	((struct inet6_skb_parm*)((skb)->cb))
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 3673b8f..4da218c 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -531,6 +531,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 	head->tstamp = fq->q.stamp;
 	ipv6_hdr(head)->payload_len = htons(payload_len);
 	IP6CB(head)->nhoff = nhoff;
+	IP6CB(head)->flags |= IP6SKB_FRAGMENTED;
 
 	/* Yes, and fold redundant checksum back. 8) */
 	if (head->ip_summed == CHECKSUM_COMPLETE)
@@ -564,6 +565,9 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	const struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct net *net = dev_net(skb_dst(skb)->dev);
 
+	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
+		goto fail_hdr;
+
 	IP6_INC_STATS_BH(net, ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_REASMREQDS);
 
 	/* Jumbo payload inhibits frag. header */
@@ -584,6 +588,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 				 ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_REASMOKS);
 
 		IP6CB(skb)->nhoff = (u8 *)fhdr - skb_network_header(skb);
+		IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
 		return 1;
 	}
 
-- 
1.8.3.2

