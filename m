Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3EVHKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:10:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45440 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3EVHKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:10:46 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, KV Sujith <sujithkv@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 04/11] ARM: davinci: da8xx: creation of gpio platform device
Date: Wed, 22 May 2013 12:40:27 +0530
Message-ID: <1369206634-6778-5-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

gpio controller resource information being associated with
davinci_soc_info structure and not created any device. Hence davinci
gpio didn't fall under proper device model. This patch creates gpio
davinci as a platform device for da8xx platforms.

- Add Memory and IRQ resources for DA8xx.
- Register GPIO platform driver for DA8xx.
- Add da8xx_register_gpio API to create platform device for da8xx
  platforms.

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/mach-davinci/devices-da8xx.c      |   26 ++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
 2 files changed, 27 insertions(+)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index bf57252..892ad86 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -640,6 +640,32 @@ int __init da8xx_register_lcdc(struct da8xx_lcdc_platform_data *pdata)
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
index 2e1c9ea..aa66690 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -96,6 +96,7 @@ int da8xx_register_mmcsd0(struct davinci_mmc_config *config);
 int da850_register_mmcsd1(struct davinci_mmc_config *config);
 void __init da8xx_register_mcasp(int id, struct snd_platform_data *pdata);
 int da8xx_register_rtc(void);
+int da8xx_register_gpio(void *pdata);
 int da850_register_cpufreq(char *async_clk);
 int da8xx_register_cpuidle(void);
 void __iomem * __init da8xx_get_mem_ctlr(void);
-- 
1.7.9.5

