Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3HRFVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 01:21:31 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56694 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab3HRFVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 01:21:30 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Philip Avinash <avinashphilip@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 6/7] ARM: davinci: dmxxx: gpio device creation
Date: Sun, 18 Aug 2013 10:49:02 +0530
Message-Id: <1376803143-13738-7-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Avinash <avinashphilip@ti.com>

Create davinci gpio device and remove gpio references in
davinci_soc_info structure for dmxxx platforms. Also add Memory and IRQ
resources for GPIO platform device. Also rearrange header file inclusion
in group basis.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-davinci/board-dm355-evm.c           |   33 +++++++-----
 arch/arm/mach-davinci/board-dm355-leopard.c       |   30 ++++++-----
 arch/arm/mach-davinci/board-dm365-evm.c           |   30 ++++++-----
 arch/arm/mach-davinci/board-dm644x-evm.c          |   40 ++++++++------
 arch/arm/mach-davinci/board-dm646x-evm.c          |   37 +++++++------
 arch/arm/mach-davinci/board-neuros-osd2.c         |   18 ++++---
 arch/arm/mach-davinci/davinci.h                   |   17 +++---
 arch/arm/mach-davinci/dm355.c                     |   54 +++++++++++++------
 arch/arm/mach-davinci/dm365.c                     |   58 ++++++++++++++-------
 arch/arm/mach-davinci/dm644x.c                    |   47 ++++++++++++-----
 arch/arm/mach-davinci/dm646x.c                    |   47 ++++++++++++-----
 arch/arm/mach-davinci/include/mach/common.h       |    2 +
 arch/arm/mach-davinci/include/mach/gpio-davinci.h |    2 -
 13 files changed, 272 insertions(+), 143 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 42b23a3..4712fb4 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -8,29 +8,31 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/err.h>
-#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
 #include <linux/mtd/nand.h>
-#include <linux/i2c.h>
-#include <linux/gpio.h>
-#include <linux/clk.h>
+#include <linux/mtd/partitions.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_device.h>
+#include <linux/spi/eeprom.h>
+#include <linux/spi/spi.h>
 #include <linux/videodev2.h>
+
 #include <media/tvp514x.h>
-#include <linux/spi/spi.h>
-#include <linux/spi/eeprom.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <linux/platform_data/i2c-davinci.h>
+#include <mach/common.h>
 #include <mach/serial.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/usb-davinci.h>
 
 #include "davinci.h"
 
@@ -375,6 +377,11 @@ static struct spi_board_info dm355_evm_spi_info[] __initconst = {
 static __init void dm355_evm_init(void)
 {
 	struct clk *aemif;
+	int ret;
+
+	ret = dm355_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
 
 	gpio_request(1, "dm9000");
 	gpio_direction_input(1);
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index d9eb1c9..fbaeea8 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -7,27 +7,28 @@
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/err.h>
-#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
 #include <linux/mtd/nand.h>
-#include <linux/i2c.h>
-#include <linux/gpio.h>
-#include <linux/clk.h>
-#include <linux/spi/spi.h>
+#include <linux/mtd/partitions.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_device.h>
 #include <linux/spi/eeprom.h>
+#include <linux/spi/spi.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <linux/platform_data/i2c-davinci.h>
+#include <mach/common.h>
 #include <mach/serial.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/usb-davinci.h>
 
 #include "davinci.h"
 
@@ -233,6 +234,11 @@ static struct spi_board_info dm355_leopard_spi_info[] __initconst = {
 static __init void dm355_leopard_init(void)
 {
 	struct clk *aemif;
+	int ret;
+
+	ret = dm355_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
 
 	gpio_request(9, "dm9000");
 	gpio_direction_input(9);
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 000e2ab..9c1dd31 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -12,33 +12,33 @@
  * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
-#include <linux/io.h>
-#include <linux/clk.h>
 #include <linux/i2c/at24.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/keyscan-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
 #include <linux/slab.h>
-#include <linux/mtd/nand.h>
-#include <linux/input.h>
-#include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
+#include <linux/spi/spi.h>
 #include <linux/v4l2-dv-timings.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/mux.h>
 #include <mach/common.h>
-#include <linux/platform_data/i2c-davinci.h>
+#include <mach/mux.h>
 #include <mach/serial.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/keyscan-davinci.h>
 
 #include <media/ths7303.h>
 #include <media/tvp514x.h>
@@ -743,6 +743,12 @@ static struct spi_board_info dm365_evm_spi_info[] __initconst = {
 
 static __init void dm365_evm_init(void)
 {
+	int ret;
+
+	ret = dm365_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
+
 	evm_init_i2c();
 	davinci_serial_init(dm365_serial_device);
 
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 462812b..d0894d8 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -8,37 +8,42 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
-#include <linux/platform_device.h>
+#include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/i2c/pcf857x.h>
 #include <linux/i2c/at24.h>
+#include <linux/i2c/pcf857x.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
 #include <linux/phy.h>
-#include <linux/clk.h>
-#include <linux/videodev2.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/keyscan-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/slab.h>
+#include <linux/spi/eeprom.h>
+#include <linux/spi/spi.h>
 #include <linux/v4l2-dv-timings.h>
-#include <linux/export.h>
-
-#include <media/tvp514x.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <mach/common.h>
-#include <linux/platform_data/i2c-davinci.h>
-#include <mach/serial.h>
 #include <mach/mux.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/usb-davinci.h>
-#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <mach/serial.h>
+
+#include <media/tvp514x.h>
 
 #include "davinci.h"
 
@@ -753,9 +758,14 @@ static int davinci_phy_fixup(struct phy_device *phydev)
 
 static __init void davinci_evm_init(void)
 {
+	int ret;
 	struct clk *aemif_clk;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
+	ret = dm644x_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
+
 	aemif_clk = clk_get(NULL, "aemif");
 	clk_prepare_enable(aemif_clk);
 
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 734cc02..e5e4cf0 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -16,37 +16,37 @@
  * Included Files
  **************************************************************************/
 
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/leds.h>
+#include <linux/clk.h>
+#include <linux/export.h>
 #include <linux/gpio.h>
-#include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/i2c/at24.h>
 #include <linux/i2c/pcf857x.h>
-
-#include <media/tvp514x.h>
-#include <media/adv7343.h>
-
+#include <linux/init.h>
+#include <mach/irqs.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
-#include <linux/clk.h>
-#include <linux/export.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_device.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
+#include <mach/cdce949.h>
+#include <mach/clock.h>
 #include <mach/common.h>
 #include <mach/serial.h>
-#include <linux/platform_data/i2c-davinci.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <mach/clock.h>
-#include <mach/cdce949.h>
-#include <linux/platform_data/mtd-davinci-aemif.h>
 
-#include "davinci.h"
+#include <media/tvp514x.h>
+#include <media/adv7343.h>
+
 #include "clock.h"
+#include "davinci.h"
 
 #define NAND_BLOCK_SIZE		SZ_128K
 
@@ -785,8 +785,13 @@ static struct edma_rsv_info dm646x_edma_rsv[] = {
 
 static __init void evm_init(void)
 {
+	int ret;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
+	ret = dm646x_gpio_register();
+	if (ret)
+		pr_warn("evm_init: GPIO init failed: %d\n", ret);
+
 	evm_init_i2c();
 	davinci_serial_init(dm646x_serial_device);
 	dm646x_init_mcasp0(&dm646x_evm_snd_data[0]);
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 8e156e0..322eabd 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -23,20 +23,21 @@
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
  */
-#include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/mtd/partitions.h>
+#include <linux/platform_data/gpio-davinci.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_device.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <mach/common.h>
-#include <linux/platform_data/i2c-davinci.h>
-#include <mach/serial.h>
 #include <mach/mux.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/usb-davinci.h>
+#include <mach/serial.h>
 
 #include "davinci.h"
 
@@ -168,9 +169,14 @@ static struct davinci_mmc_config davinci_ntosd2_mmc_config = {
 
 static __init void davinci_ntosd2_init(void)
 {
+	int ret;
 	struct clk *aemif_clk;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
+	ret = dm644x_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
+
 	aemif_clk = clk_get(NULL, "aemif");
 	clk_prepare_enable(aemif_clk);
 
diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 6dfc038..e297cb7 100644
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
@@ -84,6 +85,7 @@ void dm355_init_spi0(unsigned chipselect_mask,
 		const struct spi_board_info *info, unsigned len);
 void dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata);
 int dm355_init_video(struct vpfe_config *, struct vpbe_config *);
+int dm355_gpio_register(void);
 
 /* DM365 function declarations */
 void dm365_init(void);
@@ -94,11 +96,13 @@ void dm365_init_rtc(void);
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
@@ -108,6 +112,7 @@ int dm646x_init_edma(struct edma_rsv_info *rsv);
 void dm646x_video_init(void);
 void dm646x_setup_vpif(struct vpif_display_config *,
 		       struct vpif_capture_config *);
+int dm646x_gpio_register(void);
 
 extern struct platform_device dm365_serial_device[];
 extern struct platform_device dm355_serial_device[];
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 0f3cb48..3eb5ffe 100644
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
+	.ngpio = 104,
+	.intc_irq_num = DAVINCI_N_AINTC_IRQ,
+};
+
+int __init dm355_gpio_register()
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
index 278080d..9bb60f1 100644
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
+	.ngpio = 104,
+	.intc_irq_num = DAVINCI_N_AINTC_IRQ,
+	.gpio_unbanked = 8,
+};
+
+int __init dm365_gpio_register()
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
index 4f74682..9f5f059 100644
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
+	.ngpio = 71,
+	.intc_irq_num = DAVINCI_N_AINTC_IRQ,
+};
+
+int __init dm644x_gpio_register()
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
index 68f8d1f..02042d5 100644
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
+	.ngpio = 43,
+	.intc_irq_num = DAVINCI_N_AINTC_IRQ,
+};
+
+int __init dm646x_gpio_register()
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
diff --git a/arch/arm/mach-davinci/include/mach/common.h b/arch/arm/mach-davinci/include/mach/common.h
index 0b3c169..4bb25e2 100644
--- a/arch/arm/mach-davinci/include/mach/common.h
+++ b/arch/arm/mach-davinci/include/mach/common.h
@@ -38,6 +38,8 @@ struct davinci_timer_info {
 
 struct davinci_gpio_controller;
 
+#define DAVINCI_GPIO_BASE 0x01c67000
+
 /*
  * SoC info passed into common davinci modules.
  *
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
1.7.9.5

