Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaILODM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:03:12 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43643 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaILOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:02:04 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 15/18] ARM64 / ACPI: Parse GTDT to initialize arch timer
Date: Fri, 12 Sep 2014 22:00:13 +0800
Message-Id: <1410530416-30200-16-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the information presented by GTDT to initialize the arch
timer (not memory-mapped).

Originally-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/kernel/time.c             |    7 ++
 drivers/clocksource/arm_arch_timer.c |  117 ++++++++++++++++++++++++++++------
 include/linux/clocksource.h          |    6 ++
 3 files changed, 111 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 1a7125c..42f9195 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/clocksource.h>
 #include <linux/clk-provider.h>
+#include <linux/acpi.h>
 
 #include <clocksource/arm_arch_timer.h>
 
@@ -72,6 +73,12 @@ void __init time_init(void)
 
 	tick_setup_hrtimer_broadcast();
 
+	/*
+	 * Since ACPI or FDT will only one be available in the system,
+	 * we can use acpi_generic_timer_init() here safely
+	 */
+	acpi_generic_timer_init();
+
 	arch_timer_rate = arch_timer_get_rate();
 	if (!arch_timer_rate)
 		panic("Unable to initialise architected timer.\n");
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5163ec1..397783f 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -21,6 +21,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/sched_clock.h>
+#include <linux/acpi.h>
 
 #include <asm/arch_timer.h>
 #include <asm/virt.h>
@@ -338,8 +339,12 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
 	if (arch_timer_rate)
 		return;
 
-	/* Try to determine the frequency from the device tree or CNTFRQ */
-	if (of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
+	/*
+	 * Try to determine the frequency from the device tree or CNTFRQ,
+	 * if ACPI is enabled, get the frequency from CNTFRQ ONLY.
+	 */
+	if (!acpi_disabled ||
+	    of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
 		if (cntbase)
 			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
 		else
@@ -635,20 +640,8 @@ static void __init arch_timer_common_init(void)
 	arch_timer_arch_init();
 }
 
-static void __init arch_timer_init(struct device_node *np)
+static void __init arch_timer_init(void)
 {
-	int i;
-
-	if (arch_timers_present & ARCH_CP15_TIMER) {
-		pr_warn("arch_timer: multiple nodes in dt, skipping\n");
-		return;
-	}
-
-	arch_timers_present |= ARCH_CP15_TIMER;
-	for (i = PHYS_SECURE_PPI; i < MAX_TIMER_PPI; i++)
-		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
-	arch_timer_detect_rate(NULL, np);
-
 	/*
 	 * If HYP mode is available, we know that the physical timer
 	 * has been configured to be accessible from PL1. Use it, so
@@ -667,13 +660,31 @@ static void __init arch_timer_init(struct device_node *np)
 		}
 	}
 
-	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
-
 	arch_timer_register();
 	arch_timer_common_init();
 }
-CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_init);
-CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_init);
+
+static void __init arch_timer_of_init(struct device_node *np)
+{
+	int i;
+
+	if (arch_timers_present & ARCH_CP15_TIMER) {
+		pr_warn("arch_timer: multiple nodes in dt, skipping\n");
+		return;
+	}
+
+	arch_timers_present |= ARCH_CP15_TIMER;
+	for (i = PHYS_SECURE_PPI; i < MAX_TIMER_PPI; i++)
+		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
+
+	arch_timer_detect_rate(NULL, np);
+
+	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
+
+	arch_timer_init();
+}
+CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_of_init);
+CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_of_init);
 
 static void __init arch_timer_mem_init(struct device_node *np)
 {
@@ -740,3 +751,71 @@ static void __init arch_timer_mem_init(struct device_node *np)
 }
 CLOCKSOURCE_OF_DECLARE(armv7_arch_timer_mem, "arm,armv7-timer-mem",
 		       arch_timer_mem_init);
+
+#ifdef CONFIG_ACPI
+static int __init
+map_generic_timer_interrupt(u32 interrupt, u32 flags)
+{
+	int trigger, polarity;
+
+	if (!interrupt)
+		return 0;
+
+	trigger = (flags & ACPI_GTDT_INTERRUPT_MODE) ? ACPI_EDGE_SENSITIVE
+			: ACPI_LEVEL_SENSITIVE;
+
+	polarity = (flags & ACPI_GTDT_INTERRUPT_POLARITY) ? ACPI_ACTIVE_LOW
+			: ACPI_ACTIVE_HIGH;
+
+	return acpi_register_gsi(NULL, interrupt, trigger, polarity);
+}
+
+/* Initialize per-processor generic timer */
+static int __init arch_timer_acpi_init(struct acpi_table_header *table)
+{
+	struct acpi_table_gtdt *gtdt;
+
+	if (arch_timers_present & ARCH_CP15_TIMER) {
+		pr_warn("arch_timer: already initialized, skipping\n");
+		return -EINVAL;
+	}
+
+	gtdt = container_of(table, struct acpi_table_gtdt, header);
+
+	arch_timers_present |= ARCH_CP15_TIMER;
+
+	arch_timer_ppi[PHYS_SECURE_PPI] =
+		map_generic_timer_interrupt(gtdt->secure_el1_interrupt,
+		gtdt->secure_el1_flags);
+
+	arch_timer_ppi[PHYS_NONSECURE_PPI] =
+		map_generic_timer_interrupt(gtdt->non_secure_el1_interrupt,
+		gtdt->non_secure_el1_flags);
+
+	arch_timer_ppi[VIRT_PPI] =
+		map_generic_timer_interrupt(gtdt->virtual_timer_interrupt,
+		gtdt->virtual_timer_flags);
+
+	arch_timer_ppi[HYP_PPI] =
+		map_generic_timer_interrupt(gtdt->non_secure_el2_interrupt,
+		gtdt->non_secure_el2_flags);
+
+	/* Get the frequency from CNTFRQ */
+	arch_timer_detect_rate(NULL, NULL);
+
+	/* Always-on capability */
+	arch_timer_c3stop = !(gtdt->non_secure_el1_flags & ACPI_GTDT_ALWAYS_ON);
+
+	arch_timer_init();
+	return 0;
+}
+
+/* Initialize all the generic timers presented in GTDT */
+void __init acpi_generic_timer_init(void)
+{
+	if (acpi_disabled)
+		return;
+
+	acpi_table_parse(ACPI_SIG_GTDT, arch_timer_acpi_init);
+}
+#endif
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 653f0e2..5839f98 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -346,4 +346,10 @@ extern void clocksource_of_init(void);
 static inline void clocksource_of_init(void) {}
 #endif
 
+#ifdef CONFIG_ACPI
+void acpi_generic_timer_init(void);
+#else
+static inline void acpi_generic_timer_init(void) {}
+#endif
+
 #endif /* _LINUX_CLOCKSOURCE_H */
-- 
1.7.9.5

