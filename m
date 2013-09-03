Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956Ab3ICODc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:03:32 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63544 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3ICODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:03:30 -0400
Date: Tue, 3 Sep 2013 16:03:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v3.12
Message-ID: <20130903140326.GA27332@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

   HEAD: cfb6d656d569510ac9239583ce09e4c92ad54719 Merge branch 'timers/clockevents-next' of git://git.linaro.org/people/dlezcano/clockevents into timers/core

Various clocksource driver updates: extend the core with memory mapped 
hardware (mmio) support and add new (ARM) Moxart SoC and sun4i hardware 
support.

 Thanks,

	Ingo

------------------>
John Stultz (1):
      MAINTAINERS: Add Daniel as maintainer for CLOCKSOURCE and CLOCKEVENT Drivers

Jonas Jensen (4):
      ARM: clocksource: Add support for MOXA ART SoCs
      ARM: clocksource: moxart: documentation: Fix device tree bindings document
      ARM: clocksource: moxart: Add bitops.h include
      ARM: clocksource: moxart: documentation: Update device tree bindings document

Maxime Ripard (10):
      clocksource: sun4i: Use the BIT macros where possible
      clocksource: sun4i: Wrap macros arguments in parenthesis
      clocksource: sun4i: rename AUTORELOAD define to RELOAD
      clocksource: sun4i: Add clocksource and sched clock drivers
      clocksource: sun4i: Don't forget to enable the clock we use
      clocksource: sun4i: Fix the next event code
      clocksource: sun4i: Factor out some timer code
      clocksource: sun4i: Remove TIMER_SCAL variable
      clocksource: sun4i: Cleanup parent clock setup
      clocksource: sun4i: Fix bug when switching from periodic to oneshot modes

Soren Brinkmann (2):
      clocksource: cadence_ttc: Remove unused header
      clocksource: cadence_ttc: Reuse clocksource as sched_clock

Stephen Boyd (6):
      clocksource: orion: Use linux/sched_clock.h
      clocksource: arch_timer: Make register accessors less error-prone
      clocksource: arch_timer: Pass clock event to set_mode callback
      Documentation: Add memory mapped ARM architected timer binding
      clocksource: arch_timer: Push the read/write wrappers deeper
      clocksource: arch_timer: Add support for memory mapped timers


 .../devicetree/bindings/arm/arch_timer.txt         |  59 ++-
 .../bindings/timer/moxa,moxart-timer.txt           |  17 +
 MAINTAINERS                                        |  10 +-
 arch/arm/include/asm/arch_timer.h                  |  14 +-
 arch/arm64/include/asm/arch_timer.h                |  23 +-
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/arm_arch_timer.c               | 447 +++++++++++++++++----
 drivers/clocksource/cadence_ttc_timer.c            |  13 +-
 drivers/clocksource/moxart_timer.c                 | 165 ++++++++
 drivers/clocksource/sun4i_timer.c                  | 110 +++--
 drivers/clocksource/time-orion.c                   |   2 +-
 include/clocksource/arm_arch_timer.h               |  10 +-
 12 files changed, 738 insertions(+), 133 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
 create mode 100644 drivers/clocksource/moxart_timer.c

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 20746e5..06fc760 100644
--- a/Documentation/devicetree/bindings/arm/arch_timer.txt
+++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
@@ -1,10 +1,14 @@
 * ARM architected timer
 
-ARM cores may have a per-core architected timer, which provides per-cpu timers.
+ARM cores may have a per-core architected timer, which provides per-cpu timers,
+or a memory mapped architected timer, which provides up to 8 frames with a
+physical and optional virtual timer per frame.
 
-The timer is attached to a GIC to deliver its per-processor interrupts.
+The per-core architected timer is attached to a GIC to deliver its
+per-processor interrupts via PPIs. The memory mapped timer is attached to a GIC
+to deliver its interrupts via SPIs.
 
-** Timer node properties:
+** CP15 Timer node properties:
 
 - compatible : Should at least contain one of
 	"arm,armv7-timer"
@@ -26,3 +30,52 @@ Example:
 			     <1 10 0xf08>;
 		clock-frequency = <100000000>;
 	};
+
+** Memory mapped timer node properties:
+
+- compatible : Should at least contain "arm,armv7-timer-mem".
+
+- clock-frequency : The frequency of the main counter, in Hz. Optional.
+
+- reg : The control frame base address.
+
+Note that #address-cells, #size-cells, and ranges shall be present to ensure
+the CPU can address a frame's registers.
+
+A timer node has up to 8 frame sub-nodes, each with the following properties:
+
+- frame-number: 0 to 7.
+
+- interrupts : Interrupt list for physical and virtual timers in that order.
+  The virtual timer interrupt is optional.
+
+- reg : The first and second view base addresses in that order. The second view
+  base address is optional.
+
+- status : "disabled" indicates the frame is not available for use. Optional.
+
+Example:
+
+	timer@f0000000 {
+		compatible = "arm,armv7-timer-mem";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		reg = <0xf0000000 0x1000>;
+		clock-frequency = <50000000>;
+
+		frame@f0001000 {
+			frame-number = <0>
+			interrupts = <0 13 0x8>,
+				     <0 14 0x8>;
+			reg = <0xf0001000 0x1000>,
+			      <0xf0002000 0x1000>;
+		};
+
+		frame@f0003000 {
+			frame-number = <1>
+			interrupts = <0 15 0x8>;
+			reg = <0xf0003000 0x1000>;
+			status = "disabled";
+		};
+	};
diff --git a/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt b/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
new file mode 100644
index 0000000..da2d510
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
@@ -0,0 +1,17 @@
+MOXA ART timer
+
+Required properties:
+
+- compatible : Must be "moxa,moxart-timer"
+- reg : Should contain registers location and length
+- interrupts : Should contain the timer interrupt number
+- clocks : Should contain phandle for the clock that drives the counter
+
+Example:
+
+	timer: timer@98400000 {
+		compatible = "moxa,moxart-timer";
+		reg = <0x98400000 0x42>;
+		interrupts = <19 1>;
+		clocks = <&coreclk>;
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index 229c66b..016ee06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2112,6 +2112,13 @@ M:	Russell King <linux@arm.linux.org.uk>
 S:	Maintained
 F:	include/linux/clk.h
 
+CLOCKSOURCE, CLOCKEVENT DRIVERS
+M:	Daniel Lezcano <daniel.lezcano@linaro.org>
+M:	Thomas Gleixner <tglx@linutronix.de>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
+S:	Supported
+F:	drivers/clocksource
+
 CISCO FCOE HBA DRIVER
 M:	Hiral Patel <hiralpat@cisco.com>
 M:	Suma Ramars <sramars@cisco.com>
@@ -7143,7 +7150,7 @@ S:	Maintained
 F:	include/linux/mmc/dw_mmc.h
 F:	drivers/mmc/host/dw_mmc*
 
-TIMEKEEPING, NTP
+TIMEKEEPING, CLOCKSOURCE CORE, NTP
 M:	John Stultz <john.stultz@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
@@ -7156,7 +7163,6 @@ F:	include/uapi/linux/timex.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
-F:	drivers/clocksource
 
 TLG2300 VIDEO4LINUX-2 DRIVER
 M:	Huang Shijie <shijie8@gmail.com>
diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index e406d57..5665134 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -17,7 +17,8 @@ int arch_timer_arch_init(void);
  * nicely work out which register we want, and chuck away the rest of
  * the code. At least it does so with a recent GCC (4.6.3).
  */
-static inline void arch_timer_reg_write(const int access, const int reg, u32 val)
+static __always_inline
+void arch_timer_reg_write_cp15(int access, enum arch_timer_reg reg, u32 val)
 {
 	if (access == ARCH_TIMER_PHYS_ACCESS) {
 		switch (reg) {
@@ -28,9 +29,7 @@ static inline void arch_timer_reg_write(const int access, const int reg, u32 val
 			asm volatile("mcr p15, 0, %0, c14, c2, 0" : : "r" (val));
 			break;
 		}
-	}
-
-	if (access == ARCH_TIMER_VIRT_ACCESS) {
+	} else if (access == ARCH_TIMER_VIRT_ACCESS) {
 		switch (reg) {
 		case ARCH_TIMER_REG_CTRL:
 			asm volatile("mcr p15, 0, %0, c14, c3, 1" : : "r" (val));
@@ -44,7 +43,8 @@ static inline void arch_timer_reg_write(const int access, const int reg, u32 val
 	isb();
 }
 
-static inline u32 arch_timer_reg_read(const int access, const int reg)
+static __always_inline
+u32 arch_timer_reg_read_cp15(int access, enum arch_timer_reg reg)
 {
 	u32 val = 0;
 
@@ -57,9 +57,7 @@ static inline u32 arch_timer_reg_read(const int access, const int reg)
 			asm volatile("mrc p15, 0, %0, c14, c2, 0" : "=r" (val));
 			break;
 		}
-	}
-
-	if (access == ARCH_TIMER_VIRT_ACCESS) {
+	} else if (access == ARCH_TIMER_VIRT_ACCESS) {
 		switch (reg) {
 		case ARCH_TIMER_REG_CTRL:
 			asm volatile("mrc p15, 0, %0, c14, c3, 1" : "=r" (val));
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 98abd47..c9f1d28 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -26,7 +26,13 @@
 
 #include <clocksource/arm_arch_timer.h>
 
-static inline void arch_timer_reg_write(int access, int reg, u32 val)
+/*
+ * These register accessors are marked inline so the compiler can
+ * nicely work out which register we want, and chuck away the rest of
+ * the code.
+ */
+static __always_inline
+void arch_timer_reg_write_cp15(int access, enum arch_timer_reg reg, u32 val)
 {
 	if (access == ARCH_TIMER_PHYS_ACCESS) {
 		switch (reg) {
@@ -36,8 +42,6 @@ static inline void arch_timer_reg_write(int access, int reg, u32 val)
 		case ARCH_TIMER_REG_TVAL:
 			asm volatile("msr cntp_tval_el0, %0" : : "r" (val));
 			break;
-		default:
-			BUILD_BUG();
 		}
 	} else if (access == ARCH_TIMER_VIRT_ACCESS) {
 		switch (reg) {
@@ -47,17 +51,14 @@ static inline void arch_timer_reg_write(int access, int reg, u32 val)
 		case ARCH_TIMER_REG_TVAL:
 			asm volatile("msr cntv_tval_el0, %0" : : "r" (val));
 			break;
-		default:
-			BUILD_BUG();
 		}
-	} else {
-		BUILD_BUG();
 	}
 
 	isb();
 }
 
-static inline u32 arch_timer_reg_read(int access, int reg)
+static __always_inline
+u32 arch_timer_reg_read_cp15(int access, enum arch_timer_reg reg)
 {
 	u32 val;
 
@@ -69,8 +70,6 @@ static inline u32 arch_timer_reg_read(int access, int reg)
 		case ARCH_TIMER_REG_TVAL:
 			asm volatile("mrs %0, cntp_tval_el0" : "=r" (val));
 			break;
-		default:
-			BUILD_BUG();
 		}
 	} else if (access == ARCH_TIMER_VIRT_ACCESS) {
 		switch (reg) {
@@ -80,11 +79,7 @@ static inline u32 arch_timer_reg_read(int access, int reg)
 		case ARCH_TIMER_REG_TVAL:
 			asm volatile("mrs %0, cntv_tval_el0" : "=r" (val));
 			break;
-		default:
-			BUILD_BUG();
 		}
-	} else {
-		BUILD_BUG();
 	}
 
 	return val;
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 8b00c5c..704d6d3 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ORION_TIMER)	+= time-orion.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
+obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index ffadd83..fbd9ccd 100644
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
@@ -38,19 +64,83 @@ static int arch_timer_ppi[MAX_TIMER_PPI];
 static struct clock_event_device __percpu *arch_timer_evt;
 
 static bool arch_timer_use_virtual = true;
+static bool arch_timer_mem_use_virtual;
 
 /*
  * Architected system timer support.
  */
 
-static inline irqreturn_t timer_handler(const int access,
+static __always_inline
+void arch_timer_reg_write(int access, enum arch_timer_reg reg, u32 val,
+			  struct clock_event_device *clk)
+{
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
+}
+
+static __always_inline
+u32 arch_timer_reg_read(int access, enum arch_timer_reg reg,
+			struct clock_event_device *clk)
+{
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
+}
+
+static __always_inline irqreturn_t timer_handler(const int access,
 					struct clock_event_device *evt)
 {
 	unsigned long ctrl;
-	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL);
+
+	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, evt);
 	if (ctrl & ARCH_TIMER_CTRL_IT_STAT) {
 		ctrl |= ARCH_TIMER_CTRL_IT_MASK;
-		arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
+		arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, evt);
 		evt->event_handler(evt);
 		return IRQ_HANDLED;
 	}
@@ -72,15 +162,30 @@ static irqreturn_t arch_timer_handler_phys(int irq, void *dev_id)
 	return timer_handler(ARCH_TIMER_PHYS_ACCESS, evt);
 }
 
-static inline void timer_set_mode(const int access, int mode)
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
+static __always_inline void timer_set_mode(const int access, int mode,
+				  struct clock_event_device *clk)
 {
 	unsigned long ctrl;
 	switch (mode) {
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL);
+		ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, clk);
 		ctrl &= ~ARCH_TIMER_CTRL_ENABLE;
-		arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
+		arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
 		break;
 	default:
 		break;
@@ -90,60 +195,108 @@ static inline void timer_set_mode(const int access, int mode)
 static void arch_timer_set_mode_virt(enum clock_event_mode mode,
 				     struct clock_event_device *clk)
 {
-	timer_set_mode(ARCH_TIMER_VIRT_ACCESS, mode);
+	timer_set_mode(ARCH_TIMER_VIRT_ACCESS, mode, clk);
 }
 
 static void arch_timer_set_mode_phys(enum clock_event_mode mode,
 				     struct clock_event_device *clk)
 {
-	timer_set_mode(ARCH_TIMER_PHYS_ACCESS, mode);
+	timer_set_mode(ARCH_TIMER_PHYS_ACCESS, mode, clk);
+}
+
+static void arch_timer_set_mode_virt_mem(enum clock_event_mode mode,
+					 struct clock_event_device *clk)
+{
+	timer_set_mode(ARCH_TIMER_MEM_VIRT_ACCESS, mode, clk);
 }
 
-static inline void set_next_event(const int access, unsigned long evt)
+static void arch_timer_set_mode_phys_mem(enum clock_event_mode mode,
+					 struct clock_event_device *clk)
+{
+	timer_set_mode(ARCH_TIMER_MEM_PHYS_ACCESS, mode, clk);
+}
+
+static __always_inline void set_next_event(const int access, unsigned long evt,
+					   struct clock_event_device *clk)
 {
 	unsigned long ctrl;
-	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL);
+	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, clk);
 	ctrl |= ARCH_TIMER_CTRL_ENABLE;
 	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
-	arch_timer_reg_write(access, ARCH_TIMER_REG_TVAL, evt);
-	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
+	arch_timer_reg_write(access, ARCH_TIMER_REG_TVAL, evt, clk);
+	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
 }
 
 static int arch_timer_set_next_event_virt(unsigned long evt,
-					  struct clock_event_device *unused)
+					  struct clock_event_device *clk)
 {
-	set_next_event(ARCH_TIMER_VIRT_ACCESS, evt);
+	set_next_event(ARCH_TIMER_VIRT_ACCESS, evt, clk);
 	return 0;
 }
 
 static int arch_timer_set_next_event_phys(unsigned long evt,
-					  struct clock_event_device *unused)
+					  struct clock_event_device *clk)
 {
-	set_next_event(ARCH_TIMER_PHYS_ACCESS, evt);
+	set_next_event(ARCH_TIMER_PHYS_ACCESS, evt, clk);
 	return 0;
 }
 
-static int arch_timer_setup(struct clock_event_device *clk)
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
+static void __arch_timer_setup(unsigned type,
+			       struct clock_event_device *clk)
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
+	clk->set_mode(CLOCK_EVT_MODE_SHUTDOWN, clk);
 
-	clk->set_mode(CLOCK_EVT_MODE_SHUTDOWN, NULL);
+	clockevents_config_and_register(clk, arch_timer_rate, 0xf, 0x7fffffff);
+}
 
-	clockevents_config_and_register(clk, arch_timer_rate,
-					0xf, 0x7fffffff);
+static int arch_timer_setup(struct clock_event_device *clk)
+{
+	__arch_timer_setup(ARCH_CP15_TIMER, clk);
 
 	if (arch_timer_use_virtual)
 		enable_percpu_irq(arch_timer_ppi[VIRT_PPI], 0);
@@ -158,27 +311,41 @@ static int arch_timer_setup(struct clock_event_device *clk)
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
@@ -186,19 +353,35 @@ u32 arch_timer_get_rate(void)
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
@@ -221,6 +404,23 @@ struct timecounter *arch_timer_get_timecounter(void)
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
 static void arch_timer_stop(struct clock_event_device *clk)
 {
 	pr_debug("arch_timer_teardown disable IRQ%d cpu #%d\n",
@@ -265,22 +465,12 @@ static int __init arch_timer_register(void)
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
@@ -331,24 +521,77 @@ out:
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
@@ -369,7 +612,73 @@ static void __init arch_timer_init(struct device_node *np)
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
+		       arch_timer_mem_use_virtual ? "virt" : "phys");
+		return;
+	}
+
+	arch_timer_detect_rate(base, np);
+	arch_timer_mem_register(base, irq);
+	arch_timer_common_init();
+}
+CLOCKSOURCE_OF_DECLARE(armv7_arch_timer_mem, "arm,armv7-timer-mem",
+		       arch_timer_mem_init);
diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 4cbe28c..b2bb3a4b 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -21,7 +21,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/slab.h>
-#include <linux/clk-provider.h>
+#include <linux/sched_clock.h>
 
 /*
  * This driver configures the 2 16-bit count-up timers as follows:
@@ -95,6 +95,8 @@ struct ttc_timer_clockevent {
 #define to_ttc_timer_clkevent(x) \
 		container_of(x, struct ttc_timer_clockevent, ce)
 
+static void __iomem *ttc_sched_clock_val_reg;
+
 /**
  * ttc_set_interval - Set the timer interval value
  *
@@ -156,6 +158,11 @@ static cycle_t __ttc_clocksource_read(struct clocksource *cs)
 				TTC_COUNT_VAL_OFFSET);
 }
 
+static u32 notrace ttc_sched_clock_read(void)
+{
+	return __raw_readl(ttc_sched_clock_val_reg);
+}
+
 /**
  * ttc_set_next_event - Sets the time interval for next event
  *
@@ -297,6 +304,10 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 		kfree(ttccs);
 		return;
 	}
+
+	ttc_sched_clock_val_reg = base + TTC_COUNT_VAL_OFFSET;
+	setup_sched_clock(ttc_sched_clock_read, 16,
+			clk_get_rate(ttccs->ttc.clk) / PRESCALE);
 }
 
 static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
diff --git a/drivers/clocksource/moxart_timer.c b/drivers/clocksource/moxart_timer.c
new file mode 100644
index 0000000..5eb2c35
--- /dev/null
+++ b/drivers/clocksource/moxart_timer.c
@@ -0,0 +1,165 @@
+/*
+ * MOXA ART SoCs timer handling.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqreturn.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/io.h>
+#include <linux/clocksource.h>
+#include <linux/bitops.h>
+
+#define TIMER1_BASE		0x00
+#define TIMER2_BASE		0x10
+#define TIMER3_BASE		0x20
+
+#define REG_COUNT		0x0 /* writable */
+#define REG_LOAD		0x4
+#define REG_MATCH1		0x8
+#define REG_MATCH2		0xC
+
+#define TIMER_CR		0x30
+#define TIMER_INTR_STATE	0x34
+#define TIMER_INTR_MASK		0x38
+
+/*
+ * TIMER_CR flags:
+ *
+ * TIMEREG_CR_*_CLOCK	0: PCLK, 1: EXT1CLK
+ * TIMEREG_CR_*_INT	overflow interrupt enable bit
+ */
+#define TIMEREG_CR_1_ENABLE	BIT(0)
+#define TIMEREG_CR_1_CLOCK	BIT(1)
+#define TIMEREG_CR_1_INT	BIT(2)
+#define TIMEREG_CR_2_ENABLE	BIT(3)
+#define TIMEREG_CR_2_CLOCK	BIT(4)
+#define TIMEREG_CR_2_INT	BIT(5)
+#define TIMEREG_CR_3_ENABLE	BIT(6)
+#define TIMEREG_CR_3_CLOCK	BIT(7)
+#define TIMEREG_CR_3_INT	BIT(8)
+#define TIMEREG_CR_COUNT_UP	BIT(9)
+
+#define TIMER1_ENABLE		(TIMEREG_CR_2_ENABLE | TIMEREG_CR_1_ENABLE)
+#define TIMER1_DISABLE		(TIMEREG_CR_2_ENABLE)
+
+static void __iomem *base;
+static unsigned int clock_count_per_tick;
+
+static void moxart_clkevt_mode(enum clock_event_mode mode,
+			       struct clock_event_device *clk)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_ONESHOT:
+		writel(TIMER1_DISABLE, base + TIMER_CR);
+		writel(~0, base + TIMER1_BASE + REG_LOAD);
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+		writel(clock_count_per_tick, base + TIMER1_BASE + REG_LOAD);
+		writel(TIMER1_ENABLE, base + TIMER_CR);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		writel(TIMER1_DISABLE, base + TIMER_CR);
+		break;
+	}
+}
+
+static int moxart_clkevt_next_event(unsigned long cycles,
+				    struct clock_event_device *unused)
+{
+	u32 u;
+
+	writel(TIMER1_DISABLE, base + TIMER_CR);
+
+	u = readl(base + TIMER1_BASE + REG_COUNT) - cycles;
+	writel(u, base + TIMER1_BASE + REG_MATCH1);
+
+	writel(TIMER1_ENABLE, base + TIMER_CR);
+
+	return 0;
+}
+
+static struct clock_event_device moxart_clockevent = {
+	.name		= "moxart_timer",
+	.rating		= 200,
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= moxart_clkevt_mode,
+	.set_next_event	= moxart_clkevt_next_event,
+};
+
+static irqreturn_t moxart_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction moxart_timer_irq = {
+	.name		= "moxart-timer",
+	.flags		= IRQF_TIMER,
+	.handler	= moxart_timer_interrupt,
+	.dev_id		= &moxart_clockevent,
+};
+
+static void __init moxart_timer_init(struct device_node *node)
+{
+	int ret, irq;
+	unsigned long pclk;
+	struct clk *clk;
+
+	base = of_iomap(node, 0);
+	if (!base)
+		panic("%s: of_iomap failed\n", node->full_name);
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0)
+		panic("%s: irq_of_parse_and_map failed\n", node->full_name);
+
+	ret = setup_irq(irq, &moxart_timer_irq);
+	if (ret)
+		panic("%s: setup_irq failed\n", node->full_name);
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk))
+		panic("%s: of_clk_get failed\n", node->full_name);
+
+	pclk = clk_get_rate(clk);
+
+	if (clocksource_mmio_init(base + TIMER2_BASE + REG_COUNT,
+				  "moxart_timer", pclk, 200, 32,
+				  clocksource_mmio_readl_down))
+		panic("%s: clocksource_mmio_init failed\n", node->full_name);
+
+	clock_count_per_tick = DIV_ROUND_CLOSEST(pclk, HZ);
+
+	writel(~0, base + TIMER2_BASE + REG_LOAD);
+	writel(TIMEREG_CR_2_ENABLE, base + TIMER_CR);
+
+	moxart_clockevent.cpumask = cpumask_of(0);
+	moxart_clockevent.irq = irq;
+
+	/*
+	 * documentation is not publicly available:
+	 * min_delta / max_delta obtained by trial-and-error,
+	 * max_delta 0xfffffffe should be ok because count
+	 * register size is u32
+	 */
+	clockevents_config_and_register(&moxart_clockevent, pclk,
+					0x4, 0xfffffffe);
+}
+CLOCKSOURCE_OF_DECLARE(moxart, "moxa,moxart-timer", moxart_timer_init);
diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index d4674e7..8ead025 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -19,42 +19,83 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqreturn.h>
+#include <linux/sched_clock.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
 #define TIMER_IRQ_EN_REG	0x00
-#define TIMER_IRQ_EN(val)		(1 << val)
+#define TIMER_IRQ_EN(val)		BIT(val)
 #define TIMER_IRQ_ST_REG	0x04
 #define TIMER_CTL_REG(val)	(0x10 * val + 0x10)
-#define TIMER_CTL_ENABLE		(1 << 0)
-#define TIMER_CTL_AUTORELOAD		(1 << 1)
-#define TIMER_CTL_ONESHOT		(1 << 7)
-#define TIMER_INTVAL_REG(val)	(0x10 * val + 0x14)
-#define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
-
-#define TIMER_SCAL		16
+#define TIMER_CTL_ENABLE		BIT(0)
+#define TIMER_CTL_RELOAD		BIT(1)
+#define TIMER_CTL_CLK_SRC(val)		(((val) & 0x3) << 2)
+#define TIMER_CTL_CLK_SRC_OSC24M		(1)
+#define TIMER_CTL_CLK_PRES(val)		(((val) & 0x7) << 4)
+#define TIMER_CTL_ONESHOT		BIT(7)
+#define TIMER_INTVAL_REG(val)	(0x10 * (val) + 0x14)
+#define TIMER_CNTVAL_REG(val)	(0x10 * (val) + 0x18)
 
 static void __iomem *timer_base;
+static u32 ticks_per_jiffy;
+
+/*
+ * When we disable a timer, we need to wait at least for 2 cycles of
+ * the timer source clock. We will use for that the clocksource timer
+ * that is already setup and runs at the same frequency than the other
+ * timers, and we never will be disabled.
+ */
+static void sun4i_clkevt_sync(void)
+{
+	u32 old = readl(timer_base + TIMER_CNTVAL_REG(1));
+
+	while ((old - readl(timer_base + TIMER_CNTVAL_REG(1))) < 3)
+		cpu_relax();
+}
+
+static void sun4i_clkevt_time_stop(u8 timer)
+{
+	u32 val = readl(timer_base + TIMER_CTL_REG(timer));
+	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(timer));
+	sun4i_clkevt_sync();
+}
+
+static void sun4i_clkevt_time_setup(u8 timer, unsigned long delay)
+{
+	writel(delay, timer_base + TIMER_INTVAL_REG(timer));
+}
+
+static void sun4i_clkevt_time_start(u8 timer, bool periodic)
+{
+	u32 val = readl(timer_base + TIMER_CTL_REG(timer));
+
+	if (periodic)
+		val &= ~TIMER_CTL_ONESHOT;
+	else
+		val |= TIMER_CTL_ONESHOT;
+
+	writel(val | TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
+	       timer_base + TIMER_CTL_REG(timer));
+}
 
 static void sun4i_clkevt_mode(enum clock_event_mode mode,
 			      struct clock_event_device *clk)
 {
-	u32 u = readl(timer_base + TIMER_CTL_REG(0));
-
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		u &= ~(TIMER_CTL_ONESHOT);
-		writel(u | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
+		sun4i_clkevt_time_stop(0);
+		sun4i_clkevt_time_setup(0, ticks_per_jiffy);
+		sun4i_clkevt_time_start(0, true);
 		break;
-
 	case CLOCK_EVT_MODE_ONESHOT:
-		writel(u | TIMER_CTL_ONESHOT, timer_base + TIMER_CTL_REG(0));
+		sun4i_clkevt_time_stop(0);
+		sun4i_clkevt_time_start(0, false);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	default:
-		writel(u & ~(TIMER_CTL_ENABLE), timer_base + TIMER_CTL_REG(0));
+		sun4i_clkevt_time_stop(0);
 		break;
 	}
 }
@@ -62,10 +103,9 @@ static void sun4i_clkevt_mode(enum clock_event_mode mode,
 static int sun4i_clkevt_next_event(unsigned long evt,
 				   struct clock_event_device *unused)
 {
-	u32 u = readl(timer_base + TIMER_CTL_REG(0));
-	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
-	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
-	       timer_base + TIMER_CTL_REG(0));
+	sun4i_clkevt_time_stop(0);
+	sun4i_clkevt_time_setup(0, evt);
+	sun4i_clkevt_time_start(0, false);
 
 	return 0;
 }
@@ -96,6 +136,11 @@ static struct irqaction sun4i_timer_irq = {
 	.dev_id = &sun4i_clockevent,
 };
 
+static u32 sun4i_timer_sched_read(void)
+{
+	return ~readl(timer_base + TIMER_CNTVAL_REG(1));
+}
+
 static void __init sun4i_timer_init(struct device_node *node)
 {
 	unsigned long rate = 0;
@@ -114,22 +159,23 @@ static void __init sun4i_timer_init(struct device_node *node)
 	clk = of_clk_get(node, 0);
 	if (IS_ERR(clk))
 		panic("Can't get timer clock");
+	clk_prepare_enable(clk);
 
 	rate = clk_get_rate(clk);
 
-	writel(rate / (TIMER_SCAL * HZ),
-	       timer_base + TIMER_INTVAL_REG(0));
+	writel(~0, timer_base + TIMER_INTVAL_REG(1));
+	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD |
+	       TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
+	       timer_base + TIMER_CTL_REG(1));
+
+	setup_sched_clock(sun4i_timer_sched_read, 32, rate);
+	clocksource_mmio_init(timer_base + TIMER_CNTVAL_REG(1), node->name,
+			      rate, 300, 32, clocksource_mmio_readl_down);
 
-	/* set clock source to HOSC, 16 pre-division */
-	val = readl(timer_base + TIMER_CTL_REG(0));
-	val &= ~(0x07 << 4);
-	val &= ~(0x03 << 2);
-	val |= (4 << 4) | (1 << 2);
-	writel(val, timer_base + TIMER_CTL_REG(0));
+	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
 
-	/* set mode to auto reload */
-	val = readl(timer_base + TIMER_CTL_REG(0));
-	writel(val | TIMER_CTL_AUTORELOAD, timer_base + TIMER_CTL_REG(0));
+	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
+	       timer_base + TIMER_CTL_REG(0));
 
 	ret = setup_irq(irq, &sun4i_timer_irq);
 	if (ret)
@@ -141,8 +187,8 @@ static void __init sun4i_timer_init(struct device_node *node)
 
 	sun4i_clockevent.cpumask = cpumask_of(0);
 
-	clockevents_config_and_register(&sun4i_clockevent, rate / TIMER_SCAL,
-					0x1, 0xff);
+	clockevents_config_and_register(&sun4i_clockevent, rate, 0x1,
+					0xffffffff);
 }
 CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-timer",
 		       sun4i_timer_init);
diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
index ecbeb68..9c7f018 100644
--- a/drivers/clocksource/time-orion.c
+++ b/drivers/clocksource/time-orion.c
@@ -19,7 +19,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/spinlock.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 #define TIMER_CTRL		0x00
 #define  TIMER0_EN		BIT(0)
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index c463ce9..93b7f96 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -23,16 +23,20 @@
 #define ARCH_TIMER_CTRL_IT_MASK		(1 << 1)
 #define ARCH_TIMER_CTRL_IT_STAT		(1 << 2)
 
-#define ARCH_TIMER_REG_CTRL		0
-#define ARCH_TIMER_REG_TVAL		1
+enum arch_timer_reg {
+	ARCH_TIMER_REG_CTRL,
+	ARCH_TIMER_REG_TVAL,
+};
 
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
