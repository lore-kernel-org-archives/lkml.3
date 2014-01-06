Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaAFLf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:35:56 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:57177 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaAFLfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:35:06 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        preeti.lkml@gmail.com
Subject: [PATCH V2 8/8] sched: factor out on_null_domain check in trigger_load_balance function
Date: Mon,  6 Jan 2014 12:34:45 +0100
Message-Id: <1389008085-9069-9-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test on_null_domain is done twice in the trigger_load_balance function.

Move the test at the begin of the function, so there is only one check.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/fair.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 59c57e7..ef95ddf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6871,11 +6871,13 @@ static inline int on_null_domain(struct rq *rq)
 void trigger_load_balance(struct rq *rq)
 {
 	/* Don't need to rebalance while attached to NULL domain */
-	if (time_after_eq(jiffies, rq->next_balance) &&
-	    likely(!on_null_domain(rq)))
+	if (unlikely(on_null_domain(rq)))
+		return;
+
+	if (time_after_eq(jiffies, rq->next_balance))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ_COMMON
-	if (nohz_kick_needed(rq) && likely(!on_null_domain(rq)))
+	if (nohz_kick_needed(rq))
 		nohz_balancer_kick();
 #endif
 }
-- 
1.7.9.5

