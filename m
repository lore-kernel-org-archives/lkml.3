Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaE0VCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:02:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20913 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751540AbaE0VCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:02:06 -0400
Date: Tue, 27 May 2014 17:02:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2] sched/numa: Fix use of spin_{un}lock_irq() when
 interrupts are disabled
Message-ID: <20140527170204.2968e4fd@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Peter Zijlstra told me, we have the following path:

do_exit()
  exit_itimers()
    itimer_delete()
      spin_lock_irqsave(&timer->it_lock, &flags);
      timer_delete_hook(timer);
        kc->timer_del(timer) := posix_cpu_timer_del()
          put_task_struct()
            __put_task_struct()
              task_numa_free()
                spin_lock(&grp->lock);


Which means that task_numa_free() can be called with interrupts
disabled, which means that we should not be using spin_lock_irq() but
spin_lock_irqsave() instead. Otherwise we are enabling interrupts while
holding an interrupt unsafe lock!

Link: http://lkml.kernel.org/r/20140527182541.GH11096@twins.programming.kicks-ass.net

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
v2: let's see if claws mail screws up the format on this on :-p

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..3ea16b0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1707,18 +1707,19 @@ no_join:
 void task_numa_free(struct task_struct *p)
 {
 	struct numa_group *grp = p->numa_group;
-	int i;
 	void *numa_faults = p->numa_faults_memory;
+	unsigned long flags;
+	int i;
 
 	if (grp) {
-		spin_lock_irq(&grp->lock);
+		spin_lock_irqsave(&grp->lock, flags);
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
 			grp->faults[i] -= p->numa_faults_memory[i];
 		grp->total_faults -= p->total_numa_faults;
 
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
-		spin_unlock_irq(&grp->lock);
+		spin_unlock_irqrestore(&grp->lock, flags);
 		rcu_assign_pointer(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
