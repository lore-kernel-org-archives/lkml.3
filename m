Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3ILRcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:32:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3ILR0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 09/19] ipv6: drop packets with multiple fragmentation headers
Date: Thu, 12 Sep 2013 10:26:18 -0700
Message-Id: <20130912172525.185359532@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
References: <20130912172524.135620246@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ipv6.h  |    1 +
 net/ipv6/reassembly.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -255,6 +255,7 @@ struct inet6_skb_parm {
 #define IP6SKB_XFRM_TRANSFORMED	1
 #define IP6SKB_FORWARDED	2
 #define IP6SKB_REROUTED		4
+#define IP6SKB_FRAGMENTED      16
 };
 
 #define IP6CB(skb)	((struct inet6_skb_parm*)((skb)->cb))
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -516,6 +516,7 @@ static int ip6_frag_reasm(struct frag_qu
 	head->tstamp = fq->q.stamp;
 	ipv6_hdr(head)->payload_len = htons(payload_len);
 	IP6CB(head)->nhoff = nhoff;
+	IP6CB(head)->flags |= IP6SKB_FRAGMENTED;
 
 	/* Yes, and fold redundant checksum back. 8) */
 	if (head->ip_summed == CHECKSUM_COMPLETE)
@@ -551,6 +552,9 @@ static int ipv6_frag_rcv(struct sk_buff
 	const struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct net *net = dev_net(skb_dst(skb)->dev);
 
+	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
+		goto fail_hdr;
+
 	IP6_INC_STATS_BH(net, ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_REASMREQDS);
 
 	/* Jumbo payload inhibits frag. header */
@@ -571,6 +575,7 @@ static int ipv6_frag_rcv(struct sk_buff
 				 ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_REASMOKS);
 
 		IP6CB(skb)->nhoff = (u8 *)fhdr - skb_network_header(skb);
+		IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
 		return 1;
 	}
 


