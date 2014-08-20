Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaHTUmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:42:52 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61832 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaHTUmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:42:47 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 5/9] ARM: zynq: Remove invalidate cache for cpu die
Date: Wed, 20 Aug 2014 13:41:51 -0700
Message-Id: <1408567315-28479-6-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
In-Reply-To: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

As there is no Power management unit on this board, it is not possible to power
down a core, just WFI is allowed. There is no point to invalidate the cache and
exit coherency.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-and-tested-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/hotplug.c | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/arch/arm/mach-zynq/hotplug.c b/arch/arm/mach-zynq/hotplug.c
index 5052c70326e4..366f46c91365 100644
--- a/arch/arm/mach-zynq/hotplug.c
+++ b/arch/arm/mach-zynq/hotplug.c
@@ -10,35 +10,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/smp.h>
-
-#include <asm/cacheflush.h>
-#include <asm/cp15.h>
-#include "common.h"
-
-static inline void zynq_cpu_enter_lowpower(void)
-{
-	unsigned int v;
-
-	flush_cache_all();
-	asm volatile(
-	"	mcr	p15, 0, %1, c7, c5, 0\n"
-	"	dsb\n"
-	/*
-	 * Turn off coherency
-	 */
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	bic	%0, %0, #0x40\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	"	mrc	p15, 0, %0, c1, c0, 0\n"
-	"	bic	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	  : "=&r" (v)
-	  : "r" (0), "Ir" (CR_C)
-	  : "cc");
-}
+#include <asm/proc-fns.h>
 
 /*
  * platform-specific code to shutdown a CPU
@@ -47,8 +19,6 @@ static inline void zynq_cpu_enter_lowpower(void)
  */
 void zynq_platform_cpu_die(unsigned int cpu)
 {
-	zynq_cpu_enter_lowpower();
-
 	/*
 	 * there is no power-control hardware on this platform, so all
 	 * we can do is put the core into WFI; this is safe as the calling
-- 
2.0.1.1.gfbfc394

