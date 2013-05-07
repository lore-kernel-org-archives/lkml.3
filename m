Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab3EGEZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:25:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392Ab3EGEZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:37 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=-zpqR09emLcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ZNVtiSZWppYA:10 a=1XWaLZrsAAAA:8 a=9-efGfXaAAAA:8 a=J1Y8HTJGAAAA:8 a=iY_pXu-Sl_Z-crGENnUA:9 a=UTB_XpHje0EA:10 a=7oEFu1jkwK4A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035901.641363745@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tom Parkin <tparkin@katalix.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [124/126] net: drop dst before queueing fragments
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0124-net-drop-dst-before-queueing-fragments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/ip_fragment.c |   15 +++++++++++----
 net/ipv6/reassembly.c  |   13 +++++++++++--
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 578e536..71ce1c0b 100644
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
@@ -521,8 +520,16 @@ found:
 		qp->q.last_in |= INET_FRAG_FIRST_IN;
 
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
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 66d2096..3673b8f 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -386,8 +386,17 @@ found:
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
-- 
1.7.10.4


