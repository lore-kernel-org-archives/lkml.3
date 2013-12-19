Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3LSBaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:30:21 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53448 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3LSBaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:30:15 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] closures: move to lib/
Date: Wed, 18 Dec 2013 17:29:54 -0800
Message-Id: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the closure code was never intended to be bcache specific - hopefully it can be
useful elsewhere in the kernel.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/bcache/Kconfig   |   9 -
 drivers/md/bcache/Makefile  |   2 +-
 drivers/md/bcache/bcache.h  |   2 +-
 drivers/md/bcache/closure.c | 222 ----------------------
 drivers/md/bcache/closure.h | 453 --------------------------------------------
 drivers/md/bcache/util.h    |   3 +-
 include/linux/closure.h     | 451 +++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug           |   8 +
 lib/Makefile                |   2 +-
 lib/closure.c               | 218 +++++++++++++++++++++
 10 files changed, 681 insertions(+), 689 deletions(-)
 delete mode 100644 drivers/md/bcache/closure.c
 delete mode 100644 drivers/md/bcache/closure.h
 create mode 100644 include/linux/closure.h
 create mode 100644 lib/closure.c

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index 2638417b19..d6d7f792cc 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -16,15 +16,6 @@ config BCACHE_DEBUG
 	Enables extra debugging tools, allows expensive runtime checks to be
 	turned on.
 
-config BCACHE_CLOSURES_DEBUG
-	bool "Debug closures"
-	depends on BCACHE
-	select DEBUG_FS
-	---help---
-	Keeps all active closures in a linked list and provides a debugfs
-	interface to list them, which makes it possible to see asynchronous
-	operations that get stuck.
-
 # cgroup code needs to be updated:
 #
 #config CGROUP_BCACHE
diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
index 0e9c82523b..17ab9adbdf 100644
--- a/drivers/md/bcache/Makefile
+++ b/drivers/md/bcache/Makefile
@@ -2,6 +2,6 @@
 obj-$(CONFIG_BCACHE)	+= bcache.o
 
 bcache-y		:= alloc.o btree.o bset.o io.o journal.o writeback.o\
-	movinggc.o request.o super.o sysfs.o debug.o util.o trace.o stats.o closure.o
+	movinggc.o request.o super.o sysfs.o debug.o util.o trace.o stats.o
 
 CFLAGS_request.o	+= -Iblock
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9d062bc562..79f444a8b9 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -179,6 +179,7 @@
 
 #include <linux/bcache.h>
 #include <linux/bio.h>
+#include <linux/closure.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
@@ -188,7 +189,6 @@
 #include <linux/workqueue.h>
 
 #include "util.h"
-#include "closure.h"
 
 struct bucket {
 	atomic_t	pin;
diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
deleted file mode 100644
index 7a228de95f..0000000000
--- a/drivers/md/bcache/closure.c
+++ /dev/null
@@ -1,222 +0,0 @@
-/*
- * Asynchronous refcounty things
- *
- * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
- * Copyright 2012 Google, Inc.
- */
-
-#include <linux/debugfs.h>
-#include <linux/module.h>
-#include <linux/seq_file.h>
-
-#include "closure.h"
-
-static inline void closure_put_after_sub(struct closure *cl, int flags)
-{
-	int r = flags & CLOSURE_REMAINING_MASK;
-
-	BUG_ON(flags & CLOSURE_GUARD_MASK);
-	BUG_ON(!r && (flags & ~CLOSURE_DESTRUCTOR));
-
-	/* Must deliver precisely one wakeup */
-	if (r == 1 && (flags & CLOSURE_SLEEPING))
-		wake_up_process(cl->task);
-
-	if (!r) {
-		if (cl->fn && !(flags & CLOSURE_DESTRUCTOR)) {
-			atomic_set(&cl->remaining,
-				   CLOSURE_REMAINING_INITIALIZER);
-			closure_queue(cl);
-		} else {
-			struct closure *parent = cl->parent;
-			closure_fn *destructor = cl->fn;
-
-			closure_debug_destroy(cl);
-
-			if (destructor)
-				destructor(cl);
-
-			if (parent)
-				closure_put(parent);
-		}
-	}
-}
-
-/* For clearing flags with the same atomic op as a put */
-void closure_sub(struct closure *cl, int v)
-{
-	closure_put_after_sub(cl, atomic_sub_return(v, &cl->remaining));
-}
-EXPORT_SYMBOL(closure_sub);
-
-/**
- * closure_put - decrement a closure's refcount
- */
-void closure_put(struct closure *cl)
-{
-	closure_put_after_sub(cl, atomic_dec_return(&cl->remaining));
-}
-EXPORT_SYMBOL(closure_put);
-
-/**
- * closure_wake_up - wake up all closures on a wait list, without memory barrier
- */
-void __closure_wake_up(struct closure_waitlist *wait_list)
-{
-	struct llist_node *list;
-	struct closure *cl;
-	struct llist_node *reverse = NULL;
-
-	list = llist_del_all(&wait_list->list);
-
-	/* We first reverse the list to preserve FIFO ordering and fairness */
-
-	while (list) {
-		struct llist_node *t = list;
-		list = llist_next(list);
-
-		t->next = reverse;
-		reverse = t;
-	}
-
-	/* Then do the wakeups */
-
-	while (reverse) {
-		cl = container_of(reverse, struct closure, list);
-		reverse = llist_next(reverse);
-
-		closure_set_waiting(cl, 0);
-		closure_sub(cl, CLOSURE_WAITING + 1);
-	}
-}
-EXPORT_SYMBOL(__closure_wake_up);
-
-/**
- * closure_wait - add a closure to a waitlist
- *
- * @waitlist will own a ref on @cl, which will be released when
- * closure_wake_up() is called on @waitlist.
- *
- */
-bool closure_wait(struct closure_waitlist *waitlist, struct closure *cl)
-{
-	if (atomic_read(&cl->remaining) & CLOSURE_WAITING)
-		return false;
-
-	closure_set_waiting(cl, _RET_IP_);
-	atomic_add(CLOSURE_WAITING + 1, &cl->remaining);
-	llist_add(&cl->list, &waitlist->list);
-
-	return true;
-}
-EXPORT_SYMBOL(closure_wait);
-
-/**
- * closure_sync - sleep until a closure a closure has nothing left to wait on
- *
- * Sleeps until the refcount hits 1 - the thread that's running the closure owns
- * the last refcount.
- */
-void closure_sync(struct closure *cl)
-{
-	while (1) {
-		__closure_start_sleep(cl);
-		closure_set_ret_ip(cl);
-
-		if ((atomic_read(&cl->remaining) &
-		     CLOSURE_REMAINING_MASK) == 1)
-			break;
-
-		schedule();
-	}
-
-	__closure_end_sleep(cl);
-}
-EXPORT_SYMBOL(closure_sync);
-
-#ifdef CONFIG_BCACHE_CLOSURES_DEBUG
-
-static LIST_HEAD(closure_list);
-static DEFINE_SPINLOCK(closure_list_lock);
-
-void closure_debug_create(struct closure *cl)
-{
-	unsigned long flags;
-
-	BUG_ON(cl->magic == CLOSURE_MAGIC_ALIVE);
-	cl->magic = CLOSURE_MAGIC_ALIVE;
-
-	spin_lock_irqsave(&closure_list_lock, flags);
-	list_add(&cl->all, &closure_list);
-	spin_unlock_irqrestore(&closure_list_lock, flags);
-}
-EXPORT_SYMBOL(closure_debug_create);
-
-void closure_debug_destroy(struct closure *cl)
-{
-	unsigned long flags;
-
-	BUG_ON(cl->magic != CLOSURE_MAGIC_ALIVE);
-	cl->magic = CLOSURE_MAGIC_DEAD;
-
-	spin_lock_irqsave(&closure_list_lock, flags);
-	list_del(&cl->all);
-	spin_unlock_irqrestore(&closure_list_lock, flags);
-}
-EXPORT_SYMBOL(closure_debug_destroy);
-
-static struct dentry *debug;
-
-#define work_data_bits(work) ((unsigned long *)(&(work)->data))
-
-static int debug_seq_show(struct seq_file *f, void *data)
-{
-	struct closure *cl;
-	spin_lock_irq(&closure_list_lock);
-
-	list_for_each_entry(cl, &closure_list, all) {
-		int r = atomic_read(&cl->remaining);
-
-		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
-			   cl, (void *) cl->ip, cl->fn, cl->parent,
-			   r & CLOSURE_REMAINING_MASK);
-
-		seq_printf(f, "%s%s%s%s\n",
-			   test_bit(WORK_STRUCT_PENDING,
-				    work_data_bits(&cl->work)) ? "Q" : "",
-			   r & CLOSURE_RUNNING	? "R" : "",
-			   r & CLOSURE_STACK	? "S" : "",
-			   r & CLOSURE_SLEEPING	? "Sl" : "");
-
-		if (r & CLOSURE_WAITING)
-			seq_printf(f, " W %pF\n",
-				   (void *) cl->waiting_on);
-
-		seq_printf(f, "\n");
-	}
-
-	spin_unlock_irq(&closure_list_lock);
-	return 0;
-}
-
-static int debug_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, debug_seq_show, NULL);
-}
-
-static const struct file_operations debug_ops = {
-	.owner		= THIS_MODULE,
-	.open		= debug_seq_open,
-	.read		= seq_read,
-	.release	= single_release
-};
-
-void __init closure_debug_init(void)
-{
-	debug = debugfs_create_file("closures", 0400, NULL, NULL, &debug_ops);
-}
-
-#endif
-
-MODULE_AUTHOR("Kent Overstreet <koverstreet@google.com>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
deleted file mode 100644
index 13c3aa2157..0000000000
--- a/drivers/md/bcache/closure.h
+++ /dev/null
@@ -1,453 +0,0 @@
-#ifndef _LINUX_CLOSURE_H
-#define _LINUX_CLOSURE_H
-
-#include <linux/llist.h>
-#include <linux/sched.h>
-#include <linux/workqueue.h>
-
-/*
- * Closure is perhaps the most overused and abused term in computer science, but
- * since I've been unable to come up with anything better you're stuck with it
- * again.
- *
- * What are closures?
- *
- * They embed a refcount. The basic idea is they count "things that are in
- * progress" - in flight bios, some other thread that's doing something else -
- * anything you might want to wait on.
- *
- * The refcount may be manipulated with closure_get() and closure_put().
- * closure_put() is where many of the interesting things happen, when it causes
- * the refcount to go to 0.
- *
- * Closures can be used to wait on things both synchronously and asynchronously,
- * and synchronous and asynchronous use can be mixed without restriction. To
- * wait synchronously, use closure_sync() - you will sleep until your closure's
- * refcount hits 1.
- *
- * To wait asynchronously, use
- *   continue_at(cl, next_function, workqueue);
- *
- * passing it, as you might expect, the function to run when nothing is pending
- * and the workqueue to run that function out of.
- *
- * continue_at() also, critically, is a macro that returns the calling function.
- * There's good reason for this.
- *
- * To use safely closures asynchronously, they must always have a refcount while
- * they are running owned by the thread that is running them. Otherwise, suppose
- * you submit some bios and wish to have a function run when they all complete:
- *
- * foo_endio(struct bio *bio, int error)
- * {
- *	closure_put(cl);
- * }
- *
- * closure_init(cl);
- *
- * do_stuff();
- * closure_get(cl);
- * bio1->bi_endio = foo_endio;
- * bio_submit(bio1);
- *
- * do_more_stuff();
- * closure_get(cl);
- * bio2->bi_endio = foo_endio;
- * bio_submit(bio2);
- *
- * continue_at(cl, complete_some_read, system_wq);
- *
- * If closure's refcount started at 0, complete_some_read() could run before the
- * second bio was submitted - which is almost always not what you want! More
- * importantly, it wouldn't be possible to say whether the original thread or
- * complete_some_read()'s thread owned the closure - and whatever state it was
- * associated with!
- *
- * So, closure_init() initializes a closure's refcount to 1 - and when a
- * closure_fn is run, the refcount will be reset to 1 first.
- *
- * Then, the rule is - if you got the refcount with closure_get(), release it
- * with closure_put() (i.e, in a bio->bi_endio function). If you have a refcount
- * on a closure because you called closure_init() or you were run out of a
- * closure - _always_ use continue_at(). Doing so consistently will help
- * eliminate an entire class of particularly pernicious races.
- *
- * For a closure to wait on an arbitrary event, we need to introduce waitlists:
- *
- * struct closure_waitlist list;
- * closure_wait_event(list, cl, condition);
- * closure_wake_up(wait_list);
- *
- * These work analagously to wait_event() and wake_up() - except that instead of
- * operating on the current thread (for wait_event()) and lists of threads, they
- * operate on an explicit closure and lists of closures.
- *
- * Because it's a closure we can now wait either synchronously or
- * asynchronously. closure_wait_event() returns the current value of the
- * condition, and if it returned false continue_at() or closure_sync() can be
- * used to wait for it to become true.
- *
- * It's useful for waiting on things when you can't sleep in the context in
- * which you must check the condition (perhaps a spinlock held, or you might be
- * beneath generic_make_request() - in which case you can't sleep on IO).
- *
- * closure_wait_event() will wait either synchronously or asynchronously,
- * depending on whether the closure is in blocking mode or not. You can pick a
- * mode explicitly with closure_wait_event_sync() and
- * closure_wait_event_async(), which do just what you might expect.
- *
- * Lastly, you might have a wait list dedicated to a specific event, and have no
- * need for specifying the condition - you just want to wait until someone runs
- * closure_wake_up() on the appropriate wait list. In that case, just use
- * closure_wait(). It will return either true or false, depending on whether the
- * closure was already on a wait list or not - a closure can only be on one wait
- * list at a time.
- *
- * Parents:
- *
- * closure_init() takes two arguments - it takes the closure to initialize, and
- * a (possibly null) parent.
- *
- * If parent is non null, the new closure will have a refcount for its lifetime;
- * a closure is considered to be "finished" when its refcount hits 0 and the
- * function to run is null. Hence
- *
- * continue_at(cl, NULL, NULL);
- *
- * returns up the (spaghetti) stack of closures, precisely like normal return
- * returns up the C stack. continue_at() with non null fn is better thought of
- * as doing a tail call.
- *
- * All this implies that a closure should typically be embedded in a particular
- * struct (which its refcount will normally control the lifetime of), and that
- * struct can very much be thought of as a stack frame.
- */
-
-struct closure;
-typedef void (closure_fn) (struct closure *);
-
-struct closure_waitlist {
-	struct llist_head	list;
-};
-
-enum closure_state {
-	/*
-	 * CLOSURE_WAITING: Set iff the closure is on a waitlist. Must be set by
-	 * the thread that owns the closure, and cleared by the thread that's
-	 * waking up the closure.
-	 *
-	 * CLOSURE_SLEEPING: Must be set before a thread uses a closure to sleep
-	 * - indicates that cl->task is valid and closure_put() may wake it up.
-	 * Only set or cleared by the thread that owns the closure.
-	 *
-	 * The rest are for debugging and don't affect behaviour:
-	 *
-	 * CLOSURE_RUNNING: Set when a closure is running (i.e. by
-	 * closure_init() and when closure_put() runs then next function), and
-	 * must be cleared before remaining hits 0. Primarily to help guard
-	 * against incorrect usage and accidentally transferring references.
-	 * continue_at() and closure_return() clear it for you, if you're doing
-	 * something unusual you can use closure_set_dead() which also helps
-	 * annotate where references are being transferred.
-	 *
-	 * CLOSURE_STACK: Sanity check - remaining should never hit 0 on a
-	 * closure with this flag set
-	 */
-
-	CLOSURE_BITS_START	= (1 << 23),
-	CLOSURE_DESTRUCTOR	= (1 << 23),
-	CLOSURE_WAITING		= (1 << 25),
-	CLOSURE_SLEEPING	= (1 << 27),
-	CLOSURE_RUNNING		= (1 << 29),
-	CLOSURE_STACK		= (1 << 31),
-};
-
-#define CLOSURE_GUARD_MASK					\
-	((CLOSURE_DESTRUCTOR|CLOSURE_WAITING|CLOSURE_SLEEPING|	\
-	  CLOSURE_RUNNING|CLOSURE_STACK) << 1)
-
-#define CLOSURE_REMAINING_MASK		(CLOSURE_BITS_START - 1)
-#define CLOSURE_REMAINING_INITIALIZER	(1|CLOSURE_RUNNING)
-
-struct closure {
-	union {
-		struct {
-			struct workqueue_struct *wq;
-			struct task_struct	*task;
-			struct llist_node	list;
-			closure_fn		*fn;
-		};
-		struct work_struct	work;
-	};
-
-	struct closure		*parent;
-
-	atomic_t		remaining;
-
-#ifdef CONFIG_BCACHE_CLOSURES_DEBUG
-#define CLOSURE_MAGIC_DEAD	0xc054dead
-#define CLOSURE_MAGIC_ALIVE	0xc054a11e
-
-	unsigned		magic;
-	struct list_head	all;
-	unsigned long		ip;
-	unsigned long		waiting_on;
-#endif
-};
-
-void closure_sub(struct closure *cl, int v);
-void closure_put(struct closure *cl);
-void __closure_wake_up(struct closure_waitlist *list);
-bool closure_wait(struct closure_waitlist *list, struct closure *cl);
-void closure_sync(struct closure *cl);
-
-#ifdef CONFIG_BCACHE_CLOSURES_DEBUG
-
-void closure_debug_init(void);
-void closure_debug_create(struct closure *cl);
-void closure_debug_destroy(struct closure *cl);
-
-#else
-
-static inline void closure_debug_init(void) {}
-static inline void closure_debug_create(struct closure *cl) {}
-static inline void closure_debug_destroy(struct closure *cl) {}
-
-#endif
-
-static inline void closure_set_ip(struct closure *cl)
-{
-#ifdef CONFIG_BCACHE_CLOSURES_DEBUG
-	cl->ip = _THIS_IP_;
-#endif
-}
-
-static inline void closure_set_ret_ip(struct closure *cl)
-{
-#ifdef CONFIG_BCACHE_CLOSURES_DEBUG
-	cl->ip = _RET_IP_;
-#endif
-}
-
-static inline void closure_set_waiting(struct closure *cl, unsigned long f)
-{
-#ifdef CONFIG_BCACHE_CLOSURES_DEBUG
-	cl->waiting_on = f;
-#endif
-}
-
-static inline void __closure_end_sleep(struct closure *cl)
-{
-	__set_current_state(TASK_RUNNING);
-
-	if (atomic_read(&cl->remaining) & CLOSURE_SLEEPING)
-		atomic_sub(CLOSURE_SLEEPING, &cl->remaining);
-}
-
-static inline void __closure_start_sleep(struct closure *cl)
-{
-	closure_set_ip(cl);
-	cl->task = current;
-	set_current_state(TASK_UNINTERRUPTIBLE);
-
-	if (!(atomic_read(&cl->remaining) & CLOSURE_SLEEPING))
-		atomic_add(CLOSURE_SLEEPING, &cl->remaining);
-}
-
-static inline void closure_set_stopped(struct closure *cl)
-{
-	atomic_sub(CLOSURE_RUNNING, &cl->remaining);
-}
-
-static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
-				  struct workqueue_struct *wq)
-{
-	BUG_ON(object_is_on_stack(cl));
-	closure_set_ip(cl);
-	cl->fn = fn;
-	cl->wq = wq;
-	/* between atomic_dec() in closure_put() */
-	smp_mb__before_atomic_dec();
-}
-
-static inline void closure_queue(struct closure *cl)
-{
-	struct workqueue_struct *wq = cl->wq;
-	if (wq) {
-		INIT_WORK(&cl->work, cl->work.func);
-		BUG_ON(!queue_work(wq, &cl->work));
-	} else
-		cl->fn(cl);
-}
-
-/**
- * closure_get - increment a closure's refcount
- */
-static inline void closure_get(struct closure *cl)
-{
-#ifdef CONFIG_BCACHE_CLOSURES_DEBUG
-	BUG_ON((atomic_inc_return(&cl->remaining) &
-		CLOSURE_REMAINING_MASK) <= 1);
-#else
-	atomic_inc(&cl->remaining);
-#endif
-}
-
-/**
- * closure_init - Initialize a closure, setting the refcount to 1
- * @cl:		closure to initialize
- * @parent:	parent of the new closure. cl will take a refcount on it for its
- *		lifetime; may be NULL.
- */
-static inline void closure_init(struct closure *cl, struct closure *parent)
-{
-	memset(cl, 0, sizeof(struct closure));
-	cl->parent = parent;
-	if (parent)
-		closure_get(parent);
-
-	atomic_set(&cl->remaining, CLOSURE_REMAINING_INITIALIZER);
-
-	closure_debug_create(cl);
-	closure_set_ip(cl);
-}
-
-static inline void closure_init_stack(struct closure *cl)
-{
-	memset(cl, 0, sizeof(struct closure));
-	atomic_set(&cl->remaining, CLOSURE_REMAINING_INITIALIZER|CLOSURE_STACK);
-}
-
-/**
- * closure_wake_up - wake up all closures on a wait list.
- */
-static inline void closure_wake_up(struct closure_waitlist *list)
-{
-	smp_mb();
-	__closure_wake_up(list);
-}
-
-/**
- * closure_wait_event - wait on arbitrary event
- *
- * Analogous to wait_event() but for closures.
- *
- * The loop is oddly structured so as to avoid a race; we must check the
- * condition again after we've added ourself to the waitlist. We know if we were
- * already on the waitlist because closure_wait() returns false; thus, we only
- * schedule or break if closure_wait() returns false. If it returns true, we
- * just loop again - rechecking the condition.
- *
- * The __closure_wake_up() is necessary because we may race with the event
- * becoming true; i.e. we see event false -> wait -> recheck condition, but the
- * thread that made the event true may have called closure_wake_up() before we
- * added ourself to the wait list.
- *
- * We have to call closure_sync() at the end instead of just
- * __closure_end_sleep() because a different thread might've called
- * closure_wake_up() before us and gotten preempted before they dropped the
- * refcount on our closure. If this was a stack allocated closure, that would be
- * bad.
- */
-#define closure_wait_event(list, cl, condition)				\
-({									\
-	typeof(condition) ret;						\
-									\
-	while (1) {							\
-		ret = (condition);					\
-		if (ret) {						\
-			__closure_wake_up(list);			\
-			closure_sync(cl);				\
-			break;						\
-		}							\
-									\
-		__closure_start_sleep(cl);				\
-									\
-		if (!closure_wait(list, cl))				\
-			schedule();					\
-	}								\
-									\
-	ret;								\
-})
-
-/**
- * continue_at - jump to another function with barrier
- *
- * After @cl is no longer waiting on anything (i.e. all outstanding refs have
- * been dropped with closure_put()), it will resume execution at @fn running out
- * of @wq (or, if @wq is NULL, @fn will be called by closure_put() directly).
- *
- * NOTE: This macro expands to a return in the calling function!
- *
- * This is because after calling continue_at() you no longer have a ref on @cl,
- * and whatever @cl owns may be freed out from under you - a running closure fn
- * has a ref on its own closure which continue_at() drops.
- */
-#define continue_at(_cl, _fn, _wq)					\
-do {									\
-	set_closure_fn(_cl, _fn, _wq);					\
-	closure_sub(_cl, CLOSURE_RUNNING + 1);				\
-	return;								\
-} while (0)
-
-/**
- * closure_return - finish execution of a closure
- *
- * This is used to indicate that @cl is finished: when all outstanding refs on
- * @cl have been dropped @cl's ref on its parent closure (as passed to
- * closure_init()) will be dropped, if one was specified - thus this can be
- * thought of as returning to the parent closure.
- */
-#define closure_return(_cl)	continue_at((_cl), NULL, NULL)
-
-/**
- * continue_at_nobarrier - jump to another function without barrier
- *
- * Causes @fn to be executed out of @cl, in @wq context (or called directly if
- * @wq is NULL).
- *
- * NOTE: like continue_at(), this macro expands to a return in the caller!
- *
- * The ref the caller of continue_at_nobarrier() had on @cl is now owned by @fn,
- * thus it's not safe to touch anything protected by @cl after a
- * continue_at_nobarrier().
- */
-#define continue_at_nobarrier(_cl, _fn, _wq)				\
-do {									\
-	set_closure_fn(_cl, _fn, _wq);					\
-	closure_queue(_cl);						\
-	return;								\
-} while (0)
-
-/**
- * closure_return - finish execution of a closure, with destructor
- *
- * Works like closure_return(), except @destructor will be called when all
- * outstanding refs on @cl have been dropped; @destructor may be used to safely
- * free the memory occupied by @cl, and it is called with the ref on the parent
- * closure still held - so @destructor could safely return an item to a
- * freelist protected by @cl's parent.
- */
-#define closure_return_with_destructor(_cl, _destructor)		\
-do {									\
-	set_closure_fn(_cl, _destructor, NULL);				\
-	closure_sub(_cl, CLOSURE_RUNNING - CLOSURE_DESTRUCTOR + 1);	\
-	return;								\
-} while (0)
-
-/**
- * closure_call - execute @fn out of a new, uninitialized closure
- *
- * Typically used when running out of one closure, and we want to run @fn
- * asynchronously out of a new closure - @parent will then wait for @cl to
- * finish.
- */
-static inline void closure_call(struct closure *cl, closure_fn fn,
-				struct workqueue_struct *wq,
-				struct closure *parent)
-{
-	closure_init(cl, parent);
-	continue_at_nobarrier(cl, fn, wq);
-}
-
-#endif /* _LINUX_CLOSURE_H */
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 1030c6020e..c51605d34b 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -2,6 +2,7 @@
 #ifndef _BCACHE_UTIL_H
 #define _BCACHE_UTIL_H
 
+#include <linux/closure.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/llist.h>
@@ -9,8 +10,6 @@
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 
-#include "closure.h"
-
 #define PAGE_SECTORS		(PAGE_SIZE / 512)
 
 struct closure;
diff --git a/include/linux/closure.h b/include/linux/closure.h
new file mode 100644
index 0000000000..038f0bf5df
--- /dev/null
+++ b/include/linux/closure.h
@@ -0,0 +1,451 @@
+#ifndef _LINUX_CLOSURE_H
+#define _LINUX_CLOSURE_H
+
+#include <linux/llist.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+
+/*
+ * Closure is perhaps the most overused and abused term in computer science, but
+ * since I've been unable to come up with anything better you're stuck with it
+ * again.
+ *
+ * What are closures?
+ *
+ * They embed a refcount. The basic idea is they count "things that are in
+ * progress" - in flight bios, some other thread that's doing something else -
+ * anything you might want to wait on.
+ *
+ * The refcount may be manipulated with closure_get() and closure_put().
+ * closure_put() is where many of the interesting things happen, when it causes
+ * the refcount to go to 0.
+ *
+ * Closures can be used to wait on things both synchronously and asynchronously,
+ * and synchronous and asynchronous use can be mixed without restriction. To
+ * wait synchronously, use closure_sync() - you will sleep until your closure's
+ * refcount hits 1.
+ *
+ * To wait asynchronously, use
+ *   continue_at(cl, next_function, workqueue);
+ *
+ * passing it, as you might expect, the function to run when nothing is pending
+ * and the workqueue to run that function out of.
+ *
+ * continue_at() also, critically, is a macro that returns the calling function.
+ * There's good reason for this.
+ *
+ * To use safely closures asynchronously, they must always have a refcount while
+ * they are running owned by the thread that is running them. Otherwise, suppose
+ * you submit some bios and wish to have a function run when they all complete:
+ *
+ * foo_endio(struct bio *bio, int error)
+ * {
+ *	closure_put(cl);
+ * }
+ *
+ * closure_init(cl);
+ *
+ * do_stuff();
+ * closure_get(cl);
+ * bio1->bi_endio = foo_endio;
+ * bio_submit(bio1);
+ *
+ * do_more_stuff();
+ * closure_get(cl);
+ * bio2->bi_endio = foo_endio;
+ * bio_submit(bio2);
+ *
+ * continue_at(cl, complete_some_read, system_wq);
+ *
+ * If closure's refcount started at 0, complete_some_read() could run before the
+ * second bio was submitted - which is almost always not what you want! More
+ * importantly, it wouldn't be possible to say whether the original thread or
+ * complete_some_read()'s thread owned the closure - and whatever state it was
+ * associated with!
+ *
+ * So, closure_init() initializes a closure's refcount to 1 - and when a
+ * closure_fn is run, the refcount will be reset to 1 first.
+ *
+ * Then, the rule is - if you got the refcount with closure_get(), release it
+ * with closure_put() (i.e, in a bio->bi_endio function). If you have a refcount
+ * on a closure because you called closure_init() or you were run out of a
+ * closure - _always_ use continue_at(). Doing so consistently will help
+ * eliminate an entire class of particularly pernicious races.
+ *
+ * For a closure to wait on an arbitrary event, we need to introduce waitlists:
+ *
+ * struct closure_waitlist list;
+ * closure_wait_event(list, cl, condition);
+ * closure_wake_up(wait_list);
+ *
+ * These work analagously to wait_event() and wake_up() - except that instead of
+ * operating on the current thread (for wait_event()) and lists of threads, they
+ * operate on an explicit closure and lists of closures.
+ *
+ * Because it's a closure we can now wait either synchronously or
+ * asynchronously. closure_wait_event() returns the current value of the
+ * condition, and if it returned false continue_at() or closure_sync() can be
+ * used to wait for it to become true.
+ *
+ * It's useful for waiting on things when you can't sleep in the context in
+ * which you must check the condition (perhaps a spinlock held, or you might be
+ * beneath generic_make_request() - in which case you can't sleep on IO).
+ *
+ * closure_wait_event() will wait either synchronously or asynchronously,
+ * depending on whether the closure is in blocking mode or not. You can pick a
+ * mode explicitly with closure_wait_event_sync() and
+ * closure_wait_event_async(), which do just what you might expect.
+ *
+ * Lastly, you might have a wait list dedicated to a specific event, and have no
+ * need for specifying the condition - you just want to wait until someone runs
+ * closure_wake_up() on the appropriate wait list. In that case, just use
+ * closure_wait(). It will return either true or false, depending on whether the
+ * closure was already on a wait list or not - a closure can only be on one wait
+ * list at a time.
+ *
+ * Parents:
+ *
+ * closure_init() takes two arguments - it takes the closure to initialize, and
+ * a (possibly null) parent.
+ *
+ * If parent is non null, the new closure will have a refcount for its lifetime;
+ * a closure is considered to be "finished" when its refcount hits 0 and the
+ * function to run is null. Hence
+ *
+ * continue_at(cl, NULL, NULL);
+ *
+ * returns up the (spaghetti) stack of closures, precisely like normal return
+ * returns up the C stack. continue_at() with non null fn is better thought of
+ * as doing a tail call.
+ *
+ * All this implies that a closure should typically be embedded in a particular
+ * struct (which its refcount will normally control the lifetime of), and that
+ * struct can very much be thought of as a stack frame.
+ */
+
+struct closure;
+typedef void (closure_fn) (struct closure *);
+
+struct closure_waitlist {
+	struct llist_head	list;
+};
+
+enum closure_state {
+	/*
+	 * CLOSURE_WAITING: Set iff the closure is on a waitlist. Must be set by
+	 * the thread that owns the closure, and cleared by the thread that's
+	 * waking up the closure.
+	 *
+	 * CLOSURE_SLEEPING: Must be set before a thread uses a closure to sleep
+	 * - indicates that cl->task is valid and closure_put() may wake it up.
+	 * Only set or cleared by the thread that owns the closure.
+	 *
+	 * The rest are for debugging and don't affect behaviour:
+	 *
+	 * CLOSURE_RUNNING: Set when a closure is running (i.e. by
+	 * closure_init() and when closure_put() runs then next function), and
+	 * must be cleared before remaining hits 0. Primarily to help guard
+	 * against incorrect usage and accidentally transferring references.
+	 * continue_at() and closure_return() clear it for you, if you're doing
+	 * something unusual you can use closure_set_dead() which also helps
+	 * annotate where references are being transferred.
+	 *
+	 * CLOSURE_STACK: Sanity check - remaining should never hit 0 on a
+	 * closure with this flag set
+	 */
+
+	CLOSURE_BITS_START	= (1 << 23),
+	CLOSURE_DESTRUCTOR	= (1 << 23),
+	CLOSURE_WAITING		= (1 << 25),
+	CLOSURE_SLEEPING	= (1 << 27),
+	CLOSURE_RUNNING		= (1 << 29),
+	CLOSURE_STACK		= (1 << 31),
+};
+
+#define CLOSURE_GUARD_MASK					\
+	((CLOSURE_DESTRUCTOR|CLOSURE_WAITING|CLOSURE_SLEEPING|	\
+	  CLOSURE_RUNNING|CLOSURE_STACK) << 1)
+
+#define CLOSURE_REMAINING_MASK		(CLOSURE_BITS_START - 1)
+#define CLOSURE_REMAINING_INITIALIZER	(1|CLOSURE_RUNNING)
+
+struct closure {
+	union {
+		struct {
+			struct workqueue_struct *wq;
+			struct task_struct	*task;
+			struct llist_node	list;
+			closure_fn		*fn;
+		};
+		struct work_struct	work;
+	};
+
+	struct closure		*parent;
+
+	atomic_t		remaining;
+
+#ifdef CONFIG_CLOSURE_DEBUG
+#define CLOSURE_MAGIC_DEAD	0xc054dead
+#define CLOSURE_MAGIC_ALIVE	0xc054a11e
+
+	unsigned		magic;
+	struct list_head	all;
+	unsigned long		ip;
+	unsigned long		waiting_on;
+#endif
+};
+
+void closure_sub(struct closure *cl, int v);
+void closure_put(struct closure *cl);
+void __closure_wake_up(struct closure_waitlist *list);
+bool closure_wait(struct closure_waitlist *list, struct closure *cl);
+void closure_sync(struct closure *cl);
+
+#ifdef CONFIG_CLOSURE_DEBUG
+
+void closure_debug_create(struct closure *cl);
+void closure_debug_destroy(struct closure *cl);
+
+#else
+
+static inline void closure_debug_create(struct closure *cl) {}
+static inline void closure_debug_destroy(struct closure *cl) {}
+
+#endif
+
+static inline void closure_set_ip(struct closure *cl)
+{
+#ifdef CONFIG_CLOSURE_DEBUG
+	cl->ip = _THIS_IP_;
+#endif
+}
+
+static inline void closure_set_ret_ip(struct closure *cl)
+{
+#ifdef CONFIG_CLOSURE_DEBUG
+	cl->ip = _RET_IP_;
+#endif
+}
+
+static inline void closure_set_waiting(struct closure *cl, unsigned long f)
+{
+#ifdef CONFIG_CLOSURE_DEBUG
+	cl->waiting_on = f;
+#endif
+}
+
+static inline void __closure_end_sleep(struct closure *cl)
+{
+	__set_current_state(TASK_RUNNING);
+
+	if (atomic_read(&cl->remaining) & CLOSURE_SLEEPING)
+		atomic_sub(CLOSURE_SLEEPING, &cl->remaining);
+}
+
+static inline void __closure_start_sleep(struct closure *cl)
+{
+	closure_set_ip(cl);
+	cl->task = current;
+	set_current_state(TASK_UNINTERRUPTIBLE);
+
+	if (!(atomic_read(&cl->remaining) & CLOSURE_SLEEPING))
+		atomic_add(CLOSURE_SLEEPING, &cl->remaining);
+}
+
+static inline void closure_set_stopped(struct closure *cl)
+{
+	atomic_sub(CLOSURE_RUNNING, &cl->remaining);
+}
+
+static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
+				  struct workqueue_struct *wq)
+{
+	BUG_ON(object_is_on_stack(cl));
+	closure_set_ip(cl);
+	cl->fn = fn;
+	cl->wq = wq;
+	/* between atomic_dec() in closure_put() */
+	smp_mb__before_atomic_dec();
+}
+
+static inline void closure_queue(struct closure *cl)
+{
+	struct workqueue_struct *wq = cl->wq;
+	if (wq) {
+		INIT_WORK(&cl->work, cl->work.func);
+		BUG_ON(!queue_work(wq, &cl->work));
+	} else
+		cl->fn(cl);
+}
+
+/**
+ * closure_get - increment a closure's refcount
+ */
+static inline void closure_get(struct closure *cl)
+{
+#ifdef CONFIG_CLOSURE_DEBUG
+	BUG_ON((atomic_inc_return(&cl->remaining) &
+		CLOSURE_REMAINING_MASK) <= 1);
+#else
+	atomic_inc(&cl->remaining);
+#endif
+}
+
+/**
+ * closure_init - Initialize a closure, setting the refcount to 1
+ * @cl:		closure to initialize
+ * @parent:	parent of the new closure. cl will take a refcount on it for its
+ *		lifetime; may be NULL.
+ */
+static inline void closure_init(struct closure *cl, struct closure *parent)
+{
+	memset(cl, 0, sizeof(struct closure));
+	cl->parent = parent;
+	if (parent)
+		closure_get(parent);
+
+	atomic_set(&cl->remaining, CLOSURE_REMAINING_INITIALIZER);
+
+	closure_debug_create(cl);
+	closure_set_ip(cl);
+}
+
+static inline void closure_init_stack(struct closure *cl)
+{
+	memset(cl, 0, sizeof(struct closure));
+	atomic_set(&cl->remaining, CLOSURE_REMAINING_INITIALIZER|CLOSURE_STACK);
+}
+
+/**
+ * closure_wake_up - wake up all closures on a wait list.
+ */
+static inline void closure_wake_up(struct closure_waitlist *list)
+{
+	smp_mb();
+	__closure_wake_up(list);
+}
+
+/**
+ * closure_wait_event - wait on arbitrary event
+ *
+ * Analogous to wait_event() but for closures.
+ *
+ * The loop is oddly structured so as to avoid a race; we must check the
+ * condition again after we've added ourself to the waitlist. We know if we were
+ * already on the waitlist because closure_wait() returns false; thus, we only
+ * schedule or break if closure_wait() returns false. If it returns true, we
+ * just loop again - rechecking the condition.
+ *
+ * The __closure_wake_up() is necessary because we may race with the event
+ * becoming true; i.e. we see event false -> wait -> recheck condition, but the
+ * thread that made the event true may have called closure_wake_up() before we
+ * added ourself to the wait list.
+ *
+ * We have to call closure_sync() at the end instead of just
+ * __closure_end_sleep() because a different thread might've called
+ * closure_wake_up() before us and gotten preempted before they dropped the
+ * refcount on our closure. If this was a stack allocated closure, that would be
+ * bad.
+ */
+#define closure_wait_event(list, cl, condition)				\
+({									\
+	typeof(condition) ret;						\
+									\
+	while (1) {							\
+		ret = (condition);					\
+		if (ret) {						\
+			__closure_wake_up(list);			\
+			closure_sync(cl);				\
+			break;						\
+		}							\
+									\
+		__closure_start_sleep(cl);				\
+									\
+		if (!closure_wait(list, cl))				\
+			schedule();					\
+	}								\
+									\
+	ret;								\
+})
+
+/**
+ * continue_at - jump to another function with barrier
+ *
+ * After @cl is no longer waiting on anything (i.e. all outstanding refs have
+ * been dropped with closure_put()), it will resume execution at @fn running out
+ * of @wq (or, if @wq is NULL, @fn will be called by closure_put() directly).
+ *
+ * NOTE: This macro expands to a return in the calling function!
+ *
+ * This is because after calling continue_at() you no longer have a ref on @cl,
+ * and whatever @cl owns may be freed out from under you - a running closure fn
+ * has a ref on its own closure which continue_at() drops.
+ */
+#define continue_at(_cl, _fn, _wq)					\
+do {									\
+	set_closure_fn(_cl, _fn, _wq);					\
+	closure_sub(_cl, CLOSURE_RUNNING + 1);				\
+	return;								\
+} while (0)
+
+/**
+ * closure_return - finish execution of a closure
+ *
+ * This is used to indicate that @cl is finished: when all outstanding refs on
+ * @cl have been dropped @cl's ref on its parent closure (as passed to
+ * closure_init()) will be dropped, if one was specified - thus this can be
+ * thought of as returning to the parent closure.
+ */
+#define closure_return(_cl)	continue_at((_cl), NULL, NULL)
+
+/**
+ * continue_at_nobarrier - jump to another function without barrier
+ *
+ * Causes @fn to be executed out of @cl, in @wq context (or called directly if
+ * @wq is NULL).
+ *
+ * NOTE: like continue_at(), this macro expands to a return in the caller!
+ *
+ * The ref the caller of continue_at_nobarrier() had on @cl is now owned by @fn,
+ * thus it's not safe to touch anything protected by @cl after a
+ * continue_at_nobarrier().
+ */
+#define continue_at_nobarrier(_cl, _fn, _wq)				\
+do {									\
+	set_closure_fn(_cl, _fn, _wq);					\
+	closure_queue(_cl);						\
+	return;								\
+} while (0)
+
+/**
+ * closure_return - finish execution of a closure, with destructor
+ *
+ * Works like closure_return(), except @destructor will be called when all
+ * outstanding refs on @cl have been dropped; @destructor may be used to safely
+ * free the memory occupied by @cl, and it is called with the ref on the parent
+ * closure still held - so @destructor could safely return an item to a
+ * freelist protected by @cl's parent.
+ */
+#define closure_return_with_destructor(_cl, _destructor)		\
+do {									\
+	set_closure_fn(_cl, _destructor, NULL);				\
+	closure_sub(_cl, CLOSURE_RUNNING - CLOSURE_DESTRUCTOR + 1);	\
+	return;								\
+} while (0)
+
+/**
+ * closure_call - execute @fn out of a new, uninitialized closure
+ *
+ * Typically used when running out of one closure, and we want to run @fn
+ * asynchronously out of a new closure - @parent will then wait for @cl to
+ * finish.
+ */
+static inline void closure_call(struct closure *cl, closure_fn fn,
+				struct workqueue_struct *wq,
+				struct closure *parent)
+{
+	closure_init(cl, parent);
+	continue_at_nobarrier(cl, fn, wq);
+}
+
+#endif /* _LINUX_CLOSURE_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index db25707aa4..0d1dbbf07a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1240,6 +1240,14 @@ config DEBUG_BLOCK_EXT_DEVT
 
 	  Say N if you are unsure.
 
+config CLOSURE_DEBUG
+	bool "Debug closures"
+	select DEBUG_FS
+	---help---
+	Keeps all active closures in a linked list and provides a debugfs
+	interface to list them, which makes it possible to see asynchronous
+	operations that get stuck.
+
 config NOTIFIER_ERROR_INJECTION
 	tristate "Notifier error injection"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index a459c31e8c..907c11b788 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -26,7 +26,7 @@ obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
-	 percpu-refcount.o percpu_ida.o
+	 percpu-refcount.o percpu_ida.o closure.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
diff --git a/lib/closure.c b/lib/closure.c
new file mode 100644
index 0000000000..10ec8a1711
--- /dev/null
+++ b/lib/closure.c
@@ -0,0 +1,218 @@
+/*
+ * Asynchronous refcounty things
+ *
+ * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
+ * Copyright 2012 Google, Inc.
+ */
+
+#include <linux/closure.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+static inline void closure_put_after_sub(struct closure *cl, int flags)
+{
+	int r = flags & CLOSURE_REMAINING_MASK;
+
+	BUG_ON(flags & CLOSURE_GUARD_MASK);
+	BUG_ON(!r && (flags & ~CLOSURE_DESTRUCTOR));
+
+	/* Must deliver precisely one wakeup */
+	if (r == 1 && (flags & CLOSURE_SLEEPING))
+		wake_up_process(cl->task);
+
+	if (!r) {
+		if (cl->fn && !(flags & CLOSURE_DESTRUCTOR)) {
+			atomic_set(&cl->remaining,
+				   CLOSURE_REMAINING_INITIALIZER);
+			closure_queue(cl);
+		} else {
+			struct closure *parent = cl->parent;
+			closure_fn *destructor = cl->fn;
+
+			closure_debug_destroy(cl);
+
+			if (destructor)
+				destructor(cl);
+
+			if (parent)
+				closure_put(parent);
+		}
+	}
+}
+
+/* For clearing flags with the same atomic op as a put */
+void closure_sub(struct closure *cl, int v)
+{
+	closure_put_after_sub(cl, atomic_sub_return(v, &cl->remaining));
+}
+EXPORT_SYMBOL(closure_sub);
+
+/**
+ * closure_put - decrement a closure's refcount
+ */
+void closure_put(struct closure *cl)
+{
+	closure_put_after_sub(cl, atomic_dec_return(&cl->remaining));
+}
+EXPORT_SYMBOL(closure_put);
+
+/**
+ * closure_wake_up - wake up all closures on a wait list, without memory barrier
+ */
+void __closure_wake_up(struct closure_waitlist *wait_list)
+{
+	struct llist_node *list;
+	struct closure *cl;
+	struct llist_node *reverse = NULL;
+
+	list = llist_del_all(&wait_list->list);
+
+	/* We first reverse the list to preserve FIFO ordering and fairness */
+
+	while (list) {
+		struct llist_node *t = list;
+		list = llist_next(list);
+
+		t->next = reverse;
+		reverse = t;
+	}
+
+	/* Then do the wakeups */
+
+	while (reverse) {
+		cl = container_of(reverse, struct closure, list);
+		reverse = llist_next(reverse);
+
+		closure_set_waiting(cl, 0);
+		closure_sub(cl, CLOSURE_WAITING + 1);
+	}
+}
+EXPORT_SYMBOL(__closure_wake_up);
+
+/**
+ * closure_wait - add a closure to a waitlist
+ *
+ * @waitlist will own a ref on @cl, which will be released when
+ * closure_wake_up() is called on @waitlist.
+ *
+ */
+bool closure_wait(struct closure_waitlist *waitlist, struct closure *cl)
+{
+	if (atomic_read(&cl->remaining) & CLOSURE_WAITING)
+		return false;
+
+	closure_set_waiting(cl, _RET_IP_);
+	atomic_add(CLOSURE_WAITING + 1, &cl->remaining);
+	llist_add(&cl->list, &waitlist->list);
+
+	return true;
+}
+EXPORT_SYMBOL(closure_wait);
+
+/**
+ * closure_sync - sleep until a closure a closure has nothing left to wait on
+ *
+ * Sleeps until the refcount hits 1 - the thread that's running the closure owns
+ * the last refcount.
+ */
+void closure_sync(struct closure *cl)
+{
+	while (1) {
+		__closure_start_sleep(cl);
+		closure_set_ret_ip(cl);
+
+		if ((atomic_read(&cl->remaining) &
+		     CLOSURE_REMAINING_MASK) == 1)
+			break;
+
+		schedule();
+	}
+
+	__closure_end_sleep(cl);
+}
+EXPORT_SYMBOL(closure_sync);
+
+#ifdef CONFIG_CLOSURE_DEBUG
+
+static LIST_HEAD(closure_list);
+static DEFINE_SPINLOCK(closure_list_lock);
+
+void closure_debug_create(struct closure *cl)
+{
+	unsigned long flags;
+
+	BUG_ON(cl->magic == CLOSURE_MAGIC_ALIVE);
+	cl->magic = CLOSURE_MAGIC_ALIVE;
+
+	spin_lock_irqsave(&closure_list_lock, flags);
+	list_add(&cl->all, &closure_list);
+	spin_unlock_irqrestore(&closure_list_lock, flags);
+}
+EXPORT_SYMBOL(closure_debug_create);
+
+void closure_debug_destroy(struct closure *cl)
+{
+	unsigned long flags;
+
+	BUG_ON(cl->magic != CLOSURE_MAGIC_ALIVE);
+	cl->magic = CLOSURE_MAGIC_DEAD;
+
+	spin_lock_irqsave(&closure_list_lock, flags);
+	list_del(&cl->all);
+	spin_unlock_irqrestore(&closure_list_lock, flags);
+}
+EXPORT_SYMBOL(closure_debug_destroy);
+
+static struct dentry *debug;
+
+#define work_data_bits(work) ((unsigned long *)(&(work)->data))
+
+static int debug_seq_show(struct seq_file *f, void *data)
+{
+	struct closure *cl;
+	spin_lock_irq(&closure_list_lock);
+
+	list_for_each_entry(cl, &closure_list, all) {
+		int r = atomic_read(&cl->remaining);
+
+		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
+			   cl, (void *) cl->ip, cl->fn, cl->parent,
+			   r & CLOSURE_REMAINING_MASK);
+
+		seq_printf(f, "%s%s%s%s\n",
+			   test_bit(WORK_STRUCT_PENDING,
+				    work_data_bits(&cl->work)) ? "Q" : "",
+			   r & CLOSURE_RUNNING	? "R" : "",
+			   r & CLOSURE_STACK	? "S" : "",
+			   r & CLOSURE_SLEEPING	? "Sl" : "");
+
+		if (r & CLOSURE_WAITING)
+			seq_printf(f, " W %pF\n",
+				   (void *) cl->waiting_on);
+
+		seq_printf(f, "\n");
+	}
+
+	spin_unlock_irq(&closure_list_lock);
+	return 0;
+}
+
+static int debug_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_seq_show, NULL);
+}
+
+static const struct file_operations debug_ops = {
+	.open		= debug_seq_open,
+	.read		= seq_read,
+	.release	= single_release
+};
+
+static int __init closure_debug_init(void)
+{
+	debug = debugfs_create_file("closures", 0400, NULL, NULL, &debug_ops);
+	return 0;
+}
+late_initcall(closure_debug_init);
+
+#endif
-- 
1.8.5.1

