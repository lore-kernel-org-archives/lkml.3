Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3CYHtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:49:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55893 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab3CYHtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:49:40 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <jacmet@sunsite.dk>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v3 2/3] arm: davinci: clock node support for ECAP & EHRPWM
Date: Mon, 25 Mar 2013 13:19:48 +0530
Message-ID: <1364197789-16783-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364197789-16783-1-git-send-email-avinashphilip@ti.com>
References: <1364197789-16783-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock node support for ECAP and EHRPWM modules.
Also adds TBCLK for EHRWPM TBCLK to comply with pwm-tiehrpwm
driver.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
Changes Since v2:
	- Add prefix of ehrpwm to tblck_enable and tblck_disable functions
	- Make functions as static.

Changes Since v1:
	- TBCLK make it as actual clock with enable/disable feature.

 arch/arm/mach-davinci/da850.c              |   46 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
 2 files changed, 47 insertions(+)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 0c4a26d..2a2f60c 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -383,6 +383,49 @@ static struct clk dsp_clk = {
 	.flags		= PSC_LRST | PSC_FORCE,
 };
 
+static struct clk ehrpwm_clk = {
+	.name		= "ehrpwm",
+	.parent		= &pll0_sysclk2,
+	.lpsc		= DA8XX_LPSC1_PWM,
+	.gpsc		= 1,
+	.flags		= DA850_CLK_ASYNC3,
+};
+
+#define DA8XX_EHRPWM_TBCLKSYNC	BIT(12)
+
+static void ehrpwm_tblck_enable(struct clk *clk)
+{
+	u32 val;
+
+	val = readl(DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP1_REG));
+	val |= DA8XX_EHRPWM_TBCLKSYNC;
+	writel(val, DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP1_REG));
+}
+
+static void ehrpwm_tblck_disable(struct clk *clk)
+{
+	u32 val;
+
+	val = readl(DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP1_REG));
+	val &= ~DA8XX_EHRPWM_TBCLKSYNC;
+	writel(val, DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP1_REG));
+}
+
+static struct clk ehrpwm_tbclk = {
+	.name		= "ehrpwm_tbclk",
+	.parent		= &ehrpwm_clk,
+	.clk_enable	= ehrpwm_tblck_enable,
+	.clk_disable	= ehrpwm_tblck_disable,
+};
+
+static struct clk ecap_clk = {
+	.name		= "ecap",
+	.parent		= &pll0_sysclk2,
+	.lpsc		= DA8XX_LPSC1_ECAP,
+	.gpsc		= 1,
+	.flags		= DA850_CLK_ASYNC3,
+};
+
 static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"ref",		&ref_clk),
 	CLK(NULL,		"pll0",		&pll0_clk),
@@ -430,6 +473,9 @@ static struct clk_lookup da850_clks[] = {
 	CLK("vpif",		NULL,		&vpif_clk),
 	CLK("ahci",		NULL,		&sata_clk),
 	CLK("davinci-rproc.0",	NULL,		&dsp_clk),
+	CLK("ehrpwm",		"fck",		&ehrpwm_clk),
+	CLK("ehrpwm",		"tbclk",	&ehrpwm_tbclk),
+	CLK("ecap",		"fck",		&ecap_clk),
 	CLK(NULL,		NULL,		NULL),
 };
 
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

