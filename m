Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3HRFVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 01:21:11 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41500 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab3HRFVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 01:21:08 -0400
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
Subject: [PATCH v3 5/7] ARM: davinci: da8xx: gpio device creation
Date: Sun, 18 Aug 2013 10:49:01 +0530
Message-Id: <1376803143-13738-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Avinash <avinashphilip@ti.com>

Create davinci gpio device and remove references in davinci_soc_info
structure. Also rearrange header file inclusion in group basis.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-davinci/board-da830-evm.c     |   28 ++++++++++++++++-----------
 arch/arm/mach-davinci/board-da850-evm.c     |   16 ++++++++++-----
 arch/arm/mach-davinci/board-omapl138-hawk.c |   10 ++++++++--
 arch/arm/mach-davinci/da830.c               |   21 +++++++++++++++-----
 arch/arm/mach-davinci/da850.c               |   27 ++++++++++++++++++--------
 arch/arm/mach-davinci/include/mach/da8xx.h  |   22 +++++++++++----------
 6 files changed, 83 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index c4bdc0a..54a8690 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -9,30 +9,32 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/console.h>
-#include <linux/interrupt.h>
 #include <linux/gpio.h>
-#include <linux/platform_device.h>
 #include <linux/i2c.h>
-#include <linux/i2c/pcf857x.h>
 #include <linux/i2c/at24.h>
+#include <linux/i2c/pcf857x.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
-#include <linux/spi/spi.h>
+#include <linux/platform_data/gpio-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_data/spi-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_device.h>
 #include <linux/spi/flash.h>
+#include <linux/spi/spi.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
+#include <mach/common.h>
 #include <mach/cp_intc.h>
-#include <mach/mux.h>
-#include <linux/platform_data/mtd-davinci.h>
 #include <mach/da8xx.h>
-#include <linux/platform_data/usb-davinci.h>
-#include <linux/platform_data/mtd-davinci-aemif.h>
-#include <linux/platform_data/spi-davinci.h>
+#include <mach/mux.h>
 
 #define DA830_EVM_PHY_ID		""
 /*
@@ -591,6 +593,10 @@ static __init void da830_evm_init(void)
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 	int ret;
 
+	ret = da830_register_gpio();
+	if (ret)
+		pr_warn("da830_evm_init: GPIO init failed: %d\n", ret);
+
 	ret = da830_register_edma(da830_edma_rsv);
 	if (ret)
 		pr_warning("da830_evm_init: edma registration failed: %d\n",
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 9afd687..8b0a673 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -15,29 +15,31 @@
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/gpio_keys.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/i2c/at24.h>
 #include <linux/i2c/pca953x.h>
+#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input/tps6507x-ts.h>
+#include <linux/kernel.h>
 #include <linux/mfd/tps6507x.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
-#include <linux/platform_device.h>
+#include <linux/platform_data/gpio-davinci.h>
 #include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/mtd-davinci-aemif.h>
 #include <linux/platform_data/spi-davinci.h>
 #include <linux/platform_data/uio_pruss.h>
+#include <linux/platform_device.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/tps6507x.h>
-#include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#include <linux/spi/spi.h>
 #include <linux/wl12xx.h>
 
+#include <mach/common.h>
 #include <mach/cp_intc.h>
 #include <mach/da8xx.h>
 #include <mach/mux.h>
@@ -47,8 +49,8 @@
 #include <asm/mach/arch.h>
 #include <asm/system_info.h>
 
-#include <media/tvp514x.h>
 #include <media/adv7343.h>
+#include <media/tvp514x.h>
 
 #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
 #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
@@ -1439,6 +1441,10 @@ static __init void da850_evm_init(void)
 {
 	int ret;
 
+	ret = da850_register_gpio();
+	if (ret)
+		pr_warn("da850_evm_init: GPIO init failed: %d\n", ret);
+
 	ret = pmic_tps65070_init();
 	if (ret)
 		pr_warn("%s: TPS65070 PMIC init failed: %d\n", __func__, ret);
diff --git a/arch/arm/mach-davinci/board-omapl138-hawk.c b/arch/arm/mach-davinci/board-omapl138-hawk.c
index ab98c75..0e0b998 100644
--- a/arch/arm/mach-davinci/board-omapl138-hawk.c
+++ b/arch/arm/mach-davinci/board-omapl138-hawk.c
@@ -9,14 +9,16 @@
  * version 2. This program is licensed "as is" without any warranty of
  * any kind, whether express or implied.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/console.h>
 #include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
+#include <mach/common.h>
 #include <mach/cp_intc.h>
 #include <mach/da8xx.h>
 #include <mach/mux.h>
@@ -290,6 +292,10 @@ static __init void omapl138_hawk_init(void)
 {
 	int ret;
 
+	ret = da850_register_gpio();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
+
 	davinci_serial_init(da8xx_serial_device);
 
 	omapl138_hawk_config_emac();
diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index 9ef1b67..da498ee 100644
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
+int __init da830_register_gpio()
+{
+	return da8xx_register_gpio(&da830_gpio_platform_data);
+}
+
 static struct davinci_timer_instance da830_timer_instance[2] = {
 	{
 		.base		= DA8XX_TIMER64P0_BASE,
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 887af90..c6608c4 100644
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
+int __init da850_register_gpio()
+{
+	return da8xx_register_gpio(&da850_gpio_platform_data);
+}
+
 static struct davinci_soc_info davinci_soc_info_da850 = {
 	.io_desc		= da850_io_desc,
 	.io_desc_num		= ARRAY_SIZE(da850_io_desc),
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index a96da92..8642150 100644
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
 
@@ -111,6 +111,8 @@ int da850_register_vpif_capture
 void da8xx_restart(enum reboot_mode mode, const char *cmd);
 void da8xx_rproc_reserve_cma(void);
 int da8xx_register_rproc(void);
+int da850_register_gpio(void);
+int da830_register_gpio(void);
 
 extern struct platform_device da8xx_serial_device[];
 extern struct emac_platform_data da8xx_emac_pdata;
-- 
1.7.9.5

