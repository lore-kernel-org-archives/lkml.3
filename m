Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3EJALe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:11:34 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:41089 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab3EJALZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:11:25 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3/3] ARM: versatile: Make able to use UART ports for KGDB FIQ debugger
Date: Thu,  9 May 2013 17:10:51 -0700
Message-Id: <1368144651-11250-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368144651-11250-1-git-send-email-john.stultz@linaro.org>
References: <1368144651-11250-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton.vorontsov@linaro.org>

If enabled, kernel will able to enter KGDB upon serial line activity on
UART ports.

Note that even with this patch and CONFIG_KGDB_FIQ is enabled, you still
need to pass kgdb_fiq.enable=1 kernel command line option, otherwise UART
will behave in a normal way.

By default UART0 is used, but this can be changed via kgdb_fiq.uart_num
kernel command line option.

Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kernel-team@android.com
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/Kconfig                   |  1 +
 arch/arm/mach-versatile/Makefile   |  1 +
 arch/arm/mach-versatile/kgdb_fiq.c | 55 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)
 create mode 100644 arch/arm/mach-versatile/kgdb_fiq.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 66a9076..9909af3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -364,6 +364,7 @@ config ARCH_VERSATILE
 	select PLAT_VERSATILE_CLCD
 	select PLAT_VERSATILE_CLOCK
 	select VERSATILE_FPGA_IRQ
+	select ARCH_MIGHT_HAVE_KGDB_FIQ
 	help
 	  This enables support for ARM Ltd Versatile board.
 
diff --git a/arch/arm/mach-versatile/Makefile b/arch/arm/mach-versatile/Makefile
index 81fa3fe..bfd761f 100644
--- a/arch/arm/mach-versatile/Makefile
+++ b/arch/arm/mach-versatile/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_ARCH_VERSATILE_PB)		+= versatile_pb.o
 obj-$(CONFIG_MACH_VERSATILE_AB)		+= versatile_ab.o
 obj-$(CONFIG_MACH_VERSATILE_DT)		+= versatile_dt.o
 obj-$(CONFIG_PCI)			+= pci.o
+obj-$(CONFIG_KGDB_FIQ)			+= kgdb_fiq.o
diff --git a/arch/arm/mach-versatile/kgdb_fiq.c b/arch/arm/mach-versatile/kgdb_fiq.c
new file mode 100644
index 0000000..dd92e40
--- /dev/null
+++ b/arch/arm/mach-versatile/kgdb_fiq.c
@@ -0,0 +1,55 @@
+/*
+ * KGDB FIQ board support
+ *
+ * Copyright 2012 Linaro Ltd.
+ *		  Anton Vorontsov <anton.vorontsov@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kgdb.h>
+#include <mach/hardware.h>
+#include <mach/platform.h>
+#include <asm/hardware/vic.h>
+
+static void *kgdb_irq_base;
+
+static int kgdb_irq;
+module_param_named(uart_num, kgdb_irq, int, 0600);
+MODULE_PARM_DESC(uart_num, "UART<number> port to use for KGDB FIQ");
+
+static void kgdb_fiq_select(bool on)
+{
+	void __iomem *sel = kgdb_irq_base + VIC_INT_SELECT;
+	u32 msk = 1 << kgdb_irq;
+	u32 val;
+
+	pr_debug("rerouting VIC vector %d to %s\n", kgdb_irq,
+		 on ? "FIQ" : "IRQ");
+
+	val = readl(sel);
+	val &= ~msk;
+	if (on)
+		val |= msk;
+	writel(val, sel);
+}
+
+static bool kgdb_is_fiq_rised(void)
+{
+	return readl(kgdb_irq_base + VIC_FIQ_STATUS) & (1 << kgdb_irq);
+}
+
+static int __init kgdb_fiq_init(void)
+{
+	kgdb_irq_base = __io_address(VERSATILE_VIC_BASE);
+	kgdb_irq += INT_UARTINT0;
+	WARN_ON(kgdb_irq > INT_UARTINT2);
+
+	return kgdb_register_fiq(kgdb_fiq_select, kgdb_is_fiq_rised);
+}
+console_initcall(kgdb_fiq_init);
-- 
1.8.1.2

