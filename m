Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaFEOek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:34:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48272 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFEOeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:34:36 -0400
Date: Thu, 5 Jun 2014 07:33:25 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-e9dd685ce81815811fb4da72e6ab10a694ac8468@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        eric.dumazet@gmail.com, torvalds@linux-foundation.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, torvalds@linux-foundation.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <20140527182541.GH11096@twins.programming.kicks-ass.net>
References: <20140527182541.GH11096@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/numa: Fix use of spin_{un}lock_irq()
  when interrupts are disabled
Git-Commit-ID: e9dd685ce81815811fb4da72e6ab10a694ac8468
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

Commit-ID:  e9dd685ce81815811fb4da72e6ab10a694ac8468
Gitweb:     http://git.kernel.org/tip/e9dd685ce81815811fb4da72e6ab10a694ac8468
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Tue, 27 May 2014 17:02:04 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:07:41 +0200

sched/numa: Fix use of spin_{un}lock_irq() when interrupts are disabled

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner<tglx@linutronix.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140527182541.GH11096@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0fdb96d..b4768c0 100644
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
