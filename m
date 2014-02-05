Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaBEJ1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:27:02 -0500
Received: from hofr.at ([212.69.189.236]:35308 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbaBEJ07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:26:59 -0500
Date: Wed, 5 Feb 2014 10:26:57 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.9-rt13
Message-ID: <20140205092657.GA21590@opentech.at>
References: <20140203194841.GA17108@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203194841.GA17108@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Feb 2014, Sebastian Andrzej Siewior wrote:

> Dear RT folks!
> 
> I'm pleased to announce the v3.12.9-rt13 patch set.
> 
> Changes since v3.12.9-rt12
...
> - drop a migrate_disable() call in local_lock(). Clean up / optimization
>   by Nicholas Mc Guire.

Sorry - this one causes a build failure with PREEMPT_RT_BASE=y and 
PREEMPT_RT_FULL not set.

The patch below fixes this build failure for 3.12.9-rt13.

<snip>
In file included from kernel/softirq.c:29:0:
include/linux/locallock.h: In function '__local_lock':
include/linux/locallock.h:42:3: error: implicit declaration of function 'spin_lock_local' [-Werror=implicit-function-declaration]
include/linux/locallock.h: In function '__local_trylock':
include/linux/locallock.h:55:2: error: implicit declaration of function 'spin_trylock_local' [-Werror=implicit-function-declaration]
include/linux/locallock.h: In function '__local_unlock':
include/linux/locallock.h:82:2: error: implicit declaration of function 'spin_unlock_local' [-Werror=implicit-function-declaration]
<snip>


spin_*lock_local is defined in linux/spinlock_rt.h and conditioned on
PREEMPT_RT_FULL, use-local-spin_locks-in-local_lock.patch. replaced the
spin_*locks by spin_*lock_local in locallock.h which is conditioned on
PREEMPT_RT_BASE only, so this results in implicit declarations.

Not sure what the clean way of resolving this is - this patch proposes to
move the spin_*_local into linux/locallock.h and map to spin_*lock for
the "CONFIG_PREEMPT_RT_FULL not set" case.

This was build tested with Preempt none,voluntary,low-lat,base,full and 
otherweise got only limited testing.

I'm also not sure if putting the rt specific locks into locallock.h in 
this way is the proper way to deal with this #include dependency.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 include/linux/locallock.h   |   15 +++++++++++++++
 include/linux/spinlock_rt.h |    4 ----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/locallock.h b/include/linux/locallock.h
index 32c684b..49ee095 100644
--- a/include/linux/locallock.h
+++ b/include/linux/locallock.h
@@ -36,6 +36,21 @@ struct local_irq_lock {
 			spin_lock_init(&per_cpu(lvar, __cpu).lock);	\
 	} while (0)
 
+/* spin_lock|trylock|unlock_local flavour that does not migrate disable
+ * used for __local_lock|trylock|unlock where get_local_var/put_local_var
+ * already takes care of the migrate_disable/enable
+ * for CONFIG_PREEMPT_BASE map to the normal spin_* calls.
+ */
+#ifdef CONFIG_PREEMPT_RT_FULL
+# define spin_lock_local(lock)			rt_spin_lock(lock)
+# define spin_trylock_local(lock)		rt_spin_trylock(lock)
+# define spin_unlock_local(lock)		rt_spin_unlock(lock)
+#else
+# define spin_lock_local(lock)			spin_lock(lock)
+# define spin_trylock_local(lock)		spin_trylock(lock)
+# define spin_unlock_local(lock)		spin_unlock(lock)
+#endif
+
 static inline void __local_lock(struct local_irq_lock *lv)
 {
 	if (lv->owner != current) {
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 4f91114..ac6f08b 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -36,10 +36,6 @@ extern int atomic_dec_and_spin_lock(atomic_t *atomic, spinlock_t *lock);
 extern void __lockfunc __rt_spin_lock(struct rt_mutex *lock);
 extern void __lockfunc __rt_spin_unlock(struct rt_mutex *lock);
 
-#define spin_lock_local(lock)			rt_spin_lock(lock)
-#define spin_trylock_local(lock)		rt_spin_trylock(lock)
-#define spin_unlock_local(lock)			rt_spin_unlock(lock)
-
 #define spin_lock(lock)				\
 	do {					\
 		migrate_disable();		\
-- 
1.7.10.4

