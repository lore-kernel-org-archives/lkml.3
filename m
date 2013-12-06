Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab3LFWh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:37:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024Ab3LFVwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 27/83] pkt_sched: fq: fix pacing for small frames
Date: Fri,  6 Dec 2013 13:51:17 -0800
Message-Id: <20131206214642.598396509@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f52ed89971adbe79b6438c459814034707b8ab91 ]

For performance reasons, sch_fq tried hard to not setup timers for every
sent packet, using a quantum based heuristic : A delay is setup only if
the flow exhausted its credit.

Problem is that application limited flows can refill their credit
for every queued packet, and they can evade pacing.

This problem can also be triggered when TCP flows use small MSS values,
as TSO auto sizing builds packets that are smaller than the default fq
quantum (3028 bytes)

This patch adds a 40 ms delay to guard flow credit refill.

Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/pkt_sched.h |    3 +++
 net/sched/sch_fq.c             |   22 ++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -764,6 +764,9 @@ enum {
 	TCA_FQ_FLOW_MAX_RATE,	/* per flow max rate */
 
 	TCA_FQ_BUCKETS_LOG,	/* log2(number of buckets) */
+
+	TCA_FQ_FLOW_REFILL_DELAY,	/* flow credit refill delay in usec */
+
 	__TCA_FQ_MAX
 };
 
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -88,6 +88,7 @@ struct fq_sched_data {
 	struct fq_flow	internal;	/* for non classified or high prio packets */
 	u32		quantum;
 	u32		initial_quantum;
+	u32		flow_refill_delay;
 	u32		flow_max_rate;	/* optional max rate per flow */
 	u32		flow_plimit;	/* max packets per flow */
 	struct rb_root	*fq_root;
@@ -114,6 +115,7 @@ static struct fq_flow detached, throttle
 static void fq_flow_set_detached(struct fq_flow *f)
 {
 	f->next = &detached;
+	f->age = jiffies;
 }
 
 static bool fq_flow_is_detached(const struct fq_flow *f)
@@ -365,17 +367,20 @@ static int fq_enqueue(struct sk_buff *sk
 	}
 
 	f->qlen++;
-	flow_queue_add(f, skb);
 	if (skb_is_retransmit(skb))
 		q->stat_tcp_retrans++;
 	sch->qstats.backlog += qdisc_pkt_len(skb);
 	if (fq_flow_is_detached(f)) {
 		fq_flow_add_tail(&q->new_flows, f);
-		if (q->quantum > f->credit)
-			f->credit = q->quantum;
+		if (time_after(jiffies, f->age + q->flow_refill_delay))
+			f->credit = max_t(u32, f->credit, q->quantum);
 		q->inactive_flows--;
 		qdisc_unthrottled(sch);
 	}
+
+	/* Note: this overwrites f->age */
+	flow_queue_add(f, skb);
+
 	if (unlikely(f == &q->internal)) {
 		q->stat_internal_packets++;
 		qdisc_unthrottled(sch);
@@ -453,7 +458,6 @@ begin:
 			fq_flow_add_tail(&q->old_flows, f);
 		} else {
 			fq_flow_set_detached(f);
-			f->age = jiffies;
 			q->inactive_flows++;
 		}
 		goto begin;
@@ -607,6 +611,7 @@ static const struct nla_policy fq_policy
 	[TCA_FQ_FLOW_DEFAULT_RATE]	= { .type = NLA_U32 },
 	[TCA_FQ_FLOW_MAX_RATE]		= { .type = NLA_U32 },
 	[TCA_FQ_BUCKETS_LOG]		= { .type = NLA_U32 },
+	[TCA_FQ_FLOW_REFILL_DELAY]	= { .type = NLA_U32 },
 };
 
 static int fq_change(struct Qdisc *sch, struct nlattr *opt)
@@ -663,6 +668,12 @@ static int fq_change(struct Qdisc *sch,
 			err = -EINVAL;
 	}
 
+	if (tb[TCA_FQ_FLOW_REFILL_DELAY]) {
+		u32 usecs_delay = nla_get_u32(tb[TCA_FQ_FLOW_REFILL_DELAY]) ;
+
+		q->flow_refill_delay = usecs_to_jiffies(usecs_delay);
+	}
+
 	if (!err)
 		err = fq_resize(q, fq_log);
 
@@ -698,6 +709,7 @@ static int fq_init(struct Qdisc *sch, st
 	q->flow_plimit		= 100;
 	q->quantum		= 2 * psched_mtu(qdisc_dev(sch));
 	q->initial_quantum	= 10 * psched_mtu(qdisc_dev(sch));
+	q->flow_refill_delay	= msecs_to_jiffies(40);
 	q->flow_max_rate	= ~0U;
 	q->rate_enable		= 1;
 	q->new_flows.first	= NULL;
@@ -732,6 +744,8 @@ static int fq_dump(struct Qdisc *sch, st
 	    nla_put_u32(skb, TCA_FQ_INITIAL_QUANTUM, q->initial_quantum) ||
 	    nla_put_u32(skb, TCA_FQ_RATE_ENABLE, q->rate_enable) ||
 	    nla_put_u32(skb, TCA_FQ_FLOW_MAX_RATE, q->flow_max_rate) ||
+	    nla_put_u32(skb, TCA_FQ_FLOW_REFILL_DELAY,
+			jiffies_to_usecs(q->flow_refill_delay)) ||
 	    nla_put_u32(skb, TCA_FQ_BUCKETS_LOG, q->fq_trees_log))
 		goto nla_put_failure;
 


