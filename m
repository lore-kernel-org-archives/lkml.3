Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaIXO5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:57:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaIXO5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:57:17 -0400
Date: Wed, 24 Sep 2014 07:56:22 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-5bd96ab6fef66ec6b9f54134364e618fd0f8f2f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, tkhai@yandex.ru, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, tkhai@yandex.ru, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20140921193341.GA28628@redhat.com>
References: <20140921193341.GA28628@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: print_rq(): Don't use tasklist_lock
Git-Commit-ID: 5bd96ab6fef66ec6b9f54134364e618fd0f8f2f3
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

Commit-ID:  5bd96ab6fef66ec6b9f54134364e618fd0f8f2f3
Gitweb:     http://git.kernel.org/tip/5bd96ab6fef66ec6b9f54134364e618fd0f8f2f3
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 21 Sep 2014 21:33:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:47:04 +0200

sched: print_rq(): Don't use tasklist_lock

read_lock_irqsave(tasklist_lock) in print_rq() looks strange. We do
not need to disable irqs, and they are already disabled by the caller.

And afaics this lock buys nothing, we can rely on rcu_read_lock().
In this case it makes sense to also move rcu_read_lock/unlock from
the caller to print_rq().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140921193341.GA28628@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index c7fe1ea0..ce33780 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -150,7 +150,6 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 {
 	struct task_struct *g, *p;
-	unsigned long flags;
 
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
@@ -159,14 +158,14 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	"------------------------------------------------------"
 	"----------------------------------------------------\n");
 
-	read_lock_irqsave(&tasklist_lock, flags);
+	rcu_read_lock();
 	for_each_process_thread(g, p) {
 		if (task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
 	}
-	read_unlock_irqrestore(&tasklist_lock, flags);
+	rcu_read_unlock();
 }
 
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
@@ -331,9 +330,7 @@ do {									\
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
 
-	rcu_read_lock();
 	print_rq(m, rq, cpu);
-	rcu_read_unlock();
 	spin_unlock_irqrestore(&sched_debug_lock, flags);
 	SEQ_printf(m, "\n");
 }
