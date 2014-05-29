Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545AbaE2ErF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:47:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224AbaE2Eil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 63/86] net: ipv4: ip_forward: fix inverted local_df test
Date: Wed, 28 May 2014 21:37:38 -0700
Message-Id: <20140529043522.038821330@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ca6c5d4ad216d5942ae544bbf02503041bd802aa ]

local_df means 'ignore DF bit if set', so if its set we're
allowed to perform ip fragmentation.

This wasn't noticed earlier because the output path also drops such skbs
(and emits needed icmp error) and because netfilter ip defrag did not
set local_df until couple of days ago.

Only difference is that DF-packets-larger-than MTU now discarded
earlier (f.e. we avoid pointless netfilter postrouting trip).

While at it, drop the repeated test ip_exceeds_mtu, checking it once
is enough...

Fixes: fe6cc55f3a9 ("net: ip, ipv6: handle gso skbs in forwarding path")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_forward.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -42,12 +42,12 @@
 static bool ip_may_fragment(const struct sk_buff *skb)
 {
 	return unlikely((ip_hdr(skb)->frag_off & htons(IP_DF)) == 0) ||
-	       !skb->local_df;
+		skb->local_df;
 }
 
 static bool ip_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 {
-	if (skb->len <= mtu || skb->local_df)
+	if (skb->len <= mtu)
 		return false;
 
 	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)


