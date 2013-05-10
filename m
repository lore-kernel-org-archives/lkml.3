Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3EJMHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:07:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3EJMHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:07:52 -0400
Date: Fri, 10 May 2013 05:07:08 -0700
From: tip-bot for Nathan Zimmer <tipbot@zytor.com>
Message-ID: <tip-424c93fe4cbe719e7fd7169248d2b648c493b68d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, nzimmer@sgi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, nzimmer@sgi.com, tglx@linutronix.de
In-Reply-To: <1368116643-87971-1-git-send-email-nzimmer@sgi.com>
References: <1368116643-87971-1-git-send-email-nzimmer@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use this_rq() helper
Git-Commit-ID: 424c93fe4cbe719e7fd7169248d2b648c493b68d
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

Commit-ID:  424c93fe4cbe719e7fd7169248d2b648c493b68d
Gitweb:     http://git.kernel.org/tip/424c93fe4cbe719e7fd7169248d2b648c493b68d
Author:     Nathan Zimmer <nzimmer@sgi.com>
AuthorDate: Thu, 9 May 2013 11:24:03 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 10 May 2013 10:35:56 +0200

sched: Use this_rq() helper

It is a few instructions more efficent to and slightly more
readable to use this_rq()-> instead of cpu_rq(smp_processor_id())-> .

Size comparison of kernel/sched/fair.o:

   text    data     bss     dec     hex filename
  27972     122      26   28120    6dd8 fair.o.before
  27956     122      26   28104    6dc8 fair.o.after

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1368116643-87971-1-git-send-email-nzimmer@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 6 ++----
 kernel/sched/rt.c   | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..f2c9c0c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5418,10 +5418,9 @@ static inline void nohz_balance_exit_idle(int cpu)
 static inline void set_cpu_sd_state_busy(void)
 {
 	struct sched_domain *sd;
-	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
 
 	if (!sd || !sd->nohz_idle)
 		goto unlock;
@@ -5436,10 +5435,9 @@ unlock:
 void set_cpu_sd_state_idle(void)
 {
 	struct sched_domain *sd;
-	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
 
 	if (!sd || sd->nohz_idle)
 		goto unlock;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 127a2c4..7aced2e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -472,7 +472,7 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
 #ifdef CONFIG_SMP
 static inline const struct cpumask *sched_rt_period_mask(void)
 {
-	return cpu_rq(smp_processor_id())->rd->span;
+	return this_rq()->rd->span;
 }
 #else
 static inline const struct cpumask *sched_rt_period_mask(void)
