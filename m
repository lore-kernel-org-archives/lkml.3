Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423205Ab3CWBaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:30:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:7961 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422851Ab3CWBZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338481"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 27/29] locking, tsx: Add elision to bit spinlocks
Date: Fri, 22 Mar 2013 18:25:21 -0700
Message-Id: <1364001923-10796-28-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Very straight forward. Use the non-adaptive elision wrappers for
bit spinlocks. This is useful because they perform very poorly
under contention.

The functions are a bit on the big side for inlining now, but
I kept them inline for now.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/rtm-locks.c  |    5 +++--
 include/linux/bit_spinlock.h |   16 ++++++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/rtm-locks.c b/arch/x86/kernel/rtm-locks.c
index bc3275a..40a0e7d 100644
--- a/arch/x86/kernel/rtm-locks.c
+++ b/arch/x86/kernel/rtm-locks.c
@@ -464,14 +464,15 @@ void init_rtm_spinlocks(void)
 
 	static_key_slow_inc(&rwlock_elision);
 	static_key_slow_inc(&mutex_elision);
+	bitlock_elision = true;
 }
 
 __read_mostly struct elision_config mutex_elision_config =
 	DEFAULT_ELISION_CONFIG;
 TUNE_ELISION_CONFIG(mutex, mutex_elision_config);
 
-__read_mostly bool rwsem_elision = true;
-module_param(rwsem_elision, bool, 0644);
+__read_mostly bool bitlock_elision;
+module_param(bitlock_elision, bool, 0644);
 
 module_param_cb(lock_el_skip, &param_ops_percpu_uint, &lock_el_skip,
 		0644);
diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index 3b5bafc..2954b86 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -5,6 +5,9 @@
 #include <linux/preempt.h>
 #include <linux/atomic.h>
 #include <linux/bug.h>
+#include <linux/elide.h>
+
+extern bool bitlock_elision;
 
 /*
  *  bit-based spin_lock()
@@ -14,6 +17,9 @@
  */
 static inline void bit_spin_lock(int bitnum, unsigned long *addr)
 {
+	if (elide_lock(bitlock_elision, test_bit(bitnum, addr) == 0))
+		return;
+
 	/*
 	 * Assuming the lock is uncontended, this never enters
 	 * the body of the outer loop. If it is contended, then
@@ -39,6 +45,9 @@ static inline void bit_spin_lock(int bitnum, unsigned long *addr)
  */
 static inline int bit_spin_trylock(int bitnum, unsigned long *addr)
 {
+	if (elide_lock(bitlock_elision, test_bit(bitnum, addr) == 0))
+		return 1;
+
 	preempt_disable();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	if (unlikely(test_and_set_bit_lock(bitnum, addr))) {
@@ -55,6 +64,9 @@ static inline int bit_spin_trylock(int bitnum, unsigned long *addr)
  */
 static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
 {
+	if (elide_unlock(test_bit(bitnum, addr) == 0))
+		return;
+
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
 #endif
@@ -72,6 +84,9 @@ static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
  */
 static inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
 {
+	if (elide_unlock(test_bit(bitnum, addr) == 0))
+		return;
+
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
 #endif
@@ -87,6 +102,7 @@ static inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
  */
 static inline int bit_spin_is_locked(int bitnum, unsigned long *addr)
 {
+	elide_abort();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	return test_bit(bitnum, addr);
 #elif defined CONFIG_PREEMPT_COUNT
-- 
1.7.7.6

