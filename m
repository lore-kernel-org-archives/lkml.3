Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936351Ab3DIOii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:38:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:46868 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936233Ab3DIOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:38:37 -0400
Date: Tue, 9 Apr 2013 16:38:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] kthread: Prevent unpark race which puts threads on the wrong
 cpu
In-Reply-To: <alpine.LFD.2.02.1304081415570.21884@ionos>
Message-ID: <alpine.LFD.2.02.1304091635430.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smpboot threads rely on the park/unpark mechanism which binds per
cpu threads on a particular core. Though the functionality is racy:

CPU0	       	 	CPU1  	     	    CPU2
unpark(T)				    wake_up_process(T)
  clear(SHOULD_PARK)	T runs
			leave parkme() due to !SHOULD_PARK  
  bind_to(CPU2)		BUG_ON(wrong CPU)						    

We cannot let the tasks move themself to the target CPU as one of
those tasks is actually the migration thread itself, which requires
that it starts running on the target cpu right away.

The only rock solid solution to this problem is to prevent wakeups in
park state which are not from unpark(). That way we can guarantee that
the association of the task to the target cpu is working correctly.

Add a new task state (TASK_PARKED) which prevents other wakeups and
use this state explicitely for the unpark wakeup.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Dave Hansen <dave@sr71.net>
Reported-by: Borislav Petkov <bp@alien8.de>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/array.c       |    1 +
 include/linux/sched.h |    5 +++--
 kernel/kthread.c      |   38 +++++++++++++++++++++-----------------
 3 files changed, 25 insertions(+), 19 deletions(-)

Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c
+++ linux-2.6/fs/proc/array.c
@@ -143,6 +143,7 @@ static const char * const task_state_arr
 	"x (dead)",		/*  64 */
 	"K (wakekill)",		/* 128 */
 	"W (waking)",		/* 256 */
+	"P (parked)",		/* 512 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -163,9 +163,10 @@ print_cfs_rq(struct seq_file *m, int cpu
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
Index: linux-2.6/kernel/kthread.c
===================================================================
--- linux-2.6.orig/kernel/kthread.c
+++ linux-2.6/kernel/kthread.c
@@ -124,12 +124,12 @@ void *kthread_data(struct task_struct *t
 
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
@@ -324,6 +324,22 @@ static struct kthread *task_get_live_kth
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
+			__kthread_bind(k, kthread->cpu);
+		wake_up_state(k, TASK_PARKED);
+	}
+}
+
 /**
  * kthread_unpark - unpark a thread created by kthread_create().
  * @k:		thread created by kthread_create().
@@ -336,20 +352,8 @@ void kthread_unpark(struct task_struct *
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
