Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaFARy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 13:54:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbaFARy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 13:54:27 -0400
Date: Sun, 1 Jun 2014 13:53:11 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
cc: chegu_vinod@hp.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, Jason Low <jason.low2@hp.com>
Subject: [PATCH] fix a race condition in cancelable mcs spinlocks
Message-ID: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cancelable MCS spinlocks introduced in
fb0527bd5ea99bfeb2dd91e3c1433ecf745d6b99 break the kernel on PA-RISC.

How to reproduce:
* Use a machine with two dual-core PA-8900 processors.
* Run the LVM testsuite and compile the kernel in an endless loop at the
  same time.
* Wait for an hour or two and the kernel locks up.

You see some processes locked up in osd_lock and osq_unlock:
INFO: rcu_sched self-detected stall on CPU { 2}  (t=18000 jiffies g=247335 c=247334 q=101)
CPU: 2 PID: 21006 Comm: lvm Tainted: G           O  3.15.0-rc7 #9
Backtrace:
 [<000000004013e8a4>] show_stack+0x14/0x20
 [<00000000403016f0>] dump_stack+0x88/0x100
 [<00000000401b8738>] rcu_check_callbacks+0x4a8/0x900
 [<00000000401714c4>] update_process_times+0x64/0xc0
 [<000000004013fa24>] timer_interrupt+0x19c/0x200
 [<00000000401ad8d8>] handle_irq_event_percpu+0xa8/0x238
 [<00000000401b2454>] handle_percpu_irq+0x9c/0xd0
 [<00000000401acc40>] generic_handle_irq+0x40/0x50
 [<00000000401408cc>] do_cpu_irq_mask+0x1ac/0x298
 [<000000004012c074>] intr_return+0x0/0xc
 [<00000000401a609c>] osq_lock+0xc4/0x178
 [<0000000040138d24>] __mutex_lock_slowpath+0x1cc/0x290
 [<0000000040138e78>] mutex_lock+0x90/0x98
 [<00000000402a5614>] kernfs_activate+0x6c/0x1a0
 [<00000000402a59e0>] kernfs_add_one+0x140/0x190
 [<00000000402a75ec>] __kernfs_create_file+0xa4/0xf8

INFO: rcu_sched self-detected stall on CPU { 3}  (t=18473 jiffies g=247335 c=247334 q=101)
CPU: 3 PID: 21051 Comm: udevd Tainted: G           O  3.15.0-rc7 #9
Backtrace:
 [<000000004013e8a4>] show_stack+0x14/0x20
 [<00000000403016f0>] dump_stack+0x88/0x100
 [<00000000401b8738>] rcu_check_callbacks+0x4a8/0x900
 [<00000000401714c4>] update_process_times+0x64/0xc0
 [<000000004013fa24>] timer_interrupt+0x19c/0x200
 [<00000000401ad8d8>] handle_irq_event_percpu+0xa8/0x238
 [<00000000401b2454>] handle_percpu_irq+0x9c/0xd0
 [<00000000401acc40>] generic_handle_irq+0x40/0x50
 [<00000000401408cc>] do_cpu_irq_mask+0x1ac/0x298
 [<000000004012c074>] intr_return+0x0/0xc
 [<00000000401a6220>] osq_unlock+0xd0/0xf8
 [<0000000040138dcc>] __mutex_lock_slowpath+0x274/0x290
 [<0000000040138e78>] mutex_lock+0x90/0x98
 [<00000000402a3a90>] kernfs_dop_revalidate+0x48/0x108
 [<0000000040233310>] lookup_fast+0x320/0x348
 [<0000000040234600>] link_path_walk+0x190/0x9d8


The code in kernel/locking/mcs_spinlock.c is broken.

PA-RISC doesn't have xchg or cmpxchg atomic instructions like other
processors. It only has ldcw and ldcd instructions that load a word (or
doubleword) from memory and atomically store zero at the same location.
These instructions can only be used to implement spinlocks, direct
implementation of other atomic operations is impossible.

Consequently, Linux xchg and cmpxchg functions are implemented in such a
way that they hash the address, use the hash to index a spinlock, take the
spinlock, perform the xchg or cmpxchg operation non-atomically and drop
the spinlock.

If you write to some variable with ACCESS_ONCE and use cmpxchg or xchg at
the same time, you break it. ACCESS_ONCE doesn't take the hashed spinlock,
so, in this case, cmpxchg or xchg isn't really atomic at all.

This patch fixes the bug by introducing a new type atomic_pointer_t 
(backed by atomic_long_t) and replacing the offending pointer with it. 
atomic_long_set takes the hashed spinlock, so it avoids the race 
condition.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/asm-generic/atomic-long.h |   24 ++++++++++++++++++++++++
 kernel/locking/mcs_spinlock.c     |   16 ++++++++--------
 kernel/locking/mcs_spinlock.h     |    4 +++-
 3 files changed, 35 insertions(+), 9 deletions(-)

Index: linux-3.15-rc7/kernel/locking/mcs_spinlock.c
===================================================================
--- linux-3.15-rc7.orig/kernel/locking/mcs_spinlock.c	2014-05-31 19:05:24.000000000 +0200
+++ linux-3.15-rc7/kernel/locking/mcs_spinlock.c	2014-06-01 14:31:58.000000000 +0200
@@ -47,8 +47,8 @@ osq_wait_next(struct optimistic_spin_que
 		 * wait for either @lock to point to us, through its Step-B, or
 		 * wait for a new @node->next from its Step-C.
 		 */
-		if (node->next) {
-			next = xchg(&node->next, NULL);
+		if (atomic_pointer_read(&node->next)) {
+			next = atomic_pointer_xchg(&node->next, NULL);
 			if (next)
 				break;
 		}
@@ -65,13 +65,13 @@ bool osq_lock(struct optimistic_spin_que
 	struct optimistic_spin_queue *prev, *next;
 
 	node->locked = 0;
-	node->next = NULL;
+	atomic_pointer_set(&node->next, NULL);
 
 	node->prev = prev = xchg(lock, node);
 	if (likely(prev == NULL))
 		return true;
 
-	ACCESS_ONCE(prev->next) = node;
+	atomic_pointer_set(&prev->next, node);
 
 	/*
 	 * Normally @prev is untouchable after the above store; because at that
@@ -103,8 +103,8 @@ unqueue:
 	 */
 
 	for (;;) {
-		if (prev->next == node &&
-		    cmpxchg(&prev->next, node, NULL) == node)
+		if (atomic_pointer_read(&prev->next) == node &&
+		    atomic_pointer_cmpxchg(&prev->next, node, NULL) == node)
 			break;
 
 		/*
@@ -144,7 +144,7 @@ unqueue:
 	 */
 
 	ACCESS_ONCE(next->prev) = prev;
-	ACCESS_ONCE(prev->next) = next;
+	atomic_pointer_set(&prev->next, next);
 
 	return false;
 }
@@ -163,7 +163,7 @@ void osq_unlock(struct optimistic_spin_q
 	/*
 	 * Second most likely case.
 	 */
-	next = xchg(&node->next, NULL);
+	next = atomic_pointer_xchg(&node->next, NULL);
 	if (next) {
 		ACCESS_ONCE(next->locked) = 1;
 		return;
Index: linux-3.15-rc7/kernel/locking/mcs_spinlock.h
===================================================================
--- linux-3.15-rc7.orig/kernel/locking/mcs_spinlock.h	2014-05-31 19:01:01.000000000 +0200
+++ linux-3.15-rc7/kernel/locking/mcs_spinlock.h	2014-06-01 14:17:49.000000000 +0200
@@ -13,6 +13,7 @@
 #define __LINUX_MCS_SPINLOCK_H
 
 #include <asm/mcs_spinlock.h>
+#include <linux/atomic.h>
 
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
@@ -119,7 +120,8 @@ void mcs_spin_unlock(struct mcs_spinlock
  */
 
 struct optimistic_spin_queue {
-	struct optimistic_spin_queue *next, *prev;
+	atomic_pointer_t next;
+	struct optimistic_spin_queue *prev;
 	int locked; /* 1 if lock acquired */
 };
 
Index: linux-3.15-rc7/include/asm-generic/atomic-long.h
===================================================================
--- linux-3.15-rc7.orig/include/asm-generic/atomic-long.h	2014-06-01 14:04:17.000000000 +0200
+++ linux-3.15-rc7/include/asm-generic/atomic-long.h	2014-06-01 14:30:19.000000000 +0200
@@ -255,4 +255,28 @@ static inline long atomic_long_add_unles
 
 #endif  /*  BITS_PER_LONG == 64  */
 
+typedef atomic_long_t atomic_pointer_t;
+
+#define ATOMIC_POINTER_INIT(i)	ATOMIC_LONG_INIT((long)(i))
+
+static inline void *atomic_pointer_read(atomic_pointer_t *v)
+{
+	return (void *)atomic_long_read(v);
+}
+
+static inline void atomic_pointer_set(atomic_pointer_t *v, void *i)
+{
+	atomic_long_set(v, (long)i);
+}
+
+static inline void *atomic_pointer_xchg(atomic_pointer_t *v, void *i)
+{
+	return (void *)atomic_long_xchg(v, (long)i);
+}
+
+static inline void *atomic_pointer_cmpxchg(atomic_pointer_t *v, void *old, void *new)
+{
+	return (void *)atomic_long_cmpxchg(v, (long)old, (long)new);
+}
+
 #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
