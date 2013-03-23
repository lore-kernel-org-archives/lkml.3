Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423216Ab3CWBaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:30:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:44419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422849Ab3CWBZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338480"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 26/29] x86, tsx: Add adaptation support to rw spinlocks
Date: Fri, 22 Mar 2013 18:25:20 -0700
Message-Id: <1364001923-10796-27-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add elision adaptation state to the rwlocks and use the generic
adaptation wrapper. This unfortunately increases the size of the rwlock:
6 bytes for NR_CPUS>=2048, otherwise by 2 bytes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/rwlock.h |   30 +++++++++++++++++++++---------
 arch/x86/kernel/rtm-locks.c   |   22 +++++++++++++++++-----
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/rwlock.h b/arch/x86/include/asm/rwlock.h
index a5370a0..a3929cc 100644
--- a/arch/x86/include/asm/rwlock.h
+++ b/arch/x86/include/asm/rwlock.h
@@ -6,9 +6,15 @@
 #if CONFIG_NR_CPUS <= 2048
 
 #ifndef __ASSEMBLY__
-typedef union {
-	s32 lock;
-	s32 write;
+typedef struct {
+	union {
+		s32 lock;
+		s32 write;
+	};
+#ifdef CONFIG_RTM_LOCKS
+	short	elision_adapt;
+	/* 2 bytes padding */
+#endif
 } arch_rwlock_t;
 #endif
 
@@ -24,12 +30,18 @@ typedef union {
 #include <linux/const.h>
 
 #ifndef __ASSEMBLY__
-typedef union {
-	s64 lock;
-	struct {
-		u32 read;
-		s32 write;
+typedef struct {
+	union {
+		s64 lock;
+		struct {
+			u32 read;
+			s32 write;
+		};
 	};
+#ifdef CONFIG_RTM_LOCKS
+	short	elision_adapt;
+	/* 6 bytes padding for now */
+#endif
 } arch_rwlock_t;
 #endif
 
@@ -42,7 +54,7 @@ typedef union {
 
 #endif /* CONFIG_NR_CPUS */
 
-#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#define __ARCH_RW_LOCK_UNLOCKED		{ { RW_LOCK_BIAS } }
 
 /* Actual code is in asm/spinlock.h or in arch/x86/lib/rwlock.S */
 
diff --git a/arch/x86/kernel/rtm-locks.c b/arch/x86/kernel/rtm-locks.c
index 1651049..bc3275a 100644
--- a/arch/x86/kernel/rtm-locks.c
+++ b/arch/x86/kernel/rtm-locks.c
@@ -155,8 +155,16 @@ static int rtm_spin_is_locked(struct arch_spinlock *lock)
  * This uses direct calls with static patching, not pvops.
  */
 
-__read_mostly bool rwlock_elision = true;
-module_param(rwlock_elision, bool, 0644);
+static struct static_key rwlock_elision = STATIC_KEY_INIT_FALSE;
+module_param(rwlock_elision, static_key, 0644);
+
+static __read_mostly struct elision_config readlock_elision_config =
+	DEFAULT_ELISION_CONFIG;
+TUNE_ELISION_CONFIG(readlock, readlock_elision_config);
+
+static __read_mostly struct elision_config writelock_elision_config =
+	DEFAULT_ELISION_CONFIG;
+TUNE_ELISION_CONFIG(writelock, writelock_elision_config);
 
 void rtm_read_lock(arch_rwlock_t *rw)
 {
@@ -167,7 +175,8 @@ void rtm_read_lock(arch_rwlock_t *rw)
 	 * would abort anyways.
 	 */
 
-	if (!elide_lock(rwlock_elision, !arch_rwlock_is_locked(rw)))
+	if (!elide_lock_adapt(rwlock_elision, !arch_rwlock_is_locked(rw),
+			      &rw->elision_adapt, &readlock_elision_config))
 		arch_do_read_lock(rw);
 }
 EXPORT_SYMBOL(rtm_read_lock);
@@ -210,7 +219,8 @@ EXPORT_SYMBOL(rtm_read_unlock_irqrestore);
 
 int rtm_read_trylock(arch_rwlock_t *rw)
 {
-	if (elide_lock(rwlock_elision, !arch_rwlock_is_locked(rw)))
+	if (elide_lock_adapt(rwlock_elision, !arch_rwlock_is_locked(rw),
+			     &rw->elision_adapt, &readlock_elision_config))
 		return 1;
 	return arch_do_read_trylock(rw);
 }
@@ -218,7 +228,8 @@ EXPORT_SYMBOL(rtm_read_trylock);
 
 void rtm_write_lock(arch_rwlock_t *rw)
 {
-	if (!elide_lock(rwlock_elision, !arch_write_can_lock(rw)))
+	if (!elide_lock_adapt(rwlock_elision, !arch_write_can_lock(rw),
+			      &rw->elision_adapt, &writelock_elision_config))
 		arch_do_write_lock(rw);
 }
 EXPORT_SYMBOL(rtm_write_lock);
@@ -451,6 +462,7 @@ void init_rtm_spinlocks(void)
 	pv_irq_ops.restore_fl = PV_CALLEE_SAVE(rtm_restore_fl);
 	pv_init_ops.patch = rtm_patch;
 
+	static_key_slow_inc(&rwlock_elision);
 	static_key_slow_inc(&mutex_elision);
 }
 
-- 
1.7.7.6

