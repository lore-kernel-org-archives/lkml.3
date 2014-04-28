Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbaD1Txg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:53:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28105 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933074AbaD1Tx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:53:29 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/10] clocksource: Sched clock source for Versatile Express
Date: Mon, 28 Apr 2014 18:57:53 +0100
Message-Id: <1398707877-22596-7-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a trival sched clock source using free
running, 24MHz clocked counter present in the ARM Ltd.
reference platforms (Versatile, RealView, Versatile
Express) System Registers block.

This code replaces the call in the VE machine code.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/mach-vexpress/v2m.c    |  2 --
 drivers/clocksource/Kconfig     | 11 +++++++++++
 drivers/clocksource/Makefile    |  1 +
 drivers/clocksource/versatile.c | 40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clocksource/versatile.c

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 90f04c9..d8a9fd7 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -418,8 +418,6 @@ void __init v2m_dt_init_early(void)
 			pr_warning("vexpress: DT HBI (%x) is not matching "
 					"hardware (%x)!\n", dt_hbi, hbi);
 	}
-
-	versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
 }
 
 
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 96918e1..2c27b02 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -191,3 +191,14 @@ config EM_TIMER_STI
 
 config CLKSRC_QCOM
 	bool
+
+config CLKSRC_VERSATILE
+	bool "ARM Versatile (Express) reference platforms clock source"
+	depends on GENERIC_SCHED_CLOCK
+	select CLKSRC_OF
+	default y if MFD_VEXPRESS_SYSREG
+	help
+	  This option enables clock source based on free running
+	  counter available in the "System Registers" block of
+	  ARM Versatile, RealView and Versatile Express reference
+	  platforms.
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 98cb6c5..6f25bdf 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
 obj-$(CONFIG_ARCH_KEYSTONE)		+= timer-keystone.o
+obj-$(CONFIG_CLKSRC_VERSATILE)		+= versatile.o
diff --git a/drivers/clocksource/versatile.c b/drivers/clocksource/versatile.c
new file mode 100644
index 0000000..e4c50ad
--- /dev/null
+++ b/drivers/clocksource/versatile.c
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
+ * Copyright (C) 2014 ARM Limited
+ */
+
+#include <linux/clocksource.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/sched_clock.h>
+
+#define SYS_24MHZ 0x05c
+
+static void __iomem *versatile_sys_24mhz;
+
+static u32 notrace versatile_sys_24mhz_read(void)
+{
+	return readl(versatile_sys_24mhz);
+}
+
+static void __init versatile_sched_clock_init(struct device_node *node)
+{
+	void __iomem *base = of_iomap(node, 0);
+
+	if (!base)
+		return;
+
+	versatile_sys_24mhz = base + SYS_24MHZ;
+
+	setup_sched_clock(versatile_sys_24mhz_read, 32, 24000000);
+}
+CLOCKSOURCE_OF_DECLARE(versatile, "arm,vexpress-sysreg",
+		versatile_sched_clock_init);
-- 
1.9.1

