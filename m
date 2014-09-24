Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaIXPHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:07:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaIXO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:56:28 -0400
Date: Wed, 24 Sep 2014 07:54:55 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-a5e7be3b28a235108c59561bea55eea1072b23b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luca.abeni@unitn.it, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        daniel.wagner@bmw-carit.de, daniele.alessandrelli@gmail.com,
        raistlin@linux.it, fchecconi@gmail.com, vincent@legout.info,
        juri.lelli@arm.com, michael@amarulasolutions.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        daniel.wagner@bmw-carit.de, peterz@infradead.org,
        daniele.alessandrelli@gmail.com, raistlin@linux.it,
        fchecconi@gmail.com, vincent@legout.info, juri.lelli@arm.com,
        tglx@linutronix.de, michael@amarulasolutions.com
In-Reply-To: <1411118561-26323-2-git-send-email-juri.lelli@arm.com>
References: <1411118561-26323-2-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Clear dl_entity params when setscheduling to different class
Git-Commit-ID: a5e7be3b28a235108c59561bea55eea1072b23b0
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

Commit-ID:  a5e7be3b28a235108c59561bea55eea1072b23b0
Gitweb:     http://git.kernel.org/tip/a5e7be3b28a235108c59561bea55eea1072b23b0
Author:     Juri Lelli <juri.lelli@arm.com>
AuthorDate: Fri, 19 Sep 2014 10:22:39 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:46:56 +0200

sched/deadline: Clear dl_entity params when setscheduling to different class

When a task is using SCHED_DEADLINE and the user setschedules it to a
different class its sched_dl_entity static parameters are not cleaned
up. This causes a bug if the user sets it back to SCHED_DEADLINE with
the same parameters again.  The problem resides in the check we
perform at the very beginning of dl_overflow():

	if (new_bw == p->dl.dl_bw)
		return 0;

This condition is met in the case depicted above, so the function
returns and dl_b->total_bw is not updated (the p->dl.dl_bw is not
added to it). After this, admission control is broken.

This patch fixes the thing, properly clearing static parameters for a
task that ceases to use SCHED_DEADLINE.

Reported-by: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Reported-by: Vincent Legout <vincent@legout.info>
Tested-by: Luca Abeni <luca.abeni@unitn.it>
Tested-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Tested-by: Vincent Legout <vincent@legout.info>
Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Fabio Checconi <fchecconi@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <michael@amarulasolutions.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1411118561-26323-2-git-send-email-juri.lelli@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c     | 19 +++++++++++++++----
 kernel/sched/deadline.c |  2 ++
 kernel/sched/sched.h    |  3 +++
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a284190..09bde2a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1809,6 +1809,20 @@ int wake_up_state(struct task_struct *p, unsigned int state)
 }
 
 /*
+ * This function clears the sched_dl_entity static params.
+ */
+void __dl_clear_params(struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	dl_se->dl_runtime = 0;
+	dl_se->dl_deadline = 0;
+	dl_se->dl_period = 0;
+	dl_se->flags = 0;
+	dl_se->dl_bw = 0;
+}
+
+/*
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
  *
@@ -1832,10 +1846,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	RB_CLEAR_NODE(&p->dl.rb_node);
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	p->dl.dl_runtime = p->dl.runtime = 0;
-	p->dl.dl_deadline = p->dl.deadline = 0;
-	p->dl.dl_period = 0;
-	p->dl.flags = 0;
+	__dl_clear_params(p);
 
 	INIT_LIST_HEAD(&p->rt.run_list);
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index aaa5abb..efb9412 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1565,6 +1565,8 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	if (hrtimer_active(&p->dl.dl_timer) && !dl_policy(p->policy))
 		hrtimer_try_to_cancel(&p->dl.dl_timer);
 
+	__dl_clear_params(p);
+
 #ifdef CONFIG_SMP
 	/*
 	 * Since this might be the only -deadline task on the rq,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bc6aad..76f3a38 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -130,6 +130,9 @@ struct rt_bandwidth {
 	u64			rt_runtime;
 	struct hrtimer		rt_period_timer;
 };
+
+void __dl_clear_params(struct task_struct *p);
+
 /*
  * To keep the bandwidth of -deadline tasks and groups under control
  * we need some place where:
