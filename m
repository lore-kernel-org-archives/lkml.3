Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaJ1LKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:10:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbaJ1LKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:10:36 -0400
Date: Tue, 28 Oct 2014 04:09:43 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-61ada528dea028331e99e8ceaed87c683ad25de2@git.kernel.org>
Cc: tglx@linutronix.de, oleg@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org
Reply-To: torvalds@linux-foundation.org, peterz@infradead.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, oleg@redhat.com, mingo@kernel.org,
        tglx@linutronix.de
In-Reply-To: <20140924082242.051202318@infradead.org>
References: <20140924082242.051202318@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait:
  Provide infrastructure to deal with nested blocking
Git-Commit-ID: 61ada528dea028331e99e8ceaed87c683ad25de2
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

Commit-ID:  61ada528dea028331e99e8ceaed87c683ad25de2
Gitweb:     http://git.kernel.org/tip/61ada528dea028331e99e8ceaed87c683ad25de2
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:55:15 +0100

sched/wait: Provide infrastructure to deal with nested blocking

There are a few places that call blocking primitives from wait loops,
provide infrastructure to support this without the typical
task_struct::state collision.

We record the wakeup in wait_queue_t::flags which leaves
task_struct::state free to be used by others.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140924082242.051202318@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h |  7 +++++-
 kernel/sched/wait.c  | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index e4a8eb9..fc0e993 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -13,9 +13,12 @@ typedef struct __wait_queue wait_queue_t;
 typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
 int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
 
+/* __wait_queue::flags */
+#define WQ_FLAG_EXCLUSIVE	0x01
+#define WQ_FLAG_WOKEN		0x02
+
 struct __wait_queue {
 	unsigned int		flags;
-#define WQ_FLAG_EXCLUSIVE	0x01
 	void			*private;
 	wait_queue_func_t	func;
 	struct list_head	task_list;
@@ -830,6 +833,8 @@ void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int sta
 long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
 void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait, unsigned int mode, void *key);
+long wait_woken(wait_queue_t *wait, unsigned mode, long timeout);
+int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 5a62915..4dae188 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -297,6 +297,67 @@ int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *
 }
 EXPORT_SYMBOL(autoremove_wake_function);
 
+
+/*
+ * DEFINE_WAIT_FUNC(wait, woken_wake_func);
+ *
+ * add_wait_queue(&wq, &wait);
+ * for (;;) {
+ *     if (condition)
+ *         break;
+ *
+ *     p->state = mode;				condition = true;
+ *     smp_mb(); // A				smp_wmb(); // C
+ *     if (!wait->flags & WQ_FLAG_WOKEN)	wait->flags |= WQ_FLAG_WOKEN;
+ *         schedule()				try_to_wake_up();
+ *     p->state = TASK_RUNNING;		    ~~~~~~~~~~~~~~~~~~
+ *     wait->flags &= ~WQ_FLAG_WOKEN;		condition = true;
+ *     smp_mb() // B				smp_wmb(); // C
+ *						wait->flags |= WQ_FLAG_WOKEN;
+ * }
+ * remove_wait_queue(&wq, &wait);
+ *
+ */
+long wait_woken(wait_queue_t *wait, unsigned mode, long timeout)
+{
+	set_current_state(mode); /* A */
+	/*
+	 * The above implies an smp_mb(), which matches with the smp_wmb() from
+	 * woken_wake_function() such that if we observe WQ_FLAG_WOKEN we must
+	 * also observe all state before the wakeup.
+	 */
+	if (!(wait->flags & WQ_FLAG_WOKEN))
+		timeout = schedule_timeout(timeout);
+	__set_current_state(TASK_RUNNING);
+
+	/*
+	 * The below implies an smp_mb(), it too pairs with the smp_wmb() from
+	 * woken_wake_function() such that we must either observe the wait
+	 * condition being true _OR_ WQ_FLAG_WOKEN such that we will not miss
+	 * an event.
+	 */
+	set_mb(wait->flags, wait->flags & ~WQ_FLAG_WOKEN); /* B */
+
+	return timeout;
+}
+EXPORT_SYMBOL(wait_woken);
+
+int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	/*
+	 * Although this function is called under waitqueue lock, LOCK
+	 * doesn't imply write barrier and the users expects write
+	 * barrier semantics on wakeup functions.  The following
+	 * smp_wmb() is equivalent to smp_wmb() in try_to_wake_up()
+	 * and is paired with set_mb() in wait_woken().
+	 */
+	smp_wmb(); /* C */
+	wait->flags |= WQ_FLAG_WOKEN;
+
+	return default_wake_function(wait, mode, sync, key);
+}
+EXPORT_SYMBOL(woken_wake_function);
+
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
 {
 	struct wait_bit_key *key = arg;
