Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaFFSs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:48:26 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:58795 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaFFSsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:48:25 -0400
Message-ID: <1402080497.14433.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/2] locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, mpatocka@redhat.com,
        torvalds@linux-foundation.org, waiman.long@hp.com,
        jejb@parisc-linux.org, paulmck@linux.vnet.ibm.com,
        dave.anglin@bell.net, aswin@hp.com, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Date: Fri, 06 Jun 2014 11:48:17 -0700
In-Reply-To: <1402078358.14433.3.camel@buesod1.americas.hpqcorp.net>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
	 <1402070140-15090-2-git-send-email-davidlohr@hp.com>
	 <1402074788.6680.50.camel@j-VirtualBox>
	 <1402078358.14433.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 11:12 -0700, Davidlohr Bueso wrote:
> On Fri, 2014-06-06 at 10:13 -0700, Jason Low wrote:
> > On Fri, 2014-06-06 at 08:55 -0700, Davidlohr Bueso wrote:
> > > Just like with mutexes (CONFIG_MUTEX_SPIN_ON_OWNER),
> > > encapsulate the dependencies for rwsem optimistic spinning.
> > > No logical changes here as it continues to depend on both
> > > SMP and the XADD algorithm variant.
> > > 
> > > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > > ---
> > >  include/linux/rwsem.h  | 4 ++--
> > >  kernel/Kconfig.locks   | 4 ++++
> > >  kernel/locking/rwsem.c | 2 +-
> > >  3 files changed, 7 insertions(+), 3 deletions(-)
> > 
> > Do we also want to add an #ifdef CONFIG_RWSEM_SPIN_ON_OWNER in
> > __init_rwsem() and in the optimistic spinning functions for rwsem-xadd?
> > 
> 
> Not really, as we conditionally build rwsem-xadd.o based on
> CONFIG_RWSEM_XCHGADD_ALGORITHM:
> 
> obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
> obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
> 
> So leaving just SMP is ok there.

Of course that's bogus when we add more dependencies (ie 2/2), so yeah,
we need to add the whole CONFIG_RWSEM_SPIN_ON_OWNER option.

Thanks.

8<---------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Date: Fri, 6 Jun 2014 11:45:34 -0700
Subject: [PATCH v2 1/2] locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER

Just like with mutexes (CONFIG_MUTEX_SPIN_ON_OWNER),
encapsulate the dependencies for rwsem optimistic spinning.
No logical changes here as it continues to depend on both
SMP and the XADD algorithm variant.

Acked-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/linux/rwsem.h       | 4 ++--
 kernel/Kconfig.locks        | 4 ++++
 kernel/locking/rwsem-xadd.c | 2 +-
 kernel/locking/rwsem.c      | 2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

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
index dacc321..f6b5b96 100644
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



