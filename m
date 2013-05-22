Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3EVHLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:11:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57296 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3EVHL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:11:27 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 07/11] ARM: davinci: create davinci gpio device for dm platforms
Date: Wed, 22 May 2013 12:40:30 +0530
Message-ID: <1369206634-6778-8-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c     |   27 ++++++++++++++++++++++++++
 arch/arm/mach-davinci/board-dm355-leopard.c |    1 +
 arch/arm/mach-davinci/board-dm365-evm.c     |   28 +++++++++++++++++++++++++++
 arch/arm/mach-davinci/board-dm644x-evm.c    |   26 +++++++++++++++++++++++++
 arch/arm/mach-davinci/board-dm646x-evm.c    |   27 ++++++++++++++++++++++++++
 arch/arm/mach-davinci/board-neuros-osd2.c   |    1 +
 arch/arm/mach-davinci/dm355.c               |    4 ----
 arch/arm/mach-davinci/dm365.c               |    5 -----
 arch/arm/mach-davinci/dm644x.c              |    4 ----
 arch/arm/mach-davinci/dm646x.c              |    4 ----
 arch/arm/mach-davinci/include/mach/common.h |    2 ++
 11 files changed, 112 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index bfdf8b9..785c7b8 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -28,9 +28,11 @@
 
 #include <linux/platform_data/i2c-davinci.h>
 #include <mach/serial.h>
+#include <mach/common.h>
 #include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include "davinci.h"
 
@@ -311,9 +313,34 @@ static struct spi_board_info dm355_evm_spi_info[] __initconst = {
 	},
 };
 
+static struct resource dm355_gpio_resources[] = {
+	{ /* registers */
+		.start	= DAVINCI_GPIO_BASE,
+		.end	= DAVINCI_GPIO_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{ /* interrupt */
+		.start	= IRQ_DM355_GPIOBNK0,
+		.end	= IRQ_DM355_GPIOBNK6,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct davinci_gpio_platform_data dm355_gpio_platform_data = {
+	.ngpio = 104,
+	.intc_irq_num = DAVINCI_N_AINTC_IRQ,
+};
+
 static __init void dm355_evm_init(void)
 {
 	struct clk *aemif;
+	int ret;
+
+	ret = davinci_gpio_register(dm355_gpio_resources,
+			sizeof(dm355_gpio_resources),
+			&dm355_gpio_platform_data);
+	if (ret)
+		pr_warn("dm355_evm_init: GPIO init failed: %d\n", ret);
 
 	gpio_request(1, "dm9000");
 	gpio_direction_input(1);
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index dff4ddc..34a2b64 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -25,6 +25,7 @@
 
 #include <linux/platform_data/i2c-davinci.h>
 #include <mach/serial.h>
+#include <mach/common.h>
 #include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/usb-davinci.h>
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 4cfdd91..623263e 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -38,6 +38,7 @@
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/keyscan-davinci.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include <media/tvp514x.h>
 
@@ -586,8 +587,35 @@ static struct spi_board_info dm365_evm_spi_info[] __initconst = {
 	},
 };
 
+static struct resource dm365_gpio_resources[] = {
+	{ /* registers */
+		.start	= DAVINCI_GPIO_BASE,
+		.end	= DAVINCI_GPIO_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{ /* interrupt */
+		.start	= IRQ_DM365_GPIO0,
+		.end	= IRQ_DM365_GPIO7,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct davinci_gpio_platform_data dm365_gpio_platform_data = {
+	.ngpio = 104,
+	.intc_irq_num = DAVINCI_N_AINTC_IRQ,
+	.gpio_unbanked = 8,
+};
+
 static __init void dm365_evm_init(void)
 {
+	int ret;
+
+	ret = davinci_gpio_register(dm365_gpio_resources,
+			sizeof(dm365_gpio_resources),
+			&dm365_gpio_platform_data);
+	if (ret)
+		pr_warn("dm365_evm_init: GPIO init failed: %d\n", ret);
+
 	evm_init_i2c();
 	davinci_serial_init(&uart_config);
 
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index fc8e38e..76d9f6b 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -39,6 +39,7 @@
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/usb-davinci.h>
 #include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include "davinci.h"
 
@@ -755,11 +756,36 @@ static int davinci_phy_fixup(struct phy_device *phydev)
 
 #define HAS_NAND	IS_ENABLED(CONFIG_MTD_NAND_DAVINCI)
 
+static struct resource dm644_gpio_resources[] = {
+	{ /* registers */
+		.start	= DAVINCI_GPIO_BASE,
+		.end	= DAVINCI_GPIO_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{ /* interrupt */
+		.start	= IRQ_GPIOBNK0,
+		.end	= IRQ_GPIOBNK4,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct davinci_gpio_platform_data dm644_gpio_platform_data = {
+	.ngpio = 71,
+	.intc_irq_num = DAVINCI_N_AINTC_IRQ,
+};
+
 static __init void davinci_evm_init(void)
 {
+	int ret;
 	struct clk *aemif_clk;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
+	ret = davinci_gpio_register(dm644_gpio_resources,
+			sizeof(dm644_gpio_resources),
+			&dm644_gpio_platform_data);
+	if (ret)
+		pr_warn("davinci_evm_init: GPIO init failed: %d\n", ret);
+
 	aemif_clk = clk_get(NULL, "aemif");
 	clk_prepare_enable(aemif_clk);
 
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 03785e0..e419d9e 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -39,11 +39,13 @@
 
 #include <mach/common.h>
 #include <mach/serial.h>
+#include <mach/irqs.h>
 #include <linux/platform_data/i2c-davinci.h>
 #include <linux/platform_data/mtd-davinci.h>
 #include <mach/clock.h>
 #include <mach/cdce949.h>
 #include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include "davinci.h"
 #include "clock.h"
@@ -787,10 +789,35 @@ static struct edma_rsv_info dm646x_edma_rsv[] = {
 	},
 };
 
+static struct resource dm646_gpio_resources[] = {
+	{ /* registers */
+		.start	= DAVINCI_GPIO_BASE,
+		.end	= DAVINCI_GPIO_BASE + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{ /* interrupt */
+		.start	= IRQ_DM646X_GPIOBNK0,
+		.end	= IRQ_DM646X_GPIOBNK2,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct davinci_gpio_platform_data dm646_gpio_platform_data = {
+	.ngpio = 43,
+	.intc_irq_num = DAVINCI_N_AINTC_IRQ,
+};
+
 static __init void evm_init(void)
 {
+	int ret;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
+	ret = davinci_gpio_register(dm646_gpio_resources,
+			sizeof(dm646_gpio_resources),
+			&dm646_gpio_platform_data);
+	if (ret)
+		pr_warn("evm_init: GPIO init failed: %d\n", ret);
+
 	evm_init_i2c();
 	davinci_serial_init(&uart_config);
 	dm646x_init_mcasp0(&dm646x_evm_snd_data[0]);
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 2bc112a..c2b96ec 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -37,6 +37,7 @@
 #include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 87e6104..2ecbb71 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -840,10 +840,6 @@ static struct davinci_soc_info davinci_soc_info_dm355 = {
 	.intc_irq_prios		= dm355_default_priorities,
 	.intc_irq_num		= DAVINCI_N_AINTC_IRQ,
 	.timer_info		= &dm355_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DAVINCI_GPIO_BASE,
-	.gpio_num		= 104,
-	.gpio_irq		= IRQ_DM355_GPIOBNK0,
 	.serial_dev		= &dm355_serial_device,
 	.sram_dma		= 0x00010000,
 	.sram_len		= SZ_32K,
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 2791df9..861dec9 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -1084,11 +1084,6 @@ static struct davinci_soc_info davinci_soc_info_dm365 = {
 	.intc_irq_prios		= dm365_default_priorities,
 	.intc_irq_num		= DAVINCI_N_AINTC_IRQ,
 	.timer_info		= &dm365_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DAVINCI_GPIO_BASE,
-	.gpio_num		= 104,
-	.gpio_irq		= IRQ_DM365_GPIO0,
-	.gpio_unbanked		= 8,	/* really 16 ... skip muxed GPIOs */
 	.serial_dev		= &dm365_serial_device,
 	.emac_pdata		= &dm365_emac_pdata,
 	.sram_dma		= 0x00010000,
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index ab6bf54..d1d7670 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -868,10 +868,6 @@ static struct davinci_soc_info davinci_soc_info_dm644x = {
 	.intc_irq_prios 	= dm644x_default_priorities,
 	.intc_irq_num		= DAVINCI_N_AINTC_IRQ,
 	.timer_info		= &dm644x_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DAVINCI_GPIO_BASE,
-	.gpio_num		= 71,
-	.gpio_irq		= IRQ_GPIOBNK0,
 	.serial_dev		= &dm644x_serial_device,
 	.emac_pdata		= &dm644x_emac_pdata,
 	.sram_dma		= 0x00008000,
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index ac7b431..1058e7c 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -845,10 +845,6 @@ static struct davinci_soc_info davinci_soc_info_dm646x = {
 	.intc_irq_prios		= dm646x_default_priorities,
 	.intc_irq_num		= DAVINCI_N_AINTC_IRQ,
 	.timer_info		= &dm646x_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DAVINCI_GPIO_BASE,
-	.gpio_num		= 43, /* Only 33 usable */
-	.gpio_irq		= IRQ_DM646X_GPIOBNK0,
 	.serial_dev		= &dm646x_serial_device,
 	.emac_pdata		= &dm646x_emac_pdata,
 	.sram_dma		= 0x10010000,
diff --git a/arch/arm/mach-davinci/include/mach/common.h b/arch/arm/mach-davinci/include/mach/common.h
index bd389ba..f9d81fb 100644
--- a/arch/arm/mach-davinci/include/mach/common.h
+++ b/arch/arm/mach-davinci/include/mach/common.h
@@ -38,6 +38,8 @@ struct davinci_timer_info {
 
 struct davinci_gpio_controller;
 
+#define DAVINCI_GPIO_BASE 0x01C67000
+
 /*
  * SoC info passed into common davinci modules.
  *
-- 
1.7.9.5

