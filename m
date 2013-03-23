Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422959Ab3CWBZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:25:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:44419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422834Ab3CWBZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338473"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/29] locking, tsx: Add support for arch_spin_unlock_irq/flags
Date: Fri, 22 Mar 2013 18:25:04 -0700
Message-Id: <1364001923-10796-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The TSX RTM lock elision code needs to distinguish spin unlocks that reenable
interrupts from others. Currently this is hidden in the higher level spinlock
code. Add support for calling an architecture specific arch_spin_unlock_flags/irq
if available.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/spinlock.h         |   41 ++++++++++++++++++++++++++++++++++++++
 include/linux/spinlock_api_smp.h |    6 +---
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 7d537ce..c6c531a 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -128,11 +128,38 @@ static inline void smp_mb__after_lock(void) { smp_mb(); }
  */
 #define raw_spin_unlock_wait(lock)	arch_spin_unlock_wait(&(lock)->raw_lock)
 
+#ifndef ARCH_HAS_SPIN_UNLOCK_IRQ
+static inline void arch_spin_unlock_flags(arch_spinlock_t *lock, unsigned long flags)
+{
+	arch_spin_unlock(lock);
+	local_irq_restore(flags);
+}
+
+static inline void arch_spin_unlock_irq(arch_spinlock_t *lock)
+{
+	arch_spin_unlock(lock);
+	local_irq_enable();
+}
+#endif
+
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock);
 #define do_raw_spin_lock_flags(lock, flags) do_raw_spin_lock(lock)
  extern int do_raw_spin_trylock(raw_spinlock_t *lock);
  extern void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock);
+static inline void do_raw_spin_unlock_flags(raw_spinlock_t *lock, unsigned long flags)
+	__releases(lock)
+{
+	do_raw_spin_unlock(lock);
+	local_irq_restore(flags);
+}
+
+static inline void do_raw_spin_unlock_irq(raw_spinlock_t *lock)
+	__releases(lock)
+{
+	do_raw_spin_unlock(lock);
+	local_irq_enable();
+}
 #else
 static inline void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock)
 {
@@ -157,6 +184,20 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 	arch_spin_unlock(&lock->raw_lock);
 	__release(lock);
 }
+
+static inline void do_raw_spin_unlock_flags(raw_spinlock_t *lock, unsigned long flags)
+	__releases(lock)
+{
+	arch_spin_unlock_flags(&lock->raw_lock, flags);
+	__release(lock);
+}
+
+static inline void do_raw_spin_unlock_irq(raw_spinlock_t *lock)
+	__releases(lock)
+{
+	arch_spin_unlock_irq(&lock->raw_lock);
+	__release(lock);
+}
 #endif
 
 /*
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 51df117..cf9bf3b 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -157,16 +157,14 @@ static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
 					    unsigned long flags)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
-	do_raw_spin_unlock(lock);
-	local_irq_restore(flags);
+	do_raw_spin_unlock_flags(lock, flags);
 	preempt_enable();
 }
 
 static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
-	do_raw_spin_unlock(lock);
-	local_irq_enable();
+	do_raw_spin_unlock_irq(lock);
 	preempt_enable();
 }
 
-- 
1.7.7.6

