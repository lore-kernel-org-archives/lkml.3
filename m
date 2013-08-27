Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3H0Thr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:37:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33647 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3H0Thq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:37:46 -0400
Message-ID: <521CFFEA.7050200@ti.com>
Date: Wed, 28 Aug 2013 01:07:14 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH v3 4/7] ARM: davinci: devices.c: support gpio platform
 device
References: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com> <1376803143-13738-5-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1376803143-13738-5-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/2013 10:49 AM, Lad, Prabhakar wrote:
> From: Philip Avinash <avinashphilip@ti.com>
> 
> DaVinci GPIO driver now uses platform device model.
> Add a GPIO platform register API to convert the
> traditional DaVinci  SoCs to use the new model.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> [nsekhar@ti.com: move function declaration to local header,
> simplify commit message]
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Similar to what was done for the DA8XX part, the SoC specific parts 
from 6/7 can be merged into this. This way 6/7 is just board changes.

I did that for you and here is the result.

Thanks,
Sekhar

---8<---
>From 95a5d877d8d63d9decd496f616b375f30014aad8 Mon Sep 17 00:00:00 2001
From: Philip Avinash <avinashphilip@ti.com>
Date: Sun, 18 Aug 2013 10:49:00 +0530
Subject: [PATCH 4/7] ARM: davinci: support gpio platform device

DaVinci GPIO driver now uses platform device model.
Add a GPIO platform register API to convert the
traditional DaVinci  SoCs to use the new model.

While at it, also sort include files in alphabetic
order as it will help later in avoiding duplicate
includes.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
[nsekhar@ti.com: move function declaration to local header,
		 simplify commit message, merge SoC specific
		 portions from other patches into this patch]
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/davinci.h                   |   20 ++++---
 arch/arm/mach-davinci/devices.c                   |   13 +++++
 arch/arm/mach-davinci/dm355.c                     |   54 +++++++++++++------
 arch/arm/mach-davinci/dm365.c                     |   58 ++++++++++++++-------
 arch/arm/mach-davinci/dm644x.c                    |   47 ++++++++++++-----
 arch/arm/mach-davinci/dm646x.c                    |   47 ++++++++++++-----
 arch/arm/mach-davinci/include/mach/gpio-davinci.h |    2 -
 7 files changed, 172 insertions(+), 69 deletions(-)

diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 2ab5d57..645f376 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -18,22 +18,23 @@
 #define __DAVINCI_H
 
 #include <linux/clk.h>
-#include <linux/videodev2.h>
 #include <linux/davinci_emac.h>
-#include <linux/platform_device.h>
-#include <linux/spi/spi.h>
 #include <linux/platform_data/davinci_asp.h>
 #include <linux/platform_data/edma.h>
 #include <linux/platform_data/keyscan-davinci.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/videodev2.h>
+
 #include <mach/hardware.h>
 
-#include <media/davinci/vpfe_capture.h>
-#include <media/davinci/vpif_types.h>
-#include <media/davinci/vpss.h>
 #include <media/davinci/vpbe_types.h>
 #include <media/davinci/vpbe_venc.h>
 #include <media/davinci/vpbe.h>
 #include <media/davinci/vpbe_osd.h>
+#include <media/davinci/vpfe_capture.h>
+#include <media/davinci/vpif_types.h>
+#include <media/davinci/vpss.h>
 
 #define DAVINCI_SYSTEM_MODULE_BASE	0x01c40000
 #define SYSMOD_VDAC_CONFIG		0x2c
@@ -53,6 +54,9 @@ extern void __iomem *davinci_sysmod_base;
 #define DAVINCI_SYSMOD_VIRT(x)	(davinci_sysmod_base + (x))
 void davinci_map_sysmod(void);
 
+#define DAVINCI_GPIO_BASE 0x01C67000
+int davinci_gpio_register(struct resource *res, int size, void *pdata);
+
 /* DM355 base addresses */
 #define DM355_ASYNC_EMIF_CONTROL_BASE	0x01e10000
 #define DM355_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
@@ -82,6 +86,7 @@ void dm355_init_spi0(unsigned chipselect_mask,
 		const struct spi_board_info *info, unsigned len);
 void dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata);
 int dm355_init_video(struct vpfe_config *, struct vpbe_config *);
+int dm355_gpio_register(void);
 
 /* DM365 function declarations */
 void dm365_init(void);
@@ -92,11 +97,13 @@ void dm365_init_rtc(void);
 void dm365_init_spi0(unsigned chipselect_mask,
 			const struct spi_board_info *info, unsigned len);
 int dm365_init_video(struct vpfe_config *, struct vpbe_config *);
+int dm365_gpio_register(void);
 
 /* DM644x function declarations */
 void dm644x_init(void);
 void dm644x_init_asp(struct snd_platform_data *pdata);
 int dm644x_init_video(struct vpfe_config *, struct vpbe_config *);
+int dm644x_gpio_register(void);
 
 /* DM646x function declarations */
 void dm646x_init(void);
@@ -106,6 +113,7 @@ int dm646x_init_edma(struct edma_rsv_info *rsv);
 void dm646x_video_init(void);
 void dm646x_setup_vpif(struct vpif_display_config *,
 		       struct vpif_capture_config *);
+int dm646x_gpio_register(void);
 
 extern struct platform_device dm365_serial_device[];
 extern struct platform_device dm355_serial_device[];
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 111573c..3996e98 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -318,6 +318,19 @@ static void davinci_init_wdt(void)
 	platform_device_register(&davinci_wdt_device);
 }
 
+static struct platform_device davinci_gpio_device = {
+	.name	= "davinci_gpio",
+	.id	= -1,
+};
+
+int davinci_gpio_register(struct resource *res, int size, void *pdata)
+{
+	davinci_gpio_device.resource = res;
+	davinci_gpio_device.num_resources = size;
+	davinci_gpio_device.dev.platform_data = pdata;
+	return platform_device_register(&davinci_gpio_device);
+}
+
 /*-------------------------------------------------------------------------*/
 
 /*-------------------------------------------------------------------------*/
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 0f3cb48..1796213 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -8,31 +8,31 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
-#include <linux/init.h>
 #include <linux/clk.h>
-#include <linux/serial_8250.h>
-#include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-
+#include <linux/init.h>
+#include <linux/platform_data/edma.h>
+#include <linux/platform_data/gpio-davinci.h>
+#include <linux/platform_data/spi-davinci.h>
+#include <linux/platform_device.h>
+#include <linux/serial_8250.h>
 #include <linux/spi/spi.h>
 
 #include <asm/mach/map.h>
 
+#include <mach/common.h>
 #include <mach/cputype.h>
-#include <mach/psc.h>
-#include <mach/mux.h>
+#include <mach/gpio-davinci.h>
 #include <mach/irqs.h>
-#include <mach/time.h>
+#include <mach/mux.h>
+#include <mach/psc.h>
 #include <mach/serial.h>
-#include <mach/common.h>
-#include <linux/platform_data/spi-davinci.h>
-#include <mach/gpio-davinci.h>
-#include <linux/platform_data/edma.h>
+#include <mach/time.h>
 
-#include "davinci.h"
+#include "asp.h"
 #include "clock.h"
+#include "davinci.h"
 #include "mux.h"
-#include "asp.h"
 
 #define DM355_UART2_BASE	(IO_PHYS + 0x206000)
 #define DM355_OSD_BASE		(IO_PHYS + 0x70200)
@@ -886,6 +886,30 @@ static struct platform_device dm355_vpbe_dev = {
 	},
 };
 
+static struct resource dm355_gpio_resources[] = {
+	{	/* registers */
+		.start	= DAVINCI_GPIO_BASE,
+		.end	= DAVINCI_GPIO_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{	/* interrupt */
+		.start	= IRQ_DM355_GPIOBNK0,
+		.end	= IRQ_DM355_GPIOBNK6,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct davinci_gpio_platform_data dm355_gpio_platform_data = {
+	.ngpio		= 104,
+	.intc_irq_num	= DAVINCI_N_AINTC_IRQ,
+};
+
+int __init dm355_gpio_register(void)
+{
+	return davinci_gpio_register(dm355_gpio_resources,
+				     sizeof(dm355_gpio_resources),
+				     &dm355_gpio_platform_data);
+}
 /*----------------------------------------------------------------------*/
 
 static struct map_desc dm355_io_desc[] = {
@@ -1005,10 +1029,6 @@ static struct davinci_soc_info davinci_soc_info_dm355 = {
 	.intc_irq_prios		= dm355_default_priorities,
 	.intc_irq_num		= DAVINCI_N_AINTC_IRQ,
 	.timer_info		= &dm355_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DAVINCI_GPIO_BASE,
-	.gpio_num		= 104,
-	.gpio_irq		= IRQ_DM355_GPIOBNK0,
 	.sram_dma		= 0x00010000,
 	.sram_len		= SZ_32K,
 };
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 278080d..3263d0b 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -12,31 +12,32 @@
  * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-#include <linux/init.h>
 #include <linux/clk.h>
-#include <linux/serial_8250.h>
-#include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <linux/spi/spi.h>
+#include <linux/init.h>
 #include <linux/platform_data/edma.h>
+#include <linux/platform_data/gpio-davinci.h>
+#include <linux/platform_data/keyscan-davinci.h>
+#include <linux/platform_data/spi-davinci.h>
+#include <linux/platform_device.h>
+#include <linux/serial_8250.h>
+#include <linux/spi/spi.h>
 
 #include <asm/mach/map.h>
 
+#include <mach/common.h>
 #include <mach/cputype.h>
-#include <mach/psc.h>
-#include <mach/mux.h>
+#include <mach/gpio-davinci.h>
 #include <mach/irqs.h>
-#include <mach/time.h>
+#include <mach/mux.h>
+#include <mach/psc.h>
 #include <mach/serial.h>
-#include <mach/common.h>
-#include <linux/platform_data/keyscan-davinci.h>
-#include <linux/platform_data/spi-davinci.h>
-#include <mach/gpio-davinci.h>
+#include <mach/time.h>
 
-#include "davinci.h"
+#include "asp.h"
 #include "clock.h"
+#include "davinci.h"
 #include "mux.h"
-#include "asp.h"
 
 #define DM365_REF_FREQ		24000000	/* 24 MHz on the DM365 EVM */
 #define DM365_RTC_BASE			0x01c69000
@@ -698,6 +699,32 @@ void __init dm365_init_spi0(unsigned chipselect_mask,
 	platform_device_register(&dm365_spi0_device);
 }
 
+static struct resource dm365_gpio_resources[] = {
+	{	/* registers */
+		.start	= DAVINCI_GPIO_BASE,
+		.end	= DAVINCI_GPIO_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{	/* interrupt */
+		.start	= IRQ_DM365_GPIO0,
+		.end	= IRQ_DM365_GPIO7,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct davinci_gpio_platform_data dm365_gpio_platform_data = {
+	.ngpio		= 104,
+	.intc_irq_num	= DAVINCI_N_AINTC_IRQ,
+	.gpio_unbanked	= 8,
+};
+
+int __init dm365_gpio_register(void)
+{
+	return davinci_gpio_register(dm365_gpio_resources,
+				     sizeof(dm365_gpio_resources),
+				     &dm365_gpio_platform_data);
+}
+
 static struct emac_platform_data dm365_emac_pdata = {
 	.ctrl_reg_offset	= DM365_EMAC_CNTRL_OFFSET,
 	.ctrl_mod_reg_offset	= DM365_EMAC_CNTRL_MOD_OFFSET,
@@ -1105,11 +1132,6 @@ static struct davinci_soc_info davinci_soc_info_dm365 = {
 	.intc_irq_prios		= dm365_default_priorities,
 	.intc_irq_num		= DAVINCI_N_AINTC_IRQ,
 	.timer_info		= &dm365_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DAVINCI_GPIO_BASE,
-	.gpio_num		= 104,
-	.gpio_irq		= IRQ_DM365_GPIO0,
-	.gpio_unbanked		= 8,	/* really 16 ... skip muxed GPIOs */
 	.emac_pdata		= &dm365_emac_pdata,
 	.sram_dma		= 0x00010000,
 	.sram_len		= SZ_32K,
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 4f74682..71cdc35 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -8,27 +8,28 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
-#include <linux/init.h>
 #include <linux/clk.h>
-#include <linux/serial_8250.h>
-#include <linux/platform_device.h>
+#include <linux/init.h>
 #include <linux/platform_data/edma.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/gpio-davinci.h>
+#include <linux/serial_8250.h>
 
 #include <asm/mach/map.h>
 
+#include <mach/common.h>
 #include <mach/cputype.h>
+#include <mach/gpio-davinci.h>
 #include <mach/irqs.h>
-#include <mach/psc.h>
 #include <mach/mux.h>
-#include <mach/time.h>
+#include <mach/psc.h>
 #include <mach/serial.h>
-#include <mach/common.h>
-#include <mach/gpio-davinci.h>
+#include <mach/time.h>
 
-#include "davinci.h"
+#include "asp.h"
 #include "clock.h"
+#include "davinci.h"
 #include "mux.h"
-#include "asp.h"
 
 /*
  * Device specific clocks
@@ -771,6 +772,30 @@ static struct platform_device dm644x_vpbe_dev = {
 	},
 };
 
+static struct resource dm644_gpio_resources[] = {
+	{	/* registers */
+		.start	= DAVINCI_GPIO_BASE,
+		.end	= DAVINCI_GPIO_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{	/* interrupt */
+		.start	= IRQ_GPIOBNK0,
+		.end	= IRQ_GPIOBNK4,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct davinci_gpio_platform_data dm644_gpio_platform_data = {
+	.ngpio		= 71,
+	.intc_irq_num	= DAVINCI_N_AINTC_IRQ,
+};
+
+int __init dm644x_gpio_register(void)
+{
+	return davinci_gpio_register(dm644_gpio_resources,
+				     sizeof(dm644_gpio_resources),
+				     &dm644_gpio_platform_data);
+}
 /*----------------------------------------------------------------------*/
 
 static struct map_desc dm644x_io_desc[] = {
@@ -897,10 +922,6 @@ static struct davinci_soc_info davinci_soc_info_dm644x = {
 	.intc_irq_prios 	= dm644x_default_priorities,
 	.intc_irq_num		= DAVINCI_N_AINTC_IRQ,
 	.timer_info		= &dm644x_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DAVINCI_GPIO_BASE,
-	.gpio_num		= 71,
-	.gpio_irq		= IRQ_GPIOBNK0,
 	.emac_pdata		= &dm644x_emac_pdata,
 	.sram_dma		= 0x00008000,
 	.sram_len		= SZ_16K,
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 68f8d1f..ef1abdc 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -8,28 +8,29 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/init.h>
-#include <linux/clk.h>
-#include <linux/serial_8250.h>
-#include <linux/platform_device.h>
 #include <linux/platform_data/edma.h>
+#include <linux/platform_data/gpio-davinci.h>
+#include <linux/platform_device.h>
+#include <linux/serial_8250.h>
 
 #include <asm/mach/map.h>
 
+#include <mach/common.h>
 #include <mach/cputype.h>
+#include <mach/gpio-davinci.h>
 #include <mach/irqs.h>
-#include <mach/psc.h>
 #include <mach/mux.h>
-#include <mach/time.h>
+#include <mach/psc.h>
 #include <mach/serial.h>
-#include <mach/common.h>
-#include <mach/gpio-davinci.h>
+#include <mach/time.h>
 
-#include "davinci.h"
+#include "asp.h"
 #include "clock.h"
+#include "davinci.h"
 #include "mux.h"
-#include "asp.h"
 
 #define DAVINCI_VPIF_BASE       (0x01C12000)
 
@@ -748,6 +749,30 @@ static struct platform_device vpif_capture_dev = {
 	.num_resources	= ARRAY_SIZE(vpif_capture_resource),
 };
 
+static struct resource dm646x_gpio_resources[] = {
+	{	/* registers */
+		.start	= DAVINCI_GPIO_BASE,
+		.end	= DAVINCI_GPIO_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{	/* interrupt */
+		.start	= IRQ_DM646X_GPIOBNK0,
+		.end	= IRQ_DM646X_GPIOBNK2,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct davinci_gpio_platform_data dm646x_gpio_platform_data = {
+	.ngpio		= 43,
+	.intc_irq_num	= DAVINCI_N_AINTC_IRQ,
+};
+
+int __init dm646x_gpio_register(void)
+{
+	return davinci_gpio_register(dm646x_gpio_resources,
+				     sizeof(dm646x_gpio_resources),
+				     &dm646x_gpio_platform_data);
+}
 /*----------------------------------------------------------------------*/
 
 static struct map_desc dm646x_io_desc[] = {
@@ -874,10 +899,6 @@ static struct davinci_soc_info davinci_soc_info_dm646x = {
 	.intc_irq_prios		= dm646x_default_priorities,
 	.intc_irq_num		= DAVINCI_N_AINTC_IRQ,
 	.timer_info		= &dm646x_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DAVINCI_GPIO_BASE,
-	.gpio_num		= 43, /* Only 33 usable */
-	.gpio_irq		= IRQ_DM646X_GPIOBNK0,
 	.emac_pdata		= &dm646x_emac_pdata,
 	.sram_dma		= 0x10010000,
 	.sram_len		= SZ_32K,
diff --git a/arch/arm/mach-davinci/include/mach/gpio-davinci.h b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
index 551ba43..0d63b24 100644
--- a/arch/arm/mach-davinci/include/mach/gpio-davinci.h
+++ b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
@@ -21,8 +21,6 @@
 #include <mach/irqs.h>
 #include <mach/common.h>
 
-#define DAVINCI_GPIO_BASE 0x01C67000
-
 enum davinci_gpio_type {
 	GPIO_TYPE_DAVINCI = 0,
 	GPIO_TYPE_TNETV107X,
-- 
1.7.10.1

