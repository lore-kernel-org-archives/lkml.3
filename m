Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaAWGei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:34:38 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:53830 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaAWGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:34:37 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jan 2014 01:34:36 EST
From: Tony Prisk <linux@prisktech.co.nz>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] arm: vt8500: Fix gpio mux setup in vt8500_init()
Date: Thu, 23 Jan 2014 19:28:47 +1300
Message-Id: <1390458527-30068-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the switch to a pinctrl driver, and the dropping of the gpio driver,
the code in vt8500_init now always fails, and drops back to LEGACY mode.

Update the gpio mux init code, and removing the #ifdef's and the LEGACY
mode fallback.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/mach-vt8500/vt8500.c |   91 ++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 61 deletions(-)

diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index 4a73464..fe5243e 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -32,9 +32,6 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
-#define LEGACY_GPIO_BASE	0xD8110000
-#define LEGACY_PMC_BASE		0xD8130000
-
 /* Registers in GPIO Controller */
 #define VT8500_GPIO_MUX_REG	0x200
 
@@ -75,89 +72,61 @@ static void vt8500_power_off(void)
 void __init vt8500_init(void)
 {
 	struct device_node *np;
-#if defined(CONFIG_FB_VT8500) || defined(CONFIG_FB_WM8505)
 	struct device_node *fb;
-	void __iomem *gpio_base;
-#endif
+	void __iomem *base;
 
-#ifdef CONFIG_FB_VT8500
 	fb = of_find_compatible_node(NULL, NULL, "via,vt8500-fb");
 	if (fb) {
-		np = of_find_compatible_node(NULL, NULL, "via,vt8500-gpio");
-		if (np) {
-			gpio_base = of_iomap(np, 0);
-
-			if (!gpio_base)
-				pr_err("%s: of_iomap(gpio_mux) failed\n",
-								__func__);
+		np = of_find_compatible_node(NULL, NULL, "via,vt8500-pinctrl");
+		if (!np) {
+			pr_err("pinctrl node required for framebuffer\n");
+			BUG();
+		}
 
-			of_node_put(np);
+		base = of_iomap(np, 0);
+		if (base) {
+			writel(readl(base + VT8500_GPIO_MUX_REG) | 1,
+			       base + VT8500_GPIO_MUX_REG);
+			iounmap(base);
 		} else {
-			gpio_base = ioremap(LEGACY_GPIO_BASE, 0x1000);
-			if (!gpio_base)
-				pr_err("%s: ioremap(legacy_gpio_mux) failed\n",
-								__func__);
+			pr_err("%s: of_iomap(gpio_mux) failed\n", __func__);
 		}
-		if (gpio_base) {
-			writel(readl(gpio_base + VT8500_GPIO_MUX_REG) | 1,
-				gpio_base + VT8500_GPIO_MUX_REG);
-			iounmap(gpio_base);
-		} else
-			pr_err("%s: Could not remap GPIO mux\n", __func__);
 
+		of_node_put(np);
 		of_node_put(fb);
 	}
-#endif
 
-#ifdef CONFIG_FB_WM8505
 	fb = of_find_compatible_node(NULL, NULL, "wm,wm8505-fb");
 	if (fb) {
-		np = of_find_compatible_node(NULL, NULL, "wm,wm8505-gpio");
-		if (!np)
-			np = of_find_compatible_node(NULL, NULL,
-							"wm,wm8650-gpio");
-		if (np) {
-			gpio_base = of_iomap(np, 0);
-
-			if (!gpio_base)
-				pr_err("%s: of_iomap(gpio_mux) failed\n",
-								__func__);
-
-			of_node_put(np);
+		np = of_find_compatible_node(NULL, NULL, "wm,prizm-pinctrl");
+		if (!np) {
+			pr_err("pinctrl node required for framebuffer\n");
+			BUG();
+		}
+
+		base = of_iomap(np, 0);
+		if (base) {
+			writel(readl(base + VT8500_GPIO_MUX_REG) |
+			       0x80000000, base + VT8500_GPIO_MUX_REG);
+			iounmap(base);
 		} else {
-			gpio_base = ioremap(LEGACY_GPIO_BASE, 0x1000);
-			if (!gpio_base)
-				pr_err("%s: ioremap(legacy_gpio_mux) failed\n",
-								__func__);
+			pr_err("%s: of_iomap(gpio_mux) failed\n", __func__);
 		}
-		if (gpio_base) {
-			writel(readl(gpio_base + VT8500_GPIO_MUX_REG) |
-				0x80000000, gpio_base + VT8500_GPIO_MUX_REG);
-			iounmap(gpio_base);
-		} else
-			pr_err("%s: Could not remap GPIO mux\n", __func__);
 
+		of_node_put(np);
 		of_node_put(fb);
 	}
-#endif
 
 	np = of_find_compatible_node(NULL, NULL, "via,vt8500-pmc");
 	if (np) {
 		pmc_base = of_iomap(np, 0);
-
-		if (!pmc_base)
-			pr_err("%s:of_iomap(pmc) failed\n", __func__);
+		if (pmc_base)
+			pm_power_off = &vt8500_power_off;
+		else
+			pr_err("%s: of_iomap(pmc) failed\n", __func__);
 
 		of_node_put(np);
-	} else {
-		pmc_base = ioremap(LEGACY_PMC_BASE, 0x1000);
-		if (!pmc_base)
-			pr_err("%s:ioremap(power_off) failed\n", __func__);
 	}
-	if (pmc_base)
-		pm_power_off = &vt8500_power_off;
-	else
-		pr_err("%s: PMC Hibernation register could not be remapped, not enabling power off!\n", __func__);
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
-- 
1.7.9.5

