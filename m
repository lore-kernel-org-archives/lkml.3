Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967141AbaCUB13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:27:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905AbaCUAD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 017/149] sch_tbf: Fix potential memory leak in tbf_change().
Date: Thu, 20 Mar 2014 17:03:00 -0700
Message-Id: <20140321000437.548201161@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

[ Upstream commit 724b9e1d75ab3401aaa081bd4efb440c1b3509db ]

The allocated child qdisc is not freed in error conditions.
Defer the allocation after user configuration turns out to be
valid and acceptable.

Fixes: cc106e441a63b ("net: sched: tbf: fix the calculation of max_size")
Signed-off-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_tbf.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -332,18 +332,6 @@ static int tbf_change(struct Qdisc *sch,
 			qdisc_put_rtab(qdisc_get_rtab(&qopt->peakrate,
 						      tb[TCA_TBF_PTAB]));
 
-	if (q->qdisc != &noop_qdisc) {
-		err = fifo_set_limit(q->qdisc, qopt->limit);
-		if (err)
-			goto done;
-	} else if (qopt->limit > 0) {
-		child = fifo_create_dflt(sch, &bfifo_qdisc_ops, qopt->limit);
-		if (IS_ERR(child)) {
-			err = PTR_ERR(child);
-			goto done;
-		}
-	}
-
 	buffer = min_t(u64, PSCHED_TICKS2NS(qopt->buffer), ~0U);
 	mtu = min_t(u64, PSCHED_TICKS2NS(qopt->mtu), ~0U);
 
@@ -377,6 +365,18 @@ static int tbf_change(struct Qdisc *sch,
 		goto done;
 	}
 
+	if (q->qdisc != &noop_qdisc) {
+		err = fifo_set_limit(q->qdisc, qopt->limit);
+		if (err)
+			goto done;
+	} else if (qopt->limit > 0) {
+		child = fifo_create_dflt(sch, &bfifo_qdisc_ops, qopt->limit);
+		if (IS_ERR(child)) {
+			err = PTR_ERR(child);
+			goto done;
+		}
+	}
+
 	sch_tree_lock(sch);
 	if (child) {
 		qdisc_tree_decrease_qlen(q->qdisc, q->qdisc->q.qlen);


