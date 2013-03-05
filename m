Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab3CESGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:06:54 -0500
Received: from spostino.sms.unimo.it ([155.185.44.3]:38165 "EHLO
	spostino.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab3CESGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:06:48 -0500
From: Paolo valente <paolo.valente@unimore.it>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, shemminger@vyatta.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fchecconi@gmail.com,
        rizzo@iet.unipi.it, Paolo Valente <paolo.valente@unimore.it>
Subject: [PATCH BUGFIX 5/6] pkt_sched: do not allow virtual time to jump if an aggregate is in service
Date: Tue,  5 Mar 2013 19:05:01 +0100
Message-Id: <1362506702-4985-6-git-send-email-paolo.valente@unimore.it>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362506702-4985-1-git-send-email-paolo.valente@unimore.it>
References: <20130226.173700.882998504986475149.davem@davemloft.net>
 <1362506702-4985-1-git-send-email-paolo.valente@unimore.it>
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By definition of (the algorithm of) QFQ+, the system virtual time must
be pushed up only if there is no 'eligible' aggregate, i.e. no
aggregate that would have started to be served also in the ideal
system emulated by QFQ+.  QFQ+ serves only eligible aggregates, hence
the aggregate currently in service is eligible.  As a consequence, to
decide whether there is no eligible aggregate, QFQ+ must also check
whether there is no aggregate in service.

Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Reviewed-by: Fabio Checconi <fchecconi@gmail.com>
---
 net/sched/sch_qfq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 26149e2..5d327b3 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1281,7 +1281,8 @@ static void qfq_schedule_agg(struct qfq_sched *q, struct qfq_aggregate *agg)
 		/* group was surely ineligible, remove */
 		__clear_bit(grp->index, &q->bitmaps[IR]);
 		__clear_bit(grp->index, &q->bitmaps[IB]);
-	} else if (!q->bitmaps[ER] && qfq_gt(roundedS, q->V))
+	} else if (!q->bitmaps[ER] && qfq_gt(roundedS, q->V) &&
+		   q->in_serv_agg == NULL)
 		q->V = roundedS;
 
 	grp->S = roundedS;
-- 
1.7.9.5

