Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaIXPHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:07:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59601 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaIXO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:56:12 -0400
Date: Wed, 24 Sep 2014 07:55:11 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-91ec6778ec4f963fcb2c2793610919b572f633b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        juri.lelli@arm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, juri.lelli@arm.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1411118561-26323-4-git-send-email-juri.lelli@arm.com>
References: <1411118561-26323-4-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Fix inter- exclusive cpusets migrations
Git-Commit-ID: 91ec6778ec4f963fcb2c2793610919b572f633b0
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

Commit-ID:  91ec6778ec4f963fcb2c2793610919b572f633b0
Gitweb:     http://git.kernel.org/tip/91ec6778ec4f963fcb2c2793610919b572f633b0
Author:     Juri Lelli <juri.lelli@arm.com>
AuthorDate: Fri, 19 Sep 2014 10:22:41 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:46:57 +0200

sched/deadline: Fix inter- exclusive cpusets migrations

Users can perform clustered scheduling using the cpuset facility.
After an exclusive cpuset is created, task migrations happen only
between CPUs belonging to the same cpuset. Inter- cpuset migrations
can only happen when the user requires so, moving a task between
different cpusets. This behaviour is broken in SCHED_DEADLINE, as
currently spurious inter- cpuset migration may happen without user
intervention.

This patch fix the problem (and shuffles the code a bit to improve
clarity).

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: raistlin@linux.it
Cc: michael@amarulasolutions.com
Cc: fchecconi@gmail.com
Cc: daniel.wagner@bmw-carit.de
Cc: vincent@legout.info
Cc: luca.abeni@unitn.it
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1411118561-26323-4-git-send-email-juri.lelli@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cpudeadline.c | 4 +---
 kernel/sched/deadline.c    | 7 +++++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index bd95963..539ca3c 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -107,9 +107,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	int best_cpu = -1;
 	const struct sched_dl_entity *dl_se = &p->dl;
 
-	if (later_mask && cpumask_and(later_mask, cp->free_cpus,
-			&p->cpus_allowed) && cpumask_and(later_mask,
-			later_mask, cpu_active_mask)) {
+	if (later_mask && cpumask_and(later_mask, later_mask, cp->free_cpus)) {
 		best_cpu = cpumask_any(later_mask);
 		goto out;
 	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index efb9412..abfaf3d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1164,6 +1164,13 @@ static int find_later_rq(struct task_struct *task)
 	if (task->nr_cpus_allowed == 1)
 		return -1;
 
+	/*
+	 * We have to consider system topology and task affinity
+	 * first, then we can look for a suitable cpu.
+	 */
+	cpumask_copy(later_mask, task_rq(task)->rd->span);
+	cpumask_and(later_mask, later_mask, cpu_active_mask);
+	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
 	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
 			task, later_mask);
 	if (best_cpu == -1)
