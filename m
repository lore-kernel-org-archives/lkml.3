Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaFFP4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:56:06 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:59329 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFFP4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:56:03 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: mpatocka@redhat.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        waiman.long@hp.com, jejb@parisc-linux.org, paulmck@linux.vnet.ibm.com,
        dave.anglin@bell.net, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH 1/2] locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER
Date: Fri,  6 Jun 2014 08:55:39 -0700
Message-Id: <1402070140-15090-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like with mutexes (CONFIG_MUTEX_SPIN_ON_OWNER),
encapsulate the dependencies for rwsem optimistic spinning.
No logical changes here as it continues to depend on both
SMP and the XADD algorithm variant.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/linux/rwsem.h  | 4 ++--
 kernel/Kconfig.locks   | 4 ++++
 kernel/locking/rwsem.c | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

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

