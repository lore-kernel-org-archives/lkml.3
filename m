Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaKWWE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 17:04:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:35306 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaKWWE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 17:04:57 -0500
Date: Sun, 23 Nov 2014 23:04:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Mason <clm@fb.com>
cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: Provide update_curr callbacks for stop/idle scheduling
 classes
In-Reply-To: <1416778927.3019.1@mail.thefacebook.com>
Message-ID: <alpine.DEB.2.11.1411232247520.6439@nanos>
References: <20141123010239.GA12691@ret.masoncoding.com> <1416758187.24312.12@mail.thefacebook.com> <20141123161120.GB7070@pd.tnic> <1416759411.24312.13@mail.thefacebook.com> <20141123163258.GB6436@pd.tnic> <1416761342.24312.15@mail.thefacebook.com>
 <alpine.DEB.2.11.1411232141590.6439@nanos> <1416777079.1732.0@mail.thefacebook.com> <alpine.DEB.2.11.1411232235591.6439@nanos> <1416778927.3019.1@mail.thefacebook.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris bisected a NULL pointer deference in task_sched_runtime() to
commit 6e998916dfe3 'sched/cputime: Fix clock_nanosleep()/clock_gettime()
inconsistency'.

Chris observed crashes in atop or other /proc walking programs when he
started fork bombs on his machine. He assumed that this is a new exit
race, but that does not make any sense when looking at that commit.

What's interesting is that, the commit provides update_curr callbacks
for all scheduling classes except stop_task and idle_task.

While nothing can ever hit that via the clock_nanosleep() and
clock_gettime() interfaces, which have been the target of the commit
in question, the author obviously forgot, that there are other code
pathes which invoke task_sched_runtime()

do_task_stat(()
 thread_group_cputime_adjusted()
   thread_group_cputime()
     task_cputime()
       task_sched_runtime()
        if (task_current(rq, p) && task_on_rq_queued(p)) {
          update_rq_clock(rq);
          up->sched_class->update_curr(rq);
        }

If the stats are read for a stomp machine task, aka 'migration/N' and
that task is current on its cpu, this will happily call the NULL
pointer of stop_task->update_curr. Ooops.

Chris observation that this happens faster when he runs the fork bomb
makes sense as the fork bomb will kick migration threads more often so
the probability to hit the issue will increase.

Add the missing update_curr callbacks to the scheduler classes
stop_task and idle_task. While idle tasks cannot be monitored via
/proc we have other means to hit the idle case.

Fixes: 6e998916dfe3 'sched/cputime: Fix clock_nanosleep()/clock_gettime() inconsistency'
Reported-by: Chris Mason <clm@fb.com>
Reported-and-tested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 67ad4e7f506a..c65dac8c97cd 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -75,6 +75,10 @@ static unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task
 	return 0;
 }
 
+static void update_curr_idle(struct rq *rq)
+{
+}
+
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
@@ -101,4 +105,5 @@ const struct sched_class idle_sched_class = {
 
 	.prio_changed		= prio_changed_idle,
 	.switched_to		= switched_to_idle,
+	.update_curr		= update_curr_idle,
 };
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 67426e529f59..79ffec45a6ac 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -102,6 +102,10 @@ get_rr_interval_stop(struct rq *rq, struct task_struct *task)
 	return 0;
 }
 
+static void update_curr_stop(struct rq *rq)
+{
+}
+
 /*
  * Simple, special scheduling class for the per-CPU stop tasks:
  */
@@ -128,4 +132,5 @@ const struct sched_class stop_sched_class = {
 
 	.prio_changed		= prio_changed_stop,
 	.switched_to		= switched_to_stop,
+	.update_curr		= update_curr_stop,
 };
