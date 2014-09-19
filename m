Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbaISJXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:23:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40364 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaISJWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:22:40 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, juri.lelli@gmail.com, raistlin@linux.it,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        daniel.wagner@bmw-carit.de, vincent@legout.info, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@arm.com>
Subject: [PATCH 3/3] sched/deadline: fix inter- exclusive cpusets migrations
Date: Fri, 19 Sep 2014 10:22:41 +0100
Message-Id: <1411118561-26323-4-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
X-OriginalArrivalTime: 19 Sep 2014 09:22:36.0334 (UTC) FILETIME=[401B4CE0:01CFD3EB]
X-MC-Unique: 114091910223810201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8J9NXbP015353

Users can perform clustered scheduling using the cpuset facility.
After an exclusive cpuset is created, task migrations happen only
between CPUs belonging to the same cpuset. Inter- cpuset migrations
can only happen when the user requires so, moving a task between
different cpusets. This behaviour is broken in SCHED_DEADLINE, as
currently spurious inter- cpuset migration may happen without
user intervention.

This patch fix the problem (and shuffles the code a bit to improve
clarity).

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <michael@amarulasolutions.com>
Cc: Fabio Checconi <fchecconi@gmail.com>
Cc: linux-kernel@vger.kernel.org
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
index 56cb157..2799441 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1169,6 +1169,13 @@ static int find_later_rq(struct task_struct *task)
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
-- 
2.1.0


