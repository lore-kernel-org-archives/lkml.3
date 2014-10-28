Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaJ1Ly6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:54:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51675 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaJ1Ly5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:54:57 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@arm.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] sched/core: dl_bw_of() has to be used under rcu_read_lock_sched()
Date: Tue, 28 Oct 2014 11:54:46 +0000
Message-Id: <1414497286-28824-1-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.1.2
X-OriginalArrivalTime: 28 Oct 2014 11:54:54.0317 (UTC) FILETIME=[FCE119D0:01CFF2A5]
X-MC-Unique: 114102811545500201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id s9SBt55k024618

As per commit f10e00f4bf36 ("sched/dl: Use dl_bw_of() under
rcu_read_lock_sched()"), dl_bw_of() has to be protected by
rcu_read_lock_sched().

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
---
 kernel/sched/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b9f78f1..b9fb426 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4657,6 +4657,7 @@ int cpuset_cpumask_can_shrink(const struct cpumask *cur,
 	struct dl_bw *cur_dl_b;
 	unsigned long flags;
 
+	rcu_read_lock_sched();
 	cur_dl_b = dl_bw_of(cpumask_any(cur));
 	trial_cpus = cpumask_weight(trial);
 
@@ -4665,6 +4666,7 @@ int cpuset_cpumask_can_shrink(const struct cpumask *cur,
 	    cur_dl_b->bw * trial_cpus < cur_dl_b->total_bw)
 		ret = 0;
 	raw_spin_unlock_irqrestore(&cur_dl_b->lock, flags);
+	rcu_read_unlock_sched();
 
 	return ret;
 }
@@ -4693,11 +4695,13 @@ int task_can_attach(struct task_struct *p,
 					      cs_cpus_allowed)) {
 		unsigned int dest_cpu = cpumask_any_and(cpu_active_mask,
 							cs_cpus_allowed);
-		struct dl_bw *dl_b = dl_bw_of(dest_cpu);
+		struct dl_bw *dl_b;
 		bool overflow;
 		int cpus;
 		unsigned long flags;
 
+		rcu_read_lock_sched();
+		dl_b = dl_bw_of(dest_cpu);
 		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		cpus = dl_bw_cpus(dest_cpu);
 		overflow = __dl_overflow(dl_b, cpus, 0, p->dl.dl_bw);
@@ -4713,6 +4717,7 @@ int task_can_attach(struct task_struct *p,
 			__dl_add(dl_b, p->dl.dl_bw);
 		}
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+		rcu_read_unlock_sched();
 
 	}
 #endif
-- 
2.1.2


