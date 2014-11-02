Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaKBHa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:30:58 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:60354 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaKBHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:30:55 -0500
Message-ID: <1414913451.5380.111.camel@marge.simpson.net>
Subject: 3.14.23-rt20 - sched/numa: Fix task_numa_free() lockdep splat
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Sun, 02 Nov 2014 08:30:51 +0100
In-Reply-To: <1414910967.5380.81.camel@marge.simpson.net>
References: <20141031170326.1491a63f@gandalf.local.home>
	 <1414910967.5380.81.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 60e69eed85bb7b5198ef70643b5895c26ad76ef7 Mon Sep 17 00:00:00 2001
From: Mike Galbraith <bitbucket@online.de>
Date: Mon, 7 Apr 2014 10:55:15 +0200
Subject: sched/numa: Fix task_numa_free() lockdep splat

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
 kernel/sched/fair.c  |   13 +++++++------
 kernel/sched/sched.h |    9 +++++++++
 2 files changed, 16 insertions(+), 6 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1371,7 +1371,7 @@ static void task_numa_placement(struct t
 	/* If the task is part of a group prevent parallel updates to group stats */
 	if (p->numa_group) {
 		group_lock = &p->numa_group->lock;
-		spin_lock(group_lock);
+		spin_lock_irq(group_lock);
 	}
 
 	/* Find the node with the highest number of faults */
@@ -1432,7 +1432,7 @@ static void task_numa_placement(struct t
 			}
 		}
 
-		spin_unlock(group_lock);
+		spin_unlock_irq(group_lock);
 	}
 
 	/* Preferred node as the node with the most faults */
@@ -1532,7 +1532,8 @@ static void task_numa_group(struct task_
 	if (!join)
 		return;
 
-	double_lock(&my_grp->lock, &grp->lock);
+	BUG_ON(irqs_disabled());
+	double_lock_irq(&my_grp->lock, &grp->lock);
 
 	for (i = 0; i < 2*nr_node_ids; i++) {
 		my_grp->faults[i] -= p->numa_faults[i];
@@ -1546,7 +1547,7 @@ static void task_numa_group(struct task_
 	grp->nr_tasks++;
 
 	spin_unlock(&my_grp->lock);
-	spin_unlock(&grp->lock);
+	spin_unlock_irq(&grp->lock);
 
 	rcu_assign_pointer(p->numa_group, grp);
 
@@ -1565,14 +1566,14 @@ void task_numa_free(struct task_struct *
 	void *numa_faults = p->numa_faults;
 
 	if (grp) {
-		spin_lock(&grp->lock);
+		spin_lock_irq(&grp->lock);
 		for (i = 0; i < 2*nr_node_ids; i++)
 			grp->faults[i] -= p->numa_faults[i];
 		grp->total_faults -= p->total_numa_faults;
 
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
-		spin_unlock(&grp->lock);
+		spin_unlock_irq(&grp->lock);
 		rcu_assign_pointer(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1402,6 +1402,15 @@ static inline void double_lock(spinlock_
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






