Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3BJF6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:58:40 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:46087 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3BJF6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:36 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        sparclinux@vger.kernel.org
Subject: [PATCH 04/16] sparc idle: rename pm_idle to sparc_idle
Date: Sun, 10 Feb 2013 00:58:11 -0500
Message-Id: <3a242f58a5f40c60568cb1e3b13f119432203f48.1360475150.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360475903-30007-1-git-send-email-lenb@kernel.org>
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
In-Reply-To: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
References: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

(pm_idle)() is being removed from linux/pm.h
because Linux does not have such a cross-architecture concept.

sparc uses an idle function pointer in its architecture
specific code.  So we re-name sparc use of pm_idle to sparc_idle.

Maybe some day, SPARC will cut over to cpuidle...

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/include/asm/processor.h | 1 +
 arch/sparc/kernel/apc.c            | 3 ++-
 arch/sparc/kernel/leon_pmc.c       | 5 +++--
 arch/sparc/kernel/pmc.c            | 3 ++-
 arch/sparc/kernel/process_32.c     | 7 +++----
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/sparc/include/asm/processor.h b/arch/sparc/include/asm/processor.h
index 2fe99e6..34baa35 100644
--- a/arch/sparc/include/asm/processor.h
+++ b/arch/sparc/include/asm/processor.h
@@ -7,5 +7,6 @@
 #endif
 
 #define nop() 		__asm__ __volatile__ ("nop")
+extern void (*sparc_idle)(void);
 
 #endif
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index 348fa1a..eefda32 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -20,6 +20,7 @@
 #include <asm/uaccess.h>
 #include <asm/auxio.h>
 #include <asm/apc.h>
+#include <asm/processor.h>
 
 /* Debugging
  * 
@@ -158,7 +159,7 @@ static int apc_probe(struct platform_device *op)
 
 	/* Assign power management IDLE handler */
 	if (!apc_no_idle)
-		pm_idle = apc_swift_idle;	
+		sparc_idle = apc_swift_idle;
 
 	printk(KERN_INFO "%s: power management initialized%s\n", 
 	       APC_DEVNAME, apc_no_idle ? " (CPU idle disabled)" : "");
diff --git a/arch/sparc/kernel/leon_pmc.c b/arch/sparc/kernel/leon_pmc.c
index 4e17432..708bca4 100644
--- a/arch/sparc/kernel/leon_pmc.c
+++ b/arch/sparc/kernel/leon_pmc.c
@@ -9,6 +9,7 @@
 #include <asm/leon_amba.h>
 #include <asm/cpu_type.h>
 #include <asm/leon.h>
+#include <asm/processor.h>
 
 /* List of Systems that need fixup instructions around power-down instruction */
 unsigned int pmc_leon_fixup_ids[] = {
@@ -69,9 +70,9 @@ static int __init leon_pmc_install(void)
 	if (sparc_cpu_model == sparc_leon) {
 		/* Assign power management IDLE handler */
 		if (pmc_leon_need_fixup())
-			pm_idle = pmc_leon_idle_fixup;
+			sparc_idle = pmc_leon_idle_fixup;
 		else
-			pm_idle = pmc_leon_idle;
+			sparc_idle = pmc_leon_idle;
 
 		printk(KERN_INFO "leon: power management initialized\n");
 	}
diff --git a/arch/sparc/kernel/pmc.c b/arch/sparc/kernel/pmc.c
index dcbb62f..8b7297f 100644
--- a/arch/sparc/kernel/pmc.c
+++ b/arch/sparc/kernel/pmc.c
@@ -17,6 +17,7 @@
 #include <asm/oplib.h>
 #include <asm/uaccess.h>
 #include <asm/auxio.h>
+#include <asm/processor.h>
 
 /* Debug
  *
@@ -63,7 +64,7 @@ static int pmc_probe(struct platform_device *op)
 
 #ifndef PMC_NO_IDLE
 	/* Assign power management IDLE handler */
-	pm_idle = pmc_swift_idle;
+	sparc_idle = pmc_swift_idle;
 #endif
 
 	printk(KERN_INFO "%s: power management initialized\n", PMC_DEVNAME);
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index be8e862..62eede1 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -43,8 +43,7 @@
  * Power management idle function 
  * Set in pm platform drivers (apc.c and pmc.c)
  */
-void (*pm_idle)(void);
-EXPORT_SYMBOL(pm_idle);
+void (*sparc_idle)(void);
 
 /* 
  * Power-off handler instantiation for pm.h compliance
@@ -75,8 +74,8 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	for (;;) {
 		while (!need_resched()) {
-			if (pm_idle)
-				(*pm_idle)();
+			if (sparc_idle)
+				(*sparc_idle)();
 			else
 				cpu_relax();
 		}
-- 
1.8.1.3.535.ga923c31

