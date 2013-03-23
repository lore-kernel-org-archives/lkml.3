Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423073Ab3CWB0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:26:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:24640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423007Ab3CWB0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:26:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455617"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 28/29] x86, tsx: Add adaptive elision for rwsems
Date: Fri, 22 Mar 2013 18:25:22 -0700
Message-Id: <1364001923-10796-29-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Convert the rwsem elision to be adaptive. This requires adding
4/8 bytes to the rwsem for the adaptation state. The algorithm
is the same as for other adaptive lock types. The elision
configuration is split for readers and writers.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/rwsem.h |   22 +++++++++++++++++-----
 arch/x86/kernel/rtm-locks.c  |   10 ++++++++++
 include/linux/rwsem.h        |    3 +++
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index f9297af..da6437c 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -39,6 +39,7 @@
 #ifdef __KERNEL__
 #include <asm/asm.h>
 #include <linux/elide.h>
+#include <linux/jump_label.h>
 
 /*
  * The bias values and the counter type limits the number of
@@ -58,14 +59,18 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
-extern bool rwsem_elision;
+extern struct static_key rwsem_elision;
+extern struct elision_config readsem_elision_config;
+extern struct elision_config writesem_elision_config;
 
 /*
  * lock for reading
  */
 static inline void __down_read(struct rw_semaphore *sem)
 {
-	if (elide_lock(rwsem_elision, sem->count == 0))
+	if (elide_lock_adapt(rwsem_elision, sem->count == 0,
+			     &sem->elision_adapt,
+			     &readsem_elision_config))
 		return;
 	asm volatile("# beginning down_read\n\t"
 		     LOCK_PREFIX _ASM_INC "(%1)\n\t"
@@ -86,7 +91,9 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
 	long result, tmp;
 
-	if (elide_lock(rwsem_elision, sem->count == 0))
+	if (elide_lock_adapt(rwsem_elision, sem->count == 0,
+			     &sem->elision_adapt,
+			     &readsem_elision_config))
 		return 1;
 	asm volatile("# beginning __down_read_trylock\n\t"
 		     "  mov          %0,%1\n\t"
@@ -111,7 +118,9 @@ static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	long tmp;
 
-	if (elide_lock(rwsem_elision, sem->count == 0))
+	if (elide_lock_adapt(rwsem_elision, sem->count == 0,
+			     &sem->elision_adapt,
+			     &readsem_elision_config))
 		return;
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
@@ -139,7 +148,9 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
 	long ret;
 
-	if (elide_lock(rwsem_elision, sem->count == 0))
+	if (elide_lock_adapt(rwsem_elision, sem->count == 0,
+			     &sem->elision_adapt,
+			     &writesem_elision_config))
 		return 1;
 	ret = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
 			   RWSEM_ACTIVE_WRITE_BIAS);
@@ -195,6 +206,7 @@ static inline void __up_write(struct rw_semaphore *sem)
  */
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
+	/* if (sem->count == 0) return; */
 	asm volatile("# beginning __downgrade_write\n\t"
 		     LOCK_PREFIX _ASM_ADD "%2,(%1)\n\t"
 		     /*
diff --git a/arch/x86/kernel/rtm-locks.c b/arch/x86/kernel/rtm-locks.c
index 40a0e7d..5a33a12 100644
--- a/arch/x86/kernel/rtm-locks.c
+++ b/arch/x86/kernel/rtm-locks.c
@@ -436,6 +436,15 @@ static unsigned rtm_patch(u8 type, u16 clobbers, void *ibuf,
 struct static_key mutex_elision = STATIC_KEY_INIT_FALSE;
 module_param(mutex_elision, static_key, 0644);
 
+struct static_key rwsem_elision = STATIC_KEY_INIT_FALSE;
+module_param(rwsem_elision, static_key, 0644);
+__read_mostly struct elision_config readsem_elision_config =
+	DEFAULT_ELISION_CONFIG;
+TUNE_ELISION_CONFIG(readsem, readsem_elision_config);
+__read_mostly struct elision_config writesem_elision_config =
+	DEFAULT_ELISION_CONFIG;
+TUNE_ELISION_CONFIG(writesem, writesem_elision_config);
+
 void init_rtm_spinlocks(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_RTM))
@@ -464,6 +473,7 @@ void init_rtm_spinlocks(void)
 
 	static_key_slow_inc(&rwlock_elision);
 	static_key_slow_inc(&mutex_elision);
+	static_key_slow_inc(&rwsem_elision);
 	bitlock_elision = true;
 }
 
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 436e430..fb96c565 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -28,6 +28,9 @@ struct rw_semaphore {
 	long			count;
 	raw_spinlock_t		wait_lock;
 	struct list_head	wait_list;
+#ifdef CONFIG_RTM_LOCKS
+	short			elision_adapt;
+#endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
-- 
1.7.7.6

