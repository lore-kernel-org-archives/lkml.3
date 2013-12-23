Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab3LWQ1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:27:17 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39554 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3LWQYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:08 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC 11/18] clocksource: Sched clock source for Versatile Express
Date: Mon, 23 Dec 2013 16:23:43 +0000
Message-Id: <1387815830-8794-12-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:06.0072 (UTC) FILETIME=[666E9380:01CEFFFB]
X-MC-Unique: 113122316240700301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGROmn026638

This patch adds a trival sched clock source using free
running, 24MHz clocked counter present in the ARM Ltd.
Versatile Express platform's System Registers block.

This code replaces the call in the VE machine code.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-vexpress/v2m.c   |  2 --
 drivers/clocksource/Kconfig    |  9 +++++++++
 drivers/clocksource/Makefile   |  1 +
 drivers/clocksource/vexpress.c | 40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clocksource/vexpress.c

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 4f8b8cb..8e0e872 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -419,8 +419,6 @@ void __init v2m_dt_init_early(void)
 			pr_warning("vexpress: DT HBI (%x) is not matching "
 					"hardware (%x)!\n", dt_hbi, hbi);
 	}
-
-	versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
 }
 
 static const struct of_device_id v2m_dt_bus_match[] __initconst = {
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 634c4d6..93204e0 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -136,3 +136,12 @@ config VF_PIT_TIMER
 	bool
 	help
 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
+
+config CLKSRC_VEXPRESS
+	bool
+	depends on MFD_VEXPRESS_SYSREG
+	depends on GENERIC_SCHED_CLOCK
+	select CLKSRC_OF
+	default y
+	help
+	  Simple provider of sched clock on ARM Versatile Express platform.
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 33621ef..7c2e338 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
+obj-$(CONFIG_CLKSRC_VEXPRESS)	+= vexpress.o
diff --git a/drivers/clocksource/vexpress.c b/drivers/clocksource/vexpress.c
new file mode 100644
index 0000000..55b8ab4
--- /dev/null
+++ b/drivers/clocksource/vexpress.c
@@ -0,0 +1,40 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2013 ARM Limited
+ */
+
+#include <linux/clocksource.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/sched_clock.h>
+
+#define SYS_24MHZ 0x05c
+
+static void __iomem *vexpress_sys_24mhz;
+
+static u32 notrace vexpress_sys_24mhz_read(void)
+{
+	return readl(vexpress_sys_24mhz);
+}
+
+static void __init vexpress_sched_clock_init(struct device_node *node)
+{
+	void __iomem *base = of_iomap(node, 0);
+
+	if (!base)
+		return;
+
+	vexpress_sys_24mhz = base + SYS_24MHZ;
+
+	setup_sched_clock(vexpress_sys_24mhz_read, 32, 24000000);
+}
+CLOCKSOURCE_OF_DECLARE(vexpress, "arm,vexpress-sysreg",
+		vexpress_sched_clock_init);
-- 
1.8.3.2


