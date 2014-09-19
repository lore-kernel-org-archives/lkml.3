Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaISLof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:44:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaISLod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:44:33 -0400
Date: Fri, 19 Sep 2014 04:43:30 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-ba7e5a279e72f4b246dc7a419ac707e1936ede3e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, riel@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, riel@redhat.com, tglx@linutronix.de
In-Reply-To: <20140904163530.189d410a@cuia.bos.redhat.com>
References: <20140904163530.189d410a@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Use select_idle_sibling()
  to select a destination for task_numa_move()
Git-Commit-ID: ba7e5a279e72f4b246dc7a419ac707e1936ede3e
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

Commit-ID:  ba7e5a279e72f4b246dc7a419ac707e1936ede3e
Gitweb:     http://git.kernel.org/tip/ba7e5a279e72f4b246dc7a419ac707e1936ede3e
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Thu, 4 Sep 2014 16:35:30 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:14 +0200

sched/numa: Use select_idle_sibling() to select a destination for task_numa_move()

The code in task_numa_compare() will only examine at most one idle CPU per node,
because they all have the same score. However, some idle CPUs are better
candidates than others, due to busy or idle SMT siblings, etc...

The scheduler has logic to find the best CPU within an LLC to place a
task. The NUMA code should probably use it.

This seems to reduce the standard deviation for single instance SPECjbb2005
with a low warehouse count on my 4 node test system.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140904163530.189d410a@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index be9e97b..96e7147 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -665,6 +665,7 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #ifdef CONFIG_SMP
+static int select_idle_sibling(struct task_struct *p, int cpu);
 static unsigned long task_h_load(struct task_struct *p);
 
 static inline void __update_task_entity_contrib(struct sched_entity *se);
@@ -1257,6 +1258,13 @@ balance:
 	if (load_too_imbalanced(src_load, dst_load, env))
 		goto unlock;
 
+	/*
+	 * One idle CPU per node is evaluated for a task numa move.
+	 * Call select_idle_sibling to maybe find a better one.
+	 */
+	if (!cur)
+		env->dst_cpu = select_idle_sibling(env->p, env->dst_cpu);
+
 assign:
 	task_numa_assign(env, cur, imp);
 unlock:
