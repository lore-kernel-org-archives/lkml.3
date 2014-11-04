Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaKDTlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:41:42 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:65478 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbaKDTll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:41:41 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcOAFwrWVRbsl9p/2dsb2JhbABbgw6BLLp/BgEBAQEBBQF0miiBJBcBAQEBAX2EMC8jgRo3iEUBvm+PCCyGN4pZHYQ1BYY2l1GMd4lYgUcBgjE8L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] ipv4: ip_frag_queue function clean-up
Date: Tue,  4 Nov 2014 20:41:37 +0100
Message-Id: <1415130097-14490-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-remove unnecessary else after break
-declare free_it sk_buff * only once (like prev and next)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/ip_fragment.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 2811cc1..153c402 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -317,7 +317,7 @@ static int ip_frag_reinit(struct ipq *qp)
 /* Add new segment to existing queue. */
 static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 {
-	struct sk_buff *prev, *next;
+	struct sk_buff *prev, *next, *free_it;
 	struct net_device *dev;
 	int flags, offset;
 	int ihl, end;
@@ -432,23 +432,23 @@ found:
 			if (next->ip_summed != CHECKSUM_UNNECESSARY)
 				next->ip_summed = CHECKSUM_NONE;
 			break;
-		} else {
-			struct sk_buff *free_it = next;
+		}
 
-			/* Old fragment is completely overridden with
-			 * new one drop it.
-			 */
-			next = next->next;
+		free_it = next;
 
-			if (prev)
-				prev->next = next;
-			else
-				qp->q.fragments = next;
+		/* Old fragment is completely overridden with
+		 * new one drop it.
+		 */
+		next = next->next;
 
-			qp->q.meat -= free_it->len;
-			sub_frag_mem_limit(&qp->q, free_it->truesize);
-			kfree_skb(free_it);
-		}
+		if (prev)
+			prev->next = next;
+		else
+			qp->q.fragments = next;
+
+		qp->q.meat -= free_it->len;
+		sub_frag_mem_limit(&qp->q, free_it->truesize);
+		kfree_skb(free_it);
 	}
 
 	FRAG_CB(skb)->offset = offset;
-- 
1.9.3

