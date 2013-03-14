Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3CNKyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:54:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52896 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111Ab3CNKhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:33 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 2/3] ARM: davinci: da850: Enable EHRPWM TBCLK from CFG_CHIP1
Date: Thu, 14 Mar 2013 16:07:32 +0530
Message-ID: <1363257453-24747-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363257453-24747-1-git-send-email-avinashphilip@ti.com>
References: <1363257453-24747-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da850 platforms require TBCLK synchronization in CFG_CHIP1 register for
TBCLK enable in EHRPWM modules. Enabling of TBCLK is done only if EHRPWM
DT node status is set to "okay" DT blob.
Also adds macro definitions for DA8XX_EHRPWM_TBCLKSYNC and
DA8XX_CFGCHIP1_REG.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
:100644 100644 6b7a0a2... 72466ab... M	arch/arm/mach-davinci/da8xx-dt.c
:100644 100644 de439b7... be77ce2... M	arch/arm/mach-davinci/include/mach/da8xx.h
 arch/arm/mach-davinci/da8xx-dt.c           |   15 +++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
 2 files changed, 16 insertions(+)

diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index 6b7a0a2..72466ab 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -19,6 +19,7 @@
 #include <mach/da8xx.h>
 
 #define DA8XX_NUM_UARTS	3
+#define DA8XX_EHRPWM_TBCLKSYNC	BIT(12)
 
 void __init da8xx_uart_clk_enable(void)
 {
@@ -47,10 +48,24 @@ struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
 
 static void __init da850_init_machine(void)
 {
+	struct device_node *ehrpwm_np;
+	const char *ehrpwm_compat = "ti,da850-ehrpwm";
+	void __iomem *cfg_chip1_base;
+
+	cfg_chip1_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP1_REG);
+
 	of_platform_populate(NULL, of_default_bus_match_table,
 			     da850_auxdata_lookup, NULL);
 
 	da8xx_uart_clk_enable();
+
+	for_each_compatible_node(ehrpwm_np, NULL, ehrpwm_compat)
+		if (of_device_is_available(ehrpwm_np)) {
+			/* Enable TBCLK synchronization for EHRWPM modules */
+			writel(readl(cfg_chip1_base) | DA8XX_EHRPWM_TBCLKSYNC,
+					cfg_chip1_base);
+			break;
+		}
 }
 
 static const char *da850_boards_compat[] __initdata = {
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index de439b7..be77ce2 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -55,6 +55,7 @@ extern unsigned int da850_max_speed;
 #define DA8XX_SYSCFG0_VIRT(x)	(da8xx_syscfg0_base + (x))
 #define DA8XX_JTAG_ID_REG	0x18
 #define DA8XX_CFGCHIP0_REG	0x17c
+#define DA8XX_CFGCHIP1_REG	0x180
 #define DA8XX_CFGCHIP2_REG	0x184
 #define DA8XX_CFGCHIP3_REG	0x188
 
-- 
1.7.9.5

