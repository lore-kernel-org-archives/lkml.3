Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaHQP3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaHQP3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:29:06 -0400
Date: Sun, 17 Aug 2014 17:26:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        linux-kernel@vger.kernel.org, Kirill Tkhai <tkhai@yandex.ru>
Subject: [PATCH 2/2] sched: print_rq: don't use tasklist_lock
Message-ID: <20140817152637.GC17984@redhat.com>
References: <20140813191938.GA19301@redhat.com> <20140817152549.GA17984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817152549.GA17984@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_lock_irqsave(tasklist_lock) in print_rq() looks strange. We do
not need to disable irqs, and they are already disabled by the caller.

And afaics this lock buys nothing, we can rely on rcu_read_lock().
In this case it makes sense to also move rcu_read_lock/unlock from
the caller to print_rq().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/debug.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index c7fe1ea..ce33780 100644
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
-- 
1.5.5.1


