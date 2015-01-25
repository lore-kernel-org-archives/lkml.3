Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbbAYJnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 04:43:12 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64833 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbbAYJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 04:43:05 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: heiko@sntech.de
Cc: tglx@linutronix.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: [PATCH V2] clockevents: rockchip: Add rockchip timer for rk3288
Date: Sun, 25 Jan 2015 10:42:59 +0100
Message-Id: <1422178979-12382-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rk3288 board uses the architected timers and these ones are shutdown when
the cpu is powered down. There is a need of a broadcast timer in this case to
ensure proper wakeup when the cpus are in sleep mode and a timer expires.

This driver provides the basic timer functionnality as a backup for the local
timers at sleep time.

The timer belongs to the alive subsystem. It includes two programmables 64 bits
timer channels but the driver only uses 32bits. It works with two operations
mode: free running and user defined count.

Programing sequence:

1. Timer initialization:
 * Disable the timer by writing '0' to the CONTROLREG register
 * Program the timer mode by writing the mode to the CONTROLREG register
 * Set the interrupt mask

2. Setting the count value:
 * Load the count value to the registers COUNT0 and COUNT1 (not used).

3. Enable the timer
 * Write '1' to the CONTROLREG register with the mode (free running or user)

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../bindings/timer/rockchip,rk3288-timer.txt       |  18 +++
 arch/arm/boot/dts/rk3288.dtsi                      |   8 +
 arch/arm/mach-rockchip/Kconfig                     |   1 +
 drivers/clocksource/Kconfig                        |   4 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/rockchip_timer.c               | 180 +++++++++++++++++++++
 6 files changed, 212 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/rockchip,rk3288-timer.txt
 create mode 100644 drivers/clocksource/rockchip_timer.c

diff --git a/Documentation/devicetree/bindings/timer/rockchip,rk3288-timer.txt b/Documentation/devicetree/bindings/timer/rockchip,rk3288-timer.txt
new file mode 100644
index 0000000..87f0b00
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/rockchip,rk3288-timer.txt
@@ -0,0 +1,18 @@
+Rockchip rk3288 timer
+
+Required properties:
+- compatible: shall be "rockchip,rk3288-timer"
+- reg: base address of the timer register starting with TIMERS CONTROL register
+- interrupts: should contain the interrupts for Timer0
+- clocks : must contain an entry for each entry in clock-names
+- clock-names : must include the following entries:
+  "timer", "pclk"
+
+Example:
+	timer: timer@ff810000 {
+		compatible = "rockchip,rk3288-timer";
+		reg = <0xff810000 0x20>;
+		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&xin24m>, <&cru PCLK_TIMER>;
+		clock-names = "timer", "pclk";
+	};
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 2a878a3..0930140 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -149,6 +149,14 @@
 		clock-frequency = <24000000>;
 	};
 
+	timer: timer@ff810000 {
+		compatible = "rockchip,rk3288-timer";
+		reg = <0xff810000 0x20>;
+		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&xin24m>, <&cru PCLK_TIMER>;
+		clock-names = "timer", "pclk";
+	};
+
 	sdmmc: dwmmc@ff0c0000 {
 		compatible = "rockchip,rk3288-dw-mshc";
 		clock-freq-min-max = <400000 150000000>;
diff --git a/arch/arm/mach-rockchip/Kconfig b/arch/arm/mach-rockchip/Kconfig
index ac5803c..5078932 100644
--- a/arch/arm/mach-rockchip/Kconfig
+++ b/arch/arm/mach-rockchip/Kconfig
@@ -11,6 +11,7 @@ config ARCH_ROCKCHIP
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 	select DW_APB_TIMER_OF
+	select ROCKCHIP_TIMER
 	select ARM_GLOBAL_TIMER
 	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
 	help
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index fc01ec2..5c39de7 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -26,6 +26,10 @@ config DW_APB_TIMER_OF
 	select DW_APB_TIMER
 	select CLKSRC_OF
 
+config ROCKCHIP_TIMER
+	bool
+	select CLKSRC_OF
+
 config ARMADA_370_XP_TIMER
 	bool
 	select CLKSRC_OF
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 94d90b2..0ea1342 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_CLKBLD_I8253)	+= i8253.o
 obj-$(CONFIG_CLKSRC_MMIO)	+= mmio.o
 obj-$(CONFIG_DW_APB_TIMER)	+= dw_apb_timer.o
 obj-$(CONFIG_DW_APB_TIMER_OF)	+= dw_apb_timer_of.o
+obj-$(CONFIG_ROCKCHIP_TIMER)      += rockchip_timer.o
 obj-$(CONFIG_CLKSRC_NOMADIK_MTU)	+= nomadik-mtu.o
 obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
diff --git a/drivers/clocksource/rockchip_timer.c b/drivers/clocksource/rockchip_timer.c
new file mode 100644
index 0000000..5ea290d
--- /dev/null
+++ b/drivers/clocksource/rockchip_timer.c
@@ -0,0 +1,180 @@
+/*
+ * Rockchip timer support
+ *
+ * Copyright (C) Daniel Lezcano <daniel.lezcano@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#define TIMER_NAME "rk_timer"
+
+#define TIMER_LOAD_COUNT0               0x00
+#define TIMER_LOAD_COUNT1               0x04
+#define TIMER_CONTROL_REG               0x10
+#define TIMER_INT_STATUS                0x18
+
+#define TIMER_DISABLE                   0x0
+#define TIMER_ENABLE                    0x1
+#define TIMER_MODE_FREE_RUNNING         (0 << 1)
+#define TIMER_MODE_USER_DEFINED_COUNT   (1 << 1)
+#define TIMER_INT_UNMASK                (1 << 2)
+
+struct bc_timer {
+	struct clock_event_device ce;
+	void __iomem *base;
+	u32 freq;
+};
+
+static struct bc_timer bc_timer;
+
+static inline struct bc_timer *rk_timer(struct clock_event_device *ce)
+{
+	return container_of(ce, struct bc_timer, ce);
+}
+
+static inline void __iomem *rk_base(struct clock_event_device *ce)
+{
+	return rk_timer(ce)->base;
+}
+
+static inline void rk_timer_disable(struct clock_event_device *ce)
+{
+	writel_relaxed(TIMER_DISABLE, rk_base(ce) + TIMER_CONTROL_REG);
+	dsb();
+}
+
+static inline void rk_timer_enable(struct clock_event_device *ce, u32 flags)
+{
+	writel_relaxed(TIMER_ENABLE | TIMER_INT_UNMASK | flags,
+		       rk_base(ce) + TIMER_CONTROL_REG);
+	dsb();
+}
+
+static void rk_timer_update_counter(unsigned long cycles,
+				    struct clock_event_device *ce)
+{
+	writel_relaxed(cycles, rk_base(ce) + TIMER_LOAD_COUNT0);
+	writel_relaxed(0, rk_base(ce) + TIMER_LOAD_COUNT1);
+	dsb();
+}
+
+static void rk_timer_interrupt_clear(struct clock_event_device *ce)
+{
+	writel_relaxed(1, rk_base(ce) + TIMER_INT_STATUS);
+	dsb();
+}
+
+static inline int rk_timer_set_next_event(unsigned long cycles,
+					  struct clock_event_device *ce)
+{
+	rk_timer_disable(ce);
+	rk_timer_update_counter(cycles, ce);
+	rk_timer_enable(ce, TIMER_MODE_USER_DEFINED_COUNT);
+	return 0;
+}
+
+static inline void rk_timer_set_mode(enum clock_event_mode mode,
+				     struct clock_event_device *ce)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		rk_timer_disable(ce);
+		rk_timer_update_counter(rk_timer(ce)->freq / HZ - 1, ce);
+		rk_timer_enable(ce, TIMER_MODE_FREE_RUNNING);
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		rk_timer_disable(ce);
+		break;
+	}
+}
+
+static irqreturn_t rk_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *ce = dev_id;
+
+	rk_timer_interrupt_clear(ce);
+
+	if (ce->mode == CLOCK_EVT_MODE_ONESHOT) {
+		rk_timer_disable(ce);
+	}
+
+	ce->event_handler(ce);
+
+	return IRQ_HANDLED;
+}
+
+static void __init rk_timer_init(struct device_node *np)
+{
+	struct clock_event_device *ce = &bc_timer.ce;
+	struct clk *timer_clk;
+	struct clk *pclk;
+	int ret, irq;
+
+	bc_timer.base = of_iomap(np, 0);
+	if (!bc_timer.base) {
+		pr_err("Failed to get base address for '%s'\n", TIMER_NAME);
+		return;
+	}
+
+        pclk = of_clk_get_by_name(np, "pclk");
+        if (IS_ERR(pclk)) {
+		pr_err("Failed to get pclk for '%s'\n", TIMER_NAME);
+		return;
+	}
+
+	if (clk_prepare_enable(pclk)) {
+		pr_err("Failed to enable pclk for '%s'\n", TIMER_NAME);
+		return;
+	}
+
+        timer_clk = of_clk_get_by_name(np, "timer");
+        if (IS_ERR(timer_clk)) {
+		pr_err("Failed to get timer clock for '%s'\n", TIMER_NAME);
+		return;
+	}
+
+	if (clk_prepare_enable(timer_clk)) {
+		pr_err("Failed to enable timer clock\n");
+		return;
+	}
+
+	bc_timer.freq = clk_get_rate(timer_clk);
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq == NO_IRQ) {
+		pr_err("Failed to map interrupts for '%s'\n", TIMER_NAME);
+		return;
+	}
+
+	ce->name = TIMER_NAME;
+	ce->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	ce->set_next_event = rk_timer_set_next_event;
+	ce->set_mode = rk_timer_set_mode;
+	ce->irq = irq;
+	ce->cpumask = cpumask_of(0);
+	ce->rating = 250;
+
+	rk_timer_interrupt_clear(ce);
+	rk_timer_disable(ce);
+
+	ret = request_irq(irq, rk_timer_interrupt, IRQF_TIMER, TIMER_NAME, ce);
+	if (ret) {
+		pr_err("Failed to initialize '%s': %d\n", TIMER_NAME, ret);
+		return;
+	}
+
+	clockevents_config_and_register(ce, bc_timer.freq, 1, UINT_MAX);
+}
+CLOCKSOURCE_OF_DECLARE(rk_timer, "rockchip,rk3288-timer", rk_timer_init);
-- 
1.9.1

