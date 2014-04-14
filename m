Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaDNRnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:43:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38819 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbaDNRm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:42:56 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <ivan.khoronzhuk@ti.com>, <grygorii.strashko@ti.com>, <olof@lixom.net>,
        <w-kwok2@ti.com>, <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 3/5] ARM: keystone: remove redundant reset stuff
Date: Mon, 14 Apr 2014 20:41:21 +0300
Message-ID: <1397497283-16391-4-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397497283-16391-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1397497283-16391-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove reset stuff in flavour of using keystone reset driver:
driver/power/reset/keystone-reset.c

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/mach-keystone/keystone.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/keystone.c
index e0b9e1b..c96e2a4 100644
--- a/arch/arm/mach-keystone/keystone.c
+++ b/arch/arm/mach-keystone/keystone.c
@@ -23,24 +23,8 @@
 
 #include "keystone.h"
 
-#define PLL_RESET_WRITE_KEY_MASK		0xffff0000
-#define PLL_RESET_WRITE_KEY			0x5a69
-#define PLL_RESET				BIT(16)
-
-static void __iomem *keystone_rstctrl;
-
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
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
@@ -50,24 +34,6 @@ static const char *keystone_match[] __initconst = {
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
@@ -75,5 +41,4 @@ DT_MACHINE_START(KEYSTONE, "Keystone")
 	.smp		= smp_ops(keystone_smp_ops),
 	.init_machine	= keystone_init,
 	.dt_compat	= keystone_match,
-	.restart	= keystone_restart,
 MACHINE_END
-- 
1.8.3.2

