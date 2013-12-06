Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039Ab3LFVwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018Ab3LFVwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 26/83] pkt_sched: fq: warn users using defrate
Date: Fri,  6 Dec 2013 13:51:16 -0800
Message-Id: <20131206214642.506130818@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 65c5189a2b57b9aa1d89e4b79da39928257c9505 ]

Commit 7eec4174ff29 ("pkt_sched: fq: fix non TCP flows pacing")
obsoleted TCA_FQ_FLOW_DEFAULT_RATE without notice for the users.

Suggested by David Miller

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/pkt_sched.h |    4 +---
 net/sched/sch_fq.c             |   10 ++++------
 2 files changed, 5 insertions(+), 9 deletions(-)

--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -759,9 +759,7 @@ enum {
 
 	TCA_FQ_RATE_ENABLE,	/* enable/disable rate limiting */
 
-	TCA_FQ_FLOW_DEFAULT_RATE,/* for sockets with unspecified sk_rate,
-				  * use the following rate
-				  */
+	TCA_FQ_FLOW_DEFAULT_RATE,/* obsolete, do not use */
 
 	TCA_FQ_FLOW_MAX_RATE,	/* per flow max rate */
 
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -88,7 +88,6 @@ struct fq_sched_data {
 	struct fq_flow	internal;	/* for non classified or high prio packets */
 	u32		quantum;
 	u32		initial_quantum;
-	u32		flow_default_rate;/* rate per flow : bytes per second */
 	u32		flow_max_rate;	/* optional max rate per flow */
 	u32		flow_plimit;	/* max packets per flow */
 	struct rb_root	*fq_root;
@@ -649,7 +648,8 @@ static int fq_change(struct Qdisc *sch,
 		q->initial_quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
 
 	if (tb[TCA_FQ_FLOW_DEFAULT_RATE])
-		q->flow_default_rate = nla_get_u32(tb[TCA_FQ_FLOW_DEFAULT_RATE]);
+		pr_warn_ratelimited("sch_fq: defrate %u ignored.\n",
+				    nla_get_u32(tb[TCA_FQ_FLOW_DEFAULT_RATE]));
 
 	if (tb[TCA_FQ_FLOW_MAX_RATE])
 		q->flow_max_rate = nla_get_u32(tb[TCA_FQ_FLOW_MAX_RATE]);
@@ -698,7 +698,6 @@ static int fq_init(struct Qdisc *sch, st
 	q->flow_plimit		= 100;
 	q->quantum		= 2 * psched_mtu(qdisc_dev(sch));
 	q->initial_quantum	= 10 * psched_mtu(qdisc_dev(sch));
-	q->flow_default_rate	= 0;
 	q->flow_max_rate	= ~0U;
 	q->rate_enable		= 1;
 	q->new_flows.first	= NULL;
@@ -725,9 +724,8 @@ static int fq_dump(struct Qdisc *sch, st
 	if (opts == NULL)
 		goto nla_put_failure;
 
-	/* TCA_FQ_FLOW_DEFAULT_RATE is not used anymore,
-	 * do not bother giving its value
-	 */
+	/* TCA_FQ_FLOW_DEFAULT_RATE is not used anymore */
+
 	if (nla_put_u32(skb, TCA_FQ_PLIMIT, sch->limit) ||
 	    nla_put_u32(skb, TCA_FQ_FLOW_PLIMIT, q->flow_plimit) ||
 	    nla_put_u32(skb, TCA_FQ_QUANTUM, q->quantum) ||


