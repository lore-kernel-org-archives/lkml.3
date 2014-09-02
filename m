Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaIBVUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:20:21 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58322 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaIBVTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:19:42 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 8/9] ARM: zynq: Remove hotplug.c
Date: Tue,  2 Sep 2014 14:19:13 -0700
Message-Id: <1409692754-13437-9-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
In-Reply-To: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hotplug code contains only a single function, which is an SMP
function. Move that to platsmp.c where all other SMP runctions reside.
That allows removing hotplug.c and declaring the cpu_die function
static.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v2:
 - don't add function prototype a second time
---
 arch/arm/mach-zynq/Makefile  |  1 -
 arch/arm/mach-zynq/common.h  |  3 ---
 arch/arm/mach-zynq/hotplug.c | 17 -----------------
 arch/arm/mach-zynq/platsmp.c | 18 ++++++++++++++++++
 4 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
index 820dff6e1eba..c85fb3f7d5cd 100644
--- a/arch/arm/mach-zynq/Makefile
+++ b/arch/arm/mach-zynq/Makefile
@@ -6,5 +6,4 @@
 obj-y				:= common.o slcr.o pm.o
 CFLAGS_REMOVE_hotplug.o		=-march=armv6k
 CFLAGS_hotplug.o 		=-Wa,-march=armv7-a -mcpu=cortex-a9
-obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 obj-$(CONFIG_SMP)		+= headsmp.o platsmp.o
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 24d6340d3fb6..2bc71273c73c 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -39,9 +39,6 @@ extern struct smp_operations zynq_smp_ops __initdata;
 
 extern void __iomem *zynq_scu_base;
 
-/* Hotplug */
-extern void zynq_platform_cpu_die(unsigned int cpu);
-
 void zynq_pm_late_init(void);
 
 static inline void zynq_core_pm_init(void)
diff --git a/arch/arm/mach-zynq/hotplug.c b/arch/arm/mach-zynq/hotplug.c
index fe44a05677e2..b685c89f11e4 100644
--- a/arch/arm/mach-zynq/hotplug.c
+++ b/arch/arm/mach-zynq/hotplug.c
@@ -12,20 +12,3 @@
  */
 #include <asm/proc-fns.h>
 
-/*
- * platform-specific code to shutdown a CPU
- *
- * Called with IRQs disabled
- */
-void zynq_platform_cpu_die(unsigned int cpu)
-{
-	zynq_slcr_cpu_state_write(cpu, true);
-
-	/*
-	 * there is no power-control hardware on this platform, so all
-	 * we can do is put the core into WFI; this is safe as the calling
-	 * code will have already disabled interrupts
-	 */
-	for (;;)
-		cpu_do_idle();
-}
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 06415eeba7e6..f722b5a83a45 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -136,6 +136,24 @@ static int zynq_cpu_kill(unsigned cpu)
 	zynq_slcr_cpu_stop(cpu);
 	return 1;
 }
+
+/*
+ * platform-specific code to shutdown a CPU
+ *
+ * Called with IRQs disabled
+ */
+static void zynq_platform_cpu_die(unsigned int cpu)
+{
+	zynq_slcr_cpu_state_write(cpu, true);
+
+	/*
+	 * there is no power-control hardware on this platform, so all
+	 * we can do is put the core into WFI; this is safe as the calling
+	 * code will have already disabled interrupts
+	 */
+	for (;;)
+		cpu_do_idle();
+}
 #endif
 
 struct smp_operations zynq_smp_ops __initdata = {
-- 
2.1.0.1.g27b9230

