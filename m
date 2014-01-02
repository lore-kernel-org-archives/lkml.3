Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaABJSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 04:18:45 -0500
Received: from hofr.at ([212.69.189.236]:56337 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaABJSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:18:43 -0500
Date: Thu, 2 Jan 2014 10:18:42 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH RT 1/2] write_lock migrate_disable pushdown to rt_write_lock
Message-ID: <20140102091842.GB1757@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pushdown of migrate_disable/enable from write_*lock* to the rt_write_*lock* 
api level

general mapping of write_*lock* to mutexes:

write_*lock*
  `-> rt_write_*lock*
          `-> __spin_lock (the sleeping __spin_lock)
                 `-> rt_mutex

write_*lock*s are non-recursive so we have two lock chains to consider
 - write_trylock*/write_unlock
 - write_lock*/wirte_unlock
for both paths the migration_disable/enable must be balanced.


write_trylock* mapping:

write_trylock_irqsave
                `-> rt_write_trylock_irqsave 
write_trylock             \
          `-------->  rt_write_trylock 
                       ret = rt_mutex_trylock
                              rt_mutex_fasttrylock
                               rt_mutex_cmpxchg
                       if (ret) 
                            migrate_disable 


write_lock* mapping:

                  write_lock_irqsave
                                `-> rt_write_lock_irqsave
write_lock_irq -> write_lock ----.     \
                  write_lock_bh -+      \
                                 `-> rt_write_lock
                                      __rt_spin_lock()
                                       rt_spin_lock_fastlock()
                                        rt_mutex_cmpxchg()
                                     migrate_disable()
                     
write_unlock* mapping:

                    write_unlock_irqrestore.
                    write_unlock_bh -------+
write_unlock_irq -> write_unlock ----------+
                                           `-> rt_write_unlock()
                                                __rt_spin_unlock()
                                                 rt_spin_lock_fastunlock()
                                                  rt_mutex_cmpxchg()
                                               migrate_enable()

So calls to migrate_disable/enable() are better placed at the rt_write_* 
level of lock/trylock/unlock as all of the write_*lock* API has this as a 
common path.

This approach to write_*_bh also eliminates the concerns raised with 
regards to api inbalances (write_lock_bh -> write_unlock+local_bh_enable)

this is on top of 3.12.6-rt9 with
timers-do-not-raise-softirq-unconditionally.patch removed

No change of functional behavior

Tested-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 include/linux/rwlock_rt.h |    6 ------
 kernel/rt.c               |    4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/rwlock_rt.h b/include/linux/rwlock_rt.h
index 853ee36..a276fae 100644
--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -40,7 +40,6 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 #define write_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		migrate_disable();			\
 		flags = rt_write_lock_irqsave(lock);	\
 	} while (0)
 
@@ -61,14 +60,12 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 
 #define write_lock(lock)				\
 	do {						\
-		migrate_disable();			\
 		rt_write_lock(lock);			\
 	} while (0)
 
 #define write_lock_bh(lock)				\
 	do {						\
 		local_bh_disable();			\
-		migrate_disable();			\
 		rt_write_lock(lock);			\
 	} while (0)
 
@@ -92,13 +89,11 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 #define write_unlock(lock)				\
 	do {						\
 		rt_write_unlock(lock);			\
-		migrate_enable();			\
 	} while (0)
 
 #define write_unlock_bh(lock)				\
 	do {						\
 		rt_write_unlock(lock);			\
-		migrate_enable();			\
 		local_bh_enable();			\
 	} while (0)
 
@@ -117,7 +112,6 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 		typecheck(unsigned long, flags);	\
 		(void) flags;				\
 		rt_write_unlock(lock);			\
-		migrate_enable();			\
 	} while (0)
 
 #endif
diff --git a/kernel/rt.c b/kernel/rt.c
index 29771e2..c43c923 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -197,8 +197,6 @@ int __lockfunc rt_write_trylock_irqsave(rwlock_t *rwlock, unsigned long *flags)
 
 	*flags = 0;
 	ret = rt_write_trylock(rwlock);
-	if (ret)
-		migrate_disable();
 	return ret;
 }
 EXPORT_SYMBOL(rt_write_trylock_irqsave);
@@ -234,6 +232,7 @@ EXPORT_SYMBOL(rt_read_trylock);
 void __lockfunc rt_write_lock(rwlock_t *rwlock)
 {
 	rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
+	migrate_disable();
 	__rt_spin_lock(&rwlock->lock);
 }
 EXPORT_SYMBOL(rt_write_lock);
@@ -259,6 +258,7 @@ void __lockfunc rt_write_unlock(rwlock_t *rwlock)
 	/* NOTE: we always pass in '1' for nested, for simplicity */
 	rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
 	__rt_spin_unlock(&rwlock->lock);
+	migrate_enable();
 }
 EXPORT_SYMBOL(rt_write_unlock);
 
-- 
1.7.2.5

