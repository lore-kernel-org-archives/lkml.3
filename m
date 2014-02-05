Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbaBEVFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:05:16 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48040 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaBEUFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <shemminger@osdl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 051/213] netem: fix possible skb leak
Date: Wed, 5 Feb 2014 15:00:06 -0500
Message-ID: <1391630568-49251-52-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 116a0fc31c6c9b8fc821be5a96e5bf0b43260131 upstream.

skb_checksum_help(skb) can return an error, we must free skb in this
case. qdisc_drop(skb, sch) can also be feeded with a NULL skb (if
skb_unshare() failed), so lets use this generic helper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Hemminger <shemminger@osdl.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sched/sch_netem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 4714ff162bbd..e105245dac93 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -202,10 +202,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 	if (q->corrupt && q->corrupt >= get_crandom(&q->corrupt_cor)) {
 		if (!(skb = skb_unshare(skb, GFP_ATOMIC)) ||
 		    (skb->ip_summed == CHECKSUM_PARTIAL &&
-		     skb_checksum_help(skb))) {
-			sch->qstats.drops++;
-			return NET_XMIT_DROP;
-		}
+		     skb_checksum_help(skb)))
+			return qdisc_drop(skb, sch);
 
 		skb->data[net_random() % skb_headlen(skb)] ^= 1<<(net_random() % 8);
 	}
-- 
1.8.5.2

