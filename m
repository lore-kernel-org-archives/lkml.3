Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936791Ab3DICax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:30:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52405 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934744Ab3DICa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:30:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,434,1363158000"; 
   d="scan'208";a="36904320"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: [PATCH 4/4] clocksource: arch_timer: Add support for memory mapped timers
Date: Mon,  8 Apr 2013 19:30:23 -0700
Message-Id: <1365474623-29181-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org>
References: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org>
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
timer in low power modes. The DT binding allows for per-CPU
memory mapped timers in case we want to support that in the
future, but the code isn't added here.

We also punt on hypervisor support, although it should be
possible to support it by searching for the hyp frame instead of
the kernel frame and updating KVM timers to support it.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/arm_arch_timer.c | 411 ++++++++++++++++++++++++++++++-----
 include/clocksource/arm_arch_timer.h |   4 +-
 2 files changed, 357 insertions(+), 58 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 38e0efc..6158422 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -16,13 +16,43 @@
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
+#include <linux/of_address.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #include <asm/arch_timer.h>
 #include <asm/virt.h>
 
 #include <clocksource/arm_arch_timer.h>
 
+#define FRAME_NUM_MASK		0x7
+#define FRAME_TYPE_MASK		(0x3 << 8)
+#define FRAME_TYPE_KERNEL_USER	(0 << 8)
+
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
+static unsigned arch_timers_present;
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
@@ -38,6 +68,7 @@ static int arch_timer_ppi[MAX_TIMER_PPI];
 static struct clock_event_device __percpu *arch_timer_evt;
 
 static bool arch_timer_use_virtual = true;
+static bool arch_timer_mem_use_virtual = true;
 
 /*
  * Architected system timer support.
@@ -46,13 +77,69 @@ static bool arch_timer_use_virtual = true;
 static inline void arch_timer_reg_write(int access, int reg, u32 val,
 					struct clock_event_device *clk)
 {
-	__arch_timer_reg_write(access, reg, val);
+	if (access == ARCH_TIMER_MEM_PHYS_ACCESS) {
+		struct arch_timer *timer = to_arch_timer(clk);
+		switch (reg) {
+		case ARCH_TIMER_REG_CTRL:
+			writel_relaxed(val, timer->base + CNTP_CTL);
+			break;
+		case ARCH_TIMER_REG_TVAL:
+			writel_relaxed(val, timer->base + CNTP_TVAL);
+			break;
+		default:
+			BUILD_BUG();
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
+		default:
+			BUILD_BUG();
+		}
+	} else {
+		__arch_timer_reg_write(access, reg, val);
+	}
 }
 
 static inline u32 arch_timer_reg_read(int access, int reg,
 				      struct clock_event_device *clk)
 {
-	return __arch_timer_reg_read(access, reg);
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
+		default:
+			BUILD_BUG();
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
+		default:
+			BUILD_BUG();
+		}
+	} else {
+		val = __arch_timer_reg_read(access, reg);
+	}
+
+	return val;
 }
 
 static inline irqreturn_t timer_handler(const int access,
@@ -84,6 +171,20 @@ static irqreturn_t arch_timer_handler_phys(int irq, void *dev_id)
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
 static inline void timer_set_mode(const int access, int mode,
 				  struct clock_event_device *clk)
 {
@@ -112,6 +213,18 @@ static void arch_timer_set_mode_phys(enum clock_event_mode mode,
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
 static inline void set_next_event(const int access, unsigned long evt,
 				  struct clock_event_device *clk)
 {
@@ -137,27 +250,62 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
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
@@ -172,27 +320,41 @@ static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
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
+	/* Who has more than one independent system counters? */
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
@@ -200,19 +362,29 @@ u32 arch_timer_get_rate(void)
 	return arch_timer_rate;
 }
 
-u64 arch_timer_read_counter(void)
+static u64 arch_counter_get_mem_cntvct(void)
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
 
+u64 (*arch_timer_read_counter)(void);
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
@@ -235,6 +407,23 @@ struct timecounter *arch_timer_get_timecounter(void)
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
+		arch_timer_read_counter = arch_counter_get_mem_cntvct;
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
@@ -277,22 +466,12 @@ static int __init arch_timer_register(void)
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
@@ -343,31 +522,50 @@ out:
 	return err;
 }
 
+static int __init arch_timer_mem_register(void __iomem *base, unsigned irq)
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
+	if (ret)
+		kfree(t);
+	return ret;
+}
+
 static const struct of_device_id arch_timer_of_match[] __initconst = {
 	{ .compatible	= "arm,armv7-timer",	},
 	{ .compatible	= "arm,armv8-timer",	},
 	{},
 };
 
-int __init arch_timer_init(void)
+static int __init arch_timer_parse(void)
 {
 	struct device_node *np;
-	u32 freq;
 	int i;
 
 	np = of_find_matching_node(NULL, arch_timer_of_match);
-	if (!np) {
-		pr_err("arch_timer: can't find DT node\n");
-		return -ENODEV;
-	}
-
-	/* Try to determine the frequency from the device tree or CNTFRQ */
-	if (!of_property_read_u32(np, "clock-frequency", &freq))
-		arch_timer_rate = freq;
+	if (!np)
+		return 0;
 
+	arch_timers_present |= ARCH_CP15_TIMER;
 	for (i = PHYS_SECURE_PPI; i < MAX_TIMER_PPI; i++)
 		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
-
+	arch_timer_detect_rate(NULL, np);
 	of_node_put(np);
 
 	/*
@@ -390,3 +588,102 @@ int __init arch_timer_init(void)
 
 	return arch_timer_register();
 }
+
+static const struct of_device_id arch_timer_mem_of_match[] __initconst = {
+	{ .compatible	= "arm,armv7-timer-mem", },
+	{},
+};
+
+static int __init arch_timer_mem_parse(void)
+{
+	struct device_node *np, *frame, *best_frame = NULL;
+	void __iomem *cntctlbase, *base;
+	unsigned irq;
+	u32 cnttidr;
+
+	np = of_find_matching_node(NULL, arch_timer_mem_of_match);
+	if (!np)
+		return 0;
+
+	arch_timers_present |= ARCH_MEM_TIMER;
+	cntctlbase = of_iomap(np, 0);
+	if (!cntctlbase) {
+		pr_err("arch_timer: Can't find CNTCTLBase\n");
+		of_node_put(np);
+		return -ENOMEM;
+	}
+
+	cnttidr = readl_relaxed(cntctlbase + CNTTIDR);
+	/*
+	 * Try to find a virtual capable kernel/user frame. Otherwise fall back
+	 * to a physical kernel/user frame.
+	 */
+	for_each_child_of_node(np, frame) {
+		u32 id;
+		int n;
+
+		if (of_property_read_u32(frame, "frame-id", &id)) {
+			pr_warn("arch_timer: Missing frame-id\n");
+			of_node_put(frame);
+			of_node_put(np);
+			return -EINVAL;
+		}
+
+		n = id & FRAME_NUM_MASK;
+		if ((id & FRAME_TYPE_MASK) == FRAME_TYPE_KERNEL_USER) {
+			if (cnttidr & CNTTIDR_VIRT(n)) {
+				of_node_put(best_frame);
+				best_frame = frame;
+				break;
+			}
+			of_node_put(best_frame);
+			best_frame = of_node_get(frame);
+		}
+	}
+	of_node_put(np);
+
+	base = arch_counter_base = of_iomap(best_frame, 0);
+	if (!base) {
+		pr_warn("arch_timer: Can't map frame's registers\n");
+		of_node_put(best_frame);
+		return -ENOMEM;
+	}
+
+	irq = irq_of_parse_and_map(best_frame, 1);
+	if (!irq) {
+		arch_timer_mem_use_virtual = false;
+		irq = irq_of_parse_and_map(best_frame, 0);
+	}
+	if (!irq) {
+		pr_warn("arch_timer: Missing timer irq\n");
+		of_node_put(best_frame);
+		return -EINVAL;
+	}
+
+	arch_timer_detect_rate(base, best_frame);
+	of_node_put(best_frame);
+
+	return arch_timer_mem_register(base, irq);
+}
+
+int __init arch_timer_init(void)
+{
+	int err;
+
+	err = arch_timer_parse();
+	if (err)
+		return err;
+
+	err = arch_timer_mem_parse();
+	if (err)
+		return err;
+
+	if (!(arch_timers_present & (ARCH_CP15_TIMER | ARCH_MEM_TIMER))) {
+		pr_err("arch_timer: can't find DT node\n");
+		return -ENODEV;
+	}
+
+	arch_timer_banner(arch_timers_present);
+	arch_counter_register(arch_timers_present);
+	return 0;
+}
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 3883812..c3ff7fe 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -28,12 +28,14 @@
 
 #define ARCH_TIMER_PHYS_ACCESS		0
 #define ARCH_TIMER_VIRT_ACCESS		1
+#define ARCH_TIMER_MEM_PHYS_ACCESS	2
+#define ARCH_TIMER_MEM_VIRT_ACCESS	3
 
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern int arch_timer_init(void);
 extern u32 arch_timer_get_rate(void);
-extern u64 arch_timer_read_counter(void);
+extern u64 (*arch_timer_read_counter)(void);
 extern struct timecounter *arch_timer_get_timecounter(void);
 
 #else
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

