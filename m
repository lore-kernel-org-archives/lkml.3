Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaJ1LEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:04:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaJ1LEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:04:46 -0400
Date: Tue, 28 Oct 2014 04:04:01 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-9942f79baaaf111d63ebf0862a819278d84fccc4@git.kernel.org>
Cc: torvalds@linux-foundation.org, peterz@infradead.org, hpa@zytor.com,
        riel@redhat.com, mingo@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, riel@redhat.com, hpa@zytor.com,
        peterz@infradead.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1413530994-9732-2-git-send-email-riel@redhat.com>
References: <1413530994-9732-2-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Export info needed for NUMA balancing on complex topologies
Git-Commit-ID: 9942f79baaaf111d63ebf0862a819278d84fccc4
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

Commit-ID:  9942f79baaaf111d63ebf0862a819278d84fccc4
Gitweb:     http://git.kernel.org/tip/9942f79baaaf111d63ebf0862a819278d84fccc4
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 17 Oct 2014 03:29:49 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:47 +0100

sched/numa: Export info needed for NUMA balancing on complex topologies

Export some information that is necessary to do placement of
tasks on systems with multi-level NUMA topologies.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1413530994-9732-2-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 4 +++-
 kernel/sched/sched.h | 5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c..4007595 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6129,6 +6129,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 #ifdef CONFIG_NUMA
 static int sched_domains_numa_levels;
 static int *sched_domains_numa_distance;
+int sched_max_numa_distance;
 static struct cpumask ***sched_domains_numa_masks;
 static int sched_domains_curr_level;
 #endif
@@ -6300,7 +6301,7 @@ static void sched_numa_warn(const char *str)
 	printk(KERN_WARNING "\n");
 }
 
-static bool find_numa_distance(int distance)
+bool find_numa_distance(int distance)
 {
 	int i;
 
@@ -6447,6 +6448,7 @@ static void sched_init_numa(void)
 	sched_domain_topology = tl;
 
 	sched_domains_numa_levels = level;
+	sched_max_numa_distance = sched_domains_numa_distance[level - 1];
 }
 
 static void sched_domains_numa_masks_set(int cpu)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24156c84..443d6e1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -678,6 +678,11 @@ static inline u64 rq_clock_task(struct rq *rq)
 	return rq->clock_task;
 }
 
+#ifdef CONFIG_NUMA
+extern int sched_max_numa_distance;
+extern bool find_numa_distance(int distance);
+#endif
+
 #ifdef CONFIG_NUMA_BALANCING
 extern void sched_setnuma(struct task_struct *p, int node);
 extern int migrate_task_to(struct task_struct *p, int cpu);
