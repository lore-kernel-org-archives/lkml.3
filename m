Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaDNHX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:23:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaDNHXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:23:21 -0400
Date: Mon, 14 Apr 2014 00:22:05 -0700
From: tip-bot for Mike Galbraith <tipbot@zytor.com>
Message-ID: <tip-60e69eed85bb7b5198ef70643b5895c26ad76ef7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, bitbucket@online.de,
        davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        bitbucket@online.de, davej@redhat.com, tglx@linutronix.de
In-Reply-To: <1396860915.5170.5.camel@marge.simpson.net>
References: <1396860915.5170.5.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/numa: Fix task_numa_free() lockdep splat
Git-Commit-ID: 60e69eed85bb7b5198ef70643b5895c26ad76ef7
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

Commit-ID:  60e69eed85bb7b5198ef70643b5895c26ad76ef7
Gitweb:     http://git.kernel.org/tip/60e69eed85bb7b5198ef70643b5895c26ad76ef7
Author:     Mike Galbraith <bitbucket@online.de>
AuthorDate: Mon, 7 Apr 2014 10:55:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 11 Apr 2014 10:39:15 +0200

sched/numa: Fix task_numa_free() lockdep splat

Sasha reported that lockdep claims that the following commit:
made numa_group.lock interrupt unsafe:

  156654f491dd ("sched/numa: Move task_numa_free() to __put_task_struct()")

While I don't see how that could be, given the commit in question moved
task_numa_free() from one irq enabled region to another, the below does
make both gripes and lockups upon gripe with numa=fake=4 go away.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Fixes: 156654f491dd ("sched/numa: Move task_numa_free() to __put_task_struct()")
Signed-off-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org
Cc: mgorman@suse.com
Cc: akpm@linux-foundation.org
Cc: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/1396860915.5170.5.camel@marge.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c  | 13 +++++++------
 kernel/sched/sched.h |  9 +++++++++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7e9bd0b..4f14a65 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1497,7 +1497,7 @@ static void task_numa_placement(struct task_struct *p)
 	/* If the task is part of a group prevent parallel updates to group stats */
 	if (p->numa_group) {
 		group_lock = &p->numa_group->lock;
-		spin_lock(group_lock);
+		spin_lock_irq(group_lock);
 	}
 
 	/* Find the node with the highest number of faults */
@@ -1572,7 +1572,7 @@ static void task_numa_placement(struct task_struct *p)
 			}
 		}
 
-		spin_unlock(group_lock);
+		spin_unlock_irq(group_lock);
 	}
 
 	/* Preferred node as the node with the most faults */
@@ -1677,7 +1677,8 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	if (!join)
 		return;
 
-	double_lock(&my_grp->lock, &grp->lock);
+	BUG_ON(irqs_disabled());
+	double_lock_irq(&my_grp->lock, &grp->lock);
 
 	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
 		my_grp->faults[i] -= p->numa_faults_memory[i];
@@ -1691,7 +1692,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	grp->nr_tasks++;
 
 	spin_unlock(&my_grp->lock);
-	spin_unlock(&grp->lock);
+	spin_unlock_irq(&grp->lock);
 
 	rcu_assign_pointer(p->numa_group, grp);
 
@@ -1710,14 +1711,14 @@ void task_numa_free(struct task_struct *p)
 	void *numa_faults = p->numa_faults_memory;
 
 	if (grp) {
-		spin_lock(&grp->lock);
+		spin_lock_irq(&grp->lock);
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
 			grp->faults[i] -= p->numa_faults_memory[i];
 		grp->total_faults -= p->total_numa_faults;
 
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
-		spin_unlock(&grp->lock);
+		spin_unlock_irq(&grp->lock);
 		rcu_assign_pointer(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c9007f2..456e492 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1385,6 +1385,15 @@ static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
 	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
 }
 
+static inline void double_lock_irq(spinlock_t *l1, spinlock_t *l2)
+{
+	if (l1 > l2)
+		swap(l1, l2);
+
+	spin_lock_irq(l1);
+	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
+}
+
 static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
 {
 	if (l1 > l2)
