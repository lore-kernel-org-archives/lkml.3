Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3FUAhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:37:01 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40798 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422818Ab3FUAfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:35:55 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v6 5/8] ARM: s3c64xx: Add board file for boot using Device Tree
Date: Fri, 21 Jun 2013 02:35:21 +0200
Message-Id: <1371774924-9224-6-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds board file that will be used to boot S3C64xx-based boards
using Device Tree.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/mach-s3c64xx/Kconfig           | 16 +++++++
 arch/arm/mach-s3c64xx/Makefile          |  1 +
 arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c | 83 +++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)
 create mode 100644 arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c

diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index f78a6a0..fb4258c 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -308,3 +308,19 @@ config MACH_WLF_CRAGG_6410
 	select SAMSUNG_GPIO_EXTRA128
 	help
 	  Machine support for the Wolfson Cragganmore S3C6410 variant.
+
+config MACH_S3C64XX_DT
+	bool "Samsung S3C6400/S3C6410 machine using Device Tree"
+	select CLKSRC_OF
+	select CPU_S3C6400
+	select CPU_S3C6410
+	select PINCTRL
+	select PINCTRL_S3C64XX
+	select USE_OF
+	help
+	  Machine support for Samsung S3C6400/S3C6410 machines with Device Tree
+	  enabled.
+	  Select this if a fdt blob is available for your S3C64XX SoC based
+	  board.
+	  Note: This is under development and not all peripherals can be
+	  supported with this machine file.
diff --git a/arch/arm/mach-s3c64xx/Makefile b/arch/arm/mach-s3c64xx/Makefile
index 645a8fe..6faedcf 100644
--- a/arch/arm/mach-s3c64xx/Makefile
+++ b/arch/arm/mach-s3c64xx/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_MACH_SMARTQ7)		+= mach-smartq7.o
 obj-$(CONFIG_MACH_SMDK6400)		+= mach-smdk6400.o
 obj-$(CONFIG_MACH_SMDK6410)		+= mach-smdk6410.o
 obj-$(CONFIG_MACH_WLF_CRAGG_6410)	+= mach-crag6410.o mach-crag6410-module.o
+obj-$(CONFIG_MACH_S3C64XX_DT)		+= mach-s3c64xx-dt.o
diff --git a/arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c b/arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c
new file mode 100644
index 0000000..b904c9b
--- /dev/null
+++ b/arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c
@@ -0,0 +1,83 @@
+/*
+ * Samsung's S3C64XX flattened device tree enabled machine
+ *
+ * Copyright (c) 2013 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/clk-provider.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/system_misc.h>
+
+#include <plat/cpu.h>
+#include <plat/watchdog-reset.h>
+
+#include <mach/map.h>
+
+#include "common.h"
+
+/*
+ * IO mapping for shared system controller IP.
+ *
+ * FIXME: Make remaining drivers use dynamic mapping.
+ */
+static struct map_desc s3c64xx_dt_iodesc[] __initdata = {
+	{
+		.virtual	= (unsigned long)S3C_VA_SYS,
+		.pfn		= __phys_to_pfn(S3C64XX_PA_SYSCON),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	},
+};
+
+static void __init s3c64xx_dt_map_io(void)
+{
+	debug_ll_io_init();
+	iotable_init(s3c64xx_dt_iodesc, ARRAY_SIZE(s3c64xx_dt_iodesc));
+
+	s3c64xx_init_cpu();
+
+	if (!soc_is_s3c64xx())
+		panic("SoC is not S3C64xx!");
+}
+
+static void __init s3c64xx_dt_init_platform(void)
+{
+	of_clk_init(NULL);
+	samsung_wdt_reset_of_init();
+};
+
+static void __init s3c64xx_dt_init_machine(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static void s3c64xx_dt_restart(char mode, const char *cmd)
+{
+	if (mode != 's')
+		samsung_wdt_reset();
+
+	/* if all else fails, or mode was for soft, jump to 0 */
+	soft_restart(0);
+}
+
+static char const *s3c64xx_dt_compat[] __initdata = {
+	"samsung,s3c6400",
+	"samsung,s3c6410",
+	NULL
+};
+
+DT_MACHINE_START(S3C6400_DT, "Samsung S3C64xx (Flattened Device Tree)")
+	/* Maintainer: Tomasz Figa <tomasz.figa@gmail.com> */
+	.dt_compat	= s3c64xx_dt_compat,
+	.map_io		= s3c64xx_dt_map_io,
+	.init_platform	= s3c64xx_dt_init_platform,
+	.init_machine	= s3c64xx_dt_init_machine,
+	.restart        = s3c64xx_dt_restart,
+MACHINE_END
-- 
1.8.2.1

