Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3AOGud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:50:33 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:54352 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3AOGuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:50:32 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: olof@lixom.net, arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, swarren@wwwdotorg.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] timer: vt8500: Convert vt8500 to use CLKSRC_OF
Date: Tue, 15 Jan 2013 19:50:49 +1300
Message-Id: <1358232649-19964-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts arch-vt8500 to make use of CLKSRC_OF. Doing so
removes the need for include/linux/vt8500_timer.h as vt8500_timer_init
no longer needs to be visible outside vt8500_timer.c

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
Hi Olof,

Here is the fix as requested by Stephen Warren, based on vt8500/timer.

 arch/arm/mach-vt8500/Kconfig       |    1 +
 arch/arm/mach-vt8500/vt8500.c      |    4 ++--
 drivers/clocksource/vt8500_timer.c |    3 ++-
 include/linux/vt8500_timer.h       |   22 ----------------------
 4 files changed, 5 insertions(+), 25 deletions(-)
 delete mode 100644 include/linux/vt8500_timer.h

diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index 570a801..d1cbda6 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -4,6 +4,7 @@ config ARCH_VT8500
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
+	select CLKSRC_OF
 	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index b9fd9d3..fe99b70 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -18,9 +18,9 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/clocksource.h>
 #include <linux/io.h>
 #include <linux/pm.h>
-#include <linux/vt8500_timer.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -186,8 +186,8 @@ DT_MACHINE_START(WMT_DT, "VIA/Wondermedia SoC (Device Tree Support)")
 	.dt_compat	= vt8500_dt_compat,
 	.map_io		= vt8500_map_io,
 	.init_irq	= vt8500_init_irq,
-	.init_time	= vt8500_timer_init,
 	.init_machine	= vt8500_init,
+	.init_time	= clocksource_of_init,
 	.restart	= vt8500_restart,
 	.handle_irq	= vt8500_handle_irq,
 MACHINE_END
diff --git a/drivers/clocksource/vt8500_timer.c b/drivers/clocksource/vt8500_timer.c
index 3dd21a4..b75b8e3 100644
--- a/drivers/clocksource/vt8500_timer.c
+++ b/drivers/clocksource/vt8500_timer.c
@@ -134,7 +134,7 @@ static struct of_device_id vt8500_timer_ids[] = {
 	{ }
 };
 
-void __init vt8500_timer_init(void)
+static void __init vt8500_timer_init(void)
 {
 	struct device_node *np;
 	int timer_irq;
@@ -182,3 +182,4 @@ void __init vt8500_timer_init(void)
 	clockevents_register_device(&clockevent);
 }
 
+CLOCKSOURCE_OF_DECLARE(vt8500, "via,vt8500-timer", vt8500_timer_init)
diff --git a/include/linux/vt8500_timer.h b/include/linux/vt8500_timer.h
deleted file mode 100644
index 33b0ee8..0000000
--- a/include/linux/vt8500_timer.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright 2012 Tony Prisk <linux@prisktech.co.nz>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __VT8500_TIMER_H
-#define __VT8500_TIMER_H
-
-#include <asm/mach/time.h>
-
-void vt8500_timer_init(void);
-
-#endif
-- 
1.7.9.5

