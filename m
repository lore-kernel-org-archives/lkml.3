Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaKPMct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:32:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35516 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKPMcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:32:47 -0500
Date: Sun, 16 Nov 2014 04:32:15 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-6c1d9410f007a26d13173cf17204cfd965f49b83@git.kernel.org>
Cc: hpa@zytor.com, mingo@kernel.org, pang.xunlei@linaro.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org,
        wanpeng.li@linux.intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, peterz@infradead.org
Reply-To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        pang.xunlei@linaro.org, linux-kernel@vger.kernel.org,
        wanpeng.li@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        peterz@infradead.org
In-Reply-To: <1415150077-59053-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1415150077-59053-1-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move p->
 nr_cpus_allowed check to select_task_rq()
Git-Commit-ID: 6c1d9410f007a26d13173cf17204cfd965f49b83
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

Commit-ID:  6c1d9410f007a26d13173cf17204cfd965f49b83
Gitweb:     http://git.kernel.org/tip/6c1d9410f007a26d13173cf17204cfd965f49b83
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Wed, 5 Nov 2014 09:14:37 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:58:55 +0100

sched: Move p->nr_cpus_allowed check to select_task_rq()

Move the p->nr_cpus_allowed check into kernel/sched/core.c: select_task_rq().
This change will make fair.c, rt.c, and deadline.c all start with the
same logic.

Suggested-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1415150077-59053-1-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c     | 3 ++-
 kernel/sched/deadline.c | 3 ---
 kernel/sched/fair.c     | 3 ---
 kernel/sched/rt.c       | 3 ---
 4 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3ccdce1..d44d0c5 100644
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
index b091179..bb1464b 100644
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
index d11c57d..8bca292 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4730,9 +4730,6 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
 
-	if (p->nr_cpus_allowed == 1)
-		return prev_cpu;
-
 	if (sd_flag & SD_BALANCE_WAKE)
 		want_affine = cpumask_test_cpu(cpu, tsk_cpus_allowed(p));
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index f1bb92f..ee15f5a 100644
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
