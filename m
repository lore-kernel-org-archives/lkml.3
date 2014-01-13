Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaAMP4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:56:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaAMP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:56:08 -0500
Date: Mon, 13 Jan 2014 07:55:39 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-4a725627f21df6b280a19f50bc849daaab3b1544@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1389008085-9069-3-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-3-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Reduce nohz_kick_needed() parameters
Git-Commit-ID: 4a725627f21df6b280a19f50bc849daaab3b1544
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:55:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a725627f21df6b280a19f50bc849daaab3b1544
Gitweb:     http://git.kernel.org/tip/4a725627f21df6b280a19f50bc849daaab3b1544
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 6 Jan 2014 12:34:39 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:27 +0100

sched: Reduce nohz_kick_needed() parameters

The cpu information is already stored in the struct rq, so no need to pass it
as parameter to the nohz_kick_needed function.

The caller of this function just called idle_cpu() before to fill the
rq->idle_balance field.

Use rq->cpu and rq->idle_balance.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389008085-9069-3-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b35d322..c47b1ce 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6788,14 +6788,14 @@ end:
  *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
  *     domain span are idle.
  */
-static inline int nohz_kick_needed(struct rq *rq, int cpu)
+static inline int nohz_kick_needed(struct rq *rq)
 {
 	unsigned long now = jiffies;
 	struct sched_domain *sd;
 	struct sched_group_power *sgp;
-	int nr_busy;
+	int nr_busy, cpu = rq->cpu;
 
-	if (unlikely(idle_cpu(cpu)))
+	if (unlikely(rq->idle_balance))
 		return 0;
 
        /*
@@ -6885,7 +6885,7 @@ void trigger_load_balance(struct rq *rq)
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ_COMMON
-	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
 }
