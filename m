Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3HAQhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:37:03 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49453 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3HAQhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:37:01 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] arm: zynq: hotplug: Remove unreachable code
Date: Thu,  1 Aug 2013 09:36:53 -0700
Message-Id: <1375375013-17117-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zynq_platform_do_lowpower() does never return. Hence remove
all code which relies on that function returning and consolidate the
remains.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/hotplug.c | 55 ++++----------------------------------------
 1 file changed, 5 insertions(+), 50 deletions(-)

diff --git a/arch/arm/mach-zynq/hotplug.c b/arch/arm/mach-zynq/hotplug.c
index c89672b..5052c70 100644
--- a/arch/arm/mach-zynq/hotplug.c
+++ b/arch/arm/mach-zynq/hotplug.c
@@ -40,44 +40,6 @@ static inline void zynq_cpu_enter_lowpower(void)
 	  : "cc");
 }
 
-static inline void zynq_cpu_leave_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-	"	mrc	p15, 0, %0, c1, c0, 0\n"
-	"	orr	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	orr	%0, %0, #0x40\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	  : "=&r" (v)
-	  : "Ir" (CR_C)
-	  : "cc");
-}
-
-static inline void zynq_platform_do_lowpower(unsigned int cpu, int *spurious)
-{
-	/*
-	 * there is no power-control hardware on this platform, so all
-	 * we can do is put the core into WFI; this is safe as the calling
-	 * code will have already disabled interrupts
-	 */
-	for (;;) {
-		dsb();
-		wfi();
-
-		/*
-		 * Getting here, means that we have come out of WFI without
-		 * having been woken up - this shouldn't happen
-		 *
-		 * Just note it happening - when we're woken, we can report
-		 * its occurrence.
-		 */
-		(*spurious)++;
-	}
-}
-
 /*
  * platform-specific code to shutdown a CPU
  *
@@ -85,20 +47,13 @@ static inline void zynq_platform_do_lowpower(unsigned int cpu, int *spurious)
  */
 void zynq_platform_cpu_die(unsigned int cpu)
 {
-	int spurious = 0;
-
-	/*
-	 * we're ready for shutdown now, so do it
-	 */
 	zynq_cpu_enter_lowpower();
-	zynq_platform_do_lowpower(cpu, &spurious);
 
 	/*
-	 * bring this CPU back into the world of cache
-	 * coherency, and then restore interrupts
+	 * there is no power-control hardware on this platform, so all
+	 * we can do is put the core into WFI; this is safe as the calling
+	 * code will have already disabled interrupts
 	 */
-	zynq_cpu_leave_lowpower();
-
-	if (spurious)
-		pr_warn("CPU%u: %u spurious wakeup calls\n", cpu, spurious);
+	for (;;)
+		cpu_do_idle();
 }
-- 
1.8.3.4

