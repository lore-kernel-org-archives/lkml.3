Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaLWSBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:01:55 -0500
Received: from www.osadl.org ([62.245.132.105]:33800 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaLWSBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:01:51 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Dec 2014 13:01:49 EST
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 1/2] doc: brief user documentation for completion
Date: Tue, 23 Dec 2014 18:02:12 +0100
Message-Id: <1419354133-19719-2-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1419354133-19719-1-git-send-email-der.herr@hofr.at>
References: <1419354133-19719-1-git-send-email-der.herr@hofr.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch is against 3.18.0 linux-next

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 Documentation/scheduler/completion.txt |  198 ++++++++++++++++++++++++++++++++
 1 file changed, 198 insertions(+)
 create mode 100644 Documentation/scheduler/completion.txt

diff --git a/Documentation/scheduler/completion.txt b/Documentation/scheduler/completion.txt
new file mode 100644
index 0000000..3d78cd6
--- /dev/null
+++ b/Documentation/scheduler/completion.txt
@@ -0,0 +1,198 @@
+completion - wait for completion handler
+========================================
+
+Origin: Linus Torvalds, kernel 2.4.7, 2001
+Location: kernel/sched/completion.c
+	include/linux/completion.h
+Users: all subsystems - mostly wait_for_completion and
+	wait_for_completion_timeout is in use.
+
+This document was originally written based on 3.18.0
+
+Introduction:
+=============
+
+Completion is a code synchronization mechanism that is preferable to mis-
+using of locks - semantically they are somewhat like a pthread_barrier. If
+you have one or more threads of execution that must wait for some process
+to have reached a point or a specific state, completions can provide a race
+free solution to this problem.
+
+Completion is built on top of the generic event infrastructure in Linux,
+with the event reduced to a simple flag appropriately called "done" in
+struct completion, that tells the waiting threads of execution that they
+can continue safely.
+
+For details on completion design and implementation see completion-design.txt
+
+Usage:
+======
+
+Basically there are three parts to the API, the initialization of the
+completion, the waiting part through a call to a variant of
+wait_to_completion and the signaling side through a call to complete()
+or complete_all().
+
+To use completions one needs to including <linux/completion.h> and
+creating a variable of type struct completion. The structure used for
+handling of completion is:
+
+	struct completion {
+		unsigned int done;
+		wait_queue_head_t wait;
+	};
+
+providing the wait queue to place tasks on for waiting and the flag for
+indicating the state of affairs.
+
+Completions should be named to convey the intent of the waiter.  A good
+example is:
+
+	wait_for_completion(&early_console_added);
+
+	complete(&early_console_added);
+
+good naming (as always) helps code readability.
+
+
+init_completion:
+----------------
+
+Initialization is accomplished by init_completion() for dynamic
+initialization. It initializes the wait-queue and sets the default state
+to "not available", that is, "done" is set to 0.
+
+The reinitialization reinit_completion(), simply resets the done element
+to "not available", thus again to 0, without touching the wait-queue.
+
+declaration and initialization macros available are:
+
+	static DECLARE_COMPLETION(setup_done)
+
+used for static declarations in file scope - probably NOT what you want to
+use - instead use:
+
+	DECLARE_COMPLETION_ONSTACK(setup_done)
+
+used for automatic/local variables on the stack and will make lockdep happy.
+
+
+wait_for_completion:
+--------------------
+
+For a thread of execution to wait on some other thread to reach some
+preparatory action to reach completion, this is achieved by passing the
+completion event to wait_for_completion():
+
+	wait_for_completion(struct completion *done):
+
+The default behavior is to wait without a timeout and mark the task as
+uninterruptible.
+
+
+Variants available are:
+
+	wait_for_completion_interruptible(struct completion *done)
+
+marking the task TASK_INTERRUPTIBLE.
+
+	wait_for_completion_timeout(struct completion *done,
+		unsigned long timeout)
+
+passing a timeout in jiffies and marking the task as TASK_UNINTERRUPTIBLE.
+
+	wait_for_completion_interruptible_timeout(struct completion *done,
+		unsigned long timeout)
+
+passing a timeout in jiffies and marking the task as TASK_INTERRUPTIBLE.
+
+Further variants include _killable which passes TASK_KILLABLE as the
+designated tasks state and will return a -ERESTARTSYS if interrupted or
+else 0 if completion was achieved.
+
+
+	wait_for_completion_killable(struct completion *done)
+	wait_for_completion_killable_timeout(struct completion *done,
+		unsigned long timeout)
+
+The _io variants wait_for_completion_io behave the same as the non-_io
+variants, except for accounting its waiting time as waiting on IO.
+
+	wait_for_completion_io(struct completion *done)
+	wait_for_completion_io_timeout(struct completion *done
+		unsigned long timeout)
+
+complete:
+---------
+
+A thread of execution that wants to signal that the conditions for
+continuation have been achieved calls complete() to signal exactly one
+of the waiters that it can continue
+
+	complete(struct completion *done)
+
+or calls complete_all to signal all current and future waiters.
+
+	complete_all(struct completion *done)
+
+The signaling will work as expected even if completion is signaled before
+a thread starts waiting. This is achieved by the waiter "consuming"
+(decrementing) the done element of struct completion.
+
+If complete() is called multiple times then this will allow for that number
+of waiters to continue - each call to complete() will simply increment the
+done element. Calling complete_all() multiple times is a bug though.
+
+
+try_wait_for_completion()/completion_done():
+--------------------------------------------
+
+The try_wait_for_completion will not put the thread on the wait-queue but
+rather returns 0 if it would need to enqueue (block) the thread, else it
+consumes any posted completion and returns.
+
+	try_wait_for_completion(struct completion *done)
+
+Finally to check state of a completion without changing it in any way is
+provided by completion_done();
+
+	completion_done(struct completion *done)
+
+
+Constraints:
+============
+
+ * DECLARE_COMPLETION should not be used for completion objects
+   declared within functions (automatic variables) use
+   DECLEAR_COMPLETION_ONSTACK for that case.
+ * calling init_completion() on the same completion object is most
+   likely a bug - use reinit_completion() in that case.
+ * waiting threads wakeup order is the same in which they were
+   enqueued (FIFO order).
+ * There only can be one thread calling complete() or complete_all()
+   on a particular struct completion at any time - serialized
+   through the wait-queue spinlock. Any concurrent calls to
+   complete() or complete_all() probably are a design bug though.
+ * calling complete() multiple time is permitted, calling
+   complete_all() multiple times is very likely a bug.
+ * timeouts are in jiffies - use msecs_to_jiffies/usecs_to_jiffies to
+   convert arguments.
+ * default wait_for_completion is neither interruptible nor will it
+   time out - appropriate _interruptible/_timeout variants must be
+   used.
+ * with held locks only try_wait_for_completion is safe, all other
+   variants can sleep.
+ * The struct completion should be given a meaningful name - e.g.
+   &cmd.complete or thread->started but not &completion. so that
+   it is clear what is being waited on.
+ * The completion API is basically RT safe as it only is using
+   boostable locks but these could never the less be held for quite
+   lengthy periods of time.
+ * in PREEMPT_RT the wait-queue used in queuing tasks is changed to a
+   simple wait-queue to minimize the lock contention of the queue
+   related lock.
+ * PREEMPT_RT only changes the completion usage related to stop_machine
+
+Code that thinks of using yield() or some quirky msleep(1); loop to allow
+something else to proceed probably wants to look into using
+wait_for_completion() instead.
--
1.7.10.4

