Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaBUVcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:32:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59331 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaBUVct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:32:49 -0500
Date: Fri, 21 Feb 2014 13:32:13 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-410dcf7b5670c224f5bb3179b62642b7182e3486@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        bigeasy@linutronix.de
In-Reply-To: <1391803122-4425-6-git-send-email-bigeasy@linutronix.de>
References: <1391803122-4425-6-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Queue RT tasks to head when prio drops
Git-Commit-ID: 410dcf7b5670c224f5bb3179b62642b7182e3486
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

Commit-ID:  410dcf7b5670c224f5bb3179b62642b7182e3486
Gitweb:     http://git.kernel.org/tip/410dcf7b5670c224f5bb3179b62642b7182e3486
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 7 Feb 2014 20:58:41 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:19 +0100

sched: Queue RT tasks to head when prio drops

The following scenario does not work correctly:

Runqueue of CPUx contains two runnable and pinned tasks:
 T1: SCHED_FIFO, prio 80
 T2: SCHED_FIFO, prio 80

T1 is on the cpu and executes the following syscalls (classic priority
ceiling scenario):

 sys_sched_setscheduler(pid(T1), SCHED_FIFO, .prio = 90);
 ...
 sys_sched_setscheduler(pid(T1), SCHED_FIFO, .prio = 80);
 ...

Now T1 gets preempted by T3 (SCHED_FIFO, prio 95). After T3 goes back
to sleep the scheduler picks T2. Surprise!

The same happens w/o actual preemption when T1 is forced into the
scheduler due to a sporadic NEED_RESCHED event. The scheduler invokes
pick_next_task() which returns T2. So T1 gets preempted and scheduled
out.

This happens because sched_setscheduler() dequeues T1 from the prio 90
list and then enqueues it on the tail of the prio 80 list behind T2.
This violates the POSIX spec and surprises user space which relies on
the guarantee that SCHED_FIFO tasks are not scheduled out unless they
give the CPU up voluntarily or are preempted by a higher priority
task. In the latter case the preempted task must get back on the CPU
after the preempting task schedules out again.

We fixed a similar issue already in commit 60db48c (sched: Queue a
deboosted task to the head of the RT prio queue). The same treatment
is necessary for sched_setscheduler(). So enqueue to head of the prio
bucket list if the priority of the task is lowered.

It might be possible that existing user space relies on the current
behaviour, but it can be considered highly unlikely due to the corner
case nature of the application scenario.

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1391803122-4425-6-git-send-email-bigeasy@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7527e68..a41d239 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3450,8 +3450,13 @@ change:
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq)
-		enqueue_task(rq, p, 0);
+	if (on_rq) {
+		/*
+		 * We enqueue to tail when the priority of a task is
+		 * increased (user space view).
+		 */
+		enqueue_task(rq, p, oldprio <= p->prio ? ENQUEUE_HEAD : 0);
+	}
 
 	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, p, &flags);
