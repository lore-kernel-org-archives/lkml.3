Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3KAWWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:22:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3KAWIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 27/66] netem: free skbs in tree on reset
Date: Fri,  1 Nov 2013 15:07:03 -0700
Message-Id: <20131101220642.285992309@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit ff704050f2fc0f3382b5a70bba56a51a3feca79d ]

Netem can leak memory because packets get stored in red-black
tree and it is not cleared on reset.

Reported by: Сергеев Сергей <adron@yapic.net>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_netem.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -358,6 +358,21 @@ static psched_time_t packet_len_2_sched_
 	return PSCHED_NS2TICKS(ticks);
 }
 
+static void tfifo_reset(struct Qdisc *sch)
+{
+	struct netem_sched_data *q = qdisc_priv(sch);
+	struct rb_node *p;
+
+	while ((p = rb_first(&q->t_root))) {
+		struct sk_buff *skb = netem_rb_to_skb(p);
+
+		rb_erase(p, &q->t_root);
+		skb->next = NULL;
+		skb->prev = NULL;
+		kfree_skb(skb);
+	}
+}
+
 static void tfifo_enqueue(struct sk_buff *nskb, struct Qdisc *sch)
 {
 	struct netem_sched_data *q = qdisc_priv(sch);
@@ -613,6 +628,7 @@ static void netem_reset(struct Qdisc *sc
 	struct netem_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset_queue(sch);
+	tfifo_reset(sch);
 	if (q->qdisc)
 		qdisc_reset(q->qdisc);
 	qdisc_watchdog_cancel(&q->watchdog);


