Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbaIOXwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:22 -0400
Received: from mail-qg0-f74.google.com ([209.85.192.74]:53552 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbaIOXvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:42 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/24] MIPS: Move GIC to drivers/irqchip/
Date: Mon, 15 Sep 2014 16:51:16 -0700
Message-Id: <1410825087-5497-14-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move GIC irqchip support to drivers/irqchip/ and rename the Kconfig
option from IRQ_GIC to MIPS_GIC to avoid confusion with the ARM GIC.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/Kconfig                                            | 10 +++-------
 arch/mips/kernel/Makefile                                    |  1 -
 arch/mips/kernel/cevt-r4k.c                                  |  2 +-
 arch/mips/kernel/smp-mt.c                                    |  4 ++--
 arch/mips/mti-malta/malta-time.c                             | 10 +++++-----
 drivers/irqchip/Kconfig                                      |  4 ++++
 drivers/irqchip/Makefile                                     |  1 +
 arch/mips/kernel/irq-gic.c => drivers/irqchip/irq-mips-gic.c |  0
 8 files changed, 16 insertions(+), 16 deletions(-)
 rename arch/mips/kernel/irq-gic.c => drivers/irqchip/irq-mips-gic.c (100%)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index de72c92..a0720d0 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -319,7 +319,7 @@ config MIPS_MALTA
 	select GENERIC_ISA_DMA
 	select HAVE_PCSPKR_PLATFORM
 	select IRQ_CPU
-	select IRQ_GIC
+	select MIPS_GIC
 	select HW_HAS_PCI
 	select I8253
 	select I8259
@@ -360,7 +360,7 @@ config MIPS_SEAD3
 	select CPU_MIPSR2_IRQ_EI
 	select DMA_NONCOHERENT
 	select IRQ_CPU
-	select IRQ_GIC
+	select MIPS_GIC
 	select LIBFDT
 	select MIPS_MSC
 	select SYS_HAS_CPU_MIPS32_R1
@@ -1069,10 +1069,6 @@ config IRQ_TXX9
 config IRQ_GT641XX
 	bool
 
-config IRQ_GIC
-	select MIPS_CM
-	bool
-
 config PCI_GT64XXX_PCI0
 	bool
 
@@ -1886,7 +1882,7 @@ config FORCE_MAX_ZONEORDER
 
 config CEVT_GIC
 	bool "Use GIC global counter for clock events"
-	depends on IRQ_GIC && !MIPS_SEAD3
+	depends on MIPS_GIC && !MIPS_SEAD3
 	help
 	  Use the GIC global counter for the clock events. The R4K clock
 	  event driver is always present, so if the platform ends up not
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 008a2fe..3982e51 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -68,7 +68,6 @@ obj-$(CONFIG_IRQ_CPU_RM7K)	+= irq-rm7000.o
 obj-$(CONFIG_MIPS_MSC)		+= irq-msc01.o
 obj-$(CONFIG_IRQ_TXX9)		+= irq_txx9.o
 obj-$(CONFIG_IRQ_GT641XX)	+= irq-gt641xx.o
-obj-$(CONFIG_IRQ_GIC)		+= irq-gic.o
 
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_32BIT)		+= scall32-o32.o
diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index bc127e2..5b8f8e3 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -85,7 +85,7 @@ void mips_event_handler(struct clock_event_device *dev)
  */
 static int c0_compare_int_pending(void)
 {
-#ifdef CONFIG_IRQ_GIC
+#ifdef CONFIG_MIPS_GIC
 	if (cpu_has_veic)
 		return gic_get_timer_pending();
 #endif
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index 21f23ad..d60475f 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -119,7 +119,7 @@ static void vsmp_send_ipi_single(int cpu, unsigned int action)
 	unsigned long flags;
 	int vpflags;
 
-#ifdef CONFIG_IRQ_GIC
+#ifdef CONFIG_MIPS_GIC
 	if (gic_present) {
 		gic_send_ipi_single(cpu, action);
 		return;
@@ -158,7 +158,7 @@ static void vsmp_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 
 static void vsmp_init_secondary(void)
 {
-#ifdef CONFIG_IRQ_GIC
+#ifdef CONFIG_MIPS_GIC
 	/* This is Malta specific: IPI,performance and timer interrupts */
 	if (gic_present)
 		change_c0_status(ST0_IM, STATUSF_IP3 | STATUSF_IP4 |
diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index a4e035c..17cfc8a 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -70,7 +70,7 @@ static void __init estimate_frequencies(void)
 {
 	unsigned long flags;
 	unsigned int count, start;
-#ifdef CONFIG_IRQ_GIC
+#ifdef CONFIG_MIPS_GIC
 	unsigned int giccount = 0, gicstart = 0;
 #endif
 
@@ -87,7 +87,7 @@ static void __init estimate_frequencies(void)
 
 	/* Initialize counters. */
 	start = read_c0_count();
-#ifdef CONFIG_IRQ_GIC
+#ifdef CONFIG_MIPS_GIC
 	if (gic_present)
 		GICREAD(GIC_REG(SHARED, GIC_SH_COUNTER_31_00), gicstart);
 #endif
@@ -97,7 +97,7 @@ static void __init estimate_frequencies(void)
 	while (!(CMOS_READ(RTC_REG_A) & RTC_UIP));
 
 	count = read_c0_count();
-#ifdef CONFIG_IRQ_GIC
+#ifdef CONFIG_MIPS_GIC
 	if (gic_present)
 		GICREAD(GIC_REG(SHARED, GIC_SH_COUNTER_31_00), giccount);
 #endif
@@ -107,7 +107,7 @@ static void __init estimate_frequencies(void)
 	count -= start;
 	mips_hpt_frequency = count;
 
-#ifdef CONFIG_IRQ_GIC
+#ifdef CONFIG_MIPS_GIC
 	if (gic_present) {
 		giccount -= gicstart;
 		gic_frequency = giccount;
@@ -189,7 +189,7 @@ void __init plat_time_init(void)
 	setup_pit_timer();
 #endif
 
-#ifdef CONFIG_IRQ_GIC
+#ifdef CONFIG_MIPS_GIC
 	if (gic_present) {
 		freq = freqround(gic_frequency, 5000);
 		printk("GIC frequency %d.%02d MHz\n", freq/1000000,
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b8632bf..ddacccf 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -113,3 +113,7 @@ config IRQ_CROSSBAR
 	  The primary irqchip invokes the crossbar's callback which inturn allocates
 	  a free irq and configures the IP. Thus the peripheral interrupts are
 	  routed to one of the free irqchip interrupt lines.
+
+config MIPS_GIC
+	bool
+	select MIPS_CM
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 73052ba..fd47e0d 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
 obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
 obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
 obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
+obj-$(CONFIG_MIPS_GIC)			+= irq-mips-gic.o
diff --git a/arch/mips/kernel/irq-gic.c b/drivers/irqchip/irq-mips-gic.c
similarity index 100%
rename from arch/mips/kernel/irq-gic.c
rename to drivers/irqchip/irq-mips-gic.c
-- 
2.1.0.rc2.206.gedb03e5

