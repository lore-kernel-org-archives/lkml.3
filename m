Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423089Ab3CWB1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:27:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:62847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423000Ab3CWBZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455613"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 19/29] x86, tsx: Add support for rwsem elision
Date: Fri, 22 Mar 2013 18:25:13 -0700
Message-Id: <1364001923-10796-20-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add the standard elide wrapper macros to rwsems to enable
lock elision for rwsems. Main target is mmap_sem.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/rwsem.h |   23 ++++++++++++++++++++++-
 arch/x86/kernel/rtm-locks.c  |    3 +++
 include/linux/rwsem.h        |    3 +++
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 2dbe4a7..f9297af 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -38,6 +38,7 @@
 
 #ifdef __KERNEL__
 #include <asm/asm.h>
+#include <linux/elide.h>
 
 /*
  * The bias values and the counter type limits the number of
@@ -57,11 +58,15 @@
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
+extern bool rwsem_elision;
+
 /*
  * lock for reading
  */
 static inline void __down_read(struct rw_semaphore *sem)
 {
+	if (elide_lock(rwsem_elision, sem->count == 0))
+		return;
 	asm volatile("# beginning down_read\n\t"
 		     LOCK_PREFIX _ASM_INC "(%1)\n\t"
 		     /* adds 0x00000001 */
@@ -80,6 +85,9 @@ static inline void __down_read(struct rw_semaphore *sem)
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
 	long result, tmp;
+
+	if (elide_lock(rwsem_elision, sem->count == 0))
+		return 1;
 	asm volatile("# beginning __down_read_trylock\n\t"
 		     "  mov          %0,%1\n\t"
 		     "1:\n\t"
@@ -102,6 +110,9 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	long tmp;
+
+	if (elide_lock(rwsem_elision, sem->count == 0))
+		return;
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* adds 0xffff0001, returns the old value */
@@ -126,7 +137,11 @@ static inline void __down_write(struct rw_semaphore *sem)
  */
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	long ret = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
+	long ret;
+
+	if (elide_lock(rwsem_elision, sem->count == 0))
+		return 1;
+	ret = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
 			   RWSEM_ACTIVE_WRITE_BIAS);
 	if (ret == RWSEM_UNLOCKED_VALUE)
 		return 1;
@@ -139,6 +154,9 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
 static inline void __up_read(struct rw_semaphore *sem)
 {
 	long tmp;
+
+	if (elide_unlock(sem->count == 0))
+		return;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
@@ -157,6 +175,9 @@ static inline void __up_read(struct rw_semaphore *sem)
 static inline void __up_write(struct rw_semaphore *sem)
 {
 	long tmp;
+
+	if (elide_unlock(sem->count == 0))
+		return;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 0xffff0001, returns the old value */
diff --git a/arch/x86/kernel/rtm-locks.c b/arch/x86/kernel/rtm-locks.c
index f3ae8e6..1811028 100644
--- a/arch/x86/kernel/rtm-locks.c
+++ b/arch/x86/kernel/rtm-locks.c
@@ -351,3 +351,6 @@ void init_rtm_spinlocks(void)
 
 __read_mostly bool mutex_elision = true;
 module_param(mutex_elision, bool, 0644);
+
+__read_mostly bool rwsem_elision = true;
+module_param(rwsem_elision, bool, 0644);
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8da67d6..436e430 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -16,6 +16,8 @@
 
 #include <linux/atomic.h>
 
+#include <linux/elide.h>
+
 struct rw_semaphore;
 
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
@@ -42,6 +44,7 @@ extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 /* In all implementations count != 0 means locked */
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
 {
+	elide_abort();
 	return sem->count != 0;
 }
 
-- 
1.7.7.6

