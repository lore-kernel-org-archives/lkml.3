Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaJTTGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:06:38 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:57609 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaJTTEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:13 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/19] MIPS: Move GIC clocksource driver to drivers/clocksource/
Date: Mon, 20 Oct 2014 12:03:58 -0700
Message-Id: <1413831846-32100-12-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the GIC clocksource driver to drivers/clocksource/mips-gic-timer.c.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/Kconfig                                                 | 8 ++------
 arch/mips/kernel/Makefile                                         | 1 -
 arch/mips/mti-malta/malta-time.c                                  | 2 +-
 drivers/clocksource/Kconfig                                       | 4 ++++
 drivers/clocksource/Makefile                                      | 1 +
 .../kernel/csrc-gic.c => drivers/clocksource/mips-gic-timer.c     | 0
 drivers/irqchip/irq-mips-gic.c                                    | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)
 rename arch/mips/kernel/csrc-gic.c => drivers/clocksource/mips-gic-timer.c (100%)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 4195267..5b1d44b 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -315,7 +315,7 @@ config MIPS_MALTA
 	select BOOT_RAW
 	select CEVT_R4K
 	select CSRC_R4K
-	select CSRC_GIC
+	select CLKSRC_MIPS_GIC
 	select DMA_MAYBE_COHERENT
 	select GENERIC_ISA_DMA
 	select HAVE_PCSPKR_PLATFORM
@@ -357,7 +357,7 @@ config MIPS_SEAD3
 	select BUILTIN_DTB
 	select CEVT_R4K
 	select CSRC_R4K
-	select CSRC_GIC
+	select CLKSRC_MIPS_GIC
 	select CPU_MIPSR2_IRQ_VI
 	select CPU_MIPSR2_IRQ_EI
 	select DMA_NONCOHERENT
@@ -926,10 +926,6 @@ config CSRC_IOASIC
 config CSRC_R4K
 	bool
 
-config CSRC_GIC
-	select MIPS_CM
-	bool
-
 config CSRC_SB1250
 	bool
 
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 3982e51..3d1ea51 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -23,7 +23,6 @@ obj-$(CONFIG_CEVT_GT641XX)	+= cevt-gt641xx.o
 obj-$(CONFIG_CEVT_SB1250)	+= cevt-sb1250.o
 obj-$(CONFIG_CEVT_TXX9)		+= cevt-txx9.o
 obj-$(CONFIG_CSRC_BCM1480)	+= csrc-bcm1480.o
-obj-$(CONFIG_CSRC_GIC)		+= csrc-gic.o
 obj-$(CONFIG_CSRC_IOASIC)	+= csrc-ioasic.o
 obj-$(CONFIG_CSRC_R4K)		+= csrc-r4k.o
 obj-$(CONFIG_CSRC_SB1250)	+= csrc-sb1250.o
diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index 608655f..028fae0 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -183,7 +183,7 @@ void __init plat_time_init(void)
 		freq = freqround(gic_frequency, 5000);
 		printk("GIC frequency %d.%02d MHz\n", freq/1000000,
 		       (freq%1000000)*100/1000000);
-#ifdef CONFIG_CSRC_GIC
+#ifdef CONFIG_CLKSRC_MIPS_GIC
 		gic_clocksource_init(gic_frequency);
 #endif
 	}
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 9042060..cb7e7f4 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -223,4 +223,8 @@ config CLKSRC_VERSATILE
 	  ARM Versatile, RealView and Versatile Express reference
 	  platforms.
 
+config CLKSRC_MIPS_GIC
+	bool
+	depends on MIPS_GIC
+
 endmenu
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 756f6f1..e23fc2d 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -46,3 +46,4 @@ obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
 obj-$(CONFIG_ARCH_KEYSTONE)		+= timer-keystone.o
 obj-$(CONFIG_CLKSRC_VERSATILE)		+= versatile.o
+obj-$(CONFIG_CLKSRC_MIPS_GIC)		+= mips-gic-timer.o
diff --git a/arch/mips/kernel/csrc-gic.c b/drivers/clocksource/mips-gic-timer.c
similarity index 100%
rename from arch/mips/kernel/csrc-gic.c
rename to drivers/clocksource/mips-gic-timer.c
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 165cf1e..99687ed 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -103,7 +103,7 @@ static inline void gic_map_to_vpe(unsigned int intr, unsigned int vpe)
 		  GIC_SH_MAP_TO_VPE_REG_BIT(vpe));
 }
 
-#if defined(CONFIG_CSRC_GIC) || defined(CONFIG_CEVT_GIC)
+#if defined(CONFIG_CLKSRC_MIPS_GIC) || defined(CONFIG_CEVT_GIC)
 cycle_t gic_read_count(void)
 {
 	unsigned int hi, hi2, lo;
-- 
2.1.0.rc2.206.gedb03e5

