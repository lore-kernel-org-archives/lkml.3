Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaJ1LJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:09:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbaJ1LJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:09:05 -0400
Date: Tue, 28 Oct 2014 04:07:22 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-f82f80426f7afcf55953924e71555984a4bd6ce6@git.kernel.org>
Cc: tglx@linutronix.de, torvalds@linux-foundation.org, mingo@kernel.org,
        peterz@infradead.org, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, juri.lelli@arm.com
Reply-To: torvalds@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org,
        peterz@infradead.org, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, juri.lelli@arm.com
In-Reply-To: <5433E6AF.5080105@arm.com>
References: <5433E6AF.5080105@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Ensure that updates to exclusive cpusets don't break AC
Git-Commit-ID: f82f80426f7afcf55953924e71555984a4bd6ce6
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

Commit-ID:  f82f80426f7afcf55953924e71555984a4bd6ce6
Gitweb:     http://git.kernel.org/tip/f82f80426f7afcf55953924e71555984a4bd6ce6
Author:     Juri Lelli <juri.lelli@arm.com>
AuthorDate: Tue, 7 Oct 2014 09:52:11 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:48:00 +0100

sched/deadline: Ensure that updates to exclusive cpusets don't break AC

How we deal with updates to exclusive cpusets is currently broken.
As an example, suppose we have an exclusive cpuset composed of
two cpus: A[cpu0,cpu1]. We can assign SCHED_DEADLINE task to it
up to the allowed bandwidth. If we want now to modify cpusetA's
cpumask, we have to check that removing a cpu's amount of
bandwidth doesn't break AC guarantees. This thing isn't checked
in the current code.

This patch fixes the problem above, denying an update if the
new cpumask won't have enough bandwidth for SCHED_DEADLINE tasks
that are currently active.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org
Link: http://lkml.kernel.org/r/5433E6AF.5080105@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  2 ++
 kernel/cpuset.c       | 10 ++++++++++
 kernel/sched/core.c   | 19 +++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1d1fa08..320a977 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2052,6 +2052,8 @@ static inline void tsk_restore_flags(struct task_struct *task,
 	task->flags |= orig_flags & flags;
 }
 
+extern int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+				     const struct cpumask *trial);
 extern int task_can_attach(struct task_struct *p,
 			   const struct cpumask *cs_cpus_allowed);
 #ifdef CONFIG_SMP
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 7af8577..723cfc9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -506,6 +506,16 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 			goto out;
 	}
 
+	/*
+	 * We can't shrink if we won't have enough room for SCHED_DEADLINE
+	 * tasks.
+	 */
+	ret = -EBUSY;
+	if (is_cpu_exclusive(cur) &&
+	    !cpuset_cpumask_can_shrink(cur->cpus_allowed,
+				       trial->cpus_allowed))
+		goto out;
+
 	ret = 0;
 out:
 	rcu_read_unlock();
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9993fee..0456a55 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4650,6 +4650,25 @@ void init_idle(struct task_struct *idle, int cpu)
 #endif
 }
 
+int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+			      const struct cpumask *trial)
+{
+	int ret = 1, trial_cpus;
+	struct dl_bw *cur_dl_b;
+	unsigned long flags;
+
+	cur_dl_b = dl_bw_of(cpumask_any(cur));
+	trial_cpus = cpumask_weight(trial);
+
+	raw_spin_lock_irqsave(&cur_dl_b->lock, flags);
+	if (cur_dl_b->bw != -1 &&
+	    cur_dl_b->bw * trial_cpus < cur_dl_b->total_bw)
+		ret = 0;
+	raw_spin_unlock_irqrestore(&cur_dl_b->lock, flags);
+
+	return ret;
+}
+
 int task_can_attach(struct task_struct *p,
 		    const struct cpumask *cs_cpus_allowed)
 {
