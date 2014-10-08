Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaJHSgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:36:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaJHSgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:36:45 -0400
Date: Wed, 8 Oct 2014 20:33:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Kirill Tkhai <tkhai@yandex.ru>
Subject: [PATCH 1/2] sched: schedule_tail() should disable preemption
Message-ID: <20141008183326.GB17495@redhat.com>
References: <20141007195046.GA28002@redhat.com> <20141008080016.GB10832@worktop.programming.kicks-ass.net> <20141008183302.GA17495@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008183302.GA17495@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

finish_task_switch() enables preemption, so post_schedule(rq) can be
called on the wrong (and even dead) CPU. Afaics, nothing really bad
can happen, but in this case we can wrongly clear rq->post_schedule
on that CPU. And this simply looks wrong in any case.

Another problem is that finish_task_switch() itself runs with preempt
enabled after finish_lock_switch(). If nothing else this means that
->sched_in() notifier can't trust its "cpu" arg.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 703c7e6..3f267e8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2277,15 +2277,14 @@ static inline void post_schedule(struct rq *rq)
 asmlinkage __visible void schedule_tail(struct task_struct *prev)
 	__releases(rq->lock)
 {
-	struct rq *rq = this_rq();
+	struct rq *rq;
 
+	/* finish_task_switch() drops rq->lock and enables preemtion */
+	preempt_disable();
+	rq = this_rq();
 	finish_task_switch(rq, prev);
-
-	/*
-	 * FIXME: do we need to worry about rq being invalidated by the
-	 * task_switch?
-	 */
 	post_schedule(rq);
+	preempt_enable();
 
 	if (current->set_child_tid)
 		put_user(task_pid_vnr(current), current->set_child_tid);
-- 
1.5.5.1


