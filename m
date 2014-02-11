Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaBKMS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:18:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaBKMSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:18:03 -0500
Date: Tue, 11 Feb 2014 04:17:31 -0800
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-37e6bae8395a94b4dd934c92b02b9408be992365@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alex.shi@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, alex.shi@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <52E0F3BF.5020904@linaro.org>
References: <52E0F3BF.5020904@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Add statistic for newidle load balance cost
Git-Commit-ID: 37e6bae8395a94b4dd934c92b02b9408be992365
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:17:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37e6bae8395a94b4dd934c92b02b9408be992365
Gitweb:     http://git.kernel.org/tip/37e6bae8395a94b4dd934c92b02b9408be992365
Author:     Alex Shi <alex.shi@linaro.org>
AuthorDate: Thu, 23 Jan 2014 18:39:54 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Feb 2014 09:58:18 +0100

sched: Add statistic for newidle load balance cost

Tracking rq->max_idle_balance_cost and sd->max_newidle_lb_cost.
It's useful to know these values in debug mode.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/52E0F3BF.5020904@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 9 ++++++---
 kernel/sched/debug.c | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3068f37..fb9764f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4811,7 +4811,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(13);
+	struct ctl_table *table = sd_alloc_ctl_entry(14);
 
 	if (table == NULL)
 		return NULL;
@@ -4839,9 +4839,12 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[10], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax, false);
-	set_table_entry(&table[11], "name", sd->name,
+	set_table_entry(&table[11], "max_newidle_lb_cost",
+		&sd->max_newidle_lb_cost,
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
+	set_table_entry(&table[12], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[12] is terminator */
+	/* &table[13] is terminator */
 
 	return table;
 }
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 31b908d..f3344c3 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -321,6 +321,7 @@ do {									\
 	P(sched_goidle);
 #ifdef CONFIG_SMP
 	P64(avg_idle);
+	P64(max_idle_balance_cost);
 #endif
 
 	P(ttwu_count);
