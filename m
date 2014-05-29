Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbaE2Ehv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:37:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795AbaE2EgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:36:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Jerry Chu <hkchu@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 138/140] ipv6: gro: fix CHECKSUM_COMPLETE support
Date: Wed, 28 May 2014 21:34:37 -0700
Message-Id: <20140529043107.124711772@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4de462ab63e23953fd05da511aeb460ae10cc726 ]

When GRE support was added in linux-3.14, CHECKSUM_COMPLETE handling
broke on GRE+IPv6 because we did not update/use the appropriate csum :

GRO layer is supposed to use/update NAPI_GRO_CB(skb)->csum instead of
skb->csum

Tested using a GRE tunnel and IPv6 traffic. GRO aggregation now happens
at the first level (ethernet device) instead of being done in gre
tunnel. Native IPv6+TCP is still properly aggregated.

Fixes: bf5a755f5e918 ("net-gre-gro: Add GRE support to the GRO stack")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jerry Chu <hkchu@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_offload.c   |    6 +-----
 net/ipv6/tcpv6_offload.c |    2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -196,7 +196,6 @@ static struct sk_buff **ipv6_gro_receive
 	unsigned int off;
 	u16 flush = 1;
 	int proto;
-	__wsum csum;
 
 	off = skb_gro_offset(skb);
 	hlen = off + sizeof(*iph);
@@ -264,13 +263,10 @@ static struct sk_buff **ipv6_gro_receive
 
 	NAPI_GRO_CB(skb)->flush |= flush;
 
-	csum = skb->csum;
-	skb_postpull_rcsum(skb, iph, skb_network_header_len(skb));
+	skb_gro_postpull_rcsum(skb, iph, nlen);
 
 	pp = ops->callbacks.gro_receive(head, skb);
 
-	skb->csum = csum;
-
 out_unlock:
 	rcu_read_unlock();
 
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -42,7 +42,7 @@ static struct sk_buff **tcp6_gro_receive
 	if (NAPI_GRO_CB(skb)->flush)
 		goto skip_csum;
 
-	wsum = skb->csum;
+	wsum = NAPI_GRO_CB(skb)->csum;
 
 	switch (skb->ip_summed) {
 	case CHECKSUM_NONE:


