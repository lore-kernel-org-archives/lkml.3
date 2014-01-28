Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaA1IGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:06:53 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41005 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaA1IGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:06:51 -0500
Message-ID: <1390895840.8373.2.camel@beeld>
Subject: Do we really need curr_target in signal_struct ?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Date: Tue, 28 Jan 2014 13:57:20 +0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering what might be the possible use of curr_target in signal_struct (atleast,
it's not doing what it's comment says). Also, I'm not seeing any real use of it except
in kernel/signal.c::complete_signal() where it's use as loop breaking condition in thread's
list traversing. As an alternative of using curr_target we can use get_nr_thread() count
to get # of threads in a group and can remove curr_target completely. This will also help
us to get rid from overhead of maintaining ->curr_target at fork()/exit() path. Below is
rough patch, I can prepare a good one if everyone agrees.

Or we really need it?

---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 485234d..1fd65b7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -554,7 +554,7 @@ struct signal_struct {
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
 
 	/* current thread group signal load-balancing target: */
-	struct task_struct	*curr_target;
+	//struct task_struct	*curr_target;
 
 	/* shared signal handling: */
 	struct sigpending	shared_pending;
diff --git a/kernel/exit.c b/kernel/exit.c
index 1e77fc6..4a2cf37 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -113,8 +113,8 @@ static void __exit_signal(struct task_struct *tsk)
 		if (sig->notify_count > 0 && !--sig->notify_count)
 			wake_up_process(sig->group_exit_task);
 
-		if (tsk == sig->curr_target)
-			sig->curr_target = next_thread(tsk);
+		//if (tsk == sig->curr_target)
+		//	sig->curr_target = next_thread(tsk);
 		/*
 		 * Accumulate here the counters for all threads but the
 		 * group leader as they die, so they can be added into
diff --git a/kernel/fork.c b/kernel/fork.c
index 2f11bbe..8de4928 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1041,7 +1041,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	tsk->thread_node = (struct list_head)LIST_HEAD_INIT(sig->thread_head);
 
 	init_waitqueue_head(&sig->wait_chldexit);
-	sig->curr_target = tsk;
+	//sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 940b30e..1a1280a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -945,6 +945,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
+	int i;
 
 	/*
 	 * Now find a thread we can wake up to take the signal off the queue.
@@ -961,21 +962,16 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 		 */
 		return;
 	else {
-		/*
-		 * Otherwise try to find a suitable thread.
-		 */
-		t = signal->curr_target;
-		while (!wants_signal(sig, t)) {
+		i = get_nr_threads(p);
+		t = p;
+		do {
+			--i;
 			t = next_thread(t);
-			if (t == signal->curr_target)
-				/*
-				 * No thread needs to be woken.
-				 * Any eligible threads will see
-				 * the signal in the queue soon.
-				 */
+			if (!i)
 				return;
-		}
-		signal->curr_target = t;
+		} while (!wants_signal(sig, t));
+	
+		//signal->curr_target = t;
 	}
 
 	/*


