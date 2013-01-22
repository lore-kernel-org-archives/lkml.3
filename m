Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3AVXOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:14:06 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36530 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3AVXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:13:56 -0500
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/6] kernel: faster queue spinlock implementation
Date: Tue, 22 Jan 2013 15:13:33 -0800
Message-Id: <1358896415-28569-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1358896415-28569-1-git-send-email-walken@google.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCS based queue spinlock implementation was easy to use, but it has
a few annoying performance limitations under moderate contention.

- In the uncontended case, it uses atomic operations on both the acquire
  and the release paths, as opposed to the ticket spinlock which can use
  (on x86) a simple store on the release path.

- In the contended case, a thread will write both to its own
  q_spinlock_node (to initialize the wait field), to the previous
  node (to set the next field), and to the next node (to release the
  spinlock). It would be nice to reduce the number of locations accessed.

- When some thread's unlock operation races with the next thread's lock
  operation, there is a short window where the unlocker might have to spin
  waiting for the locker to fully register itself. This race is most likely
  to hit with a small number of threads and a short lock hold time, and it
  may reduce performance in that case.

Because of these limitations, the MCS queue spinlock implementation does
not always compare favorably to ticket spinlocks under moderate contention.

This alternative queue spinlock implementation has some nice properties:

- One single atomic operation (xchg) during acquire
- One single memory store for unlock. No busy looping either.
  Actually, the unlock is so short that we can just inline it.
- Same basic API as with the MCS spinlock

It does however have a couple downsides:

- Spinlock initialization makes use of kmalloc(), and can fail.
  This is easy enough to deal with for dynamically allocated objects,
  where the object allocation could have failed too; however this is
  slightly inconvenient for statically allocated objects.
- trylock() is not sanely implementable in this framework, while the MCS
  queue spinlock implementation could have supported it without issues.
- This proposal does not support acquiring queue spinlocks from hardirq
  or nmi contexts (I don't expect this to be a significant downside).

Each spinlock points to a q_spinlock_token structure, which consists of a
single 'wait' field. That value is true whenever the spinlock is locked.
Each CPU has a private stash of two tokens. To acquire the spinlock,
we must use one of the per-CPU stashed tokens, set the wait field to true,
and atomically exchange it with the spinlock's token, thus getting the
previous lock holder/waiter's token. Then we wait for the previous holder
to release the lock, by waiting for that previous token's wait field to
become false. At that point, the previous holder won't access that token
anymore so we can stash it back into our per-CPU reserve. To unlock,
we must simply remember the token we had exchanged into the spinlock
variable (it gets passed from the lock function to the unlock function
through the q_spinlock_node structure) and set its wait field to false.

Since the spinlock acquisition takes one token out of our per-CPU stash
at the start of the operation, and returns a new token to the per-CPU stash
only after it's done spinning for the previous lock owner to unlock,
we need to deal with the possibility of getting interrupted during that
process and needing to acquire a separate spinlock during that interrupt.
This situation is dealt with by having two stashed tokens per CPU, and
by not supporting queue spinlock acquisition in hardirq or nmi contexts,
so that we never need more than two levels of nesting here (for process
and softirq contexts).

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/queue_spinlock.h |   80 ++++++++++++++++++----
 init/main.c                    |    2 +
 kernel/queue_spinlock.c        |  149 ++++++++++++++++++++++++++--------------
 3 files changed, 164 insertions(+), 67 deletions(-)

diff --git a/include/linux/queue_spinlock.h b/include/linux/queue_spinlock.h
index 84b2470d232b..992b72be27e3 100644
--- a/include/linux/queue_spinlock.h
+++ b/include/linux/queue_spinlock.h
@@ -2,38 +2,80 @@
 #define __LINUX_QUEUE_SPINLOCK_H
 
 #include <linux/bug.h>
+#include <linux/preempt.h>
+#include <linux/bottom_half.h>
+#include <asm/queue_spinlock.h>
 
-struct q_spinlock_node {
-	struct q_spinlock_node *next;
+struct q_spinlock_token {
 	bool wait;
 };
 
-struct q_spinlock {
-	struct q_spinlock_node *node;
+struct q_spinlock_node {
+	struct q_spinlock_token *token;
 };
 
-#define __Q_SPIN_LOCK_UNLOCKED(name) { NULL }
+struct q_spinlock {
+	struct q_spinlock_token *token;
+};
 
 #ifdef CONFIG_SMP
 
-void q_spin_lock(struct q_spinlock *lock, struct q_spinlock_node *node);
-void q_spin_lock_bh(struct q_spinlock *lock, struct q_spinlock_node *node);
-void q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node);
-void q_spin_unlock_bh(struct q_spinlock *lock, struct q_spinlock_node *node);
+struct q_spinlock_token *__q_spin_lock(struct q_spinlock *lock);
+struct q_spinlock_token *__q_spin_lock_bh(struct q_spinlock *lock);
+struct q_spinlock_token *__q_spin_lock_process(struct q_spinlock *lock);
+int q_spin_lock_init(struct q_spinlock *lock);
+void q_spin_lock_destroy(struct q_spinlock *lock);
+void q_spin_lock_percpu_init(void);
+
+static inline void
+q_spin_lock(struct q_spinlock *lock, struct q_spinlock_node *node)
+{
+	node->token = __q_spin_lock(lock);
+}
+
+static inline void
+q_spin_lock_bh(struct q_spinlock *lock, struct q_spinlock_node *node)
+{
+	node->token = __q_spin_lock_bh(lock);
+}
+
+static inline void
+q_spin_lock_process(struct q_spinlock *lock, struct q_spinlock_node *node)
+{
+	node->token = __q_spin_lock_process(lock);
+}
+
+static inline void
+q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node)
+{
+	q_spin_unlock_mb();	/* guarantee release store semantics */
+	ACCESS_ONCE(node->token->wait) = false;
+	preempt_enable();
+}
+
+static inline void
+q_spin_unlock_bh(struct q_spinlock *lock, struct q_spinlock_node *node)
+{
+	q_spin_unlock_mb();	/* guarantee release store semantics */
+	ACCESS_ONCE(node->token->wait) = false;
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
 
-static inline void q_spin_lock_init(struct q_spinlock *lock)
+static inline void
+q_spin_unlock_process(struct q_spinlock *lock, struct q_spinlock_node *node)
 {
-	lock->node = NULL;
+	q_spin_unlock(lock, node);
 }
 
 static inline void assert_q_spin_locked(struct q_spinlock *lock)
 {
-	BUG_ON(!lock->node);
+	BUG_ON(!lock->token->wait);
 }
 
 static inline void assert_q_spin_unlocked(struct q_spinlock *lock)
 {
-	BUG_ON(lock->node);
+	BUG_ON(lock->token->wait);
 }
 
 #else /* !CONFIG_SMP */
@@ -45,17 +87,27 @@ static inline void
 q_spin_lock_bh(struct q_spinlock *lock, struct q_spinlock_node *node) {}
 
 static inline void
+q_spin_lock_process(struct q_spinlock *lock, struct q_spinlock_node *node) {}
+
+static inline void
 q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node) {}
 
 static inline void
 q_spin_unlock_bh(struct q_spinlock *lock, struct q_spinlock_node *node) {}
 
-static inline void q_spin_lock_init(struct q_spinlock *lock) {}
+static inline void
+q_spin_unlock_process(struct q_spinlock *lock, struct q_spinlock_node *node) {}
+
+static inline int q_spin_lock_init(struct q_spinlock *lock) { return 0; }
+
+static inline void q_spin_lock_destroy(struct q_spinlock *lock) {}
 
 static inline void assert_q_spin_locked(struct q_spinlock *lock) {}
 
 static inline void assert_q_spin_unlocked(struct q_spinlock *lock) {}
 
+static inline void q_spin_lock_percpu_init(void) {};
+
 #endif /* CONFIG_SMP */
 
 #endif /* __LINUX_QUEUE_SPINLOCK_H */
diff --git a/init/main.c b/init/main.c
index e33e09df3cbc..ebfb6bd4a819 100644
--- a/init/main.c
+++ b/init/main.c
@@ -70,6 +70,7 @@
 #include <linux/perf_event.h>
 #include <linux/file.h>
 #include <linux/ptrace.h>
+#include <linux/queue_spinlock.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -525,6 +526,7 @@ asmlinkage void __init start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	mm_init();
+	q_spin_lock_percpu_init();
 
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
diff --git a/kernel/queue_spinlock.c b/kernel/queue_spinlock.c
index 20304f0bc852..b5715088e9cd 100644
--- a/kernel/queue_spinlock.c
+++ b/kernel/queue_spinlock.c
@@ -2,81 +2,124 @@
 #include <linux/export.h>
 #include <linux/preempt.h>
 #include <linux/bottom_half.h>
-#include <asm/barrier.h>
+#include <linux/percpu.h>
+#include <linux/slab.h>
+#include <linux/hardirq.h>
+#include <linux/cache.h>
 #include <asm/processor.h>	/* for cpu_relax() */
 #include <asm/queue_spinlock.h>
 
-static inline void
-__q_spin_lock(struct q_spinlock *lock, struct q_spinlock_node *node)
+DEFINE_PER_CPU(struct q_spinlock_token *, q_spinlock_token[2]);
+
+static inline struct q_spinlock_token *
+____q_spin_lock(struct q_spinlock *lock,
+		struct q_spinlock_token **percpu_token)
 {
-	struct q_spinlock_node *prev;
-
-	node->next = NULL;
-	prev = xchg(&lock->node, node);
-	if (likely(!prev))
-		/*
-		 * Acquired the lock.
-		 * xchg() already includes a full memory barrier.
-		 */
-		return;
-
-	node->wait = true;
-	smp_wmb();
-	ACCESS_ONCE(prev->next) = node;
-	while (ACCESS_ONCE(node->wait))
+	/*
+	 * Careful about reentrancy here - if we are interrupted and the code
+	 * running in that interrupt tries to get another queue spinlock,
+	 * it must not use the same percpu_token that we're using here.
+	 */
+
+	struct q_spinlock_token *token, *prev;
+
+	token = __this_cpu_read(*percpu_token);
+	token->wait = true;
+	prev = xchg(&lock->token, token);
+	__this_cpu_write(*percpu_token, prev);
+	while (ACCESS_ONCE(prev->wait))
 		cpu_relax();
 	q_spin_lock_mb();	/* guarantee acquire load semantics */
+	return token;
 }
 
-static inline void
-__q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node)
+#ifdef CONFIG_DEBUG_SPINLOCK
+#define SPINLOCK_WARN_ON(x) WARN_ON_ONCE(x)
+#else
+#define SPINLOCK_WARN_ON(x)
+#endif
+
+/*
+ * Acquire queue spinlock from process context.  If an interrupt comes,
+ * the BH may call __q_spin_lock() or __q_spin_lock_bh() before we return.
+ */
+struct q_spinlock_token *__q_spin_lock_process(struct q_spinlock *lock)
 {
-	struct q_spinlock_node *next;
-	if (likely(!(next = ACCESS_ONCE(node->next)))) {
-		/*
-		 * Try to release lock.
-		 * cmpxchg() already includes a full memory barrier.
-		 */
-		if (likely(cmpxchg(&lock->node, node, NULL) == node))
-			return;
-
-		/*
-		 * We raced with __q_spin_lock().
-		 * Wait for next thread to be known.
-		 */
-		while (!(next = ACCESS_ONCE(node->next)))
-			cpu_relax();
-	}
-	q_spin_unlock_mb();	/* guarantee release store semantics */
-	ACCESS_ONCE(next->wait) = false;
+	/* Call only from process context */
+	SPINLOCK_WARN_ON(in_serving_softirq() | in_irq() || in_nmi());
+
+	preempt_disable();
+	return ____q_spin_lock(lock, q_spinlock_token);
 }
+EXPORT_SYMBOL(__q_spin_lock_process);
 
-void q_spin_lock(struct q_spinlock *lock, struct q_spinlock_node *node)
+/*
+ * Acquire queue spinlock with BH processing already known to be disabled
+ * (thus there can't be nested queue spinlock acquisitions before we return).
+ */
+struct q_spinlock_token *__q_spin_lock(struct q_spinlock *lock)
 {
+	/* Do not call from hardirq context */
+	SPINLOCK_WARN_ON(in_irq() || in_nmi());
+
+	/*
+	 * Do not call with BH processing enabled
+	 * (call q_spin_lock_process() instead)
+	 */
+	SPINLOCK_WARN_ON(!in_softirq());
+
 	preempt_disable();
-	__q_spin_lock(lock, node);
+	return ____q_spin_lock(lock, q_spinlock_token + 1);
 }
-EXPORT_SYMBOL(q_spin_lock);
+EXPORT_SYMBOL(__q_spin_lock);
 
-void q_spin_lock_bh(struct q_spinlock *lock, struct q_spinlock_node *node)
+/*
+ * Acquire queue spinlock and disable BH processing
+ * (thus there can't be nested queue spinlock acquisitions before we return).
+ */
+struct q_spinlock_token *__q_spin_lock_bh(struct q_spinlock *lock)
 {
+	/* Do not call from hardirq context */
+	SPINLOCK_WARN_ON(in_irq() || in_nmi());
+
 	local_bh_disable();
 	preempt_disable();
-	__q_spin_lock(lock, node);
+	return ____q_spin_lock(lock, q_spinlock_token + 1);
+}
+EXPORT_SYMBOL(__q_spin_lock_bh);
+
+struct q_spinlock_alloc_token {
+	struct q_spinlock_token ____cacheline_aligned t;
+};
+
+int q_spin_lock_init(struct q_spinlock *lock)
+{
+	struct q_spinlock_token *token;
+	token = kmalloc(sizeof(struct q_spinlock_alloc_token), GFP_KERNEL);
+	if (!token)
+		return -ENOMEM;
+	token->wait = false;
+	lock->token = token;
+	return 0;
 }
-EXPORT_SYMBOL(q_spin_lock_bh);
+EXPORT_SYMBOL(q_spin_lock_init);
 
-void q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node)
+void q_spin_lock_destroy(struct q_spinlock *lock)
 {
-	__q_spin_unlock(lock, node);
-	preempt_enable();
+	kfree(lock->token);
 }
-EXPORT_SYMBOL(q_spin_unlock);
+EXPORT_SYMBOL(q_spin_lock_destroy);
 
-void q_spin_unlock_bh(struct q_spinlock *lock, struct q_spinlock_node *node)
+void q_spin_lock_percpu_init(void)
 {
-	__q_spin_unlock(lock, node);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	unsigned int cpu, i;
+	struct q_spinlock_token *token;
+	for_each_possible_cpu(cpu)
+		for (i = 0; i < 2; i++) {
+			token = kmalloc(sizeof(struct q_spinlock_alloc_token),
+					GFP_KERNEL);
+			BUG_ON(!token);
+			token->wait = false;
+			per_cpu(q_spinlock_token[i], cpu) = token;
+		}
 }
-EXPORT_SYMBOL(q_spin_unlock_bh);
-- 
1.7.7.3
