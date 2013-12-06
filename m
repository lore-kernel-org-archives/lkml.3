Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab3LFWih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:38:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007Ab3LFVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Willem de Bruijn <willemb@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 23/83] pkt_sched: fq: change classification of control packets
Date: Fri,  6 Dec 2013 13:51:13 -0800
Message-Id: <20131206214642.229485717@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit 2abc2f070eb30ac8421554a5c32229f8332c6206 ]

Initial sch_fq implementation copied code from pfifo_fast to classify
a packet as a high prio packet.

This clashes with setups using PRIO with say 7 bands, as one of the
band could be incorrectly (mis)classified by FQ.

Packets would be queued in the 'internal' queue, and no pacing ever
happen for this special queue.

Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -209,21 +209,15 @@ static void fq_gc(struct fq_sched_data *
 	}
 }
 
-static const u8 prio2band[TC_PRIO_MAX + 1] = {
-	1, 2, 2, 2, 1, 2, 0, 0 , 1, 1, 1, 1, 1, 1, 1, 1
-};
-
 static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
 {
 	struct rb_node **p, *parent;
 	struct sock *sk = skb->sk;
 	struct rb_root *root;
 	struct fq_flow *f;
-	int band;
 
 	/* warning: no starvation prevention... */
-	band = prio2band[skb->priority & TC_PRIO_MAX];
-	if (unlikely(band == 0))
+	if (unlikely((skb->priority & TC_PRIO_MAX) == TC_PRIO_CONTROL))
 		return &q->internal;
 
 	if (unlikely(!sk)) {


