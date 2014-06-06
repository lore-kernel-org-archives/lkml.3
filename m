Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaFFTUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 15:20:48 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:57763 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaFFTUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 15:20:47 -0400
X-Greylist: delayed 13098 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2014 15:20:47 EDT
Message-ID: <1402082441.14433.12.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/2] locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, mpatocka@redhat.com,
        torvalds@linux-foundation.org, waiman.long@hp.com,
        jejb@parisc-linux.org, paulmck@linux.vnet.ibm.com,
        dave.anglin@bell.net, aswin@hp.com, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Date: Fri, 06 Jun 2014 12:20:41 -0700
In-Reply-To: <1402081726.6680.61.camel@j-VirtualBox>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
	 <1402070140-15090-2-git-send-email-davidlohr@hp.com>
	 <1402074788.6680.50.camel@j-VirtualBox>
	 <1402078358.14433.3.camel@buesod1.americas.hpqcorp.net>
	 <1402080497.14433.8.camel@buesod1.americas.hpqcorp.net>
	 <1402081726.6680.61.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 12:08 -0700, Jason Low wrote:
> And should we also change that in the optimistic spinning functions so
> that it defaults to:
> 
> 	static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
> 	{
>         	return false;
> 	}

Oops Yep, afaict the last offending user.

8<----------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Date: Fri, 6 Jun 2014 12:15:03 -0700
Subject: [PATCH v3 1/2] locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER

Just like with mutexes (CONFIG_MUTEX_SPIN_ON_OWNER),
encapsulate the dependencies for rwsem optimistic spinning.
No logical changes here as it continues to depend on both
SMP and the XADD algorithm variant.

Acked-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/linux/rwsem.h       | 4 ++--
 kernel/Kconfig.locks        | 4 ++++
 kernel/locking/rwsem-xadd.c | 4 ++--
 kernel/locking/rwsem.c      | 2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8d79708..accdef7 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -27,7 +27,7 @@ struct rw_semaphore {
 	long count;
 	raw_spinlock_t wait_lock;
 	struct list_head wait_list;
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 	/*
 	 * Write owner. Used as a speculative check to see
 	 * if the owner is running on the cpu.
@@ -64,7 +64,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-#if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 #define __RWSEM_INITIALIZER(name)			\
 	{ RWSEM_UNLOCKED_VALUE,				\
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 35536d9..e4c3162 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -224,6 +224,10 @@ config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
 
+config RWSEM_SPIN_ON_OWNER
+       def_bool y
+       depends on SMP && RWSEM_XCHGADD_ALGORITHM
+
 config ARCH_USE_QUEUE_RWLOCK
 	bool
 
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index dacc321..abe6e06 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -82,7 +82,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 	sem->owner = NULL;
 	sem->osq = NULL;
 #endif
@@ -262,7 +262,7 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 	return false;
 }
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 /*
  * Try to acquire write lock before the writer has been put on wait queue.
  */
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 42f806d..e2d3bc7 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -12,7 +12,7 @@
 
 #include <linux/atomic.h>
 
-#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 static inline void rwsem_set_owner(struct rw_semaphore *sem)
 {
 	sem->owner = current;
-- 
1.8.1.4




