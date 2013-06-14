Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab3FNNXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:23:00 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50619 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3FNNW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:22:59 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] ARM: ux500: add restart support via prcmu
Date: Fri, 14 Jun 2013 15:22:40 +0200
Message-Id: <1371216160-2595-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary code to restart ux500 based machines using
prcmu_system_reset().

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Hi Linus,

this is something I had in my tree for some time.  This adds basic
soft-reboot support for all ux500 machines using prcmu (the actual
reboot code was already there) and may also be useful as a base to add
the remaining "reboot reason" code if necessary.

This is based on your current ste-next branch.

Thanks,
Fabio

 arch/arm/mach-ux500/board-mop500.c | 4 ++++
 arch/arm/mach-ux500/cpu-db8500.c   | 1 +
 arch/arm/mach-ux500/cpu.c          | 8 ++++++++
 arch/arm/mach-ux500/setup.h        | 2 ++
 4 files changed, 15 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 2d70e2b..bb569bf 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -697,6 +697,7 @@ MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
 	.init_time	= ux500_timer_init,
 	.init_machine	= mop500_init_machine,
 	.init_late	= ux500_init_late,
+	.restart        = ux500_restart,
 MACHINE_END
 
 MACHINE_START(U8520, "ST-Ericsson U8520 Platform HREFP520")
@@ -706,6 +707,7 @@ MACHINE_START(U8520, "ST-Ericsson U8520 Platform HREFP520")
 	.init_time	= ux500_timer_init,
 	.init_machine	= mop500_init_machine,
 	.init_late	= ux500_init_late,
+	.restart        = ux500_restart,
 MACHINE_END
 
 MACHINE_START(HREFV60, "ST-Ericsson U8500 Platform HREFv60+")
@@ -716,6 +718,7 @@ MACHINE_START(HREFV60, "ST-Ericsson U8500 Platform HREFv60+")
 	.init_time	= ux500_timer_init,
 	.init_machine	= hrefv60_init_machine,
 	.init_late	= ux500_init_late,
+	.restart        = ux500_restart,
 MACHINE_END
 
 MACHINE_START(SNOWBALL, "Calao Systems Snowball platform")
@@ -727,4 +730,5 @@ MACHINE_START(SNOWBALL, "Calao Systems Snowball platform")
 	.init_time	= ux500_timer_init,
 	.init_machine	= snowball_init_machine,
 	.init_late	= NULL,
+	.restart        = ux500_restart,
 MACHINE_END
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 27e5566..caded58 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -326,6 +326,7 @@ DT_MACHINE_START(U8500_DT, "ST-Ericsson Ux5x0 platform (Device Tree Support)")
 	.init_machine	= u8500_init_machine,
 	.init_late	= NULL,
 	.dt_compat      = stericsson_dt_platform_compat,
+	.restart        = ux500_restart,
 MACHINE_END
 
 #endif
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index b6145ea..7490224 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -31,6 +31,14 @@
 #include "db8500-regs.h"
 #include "id.h"
 
+void ux500_restart(char mode, const char *cmd)
+{
+	local_irq_disable();
+	local_fiq_disable();
+
+	prcmu_system_reset(0);
+}
+
 /*
  * FIXME: Should we set up the GPIO domain here?
  *
diff --git a/arch/arm/mach-ux500/setup.h b/arch/arm/mach-ux500/setup.h
index cad3ca8..e8be021 100644
--- a/arch/arm/mach-ux500/setup.h
+++ b/arch/arm/mach-ux500/setup.h
@@ -15,6 +15,8 @@
 #include <linux/init.h>
 #include <linux/mfd/abx500/ab8500.h>
 
+void ux500_restart(char mode, const char *cmd);
+
 void __init ux500_map_io(void);
 extern void __init u8500_map_io(void);
 
-- 
1.8.2

