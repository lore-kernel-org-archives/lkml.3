Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926Ab3GRX7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:59:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32935 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab3GRX7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:59:37 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Rob Herring <robherring2@gmail.com>
Subject: [PATCH v4 5/5] clocksource: arch_timer: Add support for memory mapped timers
Date: Thu, 18 Jul 2013 16:59:32 -0700
Message-Id: <1374191972-18015-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374191972-18015-1-git-send-email-sboyd@codeaurora.org>
References: <1374191972-18015-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the memory mapped timers by filling in the
read/write functions and adding some parsing code. Note that we
only register one clocksource, preferring the cp15 based
clocksource over the mmio one.

To keep things simple we register one global clockevent. This
covers the case of UP and SMP systems with only mmio hardware and
systems where the memory mapped timers are used as the broadcast
timer in low power modes.

The DT binding allows for per-CPU memory mapped timers in case we
want to support that in the future, but the code isn't added
here. We also don't do much for hypervisor support, although it
should be possible to support it by searching for at least two
frames where one frame has the virtual capability and then
updating KVM timers to support it.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Rob Herring <robherring2@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/arm_arch_timer.c | 402 ++++++++++++++++++++++++++++++-----
 include/clocksource/arm_arch_timer.h |   4 +-
 2 files changed, 350 insertions(+), 56 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index a9ca284..b3df46d 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -16,13 +16,39 @@
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
+#include <linux/of_address.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #include <asm/arch_timer.h>
 #include <asm/virt.h>
 
 #include <clocksource/arm_arch_timer.h>
 
+#define CNTTIDR		0x08
+#define CNTTIDR_VIRT(n)	(BIT(1) << ((n) * 4))
+
+#define CNTVCT_LO	0x08
+#define CNTVCT_HI	0x0c
+#define CNTFRQ		0x10
+#define CNTP_TVAL	0x28
+#define CNTP_CTL	0x2c
+#define CNTV_TVAL	0x38
+#define CNTV_CTL	0x3c
+
+#define ARCH_CP15_TIMER	BIT(0)
+#define ARCH_MEM_TIMER	BIT(1)
+static unsigned arch_timers_present __initdata;
+
+static void __iomem *arch_counter_base;
+
+struct arch_timer {
+	void __iomem *base;
+	struct clock_event_device evt;
+};
+
+#define to_arch_timer(e) container_of(e, struct arch_timer, evt)
+
 static u32 arch_timer_rate;
 
 enum ppi_nr {
@@ -38,6 +64,7 @@ static int arch_timer_ppi[MAX_TIMER_PPI];
 static struct clock_event_device __percpu *arch_timer_evt;
 
 static bool arch_timer_use_virtual = true;
+static bool arch_timer_mem_use_virtual;
 
 /*
  * Architected system timer support.
@@ -47,14 +74,62 @@ static __always_inline
 void arch_timer_reg_write(int access, enum arch_timer_reg reg, u32 val,
 		struct clock_event_device *clk)
 {
-	arch_timer_reg_write_cp15(access, reg, val);
+	if (access == ARCH_TIMER_MEM_PHYS_ACCESS) {
+		struct arch_timer *timer = to_arch_timer(clk);
+		switch (reg) {
+		case ARCH_TIMER_REG_CTRL:
+			writel_relaxed(val, timer->base + CNTP_CTL);
+			break;
+		case ARCH_TIMER_REG_TVAL:
+			writel_relaxed(val, timer->base + CNTP_TVAL);
+			break;
+		}
+	} else if (access == ARCH_TIMER_MEM_VIRT_ACCESS) {
+		struct arch_timer *timer = to_arch_timer(clk);
+		switch (reg) {
+		case ARCH_TIMER_REG_CTRL:
+			writel_relaxed(val, timer->base + CNTV_CTL);
+			break;
+		case ARCH_TIMER_REG_TVAL:
+			writel_relaxed(val, timer->base + CNTV_TVAL);
+			break;
+		}
+	} else {
+		arch_timer_reg_write_cp15(access, reg, val);
+	}
 }
 
 static __always_inline
 u32 arch_timer_reg_read(int access, enum arch_timer_reg reg,
 		struct clock_event_device *clk)
 {
-	return arch_timer_reg_read_cp15(access, reg);
+	u32 val;
+
+	if (access == ARCH_TIMER_MEM_PHYS_ACCESS) {
+		struct arch_timer *timer = to_arch_timer(clk);
+		switch (reg) {
+		case ARCH_TIMER_REG_CTRL:
+			val = readl_relaxed(timer->base + CNTP_CTL);
+			break;
+		case ARCH_TIMER_REG_TVAL:
+			val = readl_relaxed(timer->base + CNTP_TVAL);
+			break;
+		}
+	} else if (access == ARCH_TIMER_MEM_VIRT_ACCESS) {
+		struct arch_timer *timer = to_arch_timer(clk);
+		switch (reg) {
+		case ARCH_TIMER_REG_CTRL:
+			val = readl_relaxed(timer->base + CNTV_CTL);
+			break;
+		case ARCH_TIMER_REG_TVAL:
+			val = readl_relaxed(timer->base + CNTV_TVAL);
+			break;
+		}
+	} else {
+		val = arch_timer_reg_read_cp15(access, reg);
+	}
+
+	return val;
 }
 
 static __always_inline irqreturn_t timer_handler(const int access,
@@ -86,6 +161,20 @@ static irqreturn_t arch_timer_handler_phys(int irq, void *dev_id)
 	return timer_handler(ARCH_TIMER_PHYS_ACCESS, evt);
 }
 
+static irqreturn_t arch_timer_handler_phys_mem(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	return timer_handler(ARCH_TIMER_MEM_PHYS_ACCESS, evt);
+}
+
+static irqreturn_t arch_timer_handler_virt_mem(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	return timer_handler(ARCH_TIMER_MEM_VIRT_ACCESS, evt);
+}
+
 static __always_inline void timer_set_mode(const int access, int mode,
 				  struct clock_event_device *clk)
 {
@@ -114,6 +203,18 @@ static void arch_timer_set_mode_phys(enum clock_event_mode mode,
 	timer_set_mode(ARCH_TIMER_PHYS_ACCESS, mode, clk);
 }
 
+static void arch_timer_set_mode_virt_mem(enum clock_event_mode mode,
+					 struct clock_event_device *clk)
+{
+	timer_set_mode(ARCH_TIMER_MEM_VIRT_ACCESS, mode, clk);
+}
+
+static void arch_timer_set_mode_phys_mem(enum clock_event_mode mode,
+					 struct clock_event_device *clk)
+{
+	timer_set_mode(ARCH_TIMER_MEM_PHYS_ACCESS, mode, clk);
+}
+
 static __always_inline void set_next_event(const int access, unsigned long evt,
 				  struct clock_event_device *clk)
 {
@@ -139,27 +240,62 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
 	return 0;
 }
 
-static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
+static int arch_timer_set_next_event_virt_mem(unsigned long evt,
+					      struct clock_event_device *clk)
 {
-	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
-	clk->name = "arch_sys_timer";
-	clk->rating = 450;
-	if (arch_timer_use_virtual) {
-		clk->irq = arch_timer_ppi[VIRT_PPI];
-		clk->set_mode = arch_timer_set_mode_virt;
-		clk->set_next_event = arch_timer_set_next_event_virt;
+	set_next_event(ARCH_TIMER_MEM_VIRT_ACCESS, evt, clk);
+	return 0;
+}
+
+static int arch_timer_set_next_event_phys_mem(unsigned long evt,
+					      struct clock_event_device *clk)
+{
+	set_next_event(ARCH_TIMER_MEM_PHYS_ACCESS, evt, clk);
+	return 0;
+}
+
+static void __cpuinit __arch_timer_setup(unsigned type,
+				       struct clock_event_device *clk)
+{
+	clk->features = CLOCK_EVT_FEAT_ONESHOT;
+
+	if (type == ARCH_CP15_TIMER) {
+		clk->features |= CLOCK_EVT_FEAT_C3STOP;
+		clk->name = "arch_sys_timer";
+		clk->rating = 450;
+		clk->cpumask = cpumask_of(smp_processor_id());
+		if (arch_timer_use_virtual) {
+			clk->irq = arch_timer_ppi[VIRT_PPI];
+			clk->set_mode = arch_timer_set_mode_virt;
+			clk->set_next_event = arch_timer_set_next_event_virt;
+		} else {
+			clk->irq = arch_timer_ppi[PHYS_SECURE_PPI];
+			clk->set_mode = arch_timer_set_mode_phys;
+			clk->set_next_event = arch_timer_set_next_event_phys;
+		}
 	} else {
-		clk->irq = arch_timer_ppi[PHYS_SECURE_PPI];
-		clk->set_mode = arch_timer_set_mode_phys;
-		clk->set_next_event = arch_timer_set_next_event_phys;
+		clk->name = "arch_mem_timer";
+		clk->rating = 400;
+		clk->cpumask = cpu_all_mask;
+		if (arch_timer_mem_use_virtual) {
+			clk->set_mode = arch_timer_set_mode_virt_mem;
+			clk->set_next_event =
+				arch_timer_set_next_event_virt_mem;
+		} else {
+			clk->set_mode = arch_timer_set_mode_phys_mem;
+			clk->set_next_event =
+				arch_timer_set_next_event_phys_mem;
+		}
 	}
 
-	clk->cpumask = cpumask_of(smp_processor_id());
-
 	clk->set_mode(CLOCK_EVT_MODE_SHUTDOWN, clk);
 
-	clockevents_config_and_register(clk, arch_timer_rate,
-					0xf, 0x7fffffff);
+	clockevents_config_and_register(clk, arch_timer_rate, 0xf, 0x7fffffff);
+}
+
+static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
+{
+	__arch_timer_setup(ARCH_CP15_TIMER, clk);
 
 	if (arch_timer_use_virtual)
 		enable_percpu_irq(arch_timer_ppi[VIRT_PPI], 0);
@@ -174,27 +310,41 @@ static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
 	return 0;
 }
 
-static int arch_timer_available(void)
+static void
+arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
 {
-	u32 freq;
-
-	if (arch_timer_rate == 0) {
-		freq = arch_timer_get_cntfrq();
-
-		/* Check the timer frequency. */
-		if (freq == 0) {
-			pr_warn("Architected timer frequency not available\n");
-			return -EINVAL;
-		}
+	/* Who has more than one independent system counter? */
+	if (arch_timer_rate)
+		return;
 
-		arch_timer_rate = freq;
+	/* Try to determine the frequency from the device tree or CNTFRQ */
+	if (of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
+		if (cntbase)
+			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
+		else
+			arch_timer_rate = arch_timer_get_cntfrq();
 	}
 
-	pr_info_once("Architected local timer running at %lu.%02luMHz (%s).\n",
+	/* Check the timer frequency. */
+	if (arch_timer_rate == 0)
+		pr_warn("Architected timer frequency not available\n");
+}
+
+static void arch_timer_banner(unsigned type)
+{
+	pr_info("Architected %s%s%s timer(s) running at %lu.%02luMHz (%s%s%s).\n",
+		     type & ARCH_CP15_TIMER ? "cp15" : "",
+		     type == (ARCH_CP15_TIMER | ARCH_MEM_TIMER) ?  " and " : "",
+		     type & ARCH_MEM_TIMER ? "mmio" : "",
 		     (unsigned long)arch_timer_rate / 1000000,
 		     (unsigned long)(arch_timer_rate / 10000) % 100,
-		     arch_timer_use_virtual ? "virt" : "phys");
-	return 0;
+		     type & ARCH_CP15_TIMER ?
+			arch_timer_use_virtual ? "virt" : "phys" :
+			"",
+		     type == (ARCH_CP15_TIMER | ARCH_MEM_TIMER) ?  "/" : "",
+		     type & ARCH_MEM_TIMER ?
+			arch_timer_mem_use_virtual ? "virt" : "phys" :
+			"");
 }
 
 u32 arch_timer_get_rate(void)
@@ -202,19 +352,35 @@ u32 arch_timer_get_rate(void)
 	return arch_timer_rate;
 }
 
-u64 arch_timer_read_counter(void)
+static u64 arch_counter_get_cntvct_mem(void)
 {
-	return arch_counter_get_cntvct();
+	u32 vct_lo, vct_hi, tmp_hi;
+
+	do {
+		vct_hi = readl_relaxed(arch_counter_base + CNTVCT_HI);
+		vct_lo = readl_relaxed(arch_counter_base + CNTVCT_LO);
+		tmp_hi = readl_relaxed(arch_counter_base + CNTVCT_HI);
+	} while (vct_hi != tmp_hi);
+
+	return ((u64) vct_hi << 32) | vct_lo;
 }
 
+/*
+ * Default to cp15 based access because arm64 uses this function for
+ * sched_clock() before DT is probed and the cp15 method is guaranteed
+ * to exist on arm64. arm doesn't use this before DT is probed so even
+ * if we don't have the cp15 accessors we won't have a problem.
+ */
+u64 (*arch_timer_read_counter)(void) = arch_counter_get_cntvct;
+
 static cycle_t arch_counter_read(struct clocksource *cs)
 {
-	return arch_counter_get_cntvct();
+	return arch_timer_read_counter();
 }
 
 static cycle_t arch_counter_read_cc(const struct cyclecounter *cc)
 {
-	return arch_counter_get_cntvct();
+	return arch_timer_read_counter();
 }
 
 static struct clocksource clocksource_counter = {
@@ -237,6 +403,23 @@ struct timecounter *arch_timer_get_timecounter(void)
 	return &timecounter;
 }
 
+static void __init arch_counter_register(unsigned type)
+{
+	u64 start_count;
+
+	/* Register the CP15 based counter if we have one */
+	if (type & ARCH_CP15_TIMER)
+		arch_timer_read_counter = arch_counter_get_cntvct;
+	else
+		arch_timer_read_counter = arch_counter_get_cntvct_mem;
+
+	start_count = arch_timer_read_counter();
+	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
+	cyclecounter.mult = clocksource_counter.mult;
+	cyclecounter.shift = clocksource_counter.shift;
+	timecounter_init(&timecounter, &cyclecounter, start_count);
+}
+
 static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
 {
 	pr_debug("arch_timer_teardown disable IRQ%d cpu #%d\n",
@@ -281,22 +464,12 @@ static int __init arch_timer_register(void)
 	int err;
 	int ppi;
 
-	err = arch_timer_available();
-	if (err)
-		goto out;
-
 	arch_timer_evt = alloc_percpu(struct clock_event_device);
 	if (!arch_timer_evt) {
 		err = -ENOMEM;
 		goto out;
 	}
 
-	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
-	cyclecounter.mult = clocksource_counter.mult;
-	cyclecounter.shift = clocksource_counter.shift;
-	timecounter_init(&timecounter, &cyclecounter,
-			 arch_counter_get_cntvct());
-
 	if (arch_timer_use_virtual) {
 		ppi = arch_timer_ppi[VIRT_PPI];
 		err = request_percpu_irq(ppi, arch_timer_handler_virt,
@@ -347,24 +520,77 @@ out:
 	return err;
 }
 
+static int __init arch_timer_mem_register(void __iomem *base, unsigned int irq)
+{
+	int ret;
+	irq_handler_t func;
+	struct arch_timer *t;
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
+	if (!t)
+		return -ENOMEM;
+
+	t->base = base;
+	t->evt.irq = irq;
+	__arch_timer_setup(ARCH_MEM_TIMER, &t->evt);
+
+	if (arch_timer_mem_use_virtual)
+		func = arch_timer_handler_virt_mem;
+	else
+		func = arch_timer_handler_phys_mem;
+
+	ret = request_irq(irq, func, IRQF_TIMER, "arch_mem_timer", &t->evt);
+	if (ret) {
+		pr_err("arch_timer: Failed to request mem timer irq\n");
+		kfree(t);
+	}
+
+	return ret;
+}
+
+static const struct of_device_id arch_timer_of_match[] __initconst = {
+	{ .compatible   = "arm,armv7-timer",    },
+	{ .compatible   = "arm,armv8-timer",    },
+	{},
+};
+
+static const struct of_device_id arch_timer_mem_of_match[] __initconst = {
+	{ .compatible   = "arm,armv7-timer-mem", },
+	{},
+};
+
+static void __init arch_timer_common_init(void)
+{
+	unsigned mask = ARCH_CP15_TIMER | ARCH_MEM_TIMER;
+
+	/* Wait until both nodes are probed if we have two timers */
+	if ((arch_timers_present & mask) != mask) {
+		if (of_find_matching_node(NULL, arch_timer_mem_of_match) &&
+				!(arch_timers_present & ARCH_MEM_TIMER))
+			return;
+		if (of_find_matching_node(NULL, arch_timer_of_match) &&
+				!(arch_timers_present & ARCH_CP15_TIMER))
+			return;
+	}
+
+	arch_timer_banner(arch_timers_present);
+	arch_counter_register(arch_timers_present);
+	arch_timer_arch_init();
+}
+
 static void __init arch_timer_init(struct device_node *np)
 {
-	u32 freq;
 	int i;
 
-	if (arch_timer_get_rate()) {
+	if (arch_timers_present & ARCH_CP15_TIMER) {
 		pr_warn("arch_timer: multiple nodes in dt, skipping\n");
 		return;
 	}
 
-	/* Try to determine the frequency from the device tree or CNTFRQ */
-	if (!of_property_read_u32(np, "clock-frequency", &freq))
-		arch_timer_rate = freq;
-
+	arch_timers_present |= ARCH_CP15_TIMER;
 	for (i = PHYS_SECURE_PPI; i < MAX_TIMER_PPI; i++)
 		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
-
-	of_node_put(np);
+	arch_timer_detect_rate(NULL, np);
 
 	/*
 	 * If HYP mode is available, we know that the physical timer
@@ -385,7 +611,73 @@ static void __init arch_timer_init(struct device_node *np)
 	}
 
 	arch_timer_register();
-	arch_timer_arch_init();
+	arch_timer_common_init();
 }
 CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_init);
 CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_init);
+
+static void __init arch_timer_mem_init(struct device_node *np)
+{
+	struct device_node *frame, *best_frame = NULL;
+	void __iomem *cntctlbase, *base;
+	unsigned int irq;
+	u32 cnttidr;
+
+	arch_timers_present |= ARCH_MEM_TIMER;
+	cntctlbase = of_iomap(np, 0);
+	if (!cntctlbase) {
+		pr_err("arch_timer: Can't find CNTCTLBase\n");
+		return;
+	}
+
+	cnttidr = readl_relaxed(cntctlbase + CNTTIDR);
+	iounmap(cntctlbase);
+
+	/*
+	 * Try to find a virtual capable frame. Otherwise fall back to a
+	 * physical capable frame.
+	 */
+	for_each_available_child_of_node(np, frame) {
+		int n;
+
+		if (of_property_read_u32(frame, "frame-number", &n)) {
+			pr_err("arch_timer: Missing frame-number\n");
+			of_node_put(best_frame);
+			of_node_put(frame);
+			return;
+		}
+
+		if (cnttidr & CNTTIDR_VIRT(n)) {
+			of_node_put(best_frame);
+			best_frame = frame;
+			arch_timer_mem_use_virtual = true;
+			break;
+		}
+		of_node_put(best_frame);
+		best_frame = of_node_get(frame);
+	}
+
+	base = arch_counter_base = of_iomap(best_frame, 0);
+	if (!base) {
+		pr_err("arch_timer: Can't map frame's registers\n");
+		of_node_put(best_frame);
+		return;
+	}
+
+	if (arch_timer_mem_use_virtual)
+		irq = irq_of_parse_and_map(best_frame, 1);
+	else
+		irq = irq_of_parse_and_map(best_frame, 0);
+	of_node_put(best_frame);
+	if (!irq) {
+		pr_err("arch_timer: Frame missing %s irq",
+				arch_timer_mem_use_virtual ? "virt" : "phys");
+		return;
+	}
+
+	arch_timer_detect_rate(base, np);
+	arch_timer_mem_register(base, irq);
+	arch_timer_common_init();
+}
+CLOCKSOURCE_OF_DECLARE(armv7_arch_timer_mem, "arm,armv7-timer-mem",
+		       arch_timer_mem_init);
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index f3da817..93b7f96 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -30,11 +30,13 @@ enum arch_timer_reg {
 
 #define ARCH_TIMER_PHYS_ACCESS		0
 #define ARCH_TIMER_VIRT_ACCESS		1
+#define ARCH_TIMER_MEM_PHYS_ACCESS	2
+#define ARCH_TIMER_MEM_VIRT_ACCESS	3
 
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern u32 arch_timer_get_rate(void);
-extern u64 arch_timer_read_counter(void);
+extern u64 (*arch_timer_read_counter)(void);
 extern struct timecounter *arch_timer_get_timecounter(void);
 
 #else
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

