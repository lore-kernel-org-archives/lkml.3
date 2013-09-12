Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3ILSF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:05:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3ILSFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:05:47 -0400
Date: Thu, 12 Sep 2013 11:05:05 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-fc840914e9b07ab4685c195e1e54e58de4f84c03@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, emmanuel.deloget@efixo.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, emmanuel.deloget@efixo.com
In-Reply-To: <20130909110141.GM31370@twins.programming.kicks-ass.net>
References: <20130909110141.GM31370@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/debug: Take PID namespace into account
Git-Commit-ID: fc840914e9b07ab4685c195e1e54e58de4f84c03
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:05:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc840914e9b07ab4685c195e1e54e58de4f84c03
Gitweb:     http://git.kernel.org/tip/fc840914e9b07ab4685c195e1e54e58de4f84c03
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 9 Sep 2013 13:01:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:14:16 +0200

sched/debug: Take PID namespace into account

Emmanuel reported that /proc/sched_debug didn't report the right PIDs
when using namespaces, cure this.

Reported-by: Emmanuel Deloget <emmanuel.deloget@efixo.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130909110141.GM31370@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e076bdd..1965599 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -124,7 +124,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 		SEQ_printf(m, " ");
 
 	SEQ_printf(m, "%15s %5d %9Ld.%06ld %9Ld %5d ",
-		p->comm, p->pid,
+		p->comm, task_pid_nr(p),
 		SPLIT_NS(p->se.vruntime),
 		(long long)(p->nvcsw + p->nivcsw),
 		p->prio);
@@ -289,7 +289,7 @@ do {									\
 	P(nr_load_updates);
 	P(nr_uninterruptible);
 	PN(next_balance);
-	P(curr->pid);
+	SEQ_printf(m, "  .%-30s: %ld\n", "curr->pid", (long)(task_pid_nr(rq->curr)));
 	PN(clock);
 	P(cpu_load[0]);
 	P(cpu_load[1]);
@@ -492,7 +492,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 {
 	unsigned long nr_switches;
 
-	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid,
+	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, task_pid_nr(p),
 						get_nr_threads(p));
 	SEQ_printf(m,
 		"---------------------------------------------------------"
