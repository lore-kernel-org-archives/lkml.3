Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaKEBPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:15:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:47759 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaKEBPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:15:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,316,1413270000"; 
   d="scan'208";a="626669254"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH] sched: move p->nr_cpus_allowed to select_task_rq
Date: Wed,  5 Nov 2014 09:14:37 +0800
Message-Id: <1415150077-59053-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move p->nr_cpus_allowed check into kernel/sched/core.c: select_task_rq().
This change will make fair.c, rt.c, and deadline.c all start with the 
same logic.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/core.c     | 3 ++-
 kernel/sched/deadline.c | 3 ---
 kernel/sched/fair.c     | 3 ---
 kernel/sched/rt.c       | 3 ---
 4 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2e7578a..9815e0f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1411,7 +1411,8 @@ out:
 static inline
 int select_task_rq(struct task_struct *p, int cpu, int sd_flags, int wake_flags)
 {
-	cpu = p->sched_class->select_task_rq(p, cpu, sd_flags, wake_flags);
+	if (p->nr_cpus_allowed > 1)
+		cpu = p->sched_class->select_task_rq(p, cpu, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f3d7776..04c2cbb 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -928,9 +928,6 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
 	struct task_struct *curr;
 	struct rq *rq;
 
-	if (p->nr_cpus_allowed == 1)
-		goto out;
-
 	if (sd_flag != SD_BALANCE_WAKE)
 		goto out;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 826fdf3..1a4c688 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4723,9 +4723,6 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
 
-	if (p->nr_cpus_allowed == 1)
-		return prev_cpu;
-
 	if (sd_flag & SD_BALANCE_WAKE)
 		want_affine = cpumask_test_cpu(cpu, tsk_cpus_allowed(p));
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3d14312..4e825e5 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1301,9 +1301,6 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 	struct task_struct *curr;
 	struct rq *rq;
 
-	if (p->nr_cpus_allowed == 1)
-		goto out;
-
 	/* For anything but wake ups, just return the task_cpu */
 	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
 		goto out;
-- 
1.9.1

