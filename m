Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3DOMQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:16:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:56171 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3DOMQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:16:17 -0400
Date: Mon, 15 Apr 2013 14:16:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] core fixes for 3.9
Message-ID: <alpine.LFD.2.02.1304151414341.21884@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

* A single bugfix which plugs two race confitions which can cause
  hotplug per cpu threads to end up on the wrong cpu.

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      kthread: Prevent unpark race which puts threads on the wrong cpu


 fs/proc/array.c              |    1 +
 include/linux/sched.h        |    5 ++-
 include/trace/events/sched.h |    2 +-
 kernel/kthread.c             |   52 ++++++++++++++++++++++-------------------
 kernel/smpboot.c             |   14 +++++++++-
 5 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index f7ed9ee..cbd0f1b 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -143,6 +143,7 @@ static const char * const task_state_array[] = {
 	"x (dead)",		/*  64 */
 	"K (wakekill)",		/* 128 */
 	"W (waking)",		/* 256 */
+	"P (parked)",		/* 512 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..e692a02 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -163,9 +163,10 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #define TASK_DEAD		64
 #define TASK_WAKEKILL		128
 #define TASK_WAKING		256
-#define TASK_STATE_MAX		512
+#define TASK_PARKED		512
+#define TASK_STATE_MAX		1024
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKWP"
 
 extern char ___assert_task_state[1 - 2*!!(
 		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 5a8671e..e5586ca 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -147,7 +147,7 @@ TRACE_EVENT(sched_switch,
 		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
 				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
-				{ 128, "W" }) : "R",
+				{ 128, "K" }, { 256, "W" }, { 512, "P" }) : "R",
 		__entry->prev_state & TASK_STATE_MAX ? "+" : "",
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 691dc2e..9eb7fed 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -124,12 +124,12 @@ void *kthread_data(struct task_struct *task)
 
 static void __kthread_parkme(struct kthread *self)
 {
-	__set_current_state(TASK_INTERRUPTIBLE);
+	__set_current_state(TASK_PARKED);
 	while (test_bit(KTHREAD_SHOULD_PARK, &self->flags)) {
 		if (!test_and_set_bit(KTHREAD_IS_PARKED, &self->flags))
 			complete(&self->parked);
 		schedule();
-		__set_current_state(TASK_INTERRUPTIBLE);
+		__set_current_state(TASK_PARKED);
 	}
 	clear_bit(KTHREAD_IS_PARKED, &self->flags);
 	__set_current_state(TASK_RUNNING);
@@ -256,8 +256,13 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 }
 EXPORT_SYMBOL(kthread_create_on_node);
 
-static void __kthread_bind(struct task_struct *p, unsigned int cpu)
+static void __kthread_bind(struct task_struct *p, unsigned int cpu, long state)
 {
+	/* Must have done schedule() in kthread() before we set_task_cpu */
+	if (!wait_task_inactive(p, state)) {
+		WARN_ON(1);
+		return;
+	}
 	/* It's safe because the task is inactive. */
 	do_set_cpus_allowed(p, cpumask_of(cpu));
 	p->flags |= PF_THREAD_BOUND;
@@ -274,12 +279,7 @@ static void __kthread_bind(struct task_struct *p, unsigned int cpu)
  */
 void kthread_bind(struct task_struct *p, unsigned int cpu)
 {
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
-		WARN_ON(1);
-		return;
-	}
-	__kthread_bind(p, cpu);
+	__kthread_bind(p, cpu, TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(kthread_bind);
 
@@ -324,6 +324,22 @@ static struct kthread *task_get_live_kthread(struct task_struct *k)
 	return NULL;
 }
 
+static void __kthread_unpark(struct task_struct *k, struct kthread *kthread)
+{
+	clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
+	/*
+	 * We clear the IS_PARKED bit here as we don't wait
+	 * until the task has left the park code. So if we'd
+	 * park before that happens we'd see the IS_PARKED bit
+	 * which might be about to be cleared.
+	 */
+	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
+		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
+			__kthread_bind(k, kthread->cpu, TASK_PARKED);
+		wake_up_state(k, TASK_PARKED);
+	}
+}
+
 /**
  * kthread_unpark - unpark a thread created by kthread_create().
  * @k:		thread created by kthread_create().
@@ -336,20 +352,8 @@ void kthread_unpark(struct task_struct *k)
 {
 	struct kthread *kthread = task_get_live_kthread(k);
 
-	if (kthread) {
-		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
-		/*
-		 * We clear the IS_PARKED bit here as we don't wait
-		 * until the task has left the park code. So if we'd
-		 * park before that happens we'd see the IS_PARKED bit
-		 * which might be about to be cleared.
-		 */
-		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
-			if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
-				__kthread_bind(k, kthread->cpu);
-			wake_up_process(k);
-		}
-	}
+	if (kthread)
+		__kthread_unpark(k, kthread);
 	put_task_struct(k);
 }
 
@@ -407,7 +411,7 @@ int kthread_stop(struct task_struct *k)
 	trace_sched_kthread_stop(k);
 	if (kthread) {
 		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
-		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
+		__kthread_unpark(k, kthread);
 		wake_up_process(k);
 		wait_for_completion(&kthread->exited);
 	}
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 8eaed9a..02fc5c9 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -185,8 +185,18 @@ __smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
 	}
 	get_task_struct(tsk);
 	*per_cpu_ptr(ht->store, cpu) = tsk;
-	if (ht->create)
-		ht->create(cpu);
+	if (ht->create) {
+		/*
+		 * Make sure that the task has actually scheduled out
+		 * into park position, before calling the create
+		 * callback. At least the migration thread callback
+		 * requires that the task is off the runqueue.
+		 */
+		if (!wait_task_inactive(tsk, TASK_PARKED))
+			WARN_ON(1);
+		else
+			ht->create(cpu);
+	}
 	return 0;
 }
 
