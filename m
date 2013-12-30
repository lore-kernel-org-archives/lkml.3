Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3L3NpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:45:09 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60281 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3L3NpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:45:05 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 7/7] sched: factor out on_null_domain check in trigger_load_balance function
Date: Mon, 30 Dec 2013 14:44:53 +0100
Message-Id: <1388411093-3413-8-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org>
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

