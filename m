Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3JIRbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:31:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56343 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab3JIRbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:31:14 -0400
Date: Wed, 9 Oct 2013 10:30:33 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-2c8a50aa873a7e1d6cc0913362051ff9912dc6ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-41-git-send-email-mgorman@suse.de>
References: <1381141781-10992-41-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Favor placing a task on the preferred node
Git-Commit-ID: 2c8a50aa873a7e1d6cc0913362051ff9912dc6ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:30:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c8a50aa873a7e1d6cc0913362051ff9912dc6ca
Gitweb:     http://git.kernel.org/tip/2c8a50aa873a7e1d6cc0913362051ff9912dc6ca
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:18 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:47:41 +0200

sched/numa: Favor placing a task on the preferred node

A tasks preferred node is selected based on the number of faults
recorded for a node but the actual task_numa_migate() conducts a global
search regardless of the preferred nid. This patch checks if the
preferred nid has capacity and if so, searches for a CPU within that
node. This avoids a global search when the preferred node is not
overloaded.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-41-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 54 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1422765..09aac90 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1052,6 +1052,20 @@ unlock:
 	rcu_read_unlock();
 }
 
+static void task_numa_find_cpu(struct task_numa_env *env, long imp)
+{
+	int cpu;
+
+	for_each_cpu(cpu, cpumask_of_node(env->dst_nid)) {
+		/* Skip this CPU if the source task cannot migrate */
+		if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)))
+			continue;
+
+		env->dst_cpu = cpu;
+		task_numa_compare(env, imp);
+	}
+}
+
 static int task_numa_migrate(struct task_struct *p)
 {
 	struct task_numa_env env = {
@@ -1068,7 +1082,8 @@ static int task_numa_migrate(struct task_struct *p)
 	};
 	struct sched_domain *sd;
 	unsigned long faults;
-	int nid, cpu, ret;
+	int nid, ret;
+	long imp;
 
 	/*
 	 * Pick the lowest SD_NUMA domain, as that would have the smallest
@@ -1085,28 +1100,29 @@ static int task_numa_migrate(struct task_struct *p)
 
 	faults = task_faults(p, env.src_nid);
 	update_numa_stats(&env.src_stats, env.src_nid);
+	env.dst_nid = p->numa_preferred_nid;
+	imp = task_faults(env.p, env.dst_nid) - faults;
+	update_numa_stats(&env.dst_stats, env.dst_nid);
 
-	/* Find an alternative node with relatively better statistics */
-	for_each_online_node(nid) {
-		long imp;
-
-		if (nid == env.src_nid)
-			continue;
-
-		/* Only consider nodes that recorded more faults */
-		imp = task_faults(p, nid) - faults;
-		if (imp < 0)
-			continue;
+	/*
+	 * If the preferred nid has capacity then use it. Otherwise find an
+	 * alternative node with relatively better statistics.
+	 */
+	if (env.dst_stats.has_capacity) {
+		task_numa_find_cpu(&env, imp);
+	} else {
+		for_each_online_node(nid) {
+			if (nid == env.src_nid || nid == p->numa_preferred_nid)
+				continue;
 
-		env.dst_nid = nid;
-		update_numa_stats(&env.dst_stats, env.dst_nid);
-		for_each_cpu(cpu, cpumask_of_node(nid)) {
-			/* Skip this CPU if the source task cannot migrate */
-			if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+			/* Only consider nodes that recorded more faults */
+			imp = task_faults(env.p, nid) - faults;
+			if (imp < 0)
 				continue;
 
-			env.dst_cpu = cpu;
-			task_numa_compare(&env, imp);
+			env.dst_nid = nid;
+			update_numa_stats(&env.dst_stats, env.dst_nid);
+			task_numa_find_cpu(&env, imp);
 		}
 	}
 
