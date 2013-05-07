Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab3EGOGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:06:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab3EGNl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 058/118] net: drop dst before queueing fragments
Date: Tue,  7 May 2013 14:38:24 +0100
Message-Id: <1367933964-1564-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 97599dc792b45b1669c3cdb9a4b365aad0232f65 upstream.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_fragment.c | 15 +++++++++++----
 net/ipv6/reassembly.c  | 13 +++++++++++--
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index d513c62..3599757 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -251,8 +251,7 @@ static void ip_expire(unsigned long arg)
 		if (!head->dev)
 			goto out_rcu_unlock;
 
-		/* skb dst is stale, drop it, and perform route lookup again */
-		skb_dst_drop(head);
+		/* skb has no dst, perform route lookup again */
 		iph = ip_hdr(head);
 		err = ip_route_input_noref(head, iph->daddr, iph->saddr,
 					   iph->tos, head->dev);
@@ -517,8 +516,16 @@ found:
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
1.8.1.2

