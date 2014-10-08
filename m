Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaJHSMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:12:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:38840 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaJHSMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:12:07 -0400
Date: Wed, 8 Oct 2014 20:12:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer changes for 3.18
Message-ID: <alpine.DEB.2.11.1410082001460.4292@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

Nothing really exciting this time:

 - A few fixlets in the NOHZ code

 - A new ARM SoC timer abomination. One should expect that we have
   enough of them already, but they insist on inventing new ones.

 - The usual bunch of ARM SoC timer updates. That feels like herding
   cats.

Thanks,

	tglx

------------------>
Carlo Caione (2):
      ARM: meson: documentation: Add timer documentation
      ARM: meson6: clocksource: Add Meson6 timer support

Dan Carpenter (1):
      timerfd: Remove an always true check

Gael Portay (1):
      clocksource: tcb_clksrc: Sanitize IRQ request

Hao Liu (1):
      clocksource: sirf: Disable counter before re-setting it

Michal Simek (1):
      clocksource: cadence_ttc: Add support for 32bit mode

Nathan Lynch (3):
      clocksource: arm_arch_timer: Change clocksource name if CP15 unavailable
      clocksource: arm_arch_timer: Enable counter access for 32-bit ARM
      clocksource: arm_arch_timer: Consolidate arch_timer_evtstrm_enable

Simon Horman (3):
      clocksource: sh_cmt: Document SoC specific bindings
      clocksource: sh_mtu2: Document r7s72100 binding
      clocksource: sh_tmu: Document r8a7779 binding

Stefan Agner (1):
      clocksource: vf_pit_timer: Support shutdown mode

Sudeep Holla (1):
      clocksource: arm_arch_timer: Discard unavailable timers correctly

Viresh Kumar (2):
      nohz: Fix spurious periodic tick behaviour in low-res dynticks mode
      nohz: Avoid tick's double reprogramming in highres mode


 .../bindings/timer/amlogic,meson6-timer.txt        |  15 ++
 .../devicetree/bindings/timer/renesas,cmt.txt      |  44 +++++-
 .../devicetree/bindings/timer/renesas,mtu2.txt     |   7 +-
 .../devicetree/bindings/timer/renesas,tmu.txt      |   7 +-
 arch/arm/include/asm/arch_timer.h                  |  25 ---
 arch/arm64/include/asm/arch_timer.h                |  31 ----
 drivers/clocksource/Kconfig                        |   3 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/arm_arch_timer.c               |  64 +++++++-
 drivers/clocksource/cadence_ttc_timer.c            |  15 +-
 drivers/clocksource/meson6_timer.c                 | 167 +++++++++++++++++++++
 drivers/clocksource/tcb_clksrc.c                   |  13 +-
 drivers/clocksource/timer-marco.c                  |   5 +-
 drivers/clocksource/vf_pit_timer.c                 |   4 +
 fs/timerfd.c                                       |   3 +-
 kernel/time/tick-sched.c                           |   8 +
 16 files changed, 323 insertions(+), 89 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/amlogic,meson6-timer.txt
 create mode 100644 drivers/clocksource/meson6_timer.c

diff --git a/Documentation/devicetree/bindings/timer/amlogic,meson6-timer.txt b/Documentation/devicetree/bindings/timer/amlogic,meson6-timer.txt
new file mode 100644
index 000000000000..a092053f7902
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/amlogic,meson6-timer.txt
@@ -0,0 +1,15 @@
+Amlogic Meson6 SoCs Timer Controller
+
+Required properties:
+
+- compatible : should be "amlogic,meson6-timer"
+- reg : Specifies base physical address and size of the registers.
+- interrupts : The interrupt of the first timer
+
+Example:
+
+timer@c1109940 {
+	compatible = "amlogic,meson6-timer";
+	reg = <0xc1109940 0x14>;
+	interrupts = <0 10 1>;
+};
diff --git a/Documentation/devicetree/bindings/timer/renesas,cmt.txt b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
index a17418b0ece3..1a05c1b243c1 100644
--- a/Documentation/devicetree/bindings/timer/renesas,cmt.txt
+++ b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
@@ -11,15 +11,47 @@ datasheets.
 
 Required Properties:
 
-  - compatible: must contain one of the following.
-    - "renesas,cmt-32" for the 32-bit CMT
+  - compatible: must contain one or more of the following:
+    - "renesas,cmt-32-r8a7740" for the r8a7740 32-bit CMT
+		(CMT0)
+    - "renesas,cmt-32-sh7372" for the sh7372 32-bit CMT
+		(CMT0)
+    - "renesas,cmt-32-sh73a0" for the sh73a0 32-bit CMT
+		(CMT0)
+    - "renesas,cmt-32" for all 32-bit CMT without fast clock support
 		(CMT0 on sh7372, sh73a0 and r8a7740)
-    - "renesas,cmt-32-fast" for the 32-bit CMT with fast clock support
+		This is a fallback for the above renesas,cmt-32-* entries.
+
+    - "renesas,cmt-32-fast-r8a7740" for the r8a7740 32-bit CMT with fast
+		clock support (CMT[234])
+    - "renesas,cmt-32-fast-sh7372" for the sh7372 32-bit CMT with fast
+		clock support (CMT[234])
+    - "renesas,cmt-32-fast-sh73a0" for the sh73A0 32-bit CMT with fast
+		clock support (CMT[234])
+    - "renesas,cmt-32-fast" for all 32-bit CMT with fast clock support
 		(CMT[234] on sh7372, sh73a0 and r8a7740)
-    - "renesas,cmt-48" for the 48-bit CMT
+		This is a fallback for the above renesas,cmt-32-fast-* entries.
+
+    - "renesas,cmt-48-sh7372" for the sh7372 48-bit CMT
+		(CMT1)
+    - "renesas,cmt-48-sh73a0" for the sh73A0 48-bit CMT
+		(CMT1)
+    - "renesas,cmt-48-r8a7740" for the r8a7740 48-bit CMT
+		(CMT1)
+    - "renesas,cmt-48" for all non-second generation 48-bit CMT
 		(CMT1 on sh7372, sh73a0 and r8a7740)
-    - "renesas,cmt-48-gen2" for the second generation 48-bit CMT
+		This is a fallback for the above renesas,cmt-48-* entries.
+
+    - "renesas,cmt-48-r8a73a4" for the r8a73a4 48-bit CMT
+		(CMT[01])
+    - "renesas,cmt-48-r8a7790" for the r8a7790 48-bit CMT
+		(CMT[01])
+    - "renesas,cmt-48-r8a7791" for the r8a7791 48-bit CMT
+		(CMT[01])
+    - "renesas,cmt-48-gen2" for all second generation 48-bit CMT
 		(CMT[01] on r8a73a4, r8a7790 and r8a7791)
+		This is a fallback for the renesas,cmt-48-r8a73a4,
+		renesas,cmt-48-r8a7790 and renesas,cmt-48-r8a7791 entries.
 
   - reg: base address and length of the registers block for the timer module.
   - interrupts: interrupt-specifier for the timer, one per channel.
@@ -36,7 +68,7 @@ Example: R8A7790 (R-Car H2) CMT0 node
 	them channels 0 and 1 in the documentation.
 
 	cmt0: timer@ffca0000 {
-		compatible = "renesas,cmt-48-gen2";
+		compatible = "renesas,cmt-48-r8a7790", "renesas,cmt-48-gen2";
 		reg = <0 0xffca0000 0 0x1004>;
 		interrupts = <0 142 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 142 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
index 917453f826bc..d9a8d5af1a21 100644
--- a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
+++ b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
@@ -8,7 +8,10 @@ are independent. The MTU2 hardware supports five channels indexed from 0 to 4.
 
 Required Properties:
 
-  - compatible: must contain "renesas,mtu2"
+  - compatible: must be one or more of the following:
+    - "renesas,mtu2-r7s72100" for the r7s72100 MTU2
+    - "renesas,mtu2" for any MTU2
+      This is a fallback for the above renesas,mtu2-* entries
 
   - reg: base address and length of the registers block for the timer module.
 
@@ -26,7 +29,7 @@ Required Properties:
 Example: R7S72100 (RZ/A1H) MTU2 node
 
 	mtu2: timer@fcff0000 {
-		compatible = "renesas,mtu2";
+		compatible = "renesas,mtu2-r7s72100", "renesas,mtu2";
 		reg = <0xfcff0000 0x400>;
 		interrupts = <0 139 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 146 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/Documentation/devicetree/bindings/timer/renesas,tmu.txt b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
index 425d0c5f4aee..7db89fb25444 100644
--- a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
+++ b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
@@ -8,7 +8,10 @@ are independent. The TMU hardware supports up to three channels.
 
 Required Properties:
 
-  - compatible: must contain "renesas,tmu"
+  - compatible: must contain one or more of the following:
+    - "renesas,tmu-r8a7779" for the r8a7779 TMU
+    - "renesas,tmu" for any TMU.
+      This is a fallback for the above renesas,tmu-* entries
 
   - reg: base address and length of the registers block for the timer module.
 
@@ -27,7 +30,7 @@ Optional Properties:
 Example: R8A7779 (R-Car H1) TMU0 node
 
 	tmu0: timer@ffd80000 {
-		compatible = "renesas,tmu";
+		compatible = "renesas,tmu-r8a7779", "renesas,tmu";
 		reg = <0xffd80000 0x30>;
 		interrupts = <0 32 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 33 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 0704e0cf5571..92793ba69c40 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -99,31 +99,6 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
 
-static inline void arch_counter_set_user_access(void)
-{
-	u32 cntkctl = arch_timer_get_cntkctl();
-
-	/* Disable user access to both physical/virtual counters/timers */
-	/* Also disable virtual event stream */
-	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
-			| ARCH_TIMER_USR_VT_ACCESS_EN
-			| ARCH_TIMER_VIRT_EVT_EN
-			| ARCH_TIMER_USR_VCT_ACCESS_EN
-			| ARCH_TIMER_USR_PCT_ACCESS_EN);
-	arch_timer_set_cntkctl(cntkctl);
-}
-
-static inline void arch_timer_evtstrm_enable(int divider)
-{
-	u32 cntkctl = arch_timer_get_cntkctl();
-	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
-	/* Set the divider and enable virtual event stream */
-	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
-			| ARCH_TIMER_VIRT_EVT_EN;
-	arch_timer_set_cntkctl(cntkctl);
-	elf_hwcap |= HWCAP_EVTSTRM;
-}
-
 #endif
 
 #endif
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 9400596a0f39..f19097134b02 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -104,37 +104,6 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
-static inline void arch_counter_set_user_access(void)
-{
-	u32 cntkctl = arch_timer_get_cntkctl();
-
-	/* Disable user access to the timers and the physical counter */
-	/* Also disable virtual event stream */
-	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
-			| ARCH_TIMER_USR_VT_ACCESS_EN
-			| ARCH_TIMER_VIRT_EVT_EN
-			| ARCH_TIMER_USR_PCT_ACCESS_EN);
-
-	/* Enable user access to the virtual counter */
-	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
-
-	arch_timer_set_cntkctl(cntkctl);
-}
-
-static inline void arch_timer_evtstrm_enable(int divider)
-{
-	u32 cntkctl = arch_timer_get_cntkctl();
-	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
-	/* Set the divider and enable virtual event stream */
-	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
-			| ARCH_TIMER_VIRT_EVT_EN;
-	arch_timer_set_cntkctl(cntkctl);
-	elf_hwcap |= HWCAP_EVTSTRM;
-#ifdef CONFIG_COMPAT
-	compat_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
-#endif
-}
-
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index cfd6519df661..38029ca4e777 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -30,6 +30,9 @@ config ARMADA_370_XP_TIMER
 	bool
 	select CLKSRC_OF
 
+config MESON6_TIMER
+	bool
+
 config ORION_TIMER
 	select CLKSRC_OF
 	select CLKSRC_MMIO
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 7fd9fd1dff42..e4ae987d70aa 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_ARCH_U300)		+= timer-u300.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
 obj-$(CONFIG_SUN5I_HSTIMER)	+= timer-sun5i.o
+obj-$(CONFIG_MESON6_TIMER)	+= meson6_timer.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
 obj-$(CONFIG_ARCH_NSPIRE)	+= zevio-timer.o
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5163ec13429d..2133f9d59d06 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -299,6 +299,21 @@ static void __arch_timer_setup(unsigned type,
 	clockevents_config_and_register(clk, arch_timer_rate, 0xf, 0x7fffffff);
 }
 
+static void arch_timer_evtstrm_enable(int divider)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
+
+	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
+	/* Set the divider and enable virtual event stream */
+	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+			| ARCH_TIMER_VIRT_EVT_EN;
+	arch_timer_set_cntkctl(cntkctl);
+	elf_hwcap |= HWCAP_EVTSTRM;
+#ifdef CONFIG_COMPAT
+	compat_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
+#endif
+}
+
 static void arch_timer_configure_evtstream(void)
 {
 	int evt_stream_div, pos;
@@ -312,6 +327,23 @@ static void arch_timer_configure_evtstream(void)
 	arch_timer_evtstrm_enable(min(pos, 15));
 }
 
+static void arch_counter_set_user_access(void)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
+
+	/* Disable user access to the timers and the physical counter */
+	/* Also disable virtual event stream */
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_VIRT_EVT_EN
+			| ARCH_TIMER_USR_PCT_ACCESS_EN);
+
+	/* Enable user access to the virtual counter */
+	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
+
+	arch_timer_set_cntkctl(cntkctl);
+}
+
 static int arch_timer_setup(struct clock_event_device *clk)
 {
 	__arch_timer_setup(ARCH_CP15_TIMER, clk);
@@ -429,11 +461,19 @@ static void __init arch_counter_register(unsigned type)
 	u64 start_count;
 
 	/* Register the CP15 based counter if we have one */
-	if (type & ARCH_CP15_TIMER)
+	if (type & ARCH_CP15_TIMER) {
 		arch_timer_read_counter = arch_counter_get_cntvct;
-	else
+	} else {
 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
 
+		/* If the clocksource name is "arch_sys_counter" the
+		 * VDSO will attempt to read the CP15-based counter.
+		 * Ensure this does not happen when CP15-based
+		 * counter is not available.
+		 */
+		clocksource_counter.name = "arch_mem_counter";
+	}
+
 	start_count = arch_timer_read_counter();
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
 	cyclecounter.mult = clocksource_counter.mult;
@@ -616,17 +656,29 @@ static const struct of_device_id arch_timer_mem_of_match[] __initconst = {
 	{},
 };
 
+static bool __init
+arch_timer_probed(int type, const struct of_device_id *matches)
+{
+	struct device_node *dn;
+	bool probed = false;
+
+	dn = of_find_matching_node(NULL, matches);
+	if (dn && of_device_is_available(dn) && (arch_timers_present & type))
+		probed = true;
+	of_node_put(dn);
+
+	return probed;
+}
+
 static void __init arch_timer_common_init(void)
 {
 	unsigned mask = ARCH_CP15_TIMER | ARCH_MEM_TIMER;
 
 	/* Wait until both nodes are probed if we have two timers */
 	if ((arch_timers_present & mask) != mask) {
-		if (of_find_matching_node(NULL, arch_timer_mem_of_match) &&
-				!(arch_timers_present & ARCH_MEM_TIMER))
+		if (!arch_timer_probed(ARCH_MEM_TIMER, arch_timer_mem_of_match))
 			return;
-		if (of_find_matching_node(NULL, arch_timer_of_match) &&
-				!(arch_timers_present & ARCH_CP15_TIMER))
+		if (!arch_timer_probed(ARCH_CP15_TIMER, arch_timer_of_match))
 			return;
 	}
 
diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 7a08811df9aa..510c8a1d37b3 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -25,7 +25,7 @@
 #include <linux/sched_clock.h>
 
 /*
- * This driver configures the 2 16-bit count-up timers as follows:
+ * This driver configures the 2 16/32-bit count-up timers as follows:
  *
  * T1: Timer 1, clocksource for generic timekeeping
  * T2: Timer 2, clockevent source for hrtimers
@@ -321,7 +321,8 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
+static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base,
+					 u32 timer_width)
 {
 	struct ttc_timer_clocksource *ttccs;
 	int err;
@@ -351,7 +352,7 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	ttccs->cs.name = "ttc_clocksource";
 	ttccs->cs.rating = 200;
 	ttccs->cs.read = __ttc_clocksource_read;
-	ttccs->cs.mask = CLOCKSOURCE_MASK(16);
+	ttccs->cs.mask = CLOCKSOURCE_MASK(timer_width);
 	ttccs->cs.flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
 	/*
@@ -372,7 +373,8 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	}
 
 	ttc_sched_clock_val_reg = base + TTC_COUNT_VAL_OFFSET;
-	sched_clock_register(ttc_sched_clock_read, 16, ttccs->ttc.freq / PRESCALE);
+	sched_clock_register(ttc_sched_clock_read, timer_width,
+			     ttccs->ttc.freq / PRESCALE);
 }
 
 static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
@@ -467,6 +469,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 	struct clk *clk_cs, *clk_ce;
 	static int initialized;
 	int clksel;
+	u32 timer_width = 16;
 
 	if (initialized)
 		return;
@@ -490,6 +493,8 @@ static void __init ttc_timer_init(struct device_node *timer)
 		BUG();
 	}
 
+	of_property_read_u32(timer, "timer-width", &timer_width);
+
 	clksel = readl_relaxed(timer_baseaddr + TTC_CLK_CNTRL_OFFSET);
 	clksel = !!(clksel & TTC_CLK_CNTRL_CSRC_MASK);
 	clk_cs = of_clk_get(timer, clksel);
@@ -506,7 +511,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 		BUG();
 	}
 
-	ttc_setup_clocksource(clk_cs, timer_baseaddr);
+	ttc_setup_clocksource(clk_cs, timer_baseaddr, timer_width);
 	ttc_setup_clockevent(clk_ce, timer_baseaddr + 4, irq);
 
 	pr_info("%s #0 at %p, irq=%d\n", timer->name, timer_baseaddr, irq);
diff --git a/drivers/clocksource/meson6_timer.c b/drivers/clocksource/meson6_timer.c
new file mode 100644
index 000000000000..5c15cba41dca
--- /dev/null
+++ b/drivers/clocksource/meson6_timer.c
@@ -0,0 +1,167 @@
+/*
+ * Amlogic Meson6 SoCs timer handling.
+ *
+ * Copyright (C) 2014 Carlo Caione <carlo@caione.org>
+ *
+ * Based on code from Amlogic, Inc
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
+#include <linux/sched_clock.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#define CED_ID			0
+#define CSD_ID			4
+
+#define TIMER_ISA_MUX		0
+#define TIMER_ISA_VAL(t)	(((t) + 1) << 2)
+
+#define TIMER_INPUT_BIT(t)	(2 * (t))
+#define TIMER_ENABLE_BIT(t)	(16 + (t))
+#define TIMER_PERIODIC_BIT(t)	(12 + (t))
+
+#define TIMER_CED_INPUT_MASK	(3UL << TIMER_INPUT_BIT(CED_ID))
+#define TIMER_CSD_INPUT_MASK	(7UL << TIMER_INPUT_BIT(CSD_ID))
+
+#define TIMER_CED_UNIT_1US	0
+#define TIMER_CSD_UNIT_1US	1
+
+static void __iomem *timer_base;
+
+static u64 notrace meson6_timer_sched_read(void)
+{
+	return (u64)readl(timer_base + TIMER_ISA_VAL(CSD_ID));
+}
+
+static void meson6_clkevt_time_stop(unsigned char timer)
+{
+	u32 val = readl(timer_base + TIMER_ISA_MUX);
+
+	writel(val & ~TIMER_ENABLE_BIT(timer), timer_base + TIMER_ISA_MUX);
+}
+
+static void meson6_clkevt_time_setup(unsigned char timer, unsigned long delay)
+{
+	writel(delay, timer_base + TIMER_ISA_VAL(timer));
+}
+
+static void meson6_clkevt_time_start(unsigned char timer, bool periodic)
+{
+	u32 val = readl(timer_base + TIMER_ISA_MUX);
+
+	if (periodic)
+		val |= TIMER_PERIODIC_BIT(timer);
+	else
+		val &= ~TIMER_PERIODIC_BIT(timer);
+
+	writel(val | TIMER_ENABLE_BIT(timer), timer_base + TIMER_ISA_MUX);
+}
+
+static void meson6_clkevt_mode(enum clock_event_mode mode,
+			       struct clock_event_device *clk)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		meson6_clkevt_time_stop(CED_ID);
+		meson6_clkevt_time_setup(CED_ID, USEC_PER_SEC/HZ - 1);
+		meson6_clkevt_time_start(CED_ID, true);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		meson6_clkevt_time_stop(CED_ID);
+		meson6_clkevt_time_start(CED_ID, false);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		meson6_clkevt_time_stop(CED_ID);
+		break;
+	}
+}
+
+static int meson6_clkevt_next_event(unsigned long evt,
+				    struct clock_event_device *unused)
+{
+	meson6_clkevt_time_stop(CED_ID);
+	meson6_clkevt_time_setup(CED_ID, evt);
+	meson6_clkevt_time_start(CED_ID, false);
+
+	return 0;
+}
+
+static struct clock_event_device meson6_clockevent = {
+	.name		= "meson6_tick",
+	.rating		= 400,
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= meson6_clkevt_mode,
+	.set_next_event	= meson6_clkevt_next_event,
+};
+
+static irqreturn_t meson6_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction meson6_timer_irq = {
+	.name		= "meson6_timer",
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= meson6_timer_interrupt,
+	.dev_id		= &meson6_clockevent,
+};
+
+static void __init meson6_timer_init(struct device_node *node)
+{
+	u32 val;
+	int ret, irq;
+
+	timer_base = of_io_request_and_map(node, 0, "meson6-timer");
+	if (IS_ERR(timer_base))
+		panic("Can't map registers");
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0)
+		panic("Can't parse IRQ");
+
+	/* Set 1us for timer E */
+	val = readl(timer_base + TIMER_ISA_MUX);
+	val &= ~TIMER_CSD_INPUT_MASK;
+	val |= TIMER_CSD_UNIT_1US << TIMER_INPUT_BIT(CSD_ID);
+	writel(val, timer_base + TIMER_ISA_MUX);
+
+	sched_clock_register(meson6_timer_sched_read, 32, USEC_PER_SEC);
+	clocksource_mmio_init(timer_base + TIMER_ISA_VAL(CSD_ID), node->name,
+			      1000 * 1000, 300, 32, clocksource_mmio_readl_up);
+
+	/* Timer A base 1us */
+	val &= ~TIMER_CED_INPUT_MASK;
+	val |= TIMER_CED_UNIT_1US << TIMER_INPUT_BIT(CED_ID);
+	writel(val, timer_base + TIMER_ISA_MUX);
+
+	/* Stop the timer A */
+	meson6_clkevt_time_stop(CED_ID);
+
+	ret = setup_irq(irq, &meson6_timer_irq);
+	if (ret)
+		pr_warn("failed to setup irq %d\n", irq);
+
+	meson6_clockevent.cpumask = cpu_possible_mask;
+	meson6_clockevent.irq = irq;
+
+	clockevents_config_and_register(&meson6_clockevent, USEC_PER_SEC,
+					1, 0xfffe);
+}
+CLOCKSOURCE_OF_DECLARE(meson6, "amlogic,meson6-timer",
+		       meson6_timer_init);
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index a8d7ea14f183..c0b56ea2ddf6 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -178,12 +178,6 @@ static irqreturn_t ch2_irq(int irq, void *handle)
 	return IRQ_NONE;
 }
 
-static struct irqaction tc_irqaction = {
-	.name		= "tc_clkevt",
-	.flags		= IRQF_TIMER,
-	.handler	= ch2_irq,
-};
-
 static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 {
 	int ret;
@@ -198,15 +192,16 @@ static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 
 	clkevt.regs = tc->regs;
 	clkevt.clk = t2_clk;
-	tc_irqaction.dev_id = &clkevt;
 
 	timer_clock = clk32k_divisor_idx;
 
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
-	ret = setup_irq(irq, &tc_irqaction);
-	if (ret)
+	ret = request_irq(irq, ch2_irq, IRQF_TIMER, "tc_clkevt", &clkevt);
+	if (ret) {
+		clk_disable_unprepare(t2_clk);
 		return ret;
+	}
 
 	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
 
diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 330e93064692..caf7a2030461 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -63,7 +63,7 @@ static inline void sirfsoc_timer_count_disable(int idx)
 /* enable count and interrupt */
 static inline void sirfsoc_timer_count_enable(int idx)
 {
-	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx) | 0x7,
+	writel_relaxed(readl_relaxed(sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx) | 0x3,
 		sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL + 4 * idx);
 }
 
@@ -103,6 +103,9 @@ static int sirfsoc_timer_set_next_event(unsigned long delta,
 {
 	int cpu = smp_processor_id();
 
+	/* disable timer first, then modify the related registers */
+	sirfsoc_timer_count_disable(cpu);
+
 	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_COUNTER_0 +
 		4 * cpu);
 	writel_relaxed(delta, sirfsoc_timer_base + SIRFSOC_TIMER_MATCH_0 +
diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
index a918bc481c52..b45ac6229b57 100644
--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -93,6 +93,10 @@ static void pit_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_PERIODIC:
 		pit_set_next_event(cycle_per_jiffy, evt);
 		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		pit_timer_disable();
+		break;
 	default:
 		break;
 	}
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 80c350216ea8..b46ffa94372a 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -333,8 +333,7 @@ static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg
 		spin_lock_irq(&ctx->wqh.lock);
 		if (!timerfd_canceled(ctx)) {
 			ctx->ticks = ticks;
-			if (ticks)
-				wake_up_locked(&ctx->wqh);
+			wake_up_locked(&ctx->wqh);
 		} else
 			ret = -ECANCELED;
 		spin_unlock_irq(&ctx->wqh.lock);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 99aa6ee3908f..cc0a5b6f741b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -968,6 +968,10 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	tick_sched_do_timer(now);
 	tick_sched_handle(ts, regs);
 
+	/* No need to reprogram if we are running tickless  */
+	if (unlikely(ts->tick_stopped))
+		return;
+
 	while (tick_nohz_reprogram(ts, now)) {
 		now = ktime_get();
 		tick_do_update_jiffies64(now);
@@ -1095,6 +1099,10 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	if (regs)
 		tick_sched_handle(ts, regs);
 
+	/* No need to reprogram if we are in idle or full dynticks mode */
+	if (unlikely(ts->tick_stopped))
+		return HRTIMER_NORESTART;
+
 	hrtimer_forward(timer, now, tick_period);
 
 	return HRTIMER_RESTART;
