Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaC1VM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:12:59 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:65435 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaC1VMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:12:46 -0400
From: Alex Elder <elder@linaro.org>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, viresh.linux@gmail.com,
        shiraz.hashim@gmail.com, catalin.marinas@arm.com
Cc: spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/7] ARM: realview: use central SMP spin-table routines
Date: Fri, 28 Mar 2014 16:12:56 -0500
Message-Id: <1396041180-29897-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396041180-29897-1-git-send-email-elder@linaro.org>
References: <1396041180-29897-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first of three patches involved replacing the use of smp
operations defined under arch/arm/mach-versatile.  Both realview and
vexpress use the same smp_boot_secondary and smp_secondary_init
functions, and those are equivalent to the common ones now available
in arch/arm/kernel/smp.c.

We can't get rid of the mach-versatile functions yet, so this patch
just switches mach-realview to use the common routines.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/mach-realview/platsmp.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index 98e3052..b27dd07 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -21,8 +21,6 @@
 #include <mach/board-pb11mp.h>
 #include <mach/board-pbx.h>
 
-#include <plat/platsmp.h>
-
 #include "core.h"
 
 static void __iomem *scu_base_addr(void)
@@ -71,15 +69,15 @@ static void __init realview_smp_prepare_cpus(unsigned int max_cpus)
 	 * until it receives a soft interrupt, and then the
 	 * secondary CPU branches to this address.
 	 */
-	__raw_writel(virt_to_phys(versatile_secondary_startup),
+	__raw_writel(virt_to_phys(secondary_holding_pen),
 		     __io_address(REALVIEW_SYS_FLAGSSET));
 }
 
 struct smp_operations realview_smp_ops __initdata = {
 	.smp_init_cpus		= realview_smp_init_cpus,
 	.smp_prepare_cpus	= realview_smp_prepare_cpus,
-	.smp_secondary_init	= versatile_secondary_init,
-	.smp_boot_secondary	= versatile_boot_secondary,
+	.smp_secondary_init	= smp_secondary_init,
+	.smp_boot_secondary	= smp_boot_secondary,
 #ifdef CONFIG_HOTPLUG_CPU
 	.cpu_die		= realview_cpu_die,
 #endif
-- 
1.7.9.5

