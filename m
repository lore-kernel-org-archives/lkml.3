Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaEWPp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:45:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50453 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbaEWPpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:45:13 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <lee.jones@linaro.org>,
        <santosh.shilimkar@ti.com>, <arnd@arndb.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <mturquette@linaro.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v7 5/7] ARM: keystone: remove redundant reset stuff
Date: Fri, 23 May 2014 18:43:30 +0300
Message-ID: <1400859812-5761-6-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400859812-5761-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400859812-5761-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove reset stuff in flavour of using keystone reset driver:
driver/power/reset/keystone-reset.c

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/mach-keystone/keystone.c | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/keystone.c
index 59b8383..1f9ae89 100644
--- a/arch/arm/mach-keystone/keystone.c
+++ b/arch/arm/mach-keystone/keystone.c
@@ -26,11 +26,6 @@
 
 #include "keystone.h"
 
-#define PLL_RESET_WRITE_KEY_MASK		0xffff0000
-#define PLL_RESET_WRITE_KEY			0x5a69
-#define PLL_RESET				BIT(16)
-
-static void __iomem *keystone_rstctrl;
 static struct notifier_block platform_nb;
 static unsigned long keystone_dma_pfn_offset __read_mostly;
 
@@ -55,16 +50,6 @@ static int keystone_platform_notifier(struct notifier_block *nb,
 
 static void __init keystone_init(void)
 {
-	struct device_node *node;
-
-	node = of_find_compatible_node(NULL, NULL, "ti,keystone-reset");
-	if (WARN_ON(!node))
-		pr_warn("ti,keystone-reset node undefined\n");
-
-	keystone_rstctrl = of_iomap(node, 0);
-	if (WARN_ON(!keystone_rstctrl))
-		pr_warn("ti,keystone-reset iomap error\n");
-
 	keystone_pm_runtime_init();
 	if (platform_nb.notifier_call)
 		bus_register_notifier(&platform_bus_type, &platform_nb);
@@ -123,24 +108,6 @@ static const char *keystone_match[] __initconst = {
 	NULL,
 };
 
-void keystone_restart(enum reboot_mode mode, const char *cmd)
-{
-	u32 val;
-
-	BUG_ON(!keystone_rstctrl);
-
-	/* Enable write access to RSTCTRL */
-	val = readl(keystone_rstctrl);
-	val &= PLL_RESET_WRITE_KEY_MASK;
-	val |= PLL_RESET_WRITE_KEY;
-	writel(val, keystone_rstctrl);
-
-	/* Reset the SOC */
-	val = readl(keystone_rstctrl);
-	val &= ~PLL_RESET;
-	writel(val, keystone_rstctrl);
-}
-
 DT_MACHINE_START(KEYSTONE, "Keystone")
 #if defined(CONFIG_ZONE_DMA) && defined(CONFIG_ARM_LPAE)
 	.dma_zone_size	= SZ_2G,
@@ -148,6 +115,5 @@ DT_MACHINE_START(KEYSTONE, "Keystone")
 	.smp		= smp_ops(keystone_smp_ops),
 	.init_machine	= keystone_init,
 	.dt_compat	= keystone_match,
-	.restart	= keystone_restart,
 	.init_meminfo   = keystone_init_meminfo,
 MACHINE_END
-- 
1.8.3.2

