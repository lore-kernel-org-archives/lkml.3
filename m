Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935140AbaKNBjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:39:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935045AbaKNBiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:38:11 -0500
Date: Fri, 14 Nov 2014 02:38:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rik van Riel <riel@redhat.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] exit: wait: don't use zombie->real_parent
Message-ID: <20141114013818.GA5119@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114013750.GA4697@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. wait_task_zombie() uses p->real_parent to get psig/siglock. This is
   correct but needs tasklist_lock, ->real_parent can exit.

   We can use "current" instead. This is our natural child, its parent
   must be our sub-thread.

2. Read psig/sig outside of ->siglock, ->signal is no longer protected
   by this lock.

3. Fix the outdated comments about tasklist_lock. We can not race with
   __exit_signal(), the whole thread group is dead, nobody but us can
   call it.

   Also clarify the usage of ->stats_lock and ->siglock.

Note: thread_group_cputime_adjusted() is sub-optimal in this case, we
probably want to export cputime_adjust() to avoid thread_group_cputime().
The comment says "all threads" but there are no other threads.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 0511f1d..40d53de 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1008,8 +1008,8 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	 * Check thread_group_leader() to exclude the traced sub-threads.
 	 */
 	if (state == EXIT_DEAD && thread_group_leader(p)) {
-		struct signal_struct *psig;
-		struct signal_struct *sig;
+		struct signal_struct *sig = p->signal;
+		struct signal_struct *psig = current->signal;
 		unsigned long maxrss;
 		cputime_t tgutime, tgstime;
 
@@ -1021,21 +1021,20 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 * accumulate in the parent's signal_struct c* fields.
 		 *
 		 * We don't bother to take a lock here to protect these
-		 * p->signal fields, because they are only touched by
-		 * __exit_signal, which runs with tasklist_lock
-		 * write-locked anyway, and so is excluded here.  We do
-		 * need to protect the access to parent->signal fields,
-		 * as other threads in the parent group can be right
-		 * here reaping other children at the same time.
+		 * p->signal fields because the whole thread group is dead
+		 * and nobody can change them.
+		 *
+		 * psig->stats_lock also protects us from our sub-theads
+		 * which can reap other children at the same time. Until
+		 * we change k_getrusage()-like users to rely on this lock
+		 * we have to take ->siglock as well.
 		 *
 		 * We use thread_group_cputime_adjusted() to get times for
 		 * the thread group, which consolidates times for all threads
 		 * in the group including the group leader.
 		 */
 		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
-		spin_lock_irq(&p->real_parent->sighand->siglock);
-		psig = p->real_parent->signal;
-		sig = p->signal;
+		spin_lock_irq(&current->sighand->siglock);
 		write_seqlock(&psig->stats_lock);
 		psig->cutime += tgutime + sig->cutime;
 		psig->cstime += tgstime + sig->cstime;
@@ -1060,7 +1059,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
 		write_sequnlock(&psig->stats_lock);
-		spin_unlock_irq(&p->real_parent->sighand->siglock);
+		spin_unlock_irq(&current->sighand->siglock);
 	}
 
 	/*
-- 
1.5.5.1

