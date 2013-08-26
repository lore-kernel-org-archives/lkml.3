Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3HZLA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:00:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47072 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3HZLA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:00:26 -0400
Message-ID: <521B343D.8060900@ti.com>
Date: Mon, 26 Aug 2013 16:25:57 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH v3 3/7] ARM: davinci: da8xx: support gpio platform device
References: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com> <1376803143-13738-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1376803143-13738-4-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 August 2013 10:48 AM, Lad, Prabhakar wrote:
> From: KV Sujith <sujithkv@ti.com>
> 
> DaVinci GPIO driver now uses platform device model.
> Convert DA8XX SoC code to use the new model.
> 
> - Add Memory and IRQ resources for da8xx
> - Add da8xx_register_gpio API to create platform device for da8xx
>   platforms.
> - Removed unused GPIO initialization in davinci_soc_info structure
> 
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> [nsekhar@ti.com: simplify commit message]
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Parts of 5/7 which touch SoC specific portion can be merged into this 
patch. I did that for you and here is the result.

Thanks,
Sekhar

>From 50db0a98a3076a667d85b4009eb3f029a2f51d14 Mon Sep 17 00:00:00 2001
From: KV Sujith <sujithkv@ti.com>
Date: Sun, 18 Aug 2013 10:48:59 +0530
Subject: [PATCH] ARM: davinci: da8xx: support gpio platform device

DaVinci GPIO driver now uses platform device model.
Convert DA8XX SoC code to use the new model.

Add da8xx_register_gpio() to create platform device for da8xx
platforms.

While at it, reorder include files in alphabetical order.
This will eventually help avoid duplicate include files.

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
[nsekhar@ti.com: simplify commit message]
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/da830.c              |   25 ++++++++++++++--------
 arch/arm/mach-davinci/da850.c              |   31 +++++++++++++++++-----------
 arch/arm/mach-davinci/devices-da8xx.c      |   26 +++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |   23 ++++++++++++---------
 4 files changed, 74 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index d6c746e..73c094d 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -8,19 +8,20 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
+#include <linux/clk.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
-#include <linux/clk.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include <asm/mach/map.h>
 
-#include <mach/psc.h>
-#include <mach/irqs.h>
-#include <mach/cputype.h>
 #include <mach/common.h>
-#include <mach/time.h>
+#include <mach/cputype.h>
 #include <mach/da8xx.h>
 #include <mach/gpio-davinci.h>
+#include <mach/irqs.h>
+#include <mach/psc.h>
+#include <mach/time.h>
 
 #include "clock.h"
 #include "mux.h"
@@ -1151,6 +1152,16 @@ static struct davinci_id da830_ids[] = {
 	},
 };
 
+static struct davinci_gpio_platform_data da830_gpio_platform_data = {
+	.ngpio = 128,
+	.intc_irq_num = DA830_N_CP_INTC_IRQ,
+};
+
+int __init da830_register_gpio(void)
+{
+	return da8xx_register_gpio(&da830_gpio_platform_data);
+}
+
 static struct davinci_timer_instance da830_timer_instance[2] = {
 	{
 		.base		= DA8XX_TIMER64P0_BASE,
@@ -1196,10 +1207,6 @@ static struct davinci_soc_info davinci_soc_info_da830 = {
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
index f56e5fb..bcabb1e 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -11,24 +11,25 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
-#include <linux/clk.h>
+#include <linux/platform_data/gpio-davinci.h>
 #include <linux/platform_device.h>
-#include <linux/cpufreq.h>
 #include <linux/regulator/consumer.h>
 
 #include <asm/mach/map.h>
 
-#include <mach/psc.h>
-#include <mach/irqs.h>
-#include <mach/cputype.h>
 #include <mach/common.h>
-#include <mach/time.h>
-#include <mach/da8xx.h>
 #include <mach/cpufreq.h>
-#include <mach/pm.h>
+#include <mach/cputype.h>
+#include <mach/da8xx.h>
 #include <mach/gpio-davinci.h>
+#include <mach/irqs.h>
+#include <mach/pm.h>
+#include <mach/psc.h>
+#include <mach/time.h>
 
 #include "clock.h"
 #include "mux.h"
@@ -1281,6 +1282,16 @@ int __init da850_register_vpif_capture(struct vpif_capture_config
 	return platform_device_register(&da850_vpif_capture_dev);
 }
 
+static struct davinci_gpio_platform_data da850_gpio_platform_data = {
+	.ngpio = 144,
+	.intc_irq_num = DA850_N_CP_INTC_IRQ,
+};
+
+int __init da850_register_gpio(void)
+{
+	return da8xx_register_gpio(&da850_gpio_platform_data);
+}
+
 static struct davinci_soc_info davinci_soc_info_da850 = {
 	.io_desc		= da850_io_desc,
 	.io_desc_num		= ARRAY_SIZE(da850_io_desc),
@@ -1298,10 +1309,6 @@ static struct davinci_soc_info davinci_soc_info_da850 = {
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
index 2e473fe..c46eccb 100644
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
index aae5307..8642150 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -11,26 +11,26 @@
 #ifndef __ASM_ARCH_DAVINCI_DA8XX_H
 #define __ASM_ARCH_DAVINCI_DA8XX_H
 
-#include <video/da8xx-fb.h>
-
-#include <linux/platform_device.h>
 #include <linux/davinci_emac.h>
-#include <linux/spi/spi.h>
 #include <linux/platform_data/davinci_asp.h>
-#include <linux/reboot.h>
-#include <linux/videodev2.h>
-
-#include <mach/serial.h>
-#include <mach/pm.h>
 #include <linux/platform_data/edma.h>
 #include <linux/platform_data/i2c-davinci.h>
 #include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/usb-davinci.h>
 #include <linux/platform_data/spi-davinci.h>
 #include <linux/platform_data/uio_pruss.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+#include <linux/spi/spi.h>
+#include <linux/videodev2.h>
+
+#include <mach/pm.h>
+#include <mach/serial.h>
 
 #include <media/davinci/vpif_types.h>
 
+#include <video/da8xx-fb.h>
+
 extern void __iomem *da8xx_syscfg0_base;
 extern void __iomem *da8xx_syscfg1_base;
 
@@ -97,6 +97,7 @@ int da8xx_register_mmcsd0(struct davinci_mmc_config *config);
 int da850_register_mmcsd1(struct davinci_mmc_config *config);
 void da8xx_register_mcasp(int id, struct snd_platform_data *pdata);
 int da8xx_register_rtc(void);
+int da8xx_register_gpio(void *pdata);
 int da850_register_cpufreq(char *async_clk);
 int da8xx_register_cpuidle(void);
 void __iomem *da8xx_get_mem_ctlr(void);
@@ -110,6 +111,8 @@ int da850_register_vpif_capture
 void da8xx_restart(enum reboot_mode mode, const char *cmd);
 void da8xx_rproc_reserve_cma(void);
 int da8xx_register_rproc(void);
+int da850_register_gpio(void);
+int da830_register_gpio(void);
 
 extern struct platform_device da8xx_serial_device[];
 extern struct emac_platform_data da8xx_emac_pdata;
-- 
1.7.10.1



