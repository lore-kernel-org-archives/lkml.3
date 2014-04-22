Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaDVOSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:18:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44803 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbaDVOSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:18:00 -0400
From: Leela Krishna Amudala <leela.krishna@linaro.org>
To: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: daniel.lezcano@linaro.org, kgene.kim@samsung.com, amit.kucheria@linaro.org
Subject: [PATCH] ARM: EXYNOS: cpu hotplug: use v7_exit_coherency_flush macro for cache disabling
Date: Tue, 22 Apr 2014 19:48:00 +0530
Message-Id: <1398176280-7258-1-git-send-email-leela.krishna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the duplicated code for cache disabling and use "v7_exit_coherency_flush"
macro to do the same job.

Signed-off-by: Leela Krishna Amudala <leela.krishna@linaro.org>

---
cpu hotplug is tested with 3.15-rc1 on Origen(which has cortex A9) and
Arndale octa(which has cortex A7 and A15) boards.

 arch/arm/mach-exynos/hotplug.c |   56 ++--------------------------------------
 1 file changed, 2 insertions(+), 54 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 5eead53..9eb8d1b 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -24,56 +24,6 @@
 #include "common.h"
 #include "regs-pmu.h"
 
-static inline void cpu_enter_lowpower_a9(void)
-{
-	unsigned int v;
-
-	asm volatile(
-	"	mcr	p15, 0, %1, c7, c5, 0\n"
-	"	mcr	p15, 0, %1, c7, c10, 4\n"
-	/*
-	 * Turn off coherency
-	 */
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	bic	%0, %0, %3\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	"	mrc	p15, 0, %0, c1, c0, 0\n"
-	"	bic	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	  : "=&r" (v)
-	  : "r" (0), "Ir" (CR_C), "Ir" (0x40)
-	  : "cc");
-}
-
-static inline void cpu_enter_lowpower_a15(void)
-{
-	unsigned int v;
-
-	asm volatile(
-	"	mrc	p15, 0, %0, c1, c0, 0\n"
-	"	bic	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	  : "=&r" (v)
-	  : "Ir" (CR_C)
-	  : "cc");
-
-	flush_cache_louis();
-
-	asm volatile(
-	/*
-	* Turn off coherency
-	*/
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	bic	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	: "=&r" (v)
-	: "Ir" (0x40)
-	: "cc");
-
-	isb();
-	dsb();
-}
-
 static inline void cpu_leave_lowpower(void)
 {
 	unsigned int v;
@@ -141,10 +91,8 @@ void __ref exynos_cpu_die(unsigned int cpu)
 	 * appropriate sequence for entering low power.
 	 */
 	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
-	if ((primary_part & 0xfff0) == 0xc0f0)
-		cpu_enter_lowpower_a15();
-	else
-		cpu_enter_lowpower_a9();
+
+	v7_exit_coherency_flush(louis);
 
 	platform_do_lowpower(cpu, &spurious);
 
-- 
1.7.9.5

