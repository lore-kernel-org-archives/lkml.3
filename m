Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab3CHEhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:37:51 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50069 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391Ab3CHEhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:37:25 -0500
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/5] kernel: add ticket based fair rwlock
Date: Thu,  7 Mar 2013 20:37:16 -0800
Message-Id: <1362717437-1729-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362717437-1729-1-git-send-email-walken@google.com>
References: <1362717437-1729-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple implementation of a fair reader writer spinlock using tickets
(generic implementation, x86 specialized implementation could be made faster)

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/fair_rwlock.h | 72 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/lockdep.h     | 15 ++++++++++
 2 files changed, 87 insertions(+)
 create mode 100644 include/linux/fair_rwlock.h

diff --git a/include/linux/fair_rwlock.h b/include/linux/fair_rwlock.h
new file mode 100644
index 000000000000..28c49262c4af
--- /dev/null
+++ b/include/linux/fair_rwlock.h
@@ -0,0 +1,72 @@
+#ifndef __LINUX_FAIR_RWLOCK_H
+#define __LINUX_FAIR_RWLOCK_H
+
+struct fair_rwlock {
+	atomic_t		ticket;
+	atomic_t		curr_r;
+	atomic_t		curr_w;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+};
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define __FAIR_RWLOCK_DEP_MAP_INIT(lockname) , { .name = #lockname }
+#else
+#define __FAIR_RWLOCK_DEP_MAP_INIT(lockname)
+#endif
+
+#define __FAIR_RW_LOCK_UNLOCKED(name)				\
+	{ ATOMIC_INIT(0), ATOMIC_INIT(0), ATOMIC_INIT(0)	\
+		__FAIR_RWLOCK_DEP_MAP_INIT(name) }
+
+static inline int get_ticket(struct fair_rwlock *lock)
+{
+	return atomic_inc_return(&lock->ticket) - 1;
+}
+
+static inline void fair_write_lock(struct fair_rwlock *lock)
+{
+	int ticket;
+
+	fair_rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+
+	preempt_disable();
+	ticket = get_ticket(lock);
+	while (atomic_read(&lock->curr_w) != ticket);	/* spin */
+	smp_mb();
+}
+
+static inline void fair_write_unlock(struct fair_rwlock *lock)
+{
+	fair_rwlock_release(&lock->dep_map, 1, _RET_IP_);
+
+	smp_mb();
+	atomic_inc(&lock->curr_r);
+	atomic_inc(&lock->curr_w);
+	preempt_enable();
+}
+
+static inline void fair_read_lock(struct fair_rwlock *lock)
+{
+	int ticket;
+
+	fair_rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+
+	preempt_disable();
+	ticket = get_ticket(lock);
+	while (atomic_read(&lock->curr_r) != ticket);	/* spin */
+	smp_mb();
+	atomic_set(&lock->curr_r, ticket + 1);
+}
+
+static inline void fair_read_unlock(struct fair_rwlock *lock)
+{
+	fair_rwlock_release(&lock->dep_map, 1, _RET_IP_);
+
+	smp_mb();
+	atomic_inc(&lock->curr_w);
+	preempt_enable();
+}
+
+#endif /* __LINUX_FAIR_RWLOCK_H */
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index f1e877b79ed8..e2f59eadf485 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -510,6 +510,21 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
+#  define fair_rwlock_acquire(l, s, t, i)	lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define fair_rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
+# else
+#  define fair_rwlock_acquire(l, s, t, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define fair_rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
+# endif
+# define fair_rwlock_release(l, n, i)		lock_release(l, n, i)
+#else
+# define fair_rwlock_acquire(l, s, t, i)	do { } while (0)
+# define fair_rwlock_acquire_read(l, s, t, i)	do { } while (0)
+# define fair_rwlock_release(l, n, i)		do { } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
 #  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
 #  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
 # else
-- 
1.8.1.3
