Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaAMP5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:57:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaAMP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:57:08 -0500
Date: Mon, 13 Jan 2014 07:56:37 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-c726099ec224be8078d91072207053ff9a1ad6fc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1389008085-9069-9-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-9-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Factor out the on_null_domain()
  checks in trigger_load_balance()
Git-Commit-ID: c726099ec224be8078d91072207053ff9a1ad6fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:56:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c726099ec224be8078d91072207053ff9a1ad6fc
Gitweb:     http://git.kernel.org/tip/c726099ec224be8078d91072207053ff9a1ad6fc
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 6 Jan 2014 12:34:45 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:35 +0100

sched: Factor out the on_null_domain() checks in trigger_load_balance()

The test on_null_domain is done twice in the trigger_load_balance function.

Move the test at the begin of the function, so there is only one check.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389008085-9069-9-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d7220d1..b24b6cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6878,11 +6878,13 @@ static inline int on_null_domain(struct rq *rq)
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
