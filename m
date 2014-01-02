Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaABJTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 04:19:18 -0500
Received: from hofr.at ([212.69.189.236]:56355 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaABJTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:19:16 -0500
Date: Thu, 2 Jan 2014 10:19:15 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH RT 2/2] read_lock migrate_disable pushdown to rt_read_lock
Message-ID: <20140102091915.GC1757@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



pushdown of migrate_disable/enable from read_*lock* to the rt_read_*lock*
api level

general mapping to mutexes:

read_*lock* 
  `-> rt_read_*lock* 
          `-> __spin_lock (the sleeping spin locks)
                 `-> rt_mutex 

The real read_lock* mapping:

          read_lock_irqsave -.
read_lock_irq                `-> rt_read_lock_irqsave()  
       `->read_lock ---------.       \
          read_lock_bh ------+        \ 
                             `--> rt_read_lock() 
                                   if (rt_mutex_owner(lock) != current){
                                           `-> __rt_spin_lock()
                                                rt_spin_lock_fastlock()
                                                       `->rt_mutex_cmpxchg()
                                    migrate_disable()
                                   }
                                   rwlock->read_depth++;
read_trylock mapping:

read_trylock 
          `-> rt_read_trylock 
               if (rt_mutex_owner(lock) != current){
                                              `-> rt_mutex_trylock()
                                                   rt_mutex_fasttrylock()
                                                    rt_mutex_cmpxchg()
                migrate_disable()
               }
               rwlock->read_depth++;

read_unlock* mapping:

read_unlock_bh --------+
read_unlock_irq -------+
read_unlock_irqrestore +
read_unlock -----------+
                       `-> rt_read_unlock() 
                            if(--rwlock->read_depth==0){
                                      `-> __rt_spin_unlock()
                                           rt_spin_lock_fastunlock()
                                                        `-> rt_mutex_cmpxchg()
                             migrate_disable()
                            }

So calls to migrate_disable/enable() are better placed at the rt_read_*
level of lock/trylock/unlock as all of the read_*lock* API has this as a
common path. In the rt_read* API of lock/trylock/unlock the nesting level
is already being recorded in rwlock->read_depth, so we can push down the
migrate disable/enable to that level and condition it on the read_depth 
going from 0 to 1 -> migrate_disable and 1 to 0 -> migrate_enable. This 
eliminates the recursive calls that were needed when migrate_disable/enable
was done at the read_*lock* level.

The approach to read_*_bh also eliminates the concerns raised with the 
regards to api inbalances (read_lock_bh -> read_unlock+local_bh_enable) 

this is on top of 3.12.6-rt9 with 
timers-do-not-raise-softirq-unconditionally.patch removed

No change of functional behavior 

Tested-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 include/linux/rwlock_rt.h |    6 ------
 kernel/rt.c               |    9 +++++----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/include/linux/rwlock_rt.h b/include/linux/rwlock_rt.h
index a276fae..e85a5df 100644
--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -33,7 +33,6 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 #define read_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		migrate_disable();			\
 		flags = rt_read_lock_irqsave(lock);	\
 	} while (0)
 
@@ -45,14 +44,12 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 
 #define read_lock(lock)					\
 	do {						\
-		migrate_disable();			\
 		rt_read_lock(lock);			\
 	} while (0)
 
 #define read_lock_bh(lock)				\
 	do {						\
 		local_bh_disable();			\
-		migrate_disable();			\
 		rt_read_lock(lock);			\
 	} while (0)
 
@@ -74,13 +71,11 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 #define read_unlock(lock)				\
 	do {						\
 		rt_read_unlock(lock);			\
-		migrate_enable();			\
 	} while (0)
 
 #define read_unlock_bh(lock)				\
 	do {						\
 		rt_read_unlock(lock);			\
-		migrate_enable();			\
 		local_bh_enable();			\
 	} while (0)
 
@@ -104,7 +99,6 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 		typecheck(unsigned long, flags);	\
 		(void) flags;				\
 		rt_read_unlock(lock);			\
-		migrate_enable();			\
 	} while (0)
 
 #define write_unlock_irqrestore(lock, flags) \
diff --git a/kernel/rt.c b/kernel/rt.c
index c43c923..5d17727 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -211,19 +211,18 @@ int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 	 * but not when read_depth == 0 which means that the lock is
 	 * write locked.
 	 */
-	migrate_disable();
 	if (rt_mutex_owner(lock) != current) {
 		ret = rt_mutex_trylock(lock);
-		if (ret)
+		if (ret) {
 			rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
+			migrate_disable();
+		}
 	} else if (!rwlock->read_depth) {
 		ret = 0;
 	}
 
 	if (ret)
 		rwlock->read_depth++;
-	else
-		migrate_enable();
 
 	return ret;
 }
@@ -247,6 +246,7 @@ void __lockfunc rt_read_lock(rwlock_t *rwlock)
 	if (rt_mutex_owner(lock) != current) {
 		rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
 		__rt_spin_lock(lock);
+		migrate_disable();
 	}
 	rwlock->read_depth++;
 }
@@ -268,6 +268,7 @@ void __lockfunc rt_read_unlock(rwlock_t *rwlock)
 	if (--rwlock->read_depth == 0) {
 		rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
 		__rt_spin_unlock(&rwlock->lock);
+		migrate_enable();
 	}
 }
 EXPORT_SYMBOL(rt_read_unlock);
-- 
1.7.2.5

