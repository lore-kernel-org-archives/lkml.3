Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3K1Mjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:39:33 -0500
Received: from 7.mo6.mail-out.ovh.net ([46.105.59.196]:54354 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751712Ab3K1Mja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:39:30 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v6 02/16] ARM: at91: add Kconfig options for common clk support
Date: Thu, 28 Nov 2013 13:39:02 +0100
Message-Id: <1385642342-6646-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
References: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4141341334066657388
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the following Kconfig options to prepare the transition to
common clk framework:

- AT91_USE_OLD_CLK: this option is selected by every SoC which does not
  support new at91 clks based on common clk framework (SoC which does not
  define the clock tree in its device tree).
  This options is also selected when the user choose non dt boards support
  (new at91 clks can only be registered from a device tree definition).

- COMMON_CLK_AT91: this option cannot be selected directly. Instead it is
  enabled if these 3 conditions are met:
   * at least one of the selected SoCs have a PMC (Power Management
     Controller) Unit
   * device tree support is enabled
   * the old at91 clk implementation is disabled (every selected SoC define
     its clks in its device tree and non dt boards support is disabled)

- OLD_CLK_AT91: this option cannot be selected directly. Instead it is
  enabled if these 2 conditions are met:
   * at least one of the selected SoCs have a PMC (Power Management
     Controller) Unit
   * at least one of the selected SoCs does not define its clks in its
     device tree or non dt-boards support is enabled

This patch selects AT91_USE_OLD_CLK in all currently supported SoCs. These
selects will be removed after clk definitions are properly added in each
soc's device tree.
It also selects AT91_USE_OLD_CLK in all non-dt boards support.

AT91_PMC_UNIT references are replaced by OLD_CLK_AT91, because PMC Unit is
enabled for both old and common clk implementations, and old clk
implementation should not be compiled if COMMON_CLK is enabled.

To avoid future link errors, a new stub is created for at91_dt_clock_init
function if OLD_CLK_AT91 is disabled.

A new check is added in dt init functions (setup.c) to prepare for SoCs
supporting new clk implementation. These SoCs won't setup the
register_clocks callback (clk registration is done using of_clk_init).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig        |   21 +++++++++++++++++++++
 arch/arm/mach-at91/Kconfig.non_dt |    6 ++++++
 arch/arm/mach-at91/Makefile       |    2 +-
 arch/arm/mach-at91/generic.h      |    3 ++-
 arch/arm/mach-at91/setup.c        |    6 ++++--
 5 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 699b71e..85b53a4 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -6,10 +6,22 @@ config HAVE_AT91_DBGU0
 config HAVE_AT91_DBGU1
 	bool
 
+config AT91_USE_OLD_CLK
+	bool
+
 config AT91_PMC_UNIT
 	bool
 	default !ARCH_AT91X40
 
+config COMMON_CLK_AT91
+	bool
+	default AT91_PMC_UNIT && USE_OF && !AT91_USE_OLD_CLK
+	select COMMON_CLK
+
+config OLD_CLK_AT91
+	bool
+	default AT91_PMC_UNIT && AT91_USE_OLD_CLK
+
 config AT91_SAM9_ALT_RESET
 	bool
 	default !ARCH_AT91X40
@@ -65,6 +77,7 @@ config SOC_SAMA5D3
 	select SOC_SAMA5
 	select HAVE_FB_ATMEL
 	select HAVE_AT91_DBGU1
+	select AT91_USE_OLD_CLK
 	help
 	  Select this if you are using one of Atmel's SAMA5D3 family SoC.
 	  This support covers SAMA5D31, SAMA5D33, SAMA5D34, SAMA5D35.
@@ -78,11 +91,13 @@ config SOC_AT91RM9200
 	select HAVE_AT91_DBGU0
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
+	select AT91_USE_OLD_CLK
 
 config SOC_AT91SAM9260
 	bool "AT91SAM9260, AT91SAM9XE or AT91SAM9G20"
 	select HAVE_AT91_DBGU0
 	select SOC_AT91SAM9
+	select AT91_USE_OLD_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9260, AT91SAM9XE
 	  or AT91SAM9G20 SoC.
@@ -92,6 +107,7 @@ config SOC_AT91SAM9261
 	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select AT91_USE_OLD_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9261 or AT91SAM9G10 SoC.
 
@@ -100,18 +116,21 @@ config SOC_AT91SAM9263
 	select HAVE_AT91_DBGU1
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select AT91_USE_OLD_CLK
 
 config SOC_AT91SAM9RL
 	bool "AT91SAM9RL"
 	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select AT91_USE_OLD_CLK
 
 config SOC_AT91SAM9G45
 	bool "AT91SAM9G45 or AT91SAM9M10 families"
 	select HAVE_AT91_DBGU1
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select AT91_USE_OLD_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9G45 family SoC.
 	  This support covers AT91SAM9G45, AT91SAM9G46, AT91SAM9M10 and AT91SAM9M11.
@@ -121,6 +140,7 @@ config SOC_AT91SAM9X5
 	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select AT91_USE_OLD_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
 	  This means that your SAM9 name finishes with a '5' (except if it is
@@ -133,6 +153,7 @@ config SOC_AT91SAM9N12
 	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select AT91_USE_OLD_CLK
 	help
 	  Select this if you are using Atmel's AT91SAM9N12 SoC.
 
diff --git a/arch/arm/mach-at91/Kconfig.non_dt b/arch/arm/mach-at91/Kconfig.non_dt
index ca900be..b736b57 100644
--- a/arch/arm/mach-at91/Kconfig.non_dt
+++ b/arch/arm/mach-at91/Kconfig.non_dt
@@ -12,26 +12,32 @@ config ARCH_AT91_NONE
 config ARCH_AT91RM9200
 	bool "AT91RM9200"
 	select SOC_AT91RM9200
+	select AT91_USE_OLD_CLK
 
 config ARCH_AT91SAM9260
 	bool "AT91SAM9260 or AT91SAM9XE or AT91SAM9G20"
 	select SOC_AT91SAM9260
+	select AT91_USE_OLD_CLK
 
 config ARCH_AT91SAM9261
 	bool "AT91SAM9261 or AT91SAM9G10"
 	select SOC_AT91SAM9261
+	select AT91_USE_OLD_CLK
 
 config ARCH_AT91SAM9263
 	bool "AT91SAM9263"
 	select SOC_AT91SAM9263
+	select AT91_USE_OLD_CLK
 
 config ARCH_AT91SAM9RL
 	bool "AT91SAM9RL"
 	select SOC_AT91SAM9RL
+	select AT91_USE_OLD_CLK
 
 config ARCH_AT91SAM9G45
 	bool "AT91SAM9G45"
 	select SOC_AT91SAM9G45
+	select AT91_USE_OLD_CLK
 
 config ARCH_AT91X40
 	bool "AT91x40"
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 3b0a953..8539411 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -7,7 +7,7 @@ obj-m		:=
 obj-n		:=
 obj-		:=
 
-obj-$(CONFIG_AT91_PMC_UNIT)	+= clock.o
+obj-$(CONFIG_OLD_CLK_AT91)	+= clock.o
 obj-$(CONFIG_AT91_SAM9_ALT_RESET) += at91sam9_alt_reset.o
 obj-$(CONFIG_AT91_SAM9G45_RESET) += at91sam9g45_reset.o
 obj-$(CONFIG_AT91_SAM9_TIME)	+= at91sam926x_time.o
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index dc6e2f5..375c42e 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -44,11 +44,12 @@ extern void at91sam926x_pit_init(void);
 extern void at91x40_timer_init(void);
 
  /* Clocks */
-#ifdef CONFIG_AT91_PMC_UNIT
+#ifdef CONFIG_OLD_CLK_AT91
 extern int __init at91_clock_init(unsigned long main_clock);
 extern int __init at91_dt_clock_init(void);
 #else
 static int inline at91_clock_init(unsigned long main_clock) { return 0; }
+static int inline at91_dt_clock_init(void) { return 0; }
 #endif
 struct device;
 
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 41aa68b..06052fc 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -483,7 +483,8 @@ void __init at91rm9200_dt_initialize(void)
 	at91_dt_clock_init();
 
 	/* Register the processor-specific clocks */
-	at91_boot_soc.register_clocks();
+	if (at91_boot_soc.register_clocks)
+		at91_boot_soc.register_clocks();
 
 	at91_boot_soc.init();
 }
@@ -498,7 +499,8 @@ void __init at91_dt_initialize(void)
 	at91_dt_clock_init();
 
 	/* Register the processor-specific clocks */
-	at91_boot_soc.register_clocks();
+	if (at91_boot_soc.register_clocks)
+		at91_boot_soc.register_clocks();
 
 	if (at91_boot_soc.init)
 		at91_boot_soc.init();
-- 
1.7.9.5

