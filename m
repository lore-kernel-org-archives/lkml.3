Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaJRA3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 20:29:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:50669 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaJRA2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 20:28:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-rt-users@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/7] wait.c: mark complex wait functions to prepare for simple wait
Date: Fri, 17 Oct 2014 20:22:57 -0400
Message-ID: <1413591782-23453-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the previous commit, the goal is to explicitly distinguish
between complex wait and simple wait in the names of functions
and structs.  We avoid re-using the old namespace like
"add_wait_foo(), to ensure it is clear which users have actively
chosen which variant they want to use, vs. which ones have just
been grandfathered into using the pre-existing complex variants.

In order to achieve this, we have already done the following:

a) rename existing structs and functions with an additonal "c"
   to indicate they are the complex variants [limited to wait.h]

b) introduce temporary wait_xyz() ----> cwait_xyz() mappings that will
   let us do tree-wide conversions at our leisure (with coccinelle).
   The mappings can be disabled with #undef CWAIT_COMPAT for testing.

Here we update the existing core implementation of complex wait
functions in kernel/sched/wait.c to have "c" prefix and hence not rely
on (b) above.  Implicitly we avoid using typedefs at the same time
as we make these name changes.

We also drop "queue" from the names in order to make some of them
slightly less cumbersome, as per the previous commit.

This prepares us for adding swait_xyz() variations into wait.c
along side the existing cwait_xyz() functions renamed here.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 15cab1a4f84e..e62bd9c8aaf7 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -10,46 +10,46 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 
-void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
+void __init_cwait_head(struct cwait_head *q, const char *name,
+		       struct lock_class_key *key)
 {
 	spin_lock_init(&q->lock);
 	lockdep_set_class_and_name(&q->lock, key, name);
 	INIT_LIST_HEAD(&q->task_list);
 }
+EXPORT_SYMBOL(__init_cwait_head);
 
-EXPORT_SYMBOL(__init_waitqueue_head);
-
-void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
+void add_cwait(struct cwait_head *q, struct cwait *wait)
 {
 	unsigned long flags;
 
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
-	__add_wait_queue(q, wait);
+	__add_cwait(q, wait);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL(add_wait_queue);
+EXPORT_SYMBOL(add_cwait);
 
-void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
+void add_cwait_exclusive(struct cwait_head *q, struct cwait *wait)
 {
 	unsigned long flags;
 
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
-	__add_wait_queue_tail(q, wait);
+	__add_cwait_tail(q, wait);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL(add_wait_queue_exclusive);
+EXPORT_SYMBOL(add_cwait_exclusive);
 
-void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
+void remove_cwait(struct cwait_head *q, struct cwait *wait)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&q->lock, flags);
-	__remove_wait_queue(q, wait);
+	__remove_cwait(q, wait);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL(remove_wait_queue);
+EXPORT_SYMBOL(remove_cwait);
 
 
 /*
@@ -61,10 +61,10 @@ EXPORT_SYMBOL(remove_wait_queue);
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
  */
-static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, int wake_flags, void *key)
+static void __cwake_up_common(struct cwait_head *q, unsigned int mode,
+			      int nr_exclusive, int wake_flags, void *key)
 {
-	wait_queue_t *curr, *next;
+	struct cwait *curr, *next;
 
 	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
 		unsigned flags = curr->flags;
@@ -76,8 +76,8 @@ static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
 }
 
 /**
- * __wake_up - wake up threads blocked on a waitqueue.
- * @q: the waitqueue
+ * __cwake_up - wake up threads blocked on a waitqueue.
+ * @q: the complex waitqueue
  * @mode: which threads
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
  * @key: is directly passed to the wakeup function
@@ -85,34 +85,34 @@ static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
  * It may be assumed that this function implies a write memory barrier before
  * changing the task state if and only if any tasks are woken up.
  */
-void __wake_up(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, void *key)
+void __cwake_up(struct cwait_head *q, unsigned int mode, int nr_exclusive,
+		void *key)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, 0, key);
+	__cwake_up_common(q, mode, nr_exclusive, 0, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL(__wake_up);
+EXPORT_SYMBOL(__cwake_up);
 
 /*
- * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
+ * Same as __cwake_up but called with the spinlock in struct cwait_head held.
  */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
+void __cwake_up_locked(struct cwait_head *q, unsigned int mode, int nr)
 {
-	__wake_up_common(q, mode, nr, 0, NULL);
+	__cwake_up_common(q, mode, nr, 0, NULL);
 }
-EXPORT_SYMBOL_GPL(__wake_up_locked);
+EXPORT_SYMBOL_GPL(__cwake_up_locked);
 
-void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
+void __cwake_up_locked_key(struct cwait_head *q, unsigned int mode, void *key)
 {
-	__wake_up_common(q, mode, 1, 0, key);
+	__cwake_up_common(q, mode, 1, 0, key);
 }
-EXPORT_SYMBOL_GPL(__wake_up_locked_key);
+EXPORT_SYMBOL_GPL(__cwake_up_locked_key);
 
 /**
- * __wake_up_sync_key - wake up threads blocked on a waitqueue.
+ * __cwake_up_sync_key - wake up threads blocked on a waitqueue.
  * @q: the waitqueue
  * @mode: which threads
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
@@ -128,8 +128,8 @@ EXPORT_SYMBOL_GPL(__wake_up_locked_key);
  * It may be assumed that this function implies a write memory barrier before
  * changing the task state if and only if any tasks are woken up.
  */
-void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, void *key)
+void __cwake_up_sync_key(struct cwait_head *q, unsigned int mode,
+			 int nr_exclusive, void *key)
 {
 	unsigned long flags;
 	int wake_flags = 1; /* XXX WF_SYNC */
@@ -141,19 +141,19 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 		wake_flags = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, wake_flags, key);
+	__cwake_up_common(q, mode, nr_exclusive, wake_flags, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL_GPL(__wake_up_sync_key);
+EXPORT_SYMBOL_GPL(__cwake_up_sync_key);
 
 /*
- * __wake_up_sync - see __wake_up_sync_key()
+ * __cwake_up_sync - see __cwake_up_sync_key()
  */
-void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
+void __cwake_up_sync(struct cwait_head *q, unsigned int mode, int nr_exclusive)
 {
-	__wake_up_sync_key(q, mode, nr_exclusive, NULL);
+	__cwake_up_sync_key(q, mode, nr_exclusive, NULL);
 }
-EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
+EXPORT_SYMBOL_GPL(__cwake_up_sync);	/* For internal use only */
 
 /*
  * Note: we use "set_current_state()" _after_ the wait-queue add,
@@ -167,35 +167,34 @@ EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
  * stops them from bleeding out - it would still allow subsequent
  * loads to move into the critical region).
  */
-void
-prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
+void prepare_to_cwait(struct cwait_head *q, struct cwait *wait, int state)
 {
 	unsigned long flags;
 
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
-		__add_wait_queue(q, wait);
+		__add_cwait(q, wait);
 	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL(prepare_to_wait);
+EXPORT_SYMBOL(prepare_to_cwait);
 
-void
-prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
+void prepare_to_cwait_exclusive(struct cwait_head *q, struct cwait *wait,
+				int state)
 {
 	unsigned long flags;
 
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
-		__add_wait_queue_tail(q, wait);
+		__add_cwait_tail(q, wait);
 	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL(prepare_to_wait_exclusive);
+EXPORT_SYMBOL(prepare_to_cwait_exclusive);
 
-long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
+long prepare_to_cwait_event(struct cwait_head *q, struct cwait *wait, int state)
 {
 	unsigned long flags;
 
@@ -203,32 +202,32 @@ long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
 		return -ERESTARTSYS;
 
 	wait->private = current;
-	wait->func = autoremove_wake_function;
+	wait->func = autoremove_cwake_function;
 
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list)) {
 		if (wait->flags & WQ_FLAG_EXCLUSIVE)
-			__add_wait_queue_tail(q, wait);
+			__add_cwait_tail(q, wait);
 		else
-			__add_wait_queue(q, wait);
+			__add_cwait(q, wait);
 	}
 	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 
 	return 0;
 }
-EXPORT_SYMBOL(prepare_to_wait_event);
+EXPORT_SYMBOL(prepare_to_cwait_event);
 
 /**
- * finish_wait - clean up after waiting in a queue
- * @q: waitqueue waited on
+ * finish_cwait - clean up after waiting in a queue
+ * @q: complex waitqueue waited on
  * @wait: wait descriptor
  *
  * Sets current thread back to running state and removes
  * the wait descriptor from the given waitqueue if still
  * queued.
  */
-void finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
+void finish_cwait(struct cwait_head *q, struct cwait *wait)
 {
 	unsigned long flags;
 
@@ -252,10 +251,10 @@ void finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
 		spin_unlock_irqrestore(&q->lock, flags);
 	}
 }
-EXPORT_SYMBOL(finish_wait);
+EXPORT_SYMBOL(finish_cwait);
 
 /**
- * abort_exclusive_wait - abort exclusive waiting in a queue
+ * abort_exclusive_cwait - abort exclusive waiting in a queue
  * @q: waitqueue waited on
  * @wait: wait descriptor
  * @mode: runstate of the waiter to be woken
@@ -272,8 +271,8 @@ EXPORT_SYMBOL(finish_wait);
  * aborts and is woken up concurrently and no one wakes up
  * the next waiter.
  */
-void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
-			unsigned int mode, void *key)
+void abort_exclusive_cwait(struct cwait_head *q, struct cwait *wait,
+			   unsigned int mode, void *key)
 {
 	unsigned long flags;
 
@@ -281,36 +280,36 @@ void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
 	spin_lock_irqsave(&q->lock, flags);
 	if (!list_empty(&wait->task_list))
 		list_del_init(&wait->task_list);
-	else if (waitqueue_active(q))
-		__wake_up_locked_key(q, mode, key);
+	else if (cwait_active(q))
+		__cwake_up_locked_key(q, mode, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL(abort_exclusive_wait);
+EXPORT_SYMBOL(abort_exclusive_cwait);
 
-int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
+int autoremove_cwake_function(struct cwait *wait, unsigned mode, int sync,
+			      void *key)
 {
-	int ret = default_wake_function(wait, mode, sync, key);
+	int ret = default_cwake_function(wait, mode, sync, key);
 
 	if (ret)
 		list_del_init(&wait->task_list);
 	return ret;
 }
-EXPORT_SYMBOL(autoremove_wake_function);
+EXPORT_SYMBOL(autoremove_cwake_function);
 
-int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
+int cwake_bit_function(struct cwait *wait, unsigned mode, int sync, void *arg)
 {
-	struct wait_bit_key *key = arg;
-	struct wait_bit_queue *wait_bit
-		= container_of(wait, struct wait_bit_queue, wait);
+	struct cwait_bit_key *key = arg;
+	struct cwait_bit *wait_bit = container_of(wait, struct cwait_bit, wait);
 
 	if (wait_bit->key.flags != key->flags ||
 			wait_bit->key.bit_nr != key->bit_nr ||
 			test_bit(key->bit_nr, key->flags))
 		return 0;
 	else
-		return autoremove_wake_function(wait, mode, sync, key);
+		return autoremove_cwake_function(wait, mode, sync, key);
 }
-EXPORT_SYMBOL(wake_bit_function);
+EXPORT_SYMBOL(cwake_bit_function);
 
 /*
  * To allow interruptible waiting and asynchronous (i.e. nonblocking)
@@ -318,79 +317,79 @@ EXPORT_SYMBOL(wake_bit_function);
  * permitted return codes. Nonzero return codes halt waiting and return.
  */
 int __sched
-__wait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
+__cwait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
 	      wait_bit_action_f *action, unsigned mode)
 {
 	int ret = 0;
 
 	do {
-		prepare_to_wait(wq, &q->wait, mode);
+		prepare_to_cwait(wq, &q->wait, mode);
 		if (test_bit(q->key.bit_nr, q->key.flags))
 			ret = (*action)(&q->key);
 	} while (test_bit(q->key.bit_nr, q->key.flags) && !ret);
-	finish_wait(wq, &q->wait);
+	finish_cwait(wq, &q->wait);
 	return ret;
 }
-EXPORT_SYMBOL(__wait_on_bit);
+EXPORT_SYMBOL(__cwait_on_bit);
 
-int __sched out_of_line_wait_on_bit(void *word, int bit,
+int __sched out_of_line_cwait_on_bit(void *word, int bit,
 				    wait_bit_action_f *action, unsigned mode)
 {
-	wait_queue_head_t *wq = bit_waitqueue(word, bit);
-	DEFINE_WAIT_BIT(wait, word, bit);
+	struct cwait_head *wq = bit_cwaitqueue(word, bit);
+	DEFINE_CWAIT_BIT(wait, word, bit);
 
-	return __wait_on_bit(wq, &wait, action, mode);
+	return __cwait_on_bit(wq, &wait, action, mode);
 }
-EXPORT_SYMBOL(out_of_line_wait_on_bit);
+EXPORT_SYMBOL(out_of_line_cwait_on_bit);
 
 int __sched
-__wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
+__cwait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 			wait_bit_action_f *action, unsigned mode)
 {
 	do {
 		int ret;
 
-		prepare_to_wait_exclusive(wq, &q->wait, mode);
+		prepare_to_cwait_exclusive(wq, &q->wait, mode);
 		if (!test_bit(q->key.bit_nr, q->key.flags))
 			continue;
 		ret = action(&q->key);
 		if (!ret)
 			continue;
-		abort_exclusive_wait(wq, &q->wait, mode, &q->key);
+		abort_exclusive_cwait(wq, &q->wait, mode, &q->key);
 		return ret;
 	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
-	finish_wait(wq, &q->wait);
+	finish_cwait(wq, &q->wait);
 	return 0;
 }
-EXPORT_SYMBOL(__wait_on_bit_lock);
+EXPORT_SYMBOL(__cwait_on_bit_lock);
 
-int __sched out_of_line_wait_on_bit_lock(void *word, int bit,
+int __sched out_of_line_cwait_on_bit_lock(void *word, int bit,
 					 wait_bit_action_f *action, unsigned mode)
 {
-	wait_queue_head_t *wq = bit_waitqueue(word, bit);
-	DEFINE_WAIT_BIT(wait, word, bit);
+	struct cwait_head *wq = bit_cwaitqueue(word, bit);
+	DEFINE_CWAIT_BIT(wait, word, bit);
 
-	return __wait_on_bit_lock(wq, &wait, action, mode);
+	return __cwait_on_bit_lock(wq, &wait, action, mode);
 }
-EXPORT_SYMBOL(out_of_line_wait_on_bit_lock);
+EXPORT_SYMBOL(out_of_line_cwait_on_bit_lock);
 
-void __wake_up_bit(wait_queue_head_t *wq, void *word, int bit)
+void __cwake_up_bit(struct cwait_head *wq, void *word, int bit)
 {
-	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
-	if (waitqueue_active(wq))
-		__wake_up(wq, TASK_NORMAL, 1, &key);
+	struct cwait_bit_key key = CWAIT_BIT_KEY_INITIALIZER(word, bit);
+	if (cwait_active(wq))
+		__cwake_up(wq, TASK_NORMAL, 1, &key);
 }
-EXPORT_SYMBOL(__wake_up_bit);
+EXPORT_SYMBOL(__cwake_up_bit);
 
 /**
- * wake_up_bit - wake up a waiter on a bit
+ * cwake_up_bit - wake up a waiter on a bit
  * @word: the word being waited on, a kernel virtual address
  * @bit: the bit of the word being waited on
  *
  * There is a standard hashed waitqueue table for generic use. This
  * is the part of the hashtable's accessor API that wakes up waiters
  * on a bit. For instance, if one were to have waiters on a bitflag,
- * one would call wake_up_bit() after clearing the bit.
+ * one would call cwake_up_bit() after clearing the bit.
  *
  * In order for this to function properly, as it uses waitqueue_active()
  * internally, some kind of memory barrier must be done prior to calling
@@ -399,13 +398,13 @@ EXPORT_SYMBOL(__wake_up_bit);
  * may need to use a less regular barrier, such fs/inode.c's smp_mb(),
  * because spin_unlock() does not guarantee a memory barrier.
  */
-void wake_up_bit(void *word, int bit)
+void cwake_up_bit(void *word, int bit)
 {
-	__wake_up_bit(bit_waitqueue(word, bit), word, bit);
+	__cwake_up_bit(bit_cwaitqueue(word, bit), word, bit);
 }
-EXPORT_SYMBOL(wake_up_bit);
+EXPORT_SYMBOL(cwake_up_bit);
 
-wait_queue_head_t *bit_waitqueue(void *word, int bit)
+struct cwait_head *bit_cwaitqueue(void *word, int bit)
 {
 	const int shift = BITS_PER_LONG == 32 ? 5 : 6;
 	const struct zone *zone = page_zone(virt_to_page(word));
@@ -413,83 +412,84 @@ wait_queue_head_t *bit_waitqueue(void *word, int bit)
 
 	return &zone->wait_table[hash_long(val, zone->wait_table_bits)];
 }
-EXPORT_SYMBOL(bit_waitqueue);
+EXPORT_SYMBOL(bit_cwaitqueue);
 
 /*
  * Manipulate the atomic_t address to produce a better bit waitqueue table hash
  * index (we're keying off bit -1, but that would produce a horrible hash
  * value).
  */
-static inline wait_queue_head_t *atomic_t_waitqueue(atomic_t *p)
+static inline struct cwait_head *atomic_t_cwaitqueue(atomic_t *p)
 {
 	if (BITS_PER_LONG == 64) {
 		unsigned long q = (unsigned long)p;
-		return bit_waitqueue((void *)(q & ~1), q & 1);
+		return bit_cwaitqueue((void *)(q & ~1), q & 1);
 	}
-	return bit_waitqueue(p, 0);
+	return bit_cwaitqueue(p, 0);
 }
 
-static int wake_atomic_t_function(wait_queue_t *wait, unsigned mode, int sync,
-				  void *arg)
+static int cwake_atomic_t_function(struct cwait *wait, unsigned mode, int sync,
+				   void *arg)
 {
-	struct wait_bit_key *key = arg;
-	struct wait_bit_queue *wait_bit
-		= container_of(wait, struct wait_bit_queue, wait);
+	struct cwait_bit_key *key = arg;
+	struct cwait_bit *wait_bit = container_of(wait, struct cwait_bit, wait);
 	atomic_t *val = key->flags;
 
 	if (wait_bit->key.flags != key->flags ||
 	    wait_bit->key.bit_nr != key->bit_nr ||
 	    atomic_read(val) != 0)
 		return 0;
-	return autoremove_wake_function(wait, mode, sync, key);
+	return autoremove_cwake_function(wait, mode, sync, key);
 }
 
 /*
  * To allow interruptible waiting and asynchronous (i.e. nonblocking) waiting,
- * the actions of __wait_on_atomic_t() are permitted return codes.  Nonzero
+ * the actions of __cwait_on_atomic_t() are permitted return codes.  Nonzero
  * return codes halt waiting and return.
  */
-static __sched
-int __wait_on_atomic_t(wait_queue_head_t *wq, struct wait_bit_queue *q,
-		       int (*action)(atomic_t *), unsigned mode)
+static __sched int __cwait_on_atomic_t(struct cwait_head *wq,
+				       struct cwait_bit *q,
+				       int (*action)(atomic_t *),
+				       unsigned mode)
 {
 	atomic_t *val;
 	int ret = 0;
 
 	do {
-		prepare_to_wait(wq, &q->wait, mode);
+		prepare_to_cwait(wq, &q->wait, mode);
 		val = q->key.flags;
 		if (atomic_read(val) == 0)
 			break;
 		ret = (*action)(val);
 	} while (!ret && atomic_read(val) != 0);
-	finish_wait(wq, &q->wait);
+	finish_cwait(wq, &q->wait);
 	return ret;
 }
 
-#define DEFINE_WAIT_ATOMIC_T(name, p)					\
-	struct wait_bit_queue name = {					\
-		.key = __WAIT_ATOMIC_T_KEY_INITIALIZER(p),		\
+#define DEFINE_CWAIT_ATOMIC_T(name, p)					\
+	struct cwait_bit name = {					\
+		.key = CWAIT_ATOMIC_T_KEY_INITIALIZER(p),		\
 		.wait	= {						\
 			.private	= current,			\
-			.func		= wake_atomic_t_function,	\
+			.func		= cwake_atomic_t_function,	\
 			.task_list	=				\
 				LIST_HEAD_INIT((name).wait.task_list),	\
 		},							\
 	}
 
-__sched int out_of_line_wait_on_atomic_t(atomic_t *p, int (*action)(atomic_t *),
-					 unsigned mode)
+__sched int out_of_line_cwait_on_atomic_t(atomic_t *p,
+					  int (*action)(atomic_t *),
+					  unsigned mode)
 {
-	wait_queue_head_t *wq = atomic_t_waitqueue(p);
-	DEFINE_WAIT_ATOMIC_T(wait, p);
+	struct cwait_head *wq = atomic_t_cwaitqueue(p);
+	DEFINE_CWAIT_ATOMIC_T(wait, p);
 
-	return __wait_on_atomic_t(wq, &wait, action, mode);
+	return __cwait_on_atomic_t(wq, &wait, action, mode);
 }
-EXPORT_SYMBOL(out_of_line_wait_on_atomic_t);
+EXPORT_SYMBOL(out_of_line_cwait_on_atomic_t);
 
 /**
- * wake_up_atomic_t - Wake up a waiter on a atomic_t
+ * cwake_up_atomic_t - Wake up a waiter on a atomic_t
  * @p: The atomic_t being waited on, a kernel virtual address
  *
  * Wake up anyone waiting for the atomic_t to go to zero.
@@ -497,11 +497,11 @@ EXPORT_SYMBOL(out_of_line_wait_on_atomic_t);
  * Abuse the bit-waker function and its waitqueue hash table set (the atomic_t
  * check is done by the waiter's wake function, not the by the waker itself).
  */
-void wake_up_atomic_t(atomic_t *p)
+void cwake_up_atomic_t(atomic_t *p)
 {
-	__wake_up_bit(atomic_t_waitqueue(p), p, WAIT_ATOMIC_T_BIT_NR);
+	__cwake_up_bit(atomic_t_cwaitqueue(p), p, CWAIT_ATOMIC_T_BIT_NR);
 }
-EXPORT_SYMBOL(wake_up_atomic_t);
+EXPORT_SYMBOL(cwake_up_atomic_t);
 
 __sched int bit_wait(struct wait_bit_key *word)
 {
-- 
1.9.2

