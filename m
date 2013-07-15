Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3GONLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:11:33 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38467 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab3GONL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:11:29 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Oleg Drokin <oleg.drokin@intel.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 12/17] staging/lustre: fix build error on non-x86 platforms
Date: Mon, 15 Jul 2013 21:08:10 +0800
Message-Id: <1373893695-4094-13-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
References: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_trace() is only available on X86. Without it, Lustre's own
watchdog is broken. We can only dump current task's stack.

The client-side this code is much less likely to hit deadlocks and
it's probably OK to drop this altogether, since we hardly have any
ptlrpc threads on clients, most notable ones are ldlm cb threads
that should not really be blocking on the client anyway.

Remove libcfs watchdog for now, until the upstream kernel watchdog
can detect distributed deadlocks and dump other kernel threads.

Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/include/linux/libcfs/libcfs.h   |   25 -
 .../lustre/include/linux/libcfs/libcfs_private.h   |    1 -
 drivers/staging/lustre/lustre/include/linux/obd.h  |    5 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |    7 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    2 +-
 drivers/staging/lustre/lustre/libcfs/Makefile      |    2 +-
 .../lustre/lustre/libcfs/linux/linux-debug.c       |   45 +-
 drivers/staging/lustre/lustre/libcfs/watchdog.c    |  516 --------------------
 drivers/staging/lustre/lustre/llite/dcache.c       |    2 +-
 drivers/staging/lustre/lustre/llite/rw.c           |    2 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |    8 +
 12 files changed, 21 insertions(+), 596 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/watchdog.c

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs.h b/drivers/staging/lustre/include/linux/libcfs/libcfs.h
index 1ab1f2b..2983ce4 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs.h
@@ -117,31 +117,6 @@ int libcfs_sock_write(socket_t *sock, void *buffer, int nob, int timeout);
 int libcfs_sock_read(socket_t *sock, void *buffer, int nob, int timeout);
 void libcfs_sock_release(socket_t *sock);
 
-/* libcfs watchdogs */
-struct lc_watchdog;
-
-/* Add a watchdog which fires after "time" milliseconds of delay.  You have to
- * touch it once to enable it. */
-struct lc_watchdog *lc_watchdog_add(int time,
-				    void (*cb)(pid_t pid, void *),
-				    void *data);
-
-/* Enables a watchdog and resets its timer. */
-void lc_watchdog_touch(struct lc_watchdog *lcw, int timeout);
-#define CFS_GET_TIMEOUT(svc) (max_t(int, obd_timeout,		   \
-			  AT_OFF ? 0 : at_get(&svc->srv_at_estimate)) * \
-			  svc->srv_watchdog_factor)
-
-/* Disable a watchdog; touch it to restart it. */
-void lc_watchdog_disable(struct lc_watchdog *lcw);
-
-/* Clean up the watchdog */
-void lc_watchdog_delete(struct lc_watchdog *lcw);
-
-/* Dump a debug log */
-void lc_watchdog_dumplog(pid_t pid, void *data);
-
-
 /* need both kernel and user-land acceptor */
 #define LNET_ACCEPTOR_MIN_RESERVED_PORT    512
 #define LNET_ACCEPTOR_MAX_RESERVED_PORT    1023
diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
index 056caa4..62ef8a7 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
@@ -210,7 +210,6 @@ do {								    \
 #define ntohs(x) ___ntohs(x)
 #endif
 
-void libcfs_debug_dumpstack(task_t *tsk);
 void libcfs_run_upcall(char **argv);
 void libcfs_run_lbug_upcall(struct libcfs_debug_msg_data *);
 void libcfs_debug_dumplog(void);
diff --git a/drivers/staging/lustre/lustre/include/linux/obd.h b/drivers/staging/lustre/lustre/include/linux/obd.h
index 2c36c0d..01a5026 100644
--- a/drivers/staging/lustre/lustre/include/linux/obd.h
+++ b/drivers/staging/lustre/lustre/include/linux/obd.h
@@ -93,11 +93,8 @@ static inline void __client_obd_list_lock(client_obd_lock_t *lock,
 				      lock, task->comm, task->pid,
 				      lock->func, lock->line,
 				      (jiffies - lock->time) / HZ);
-			LCONSOLE_WARN("====== for process holding the "
-				      "lock =====\n");
-			libcfs_debug_dumpstack(task);
 			LCONSOLE_WARN("====== for current process =====\n");
-			libcfs_debug_dumpstack(NULL);
+			dump_stack();
 			LCONSOLE_WARN("====== end =======\n");
 			cfs_pause(1000 * HZ);
 		}
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 293dd90..1b99b5d 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -2322,8 +2322,13 @@ struct ptlrpc_thread {
 	pid_t t_pid;
 	/**
 	 * put watchdog in the structure per thread b=14840
+	 *
+	 * Lustre watchdog is removed for client in the hope
+	 * of a generic watchdog can be merged in kernel.
+	 * When that happens, we should add below back.
+	 *
+	 * struct lc_watchdog *t_watchdog;
 	 */
-	struct lc_watchdog *t_watchdog;
 	/**
 	 * the svc this thread belonged to b=18582
 	 */
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 33b76a1..93badf5 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -1548,7 +1548,7 @@ int ldlm_fill_lvb(struct ldlm_lock *lock, struct req_capsule *pill,
 		break;
 	default:
 		LDLM_ERROR(lock, "Unknown LVB type: %d\n", lock->l_lvb_type);
-		libcfs_debug_dumpstack(NULL);
+		dump_stack();
 		RETURN(-EINVAL);
 	}
 
diff --git a/drivers/staging/lustre/lustre/libcfs/Makefile b/drivers/staging/lustre/lustre/libcfs/Makefile
index bf5c563..6e489d7 100644
--- a/drivers/staging/lustre/lustre/libcfs/Makefile
+++ b/drivers/staging/lustre/lustre/libcfs/Makefile
@@ -11,7 +11,7 @@ libcfs-linux-objs += linux-crypto-adler.o
 libcfs-linux-objs := $(addprefix linux/,$(libcfs-linux-objs))
 
 libcfs-all-objs := debug.o fail.o nidstrings.o module.o tracefile.o \
-		   watchdog.o libcfs_string.o hash.o kernel_user_comm.o \
+		   libcfs_string.o hash.o kernel_user_comm.o \
 		   prng.o workitem.o upcall_cache.o libcfs_cpu.o \
 		   libcfs_mem.o libcfs_lock.o
 
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
index e2c195b..9b5fa91 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
@@ -168,7 +168,7 @@ void lbug_with_loc(struct libcfs_debug_msg_data *msgdata)
 		/* not reached */
 	}
 
-	libcfs_debug_dumpstack(NULL);
+	dump_stack();
 	if (!libcfs_panic_on_lbug)
 		libcfs_debug_dumplog();
 	libcfs_run_lbug_upcall(msgdata);
@@ -179,48 +179,6 @@ void lbug_with_loc(struct libcfs_debug_msg_data *msgdata)
 		schedule();
 }
 
-
-#include <linux/nmi.h>
-#include <asm/stacktrace.h>
-
-
-static int print_trace_stack(void *data, char *name)
-{
-	printk(" <%s> ", name);
-	return 0;
-}
-
-# define RELIABLE reliable
-# define DUMP_TRACE_CONST const
-static void print_trace_address(void *data, unsigned long addr, int reliable)
-{
-	char fmt[32];
-	touch_nmi_watchdog();
-	sprintf(fmt, " [<%016lx>] %s%%s\n", addr, RELIABLE ? "": "? ");
-	__print_symbol(fmt, addr);
-}
-
-static DUMP_TRACE_CONST struct stacktrace_ops print_trace_ops = {
-	.stack = print_trace_stack,
-	.address = print_trace_address,
-	.walk_stack = print_context_stack,
-};
-
-void libcfs_debug_dumpstack(struct task_struct *tsk)
-{
-	/* dump_stack() */
-	/* show_trace() */
-	if (tsk == NULL)
-		tsk = current;
-	printk("Pid: %d, comm: %.20s\n", tsk->pid, tsk->comm);
-	/* show_trace_log_lvl() */
-	printk("\nCall Trace:\n");
-	dump_trace(tsk, NULL, NULL,
-		   0,
-		   &print_trace_ops, NULL);
-	printk("\n");
-}
-
 task_t *libcfs_current(void)
 {
 	CWARN("current task struct is %p\n", current);
@@ -255,7 +213,6 @@ void libcfs_unregister_panic_notifier(void)
 	atomic_notifier_chain_unregister(&panic_notifier_list, &libcfs_panic_notifier);
 }
 
-EXPORT_SYMBOL(libcfs_debug_dumpstack);
 EXPORT_SYMBOL(libcfs_current);
 
 
diff --git a/drivers/staging/lustre/lustre/libcfs/watchdog.c b/drivers/staging/lustre/lustre/libcfs/watchdog.c
deleted file mode 100644
index 7c385ad..0000000
--- a/drivers/staging/lustre/lustre/libcfs/watchdog.c
+++ /dev/null
@@ -1,516 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2008, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * libcfs/libcfs/watchdog.c
- *
- * Author: Jacob Berkman <jacob@clusterfs.com>
- */
-
-#define DEBUG_SUBSYSTEM S_LNET
-
-#include <linux/libcfs/libcfs.h>
-#include "tracefile.h"
-
-struct lc_watchdog {
-	spinlock_t  lcw_lock;     /* check or change lcw_list */
-	int	     lcw_refcount; /* must hold lcw_pending_timers_lock */
-	timer_list_t     lcw_timer;    /* kernel timer */
-	struct list_head      lcw_list;     /* chain on pending list */
-	cfs_time_t      lcw_last_touched; /* last touched stamp */
-	task_t     *lcw_task;     /* owner task */
-	void	  (*lcw_callback)(pid_t, void *);
-	void	   *lcw_data;
-
-	pid_t	   lcw_pid;
-
-	enum {
-		LC_WATCHDOG_DISABLED,
-		LC_WATCHDOG_ENABLED,
-		LC_WATCHDOG_EXPIRED
-	} lcw_state;
-};
-
-#ifdef WITH_WATCHDOG
-/*
- * The dispatcher will complete lcw_start_completion when it starts,
- * and lcw_stop_completion when it exits.
- * Wake lcw_event_waitq to signal timer callback dispatches.
- */
-static struct completion lcw_start_completion;
-static struct completion  lcw_stop_completion;
-static wait_queue_head_t lcw_event_waitq;
-
-/*
- * Set this and wake lcw_event_waitq to stop the dispatcher.
- */
-enum {
-	LCW_FLAG_STOP = 0
-};
-static unsigned long lcw_flags = 0;
-
-/*
- * Number of outstanding watchdogs.
- * When it hits 1, we start the dispatcher.
- * When it hits 0, we stop the dispatcher.
- */
-static __u32	 lcw_refcount = 0;
-static DEFINE_MUTEX(lcw_refcount_mutex);
-
-/*
- * List of timers that have fired that need their callbacks run by the
- * dispatcher.
- */
-/* BH lock! */
-static DEFINE_SPINLOCK(lcw_pending_timers_lock);
-static struct list_head lcw_pending_timers = LIST_HEAD_INIT(lcw_pending_timers);
-
-/* Last time a watchdog expired */
-static cfs_time_t lcw_last_watchdog_time;
-static int lcw_recent_watchdog_count;
-
-static void
-lcw_dump(struct lc_watchdog *lcw)
-{
-	ENTRY;
-	rcu_read_lock();
-       if (lcw->lcw_task == NULL) {
-		LCONSOLE_WARN("Process " LPPID " was not found in the task "
-			      "list; watchdog callback may be incomplete\n",
-			      (int)lcw->lcw_pid);
-	} else {
-		libcfs_debug_dumpstack(lcw->lcw_task);
-	}
-
-	rcu_read_unlock();
-	EXIT;
-}
-
-static void lcw_cb(ulong_ptr_t data)
-{
-	struct lc_watchdog *lcw = (struct lc_watchdog *)data;
-	ENTRY;
-
-	if (lcw->lcw_state != LC_WATCHDOG_ENABLED) {
-		EXIT;
-		return;
-	}
-
-	lcw->lcw_state = LC_WATCHDOG_EXPIRED;
-
-	spin_lock_bh(&lcw->lcw_lock);
-	LASSERT(list_empty(&lcw->lcw_list));
-
-	spin_lock_bh(&lcw_pending_timers_lock);
-	lcw->lcw_refcount++; /* +1 for pending list */
-	list_add(&lcw->lcw_list, &lcw_pending_timers);
-	wake_up(&lcw_event_waitq);
-
-	spin_unlock_bh(&lcw_pending_timers_lock);
-	spin_unlock_bh(&lcw->lcw_lock);
-	EXIT;
-}
-
-static int is_watchdog_fired(void)
-{
-	int rc;
-
-	if (test_bit(LCW_FLAG_STOP, &lcw_flags))
-		return 1;
-
-	spin_lock_bh(&lcw_pending_timers_lock);
-	rc = !list_empty(&lcw_pending_timers);
-	spin_unlock_bh(&lcw_pending_timers_lock);
-	return rc;
-}
-
-static void lcw_dump_stack(struct lc_watchdog *lcw)
-{
-	cfs_time_t      current_time;
-	cfs_duration_t  delta_time;
-	struct timeval  timediff;
-
-	current_time = cfs_time_current();
-	delta_time = cfs_time_sub(current_time, lcw->lcw_last_touched);
-	cfs_duration_usec(delta_time, &timediff);
-
-	/*
-	 * Check to see if we should throttle the watchdog timer to avoid
-	 * too many dumps going to the console thus triggering an NMI.
-	 */
-	delta_time = cfs_duration_sec(cfs_time_sub(current_time,
-						   lcw_last_watchdog_time));
-
-	if (delta_time < libcfs_watchdog_ratelimit &&
-	    lcw_recent_watchdog_count > 3) {
-		LCONSOLE_WARN("Service thread pid %u was inactive for "
-			      "%lu.%.02lus. Watchdog stack traces are limited "
-			      "to 3 per %d seconds, skipping this one.\n",
-			      (int)lcw->lcw_pid,
-			      timediff.tv_sec,
-			      timediff.tv_usec / 10000,
-			      libcfs_watchdog_ratelimit);
-	} else {
-		if (delta_time < libcfs_watchdog_ratelimit) {
-			lcw_recent_watchdog_count++;
-		} else {
-			memcpy(&lcw_last_watchdog_time, &current_time,
-			       sizeof(current_time));
-			lcw_recent_watchdog_count = 0;
-		}
-
-		LCONSOLE_WARN("Service thread pid %u was inactive for "
-			      "%lu.%.02lus. The thread might be hung, or it "
-			      "might only be slow and will resume later. "
-			      "Dumping the stack trace for debugging purposes:"
-			      "\n",
-			      (int)lcw->lcw_pid,
-			      timediff.tv_sec,
-			      timediff.tv_usec / 10000);
-		lcw_dump(lcw);
-	}
-}
-
-static int lcw_dispatch_main(void *data)
-{
-	int		 rc = 0;
-	struct lc_watchdog *lcw;
-	LIST_HEAD      (zombies);
-
-	ENTRY;
-
-	complete(&lcw_start_completion);
-
-	while (1) {
-		int dumplog = 1;
-
-		cfs_wait_event_interruptible(lcw_event_waitq,
-					     is_watchdog_fired(), rc);
-		CDEBUG(D_INFO, "Watchdog got woken up...\n");
-		if (test_bit(LCW_FLAG_STOP, &lcw_flags)) {
-			CDEBUG(D_INFO, "LCW_FLAG_STOP set, shutting down...\n");
-
-			spin_lock_bh(&lcw_pending_timers_lock);
-			rc = !list_empty(&lcw_pending_timers);
-			spin_unlock_bh(&lcw_pending_timers_lock);
-			if (rc) {
-				CERROR("pending timers list was not empty at "
-				       "time of watchdog dispatch shutdown\n");
-			}
-			break;
-		}
-
-		spin_lock_bh(&lcw_pending_timers_lock);
-		while (!list_empty(&lcw_pending_timers)) {
-			int is_dumplog;
-
-			lcw = list_entry(lcw_pending_timers.next,
-					     struct lc_watchdog, lcw_list);
-			/* +1 ref for callback to make sure lwc wouldn't be
-			 * deleted after releasing lcw_pending_timers_lock */
-			lcw->lcw_refcount++;
-			spin_unlock_bh(&lcw_pending_timers_lock);
-
-			/* lock ordering */
-			spin_lock_bh(&lcw->lcw_lock);
-			spin_lock_bh(&lcw_pending_timers_lock);
-
-			if (list_empty(&lcw->lcw_list)) {
-				/* already removed from pending list */
-				lcw->lcw_refcount--; /* -1 ref for callback */
-				if (lcw->lcw_refcount == 0)
-					list_add(&lcw->lcw_list, &zombies);
-				spin_unlock_bh(&lcw->lcw_lock);
-				/* still hold lcw_pending_timers_lock */
-				continue;
-			}
-
-			list_del_init(&lcw->lcw_list);
-			lcw->lcw_refcount--; /* -1 ref for pending list */
-
-			spin_unlock_bh(&lcw_pending_timers_lock);
-			spin_unlock_bh(&lcw->lcw_lock);
-
-			CDEBUG(D_INFO, "found lcw for pid " LPPID "\n",
-			       lcw->lcw_pid);
-			lcw_dump_stack(lcw);
-
-			is_dumplog = lcw->lcw_callback == lc_watchdog_dumplog;
-			if (lcw->lcw_state != LC_WATCHDOG_DISABLED &&
-			    (dumplog || !is_dumplog)) {
-				lcw->lcw_callback(lcw->lcw_pid, lcw->lcw_data);
-				if (dumplog && is_dumplog)
-					dumplog = 0;
-			}
-
-			spin_lock_bh(&lcw_pending_timers_lock);
-			lcw->lcw_refcount--; /* -1 ref for callback */
-			if (lcw->lcw_refcount == 0)
-				list_add(&lcw->lcw_list, &zombies);
-		}
-		spin_unlock_bh(&lcw_pending_timers_lock);
-
-		while (!list_empty(&zombies)) {
-			lcw = list_entry(lcw_pending_timers.next,
-					 struct lc_watchdog, lcw_list);
-			list_del(&lcw->lcw_list);
-			LIBCFS_FREE(lcw, sizeof(*lcw));
-		}
-	}
-
-	complete(&lcw_stop_completion);
-
-	RETURN(rc);
-}
-
-static void lcw_dispatch_start(void)
-{
-	task_t *task;
-
-	ENTRY;
-	LASSERT(lcw_refcount == 1);
-
-	init_completion(&lcw_stop_completion);
-	init_completion(&lcw_start_completion);
-	init_waitqueue_head(&lcw_event_waitq);
-
-	CDEBUG(D_INFO, "starting dispatch thread\n");
-	task = kthread_run(lcw_dispatch_main, NULL, "lc_watchdogd");
-	if (IS_ERR(task)) {
-		CERROR("error spawning watchdog dispatch thread: %ld\n",
-			PTR_ERR(task));
-		EXIT;
-		return;
-	}
-	wait_for_completion(&lcw_start_completion);
-	CDEBUG(D_INFO, "watchdog dispatcher initialization complete.\n");
-
-	EXIT;
-}
-
-static void lcw_dispatch_stop(void)
-{
-	ENTRY;
-	LASSERT(lcw_refcount == 0);
-
-	CDEBUG(D_INFO, "trying to stop watchdog dispatcher.\n");
-
-	set_bit(LCW_FLAG_STOP, &lcw_flags);
-	wake_up(&lcw_event_waitq);
-
-	wait_for_completion(&lcw_stop_completion);
-
-	CDEBUG(D_INFO, "watchdog dispatcher has shut down.\n");
-
-	EXIT;
-}
-
-struct lc_watchdog *lc_watchdog_add(int timeout,
-				    void (*callback)(pid_t, void *),
-				    void *data)
-{
-	struct lc_watchdog *lcw = NULL;
-	ENTRY;
-
-	LIBCFS_ALLOC(lcw, sizeof(*lcw));
-	if (lcw == NULL) {
-		CDEBUG(D_INFO, "Could not allocate new lc_watchdog\n");
-		RETURN(ERR_PTR(-ENOMEM));
-	}
-
-	spin_lock_init(&lcw->lcw_lock);
-	lcw->lcw_refcount = 1; /* refcount for owner */
-	lcw->lcw_task     = current;
-	lcw->lcw_pid      = current_pid();
-	lcw->lcw_callback = (callback != NULL) ? callback : lc_watchdog_dumplog;
-	lcw->lcw_data     = data;
-	lcw->lcw_state    = LC_WATCHDOG_DISABLED;
-
-	INIT_LIST_HEAD(&lcw->lcw_list);
-	cfs_timer_init(&lcw->lcw_timer, lcw_cb, lcw);
-
-	mutex_lock(&lcw_refcount_mutex);
-	if (++lcw_refcount == 1)
-		lcw_dispatch_start();
-	mutex_unlock(&lcw_refcount_mutex);
-
-	/* Keep this working in case we enable them by default */
-	if (lcw->lcw_state == LC_WATCHDOG_ENABLED) {
-		lcw->lcw_last_touched = cfs_time_current();
-		cfs_timer_arm(&lcw->lcw_timer, cfs_time_seconds(timeout) +
-			      cfs_time_current());
-	}
-
-	RETURN(lcw);
-}
-EXPORT_SYMBOL(lc_watchdog_add);
-
-static void lcw_update_time(struct lc_watchdog *lcw, const char *message)
-{
-	cfs_time_t newtime = cfs_time_current();;
-
-	if (lcw->lcw_state == LC_WATCHDOG_EXPIRED) {
-		struct timeval timediff;
-		cfs_time_t delta_time = cfs_time_sub(newtime,
-						     lcw->lcw_last_touched);
-		cfs_duration_usec(delta_time, &timediff);
-
-		LCONSOLE_WARN("Service thread pid %u %s after %lu.%.02lus. "
-			      "This indicates the system was overloaded (too "
-			      "many service threads, or there were not enough "
-			      "hardware resources).\n",
-			      lcw->lcw_pid,
-			      message,
-			      timediff.tv_sec,
-			      timediff.tv_usec / 10000);
-	}
-	lcw->lcw_last_touched = newtime;
-}
-
-static void lc_watchdog_del_pending(struct lc_watchdog *lcw)
-{
-	spin_lock_bh(&lcw->lcw_lock);
-	if (unlikely(!list_empty(&lcw->lcw_list))) {
-		spin_lock_bh(&lcw_pending_timers_lock);
-		list_del_init(&lcw->lcw_list);
-		lcw->lcw_refcount--; /* -1 ref for pending list */
-		spin_unlock_bh(&lcw_pending_timers_lock);
-	}
-
-	spin_unlock_bh(&lcw->lcw_lock);
-}
-
-void lc_watchdog_touch(struct lc_watchdog *lcw, int timeout)
-{
-	ENTRY;
-	LASSERT(lcw != NULL);
-
-	lc_watchdog_del_pending(lcw);
-
-	lcw_update_time(lcw, "resumed");
-	lcw->lcw_state = LC_WATCHDOG_ENABLED;
-
-	cfs_timer_arm(&lcw->lcw_timer, cfs_time_current() +
-		      cfs_time_seconds(timeout));
-
-	EXIT;
-}
-EXPORT_SYMBOL(lc_watchdog_touch);
-
-void lc_watchdog_disable(struct lc_watchdog *lcw)
-{
-	ENTRY;
-	LASSERT(lcw != NULL);
-
-	lc_watchdog_del_pending(lcw);
-
-	lcw_update_time(lcw, "completed");
-	lcw->lcw_state = LC_WATCHDOG_DISABLED;
-
-	EXIT;
-}
-EXPORT_SYMBOL(lc_watchdog_disable);
-
-void lc_watchdog_delete(struct lc_watchdog *lcw)
-{
-	int dead;
-
-	ENTRY;
-	LASSERT(lcw != NULL);
-
-	cfs_timer_disarm(&lcw->lcw_timer);
-
-	lcw_update_time(lcw, "stopped");
-
-	spin_lock_bh(&lcw->lcw_lock);
-	spin_lock_bh(&lcw_pending_timers_lock);
-	if (unlikely(!list_empty(&lcw->lcw_list))) {
-		list_del_init(&lcw->lcw_list);
-		lcw->lcw_refcount--; /* -1 ref for pending list */
-	}
-
-	lcw->lcw_refcount--; /* -1 ref for owner */
-	dead = lcw->lcw_refcount == 0;
-	spin_unlock_bh(&lcw_pending_timers_lock);
-	spin_unlock_bh(&lcw->lcw_lock);
-
-	if (dead)
-		LIBCFS_FREE(lcw, sizeof(*lcw));
-
-	mutex_lock(&lcw_refcount_mutex);
-	if (--lcw_refcount == 0)
-		lcw_dispatch_stop();
-	mutex_unlock(&lcw_refcount_mutex);
-
-	EXIT;
-}
-EXPORT_SYMBOL(lc_watchdog_delete);
-
-/*
- * Provided watchdog handlers
- */
-
-void lc_watchdog_dumplog(pid_t pid, void *data)
-{
-	libcfs_debug_dumplog_internal((void *)((long_ptr_t)pid));
-}
-EXPORT_SYMBOL(lc_watchdog_dumplog);
-
-#else   /* !defined(WITH_WATCHDOG) */
-
-struct lc_watchdog *lc_watchdog_add(int timeout,
-				    void (*callback)(pid_t pid, void *),
-				    void *data)
-{
-	static struct lc_watchdog      watchdog;
-	return &watchdog;
-}
-EXPORT_SYMBOL(lc_watchdog_add);
-
-void lc_watchdog_touch(struct lc_watchdog *lcw, int timeout)
-{
-}
-EXPORT_SYMBOL(lc_watchdog_touch);
-
-void lc_watchdog_disable(struct lc_watchdog *lcw)
-{
-}
-EXPORT_SYMBOL(lc_watchdog_disable);
-
-void lc_watchdog_delete(struct lc_watchdog *lcw)
-{
-}
-EXPORT_SYMBOL(lc_watchdog_delete);
-
-#endif
diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
index ff0d085..40b0f3b 100644
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -300,7 +300,7 @@ void ll_invalidate_aliases(struct inode *inode)
 			CERROR("called on root (?) dentry=%p, inode=%p "
 			       "ino=%lu\n", dentry, inode, inode->i_ino);
 			lustre_dump_dentry(dentry, 1);
-			libcfs_debug_dumpstack(NULL);
+			dump_stack();
 		}
 
 		d_lustre_invalidate(dentry, 0);
diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index fac1178..f48766e 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -132,7 +132,7 @@ static struct ll_cl_context *ll_cl_init(struct file *file,
 			 * add dirty pages into cache during truncate */
 			CERROR("Proc %s is dirting page w/o inode lock, this"
 			       "will break truncate.\n", current->comm);
-			libcfs_debug_dumpstack(NULL);
+			dump_stack();
 			LBUG();
 			return ERR_PTR(-EIO);
 		}
diff --git a/drivers/staging/lustre/lustre/osc/osc_io.c b/drivers/staging/lustre/lustre/osc/osc_io.c
index 1b27704..70aad1a 100644
--- a/drivers/staging/lustre/lustre/osc/osc_io.c
+++ b/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -785,7 +785,7 @@ static void osc_req_attr_set(const struct lu_env *env,
 					      "no cover page!\n");
 			CL_PAGE_DEBUG(D_ERROR, env, apage,
 				      "dump uncover page!\n");
-			libcfs_debug_dumpstack(NULL);
+			dump_stack();
 			LBUG();
 		}
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index cd1bab5..6871711 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -2254,7 +2254,9 @@ ptlrpc_wait_event(struct ptlrpc_service_part *svcpt,
 	struct l_wait_info lwi = LWI_TIMEOUT(svcpt->scp_rqbd_timeout,
 					     ptlrpc_retry_rqbds, svcpt);
 
+	/* XXX: Add this back when libcfs watchdog is merged upstream
 	lc_watchdog_disable(thread->t_watchdog);
+	 */
 
 	cond_resched();
 
@@ -2268,8 +2270,10 @@ ptlrpc_wait_event(struct ptlrpc_service_part *svcpt,
 	if (ptlrpc_thread_stopping(thread))
 		return -EINTR;
 
+	/*
 	lc_watchdog_touch(thread->t_watchdog,
 			  ptlrpc_server_get_timeout(svcpt));
+	 */
 	return 0;
 }
 
@@ -2372,8 +2376,10 @@ static int ptlrpc_main(void *arg)
 	/* wake up our creator in case he's still waiting. */
 	wake_up(&thread->t_ctl_waitq);
 
+	/*
 	thread->t_watchdog = lc_watchdog_add(ptlrpc_server_get_timeout(svcpt),
 					     NULL, NULL);
+	 */
 
 	spin_lock(&svcpt->scp_rep_lock);
 	list_add(&rs->rs_list, &svcpt->scp_rep_idle);
@@ -2428,8 +2434,10 @@ static int ptlrpc_main(void *arg)
 		}
 	}
 
+	/*
 	lc_watchdog_delete(thread->t_watchdog);
 	thread->t_watchdog = NULL;
+	*/
 
 out_srv_fini:
 	/*
-- 
1.7.9.5

