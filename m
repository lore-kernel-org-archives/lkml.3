Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3ANFJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:09:18 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:57570 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3ANFJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:09:16 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, arm@kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] timer: vt8500: Move timer code to drivers/clocksource
Date: Mon, 14 Jan 2013 18:09:31 +1300
Message-Id: <1358140171-25390-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz>
References: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves arch-vt8500/timer.c into drivers/clocksource and
updates the necessary Kconfig/Makefile options.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/mach-vt8500/Kconfig       |    1 +
 arch/arm/mach-vt8500/Makefile      |    2 +-
 arch/arm/mach-vt8500/common.h      |    1 -
 arch/arm/mach-vt8500/timer.c       |  184 ------------------------------------
 arch/arm/mach-vt8500/vt8500.c      |    1 +
 drivers/clocksource/Kconfig        |    3 +
 drivers/clocksource/Makefile       |    1 +
 drivers/clocksource/vt8500_timer.c |  184 ++++++++++++++++++++++++++++++++++++
 include/linux/vt8500_timer.h       |   22 +++++
 9 files changed, 213 insertions(+), 186 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/timer.c
 create mode 100644 drivers/clocksource/vt8500_timer.c
 create mode 100644 include/linux/vt8500_timer.h

diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index 2ed0b7d..570a801 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -8,5 +8,6 @@ config ARCH_VT8500
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select VT8500_TIMER
 	help
 	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
diff --git a/arch/arm/mach-vt8500/Makefile b/arch/arm/mach-vt8500/Makefile
index e035251..92ceb24 100644
--- a/arch/arm/mach-vt8500/Makefile
+++ b/arch/arm/mach-vt8500/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_ARCH_VT8500) += irq.o timer.o vt8500.o
+obj-$(CONFIG_ARCH_VT8500) += irq.o vt8500.o
diff --git a/arch/arm/mach-vt8500/common.h b/arch/arm/mach-vt8500/common.h
index 6f2b843..77611a6 100644
--- a/arch/arm/mach-vt8500/common.h
+++ b/arch/arm/mach-vt8500/common.h
@@ -18,7 +18,6 @@
 
 #include <linux/of.h>
 
-void __init vt8500_timer_init(void);
 int __init vt8500_irq_init(struct device_node *node,
 				struct device_node *parent);
 
diff --git a/arch/arm/mach-vt8500/timer.c b/arch/arm/mach-vt8500/timer.c
deleted file mode 100644
index 3dd21a4..0000000
--- a/arch/arm/mach-vt8500/timer.c
+++ /dev/null
@@ -1,184 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/timer.c
- *
- *  Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-/*
- * This file is copied and modified from the original timer.c provided by
- * Alexey Charkov. Minor changes have been made for Device Tree Support.
- */
-
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
-#include <linux/delay.h>
-#include <asm/mach/time.h>
-
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-
-#define VT8500_TIMER_OFFSET	0x0100
-#define VT8500_TIMER_HZ		3000000
-#define TIMER_MATCH_VAL		0x0000
-#define TIMER_COUNT_VAL		0x0010
-#define TIMER_STATUS_VAL	0x0014
-#define TIMER_IER_VAL		0x001c		/* interrupt enable */
-#define TIMER_CTRL_VAL		0x0020
-#define TIMER_AS_VAL		0x0024		/* access status */
-#define TIMER_COUNT_R_ACTIVE	(1 << 5)	/* not ready for read */
-#define TIMER_COUNT_W_ACTIVE	(1 << 4)	/* not ready for write */
-#define TIMER_MATCH_W_ACTIVE	(1 << 0)	/* not ready for write */
-
-#define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
-
-static void __iomem *regbase;
-
-static cycle_t vt8500_timer_read(struct clocksource *cs)
-{
-	int loops = msecs_to_loops(10);
-	writel(3, regbase + TIMER_CTRL_VAL);
-	while ((readl((regbase + TIMER_AS_VAL)) & TIMER_COUNT_R_ACTIVE)
-						&& --loops)
-		cpu_relax();
-	return readl(regbase + TIMER_COUNT_VAL);
-}
-
-static struct clocksource clocksource = {
-	.name           = "vt8500_timer",
-	.rating         = 200,
-	.read           = vt8500_timer_read,
-	.mask           = CLOCKSOURCE_MASK(32),
-	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
-static int vt8500_timer_set_next_event(unsigned long cycles,
-				    struct clock_event_device *evt)
-{
-	int loops = msecs_to_loops(10);
-	cycle_t alarm = clocksource.read(&clocksource) + cycles;
-	while ((readl(regbase + TIMER_AS_VAL) & TIMER_MATCH_W_ACTIVE)
-						&& --loops)
-		cpu_relax();
-	writel((unsigned long)alarm, regbase + TIMER_MATCH_VAL);
-
-	if ((signed)(alarm - clocksource.read(&clocksource)) <= 16)
-		return -ETIME;
-
-	writel(1, regbase + TIMER_IER_VAL);
-
-	return 0;
-}
-
-static void vt8500_timer_set_mode(enum clock_event_mode mode,
-			      struct clock_event_device *evt)
-{
-	switch (mode) {
-	case CLOCK_EVT_MODE_RESUME:
-	case CLOCK_EVT_MODE_PERIODIC:
-		break;
-	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		writel(readl(regbase + TIMER_CTRL_VAL) | 1,
-			regbase + TIMER_CTRL_VAL);
-		writel(0, regbase + TIMER_IER_VAL);
-		break;
-	}
-}
-
-static struct clock_event_device clockevent = {
-	.name           = "vt8500_timer",
-	.features       = CLOCK_EVT_FEAT_ONESHOT,
-	.rating         = 200,
-	.set_next_event = vt8500_timer_set_next_event,
-	.set_mode       = vt8500_timer_set_mode,
-};
-
-static irqreturn_t vt8500_timer_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *evt = dev_id;
-	writel(0xf, regbase + TIMER_STATUS_VAL);
-	evt->event_handler(evt);
-
-	return IRQ_HANDLED;
-}
-
-static struct irqaction irq = {
-	.name    = "vt8500_timer",
-	.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler = vt8500_timer_interrupt,
-	.dev_id  = &clockevent,
-};
-
-static struct of_device_id vt8500_timer_ids[] = {
-	{ .compatible = "via,vt8500-timer" },
-	{ }
-};
-
-void __init vt8500_timer_init(void)
-{
-	struct device_node *np;
-	int timer_irq;
-
-	np = of_find_matching_node(NULL, vt8500_timer_ids);
-	if (!np) {
-		pr_err("%s: Timer description missing from Device Tree\n",
-								__func__);
-		return;
-	}
-	regbase = of_iomap(np, 0);
-	if (!regbase) {
-		pr_err("%s: Missing iobase description in Device Tree\n",
-								__func__);
-		of_node_put(np);
-		return;
-	}
-	timer_irq = irq_of_parse_and_map(np, 0);
-	if (!timer_irq) {
-		pr_err("%s: Missing irq description in Device Tree\n",
-								__func__);
-		of_node_put(np);
-		return;
-	}
-
-	writel(1, regbase + TIMER_CTRL_VAL);
-	writel(0xf, regbase + TIMER_STATUS_VAL);
-	writel(~0, regbase + TIMER_MATCH_VAL);
-
-	if (clocksource_register_hz(&clocksource, VT8500_TIMER_HZ))
-		pr_err("%s: vt8500_timer_init: clocksource_register failed for %s\n",
-					__func__, clocksource.name);
-
-	clockevents_calc_mult_shift(&clockevent, VT8500_TIMER_HZ, 4);
-
-	/* copy-pasted from mach-msm; no idea */
-	clockevent.max_delta_ns =
-		clockevent_delta2ns(0xf0000000, &clockevent);
-	clockevent.min_delta_ns = clockevent_delta2ns(4, &clockevent);
-	clockevent.cpumask = cpumask_of(0);
-
-	if (setup_irq(timer_irq, &irq))
-		pr_err("%s: setup_irq failed for %s\n", __func__,
-							clockevent.name);
-	clockevents_register_device(&clockevent);
-}
-
diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index d5b9c66..b9fd9d3 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -20,6 +20,7 @@
 
 #include <linux/io.h>
 #include <linux/pm.h>
+#include <linux/vt8500_timer.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index a32b7a9..7d978c1 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -28,6 +28,9 @@ config ARMADA_370_XP_TIMER
 config SUNXI_TIMER
 	bool
 
+config VT8500_TIMER
+	bool
+
 config CLKSRC_NOMADIK_MTU
 	bool
 	depends on (ARCH_NOMADIK || ARCH_U8500)
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index a33f792..440449c 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -17,5 +17,6 @@ obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_SUNXI_TIMER)	+= sunxi_timer.o
+obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
 
 obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+= arm_generic.o
diff --git a/drivers/clocksource/vt8500_timer.c b/drivers/clocksource/vt8500_timer.c
new file mode 100644
index 0000000..3dd21a4
--- /dev/null
+++ b/drivers/clocksource/vt8500_timer.c
@@ -0,0 +1,184 @@
+/*
+ *  arch/arm/mach-vt8500/timer.c
+ *
+ *  Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * This file is copied and modified from the original timer.c provided by
+ * Alexey Charkov. Minor changes have been made for Device Tree Support.
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/delay.h>
+#include <asm/mach/time.h>
+
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#define VT8500_TIMER_OFFSET	0x0100
+#define VT8500_TIMER_HZ		3000000
+#define TIMER_MATCH_VAL		0x0000
+#define TIMER_COUNT_VAL		0x0010
+#define TIMER_STATUS_VAL	0x0014
+#define TIMER_IER_VAL		0x001c		/* interrupt enable */
+#define TIMER_CTRL_VAL		0x0020
+#define TIMER_AS_VAL		0x0024		/* access status */
+#define TIMER_COUNT_R_ACTIVE	(1 << 5)	/* not ready for read */
+#define TIMER_COUNT_W_ACTIVE	(1 << 4)	/* not ready for write */
+#define TIMER_MATCH_W_ACTIVE	(1 << 0)	/* not ready for write */
+
+#define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
+
+static void __iomem *regbase;
+
+static cycle_t vt8500_timer_read(struct clocksource *cs)
+{
+	int loops = msecs_to_loops(10);
+	writel(3, regbase + TIMER_CTRL_VAL);
+	while ((readl((regbase + TIMER_AS_VAL)) & TIMER_COUNT_R_ACTIVE)
+						&& --loops)
+		cpu_relax();
+	return readl(regbase + TIMER_COUNT_VAL);
+}
+
+static struct clocksource clocksource = {
+	.name           = "vt8500_timer",
+	.rating         = 200,
+	.read           = vt8500_timer_read,
+	.mask           = CLOCKSOURCE_MASK(32),
+	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int vt8500_timer_set_next_event(unsigned long cycles,
+				    struct clock_event_device *evt)
+{
+	int loops = msecs_to_loops(10);
+	cycle_t alarm = clocksource.read(&clocksource) + cycles;
+	while ((readl(regbase + TIMER_AS_VAL) & TIMER_MATCH_W_ACTIVE)
+						&& --loops)
+		cpu_relax();
+	writel((unsigned long)alarm, regbase + TIMER_MATCH_VAL);
+
+	if ((signed)(alarm - clocksource.read(&clocksource)) <= 16)
+		return -ETIME;
+
+	writel(1, regbase + TIMER_IER_VAL);
+
+	return 0;
+}
+
+static void vt8500_timer_set_mode(enum clock_event_mode mode,
+			      struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_PERIODIC:
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		writel(readl(regbase + TIMER_CTRL_VAL) | 1,
+			regbase + TIMER_CTRL_VAL);
+		writel(0, regbase + TIMER_IER_VAL);
+		break;
+	}
+}
+
+static struct clock_event_device clockevent = {
+	.name           = "vt8500_timer",
+	.features       = CLOCK_EVT_FEAT_ONESHOT,
+	.rating         = 200,
+	.set_next_event = vt8500_timer_set_next_event,
+	.set_mode       = vt8500_timer_set_mode,
+};
+
+static irqreturn_t vt8500_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+	writel(0xf, regbase + TIMER_STATUS_VAL);
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction irq = {
+	.name    = "vt8500_timer",
+	.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.handler = vt8500_timer_interrupt,
+	.dev_id  = &clockevent,
+};
+
+static struct of_device_id vt8500_timer_ids[] = {
+	{ .compatible = "via,vt8500-timer" },
+	{ }
+};
+
+void __init vt8500_timer_init(void)
+{
+	struct device_node *np;
+	int timer_irq;
+
+	np = of_find_matching_node(NULL, vt8500_timer_ids);
+	if (!np) {
+		pr_err("%s: Timer description missing from Device Tree\n",
+								__func__);
+		return;
+	}
+	regbase = of_iomap(np, 0);
+	if (!regbase) {
+		pr_err("%s: Missing iobase description in Device Tree\n",
+								__func__);
+		of_node_put(np);
+		return;
+	}
+	timer_irq = irq_of_parse_and_map(np, 0);
+	if (!timer_irq) {
+		pr_err("%s: Missing irq description in Device Tree\n",
+								__func__);
+		of_node_put(np);
+		return;
+	}
+
+	writel(1, regbase + TIMER_CTRL_VAL);
+	writel(0xf, regbase + TIMER_STATUS_VAL);
+	writel(~0, regbase + TIMER_MATCH_VAL);
+
+	if (clocksource_register_hz(&clocksource, VT8500_TIMER_HZ))
+		pr_err("%s: vt8500_timer_init: clocksource_register failed for %s\n",
+					__func__, clocksource.name);
+
+	clockevents_calc_mult_shift(&clockevent, VT8500_TIMER_HZ, 4);
+
+	/* copy-pasted from mach-msm; no idea */
+	clockevent.max_delta_ns =
+		clockevent_delta2ns(0xf0000000, &clockevent);
+	clockevent.min_delta_ns = clockevent_delta2ns(4, &clockevent);
+	clockevent.cpumask = cpumask_of(0);
+
+	if (setup_irq(timer_irq, &irq))
+		pr_err("%s: setup_irq failed for %s\n", __func__,
+							clockevent.name);
+	clockevents_register_device(&clockevent);
+}
+
diff --git a/include/linux/vt8500_timer.h b/include/linux/vt8500_timer.h
new file mode 100644
index 0000000..33b0ee8
--- /dev/null
+++ b/include/linux/vt8500_timer.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright 2012 Tony Prisk <linux@prisktech.co.nz>
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
+#ifndef __VT8500_TIMER_H
+#define __VT8500_TIMER_H
+
+#include <asm/mach/time.h>
+
+void vt8500_timer_init(void);
+
+#endif
-- 
1.7.9.5

