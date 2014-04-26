Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaDZN6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 09:58:25 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:32867 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaDZN6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 09:58:22 -0400
Message-ID: <1398520699.28726.22.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Sat, 26 Apr 2014 15:58:19 +0200
In-Reply-To: <1398501491.12941.5.camel@marge.simpson.net>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
	 <1398411635.11930.45.camel@marge.simpson.net>
	 <1398501491.12941.5.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-26 at 10:38 +0200, Mike Galbraith wrote: 
> On Fri, 2014-04-25 at 09:40 +0200, Mike Galbraith wrote:
> 
> > Hotplug can still deadlock in rt trees too, and will if you beat it
> > hard.
> 
> Box actually deadlocks like so.

...

3.12-rt looks a bit busted migrate_disable/enable() wise.

/me eyeballs 3.10-rt (looks better), confirms 3.10-rt hotplug works,
swipes working code, confirms 3.12-rt now works.  Yup, that was it.

When I fix lg_global_lock() (I think it and Medusa are both busted) I
bet a nickle 3.14-rt will work.

Hm, actually, rt_write_trylock() in swiped 3.10-rt code below (and some
others) look busted to me.  migrate_disable() _after_ grabbing a lock is
too late, no?

---
 include/linux/rwlock_rt.h |   32 ++++++++++++++++++++++++++++----
 kernel/rt.c               |   21 +++++++++++----------
 2 files changed, 39 insertions(+), 14 deletions(-)

--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -33,50 +33,72 @@ extern void __rt_rwlock_init(rwlock_t *r
 #define read_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
+		migrate_disable();			\
 		flags = rt_read_lock_irqsave(lock);	\
 	} while (0)
 
 #define write_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
+		migrate_disable();			\
 		flags = rt_write_lock_irqsave(lock);	\
 	} while (0)
 
-#define read_lock(lock)		rt_read_lock(lock)
+#define read_lock(lock)					\
+	do {						\
+		migrate_disable();			\
+		rt_read_lock(lock);			\
+	} while (0)
 
 #define read_lock_bh(lock)				\
 	do {						\
 		local_bh_disable();			\
+		migrate_disable();			\
 		rt_read_lock(lock);			\
 	} while (0)
 
 #define read_lock_irq(lock)	read_lock(lock)
 
-#define write_lock(lock)	rt_write_lock(lock)
+#define write_lock(lock)				\
+	do {						\
+		migrate_disable();			\
+		rt_write_lock(lock);			\
+	} while (0)
 
 #define write_lock_bh(lock)				\
 	do {						\
 		local_bh_disable();			\
+		migrate_disable();			\
 		rt_write_lock(lock);			\
 	} while (0)
 
 #define write_lock_irq(lock)	write_lock(lock)
 
-#define read_unlock(lock)	rt_read_unlock(lock)
+#define read_unlock(lock)				\
+	do {						\
+		rt_read_unlock(lock);			\
+		migrate_enable();			\
+	} while (0)
 
 #define read_unlock_bh(lock)				\
 	do {						\
 		rt_read_unlock(lock);			\
+		migrate_enable();			\
 		local_bh_enable();			\
 	} while (0)
 
 #define read_unlock_irq(lock)	read_unlock(lock)
 
-#define write_unlock(lock)	rt_write_unlock(lock)
+#define write_unlock(lock)				\
+	do {						\
+		rt_write_unlock(lock);			\
+		migrate_enable();			\
+	} while (0)
 
 #define write_unlock_bh(lock)				\
 	do {						\
 		rt_write_unlock(lock);			\
+		migrate_enable();			\
 		local_bh_enable();			\
 	} while (0)
 
@@ -87,6 +109,7 @@ extern void __rt_rwlock_init(rwlock_t *r
 		typecheck(unsigned long, flags);	\
 		(void) flags;				\
 		rt_read_unlock(lock);			\
+		migrate_enable();			\
 	} while (0)
 
 #define write_unlock_irqrestore(lock, flags) \
@@ -94,6 +117,7 @@ extern void __rt_rwlock_init(rwlock_t *r
 		typecheck(unsigned long, flags);	\
 		(void) flags;				\
 		rt_write_unlock(lock);			\
+		migrate_enable();			\
 	} while (0)
 
 #endif
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -182,10 +182,11 @@ int __lockfunc rt_write_trylock(rwlock_t
 {
 	int ret = rt_mutex_trylock(&rwlock->lock);
 
-	if (ret) {
+	migrate_disable();
+	if (ret)
 		rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
-		migrate_disable();
-	}
+	else
+		migrate_enable();
 
 	return ret;
 }
@@ -196,7 +197,10 @@ int __lockfunc rt_write_trylock_irqsave(
 	int ret;
 
 	*flags = 0;
+	migrate_disable();
 	ret = rt_write_trylock(rwlock);
+	if (!ret)
+		migrate_enable();
 	return ret;
 }
 EXPORT_SYMBOL(rt_write_trylock_irqsave);
@@ -211,18 +215,19 @@ int __lockfunc rt_read_trylock(rwlock_t
 	 * but not when read_depth == 0 which means that the lock is
 	 * write locked.
 	 */
+	migrate_disable();
 	if (rt_mutex_owner(lock) != current) {
 		ret = rt_mutex_trylock(lock);
-		if (ret) {
+		if (ret)
 			rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
-			migrate_disable();
-		}
 	} else if (!rwlock->read_depth) {
 		ret = 0;
 	}
 
 	if (ret)
 		rwlock->read_depth++;
+	else
+		migrate_enable();
 
 	return ret;
 }
@@ -231,7 +236,6 @@ EXPORT_SYMBOL(rt_read_trylock);
 void __lockfunc rt_write_lock(rwlock_t *rwlock)
 {
 	rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
-	migrate_disable();
 	__rt_spin_lock(&rwlock->lock);
 }
 EXPORT_SYMBOL(rt_write_lock);
@@ -246,7 +250,6 @@ void __lockfunc rt_read_lock(rwlock_t *r
 	if (rt_mutex_owner(lock) != current) {
 		rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
 		__rt_spin_lock(lock);
-		migrate_disable();
 	}
 	rwlock->read_depth++;
 }
@@ -258,7 +261,6 @@ void __lockfunc rt_write_unlock(rwlock_t
 	/* NOTE: we always pass in '1' for nested, for simplicity */
 	rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
 	__rt_spin_unlock(&rwlock->lock);
-	migrate_enable();
 }
 EXPORT_SYMBOL(rt_write_unlock);
 
@@ -268,7 +270,6 @@ void __lockfunc rt_read_unlock(rwlock_t
 	if (--rwlock->read_depth == 0) {
 		rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
 		__rt_spin_unlock(&rwlock->lock);
-		migrate_enable();
 	}
 }
 EXPORT_SYMBOL(rt_read_unlock);


