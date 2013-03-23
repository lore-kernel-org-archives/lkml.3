Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423264Ab3CWBbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:31:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:10220 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422837Ab3CWBZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="310741524"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 24/29] x86, tsx: Use adaptive elision for mutexes
Date: Fri, 22 Mar 2013 18:25:18 -0700
Message-Id: <1364001923-10796-25-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add the elision adaption state to struct mutex and use elide_adapt()
This allows mutexes that do not elide to automatically disable
elision on themselves for some time. This means we have a fail-safe
for mutexes that do not elide well and do not need to annotate
very mutex.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mutex.h |   20 +++++++++++++++-----
 arch/x86/kernel/rtm-locks.c  |   10 ++++++++--
 include/linux/mutex.h        |    3 +++
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mutex.h b/arch/x86/include/asm/mutex.h
index 7f585e3..bb9cf9d 100644
--- a/arch/x86/include/asm/mutex.h
+++ b/arch/x86/include/asm/mutex.h
@@ -10,8 +10,10 @@
 #define  ARCH_HAS_MUTEX_AND_OWN 1
 
 #include <linux/elide.h>
+#include <linux/jump_label.h>
 
-extern bool mutex_elision;
+extern struct static_key mutex_elision;
+extern struct elision_config mutex_elision_config;
 
 /*
  * Try speculation first and only do the normal locking and owner setting
@@ -21,8 +23,10 @@ extern bool mutex_elision;
 #define mutex_free(l) (atomic_read(&(l)->count) == 1)
 
 #define __mutex_fastpath_lock_and_own(l, s) ({				\
-			if (!elide_lock(mutex_elision,			\
-					mutex_free(l))) {		\
+			if (!elide_lock_adapt(mutex_elision,		\
+					mutex_free(l),			\
+					&l->elision_adapt,		\
+					&mutex_elision_config)) {	\
 				__mutex_fastpath_lock(&(l)->count, s);	\
 				mutex_set_owner(l);			\
 			}						\
@@ -37,7 +41,10 @@ extern bool mutex_elision;
 
 #define __mutex_fastpath_lock_retval_and_own(l, s) ({			\
 			int ret = 0;					\
-			if (!elide_lock(mutex_elision, mutex_free(l))) { \
+			if (!elide_lock_adapt(mutex_elision,		\
+					      mutex_free(l),		\
+					      &l->elision_adapt,	\
+					      &mutex_elision_config)) { \
 				ret = __mutex_fastpath_lock_retval(&(l)->count, s); \
 				if (!ret)				\
 					mutex_set_owner(l);		\
@@ -46,7 +53,10 @@ extern bool mutex_elision;
 
 #define __mutex_fastpath_trylock_and_own(l, s) ({			\
 			int ret = 1;					\
-			if (!elide_lock(mutex_elision, mutex_free(l))) {\
+			if (!elide_lock_adapt(mutex_elision,		\
+					      mutex_free(l),		\
+					      &l->elision_adapt,	\
+					      &mutex_elision_config)) { \
 				ret = __mutex_fastpath_trylock(&(l)->count, s);	\
 				if (ret)				\
 					mutex_set_owner(l);		\
diff --git a/arch/x86/kernel/rtm-locks.c b/arch/x86/kernel/rtm-locks.c
index 8d4763d..a313a81 100644
--- a/arch/x86/kernel/rtm-locks.c
+++ b/arch/x86/kernel/rtm-locks.c
@@ -416,6 +416,9 @@ static unsigned rtm_patch(u8 type, u16 clobbers, void *ibuf,
 	}
 }
 
+struct static_key mutex_elision = STATIC_KEY_INIT_FALSE;
+module_param(mutex_elision, static_key, 0644);
+
 void init_rtm_spinlocks(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_RTM))
@@ -441,10 +444,13 @@ void init_rtm_spinlocks(void)
 	pv_irq_ops.irq_enable = PV_CALLEE_SAVE(rtm_irq_enable);
 	pv_irq_ops.restore_fl = PV_CALLEE_SAVE(rtm_restore_fl);
 	pv_init_ops.patch = rtm_patch;
+
+	static_key_slow_inc(&mutex_elision);
 }
 
-__read_mostly bool mutex_elision = true;
-module_param(mutex_elision, bool, 0644);
+__read_mostly struct elision_config mutex_elision_config =
+	DEFAULT_ELISION_CONFIG;
+TUNE_ELISION_CONFIG(mutex, mutex_elision_config);
 
 __read_mostly bool rwsem_elision = true;
 module_param(rwsem_elision, bool, 0644);
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 0574095..7ae9a08 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -54,6 +54,9 @@ struct mutex {
 #if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
 	struct task_struct	*owner;
 #endif
+#ifdef CONFIG_RTM_LOCKS
+	short			elision_adapt;
+#endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
 	void			*magic;
-- 
1.7.7.6

