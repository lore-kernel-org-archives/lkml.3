Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3DNQmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:42:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7826 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3DNQmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:42:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,471,1363104000"; 
   d="scan'208";a="7051545"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 4/8] workqueue: quit cm mode when sleeping
Date: Mon, 15 Apr 2013 00:41:52 +0800
Message-Id: <1365957716-7631-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:17,
	Serialize complete at 2013/04/15 00:41:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a work is waken up from sleeping, it makes very small sense if
we still consider this worker is RUNNING(in view of concurrency management)
o	if the work goes to sleep again, it is not RUNNING again.
o	if the work runs long without sleeping, the worker should be consider
	as CPU_INTENSIVE.
o	if the work runs short without sleeping, we can still consider
	this worker is not RUNNING this harmless short time,
	and fix it up before next work.

o	In almost all cases, the increasing nr_running does not increase
	nr_running from 0. there are other RUNNING workers, the other
	workers will not goto sleeping very probably before this worker
	finishes the work in may cases. this early increasing makes less
	sense.

So don't need consider this worker is RUNNING so early and
we can delay increasing nr_running a little. we increase it after
finished the work.

It is done by adding a new worker flag: WORKER_QUIT_CM.
it used for disabling increasing nr_running in wq_worker_waking_up(),
and for increasing nr_running after finished the work.

This change maybe cause we wakeup(or create) more workers in raw case,
but this is not incorrect.

It make the currency management much more simpler

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |   20 ++++++++++++++------
 kernel/workqueue_internal.h |    2 +-
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a4bc589..668e9b7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -75,11 +75,13 @@ enum {
 	WORKER_DIE		= 1 << 1,	/* die die die */
 	WORKER_IDLE		= 1 << 2,	/* is idle */
 	WORKER_PREP		= 1 << 3,	/* preparing to run works */
+	WORKER_QUIT_CM		= 1 << 4,	/* quit concurrency managed */
 	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
 	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */
 	WORKER_REBOUND		= 1 << 8,	/* worker was rebound */
 
-	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_CPU_INTENSIVE |
+	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_QUIT_CM |
+				  WORKER_CPU_INTENSIVE |
 				  WORKER_UNBOUND | WORKER_REBOUND,
 
 	NR_STD_WORKER_POOLS	= 2,		/* # standard pools per cpu */
@@ -122,6 +124,10 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
+ * LI: If POOL_DISASSOCIATED is NOT set, read/modification access should be
+ *     done with local IRQ-disabled and only from local cpu.
+ *     If POOL_DISASSOCIATED is set, it's identical to L.
+ *
  * MG: pool->manager_mutex and pool->lock protected.  Writes require both
  *     locks.  Reads can happen under either lock.
  *
@@ -843,11 +849,13 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task)
 	 * Please read comment there.
 	 *
 	 * NOT_RUNNING is clear.  This means that we're bound to and
-	 * running on the local cpu w/ rq lock held and preemption
+	 * running on the local cpu w/ rq lock held and preemption/irq
 	 * disabled, which in turn means that none else could be
 	 * manipulating idle_list, so dereferencing idle_list without pool
-	 * lock is safe.
+	 * lock is safe. And which in turn also means that we can
+	 * manipulating worker->flags.
 	 */
+	worker->flags |= WORKER_QUIT_CM;
 	if (atomic_dec_and_test(&pool->nr_running) &&
 	    !list_empty(&pool->worklist))
 		to_wakeup = first_worker(pool);
@@ -2160,9 +2168,9 @@ __acquires(&pool->lock)
 
 	spin_lock_irq(&pool->lock);
 
-	/* clear cpu intensive status if it is set */
-	if (unlikely(worker->flags & WORKER_CPU_INTENSIVE))
-		worker_clr_flags(worker, WORKER_CPU_INTENSIVE);
+	/* clear cpu intensive status or WORKER_QUIT_CM if they are set */
+	if (unlikely(worker->flags & (WORKER_CPU_INTENSIVE | WORKER_QUIT_CM)))
+		worker_clr_flags(worker, WORKER_CPU_INTENSIVE | WORKER_QUIT_CM);
 
 	/* we're done with it, release */
 	hash_del(&worker->hentry);
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index aec8df4..1713ae7 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -35,7 +35,7 @@ struct worker {
 						/* L: for rescuers */
 	/* 64 bytes boundary on 64bit, 32 on 32bit */
 	unsigned long		last_active;	/* L: last active timestamp */
-	unsigned int		flags;		/* X: flags */
+	unsigned int		flags;		/* LI: flags */
 	int			id;		/* I: worker id */
 
 	/* used only by rescuers to point to the target workqueue */
-- 
1.7.7.6

