Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423010Ab3CWB0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:26:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:1050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423003Ab3CWB0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:26:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455611"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 17/29] x86, tsx: Enable lock elision for mutexes
Date: Fri, 22 Mar 2013 18:25:11 -0700
Message-Id: <1364001923-10796-18-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

We use the generic elision macros and the mutex hook infrastructure
added earlier. With that attempt to lock elide mutexes using
the elide() macros and the usual elision wrapping pattern.

Lock elision does not allow modifying the lock itself, so it's not
possible to set the lock owner. So we don't do that when the lock
is elided. Lock owner is only used for debugging or adaptive spinning,
but both do not apply with elision. All the checking is still done
when the lock falls back to real locking.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mutex.h |   51 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/rtm-locks.c  |    3 ++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mutex.h b/arch/x86/include/asm/mutex.h
index 7d3a482..7f585e3 100644
--- a/arch/x86/include/asm/mutex.h
+++ b/arch/x86/include/asm/mutex.h
@@ -1,5 +1,56 @@
+#ifndef _ASM_MUTEX_H
+#define _ASM_MUTEX_H 1
+
 #ifdef CONFIG_X86_32
 # include <asm/mutex_32.h>
 #else
 # include <asm/mutex_64.h>
 #endif
+
+#define  ARCH_HAS_MUTEX_AND_OWN 1
+
+#include <linux/elide.h>
+
+extern bool mutex_elision;
+
+/*
+ * Try speculation first and only do the normal locking and owner setting
+ * if that fails.
+ */
+
+#define mutex_free(l) (atomic_read(&(l)->count) == 1)
+
+#define __mutex_fastpath_lock_and_own(l, s) ({				\
+			if (!elide_lock(mutex_elision,			\
+					mutex_free(l))) {		\
+				__mutex_fastpath_lock(&(l)->count, s);	\
+				mutex_set_owner(l);			\
+			}						\
+		})
+
+#define __mutex_fastpath_unlock_and_unown(l, s) ({			\
+			if (!elide_unlock(mutex_free(l))) {		\
+				mutex_unlock_clear_owner(l);		\
+				__mutex_fastpath_unlock(&(l)->count, s); \
+			}						\
+		})
+
+#define __mutex_fastpath_lock_retval_and_own(l, s) ({			\
+			int ret = 0;					\
+			if (!elide_lock(mutex_elision, mutex_free(l))) { \
+				ret = __mutex_fastpath_lock_retval(&(l)->count, s); \
+				if (!ret)				\
+					mutex_set_owner(l);		\
+			}						\
+			ret; })
+
+#define __mutex_fastpath_trylock_and_own(l, s) ({			\
+			int ret = 1;					\
+			if (!elide_lock(mutex_elision, mutex_free(l))) {\
+				ret = __mutex_fastpath_trylock(&(l)->count, s);	\
+				if (ret)				\
+					mutex_set_owner(l);		\
+			}						\
+			ret; })
+
+#endif
diff --git a/arch/x86/kernel/rtm-locks.c b/arch/x86/kernel/rtm-locks.c
index 0717050..f3ae8e6 100644
--- a/arch/x86/kernel/rtm-locks.c
+++ b/arch/x86/kernel/rtm-locks.c
@@ -348,3 +348,6 @@ void init_rtm_spinlocks(void)
 	pv_irq_ops.restore_fl = PV_CALLEE_SAVE(rtm_restore_fl);
 	pv_init_ops.patch = rtm_patch;
 }
+
+__read_mostly bool mutex_elision = true;
+module_param(mutex_elision, bool, 0644);
-- 
1.7.7.6

