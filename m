Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaIBVTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:19:36 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:52226 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaIBVTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:19:32 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 4/9] ARM: zynq: PM: Enable DDR clock stop
Date: Tue,  2 Sep 2014 14:19:09 -0700
Message-Id: <1409692754-13437-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
In-Reply-To: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DDR controller can detect idle periods and leverage low power
features clock stop. When new requests occur, the DDRC resumes
normal operation.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v2:
 - properly document return value for zynq_pm_ioremap
 - change zynq_pm_late_init signature to return void
 - add kernel doc to late_init()
 - fix kernel doc
 - only enable clock-stop during boot and leave out self-refresh. The
   self-refresh penalty is apparently not-negligible
---
 arch/arm/mach-zynq/Makefile |  2 +-
 arch/arm/mach-zynq/common.c |  1 +
 arch/arm/mach-zynq/common.h |  2 ++
 arch/arm/mach-zynq/pm.c     | 83 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-zynq/pm.c

diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
index 1b25d92ebf22..820dff6e1eba 100644
--- a/arch/arm/mach-zynq/Makefile
+++ b/arch/arm/mach-zynq/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common support
-obj-y				:= common.o slcr.o
+obj-y				:= common.o slcr.o pm.o
 CFLAGS_REMOVE_hotplug.o		=-march=armv6k
 CFLAGS_hotplug.o 		=-Wa,-march=armv7-a -mcpu=cortex-a9
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 3cb7c198615a..6bd13e5ce6b7 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -101,6 +101,7 @@ static int __init zynq_get_revision(void)
 static void __init zynq_init_late(void)
 {
 	zynq_core_pm_init();
+	zynq_pm_late_init();
 }
 
 /**
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 596ef0b5067c..0edbb6997b1c 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -40,6 +40,8 @@ extern void __iomem *zynq_scu_base;
 /* Hotplug */
 extern void zynq_platform_cpu_die(unsigned int cpu);
 
+void zynq_pm_late_init(void);
+
 static inline void zynq_core_pm_init(void)
 {
 	/* A9 clock gating */
diff --git a/arch/arm/mach-zynq/pm.c b/arch/arm/mach-zynq/pm.c
new file mode 100644
index 000000000000..911fcf865be8
--- /dev/null
+++ b/arch/arm/mach-zynq/pm.c
@@ -0,0 +1,83 @@
+/*
+ * Zynq power management
+ *
+ *  Copyright (C) 2012 - 2014 Xilinx
+ *
+ *  Sören Brinkmann <soren.brinkmann@xilinx.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include "common.h"
+
+/* register offsets */
+#define DDRC_CTRL_REG1_OFFS		0x60
+#define DDRC_DRAM_PARAM_REG3_OFFS	0x20
+
+/* bitfields */
+#define DDRC_CLOCKSTOP_MASK	BIT(23)
+#define DDRC_SELFREFRESH_MASK	BIT(12)
+
+static void __iomem *ddrc_base;
+
+/**
+ * zynq_pm_ioremap() - Create IO mappings
+ * @comp:	DT compatible string
+ * Return: Pointer to the mapped memory or NULL.
+ *
+ * Remap the memory region for a compatible DT node.
+ */
+static void __iomem *zynq_pm_ioremap(const char *comp)
+{
+	struct device_node *np;
+	void __iomem *base = NULL;
+
+	np = of_find_compatible_node(NULL, NULL, comp);
+	if (np) {
+		base = of_iomap(np, 0);
+		of_node_put(np);
+	} else {
+		pr_warn("%s: no compatible node found for '%s'\n", __func__,
+				comp);
+	}
+
+	return base;
+}
+
+/**
+ * zynq_pm_late_init() - Power management init
+ *
+ * Initialization of power management related featurs and infrastructure.
+ */
+void __init zynq_pm_late_init(void)
+{
+	u32 reg;
+
+	ddrc_base = zynq_pm_ioremap("xlnx,zynq-ddrc-a05");
+	if (!ddrc_base) {
+		pr_warn("%s: Unable to map DDRC IO memory.\n", __func__);
+	} else {
+		/*
+		 * Enable DDRC clock stop feature. The HW takes care of
+		 * entering/exiting the correct mode depending
+		 * on activity state.
+		 */
+		reg = readl(ddrc_base + DDRC_DRAM_PARAM_REG3_OFFS);
+		reg |= DDRC_CLOCKSTOP_MASK;
+		writel(reg, ddrc_base + DDRC_DRAM_PARAM_REG3_OFFS);
+	}
+}
-- 
2.1.0.1.g27b9230

