Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaJ1LG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:06:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51059 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaJ1LGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:06:54 -0400
Date: Tue, 28 Oct 2014 04:06:00 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-1a43a14a5bd9c32dbd7af35e35a5afa703944bcb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tkhai@yandex.ru, rostedt@goodmis.org,
        torvalds@linux-foundation.org, mingo@kernel.org, hpa@zytor.com,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
Reply-To: oleg@redhat.com, hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de,
        peterz@infradead.org, tkhai@yandex.ru, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
In-Reply-To: <20141008193644.GA32055@redhat.com>
References: <20141008193644.GA32055@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix schedule_tail() to disable preemption
Git-Commit-ID: 1a43a14a5bd9c32dbd7af35e35a5afa703944bcb
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

Commit-ID:  1a43a14a5bd9c32dbd7af35e35a5afa703944bcb
Gitweb:     http://git.kernel.org/tip/1a43a14a5bd9c32dbd7af35e35a5afa703944bcb
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 8 Oct 2014 21:36:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:54 +0100

sched: Fix schedule_tail() to disable preemption

finish_task_switch() enables preemption, so post_schedule(rq) can be
called on the wrong (and even dead) CPU. Afaics, nothing really bad
can happen, but in this case we can wrongly clear rq->post_schedule
on that CPU. And this simply looks wrong in any case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141008193644.GA32055@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cde8481..b493560 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2309,15 +2309,14 @@ static inline void post_schedule(struct rq *rq)
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
