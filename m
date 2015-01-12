Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbbALVYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:24:18 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58015 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751008AbbALVYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:24:11 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/6] ARM: at91: pm: use the mmio-sram pool to access SRAM
Date: Mon, 12 Jan 2015 22:23:41 +0100
Message-Id: <1421097825-396-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the SRAM is part of a genpool, use it to allocate memory to use for the
slowclock implementation.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig |  1 +
 arch/arm/mach-at91/pm.c    | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index cec0fb5d621a..b7dcef50db23 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -178,6 +178,7 @@ comment "AT91 Feature Selections"
 
 config AT91_SLOW_CLOCK
 	bool "Suspend-to-RAM disables main oscillator"
+	select SRAM
 	depends on SUSPEND
 	help
 	  Select this if you want Suspend-to-RAM to save the most power
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 79aa793d1f00..515791edcc60 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -14,10 +14,12 @@
 #include <linux/suspend.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
+#include <linux/genalloc.h>
 #include <linux/interrupt.h>
 #include <linux/sysfs.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/clk/at91_pmc.h>
@@ -222,10 +224,52 @@ void at91_pm_set_standby(void (*at91_standby)(void))
 	}
 }
 
+#ifdef CONFIG_AT91_SLOW_CLOCK
+static void __init at91_pm_sram_init(void)
+{
+	struct gen_pool *sram_pool;
+	phys_addr_t sram_pbase;
+	unsigned long sram_base;
+	struct device_node *node;
+	struct platform_device *pdev;
+
+	node = of_find_compatible_node(NULL, NULL, "mmio-sram");
+	if (!node) {
+		pr_warn("%s: failed to find sram node!\n", __func__);
+		return;
+	}
+
+	pdev = of_find_device_by_node(node);
+	if (!pdev) {
+		pr_warn("%s: failed to find sram device!\n", __func__);
+		goto put_node;
+	}
+
+	sram_pool = dev_get_gen_pool(&pdev->dev);
+	if (!sram_pool) {
+		pr_warn("%s: sram pool unavailable!\n", __func__);
+		goto put_node;
+	}
+
+	sram_base = gen_pool_alloc(sram_pool, at91_slow_clock_sz);
+	if (!sram_base) {
+		pr_warn("%s: unable to alloc ocram!\n", __func__);
+		goto put_node;
+	}
+
+	sram_pbase = gen_pool_virt_to_phys(sram_pool, sram_base);
+	slow_clock = __arm_ioremap_exec(sram_pbase, at91_slow_clock_sz, false);
+
+put_node:
+	of_node_put(node);
+}
+#endif
+
+
 static int __init at91_pm_init(void)
 {
 #ifdef CONFIG_AT91_SLOW_CLOCK
-	slow_clock = (void *) (AT91_IO_VIRT_BASE - at91_slow_clock_sz);
+	at91_pm_sram_init();
 #endif
 
 	pr_info("AT91: Power Management%s\n", (slow_clock ? " (with slow clock mode)" : ""));
-- 
2.1.0

