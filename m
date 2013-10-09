Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab3JIRb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:31:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3JIRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:31:49 -0400
Date: Wed, 9 Oct 2013 10:31:13 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-e29cf08b05dc0b8151d65704d96d525a9e179a6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-45-git-send-email-mgorman@suse.de>
References: <1381141781-10992-45-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Report a NUMA task group ID
Git-Commit-ID: e29cf08b05dc0b8151d65704d96d525a9e179a6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:31:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e29cf08b05dc0b8151d65704d96d525a9e179a6b
Gitweb:     http://git.kernel.org/tip/e29cf08b05dc0b8151d65704d96d525a9e179a6b
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:22 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:47:49 +0200

sched/numa: Report a NUMA task group ID

It is desirable to model from userspace how the scheduler groups tasks
over time. This patch adds an ID to the numa_group and reports it via
/proc/PID/status.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-45-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/proc/array.c       | 2 ++
 include/linux/sched.h | 5 +++++
 kernel/sched/fair.c   | 7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index cbd0f1b..1bd2077 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -183,6 +183,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
+		"Ngid:\t%d\n"
 		"Pid:\t%d\n"
 		"PPid:\t%d\n"
 		"TracerPid:\t%d\n"
@@ -190,6 +191,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
 		task_tgid_nr_ns(p, ns),
+		task_numa_group_id(p),
 		pid_nr_ns(pid, ns),
 		ppid, tpid,
 		from_kuid_munged(user_ns, cred->uid),
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f587ded..b0b343b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1452,12 +1452,17 @@ struct task_struct {
 
 #ifdef CONFIG_NUMA_BALANCING
 extern void task_numa_fault(int last_node, int node, int pages, bool migrated);
+extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   bool migrated)
 {
 }
+static inline pid_t task_numa_group_id(struct task_struct *p)
+{
+	return 0;
+}
 static inline void set_numabalancing_state(bool enabled)
 {
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8556505..5bd309c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -893,12 +893,18 @@ struct numa_group {
 
 	spinlock_t lock; /* nr_tasks, tasks */
 	int nr_tasks;
+	pid_t gid;
 	struct list_head task_list;
 
 	struct rcu_head rcu;
 	atomic_long_t faults[0];
 };
 
+pid_t task_numa_group_id(struct task_struct *p)
+{
+	return p->numa_group ? p->numa_group->gid : 0;
+}
+
 static inline int task_faults_idx(int nid, int priv)
 {
 	return 2 * nid + priv;
@@ -1265,6 +1271,7 @@ static void task_numa_group(struct task_struct *p, int cpupid)
 		atomic_set(&grp->refcount, 1);
 		spin_lock_init(&grp->lock);
 		INIT_LIST_HEAD(&grp->task_list);
+		grp->gid = p->pid;
 
 		for (i = 0; i < 2*nr_node_ids; i++)
 			atomic_long_set(&grp->faults[i], p->numa_faults[i]);
