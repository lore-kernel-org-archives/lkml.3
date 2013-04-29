Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667Ab3D2Tdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:33:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578Ab3D2TCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Parkin <tparkin@katalix.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 39/42] net: drop dst before queueing fragments
Date: Mon, 29 Apr 2013 12:02:21 -0700
Message-Id: <20130429184756.815952144@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 97599dc792b45b1669c3cdb9a4b365aad0232f65 ]

Commit 4a94445c9a5c (net: Use ip_route_input_noref() in input path)
added a bug in IP defragmentation handling, as non refcounted
dst could escape an RCU protected section.

Commit 64f3b9e203bd068 (net: ip_expire() must revalidate route) fixed
the case of timeouts, but not the general problem.

Tom Parkin noticed crashes in UDP stack and provided a patch,
but further analysis permitted us to pinpoint the root cause.

Before queueing a packet into a frag list, we must drop its dst,
as this dst has limited lifetime (RCU protected)

When/if a packet is finally reassembled, we use the dst of the very
last skb, still protected by RCU and valid, as the dst of the
reassembled packet.

Use same logic in IPv6, as there is no need to hold dst references.

Reported-by: Tom Parkin <tparkin@katalix.com>
Tested-by: Tom Parkin <tparkin@katalix.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_fragment.c |   15 +++++++++++----
 net/ipv6/reassembly.c  |   13 +++++++++++--
 2 files changed, 22 insertions(+), 6 deletions(-)

--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -255,8 +255,7 @@ static void ip_expire(unsigned long arg)
 		if (!head->dev)
 			goto out_rcu_unlock;
 
-		/* skb dst is stale, drop it, and perform route lookup again */
-		skb_dst_drop(head);
+		/* skb has no dst, perform route lookup again */
 		iph = ip_hdr(head);
 		err = ip_route_input_noref(head, iph->daddr, iph->saddr,
 					   iph->tos, head->dev);
@@ -525,8 +524,16 @@ found:
 		qp->q.max_size = skb->len + ihl;
 
 	if (qp->q.last_in == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
-	    qp->q.meat == qp->q.len)
-		return ip_frag_reasm(qp, prev, dev);
+	    qp->q.meat == qp->q.len) {
+		unsigned long orefdst = skb->_skb_refdst;
+
+		skb->_skb_refdst = 0UL;
+		err = ip_frag_reasm(qp, prev, dev);
+		skb->_skb_refdst = orefdst;
+		return err;
+	}
+
+	skb_dst_drop(skb);
 
 	write_lock(&ip4_frags.lock);
 	list_move_tail(&qp->q.lru_list, &qp->q.net->lru_list);
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -342,8 +342,17 @@ found:
 	}
 
 	if (fq->q.last_in == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
-	    fq->q.meat == fq->q.len)
-		return ip6_frag_reasm(fq, prev, dev);
+	    fq->q.meat == fq->q.len) {
+		int res;
+		unsigned long orefdst = skb->_skb_refdst;
+
+		skb->_skb_refdst = 0UL;
+		res = ip6_frag_reasm(fq, prev, dev);
+		skb->_skb_refdst = orefdst;
+		return res;
+	}
+
+	skb_dst_drop(skb);
 
 	write_lock(&ip6_frags.lock);
 	list_move_tail(&fq->q.lru_list, &fq->q.net->lru_list);


