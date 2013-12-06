Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161582Ab3LFWIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:08:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427Ab3LFVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 41/58] tcp: gso: fix truesize tracking
Date: Fri,  6 Dec 2013 13:52:12 -0800
Message-Id: <20131206214848.704943738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0d08c42cf9a71530fef5ebcfe368f38f2dd0476f ]

commit 6ff50cd55545 ("tcp: gso: do not generate out of order packets")
had an heuristic that can trigger a warning in skb_try_coalesce(),
because skb->truesize of the gso segments were exactly set to mss.

This breaks the requirement that

skb->truesize >= skb->len + truesizeof(struct sk_buff);

It can trivially be reproduced by :

ifconfig lo mtu 1500
ethtool -K lo tso off
netperf

As the skbs are looped into the TCP networking stack, skb_try_coalesce()
warns us of these skb under-estimating their truesize.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2899,6 +2899,7 @@ struct sk_buff *tcp_tso_segment(struct s
 	netdev_features_t features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	unsigned int sum_truesize = 0;
 	struct tcphdr *th;
 	unsigned int thlen;
 	unsigned int seq;
@@ -2982,13 +2983,7 @@ struct sk_buff *tcp_tso_segment(struct s
 		if (copy_destructor) {
 			skb->destructor = gso_skb->destructor;
 			skb->sk = gso_skb->sk;
-			/* {tcp|sock}_wfree() use exact truesize accounting :
-			 * sum(skb->truesize) MUST be exactly be gso_skb->truesize
-			 * So we account mss bytes of 'true size' for each segment.
-			 * The last segment will contain the remaining.
-			 */
-			skb->truesize = mss;
-			gso_skb->truesize -= mss;
+			sum_truesize += skb->truesize;
 		}
 		skb = skb->next;
 		th = tcp_hdr(skb);
@@ -3005,7 +3000,9 @@ struct sk_buff *tcp_tso_segment(struct s
 	if (copy_destructor) {
 		swap(gso_skb->sk, skb->sk);
 		swap(gso_skb->destructor, skb->destructor);
-		swap(gso_skb->truesize, skb->truesize);
+		sum_truesize += skb->truesize;
+		atomic_add(sum_truesize - gso_skb->truesize,
+			   &skb->sk->sk_wmem_alloc);
 	}
 
 	delta = htonl(oldlen + (skb->tail - skb->transport_header) +


