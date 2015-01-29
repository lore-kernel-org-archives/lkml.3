Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbbA2GnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:43:07 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:48902 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbA2GnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:43:05 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH v5 07/13] pm: at91: remove the config item CONFIG_AT91_SLOW_CLOCK
Date: Thu, 29 Jan 2015 14:40:20 +0800
Message-ID: <1422513620-24846-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
References: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slow clock always exists, for the suspend to memory mode,
the master clock always switch to the slow clock.

To simplify the PM config, remove this config item, remove
the definition code as well.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig  |   13 -------------
 arch/arm/mach-at91/Makefile |    2 +-
 arch/arm/mach-at91/pm.c     |    9 ---------
 3 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 6b9e685..3a5e46a 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -120,19 +120,6 @@ endif # SOC_SAM_V4_V5
 
 comment "AT91 Feature Selections"
 
-config AT91_SLOW_CLOCK
-	bool "Suspend-to-RAM disables main oscillator"
-	depends on SUSPEND
-	help
-	  Select this if you want Suspend-to-RAM to save the most power
-	  possible (without powering off the CPU) by disabling the PLLs
-	  and main oscillator so that only the 32 KiHz clock is available.
-
-	  When only that slow-clock is available, some peripherals lose
-	  functionality.  Many can't issue wakeup events unless faster
-	  clocks are available.  Some lose their operating state and
-	  need to be completely re-initialized.
-
 config AT91_TIMER_HZ
        int "Kernel HZ (jiffies per second)"
        range 32 1024
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 827fdbc..103c256 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_SOC_SAMA5)		+= sama5.o
 
 # Power Management
 obj-$(CONFIG_PM)		+= pm.o
-obj-$(CONFIG_AT91_SLOW_CLOCK)	+= pm_slowclock.o
+obj-$(CONFIG_PM)		+= pm_slowclock.o
 
 ifeq ($(CONFIG_PM_DEBUG),y)
 CFLAGS_pm.o += -DDEBUG
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 6df0152..d2a64cc 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -135,11 +135,9 @@ EXPORT_SYMBOL(at91_suspend_entering_slow_clock);
 static void (*slow_clock)(void __iomem *pmc, void __iomem *ramc0,
 			  void __iomem *ramc1, int memctrl);
 
-#ifdef CONFIG_AT91_SLOW_CLOCK
 extern void at91_slow_clock(void __iomem *pmc, void __iomem *ramc0,
 			    void __iomem *ramc1, int memctrl);
 extern u32 at91_slow_clock_sz;
-#endif
 
 static int at91_pm_enter(suspend_state_t state)
 {
@@ -271,7 +269,6 @@ static void at91_dt_ramc(void)
 	at91_pm_set_standby(standby);
 }
 
-#ifdef CONFIG_AT91_SLOW_CLOCK
 static void __init at91_pm_sram_init(void)
 {
 	struct gen_pool *sram_pool;
@@ -313,16 +310,10 @@ static void __init at91_pm_sram_init(void)
 put_node:
 	of_node_put(node);
 }
-#endif
-
 
 static void __init at91_pm_init(void)
 {
-#ifdef CONFIG_AT91_SLOW_CLOCK
 	at91_pm_sram_init();
-#endif
-
-	pr_info("AT91: Power Management%s\n", (slow_clock ? " (with slow clock mode)" : ""));
 
 	if (at91_cpuidle_device.dev.platform_data)
 		platform_device_register(&at91_cpuidle_device);
-- 
1.7.9.5

