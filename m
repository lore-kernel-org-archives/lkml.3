Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaAMP4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:56:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60900 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaAMP4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:56:48 -0500
Date: Mon, 13 Jan 2014 07:56:18 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-f7ed0a895ead0f093f59898ff9cf4e20768a5f09@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1389008085-9069-7-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-7-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Pass 'struct rq' to rebalance_domains()
Git-Commit-ID: f7ed0a895ead0f093f59898ff9cf4e20768a5f09
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:56:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7ed0a895ead0f093f59898ff9cf4e20768a5f09
Gitweb:     http://git.kernel.org/tip/f7ed0a895ead0f093f59898ff9cf4e20768a5f09
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 6 Jan 2014 12:34:43 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:31 +0100

sched: Pass 'struct rq' to rebalance_domains()

The cpu information is stored in the struct rq and the caller of the
rebalance_domains function pass the cpu to retrieve the struct rq but
it already has the struct rq info. Replace the cpu parameter with the
struct rq.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389008085-9069-7-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b91cd93..ff4e0df 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6640,10 +6640,10 @@ void update_max_interval(void)
  *
  * Balancing parameters are set up in init_sched_domains.
  */
-static void rebalance_domains(int cpu, enum cpu_idle_type idle)
+static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)
 {
 	int continue_balancing = 1;
-	struct rq *rq = cpu_rq(cpu);
+	int cpu = rq->cpu;
 	unsigned long interval;
 	struct sched_domain *sd;
 	/* Earliest time when we have to do rebalance again */
@@ -6769,7 +6769,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		update_idle_cpu_load(rq);
 		raw_spin_unlock_irq(&rq->lock);
 
-		rebalance_domains(balance_cpu, CPU_IDLE);
+		rebalance_domains(rq, CPU_IDLE);
 
 		if (time_after(this_rq->next_balance, rq->next_balance))
 			this_rq->next_balance = rq->next_balance;
@@ -6858,7 +6858,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
-	rebalance_domains(this_cpu, idle);
+	rebalance_domains(this_rq, idle);
 
 	/*
 	 * If this cpu has a pending nohz_balance_kick, then do the
