Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaE0SSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:18:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10496 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751920AbaE0SSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:18:40 -0400
Date: Tue, 27 May 2014 14:18:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3.14-rt] sched/numa: Fix task_numa_free() lockdep splat
Message-ID: <20140527141836.4f466086@gandalf.local.home>
In-Reply-To: <1400297819.9493.11.camel@marge.simpson.net>
References: <20140509181214.GK29014@linutronix.de>
	<1400297819.9493.11.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ moving this to LKML from linux-rt-users, as that's where it should be ]

On Sat, 17 May 2014 05:36:59 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> 3.14-rt being build with a non-rt config is unlikely, but..
> 
> >From 60e69eed85bb7b5198ef70643b5895c26ad76ef7 Mon Sep 17 00:00:00 2001
> From: Mike Galbraith <bitbucket@online.de>
> Date: Mon, 7 Apr 2014 10:55:15 +0200
> Subject: [PATCH] sched/numa: Fix task_numa_free() lockdep splat
> 
> Sasha reported that lockdep claims that the following commit:
> made numa_group.lock interrupt unsafe:
> 
>   156654f491dd ("sched/numa: Move task_numa_free() to __put_task_struct()")
> 
> While I don't see how that could be, given the commit in question moved
> task_numa_free() from one irq enabled region to another, the below does
> make both gripes and lockups upon gripe with numa=fake=4 go away.

It wasn't the irqs that was causing the lockdep splat, but the
softirqs. You moved it into __put_task_struct() which is called as a
rcu callback that gets called from soft irqs. So yes, you need to
prevent softirqs from happening whenever you take the lock.
spin_lock_irq() is a bigger hammer than needed. The patch below should
be good enough.

I kept the double_lock_irq() as there is no double_lock_bh(). Should we
bother to make one?

-- Steve


diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..f072ea9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1497,7 +1497,7 @@ static void task_numa_placement(struct task_struct *p)
 	/* If the task is part of a group prevent parallel updates to group stats */
 	if (p->numa_group) {
 		group_lock = &p->numa_group->lock;
-		spin_lock_irq(group_lock);
+		spin_lock_bh(group_lock);
 	}
 
 	/* Find the node with the highest number of faults */
@@ -1572,7 +1572,7 @@ static void task_numa_placement(struct task_struct *p)
 			}
 		}
 
-		spin_unlock_irq(group_lock);
+		spin_unlock_bh(group_lock);
 	}
 
 	/* Preferred node as the node with the most faults */
@@ -1711,14 +1711,14 @@ void task_numa_free(struct task_struct *p)
 	void *numa_faults = p->numa_faults_memory;
 
 	if (grp) {
-		spin_lock_irq(&grp->lock);
+		spin_lock_bh(&grp->lock);
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
 			grp->faults[i] -= p->numa_faults_memory[i];
 		grp->total_faults -= p->total_numa_faults;
 
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
-		spin_unlock_irq(&grp->lock);
+		spin_unlock_bh(&grp->lock);
 		rcu_assign_pointer(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
