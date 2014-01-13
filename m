Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaAMP5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:57:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60912 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaAMP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:56:58 -0500
Date: Mon, 13 Jan 2014 07:56:27 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-208cb16ba325552a3935bfc002e34561b0d512d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1389008085-9069-8-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-8-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Pass 'struct rq' to nohz_idle_balance()
Git-Commit-ID: 208cb16ba325552a3935bfc002e34561b0d512d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:56:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  208cb16ba325552a3935bfc002e34561b0d512d7
Gitweb:     http://git.kernel.org/tip/208cb16ba325552a3935bfc002e34561b0d512d7
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 6 Jan 2014 12:34:44 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:33 +0100

sched: Pass 'struct rq' to nohz_idle_balance()

The cpu information is stored in the struct rq. Pass the struct rq to
nohz_idle_balance, so all the functions called in run_rebalance_domains have
the same parameters and the 'this_cpu' variable becomes pointless.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
[ Added !SMP build fix. ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389008085-9069-8-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ff4e0df..d7220d1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6740,9 +6740,9 @@ out:
  * In CONFIG_NO_HZ_COMMON case, the idle balance kickee will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
-static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 {
-	struct rq *this_rq = cpu_rq(this_cpu);
+	int this_cpu = this_rq->cpu;
 	struct rq *rq;
 	int balance_cpu;
 
@@ -6844,7 +6844,7 @@ need_kick:
 	return 1;
 }
 #else
-static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle) { }
 #endif
 
 /*
@@ -6853,8 +6853,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
  */
 static void run_rebalance_domains(struct softirq_action *h)
 {
-	int this_cpu = smp_processor_id();
-	struct rq *this_rq = cpu_rq(this_cpu);
+	struct rq *this_rq = this_rq();
 	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
@@ -6865,7 +6864,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 	 * balancing on behalf of the other idle cpus whose ticks are
 	 * stopped.
 	 */
-	nohz_idle_balance(this_cpu, idle);
+	nohz_idle_balance(this_rq, idle);
 }
 
 static inline int on_null_domain(struct rq *rq)
