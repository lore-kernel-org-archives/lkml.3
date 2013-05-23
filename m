Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab3EWA3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 20:29:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40012 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3EWA3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 20:29:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,724,1363158000"; 
   d="scan'208";a="49787983"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: msm: Remove gpiomux-v2 and re-organize MSM_GPIOMUX configs
Date: Wed, 22 May 2013 17:29:22 -0700
Message-Id: <1369268964-28304-2-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1369268964-28304-1-git-send-email-rvaswani@codeaurora.org>
References: <1369268964-28304-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove gpiomux-v2 as it's not being used and make way for future improvements.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig        |   13 +++-----
 arch/arm/mach-msm/Makefile       |    6 +--
 arch/arm/mach-msm/gpiomux-8x60.c |   19 ------------
 arch/arm/mach-msm/gpiomux-v2.c   |   25 ---------------
 arch/arm/mach-msm/gpiomux-v2.h   |   61 --------------------------------------
 arch/arm/mach-msm/gpiomux.c      |   15 +++++++++
 arch/arm/mach-msm/gpiomux.h      |    5 ---
 drivers/gpio/gpio-msm-v2.c       |    5 +--
 8 files changed, 24 insertions(+), 125 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-8x60.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-v2.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-v2.h

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index fceb093..614e41e 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -48,9 +48,7 @@ config ARCH_MSM8X60
 	select CPU_V7
 	select GPIO_MSM_V2
 	select HAVE_SMP
-	select MSM_GPIOMUX
 	select MSM_SCM if SMP
-	select MSM_V2_TLMM
 	select USE_OF
 
 config ARCH_MSM8960
@@ -58,9 +56,8 @@ config ARCH_MSM8960
 	select ARM_GIC
 	select CPU_V7
 	select HAVE_SMP
-	select MSM_GPIOMUX
+	select GPIO_MSM_V2
 	select MSM_SCM if SMP
-	select MSM_V2_TLMM
 	select USE_OF
 
 config MSM_HAS_DEBUG_UART_HS
@@ -124,10 +121,10 @@ config MSM_SMD
 	bool
 
 config MSM_GPIOMUX
-	bool
-
-config MSM_V2_TLMM
-	bool
+	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
+	bool "MSM V1 TLMM GPIOMUX architecture"
+	help
+	  Support for MSM V1 TLMM GPIOMUX architecture.
 
 config MSM_SCM
 	bool
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 17519fa..1a26d04 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -27,7 +27,5 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
 obj-$(CONFIG_ARCH_MSM8960) += board-dt-8960.o
-
-obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
-obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
-obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
+obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
+obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o
diff --git a/arch/arm/mach-msm/gpiomux-8x60.c b/arch/arm/mach-msm/gpiomux-8x60.c
deleted file mode 100644
index 7b380b3..0000000
--- a/arch/arm/mach-msm/gpiomux-8x60.c
+++ /dev/null
@@ -1,19 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-#include "gpiomux.h"
-
-struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
diff --git a/arch/arm/mach-msm/gpiomux-v2.c b/arch/arm/mach-msm/gpiomux-v2.c
deleted file mode 100644
index 273396d..0000000
--- a/arch/arm/mach-msm/gpiomux-v2.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-#include <linux/io.h>
-#include <mach/msm_iomap.h>
-#include "gpiomux.h"
-
-void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val)
-{
-	writel(val & ~GPIOMUX_CTL_MASK,
-	       MSM_TLMM_BASE + 0x1000 + (0x10 * gpio));
-}
diff --git a/arch/arm/mach-msm/gpiomux-v2.h b/arch/arm/mach-msm/gpiomux-v2.h
deleted file mode 100644
index 3bf10e7..0000000
--- a/arch/arm/mach-msm/gpiomux-v2.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-#ifndef __ARCH_ARM_MACH_MSM_GPIOMUX_V2_H
-#define __ARCH_ARM_MACH_MSM_GPIOMUX_V2_H
-
-#define GPIOMUX_NGPIOS 173
-
-typedef u16 gpiomux_config_t;
-
-enum {
-	GPIOMUX_DRV_2MA  = 0UL << 6,
-	GPIOMUX_DRV_4MA  = 1UL << 6,
-	GPIOMUX_DRV_6MA  = 2UL << 6,
-	GPIOMUX_DRV_8MA  = 3UL << 6,
-	GPIOMUX_DRV_10MA = 4UL << 6,
-	GPIOMUX_DRV_12MA = 5UL << 6,
-	GPIOMUX_DRV_14MA = 6UL << 6,
-	GPIOMUX_DRV_16MA = 7UL << 6,
-};
-
-enum {
-	GPIOMUX_FUNC_GPIO = 0UL  << 2,
-	GPIOMUX_FUNC_1    = 1UL  << 2,
-	GPIOMUX_FUNC_2    = 2UL  << 2,
-	GPIOMUX_FUNC_3    = 3UL  << 2,
-	GPIOMUX_FUNC_4    = 4UL  << 2,
-	GPIOMUX_FUNC_5    = 5UL  << 2,
-	GPIOMUX_FUNC_6    = 6UL  << 2,
-	GPIOMUX_FUNC_7    = 7UL  << 2,
-	GPIOMUX_FUNC_8    = 8UL  << 2,
-	GPIOMUX_FUNC_9    = 9UL  << 2,
-	GPIOMUX_FUNC_A    = 10UL << 2,
-	GPIOMUX_FUNC_B    = 11UL << 2,
-	GPIOMUX_FUNC_C    = 12UL << 2,
-	GPIOMUX_FUNC_D    = 13UL << 2,
-	GPIOMUX_FUNC_E    = 14UL << 2,
-	GPIOMUX_FUNC_F    = 15UL << 2,
-};
-
-enum {
-	GPIOMUX_PULL_NONE   = 0UL,
-	GPIOMUX_PULL_DOWN   = 1UL,
-	GPIOMUX_PULL_KEEPER = 2UL,
-	GPIOMUX_PULL_UP     = 3UL,
-};
-
-#endif
diff --git a/arch/arm/mach-msm/gpiomux.c b/arch/arm/mach-msm/gpiomux.c
index 53af21a..2b8e2d2 100644
--- a/arch/arm/mach-msm/gpiomux.c
+++ b/arch/arm/mach-msm/gpiomux.c
@@ -17,9 +17,24 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include "gpiomux.h"
+#include "proc_comm.h"
 
 static DEFINE_SPINLOCK(gpiomux_lock);
 
+static void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val)
+{
+	unsigned tlmm_config  = (val & ~GPIOMUX_CTL_MASK) |
+				((gpio & 0x3ff) << 4);
+	unsigned tlmm_disable = 0;
+	int rc;
+
+	rc = msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX,
+			   &tlmm_config, &tlmm_disable);
+	if (rc)
+		pr_err("%s: unexpected proc_comm failure %d: %08x %08x\n",
+		       __func__, rc, tlmm_config, tlmm_disable);
+}
+
 int msm_gpiomux_write(unsigned gpio,
 		      gpiomux_config_t active,
 		      gpiomux_config_t suspended)
diff --git a/arch/arm/mach-msm/gpiomux.h b/arch/arm/mach-msm/gpiomux.h
index 00459f6..8e82f41 100644
--- a/arch/arm/mach-msm/gpiomux.h
+++ b/arch/arm/mach-msm/gpiomux.h
@@ -20,12 +20,7 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <mach/msm_gpiomux.h>
-
-#if defined(CONFIG_MSM_V2_TLMM)
-#include "gpiomux-v2.h"
-#else
 #include "gpiomux-v1.h"
-#endif
 
 /**
  * struct msm_gpiomux_config: gpiomux settings for one gpio line.
diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
index dd2edde..75cc821 100644
--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -29,7 +29,6 @@
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
 
-#include <mach/msm_gpiomux.h>
 #include <mach/msm_iomap.h>
 
 /* Bits of interest in the GPIO_IN_OUT register.
@@ -159,12 +158,12 @@ static int msm_gpio_direction_output(struct gpio_chip *chip,
 
 static int msm_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
-	return msm_gpiomux_get(chip->base + offset);
+	return 0;
 }
 
 static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
-	msm_gpiomux_put(chip->base + offset);
+	return;
 }
 
 static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

