Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3IILBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:01:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48053 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab3IILBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:01:47 -0400
Date: Mon, 9 Sep 2013 13:01:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Emmanuel Deloget <emmanuel.deloget@efixo.com>
Cc: "[ML] linux-kernel" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: /proc/$PID/sched does not take PID namespace into account
Message-ID: <20130909110141.GM31370@twins.programming.kicks-ass.net>
References: <5225F0A9.5040100@efixo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5225F0A9.5040100@efixo.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 04:22:33PM +0200, Emmanuel Deloget wrote:
> The issue (if this is really an issue) lies in kernel/sched/debug.c,
> function proc_sched_show_task(). The code says [1]:
> 
>     SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid,
>                         get_nr_threads(p));
> 

> I see a few options:
> 
> * either it's a bug and it should be corrected (I'm not sure how to
>   do it; the printed PID should reflect the current PID namespace
>   and I don't how how to get this information).

I suppose something like the below ought to work? -- completely
untested, please confirm.

---
Subject: sched, debug: Use PID namespaces

Emmanuel reported that /proc/sched_debug didn't report the right PIDs
when using namespaces, cure this.

Reported-by: Emmanuel Deloget <emmanuel.deloget@efixo.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e076bdd..e30bf44 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -124,7 +124,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 		SEQ_printf(m, " ");
 
 	SEQ_printf(m, "%15s %5d %9Ld.%06ld %9Ld %5d ",
-		p->comm, p->pid,
+		p->comm, task_pid(p),,
 		SPLIT_NS(p->se.vruntime),
 		(long long)(p->nvcsw + p->nivcsw),
 		p->prio);
@@ -289,7 +289,7 @@ do {									\
 	P(nr_load_updates);
 	P(nr_uninterruptible);
 	PN(next_balance);
-	P(curr->pid);
+	P(task_pid(curr));
 	PN(clock);
 	P(cpu_load[0]);
 	P(cpu_load[1]);
@@ -492,7 +492,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 {
 	unsigned long nr_switches;
 
-	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid,
+	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, task_pid(p),
 						get_nr_threads(p));
 	SEQ_printf(m,
 		"---------------------------------------------------------"
