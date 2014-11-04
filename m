Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaKDQLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:11:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaKDQLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:11:12 -0500
Date: Tue, 4 Nov 2014 08:10:35 -0800
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-75e23e49dbdd86aace375f599062aa67483a001b@git.kernel.org>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
        juri.lelli@arm.com, hpa@zytor.com
Reply-To: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, juri.lelli@arm.com, hpa@zytor.com,
        tglx@linutronix.de, peterz@infradead.org
In-Reply-To: <1414497286-28824-1-git-send-email-juri.lelli@arm.com>
References: <1414497286-28824-1-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/core: Use dl_bw_of()
  under rcu_read_lock_sched()
Git-Commit-ID: 75e23e49dbdd86aace375f599062aa67483a001b
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

Commit-ID:  75e23e49dbdd86aace375f599062aa67483a001b
Gitweb:     http://git.kernel.org/tip/75e23e49dbdd86aace375f599062aa67483a001b
Author:     Juri Lelli <juri.lelli@arm.com>
AuthorDate: Tue, 28 Oct 2014 11:54:46 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:52 +0100

sched/core: Use dl_bw_of() under rcu_read_lock_sched()

As per commit f10e00f4bf36 ("sched/dl: Use dl_bw_of() under
rcu_read_lock_sched()"), dl_bw_of() has to be protected by
rcu_read_lock_sched().

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414497286-28824-1-git-send-email-juri.lelli@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 379cb87..df0569e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4661,6 +4661,7 @@ int cpuset_cpumask_can_shrink(const struct cpumask *cur,
 	struct dl_bw *cur_dl_b;
 	unsigned long flags;
 
+	rcu_read_lock_sched();
 	cur_dl_b = dl_bw_of(cpumask_any(cur));
 	trial_cpus = cpumask_weight(trial);
 
@@ -4669,6 +4670,7 @@ int cpuset_cpumask_can_shrink(const struct cpumask *cur,
 	    cur_dl_b->bw * trial_cpus < cur_dl_b->total_bw)
 		ret = 0;
 	raw_spin_unlock_irqrestore(&cur_dl_b->lock, flags);
+	rcu_read_unlock_sched();
 
 	return ret;
 }
@@ -4697,11 +4699,13 @@ int task_can_attach(struct task_struct *p,
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
@@ -4717,6 +4721,7 @@ int task_can_attach(struct task_struct *p,
 			__dl_add(dl_b, p->dl.dl_bw);
 		}
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+		rcu_read_unlock_sched();
 
 	}
 #endif
