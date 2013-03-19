Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3CSORF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:17:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:45482 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3CSORC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:17:02 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/3] kernel/SRCU: provide a static initializer
Date: Tue, 19 Mar 2013 15:16:45 +0100
Message-Id: <1363702606-31586-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de>
References: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are macros for static initializer for the three out of four
possible notifier types, that are:
	ATOMIC_NOTIFIER_HEAD()
	BLOCKING_NOTIFIER_HEAD()
	RAW_NOTIFIER_HEAD()

This patch provides a static initilizer for the forth type to make it
complete.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/notifier.h |   26 +++++++++++++++++++++-----
 include/linux/srcu.h     |    6 +++---
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index d65746e..6bfd703 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -42,9 +42,7 @@
  * in srcu_notifier_call_chain(): no cache bounces and no memory barriers.
  * As compensation, srcu_notifier_chain_unregister() is rather expensive.
  * SRCU notifier chains should be used when the chain will be called very
- * often but notifier_blocks will seldom be removed.  Also, SRCU notifier
- * chains are slightly more difficult to use because they require special
- * runtime initialization.
+ * often but notifier_blocks will seldom be removed.
  */
 
 struct notifier_block {
@@ -85,7 +83,7 @@ struct srcu_notifier_head {
 		(name)->head = NULL;		\
 	} while (0)
 
-/* srcu_notifier_heads must be initialized and cleaned up dynamically */
+/* srcu_notifier_heads must be cleaned up dynamically */
 extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
 #define srcu_cleanup_notifier_head(name)	\
 		cleanup_srcu_struct(&(name)->srcu);
@@ -98,7 +96,13 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
 		.head = NULL }
 #define RAW_NOTIFIER_INIT(name)	{				\
 		.head = NULL }
-/* srcu_notifier_heads cannot be initialized statically */
+
+#define SRCU_NOTIFIER_INIT(name, pcpu)				\
+	{							\
+		.mutex = __MUTEX_INITIALIZER(name.mutex),	\
+		.head = NULL,					\
+		.srcu = __SRCU_STRUCT_INIT(name.srcu, pcpu),	\
+	}
 
 #define ATOMIC_NOTIFIER_HEAD(name)				\
 	struct atomic_notifier_head name =			\
@@ -110,6 +114,18 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
 	struct raw_notifier_head name =				\
 		RAW_NOTIFIER_INIT(name)
 
+#define _SRCU_NOTIFIER_HEAD(name, mod)				\
+	static DEFINE_PER_CPU(struct srcu_struct_array,		\
+			name##_head_srcu_array);		\
+	mod struct srcu_notifier_head name =			\
+			SRCU_NOTIFIER_INIT(name, name##_head_srcu_array)
+
+#define SRCU_NOTIFIER_HEAD(name)				\
+	_SRCU_NOTIFIER_HEAD(name, )
+
+#define SRCU_NOTIFIER_HEAD_STATIC(name)				\
+	_SRCU_NOTIFIER_HEAD(name, static)
+
 #ifdef __KERNEL__
 
 extern int atomic_notifier_chain_register(struct atomic_notifier_head *nh,
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index d04acb8..fe9efd4 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -84,10 +84,10 @@ int init_srcu_struct(struct srcu_struct *sp);
 
 void process_srcu(struct work_struct *work);
 
-#define __SRCU_STRUCT_INIT(name)					\
+#define __SRCU_STRUCT_INIT(name, pcpu_name)				\
 	{								\
 		.completed = -300,					\
-		.per_cpu_ref = &name##_srcu_array,			\
+		.per_cpu_ref = &pcpu_name,				\
 		.queue_lock = __SPIN_LOCK_UNLOCKED(name.queue_lock),	\
 		.running = false,					\
 		.batch_queue = RCU_BATCH_INIT(name.batch_queue),	\
@@ -105,7 +105,7 @@ void process_srcu(struct work_struct *work);
 #define _DEFINE_SRCU(name, mod)						\
 	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
 	mod struct srcu_struct name =					\
-				__SRCU_STRUCT_INIT(name);
+				__SRCU_STRUCT_INIT(name, name##_srcu_array);
 
 #define DEFINE_SRCU(name)		_DEFINE_SRCU(name, )
 #define DEFINE_STATIC_SRCU(name)	_DEFINE_SRCU(name, static)
-- 
1.7.10.4

