Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab3CESGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:06:06 -0500
Received: from spostino.sms.unimo.it ([155.185.44.3]:38133 "EHLO
	spostino.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3CESGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:06:04 -0500
From: Paolo valente <paolo.valente@unimore.it>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, shemminger@vyatta.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fchecconi@gmail.com,
        rizzo@iet.unipi.it, Paolo Valente <paolo.valente@unimore.it>
Subject: [PATCH BUGFIX 2/6] pkt_sched: fix the update of eligible-group sets
Date: Tue,  5 Mar 2013 19:04:58 +0100
Message-Id: <1362506702-4985-3-git-send-email-paolo.valente@unimore.it>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362506702-4985-1-git-send-email-paolo.valente@unimore.it>
References: <20130226.173700.882998504986475149.davem@davemloft.net>
 <1362506702-4985-1-git-send-email-paolo.valente@unimore.it>
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Between two invocations of make_eligible, the system virtual time may
happen to grow enough that, in its binary representation, a bit with
higher order than 31 flips. This happens especially with
TSO/GSO. Before this fix, the mask used in make_eligible was computed
as (1UL<<index_of_last_flipped_bit)-1, whose value is well defined on
a 64-bit architecture, because index_of_flipped_bit <= 63, but is in
general undefined on a 32-bit architecture if index_of_flipped_bit > 31.
The fix just replaces 1UL with 1ULL.

Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Reviewed-by: Fabio Checconi <fchecconi@gmail.com>
---
 net/sched/sch_qfq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 0f6e2db..4cbbf79 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -823,7 +823,7 @@ static void qfq_make_eligible(struct qfq_sched *q)
 	unsigned long old_vslot = q->oldV >> q->min_slot_shift;
 
 	if (vslot != old_vslot) {
-		unsigned long mask = (1UL << fls(vslot ^ old_vslot)) - 1;
+		unsigned long mask = (1ULL << fls(vslot ^ old_vslot)) - 1;
 		qfq_move_groups(q, mask, IR, ER);
 		qfq_move_groups(q, mask, IB, EB);
 	}
-- 
1.7.9.5

