Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3JXXyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 19:54:14 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:38756 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab3JXXyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 19:54:11 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@linaro.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v8.1 10/10] MCS Lock: Make mcs_spinlock.h includable in other files
Date: Thu, 24 Oct 2013 19:53:29 -0400
Message-Id: <1382658809-21749-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes are made to enable mcs_spinlock.h file to be
widely included in other files without causing problem:

1) Include a number of prerequisite header files and define
   arch_mutex_cpu_relax(), if not previously defined.
2) Make mcs_spin_unlock() an inlined function and
   rename mcs_spin_lock() to _raw_mcs_spin_lock() which is also an
   inlined function.
3) Create a new mcs_spinlock.c file to contain the non-inlined
   mcs_spin_lock() function.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/mcs_spinlock.h |   27 ++++++++++++++++++++++-----
 kernel/Makefile              |    6 +++---
 kernel/mcs_spinlock.c        |   21 +++++++++++++++++++++
 3 files changed, 46 insertions(+), 8 deletions(-)
 create mode 100644 kernel/mcs_spinlock.c

diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
index 93d445d..f2c71e8 100644
--- a/include/linux/mcs_spinlock.h
+++ b/include/linux/mcs_spinlock.h
@@ -12,11 +12,27 @@
 #ifndef __LINUX_MCS_SPINLOCK_H
 #define __LINUX_MCS_SPINLOCK_H
 
+/*
+ * asm/processor.h may define arch_mutex_cpu_relax().
+ * If it is not defined, cpu_relax() will be used.
+ */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/processor.h>
+#include <linux/compiler.h>
+
+#ifndef arch_mutex_cpu_relax
+# define arch_mutex_cpu_relax() cpu_relax()
+#endif
+
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
 	int locked; /* 1 if lock acquired */
 };
 
+extern
+void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node);
+
 /*
  * In order to acquire the lock, the caller should declare a local node and
  * pass a reference of the node to this function in addition to the lock.
@@ -24,11 +40,11 @@ struct mcs_spinlock {
  * on this node->locked until the previous lock holder sets the node->locked
  * in mcs_spin_unlock().
  *
- * We don't inline mcs_spin_lock() so that perf can correctly account for the
- * time spent in this lock function.
+ * The _raw_mcs_spin_lock() function should not be called directly. Instead,
+ * users should call mcs_spin_lock().
  */
-static noinline
-void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+static inline
+void _raw_mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
 	struct mcs_spinlock *prev;
 
@@ -55,7 +71,8 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
  * Releases the lock. The caller should pass in the corresponding node that
  * was used to acquire the lock.
  */
-static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+static inline
+void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
 	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 1ce4755..2ad8454 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -50,9 +50,9 @@ obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
-obj-$(CONFIG_SMP) += spinlock.o
-obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
-obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
+obj-$(CONFIG_SMP) += spinlock.o mcs_spinlock.o
+obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o mcs_spinlock.o
+obj-$(CONFIG_PROVE_LOCKING) += spinlock.o mcs_spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificate.o
diff --git a/kernel/mcs_spinlock.c b/kernel/mcs_spinlock.c
new file mode 100644
index 0000000..309dd42
--- /dev/null
+++ b/kernel/mcs_spinlock.c
@@ -0,0 +1,21 @@
+/*
+ * MCS lock
+ *
+ * The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spin-lock
+ * with the desirable properties of being fair, and with each cpu trying
+ * to acquire the lock spinning on a local variable.
+ * It avoids expensive cache bouncings that common test-and-set spin-lock
+ * implementations incur.
+ */
+#include <linux/mcs_spinlock.h>
+#include <linux/export.h>
+
+/*
+ * We don't inline mcs_spin_lock() so that perf can correctly account for the
+ * time spent in this lock function.
+ */
+void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+{
+	_raw_mcs_spin_lock(lock, node);
+}
+EXPORT_SYMBOL(mcs_spin_lock);
-- 
1.7.1

