Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3CKRiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:38:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab3CKRit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:38:49 -0400
Date: Mon, 11 Mar 2013 18:36:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kthread: kill task_get_live_kthread()
Message-ID: <20130311173646.GA13546@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311173625.GA13525@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_get_live_kthread() looks confusing and unneeded. It does
get_task_struct() but only kthread_stop() needs this, it can be
called even if the calller doesn't have a reference when we know
that this kthread can't exit until we do kthread_stop().

kthread_park() and kthread_unpark() do not need get_task_struct(),
the callers already have the reference. And it can not help if we
can race with the exiting kthread anyway, kthread_park() can hang
forever in this case.

Change kthread_park() and kthread_unpark() to use to_live_kthread(),
change kthread_stop() to do get_task_struct() by hand and remove
task_get_live_kthread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kthread.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index fa4a013..d345f4e 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -324,12 +324,6 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 	return p;
 }
 
-static struct kthread *task_get_live_kthread(struct task_struct *k)
-{
-	get_task_struct(k);
-	return to_live_kthread(k);
-}
-
 /**
  * kthread_unpark - unpark a thread created by kthread_create().
  * @k:		thread created by kthread_create().
@@ -340,7 +334,7 @@ static struct kthread *task_get_live_kthread(struct task_struct *k)
  */
 void kthread_unpark(struct task_struct *k)
 {
-	struct kthread *kthread = task_get_live_kthread(k);
+	struct kthread *kthread = to_live_kthread(k);
 
 	if (kthread) {
 		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
@@ -356,7 +350,6 @@ void kthread_unpark(struct task_struct *k)
 			wake_up_process(k);
 		}
 	}
-	put_task_struct(k);
 }
 
 /**
@@ -373,7 +366,7 @@ void kthread_unpark(struct task_struct *k)
  */
 int kthread_park(struct task_struct *k)
 {
-	struct kthread *kthread = task_get_live_kthread(k);
+	struct kthread *kthread = to_live_kthread(k);
 	int ret = -ENOSYS;
 
 	if (kthread) {
@@ -386,7 +379,6 @@ int kthread_park(struct task_struct *k)
 		}
 		ret = 0;
 	}
-	put_task_struct(k);
 	return ret;
 }
 
@@ -407,10 +399,13 @@ int kthread_park(struct task_struct *k)
  */
 int kthread_stop(struct task_struct *k)
 {
-	struct kthread *kthread = task_get_live_kthread(k);
+	struct kthread *kthread;
 	int ret;
 
 	trace_sched_kthread_stop(k);
+
+	get_task_struct(k);
+	kthread = to_live_kthread(k);
 	if (kthread) {
 		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
 		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
@@ -418,10 +413,9 @@ int kthread_stop(struct task_struct *k)
 		wait_for_completion(&kthread->exited);
 	}
 	ret = k->exit_code;
-
 	put_task_struct(k);
-	trace_sched_kthread_stop_ret(ret);
 
+	trace_sched_kthread_stop_ret(ret);
 	return ret;
 }
 EXPORT_SYMBOL(kthread_stop);
-- 
1.5.5.1

