Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab3FSAHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:07:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35505 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933703Ab3FSAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:04:46 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/11] ARM: msm: Remove TMR and TMR0 static mappings
Date: Tue, 18 Jun 2013 17:04:34 -0700
Message-Id: <1371600281-6118-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
In-Reply-To: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody is using these mappings so just drop them. of_iomap() in
the timer driver will take care of it for us. Doing this allows
us to remove the 8x60 and 8960 iomap files completely.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Unchanged from previous sends.

 arch/arm/mach-msm/board-dt-8660.c               |  3 +-
 arch/arm/mach-msm/board-dt-8960.c               |  3 +-
 arch/arm/mach-msm/common.h                      |  2 --
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h | 41 -----------------------
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h | 44 -------------------------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |  5 ---
 arch/arm/mach-msm/io.c                          | 26 ---------------
 7 files changed, 4 insertions(+), 120 deletions(-)
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8960.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h

diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
index 492f5cd..40523da 100644
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -15,6 +15,7 @@
 #include <linux/of_platform.h>
 
 #include <asm/mach/arch.h>
+#include <asm/mach/map.h>
 
 #include <mach/board.h>
 #include "common.h"
@@ -42,7 +43,7 @@ static const char *msm8x60_fluid_match[] __initdata = {
 
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
-	.map_io = msm_map_msm8x60_io,
+	.map_io = debug_ll_io_init,
 	.init_machine = msm8x60_dt_init,
 	.init_late = msm8x60_init_late,
 	.init_time	= msm_dt_timer_init,
diff --git a/arch/arm/mach-msm/board-dt-8960.c b/arch/arm/mach-msm/board-dt-8960.c
index bb55309..59b48e7 100644
--- a/arch/arm/mach-msm/board-dt-8960.c
+++ b/arch/arm/mach-msm/board-dt-8960.c
@@ -14,6 +14,7 @@
 #include <linux/of_platform.h>
 
 #include <asm/mach/arch.h>
+#include <asm/mach/map.h>
 
 #include "common.h"
 
@@ -29,7 +30,7 @@ static const char * const msm8960_dt_match[] __initconst = {
 
 DT_MACHINE_START(MSM8960_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
-	.map_io = msm_map_msm8960_io,
+	.map_io = debug_ll_io_init,
 	.init_time	= msm_dt_timer_init,
 	.init_machine = msm_dt_init,
 	.dt_compat = msm8960_dt_match,
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index ce8215a..d8f3eac 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -19,8 +19,6 @@ extern void qsd8x50_timer_init(void);
 
 extern void msm_map_common_io(void);
 extern void msm_map_msm7x30_io(void);
-extern void msm_map_msm8x60_io(void);
-extern void msm_map_msm8960_io(void);
 extern void msm_map_qsd8x50_io(void);
 
 extern void __iomem *__msm_ioremap_caller(unsigned long phys_addr, size_t size,
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
deleted file mode 100644
index 396958b..0000000
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
- * Author: Brian Swetland <swetland@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- *
- * The MSM peripherals are spread all over across 768MB of physical
- * space, which makes just having a simple IO_ADDRESS macro to slide
- * them into the right virtual location rough.  Instead, we will
- * provide a master phys->virt mapping for peripherals here.
- *
- */
-
-#ifndef __ASM_ARCH_MSM_IOMAP_8960_H
-#define __ASM_ARCH_MSM_IOMAP_8960_H
-
-/* Physical base address and size of peripherals.
- * Ordered by the virtual base addresses they will be mapped at.
- *
- * If you add or remove entries here, you'll want to edit the
- * msm_io_desc array in arch/arm/mach-msm/io.c to reflect your
- * changes.
- *
- */
-
-#define MSM8960_TMR_PHYS	0x0200A000
-#define MSM8960_TMR_SIZE	SZ_4K
-
-#define MSM8960_TMR0_PHYS	0x0208A000
-#define MSM8960_TMR0_SIZE	SZ_4K
-
-#endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
deleted file mode 100644
index dede6aa..0000000
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
- * Author: Brian Swetland <swetland@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- *
- * The MSM peripherals are spread all over across 768MB of physical
- * space, which makes just having a simple IO_ADDRESS macro to slide
- * them into the right virtual location rough.  Instead, we will
- * provide a master phys->virt mapping for peripherals here.
- *
- */
-
-#ifndef __ASM_ARCH_MSM_IOMAP_8X60_H
-#define __ASM_ARCH_MSM_IOMAP_8X60_H
-
-/* Physical base address and size of peripherals.
- * Ordered by the virtual base addresses they will be mapped at.
- *
- * MSM_VIC_BASE must be an value that can be loaded via a "mov"
- * instruction, otherwise entry-macro.S will not compile.
- *
- * If you add or remove entries here, you'll want to edit the
- * msm_io_desc array in arch/arm/mach-msm/io.c to reflect your
- * changes.
- *
- */
-
-#define MSM8X60_TMR_PHYS	0x02000000
-#define MSM8X60_TMR_SIZE	SZ_4K
-
-#define MSM8X60_TMR0_PHYS	0x02040000
-#define MSM8X60_TMR0_SIZE	SZ_4K
-
-#endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 0b36c42..0e4f491 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -45,13 +45,8 @@
 #include "msm_iomap-7x00.h"
 #endif
 
-#include "msm_iomap-8x60.h"
-#include "msm_iomap-8960.h"
-
 /* Virtual addresses shared across all MSM targets. */
 #define MSM_CSR_BASE		IOMEM(0xE0001000)
-#define MSM_TMR_BASE		IOMEM(0xF0200000)
-#define MSM_TMR0_BASE		IOMEM(0xF0201000)
 #define MSM_GPIO1_BASE		IOMEM(0xE0003000)
 #define MSM_GPIO2_BASE		IOMEM(0xE0004000)
 
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 7bfa6ff..985f4aa 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -114,32 +114,6 @@ void __init msm_map_qsd8x50_io(void)
 }
 #endif /* CONFIG_ARCH_QSD8X50 */
 
-#ifdef CONFIG_ARCH_MSM8X60
-static struct map_desc msm8x60_io_desc[] __initdata = {
-	MSM_CHIP_DEVICE(TMR, MSM8X60),
-	MSM_CHIP_DEVICE(TMR0, MSM8X60),
-};
-
-void __init msm_map_msm8x60_io(void)
-{
-	debug_ll_io_init();
-	iotable_init(msm8x60_io_desc, ARRAY_SIZE(msm8x60_io_desc));
-}
-#endif /* CONFIG_ARCH_MSM8X60 */
-
-#ifdef CONFIG_ARCH_MSM8960
-static struct map_desc msm8960_io_desc[] __initdata = {
-	MSM_CHIP_DEVICE(TMR, MSM8960),
-	MSM_CHIP_DEVICE(TMR0, MSM8960),
-};
-
-void __init msm_map_msm8960_io(void)
-{
-	debug_ll_io_init();
-	iotable_init(msm8960_io_desc, ARRAY_SIZE(msm8960_io_desc));
-}
-#endif /* CONFIG_ARCH_MSM8960 */
-
 #ifdef CONFIG_ARCH_MSM7X30
 static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

