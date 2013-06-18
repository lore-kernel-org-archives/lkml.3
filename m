Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3FRLpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:45:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56355 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab3FRLpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Russ Anderson <rja@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 73/93] CPU hotplug: provide a generic helper to disable/enable CPU hotplug
Date: Tue, 18 Jun 2013 12:43:21 +0100
Message-Id: <1371555821-12820-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit 16e53dbf10a2d7e228709a7286310e629ede5e45 upstream.

There are instances in the kernel where we would like to disable CPU
hotplug (from sysfs) during some important operation.  Today the freezer
code depends on this and the code to do it was kinda tailor-made for
that.

Restructure the code and make it generic enough to be useful for other
usecases too.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/cpu.h |  4 ++++
 kernel/cpu.c        | 55 ++++++++++++++++++++++-------------------------------
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..714e792 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -175,6 +175,8 @@ extern struct bus_type cpu_subsys;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern void cpu_hotplug_disable(void);
+extern void cpu_hotplug_enable(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -198,6 +200,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define cpu_hotplug_disable()	do { } while (0)
+#define cpu_hotplug_enable()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index a4eb522..42b5ffc 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -129,6 +129,27 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 
+/*
+ * Wait for currently running CPU hotplug operations to complete (if any) and
+ * disable future CPU hotplug (from sysfs). The 'cpu_add_remove_lock' protects
+ * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
+ * hotplug path before performing hotplug operations. So acquiring that lock
+ * guarantees mutual exclusion from any currently running hotplug operations.
+ */
+void cpu_hotplug_disable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 1;
+	cpu_maps_update_done();
+}
+
+void cpu_hotplug_enable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 0;
+	cpu_maps_update_done();
+}
+
 #else /* #if CONFIG_HOTPLUG_CPU */
 static void cpu_hotplug_begin(void) {}
 static void cpu_hotplug_done(void) {}
@@ -534,36 +555,6 @@ static int __init alloc_frozen_cpus(void)
 core_initcall(alloc_frozen_cpus);
 
 /*
- * Prevent regular CPU hotplug from racing with the freezer, by disabling CPU
- * hotplug when tasks are about to be frozen. Also, don't allow the freezer
- * to continue until any currently running CPU hotplug operation gets
- * completed.
- * To modify the 'cpu_hotplug_disabled' flag, we need to acquire the
- * 'cpu_add_remove_lock'. And this same lock is also taken by the regular
- * CPU hotplug path and released only after it is complete. Thus, we
- * (and hence the freezer) will block here until any currently running CPU
- * hotplug operation gets completed.
- */
-void cpu_hotplug_disable_before_freeze(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 1;
-	cpu_maps_update_done();
-}
-
-
-/*
- * When tasks have been thawed, re-enable regular CPU hotplug (which had been
- * disabled while beginning to freeze tasks).
- */
-void cpu_hotplug_enable_after_thaw(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 0;
-	cpu_maps_update_done();
-}
-
-/*
  * When callbacks for CPU hotplug notifications are being executed, we must
  * ensure that the state of the system with respect to the tasks being frozen
  * or not, as reported by the notification, remains unchanged *throughout the
@@ -582,12 +573,12 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 
 	case PM_SUSPEND_PREPARE:
 	case PM_HIBERNATION_PREPARE:
-		cpu_hotplug_disable_before_freeze();
+		cpu_hotplug_disable();
 		break;
 
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
-		cpu_hotplug_enable_after_thaw();
+		cpu_hotplug_enable();
 		break;
 
 	default:
-- 
1.8.1.2

