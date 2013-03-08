Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab3CHEhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:37:32 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52301 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760392Ab3CHEh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:37:26 -0500
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/5] kernel: make tasklist_lock fair for process context call sites
Date: Thu,  7 Mar 2013 20:37:17 -0800
Message-Id: <1362717437-1729-6-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362717437-1729-1-git-send-email-walken@google.com>
References: <1362717437-1729-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split tasklist_lock into two rwlocks: one fair for process context
call sites, one unfair for irq/softirq context call sites.
The write side lockers need to acquire both.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/sched.h | 22 ++++++++++++++--------
 kernel/fork.c         |  8 ++++++--
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4eb58b796261..d2b9bc78e86d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -218,6 +218,7 @@ extern char ___assert_task_state[1 - 2*!!(
 #define TASK_COMM_LEN 16
 
 #include <linux/spinlock.h>
+#include <linux/fair_rwlock.h>
 #include <linux/hardirq.h>
 
 /*
@@ -226,44 +227,49 @@ extern char ___assert_task_state[1 - 2*!!(
  * _adding_ to the beginning of the run-queue has
  * a separate lock).
  */
-extern rwlock_t tasklist_lock;
+extern struct tasklist_lock {
+	struct fair_rwlock process;
+	rwlock_t any;
+} tasklist_lock;
 extern spinlock_t mmlist_lock;
 
 static inline void tasklist_write_lock(void)
 {
 	WARN_ON_ONCE(in_serving_softirq() || in_irq() || in_nmi());
-	write_lock_irq(&tasklist_lock);
+	fair_write_lock(&tasklist_lock.process);
+	write_lock_irq(&tasklist_lock.any);
 }
 
 static inline void tasklist_write_unlock(void)
 {
-	write_unlock_irq(&tasklist_lock);
+	write_unlock_irq(&tasklist_lock.any);
+	fair_write_unlock(&tasklist_lock.process);
 }
 
 static inline void tasklist_read_lock(void)
 {
 	WARN_ON_ONCE(in_serving_softirq() || in_irq() || in_nmi());
-	read_lock(&tasklist_lock);
+	fair_read_lock(&tasklist_lock.process);
 }
 
 static inline void tasklist_read_unlock(void)
 {
-	read_unlock(&tasklist_lock);
+	fair_read_unlock(&tasklist_lock.process);
 }
 
 static inline void tasklist_read_lock_any(void)
 {
-	read_lock(&tasklist_lock);
+	read_lock(&tasklist_lock.any);
 }
 
 static inline int tasklist_read_trylock_any(void)
 {
-	return read_trylock(&tasklist_lock);
+	return read_trylock(&tasklist_lock.any);
 }
 
 static inline void tasklist_read_unlock_any(void)
 {
-	read_unlock(&tasklist_lock);
+	read_unlock(&tasklist_lock.any);
 }
 
 struct task_struct;
diff --git a/kernel/fork.c b/kernel/fork.c
index 827fe2e48e8c..71ab78755859 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -93,12 +93,16 @@ int max_threads;		/* tunable limit on nr_threads */
 
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
-__cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
+__cacheline_aligned struct tasklist_lock tasklist_lock = {
+	.process = __FAIR_RW_LOCK_UNLOCKED(tasklist_lock_process),
+	.any     = __RW_LOCK_UNLOCKED(tasklist_lock_any)
+};
 
 #ifdef CONFIG_PROVE_RCU
 int lockdep_tasklist_lock_is_held(void)
 {
-	return lockdep_is_held(&tasklist_lock);
+	return lockdep_is_held(&tasklist_lock.process) ||
+		lockdep_is_held(&tasklist_lock.any);
 }
 EXPORT_SYMBOL_GPL(lockdep_tasklist_lock_is_held);
 #endif /* #ifdef CONFIG_PROVE_RCU */
-- 
1.8.1.3
