Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbaBUVfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:35:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaBUVfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:35:14 -0500
Date: Fri, 21 Feb 2014 13:34:38 -0800
From: tip-bot for Mike Galbraith <tipbot@zytor.com>
Message-ID: <tip-vmme4f49psirp966pklm5l9j@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mgalbraith@suse.de, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, leiwen@marvell.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, leiwen@marvell.com, peterz@infradead.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, nohz: Isolated cores do not load balance
Git-Commit-ID: 6833dbedc680daac32418f919e675d208eb45fa9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6833dbedc680daac32418f919e675d208eb45fa9
Gitweb:     http://git.kernel.org/tip/6833dbedc680daac32418f919e675d208eb45fa9
Author:     Mike Galbraith <mgalbraith@suse.de>
AuthorDate: Mon, 5 Dec 2011 10:01:47 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:21 +0100

sched, nohz: Isolated cores do not load balance

The user explicitly disabled load balancing, else this core would not be
disconnected.  Don't add these to nohz.idle_cpus_mask.

Cc: Lei Wen <leiwen@marvell.com>
Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-vmme4f49psirp966pklm5l9j@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 37ee473..9ca5d57 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6802,6 +6802,11 @@ out_unlock:
 	return 0;
 }
 
+static inline int on_null_domain(struct rq *rq)
+{
+	return unlikely(!rcu_dereference_sched(rq->sd));
+}
+
 #ifdef CONFIG_NO_HZ_COMMON
 /*
  * idle load balancing details
@@ -6856,8 +6861,13 @@ static void nohz_balancer_kick(void)
 static inline void nohz_balance_exit_idle(int cpu)
 {
 	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
-		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
-		atomic_dec(&nohz.nr_cpus);
+		/*
+		 * Completely isolated CPUs don't ever set, so we must test.
+		 */
+		if (likely(cpumask_test_cpu(cpu, nohz.idle_cpus_mask))) {
+			cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
+			atomic_dec(&nohz.nr_cpus);
+		}
 		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 	}
 }
@@ -6911,6 +6921,12 @@ void nohz_balance_enter_idle(int cpu)
 	if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
 		return;
 
+	/*
+	 * If we're a completely isolated CPU, we don't play.
+	 */
+	if (on_null_domain(cpu_rq(cpu)))
+		return;
+
 	cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
 	atomic_inc(&nohz.nr_cpus);
 	set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
@@ -7173,11 +7189,6 @@ static void run_rebalance_domains(struct softirq_action *h)
 	nohz_idle_balance(this_rq, idle);
 }
 
-static inline int on_null_domain(struct rq *rq)
-{
-	return !rcu_dereference_sched(rq->sd);
-}
-
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  */
