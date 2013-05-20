Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3ETGdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:33:43 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:36066 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3ETGdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:33:40 -0400
From: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Subject: [RFC PATCH 6/6] ARM: EXYNOS: use the core cpu hotplug functions
Date: Mon, 20 May 2013 12:03:28 +0530
Message-Id: <1369031608-27347-7-git-send-email-sanjay.rawat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369031608-27347-1-git-send-email-sanjay.rawat@linaro.org>
References: <1369031608-27347-1-git-send-email-sanjay.rawat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic arm cpu hotplug related functions are moved to core hotplug code,
Exynos-4 is having Cortex-A9, remove the functions from the platform code.

Signed-off-by: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
---
 arch/arm/mach-exynos/hotplug.c |   40 ++--------------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index af90cfa..3489760 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -21,30 +21,10 @@
 
 #include <mach/regs-pmu.h>
 #include <plat/cpu.h>
+#include <asm/hotplug.h>
 
 #include "common.h"
 
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
 static inline void cpu_enter_lowpower_a15(void)
 {
 	unsigned int v;
@@ -74,22 +54,6 @@ static inline void cpu_enter_lowpower_a15(void)
 	dsb();
 }
 
-static inline void cpu_leave_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-	"mrc	p15, 0, %0, c1, c0, 0\n"
-	"	orr	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	orr	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	  : "=&r" (v)
-	  : "Ir" (CR_C), "Ir" (0x40)
-	  : "cc");
-}
-
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 {
 	for (;;) {
@@ -144,7 +108,7 @@ void __ref exynos_cpu_die(unsigned int cpu)
 	if ((primary_part & 0xfff0) == 0xc0f0)
 		cpu_enter_lowpower_a15();
 	else
-		cpu_enter_lowpower_a9();
+		cpu_enter_lowpower();
 
 	platform_do_lowpower(cpu, &spurious);
 
-- 
1.7.9.5

