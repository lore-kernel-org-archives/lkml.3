Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaLISsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:48:24 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55657 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaLISsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:48:22 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux390@de.ibm.com (supporter:S390),
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        linux-s390@vger.kernel.org (open list:S390),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] srcu: Isolate srcu sections using CONFIG_SRCU
Date: Tue,  9 Dec 2014 13:48:21 -0500
Message-Id: <1418150903-15760-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isolate the SRCU functions and data structures within CONFIG_SRCU so that there
is a compile time failure if srcu is used when not enabled. This was decided to
be better than waiting until link time for a failure to occur.

Also make including kvm_host.h conditional on CONFIG_KVM being enabled. This
prevents build failures as KVM is dependent on SRCU.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/s390/kernel/asm-offsets.c |  7 ++++++-
 include/linux/notifier.h       | 47 ++++++++++++++++++++++++------------------
 include/linux/srcu.h           |  6 +++++-
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index ef279a1..2813a3c 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -7,12 +7,15 @@
 #define ASM_OFFSETS_C
 
 #include <linux/kbuild.h>
-#include <linux/kvm_host.h>
 #include <linux/sched.h>
 #include <asm/idle.h>
 #include <asm/vdso.h>
 #include <asm/pgtable.h>
 
+#if IS_ENABLED(CONFIG_KVM)
+#include <linux/kvm_host.h>
+#endif
+
 /*
  * Make sure that the compiler is new enough. We want a compiler that
  * is known to work with the "Q" assembler constraint.
@@ -182,8 +185,10 @@ int main(void)
 	DEFINE(__LC_PGM_TDB, offsetof(struct _lowcore, pgm_tdb));
 	DEFINE(__THREAD_trap_tdb, offsetof(struct task_struct, thread.trap_tdb));
 	DEFINE(__GMAP_ASCE, offsetof(struct gmap, asce));
+#if IS_ENABLED(CONFIG_KVM)
 	DEFINE(__SIE_PROG0C, offsetof(struct kvm_s390_sie_block, prog0c));
 	DEFINE(__SIE_PROG20, offsetof(struct kvm_s390_sie_block, prog20));
+#endif /* CONFIG_KVM */
 #endif /* CONFIG_32BIT */
 	return 0;
 }
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index d14a4c3..fe4f02a 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -47,6 +47,8 @@
  * runtime initialization.
  */
 
+struct notifier_block;
+
 typedef	int (*notifier_fn_t)(struct notifier_block *nb,
 			unsigned long action, void *data);
 
@@ -70,12 +72,6 @@ struct raw_notifier_head {
 	struct notifier_block __rcu *head;
 };
 
-struct srcu_notifier_head {
-	struct mutex mutex;
-	struct srcu_struct srcu;
-	struct notifier_block __rcu *head;
-};
-
 #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
 		spin_lock_init(&(name)->lock);	\
 		(name)->head = NULL;		\
@@ -88,11 +84,6 @@ struct srcu_notifier_head {
 		(name)->head = NULL;		\
 	} while (0)
 
-/* srcu_notifier_heads must be initialized and cleaned up dynamically */
-extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
-#define srcu_cleanup_notifier_head(name)	\
-		cleanup_srcu_struct(&(name)->srcu);
-
 #define ATOMIC_NOTIFIER_INIT(name) {				\
 		.lock = __SPIN_LOCK_UNLOCKED(name.lock),	\
 		.head = NULL }
@@ -101,7 +92,6 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
 		.head = NULL }
 #define RAW_NOTIFIER_INIT(name)	{				\
 		.head = NULL }
-/* srcu_notifier_heads cannot be initialized statically */
 
 #define ATOMIC_NOTIFIER_HEAD(name)				\
 	struct atomic_notifier_head name =			\
@@ -121,8 +111,6 @@ extern int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
 		struct notifier_block *nb);
 extern int raw_notifier_chain_register(struct raw_notifier_head *nh,
 		struct notifier_block *nb);
-extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
-		struct notifier_block *nb);
 
 extern int blocking_notifier_chain_cond_register(
 		struct blocking_notifier_head *nh,
@@ -134,8 +122,6 @@ extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
 		struct notifier_block *nb);
 extern int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
 		struct notifier_block *nb);
-extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *nh,
-		struct notifier_block *nb);
 
 extern int atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 		unsigned long val, void *v);
@@ -149,10 +135,6 @@ extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v);
 extern int __raw_notifier_call_chain(struct raw_notifier_head *nh,
 	unsigned long val, void *v, int nr_to_call, int *nr_calls);
-extern int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
-		unsigned long val, void *v);
-extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
-	unsigned long val, void *v, int nr_to_call, int *nr_calls);
 
 #define NOTIFY_DONE		0x0000		/* Don't care */
 #define NOTIFY_OK		0x0001		/* Suits me */
@@ -211,5 +193,30 @@ static inline int notifier_to_errno(int ret)
 
 extern struct blocking_notifier_head reboot_notifier_list;
 
+#ifdef CONFIG_SRCU
+
+struct srcu_notifier_head {
+	struct mutex mutex;
+	struct srcu_struct srcu;
+	struct notifier_block __rcu *head;
+};
+
+/* srcu_notifier_heads must be initialized and cleaned up dynamically
+ * srcu_notifier_heads cannot be initialized statically
+ */
+extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
+#define srcu_cleanup_notifier_head(name) cleanup_srcu_struct(&(name)->srcu)
+
+extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
+		struct notifier_block *nb);
+extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *nh,
+		struct notifier_block *nb);
+extern int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
+		unsigned long val, void *v);
+extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+
+#endif /* CONFIG_SRCU */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 9cfd962..ed9c389 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -26,6 +26,8 @@
  *
  */
 
+#ifdef CONFIG_SRCU
+
 #ifndef _LINUX_SRCU_H
 #define _LINUX_SRCU_H
 
@@ -249,4 +251,6 @@ static inline void smp_mb__after_srcu_read_unlock(void)
 	/* __srcu_read_unlock has smp_mb() internally so nothing to do here. */
 }
 
-#endif
+#endif /* _LINUX_SRCU_H */
+
+#endif /* CONFIG_SRCU */
-- 
1.9.1

