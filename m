Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaJXJRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:17:15 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37736 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaJXJQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:16:52 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: juri.lelli@gmail.com, mingo@redhat.com, daniel.wagner@bmw-carit.de,
        vincent@legout.info, Juri Lelli <juri.lelli@arm.com>,
        Dario Faggioli <raistlin@linux.it>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Fabio Checconi <fchecconi@gmail.com>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [PATCH 2/4] sched/deadline: ensure that updates to exclusive cpusets don't break AC
Date: Fri, 24 Oct 2014 10:16:36 +0100
Message-Id: <1414142198-18552-3-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
References: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
X-OriginalArrivalTime: 24 Oct 2014 09:16:50.0670 (UTC) FILETIME=[3E8868E0:01CFEF6B]
X-MC-Unique: 114102410165017801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id s9O9HK48022058

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
Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <michael@amarulasolutions.com>
Cc: Fabio Checconi <fchecconi@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
---
 include/linux/sched.h |  2 ++
 kernel/cpuset.c       | 10 ++++++++++
 kernel/sched/core.c   | 21 +++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f225f20..d4ed0db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2032,6 +2032,8 @@ static inline void tsk_restore_flags(struct task_struct *task,
 	task->flags |= orig_flags & flags;
 }
 
+extern int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+				     const struct cpumask *trial);
 extern int task_can_attach(struct task_struct *p,
 			   const struct cpumask *cs_cpus_allowed);
 #ifdef CONFIG_SMP
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ab9be24..9066cc7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -505,6 +505,16 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
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
index 07ec9bb..35674eb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4622,6 +4622,27 @@ void init_idle(struct task_struct *idle, int cpu)
 #endif
 }
 
+int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+			      const struct cpumask *trial)
+{
+	int ret = 1, trial_cpus;
+	struct dl_bw *cur_dl_b;
+	unsigned long flags;
+
+	rcu_read_lock_sched();
+	cur_dl_b = dl_bw_of(cpumask_any(cur));
+	trial_cpus = cpumask_weight(trial);
+
+	raw_spin_lock_irqsave(&cur_dl_b->lock, flags);
+	if (cur_dl_b->bw != -1 &&
+	    cur_dl_b->bw * trial_cpus < cur_dl_b->total_bw)
+		ret = 0;
+	raw_spin_unlock_irqrestore(&cur_dl_b->lock, flags);
+	rcu_read_unlock_sched();
+
+	return ret;
+}
+
 int task_can_attach(struct task_struct *p,
 		    const struct cpumask *cs_cpus_allowed)
 {
-- 
2.1.2


