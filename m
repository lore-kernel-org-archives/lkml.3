Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966717AbaFTKnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:43:39 -0400
Received: from gloria.sntech.de ([95.129.55.99]:36592 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965665AbaFTKni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:43:38 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 2/2] clocksource: add rockchip-specific armv7-timer setup
Date: Fri, 20 Jun 2014 12:44:49 +0200
Message-ID: <3807304.rhf3VZXZNa@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <70167479.zcs3JF0luJ@diego>
References: <70167479.zcs3JF0luJ@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The armv7-timer on Rockchip RK3288 SoCs needs an underlying timer to run.
Therefore the special rockchip,rk3288-armv7-timer does this setup and
then initializes the architected timer using the new locally exposed
arch_timer_init.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../bindings/arm/rockchip/armv7-timer.txt          | 22 +++++++++
 drivers/clocksource/Makefile                       |  1 +
 drivers/clocksource/rockchip_timer.c               | 57 ++++++++++++++++++++++
 3 files changed, 80 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/armv7-timer.txt
 create mode 100644 drivers/clocksource/rockchip_timer.c

diff --git a/Documentation/devicetree/bindings/arm/rockchip/armv7-timer.txt b/Documentation/devicetree/bindings/arm/rockchip/armv7-timer.txt
new file mode 100644
index 0000000..4c1950a
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip/armv7-timer.txt
@@ -0,0 +1,22 @@
+Rockchip armv7-timer:
+---------------------
+
+The architected timer on rk3288 SoCs has special setup requirements, as
+the cpu-timer block needs to supply the architected timer.
+
+Required node properties:
+- compatible value : = "rockchip,rk3288-armv7-timer";
+- reg : physical base address and the size of the registers window
+        of the supplying timer block
+- CP15 Timer node properties as described in bindings/arm/arch_timer.txt
+
+Example:
+
+architected-timer {
+	compatible = "rockchip,rk3288-armv7-timer";
+	reg = <0xff810020 0x20>;
+	interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
+		     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
+		     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
+	clock-frequency = <24000000>;
+};
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 800b130..cbad225 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
 obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
+obj-$(CONFIG_ARCH_ROCKCHIP)	+= rockchip_timer.o
 obj-$(CONFIG_ARCH_U300)		+= timer-u300.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
 obj-$(CONFIG_SUN5I_HSTIMER)	+= timer-sun5i.o
diff --git a/drivers/clocksource/rockchip_timer.c b/drivers/clocksource/rockchip_timer.c
new file mode 100644
index 0000000..46c2146
--- /dev/null
+++ b/drivers/clocksource/rockchip_timer.c
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2014 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/clockchips.h>
+#include "arm_arch_timer.h"
+
+#define TIMER_LOAD_COUNT0		0x00
+#define TIMER_LOAD_COUNT1		0x04
+#define TIMER_CURRENT_VALUE0		0x08
+#define TIMER_CURRENT_VALUE1		0x0c
+#define TIMER_CONTROL_REG		0x10
+#define TIMER_INT_STATUS		0x18
+
+#define TIMER_DISABLE			(0 << 0)
+#define TIMER_ENABLE			(1 << 0)
+#define TIMER_MODE_FREE_RUNNING		(0 << 1)
+#define TIMER_MODE_USER_DEFINED_COUNT	(1 << 1)
+#define TIMER_INT_MASK			(0 << 2)
+#define TIMER_INT_UNMASK		(1 << 2)
+
+static __init void rk3288_arch_timer_init(struct device_node *np)
+{
+	void __iomem *reg_base;
+
+	reg_base = of_io_request_and_map(np, 0, "rk3288-armv7-timer");
+	if (!reg_base) {
+		pr_warn("%s: Can't get resource\n", __func__);
+		return;
+	}
+
+	writel(TIMER_DISABLE, reg_base + TIMER_CONTROL_REG);
+
+	writel(0xffffffff, reg_base + TIMER_LOAD_COUNT0);
+	writel(0xffffffff, reg_base + TIMER_LOAD_COUNT1);
+
+	writel(TIMER_ENABLE | TIMER_MODE_FREE_RUNNING,
+	       reg_base + TIMER_CONTROL_REG);
+
+	arch_timer_init(np);
+}
+CLOCKSOURCE_OF_DECLARE(rk3288_arch_timer, "rockchip,rk3288-armv7-timer",
+		       rk3288_arch_timer_init);
-- 
1.9.0


