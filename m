Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3EGOkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:40:31 -0400
Received: from relay2.sgi.com ([192.48.179.30]:46911 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752298Ab3EGOk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:40:29 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <rja@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        <stable@vger.kernel.org>
Subject: [PATCH -v8 01/11] CPU hotplug: Provide a generic helper to disable/enable CPU hotplug
Date: Tue,  7 May 2013 09:39:45 -0500
Message-Id: <1367937595-32241-2-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367937595-32241-1-git-send-email-holt@sgi.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

There are instances in the kernel where we would like to disable
CPU hotplug (from sysfs) during some important operation. Today
the freezer code depends on this and the code to do it was kinda
tailor-made for that.

Restructure the code and make it generic enough to be useful for
other usecases too.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Cc: <stable@vger.kernel.org>

---

Changes since -v6:
 - Added a #define for non-hotplug case.
---
 include/linux/cpu.h |  3 +++
 kernel/cpu.c        | 27 +++++++++------------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index c6f6e08..3e450c0 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -141,6 +141,8 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
 }
 #endif
 
+extern void cpu_hotplug_disable(void);
+extern void cpu_hotplug_enable(void);
 int cpu_up(unsigned int cpu);
 void notify_cpu_starting(unsigned int cpu);
 extern void cpu_maps_update_begin(void);
@@ -148,6 +150,7 @@ extern void cpu_maps_update_done(void);
 
 #else	/* CONFIG_SMP */
 
+#define cpu_hotplug_disable()	do { } while (0)
 #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 
 static inline int register_cpu_notifier(struct notifier_block *nb)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b5e4ab2..28769f5 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -541,29 +541,20 @@ static int __init alloc_frozen_cpus(void)
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
+ * Wait for currently running CPU hotplug operations to complete (if any) and
+ * disable future CPU hotplug (from sysfs). The 'cpu_add_remove_lock' protects
+ * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
+ * hotplug path before performing hotplug operations. So acquiring that lock
+ * guarantees mutual exclusion from any currently running hotplug operations.
  */
-void cpu_hotplug_disable_before_freeze(void)
+void cpu_hotplug_disable(void)
 {
 	cpu_maps_update_begin();
 	cpu_hotplug_disabled = 1;
 	cpu_maps_update_done();
 }
 
-
-/*
- * When tasks have been thawed, re-enable regular CPU hotplug (which had been
- * disabled while beginning to freeze tasks).
- */
-void cpu_hotplug_enable_after_thaw(void)
+void cpu_hotplug_enable(void)
 {
 	cpu_maps_update_begin();
 	cpu_hotplug_disabled = 0;
@@ -589,12 +580,12 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 
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
1.8.2.1

