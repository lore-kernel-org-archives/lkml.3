Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaDGHaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 03:30:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaDGHam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 03:30:42 -0400
Message-ID: <1396855830.28539.10.camel@marge.simpson.net>
Subject: Re: [tip:sched/core] sched/numa: Move task_numa_free() to
 __put_task_struct()
From: Mike Galbraith <bitbucket@online.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, mgorman@suse.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, Dave Jones <davej@redhat.com>
Date: Mon, 07 Apr 2014 09:30:30 +0200
In-Reply-To: <1396848585.5218.27.camel@marge.simpson.net>
References: <1393568591.6018.27.camel@marge.simpson.net>
	 <tip-156654f491dd8d52687a5fbe1637f472a52ce75b@git.kernel.org>
	 <5341A84C.4050902@oracle.com> <1396848585.5218.27.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:yCH1TRwTkb9Sr3KpuaAewe1CW3d1qw807O0o6bv36bn
 kIxoVx4pyPBdzF3JzSfabX86rdVsyno8euW1b6fRGv0ADXEQwq
 ZXPne96VBtLqngEmbEEP75zy4P6EH2ZUWafnsNbQK0FfCT2hF6
 +VcEQLcrE/p/efO21LVuL/i69O/cI/BiL3GEludSpt1EdaWRZp
 17Ql9Q93KYXHlW2IYiqOMDrn/Dqxqqs48RrF06HkglrMfWSJ1a
 8jd7smK/oH1P1IzCU/LYSAAN0UCZmd0qm1yPWCaAXblg4+/EVW
 V2pXUAYpuzCJRiG6KO+nN4BFN4kAR1JWIxT6VoooW2KJZxTZQV
 bdzmtaUPt5dVdfO0BylWcbzl9VNIzWwAP9QtRoW6Q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 07:29 +0200, Mike Galbraith wrote:

> I'm not getting it.
> 
> I moved task_numa_free() from one interrupts enabled spot to another.
> But, with numa=fake=4 and lockdep enabled, not only does lockdep gripe,
> my little box locks up on splat.  Saying spin_lock/unlock_irq() did the
> expected, just moved lockdep gripe to task_numa_fault().
> 
> 
> > [ 2590.270067]  Possible interrupt unsafe locking scenario:
> > [ 2590.270067]
> > [ 2590.270067]        CPU0                    CPU1
> > [ 2590.270067]        ----                    ----
> > [ 2590.270067]   lock(&(&grp->lock)->rlock);
> > [ 2590.270067]                                local_irq_disable();
> > [ 2590.270067]                                lock(&(&new_timer->it_lock)->rlock);
> > [ 2590.270067]                                lock(&(&grp->lock)->rlock);
> > [ 2590.270067]   <Interrupt>
> > [ 2590.270067]     lock(&(&new_timer->it_lock)->rlock);
> > [ 2590.270067]
> > [ 2590.270067]  *** DEADLOCK ***
> 
> Ok, so how did I manage that HARDIRQ-safe -> HARDIRQ-unsafe?

Think I'll turn lockdep off, and make context switches take a good long
while after finish_lock_switch(), but meanwhile, this made it happy.

Sasha reports that lockdep claims 156654f491dd8d52687a5fbe1637f472a52ce75b made
numa_group.lock interrupt unsafe.  While I don't see how that could be given the
commit in question moved task_numa_free() from one irq enabled region to another,
the below does make both gripes and lockup upon gripe with numa=fake=4 go away.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Not-signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 kernel/sched/fair.c  |   12 +++++++-----
 kernel/sched/sched.h |    9 +++++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1497,7 +1497,7 @@ static void task_numa_placement(struct t
 	/* If the task is part of a group prevent parallel updates to group stats */
 	if (p->numa_group) {
 		group_lock = &p->numa_group->lock;
-		spin_lock(group_lock);
+		spin_lock_irq(group_lock);
 	}
 
 	/* Find the node with the highest number of faults */
@@ -1572,7 +1572,7 @@ static void task_numa_placement(struct t
 			}
 		}
 
-		spin_unlock(group_lock);
+		spin_unlock_irq(group_lock);
 	}
 
 	/* Preferred node as the node with the most faults */
@@ -1677,7 +1677,8 @@ static void task_numa_group(struct task_
 	if (!join)
 		return;
 
-	double_lock(&my_grp->lock, &grp->lock);
+	BUG_ON(irqs_disabled());
+	double_lock_irq(&my_grp->lock, &grp->lock);
 
 	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
 		my_grp->faults[i] -= p->numa_faults_memory[i];
@@ -1692,6 +1693,7 @@ static void task_numa_group(struct task_
 
 	spin_unlock(&my_grp->lock);
 	spin_unlock(&grp->lock);
+	local_irq_enable();
 
 	rcu_assign_pointer(p->numa_group, grp);
 
@@ -1710,14 +1712,14 @@ void task_numa_free(struct task_struct *
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
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1388,6 +1388,15 @@ static inline void double_lock(spinlock_
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


