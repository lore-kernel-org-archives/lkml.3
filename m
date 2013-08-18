Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3HRFUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 01:20:32 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55816 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3HRFUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 01:20:30 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kevin Hilman <khilman@linaro.org>, KV Sujith <sujithkv@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 3/7] ARM: davinci: da8xx: support gpio platform device
Date: Sun, 18 Aug 2013 10:48:59 +0530
Message-Id: <1376803143-13738-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

DaVinci GPIO driver now uses platform device model.
Convert DA8XX SoC code to use the new model.

- Add Memory and IRQ resources for da8xx
- Add da8xx_register_gpio API to create platform device for da8xx
  platforms.
- Removed unused GPIO initialization in davinci_soc_info structure

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
[nsekhar@ti.com: simplify commit message]
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/da830.c              |    4 ----
 arch/arm/mach-davinci/da850.c              |    4 ----
 arch/arm/mach-davinci/devices-da8xx.c      |   26 ++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index d6c746e..9ef1b67 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -1196,10 +1196,6 @@ static struct davinci_soc_info davinci_soc_info_da830 = {
 	.intc_irq_prios		= da830_default_priorities,
 	.intc_irq_num		= DA830_N_CP_INTC_IRQ,
 	.timer_info		= &da830_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DA8XX_GPIO_BASE,
-	.gpio_num		= 128,
-	.gpio_irq		= IRQ_DA8XX_GPIO0,
 	.emac_pdata		= &da8xx_emac_pdata,
 };
 
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index f56e5fb..887af90 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -1298,10 +1298,6 @@ static struct davinci_soc_info davinci_soc_info_da850 = {
 	.intc_irq_prios		= da850_default_priorities,
 	.intc_irq_num		= DA850_N_CP_INTC_IRQ,
 	.timer_info		= &da850_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DA8XX_GPIO_BASE,
-	.gpio_num		= 144,
-	.gpio_irq		= IRQ_DA8XX_GPIO0,
 	.emac_pdata		= &da8xx_emac_pdata,
 	.sram_dma		= DA8XX_SHARED_RAM_BASE,
 	.sram_len		= SZ_128K,
diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index a408b30..242fbd4 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -665,6 +665,32 @@ int __init da8xx_register_lcdc(struct da8xx_lcdc_platform_data *pdata)
 	return platform_device_register(&da8xx_lcdc_device);
 }
 
+static struct resource da8xx_gpio_resources[] = {
+	{ /* registers */
+		.start	= DA8XX_GPIO_BASE,
+		.end	= DA8XX_GPIO_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{ /* interrupt */
+		.start	= IRQ_DA8XX_GPIO0,
+		.end	= IRQ_DA8XX_GPIO8,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device da8xx_gpio_device = {
+	.name		= "davinci_gpio",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(da8xx_gpio_resources),
+	.resource	= da8xx_gpio_resources,
+};
+
+int __init da8xx_register_gpio(void *pdata)
+{
+	da8xx_gpio_device.dev.platform_data = pdata;
+	return platform_device_register(&da8xx_gpio_device);
+}
+
 static struct resource da8xx_mmcsd0_resources[] = {
 	{		/* registers */
 		.start	= DA8XX_MMCSD0_BASE,
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index aae5307..a96da92 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -97,6 +97,7 @@ int da8xx_register_mmcsd0(struct davinci_mmc_config *config);
 int da850_register_mmcsd1(struct davinci_mmc_config *config);
 void da8xx_register_mcasp(int id, struct snd_platform_data *pdata);
 int da8xx_register_rtc(void);
+int da8xx_register_gpio(void *pdata);
 int da850_register_cpufreq(char *async_clk);
 int da8xx_register_cpuidle(void);
 void __iomem *da8xx_get_mem_ctlr(void);
-- 
1.7.9.5

