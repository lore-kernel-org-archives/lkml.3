Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab3BLSDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:03:12 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:42314 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab3BLSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:03:08 -0500
Message-ID: <511A83D8.7020202@kernel.org>
Date: Tue, 12 Feb 2013 13:03:04 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: Should SPARC use cpuidle?
References: <20130211183409.7519b73ca320baeac5ec886f@canb.auug.org.au> <51197D8B.6010407@kernel.org> <20130212173505.GA2155@merkur.ravnborg.org> <511A837B.8020804@kernel.org>
In-Reply-To: <511A837B.8020804@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------000404040702020705030902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000404040702020705030902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


>> Can you please move the definition of sparc_idle to processor_32.h
>> It is sparc32 specific - and then we do not need the __ASSEMBLY__ guards
>> as the sparc32 variant are not used from assembler.
> 
> sure, let me know if attached works.

ugh, not accustomed to sending patches via thunderbird.
hopefully this attachment works...


--------------000404040702020705030902
Content-Type: text/x-patch;
 name="0001-sparc-idle-rename-pm_idle-to-sparc_idle.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-sparc-idle-rename-pm_idle-to-sparc_idle.patch"

>From 358ca5d7e02c4559ad3fbf8135421e4a3753e979 Mon Sep 17 00:00:00 2001
From: Len Brown <len.brown@intel.com>
Date: Sat, 9 Feb 2013 23:27:26 -0500
Subject: [PATCH] sparc idle: rename pm_idle to sparc_idle
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center

(pm_idle)() is being removed from linux/pm.h
because Linux does not have such a cross-architecture concept.

sparc uses an idle function pointer in its architecture
specific code.  So we re-name sparc use of pm_idle to sparc_idle.

Maybe some day, SPARC will cut over to cpuidle...

Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/processor_32.h | 1 +
 arch/sparc/kernel/apc.c               | 3 ++-
 arch/sparc/kernel/leon_pmc.c          | 5 +++--
 arch/sparc/kernel/pmc.c               | 3 ++-
 arch/sparc/kernel/process_32.c        | 7 +++----
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/sparc/include/asm/processor_32.h b/arch/sparc/include/asm/processor_32.h
index c1e0191..2c7baa4 100644
--- a/arch/sparc/include/asm/processor_32.h
+++ b/arch/sparc/include/asm/processor_32.h
@@ -118,6 +118,7 @@ extern unsigned long get_wchan(struct task_struct *);
 extern struct task_struct *last_task_used_math;
 
 #define cpu_relax()	barrier()
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


--------------000404040702020705030902--
