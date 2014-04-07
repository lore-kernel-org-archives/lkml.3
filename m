Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaDGIzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:55:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:57101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaDGIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:55:32 -0400
Message-ID: <1396860915.5170.5.camel@marge.simpson.net>
Subject: Re: [tip:sched/core] sched/numa: Move task_numa_free() to
 __put_task_struct()
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mgorman@suse.com, akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, Dave Jones <davej@redhat.com>
Date: Mon, 07 Apr 2014 10:55:15 +0200
In-Reply-To: <20140407081644.GD11096@twins.programming.kicks-ass.net>
References: <1393568591.6018.27.camel@marge.simpson.net>
	 <tip-156654f491dd8d52687a5fbe1637f472a52ce75b@git.kernel.org>
	 <5341A84C.4050902@oracle.com> <1396848585.5218.27.camel@marge.simpson.net>
	 <1396855830.28539.10.camel@marge.simpson.net>
	 <20140407081644.GD11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:ukWjx3nScTmO6MSA7gaUvt15HGMSsvLN9tuNbVMiJFF
 VXd6rhFdSoTLbe8Fexx8LR+9LzZMCEFGlh5MoyUlkHd/ZFm5Wd
 H9ARHTe1vQb8SIYEJBuY2r75LPMOoGbEv7Pfnk1JJbF3Z1bnow
 DLaxsqTEgUFdV1QN4aU56PFYNrdMM95xTi09xd9hokSfFg3b1x
 fvYH3EeenriPaYWz+JjqbLcqJZWCwGoHxVfq+kCC+Azgz1oOAC
 RsD9eZmR/08vFEfsLuzObCBYA/+PJ72pieZhqWJ5GGwKOYkUf6
 56lu1LGRwtzHZb1g9TV0rINZDNWcj2R3MabQGTtWqssnNdcrMa
 Hb+dffX53ur88BJ+EqZXyTRJCNjf5sW/0HQw7DDEP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 10:16 +0200, Peter Zijlstra wrote: 
> On Mon, Apr 07, 2014 at 09:30:30AM +0200, Mike Galbraith wrote:
> > -	double_lock(&my_grp->lock, &grp->lock);
> > +	BUG_ON(irqs_disabled());
> > +	double_lock_irq(&my_grp->lock, &grp->lock);
> 
> So either make this:
> 
> 	local_irq_disable();
> 	double_lock();
> 
> or
> 
> >  
> >  	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
> >  		my_grp->faults[i] -= p->numa_faults_memory[i];
> > @@ -1692,6 +1693,7 @@ static void task_numa_group(struct task_
> >  
> >  	spin_unlock(&my_grp->lock);
> >  	spin_unlock(&grp->lock);
> > +	local_irq_enable();
> 
> use:
> 	spin_unlock()
> 	spin_unlock_irq()
> 
> or so, but this imbalance is making my itch :-)

sched, numa: fix task_numa_free() lockdep splat

Sasha reports that lockdep claims 156654f491dd8d52687a5fbe1637f472a52ce75b made
numa_group.lock interrupt unsafe.  While I don't see how that could be given the
commit in question moved task_numa_free() from one irq enabled region to another,
the below does make both gripes and lockups upon gripe with numa=fake=4 go away.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 kernel/sched/fair.c  |   13 +++++++------
 kernel/sched/sched.h |    9 +++++++++
 2 files changed, 16 insertions(+), 6 deletions(-)

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
@@ -1691,7 +1692,7 @@ static void task_numa_group(struct task_
 	grp->nr_tasks++;
 
 	spin_unlock(&my_grp->lock);
-	spin_unlock(&grp->lock);
+	spin_unlock_irq(&grp->lock);
 
 	rcu_assign_pointer(p->numa_group, grp);
 
@@ -1710,14 +1711,14 @@ void task_numa_free(struct task_struct *
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


