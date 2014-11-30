Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaK3QQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:16:39 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53664 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaK3QQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:16:37 -0500
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: b.zolnierkie@samsung.com, amit.daniel@samsung.com, kgene.kim@samsung.com,
        arnd@arndb.de, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] soc: samsung: pmu: split up SoC specific PMU data
Date: Sun, 30 Nov 2014 21:46:02 +0530
Message-Id: <1417364162-29981-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits up exynos-pmu.c file, and moves PMU configuration data
and functions handing those data into SoC specific PMU files, keeping
driver structure and common functionality into exynos-pmu.c.

At the same time it also separates compilation of these different SoC PMU files
based on CONFIG_ARM64 and CONFIG_ARM. This way we can reduce overhead of ARM64
SoC's PMU getting compiled when kernel is built for ARM and vice-versa.

This patch also removes .owner field from exynos-pmu.c as it's redundant for
drivers calling platform_driver_register to register platform_driver.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
This patch is prepared on top of kgene/for-next and following patch [1] from
Amit Daniel.

[1]: http://www.spinics.net/lists/linux-samsung-soc/msg39797.html

This patch tries to address some of concerns raised for using exynos-pmu.c for
ARM and ARM64 based SoC at these threads [2], [3].

[2]: http://www.spinics.net/lists/linux-samsung-soc/msg39809.html
[3]: https://lkml.org/lkml/2014/11/24/322

Since Exynos SoC's has similar PMU IP, and already existing bindings can be
used, it makes sense to keep single driver for both ARM and ARM64 based SoCs.
All common functionalties are in exynos-pmu.c whereas SoC specific data and 
handling are moved into SoC specific exynosNNNN-pmu files.

All changes are compiled tested only. Any improvements/suggestions are most
welcome.

 drivers/soc/samsung/Makefile         |    9 +-
 drivers/soc/samsung/exynos-pmu.c     | 1293 +---------------------------------
 drivers/soc/samsung/exynos-pmu.h     |   63 ++
 drivers/soc/samsung/exynos3250-pmu.c |  176 +++++
 drivers/soc/samsung/exynos4-pmu.c    |  223 ++++++
 drivers/soc/samsung/exynos5250-pmu.c |  196 ++++++
 drivers/soc/samsung/exynos5420-pmu.c |  298 ++++++++
 drivers/soc/samsung/exynos7-pmu.c    |  441 ++++++++++++
 8 files changed, 1412 insertions(+), 1287 deletions(-)
 create mode 100644 drivers/soc/samsung/exynos-pmu.h
 create mode 100644 drivers/soc/samsung/exynos3250-pmu.c
 create mode 100644 drivers/soc/samsung/exynos4-pmu.c
 create mode 100644 drivers/soc/samsung/exynos5250-pmu.c
 create mode 100644 drivers/soc/samsung/exynos5420-pmu.c
 create mode 100644 drivers/soc/samsung/exynos7-pmu.c

diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
index 5a879c6..4a59c39 100644
--- a/drivers/soc/samsung/Makefile
+++ b/drivers/soc/samsung/Makefile
@@ -1 +1,8 @@
-obj-$(CONFIG_EXYNOS_PMU)	+= exynos-pmu.o
+ifdef CONFIG_ARM
+obj-$(CONFIG_EXYNOS_PMU)	+= exynos-pmu.o exynos3250-pmu.o exynos4-pmu.o \
+				exynos5250-pmu.o exynos5420-pmu.o
+endif
+
+ifdef CONFIG_ARM64
+obj-$(CONFIG_EXYNOS_PMU)	+= exynos-pmu.o exynos7-pmu.o
+endif
diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index 3d8b82c..985fefd 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -9,970 +9,22 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
-#include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/soc/samsung/exynos-regs-pmu.h>
 #include <linux/soc/samsung/exynos-pmu.h>
 
-#define PMU_TABLE_END	(-1U)
-
-struct exynos_pmu_conf {
-	unsigned int offset;
-	u8 val[NUM_SYS_POWERDOWN];
-};
-
-struct exynos_pmu_conf_extra {
-	u32 offset;
-	u32 val[NUM_SYS_POWERDOWN];
-};
-
-struct exynos_pmu_data {
-	const struct exynos_pmu_conf *pmu_config;
-	const struct exynos_pmu_conf_extra *pmu_config_extra;
-
-	void (*pmu_init)(void);
-	void (*powerdown_conf)(enum sys_powerdown);
-	void (*powerdown_conf_extra)(enum sys_powerdown);
-	void (*powerup_conf)(enum sys_powerdown);
-};
+#include "exynos-pmu.h"
 
 struct exynos_pmu_context {
 	struct device *dev;
 	const struct exynos_pmu_data *pmu_data;
 };
 
-static void __iomem *pmu_base_addr;
 static struct exynos_pmu_context *pmu_context;
-extern u32 exynos_get_eint_wake_mask(void);
-
-static inline void pmu_raw_writel(u32 val, u32 offset)
-{
-	writel_relaxed(val, pmu_base_addr + offset);
-}
-
-static inline u32 pmu_raw_readl(u32 offset)
-{
-	return readl_relaxed(pmu_base_addr + offset);
-}
-
-static struct exynos_pmu_conf exynos3250_pmu_config[] = {
-	/* { .offset = offset, .val = { AFTR, W-AFTR, SLEEP } */
-	{ EXYNOS3_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS3_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS3_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
-	{ EXYNOS3_ARM_CORE1_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS3_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS3_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
-	{ EXYNOS3_ISP_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS3_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS3_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS3_ARM_L2_SYS_PWR_REG,			{ 0x0, 0x0, 0x3} },
-	{ EXYNOS3_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_DRAM_FREQ_DOWN_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_DDRPHY_DLLOFF_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_LPDDR_PHY_DLL_LOCK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_CMU_ACLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_SCLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_APLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_MPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_BPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_VPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_EPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_UPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_EPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_MPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_BPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_TOP_BUS_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS3_TOP_RETENTION_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_TOP_PWR_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
-	{ EXYNOS3_TOP_BUS_COREBLK_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS3_TOP_RETENTION_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_TOP_PWR_COREBLK_SYS_PWR_REG,		{ 0x3, 0x3, 0x3} },
-	{ EXYNOS3_LOGIC_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_OSCCLK_GATE_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_LOGIC_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_OSCCLK_GATE_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS3_PAD_RETENTION_DRAM_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_GPIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_UART_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_MMC0_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_MMC1_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_MMC2_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_SPI_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_EBIA_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_EBIB_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_JTAG_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_ALV_SEL_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_XUSBXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_XXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_EXT_REGULATOR_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_EXT_REGULATOR_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_GPIO_MODE_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_GPIO_MODE_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_TOP_ASB_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_TOP_ASB_ISOLATION_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_TOP_ASB_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_TOP_ASB_ISOLATION_COREBLK_SYS_PWR_REG, { 0x1, 0x1, 0x0} },
-	{ EXYNOS3_CAM_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_MFC_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_G3D_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_LCD0_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_ISP_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_MAUDIO_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_CMU_SYSCLK_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ PMU_TABLE_END,},
-};
-
-static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
-	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
-	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_CORE1_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE1,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL1,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_COMMON_LOWPWR,		{ 0x0, 0x0, 0x2 } },
-	{ S5P_L2_0_LOWPWR,			{ 0x2, 0x2, 0x3 } },
-	{ S5P_L2_1_LOWPWR,			{ 0x2, 0x2, 0x3 } },
-	{ S5P_CMU_ACLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_SCLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_APLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_MPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_VPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_EPLL_SYSCLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_GPSALIVE_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_CAM_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_TV_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_MFC_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_G3D_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_LCD0_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_LCD1_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_GPS_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_CAM_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_TV_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_MFC_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_G3D_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_LCD0_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_LCD1_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_GPS_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_TOP_BUS_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_TOP_RETENTION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
-	{ S5P_TOP_PWR_LOWPWR,			{ 0x3, 0x0, 0x3 } },
-	{ S5P_LOGIC_RESET_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_ONENAND_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_MODIMIF_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_G2D_ACP_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_USBOTG_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_HSMMC_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_CSSYS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_SECSS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_PCIE_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_SATA_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_DRAM_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_PAD_RETENTION_GPIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_UART_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MMCA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MMCB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_EBIA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_EBIB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_ISOLATION_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_ALV_SEL_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_XUSBXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_XXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_EXT_REGULATOR_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_GPIO_MODE_LOWPWR,			{ 0x1, 0x0, 0x0 } },
-	{ S5P_GPIO_MODE_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CAM_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_TV_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_MFC_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_G3D_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_LCD0_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_LCD1_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_MAUDIO_LOWPWR,			{ 0x7, 0x7, 0x0 } },
-	{ S5P_GPS_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_GPS_ALIVE_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ PMU_TABLE_END,},
-};
-
-static const struct exynos_pmu_conf exynos4x12_pmu_config[] = {
-	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_CORE1_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE1,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL1,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ISP_ARM_LOWPWR,			{ 0x1, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR,	{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR,	{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_COMMON_LOWPWR,		{ 0x0, 0x0, 0x2 } },
-	{ S5P_L2_0_LOWPWR,			{ 0x0, 0x0, 0x3 } },
-	/* XXX_OPTION register should be set other field */
-	{ S5P_ARM_L2_0_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_L2_1_LOWPWR,			{ 0x0, 0x0, 0x3 } },
-	{ S5P_ARM_L2_1_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_CMU_ACLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_SCLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_DRAM_FREQ_DOWN_LOWPWR,		{ 0x1, 0x1, 0x1 } },
-	{ S5P_DDRPHY_DLLOFF_LOWPWR,		{ 0x1, 0x1, 0x1 } },
-	{ S5P_LPDDR_PHY_DLL_LOCK_LOWPWR,	{ 0x1, 0x1, 0x1 } },
-	{ S5P_CMU_ACLKSTOP_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_SCLKSTOP_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_COREBLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_APLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_MPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_VPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_EPLL_SYSCLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_MPLLUSER_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_GPSALIVE_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_CAM_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_TV_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_MFC_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_G3D_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_LCD0_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_MAUDIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_CAM_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_TV_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_MFC_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_G3D_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_LCD0_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_TOP_BUS_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_TOP_RETENTION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
-	{ S5P_TOP_PWR_LOWPWR,			{ 0x3, 0x0, 0x3 } },
-	{ S5P_TOP_BUS_COREBLK_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_TOP_RETENTION_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x1 } },
-	{ S5P_TOP_PWR_COREBLK_LOWPWR,		{ 0x3, 0x0, 0x3 } },
-	{ S5P_LOGIC_RESET_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_OSCCLK_GATE_LOWPWR,		{ 0x1, 0x0, 0x1 } },
-	{ S5P_LOGIC_RESET_COREBLK_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_OSCCLK_GATE_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x1 } },
-	{ S5P_ONENAND_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_ONENAND_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
-	{ S5P_HSI_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_HSI_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_G2D_ACP_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_G2D_ACP_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
-	{ S5P_USBOTG_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_USBOTG_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
-	{ S5P_HSMMC_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_HSMMC_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_CSSYS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_CSSYS_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_SECSS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_SECSS_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_ROTATOR_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_ROTATOR_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
-	{ S5P_PAD_RETENTION_DRAM_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_PAD_RETENTION_GPIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_UART_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MMCA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MMCB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_EBIA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_EBIB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR,{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_ISOLATION_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_ISOLATION_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_ALV_SEL_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_XUSBXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_XXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_EXT_REGULATOR_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_GPIO_MODE_LOWPWR,			{ 0x1, 0x0, 0x0 } },
-	{ S5P_GPIO_MODE_COREBLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_GPIO_MODE_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_TOP_ASB_RESET_LOWPWR,		{ 0x1, 0x1, 0x1 } },
-	{ S5P_TOP_ASB_ISOLATION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
-	{ S5P_CAM_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_TV_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_MFC_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_G3D_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_LCD0_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_ISP_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_MAUDIO_LOWPWR,			{ 0x7, 0x7, 0x0 } },
-	{ S5P_GPS_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_GPS_ALIVE_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_CMU_SYSCLK_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_SYSCLK_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ PMU_TABLE_END,},
-};
-
-static const struct exynos_pmu_conf_extra exynos4412_pmu_config[] = {
-	{ S5P_ARM_CORE2_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE2,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL2,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_CORE3_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE3,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL3,			{ 0x0, 0x0, 0x0 } },
-	{ PMU_TABLE_END,},
-};
-
-static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
-	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
-	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_ARM_CORE1_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_FSYS_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_ISP_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS5_ARM_L2_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
-	{ EXYNOS5_ARM_L2_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_APLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_TOP_BUS_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_TOP_RETENTION_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_TOP_PWR_SYS_PWR_REG,			{ 0x3, 0x0, 0x3} },
-	{ EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x3} },
-	{ EXYNOS5_LOGIC_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_OSCCLK_GATE_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_USBOTG_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_G2D_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_USBDRD_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_SDMMC_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_CSSYS_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_SECSS_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_ROTATOR_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_INTRAM_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_INTROM_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_JPEG_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_JPEG_MEM_OPTION,			{ 0x10, 0x10, 0x0} },
-	{ EXYNOS5_HSI_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_MCUIOP_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_SATA_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_XUSBXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_XXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_EXT_REGULATOR_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_GPIO_MODE_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_GSCL_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_ISP_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_MFC_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_G3D_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_DISP1_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_MAU_SYS_PWR_REG,			{ 0x7, 0x7, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ PMU_TABLE_END,},
-};
-
-static struct exynos_pmu_conf exynos5420_pmu_config[] = {
-	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
-	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_ARM_CORE1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_ARM_CORE2_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_ARM_CORE2_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_ARM_CORE2_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_ARM_CORE3_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_ARM_CORE3_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_ARM_CORE3_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_KFC_CORE0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_KFC_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_KFC_CORE0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_KFC_CORE1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_KFC_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_KFC_CORE1_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_KFC_CORE2_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_KFC_CORE2_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_KFC_CORE2_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_KFC_CORE3_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_KFC_CORE3_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_DIS_IRQ_KFC_CORE3_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_ISP_ARM_SYS_PWR_REG,				{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_ARM_COMMON_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_KFC_COMMON_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_ARM_L2_SYS_PWR_REG,				{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_KFC_L2_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG,			{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG,			{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG,			{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_APLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_DPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_IPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_KPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_RPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_SPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_TOP_BUS_SYS_PWR_REG,				{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_TOP_RETENTION_SYS_PWR_REG,			{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_TOP_PWR_SYS_PWR_REG,				{ 0x3, 0x3, 0x0} },
-	{ EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_LOGIC_RESET_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_OSCCLK_GATE_SYS_PWR_REG,			{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_INTRAM_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x3} },
-	{ EXYNOS5420_INTROM_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x3} },
-	{ EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_JTAG_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_DRAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_UART_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_MMC0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_MMC1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_MMC2_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_HSI_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_EBIA_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_EBIB_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_SPI_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5420_PAD_RETENTION_DRAM_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_ISOLATION_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_XUSBXTI_SYS_PWR_REG,				{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_XXTI_SYS_PWR_REG,				{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_EXT_REGULATOR_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_GPIO_MODE_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_GSCL_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_ISP_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_MFC_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_G3D_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5420_DISP1_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5420_MAU_SYS_PWR_REG,				{ 0x7, 0x7, 0x0} },
-	{ EXYNOS5420_G2D_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5420_MSC_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5420_FSYS_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5420_FSYS2_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5420_PSGEN_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5420_PERIC_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5420_WCORE_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_CLKSTOP_DISP1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_CLKSTOP_MAU_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_CLKSTOP_G2D_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_CLKSTOP_MSC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_CLKSTOP_FSYS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_CLKSTOP_PSGEN_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_CLKSTOP_PERIC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_CLKSTOP_WCORE_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_SYSCLK_DISP1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_SYSCLK_MAU_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_SYSCLK_G2D_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_SYSCLK_MSC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_SYSCLK_FSYS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_SYSCLK_FSYS2_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_SYSCLK_PSGEN_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_SYSCLK_PERIC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_SYSCLK_WCORE_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_RESET_FSYS2_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_RESET_PSGEN_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_RESET_PERIC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_RESET_WCORE_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_RESET_DISP1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_RESET_MAU_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_RESET_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_RESET_MSC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5420_CMU_RESET_FSYS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
-	{ PMU_TABLE_END,},
-};
-
-static unsigned int const exynos3250_list_feed[] = {
-	EXYNOS3_ARM_CORE_OPTION(0),
-	EXYNOS3_ARM_CORE_OPTION(1),
-	EXYNOS3_ARM_CORE_OPTION(2),
-	EXYNOS3_ARM_CORE_OPTION(3),
-	EXYNOS3_ARM_COMMON_OPTION,
-	EXYNOS3_TOP_PWR_OPTION,
-	EXYNOS3_CORE_TOP_PWR_OPTION,
-	S5P_CAM_OPTION,
-	S5P_MFC_OPTION,
-	S5P_G3D_OPTION,
-	S5P_LCD0_OPTION,
-	S5P_ISP_OPTION,
-};
-
-static void exynos3250_powerdown_conf_extra(enum sys_powerdown mode)
-{
-	unsigned int i;
-	unsigned int tmp;
-
-	/* Enable only SC_FEEDBACK */
-	for (i = 0; i < ARRAY_SIZE(exynos3250_list_feed); i++) {
-		tmp = pmu_raw_readl(exynos3250_list_feed[i]);
-		tmp &= ~(EXYNOS3_OPTION_USE_SC_COUNTER);
-		tmp |= EXYNOS3_OPTION_USE_SC_FEEDBACK;
-		pmu_raw_writel(tmp, exynos3250_list_feed[i]);
-	}
-
-	if (mode != SYS_SLEEP)
-		return;
-
-	pmu_raw_writel(XUSBXTI_DURATION, EXYNOS3_XUSBXTI_DURATION);
-	pmu_raw_writel(XXTI_DURATION, EXYNOS3_XXTI_DURATION);
-	pmu_raw_writel(EXT_REGULATOR_DURATION, EXYNOS3_EXT_REGULATOR_DURATION);
-	pmu_raw_writel(EXT_REGULATOR_COREBLK_DURATION,
-		       EXYNOS3_EXT_REGULATOR_COREBLK_DURATION);
-}
-
-static const struct exynos_pmu_conf exynos7_pmu_config[] = {
-	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } } */
-	{ EXYNOS7_ATLAS_CPU0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU0_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU0_CPUSEQUENCER_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_ATLAS_CPU1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU1_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU1_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU1_CPUSEQUENCER_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_ATLAS_CPU2_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU2_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU2_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU2_CPUSEQUENCER_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_ATLAS_CPU3_SYS_PWR_REG,			{ 0x0, 0x0, 0x8 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU3_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU3_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DIS_IRQ_ATLAS_CPU3_CPUSEQUENCER_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_ATLAS_NONCPU_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_ATLAS_DBG_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_ATLAS_L2_SYS_PWR_REG,				{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_TOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_TOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_TOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CPUCLKSTOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_MIF_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_DDRPHY_DLLLOCK_SYS_PWR_REG,			{ 0x1, 0x1, 0x1 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_TOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_TOP_BUS_SYS_PWR_REG,				{ 0x7, 0x0, 0x0 } },
-	{ EXYNOS7_TOP_RETENTION_SYS_PWR_REG,			{ 0x1, 0x0, 0x1 } },
-	{ EXYNOS7_TOP_PWR_SYS_PWR_REG,				{ 0x3, 0x0, 0x3 } },
-	{ EXYNOS7_TOP_BUS_MIF_SYS_PWR_REG,			{ 0x7, 0x0, 0x0 } },
-	{ EXYNOS7_TOP_RETENTION_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x1 } },
-	{ EXYNOS7_TOP_PWR_MIF_SYS_PWR_REG,			{ 0x3, 0x0, 0x3 } },
-	{ EXYNOS7_RET_OSCCLK_GATE_SYS_PWR_REG,			{ 0x1, 0x0, 0x1 } },
-	{ EXYNOS7_LOGIC_RESET_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_OSCCLK_GATE_SYS_PWR_REG,			{ 0x1, 0x0, 0x1 } },
-	{ EXYNOS7_SLEEP_RESET_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_LOGIC_RESET_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_OSCCLK_GATE_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x1 } },
-	{ EXYNOS7_SLEEP_RESET_MIF_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_RET_OSCCLK_GATE_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x1 } },
-	{ EXYNOS7_MEMORY_TOP_SYS_PWR_REG,			{ 0x3, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_TOP_ALV_SYS_PWR_REG,			{ 0x3, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_LPDDR4_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_AUD_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_JTAG_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_MMC2_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_TOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_UART_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_MMC0_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_MMC1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_EBIA_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_EBIB_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_SPI_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_ISOLATION_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_LLI_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_UFS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_ISOLATION_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_RETENTION_FSYSGENIO_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_PAD_ALV_SEL_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_XXTI_SYS_PWR_REG,				{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_XXTI26_SYS_PWR_REG,				{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_EXT_REGULATOR_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_GPIO_MODE_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_GPIO_MODE_FSYS0_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_GPIO_MODE_FSYS1_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_GPIO_MODE_BUS0_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_GPIO_MODE_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_GPIO_MODE_AUD_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_ATLAS_SYS_PWR_REG,				{ 0xF, 0xF, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_ATLAS_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_ATLAS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_ATLAS_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_ATLAS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_ATLAS_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_ATLAS_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_SLEEP_ATLAS_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_AUD_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_BUS0_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_CAM0_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_CAM1_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_DISP_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_FSYS0_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_FSYS1_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_G2D_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_G3D_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_HEVC_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_ISP0_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_ISP1_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_MFC_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_MSCL_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_VPP_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_AUD_SYS_PWR_REG,			{ 0x0, 0x1, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_BUS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_FSYS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_FSYS1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKRUN_CMU_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_AUD_SYS_PWR_REG,			{ 0x0, 0x1, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_BUS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_FSYS0_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_FSYS1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_CLKSTOP_CMU_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_AUD_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_BUS0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_DISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_FSYS0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_FSYS1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_G2D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_HEVC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_ISP0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_ISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_MSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_DISABLE_PLL_CMU_VPP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_AUD_SYS_PWR_REG,			{ 0x0, 0x1, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_BUS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_FSYS0_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_FSYS1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_LOGIC_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_AUD_SYS_PWR_REG,			{ 0x0, 0x3, 0x0 } },
-	{ EXYNOS7_MEMORY_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_FSYS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_FSYS1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_MEMORY_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_AUD_SYS_PWR_REG,			{ 0x0, 0x1, 0x0 } },
-	{ EXYNOS7_RESET_CMU_BUS0_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_FSYS0_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_FSYS1_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_CMU_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
-	{ EXYNOS7_RESET_SLEEP_BUS0_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_RESET_SLEEP_FSYS0_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
-	{ EXYNOS7_RESET_SLEEP_FSYS1_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
-	{ PMU_TABLE_END, },
-};
-
-/* Extra PMU configurations (provided by hardware team) that are not part
- * of the UM */
-static const struct exynos_pmu_conf_extra exynos7_pmu_config_extra[] = {
-	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } } */
-	{ EXYNOS7_PMU_SYNC_CTRL,		{ 0x0,      0x0,        0x0        } },
-	{ EXYNOS7_CENTRAL_SEQ_MIF_OPTION,	{ 0x1000,   0x1000,     0x0        } },
-	{ EXYNOS7_WAKEUP_MASK_MIF,		{ 0x100013, 0x100013,   0x0        } },
-	{ EXYNOS7_ATLAS_NONCPU_OPTION,		{ 0x11,     0x11,       0x11       } },
-	{ EXYNOS7_MEMORY_TOP_OPTION,		{ 0x11,     0x11,       0x1        } },
-	{ EXYNOS7_MEMORY_TOP_ALV_OPTION,	{ 0x11,     0x11,       0x11       } },
-	{ EXYNOS7_RESET_CMU_TOP_OPTION,		{ 0x0,      0x80000000, 0x0        } },
-	{ EXYNOS7_ATLAS_OPTION,			{ 0x101,    0x101,      0x80001101 } },
-	{ EXYNOS7_BUS0_OPTION,			{ 0x101,    0x101,      0x1101     } },
-	{ EXYNOS7_FSYS0_OPTION,			{ 0x101,    0x101,      0x1101     } },
-	{ EXYNOS7_FSYS1_OPTION,			{ 0x101,    0x101,      0x1101     } },
-	{ EXYNOS7_AUD_OPTION,			{ 0x101,    0xC0000101, 0x101      } },
-	{ EXYNOS7_G3D_OPTION,			{ 0x181,    0x181,	0x181      } },
-	{ EXYNOS7_SLEEP_RESET_OPTION,		{ 0x100000, 0x100000,   0x100000   } },
-	{ EXYNOS7_TOP_PWR_OPTION,		{ 0x1,      0x80800002, 0x1        } },
-	{ EXYNOS7_TOP_PWR_MIF_OPTION,		{ 0x1,      0x1,	0x1        } },
-	{ EXYNOS7_LOGIC_RESET_OPTION,		{ 0x0,      0x80000000, 0x0        } },
-	{ EXYNOS7_TOP_RETENTION_OPTION,		{ 0x0,      0x80000000, 0x0        } },
-	{ PMU_TABLE_END, },
-};
-
-static unsigned int const exynos5_list_both_cnt_feed[] = {
-	EXYNOS5_ARM_CORE0_OPTION,
-	EXYNOS5_ARM_CORE1_OPTION,
-	EXYNOS5_ARM_COMMON_OPTION,
-	EXYNOS5_GSCL_OPTION,
-	EXYNOS5_ISP_OPTION,
-	EXYNOS5_MFC_OPTION,
-	EXYNOS5_G3D_OPTION,
-	EXYNOS5_DISP1_OPTION,
-	EXYNOS5_MAU_OPTION,
-	EXYNOS5_TOP_PWR_OPTION,
-	EXYNOS5_TOP_PWR_SYSMEM_OPTION,
-};
-
-static unsigned int const exynos5_list_disable_wfi_wfe[] = {
-	EXYNOS5_ARM_CORE1_OPTION,
-	EXYNOS5_FSYS_ARM_OPTION,
-	EXYNOS5_ISP_ARM_OPTION,
-};
-
-static unsigned int const exynos5420_list_disable_pmu_reg[] = {
-	EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG,
-	EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG,
-	EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG,
-	EXYNOS5420_CMU_CLKSTOP_DISP1_SYS_PWR_REG,
-	EXYNOS5420_CMU_CLKSTOP_MAU_SYS_PWR_REG,
-	EXYNOS5420_CMU_CLKSTOP_G2D_SYS_PWR_REG,
-	EXYNOS5420_CMU_CLKSTOP_MSC_SYS_PWR_REG,
-	EXYNOS5420_CMU_CLKSTOP_FSYS_SYS_PWR_REG,
-	EXYNOS5420_CMU_CLKSTOP_PSGEN_SYS_PWR_REG,
-	EXYNOS5420_CMU_CLKSTOP_PERIC_SYS_PWR_REG,
-	EXYNOS5420_CMU_CLKSTOP_WCORE_SYS_PWR_REG,
-	EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG,
-	EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG,
-	EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG,
-	EXYNOS5420_CMU_SYSCLK_DISP1_SYS_PWR_REG,
-	EXYNOS5420_CMU_SYSCLK_MAU_SYS_PWR_REG,
-	EXYNOS5420_CMU_SYSCLK_G2D_SYS_PWR_REG,
-	EXYNOS5420_CMU_SYSCLK_MSC_SYS_PWR_REG,
-	EXYNOS5420_CMU_SYSCLK_FSYS_SYS_PWR_REG,
-	EXYNOS5420_CMU_SYSCLK_FSYS2_SYS_PWR_REG,
-	EXYNOS5420_CMU_SYSCLK_PSGEN_SYS_PWR_REG,
-	EXYNOS5420_CMU_SYSCLK_PERIC_SYS_PWR_REG,
-	EXYNOS5420_CMU_SYSCLK_WCORE_SYS_PWR_REG,
-	EXYNOS5420_CMU_RESET_FSYS2_SYS_PWR_REG,
-	EXYNOS5420_CMU_RESET_PSGEN_SYS_PWR_REG,
-	EXYNOS5420_CMU_RESET_PERIC_SYS_PWR_REG,
-	EXYNOS5420_CMU_RESET_WCORE_SYS_PWR_REG,
-	EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG,
-	EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG,
-	EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG,
-	EXYNOS5420_CMU_RESET_DISP1_SYS_PWR_REG,
-	EXYNOS5420_CMU_RESET_MAU_SYS_PWR_REG,
-	EXYNOS5420_CMU_RESET_G2D_SYS_PWR_REG,
-	EXYNOS5420_CMU_RESET_MSC_SYS_PWR_REG,
-	EXYNOS5420_CMU_RESET_FSYS_SYS_PWR_REG,
-};
-
-static unsigned int const exynos7_list_feed[] = {
-	EXYNOS7_ATLAS_NONCPU_OPTION,
-	EXYNOS7_TOP_PWR_OPTION,
-	EXYNOS7_TOP_PWR_MIF_OPTION,
-	EXYNOS7_AUD_OPTION,
-	EXYNOS7_CAM0_OPTION,
-	EXYNOS7_DISP_OPTION,
-	EXYNOS7_G2D_OPTION,
-	EXYNOS7_G3D_OPTION,
-	EXYNOS7_HEVC_OPTION,
-	EXYNOS7_MSCL_OPTION,
-	EXYNOS7_MFC_OPTION,
-	EXYNOS7_BUS0_OPTION,
-	EXYNOS7_FSYS0_OPTION,
-	EXYNOS7_FSYS1_OPTION,
-	EXYNOS7_ISP0_OPTION,
-	EXYNOS7_ISP1_OPTION,
-	EXYNOS7_VPP_OPTION,
-};
-
-static void exynos5_power_off(void)
-{
-	unsigned int tmp;
-
-	pr_info("Power down.\n");
-	tmp = pmu_raw_readl(EXYNOS_PS_HOLD_CONTROL);
-	tmp ^= (1 << 8);
-	pmu_raw_writel(tmp, EXYNOS_PS_HOLD_CONTROL);
-
-	/* Wait a little so we don't give a false warning below */
-	mdelay(100);
-
-	pr_err("Power down failed, please power off system manually.\n");
-	while (1)
-		;
-}
-
-void exynos5420_powerdown_conf(enum sys_powerdown mode)
-{
-	u32 this_cluster;
-
-	this_cluster = MPIDR_AFFINITY_LEVEL(read_cpuid_mpidr(), 1);
-
-	/*
-	 * set the cluster id to IROM register to ensure that we wake
-	 * up with the current cluster.
-	 */
-	pmu_raw_writel(this_cluster, EXYNOS_IROM_DATA2);
-}
-
-static void exynos5_powerdown_conf(enum sys_powerdown mode)
-{
-	unsigned int i;
-	unsigned int tmp;
-
-	/*
-	 * Enable both SC_FEEDBACK and SC_COUNTER
-	 */
-	for (i = 0; i < ARRAY_SIZE(exynos5_list_both_cnt_feed); i++) {
-		tmp = pmu_raw_readl(exynos5_list_both_cnt_feed[i]);
-		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
-			EXYNOS5_USE_SC_COUNTER);
-		pmu_raw_writel(tmp, exynos5_list_both_cnt_feed[i]);
-	}
-
-	/*
-	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
-	 */
-	tmp = pmu_raw_readl(EXYNOS5_ARM_COMMON_OPTION);
-	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	pmu_raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
-
-	/*
-	 * Disable WFI/WFE on XXX_OPTION
-	 */
-	for (i = 0; i < ARRAY_SIZE(exynos5_list_disable_wfi_wfe); i++) {
-		tmp = pmu_raw_readl(exynos5_list_disable_wfi_wfe[i]);
-		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
-			 EXYNOS5_OPTION_USE_STANDBYWFI);
-		pmu_raw_writel(tmp, exynos5_list_disable_wfi_wfe[i]);
-	}
-}
 
 void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 {
@@ -1007,113 +59,6 @@ void exynos_sys_powerup_conf(enum sys_powerdown mode)
 		pmu_data->powerup_conf(mode);
 }
 
-static void exynos3250_pmu_init(void)
-{
-	unsigned int value;
-
-	/*
-	 * To prevent from issuing new bus request form L2 memory system
-	 * If core status is power down, should be set '1' to L2 power down
-	 */
-	value = pmu_raw_readl(EXYNOS3_ARM_COMMON_OPTION);
-	value |= EXYNOS3_OPTION_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	pmu_raw_writel(value, EXYNOS3_ARM_COMMON_OPTION);
-
-	/* Enable USE_STANDBY_WFI for all CORE */
-	pmu_raw_writel(S5P_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
-
-	/*
-	 * Set PSHOLD port for output high
-	 */
-	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
-	value |= S5P_PS_HOLD_OUTPUT_HIGH;
-	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
-
-	/*
-	 * Enable signal for PSHOLD port
-	 */
-	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
-	value |= S5P_PS_HOLD_EN;
-	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
-}
-
-static void exynos5250_pmu_init(void)
-{
-	unsigned int value;
-	/*
-	 * When SYS_WDTRESET is set, watchdog timer reset request
-	 * is ignored by power management unit.
-	 */
-	value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
-	value &= ~EXYNOS5_SYS_WDTRESET;
-	pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
-
-	value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
-	value &= ~EXYNOS5_SYS_WDTRESET;
-	pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
-}
-
-static void exynos5420_pmu_init(void)
-{
-	unsigned int value;
-	int i;
-
-	/*
-	 * Set the CMU_RESET, CMU_SYSCLK and CMU_CLKSTOP registers
-	 * for local power blocks to Low initially as per Table 8-4:
-	 * "System-Level Power-Down Configuration Registers".
-	 */
-	for (i = 0; i < ARRAY_SIZE(exynos5420_list_disable_pmu_reg); i++)
-		pmu_raw_writel(0, exynos5420_list_disable_pmu_reg[i]);
-
-	/* Enable USE_STANDBY_WFI for all CORE */
-	pmu_raw_writel(EXYNOS5420_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
-
-	value  = pmu_raw_readl(EXYNOS_L2_OPTION(0));
-	value &= ~EXYNOS5_USE_RETENTION;
-	pmu_raw_writel(value, EXYNOS_L2_OPTION(0));
-
-	value = pmu_raw_readl(EXYNOS_L2_OPTION(1));
-	value &= ~EXYNOS5_USE_RETENTION;
-	pmu_raw_writel(value, EXYNOS_L2_OPTION(1));
-
-	/*
-	 * If L2_COMMON is turned off, clocks related to ATB async
-	 * bridge are gated. Thus, when ISP power is gated, LPI
-	 * may get stuck.
-	 */
-	value = pmu_raw_readl(EXYNOS5420_LPI_MASK);
-	value |= EXYNOS5420_ATB_ISP_ARM;
-	pmu_raw_writel(value, EXYNOS5420_LPI_MASK);
-
-	value  = pmu_raw_readl(EXYNOS5420_LPI_MASK1);
-	value |= EXYNOS5420_ATB_KFC;
-	pmu_raw_writel(value, EXYNOS5420_LPI_MASK1);
-
-	/* Prevent issue of new bus request from L2 memory */
-	value = pmu_raw_readl(EXYNOS5420_ARM_COMMON_OPTION);
-	value |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	pmu_raw_writel(value, EXYNOS5420_ARM_COMMON_OPTION);
-
-	value = pmu_raw_readl(EXYNOS5420_KFC_COMMON_OPTION);
-	value |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	pmu_raw_writel(value, EXYNOS5420_KFC_COMMON_OPTION);
-
-	/* This setting is to reduce suspend/resume time */
-	pmu_raw_writel(DUR_WAIT_RESET, EXYNOS5420_LOGIC_RESET_DURATION3);
-
-	/* Serialized CPU wakeup of Eagle */
-	pmu_raw_writel(SPREAD_ENABLE, EXYNOS5420_ARM_INTR_SPREAD_ENABLE);
-
-	pmu_raw_writel(SPREAD_USE_STANDWFI,
-			EXYNOS5420_ARM_INTR_SPREAD_USE_STANDBYWFI);
-
-	pmu_raw_writel(0x1, EXYNOS5420_UP_SCHEDULER);
-
-	pm_power_off = exynos5_power_off;
-	pr_info("EXYNOS5420 PMU initialized\n");
-}
-
 static int pmu_restart_notify(struct notifier_block *this,
 		unsigned long code, void *unused)
 {
@@ -1122,238 +67,11 @@ static int pmu_restart_notify(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static void exynos7_set_wakeupmask(enum sys_powerdown mode)
-{
-	u32 intmask = 0;
-
-	pmu_raw_writel(exynos_get_eint_wake_mask(), EXYNOS7_EINT_WAKEUP_MASK);
-
-	switch (mode) {
-	case SYS_SLEEP:
-		/* BIT(31): deactivate wakeup event monitoring circuit */
-		intmask = 0x7FFFFFFF;
-		break;
-	default:
-		break;
-	}
-	pmu_raw_writel(intmask, EXYNOS7_WAKEUP_MASK);
-	pmu_raw_writel(0xFFFF0000, EXYNOS7_WAKEUP_MASK2);
-	pmu_raw_writel(0xFFFF0000, EXYNOS7_WAKEUP_MASK3);
-}
-
-static void exynos7_clear_wakeupmask(void)
-{
-	pmu_raw_writel(0, EXYNOS7_EINT_WAKEUP_MASK);
-	pmu_raw_writel(0, EXYNOS7_WAKEUP_MASK);
-	pmu_raw_writel(0, EXYNOS7_WAKEUP_MASK2);
-	pmu_raw_writel(0, EXYNOS7_WAKEUP_MASK3);
-}
-
-static void exynos7_pmu_central_seq(bool enable)
-{
-	unsigned int tmp;
-
-	/* central sequencer */
-	tmp = pmu_raw_readl(EXYNOS7_CENTRAL_SEQ_CONFIGURATION);
-	if (enable)
-		tmp &= ~EXYNOS7_CENTRALSEQ_PWR_CFG;
-	else
-		tmp |= EXYNOS7_CENTRALSEQ_PWR_CFG;
-	pmu_raw_writel(tmp, EXYNOS7_CENTRAL_SEQ_CONFIGURATION);
-
-	/* central sequencer MIF */
-	tmp = pmu_raw_readl(EXYNOS7_CENTRAL_SEQ_MIF_CONFIGURATION);
-	if (enable)
-		tmp &= ~EXYNOS7_CENTRALSEQ_PWR_CFG;
-	else
-		tmp |= EXYNOS7_CENTRALSEQ_PWR_CFG;
-	pmu_raw_writel(tmp, EXYNOS7_CENTRAL_SEQ_MIF_CONFIGURATION);
-}
-
-static void exynos7_pmu_pad_retention_release(void)
-{
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_AUD_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_MMC2_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_TOP_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_UART_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_MMC0_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_MMC1_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_EBIA_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_EBIB_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_SPI_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_MIF_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_UFS_OPTION);
-	pmu_raw_writel(PAD_INITIATE_WAKEUP,
-			EXYNOS7_PAD_RETENTION_FSYSGENIO_OPTION);
-}
-
-static void exynos7_powerdown_conf(enum sys_powerdown mode)
-{
-	exynos7_set_wakeupmask(mode);
-	exynos7_pmu_central_seq(true);
-	if (!(pmu_raw_readl(EXYNOS7_PMU_DEBUG) &
-				EXYNOS7_CLKOUT_DISABLE))
-		pmu_raw_writel(0x1, EXYNOS7_XXTI_SYS_PWR_REG);
-}
-
-static void exynos7_show_wakeup_reason(void)
-{
-	unsigned int wakeup_stat;
-
-	wakeup_stat = pmu_raw_readl(EXYNOS7_WAKEUP_STAT);
-
-	if (wakeup_stat & EXYNOS7_WAKEUP_STAT_RTC_ALARM)
-		pr_info("Resume caused by RTC alarm\n");
-	else
-		pr_info("Resume caused by wakeup_stat 0x%08x\n",
-			wakeup_stat);
-}
-
-static void exynos7_powerup_conf(enum sys_powerdown mode)
-{
-	/* Check early wake up*/
-	unsigned int wakeup;
-
-	wakeup = pmu_raw_readl(EXYNOS7_CENTRAL_SEQ_CONFIGURATION);
-	wakeup &= EXYNOS7_CENTRALSEQ_PWR_CFG;
-	if (wakeup)
-		/* Proper wakeup*/
-		exynos7_pmu_pad_retention_release();
-	else
-		/* Early wakeup */
-		exynos7_pmu_central_seq(false);
-
-	exynos7_clear_wakeupmask();
-	exynos7_show_wakeup_reason();
-}
-
-static void exynos7_pmu_init(void)
-{
-	unsigned int cpu;
-	unsigned int tmp, i;
-	struct device_node *node;
-	static void __iomem *atlas_cmu_base;
-
-	 /* Enable only SC_FEEDBACK for the register list */
-	for (i = 0 ; i < ARRAY_SIZE(exynos7_list_feed) ; i++) {
-		tmp = pmu_raw_readl(exynos7_list_feed[i]);
-		tmp &= ~EXYNOS5_USE_SC_COUNTER;
-		tmp |= EXYNOS5_USE_SC_FEEDBACK;
-		pmu_raw_writel(tmp, exynos7_list_feed[i]);
-	}
-
-	/*
-	 * Disable automatic L2 flush, Disable L2 retention and
-	 * Enable STANDBYWFIL2, ACE/ACP
-	 */
-	tmp = pmu_raw_readl(EXYNOS7_ATLAS_L2_OPTION);
-	tmp &= ~(EXYNOS7_USE_AUTO_L2FLUSHREQ | EXYNOS7_USE_RETENTION);
-	tmp |= (EXYNOS7_USE_STANDBYWFIL2 |
-		EXYNOS7_USE_DEACTIVATE_ACE |
-		EXYNOS7_USE_DEACTIVATE_ACP);
-	pmu_raw_writel(tmp, EXYNOS7_ATLAS_L2_OPTION);
-
-	/*
-	 * Enable both SC_COUNTER and SC_FEEDBACK for the CPUs
-	 * Use STANDBYWFI and SMPEN to indicate that core is ready to enter
-	 * low power mode
-	 */
-	for (cpu = 0; cpu < 4; cpu++) {
-		tmp = pmu_raw_readl(EXYNOS7_CPU_OPTION(cpu));
-		tmp |= (EXYNOS5_USE_SC_FEEDBACK | EXYNOS5_USE_SC_COUNTER);
-		tmp |= EXYNOS7_USE_SMPEN;
-		tmp |= EXYNOS7_USE_STANDBYWFI;
-		tmp &= ~EXYNOS7_USE_STANDBYWFE;
-		pmu_raw_writel(tmp, EXYNOS7_CPU_OPTION(cpu));
-
-		tmp = pmu_raw_readl(EXYNOS7_CPU_DURATION(cpu));
-		tmp |= EXYNOS7_DUR_WAIT_RESET;
-		tmp &= ~EXYNOS7_DUR_SCALL;
-		tmp |= EXYNOS7_DUR_SCALL_VALUE;
-		pmu_raw_writel(tmp, EXYNOS7_CPU_DURATION(cpu));
-	}
-
-	/* Skip atlas block power-off during automatic power down sequence */
-	tmp = pmu_raw_readl(EXYNOS7_ATLAS_CPUSEQUENCER_OPTION);
-	tmp |= EXYNOS7_SKIP_BLK_PWR_DOWN;
-	pmu_raw_writel(tmp, EXYNOS7_ATLAS_CPUSEQUENCER_OPTION);
-
-	/* Limit in-rush current during local power up of cores */
-	tmp = pmu_raw_readl(EXYNOS7_UP_SCHEDULER);
-	tmp |= EXYNOS7_ENABLE_ATLAS_CPU;
-	pmu_raw_writel(tmp, EXYNOS7_UP_SCHEDULER);
-
-	/* Enable PS hold and hardware tripping */
-	tmp = pmu_raw_readl(EXYNOS7_PS_HOLD_CONTROL);
-	tmp |= EXYNOS7_PS_HOLD_OUTPUT;
-	tmp |= EXYNOS7_ENABLE_HW_TRIP;
-	pmu_raw_writel(tmp, EXYNOS7_PS_HOLD_CONTROL);
-
-	/* Enable debug area of atlas cpu */
-	tmp = pmu_raw_readl(EXYNOS7_ATLAS_DBG_CONFIGURATION);
-	tmp |= EXYNOS7_DBG_INITIATE_WAKEUP;
-	pmu_raw_writel(tmp, EXYNOS7_ATLAS_DBG_CONFIGURATION);
-
-	/*
-	 * Set clock freeze cycle count to 0 before and after arm clamp or
-	 * reset signal transition
-	 */
-	node = of_find_compatible_node(NULL, NULL,
-				"samsung,exynos7-clock-atlas");
-	if (node) {
-		atlas_cmu_base = of_iomap(node, 0);
-		if (!atlas_cmu_base)
-			return;
-
-		__raw_writel(0x0,
-				atlas_cmu_base + EXYNOS7_CORE_ARMCLK_STOPCTRL);
-		iounmap(atlas_cmu_base);
-	}
-}
-
-static const struct exynos_pmu_data exynos3250_pmu_data = {
-	.pmu_config	= exynos3250_pmu_config,
-	.pmu_init	= exynos3250_pmu_init,
-	.powerdown_conf_extra	= exynos3250_powerdown_conf_extra,
-};
-
-static const struct exynos_pmu_data exynos4210_pmu_data = {
-	.pmu_config	= exynos4210_pmu_config,
-};
-
-static const struct exynos_pmu_data exynos4212_pmu_data = {
-	.pmu_config	= exynos4x12_pmu_config,
-};
-
-static const struct exynos_pmu_data exynos4412_pmu_data = {
-	.pmu_config		= exynos4x12_pmu_config,
-	.pmu_config_extra	= exynos4412_pmu_config,
-};
-
-static const struct exynos_pmu_data exynos5250_pmu_data = {
-	.pmu_config	= exynos5250_pmu_config,
-	.pmu_init	= exynos5250_pmu_init,
-	.powerdown_conf	= exynos5_powerdown_conf,
-};
-
-static struct exynos_pmu_data exynos5420_pmu_data = {
-	.pmu_config	= exynos5420_pmu_config,
-	.pmu_init	= exynos5420_pmu_init,
-	.powerdown_conf	= exynos5420_powerdown_conf,
-};
-
-static const struct exynos_pmu_data exynos7_pmu_data = {
-	.pmu_config		= exynos7_pmu_config,
-	.pmu_init		= exynos7_pmu_init,
-	.pmu_config_extra	= exynos7_pmu_config_extra,
-	.powerdown_conf		= exynos7_powerdown_conf,
-	.powerup_conf		= exynos7_powerup_conf,
-};
-
 /*
  * PMU platform driver and devicetree bindings.
  */
 static const struct of_device_id exynos_pmu_of_device_ids[] = {
+#if IS_ENABLED(CONFIG_ARM)
 	{
 		.compatible = "samsung,exynos3250-pmu",
 		.data = &exynos3250_pmu_data,
@@ -1372,10 +90,14 @@ static const struct of_device_id exynos_pmu_of_device_ids[] = {
 	}, {
 		.compatible = "samsung,exynos5420-pmu",
 		.data = &exynos5420_pmu_data,
-	}, {
+	},
+#endif
+#if IS_ENABLED(CONFIG_ARM64)
+	{
 		.compatible = "samsung,exynos7-pmu",
 		.data = &exynos7_pmu_data,
 	},
+#endif
 	{ /*sentinel*/ },
 };
 
@@ -1428,7 +150,6 @@ static int exynos_pmu_probe(struct platform_device *pdev)
 static struct platform_driver exynos_pmu_driver = {
 	.driver  = {
 		.name   = "exynos-pmu",
-		.owner	= THIS_MODULE,
 		.of_match_table = exynos_pmu_of_device_ids,
 	},
 	.probe = exynos_pmu_probe,
diff --git a/drivers/soc/samsung/exynos-pmu.h b/drivers/soc/samsung/exynos-pmu.h
new file mode 100644
index 0000000..4adc5a3
--- /dev/null
+++ b/drivers/soc/samsung/exynos-pmu.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header for EXYNOS PMU Driver support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOSPMU_H
+#define __EXYNOSPMU_H
+
+#include <linux/io.h>
+
+#define PMU_TABLE_END	(-1U)
+
+static void __iomem *pmu_base_addr;
+
+struct exynos_pmu_conf {
+	unsigned int offset;
+	u8 val[NUM_SYS_POWERDOWN];
+};
+
+struct exynos_pmu_conf_extra {
+	u32 offset;
+	u32 val[NUM_SYS_POWERDOWN];
+};
+
+struct exynos_pmu_data {
+	const struct exynos_pmu_conf *pmu_config;
+	const struct exynos_pmu_conf_extra *pmu_config_extra;
+
+	void (*pmu_init)(void);
+	void (*powerdown_conf)(enum sys_powerdown);
+	void (*powerdown_conf_extra)(enum sys_powerdown);
+	void (*powerup_conf)(enum sys_powerdown);
+};
+
+static inline void pmu_raw_writel(u32 val, u32 offset)
+{
+	writel_relaxed(val, pmu_base_addr + offset);
+}
+
+static inline u32 pmu_raw_readl(u32 offset)
+{
+	return readl_relaxed(pmu_base_addr + offset);
+}
+
+/* list of all exported SoC specific data */
+#if IS_ENABLED(CONFIG_ARM)
+extern const struct exynos_pmu_data exynos3250_pmu_data;
+extern const struct exynos_pmu_data exynos4210_pmu_data;
+extern const struct exynos_pmu_data exynos4212_pmu_data;
+extern const struct exynos_pmu_data exynos4412_pmu_data;
+extern const struct exynos_pmu_data exynos5250_pmu_data;
+extern const struct exynos_pmu_data exynos5420_pmu_data;
+#endif
+#if IS_ENABLED(CONFIG_ARM64)
+extern const struct exynos_pmu_data exynos7_pmu_data;
+#endif
+#endif /* __EXYNOSPMU_H */
diff --git a/drivers/soc/samsung/exynos3250-pmu.c b/drivers/soc/samsung/exynos3250-pmu.c
new file mode 100644
index 0000000..798861d
--- /dev/null
+++ b/drivers/soc/samsung/exynos3250-pmu.c
@@ -0,0 +1,176 @@
+/*
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS3250 - CPU PMU(Power Management Unit) support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bug.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
+
+#include "exynos-pmu.h"
+
+static struct exynos_pmu_conf exynos3250_pmu_config[] = {
+	/* { .offset = offset, .val = { AFTR, W-AFTR, SLEEP } */
+	{ EXYNOS3_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
+	{ EXYNOS3_ARM_CORE1_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
+	{ EXYNOS3_ISP_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS3_ARM_L2_SYS_PWR_REG,			{ 0x0, 0x0, 0x3} },
+	{ EXYNOS3_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_DRAM_FREQ_DOWN_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_DDRPHY_DLLOFF_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_LPDDR_PHY_DLL_LOCK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_CMU_ACLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_SCLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_APLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_MPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_BPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_VPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_EPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_UPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_EPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_MPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_BPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_TOP_BUS_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS3_TOP_RETENTION_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_TOP_PWR_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
+	{ EXYNOS3_TOP_BUS_COREBLK_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS3_TOP_RETENTION_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_TOP_PWR_COREBLK_SYS_PWR_REG,		{ 0x3, 0x3, 0x3} },
+	{ EXYNOS3_LOGIC_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_OSCCLK_GATE_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_LOGIC_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_OSCCLK_GATE_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS3_PAD_RETENTION_DRAM_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_GPIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_UART_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MMC0_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MMC1_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MMC2_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_SPI_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_EBIA_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_EBIB_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_JTAG_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_ALV_SEL_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_XUSBXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_XXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_EXT_REGULATOR_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_EXT_REGULATOR_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_GPIO_MODE_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_GPIO_MODE_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_ISOLATION_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_ISOLATION_COREBLK_SYS_PWR_REG, { 0x1, 0x1, 0x0} },
+	{ EXYNOS3_CAM_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_MFC_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_G3D_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_LCD0_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_ISP_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_MAUDIO_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_CMU_SYSCLK_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ PMU_TABLE_END,},
+};
+
+static unsigned int const exynos3250_list_feed[] = {
+	EXYNOS3_ARM_CORE_OPTION(0),
+	EXYNOS3_ARM_CORE_OPTION(1),
+	EXYNOS3_ARM_CORE_OPTION(2),
+	EXYNOS3_ARM_CORE_OPTION(3),
+	EXYNOS3_ARM_COMMON_OPTION,
+	EXYNOS3_TOP_PWR_OPTION,
+	EXYNOS3_CORE_TOP_PWR_OPTION,
+	S5P_CAM_OPTION,
+	S5P_MFC_OPTION,
+	S5P_G3D_OPTION,
+	S5P_LCD0_OPTION,
+	S5P_ISP_OPTION,
+};
+
+static void exynos3250_powerdown_conf_extra(enum sys_powerdown mode)
+{
+	unsigned int i;
+	unsigned int tmp;
+
+	/* Enable only SC_FEEDBACK */
+	for (i = 0; i < ARRAY_SIZE(exynos3250_list_feed); i++) {
+		tmp = pmu_raw_readl(exynos3250_list_feed[i]);
+		tmp &= ~(EXYNOS3_OPTION_USE_SC_COUNTER);
+		tmp |= EXYNOS3_OPTION_USE_SC_FEEDBACK;
+		pmu_raw_writel(tmp, exynos3250_list_feed[i]);
+	}
+
+	if (mode != SYS_SLEEP)
+		return;
+
+	pmu_raw_writel(XUSBXTI_DURATION, EXYNOS3_XUSBXTI_DURATION);
+	pmu_raw_writel(XXTI_DURATION, EXYNOS3_XXTI_DURATION);
+	pmu_raw_writel(EXT_REGULATOR_DURATION, EXYNOS3_EXT_REGULATOR_DURATION);
+	pmu_raw_writel(EXT_REGULATOR_COREBLK_DURATION,
+		       EXYNOS3_EXT_REGULATOR_COREBLK_DURATION);
+}
+
+static void exynos3250_pmu_init(void)
+{
+	unsigned int value;
+
+	/*
+	 * To prevent from issuing new bus request form L2 memory system
+	 * If core status is power down, should be set '1' to L2 power down
+	 */
+	value = pmu_raw_readl(EXYNOS3_ARM_COMMON_OPTION);
+	value |= EXYNOS3_OPTION_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
+	pmu_raw_writel(value, EXYNOS3_ARM_COMMON_OPTION);
+
+	/* Enable USE_STANDBY_WFI for all CORE */
+	pmu_raw_writel(S5P_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
+
+	/*
+	 * Set PSHOLD port for output high
+	 */
+	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
+	value |= S5P_PS_HOLD_OUTPUT_HIGH;
+	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
+
+	/*
+	 * Enable signal for PSHOLD port
+	 */
+	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
+	value |= S5P_PS_HOLD_EN;
+	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
+}
+
+const struct exynos_pmu_data exynos3250_pmu_data = {
+	.pmu_config		= exynos3250_pmu_config,
+	.pmu_init		= exynos3250_pmu_init,
+	.powerdown_conf_extra	= exynos3250_powerdown_conf_extra,
+};
diff --git a/drivers/soc/samsung/exynos4-pmu.c b/drivers/soc/samsung/exynos4-pmu.c
new file mode 100644
index 0000000..68a3243
--- /dev/null
+++ b/drivers/soc/samsung/exynos4-pmu.c
@@ -0,0 +1,223 @@
+/*
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS4 - CPU PMU(Power Management Unit) support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bug.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
+
+#include "exynos-pmu.h"
+
+static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
+	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
+	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_CORE1_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE1,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL1,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_COMMON_LOWPWR,		{ 0x0, 0x0, 0x2 } },
+	{ S5P_L2_0_LOWPWR,			{ 0x2, 0x2, 0x3 } },
+	{ S5P_L2_1_LOWPWR,			{ 0x2, 0x2, 0x3 } },
+	{ S5P_CMU_ACLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_SCLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_APLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_MPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_VPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_EPLL_SYSCLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_GPSALIVE_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_CAM_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_TV_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_MFC_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_G3D_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_LCD0_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_LCD1_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_GPS_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_CAM_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_TV_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_MFC_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_G3D_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_LCD0_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_LCD1_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_GPS_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_TOP_BUS_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_TOP_RETENTION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
+	{ S5P_TOP_PWR_LOWPWR,			{ 0x3, 0x0, 0x3 } },
+	{ S5P_LOGIC_RESET_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_ONENAND_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_MODIMIF_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_G2D_ACP_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_USBOTG_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_HSMMC_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_CSSYS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_SECSS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_PCIE_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_SATA_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_DRAM_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_PAD_RETENTION_GPIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_UART_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MMCA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MMCB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_EBIA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_EBIB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_ISOLATION_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_ALV_SEL_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_XUSBXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_XXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_EXT_REGULATOR_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_GPIO_MODE_LOWPWR,			{ 0x1, 0x0, 0x0 } },
+	{ S5P_GPIO_MODE_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CAM_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_TV_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_MFC_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_G3D_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_LCD0_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_LCD1_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_MAUDIO_LOWPWR,			{ 0x7, 0x7, 0x0 } },
+	{ S5P_GPS_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_GPS_ALIVE_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ PMU_TABLE_END,},
+};
+
+static const struct exynos_pmu_conf exynos4x12_pmu_config[] = {
+	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_CORE1_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE1,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL1,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ISP_ARM_LOWPWR,			{ 0x1, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR,	{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR,	{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_COMMON_LOWPWR,		{ 0x0, 0x0, 0x2 } },
+	{ S5P_L2_0_LOWPWR,			{ 0x0, 0x0, 0x3 } },
+	/* XXX_OPTION register should be set other field */
+	{ S5P_ARM_L2_0_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_L2_1_LOWPWR,			{ 0x0, 0x0, 0x3 } },
+	{ S5P_ARM_L2_1_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_CMU_ACLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_SCLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_DRAM_FREQ_DOWN_LOWPWR,		{ 0x1, 0x1, 0x1 } },
+	{ S5P_DDRPHY_DLLOFF_LOWPWR,		{ 0x1, 0x1, 0x1 } },
+	{ S5P_LPDDR_PHY_DLL_LOCK_LOWPWR,	{ 0x1, 0x1, 0x1 } },
+	{ S5P_CMU_ACLKSTOP_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_SCLKSTOP_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_COREBLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_APLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_MPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_VPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_EPLL_SYSCLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_MPLLUSER_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_GPSALIVE_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_CAM_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_TV_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_MFC_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_G3D_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_LCD0_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_MAUDIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_CAM_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_TV_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_MFC_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_G3D_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_LCD0_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_TOP_BUS_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_TOP_RETENTION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
+	{ S5P_TOP_PWR_LOWPWR,			{ 0x3, 0x0, 0x3 } },
+	{ S5P_TOP_BUS_COREBLK_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_TOP_RETENTION_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x1 } },
+	{ S5P_TOP_PWR_COREBLK_LOWPWR,		{ 0x3, 0x0, 0x3 } },
+	{ S5P_LOGIC_RESET_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_OSCCLK_GATE_LOWPWR,		{ 0x1, 0x0, 0x1 } },
+	{ S5P_LOGIC_RESET_COREBLK_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_OSCCLK_GATE_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x1 } },
+	{ S5P_ONENAND_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_ONENAND_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
+	{ S5P_HSI_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_HSI_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_G2D_ACP_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_G2D_ACP_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
+	{ S5P_USBOTG_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_USBOTG_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
+	{ S5P_HSMMC_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_HSMMC_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_CSSYS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_CSSYS_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_SECSS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_SECSS_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_ROTATOR_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_ROTATOR_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
+	{ S5P_PAD_RETENTION_DRAM_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_PAD_RETENTION_GPIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_UART_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MMCA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MMCB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_EBIA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_EBIB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR,{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_ISOLATION_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_ISOLATION_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_ALV_SEL_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_XUSBXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_XXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_EXT_REGULATOR_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_GPIO_MODE_LOWPWR,			{ 0x1, 0x0, 0x0 } },
+	{ S5P_GPIO_MODE_COREBLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_GPIO_MODE_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_TOP_ASB_RESET_LOWPWR,		{ 0x1, 0x1, 0x1 } },
+	{ S5P_TOP_ASB_ISOLATION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
+	{ S5P_CAM_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_TV_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_MFC_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_G3D_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_LCD0_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_ISP_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_MAUDIO_LOWPWR,			{ 0x7, 0x7, 0x0 } },
+	{ S5P_GPS_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_GPS_ALIVE_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_CMU_SYSCLK_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_SYSCLK_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ PMU_TABLE_END,},
+};
+
+static const struct exynos_pmu_conf_extra exynos4412_pmu_config[] = {
+	{ S5P_ARM_CORE2_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE2,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL2,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_CORE3_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE3,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL3,			{ 0x0, 0x0, 0x0 } },
+	{ PMU_TABLE_END,},
+};
+
+const struct exynos_pmu_data exynos4210_pmu_data = {
+	.pmu_config	= exynos4210_pmu_config,
+};
+
+const struct exynos_pmu_data exynos4212_pmu_data = {
+	.pmu_config	= exynos4x12_pmu_config,
+};
+
+const struct exynos_pmu_data exynos4412_pmu_data = {
+	.pmu_config		= exynos4x12_pmu_config,
+	.pmu_config_extra	= exynos4412_pmu_config,
+};
diff --git a/drivers/soc/samsung/exynos5250-pmu.c b/drivers/soc/samsung/exynos5250-pmu.c
new file mode 100644
index 0000000..b23bbd1
--- /dev/null
+++ b/drivers/soc/samsung/exynos5250-pmu.c
@@ -0,0 +1,196 @@
+/*
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS5250 - CPU PMU(Power Management Unit) support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bug.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
+
+#include "exynos-pmu.h"
+
+static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
+	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
+	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_ARM_CORE1_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_FSYS_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_ISP_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS5_ARM_L2_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
+	{ EXYNOS5_ARM_L2_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_APLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_TOP_BUS_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_TOP_RETENTION_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_TOP_PWR_SYS_PWR_REG,			{ 0x3, 0x0, 0x3} },
+	{ EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x3} },
+	{ EXYNOS5_LOGIC_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_OSCCLK_GATE_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_USBOTG_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_G2D_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_USBDRD_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_SDMMC_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_CSSYS_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_SECSS_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_ROTATOR_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_INTRAM_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_INTROM_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_JPEG_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_JPEG_MEM_OPTION,			{ 0x10, 0x10, 0x0} },
+	{ EXYNOS5_HSI_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_MCUIOP_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_SATA_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_XUSBXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_XXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_EXT_REGULATOR_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_GPIO_MODE_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_GSCL_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_ISP_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_MFC_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_G3D_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_DISP1_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_MAU_SYS_PWR_REG,			{ 0x7, 0x7, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ PMU_TABLE_END,},
+};
+
+static unsigned int const exynos5_list_both_cnt_feed[] = {
+	EXYNOS5_ARM_CORE0_OPTION,
+	EXYNOS5_ARM_CORE1_OPTION,
+	EXYNOS5_ARM_COMMON_OPTION,
+	EXYNOS5_GSCL_OPTION,
+	EXYNOS5_ISP_OPTION,
+	EXYNOS5_MFC_OPTION,
+	EXYNOS5_G3D_OPTION,
+	EXYNOS5_DISP1_OPTION,
+	EXYNOS5_MAU_OPTION,
+	EXYNOS5_TOP_PWR_OPTION,
+	EXYNOS5_TOP_PWR_SYSMEM_OPTION,
+};
+
+static unsigned int const exynos5_list_disable_wfi_wfe[] = {
+	EXYNOS5_ARM_CORE1_OPTION,
+	EXYNOS5_FSYS_ARM_OPTION,
+	EXYNOS5_ISP_ARM_OPTION,
+};
+
+static void exynos5250_powerdown_conf(enum sys_powerdown mode)
+{
+	unsigned int i;
+	unsigned int tmp;
+
+	/*
+	 * Enable both SC_FEEDBACK and SC_COUNTER
+	 */
+	for (i = 0; i < ARRAY_SIZE(exynos5_list_both_cnt_feed); i++) {
+		tmp = pmu_raw_readl(exynos5_list_both_cnt_feed[i]);
+		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
+			EXYNOS5_USE_SC_COUNTER);
+		pmu_raw_writel(tmp, exynos5_list_both_cnt_feed[i]);
+	}
+
+	/*
+	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
+	 */
+	tmp = pmu_raw_readl(EXYNOS5_ARM_COMMON_OPTION);
+	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
+	pmu_raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
+
+	/*
+	 * Disable WFI/WFE on XXX_OPTION
+	 */
+	for (i = 0; i < ARRAY_SIZE(exynos5_list_disable_wfi_wfe); i++) {
+		tmp = pmu_raw_readl(exynos5_list_disable_wfi_wfe[i]);
+		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
+			 EXYNOS5_OPTION_USE_STANDBYWFI);
+		pmu_raw_writel(tmp, exynos5_list_disable_wfi_wfe[i]);
+	}
+}
+
+static void exynos5250_pmu_init(void)
+{
+	unsigned int value;
+	/*
+	 * When SYS_WDTRESET is set, watchdog timer reset request
+	 * is ignored by power management unit.
+	 */
+	value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
+
+	value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
+}
+
+const struct exynos_pmu_data exynos5250_pmu_data = {
+	.pmu_config	= exynos5250_pmu_config,
+	.pmu_init	= exynos5250_pmu_init,
+	.powerdown_conf	= exynos5250_powerdown_conf,
+};
diff --git a/drivers/soc/samsung/exynos5420-pmu.c b/drivers/soc/samsung/exynos5420-pmu.c
new file mode 100644
index 0000000..bfcbff2
--- /dev/null
+++ b/drivers/soc/samsung/exynos5420-pmu.c
@@ -0,0 +1,298 @@
+/*
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS5420 - CPU PMU(Power Management Unit) support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bug.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
+
+#include "exynos-pmu.h"
+
+static struct exynos_pmu_conf exynos5420_pmu_config[] = {
+	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
+	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_ARM_CORE1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_ARM_CORE2_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_ARM_CORE2_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_ARM_CORE2_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_ARM_CORE3_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_ARM_CORE3_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_ARM_CORE3_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_KFC_CORE0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_KFC_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_KFC_CORE0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_KFC_CORE1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_KFC_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_KFC_CORE1_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_KFC_CORE2_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_KFC_CORE2_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_KFC_CORE2_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_KFC_CORE3_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_KFC_CORE3_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_DIS_IRQ_KFC_CORE3_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_ISP_ARM_SYS_PWR_REG,				{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_ARM_COMMON_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_KFC_COMMON_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_ARM_L2_SYS_PWR_REG,				{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_KFC_L2_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG,			{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG,			{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG,			{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_APLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_DPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_IPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_KPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_RPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_SPLL_SYSCLK_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_TOP_BUS_SYS_PWR_REG,				{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_TOP_RETENTION_SYS_PWR_REG,			{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_TOP_PWR_SYS_PWR_REG,				{ 0x3, 0x3, 0x0} },
+	{ EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_LOGIC_RESET_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_OSCCLK_GATE_SYS_PWR_REG,			{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_INTRAM_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x3} },
+	{ EXYNOS5420_INTROM_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x3} },
+	{ EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_JTAG_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_DRAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_UART_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_MMC0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_MMC1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_MMC2_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_HSI_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_EBIA_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_EBIB_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_SPI_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5420_PAD_RETENTION_DRAM_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_ISOLATION_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_XUSBXTI_SYS_PWR_REG,				{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_XXTI_SYS_PWR_REG,				{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_EXT_REGULATOR_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_GPIO_MODE_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_GSCL_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_ISP_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_MFC_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_G3D_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5420_DISP1_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5420_MAU_SYS_PWR_REG,				{ 0x7, 0x7, 0x0} },
+	{ EXYNOS5420_G2D_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5420_MSC_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5420_FSYS_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5420_FSYS2_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5420_PSGEN_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5420_PERIC_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5420_WCORE_SYS_PWR_REG,				{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_CLKSTOP_DISP1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_CLKSTOP_MAU_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_CLKSTOP_G2D_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_CLKSTOP_MSC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_CLKSTOP_FSYS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_CLKSTOP_PSGEN_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_CLKSTOP_PERIC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_CLKSTOP_WCORE_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_SYSCLK_DISP1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_SYSCLK_MAU_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_SYSCLK_G2D_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_SYSCLK_MSC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_SYSCLK_FSYS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_SYSCLK_FSYS2_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_SYSCLK_PSGEN_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_SYSCLK_PERIC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_SYSCLK_WCORE_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_RESET_FSYS2_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_RESET_PSGEN_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_RESET_PERIC_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_RESET_WCORE_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_RESET_DISP1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_RESET_MAU_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_RESET_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_RESET_MSC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5420_CMU_RESET_FSYS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0} },
+	{ PMU_TABLE_END,},
+};
+
+static unsigned int const exynos5420_list_disable_pmu_reg[] = {
+	EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG,
+	EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG,
+	EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG,
+	EXYNOS5420_CMU_CLKSTOP_DISP1_SYS_PWR_REG,
+	EXYNOS5420_CMU_CLKSTOP_MAU_SYS_PWR_REG,
+	EXYNOS5420_CMU_CLKSTOP_G2D_SYS_PWR_REG,
+	EXYNOS5420_CMU_CLKSTOP_MSC_SYS_PWR_REG,
+	EXYNOS5420_CMU_CLKSTOP_FSYS_SYS_PWR_REG,
+	EXYNOS5420_CMU_CLKSTOP_PSGEN_SYS_PWR_REG,
+	EXYNOS5420_CMU_CLKSTOP_PERIC_SYS_PWR_REG,
+	EXYNOS5420_CMU_CLKSTOP_WCORE_SYS_PWR_REG,
+	EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG,
+	EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG,
+	EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG,
+	EXYNOS5420_CMU_SYSCLK_DISP1_SYS_PWR_REG,
+	EXYNOS5420_CMU_SYSCLK_MAU_SYS_PWR_REG,
+	EXYNOS5420_CMU_SYSCLK_G2D_SYS_PWR_REG,
+	EXYNOS5420_CMU_SYSCLK_MSC_SYS_PWR_REG,
+	EXYNOS5420_CMU_SYSCLK_FSYS_SYS_PWR_REG,
+	EXYNOS5420_CMU_SYSCLK_FSYS2_SYS_PWR_REG,
+	EXYNOS5420_CMU_SYSCLK_PSGEN_SYS_PWR_REG,
+	EXYNOS5420_CMU_SYSCLK_PERIC_SYS_PWR_REG,
+	EXYNOS5420_CMU_SYSCLK_WCORE_SYS_PWR_REG,
+	EXYNOS5420_CMU_RESET_FSYS2_SYS_PWR_REG,
+	EXYNOS5420_CMU_RESET_PSGEN_SYS_PWR_REG,
+	EXYNOS5420_CMU_RESET_PERIC_SYS_PWR_REG,
+	EXYNOS5420_CMU_RESET_WCORE_SYS_PWR_REG,
+	EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG,
+	EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG,
+	EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG,
+	EXYNOS5420_CMU_RESET_DISP1_SYS_PWR_REG,
+	EXYNOS5420_CMU_RESET_MAU_SYS_PWR_REG,
+	EXYNOS5420_CMU_RESET_G2D_SYS_PWR_REG,
+	EXYNOS5420_CMU_RESET_MSC_SYS_PWR_REG,
+	EXYNOS5420_CMU_RESET_FSYS_SYS_PWR_REG,
+};
+
+void exynos5420_powerdown_conf(enum sys_powerdown mode)
+{
+	u32 this_cluster;
+
+	this_cluster = MPIDR_AFFINITY_LEVEL(read_cpuid_mpidr(), 1);
+
+	/*
+	 * set the cluster id to IROM register to ensure that we wake
+	 * up with the current cluster.
+	 */
+	pmu_raw_writel(this_cluster, EXYNOS_IROM_DATA2);
+}
+
+static void exynos5_power_off(void)
+{
+	unsigned int tmp;
+
+	pr_info("Power down.\n");
+	tmp = pmu_raw_readl(EXYNOS_PS_HOLD_CONTROL);
+	tmp ^= (1 << 8);
+	pmu_raw_writel(tmp, EXYNOS_PS_HOLD_CONTROL);
+
+	/* Wait a little so we don't give a false warning below */
+	mdelay(100);
+
+	pr_err("Power down failed, please power off system manually.\n");
+	while (1)
+		;
+}
+
+static void exynos5420_pmu_init(void)
+{
+	unsigned int value;
+	int i;
+
+	/*
+	 * Set the CMU_RESET, CMU_SYSCLK and CMU_CLKSTOP registers
+	 * for local power blocks to Low initially as per Table 8-4:
+	 * "System-Level Power-Down Configuration Registers".
+	 */
+	for (i = 0; i < ARRAY_SIZE(exynos5420_list_disable_pmu_reg); i++)
+		pmu_raw_writel(0, exynos5420_list_disable_pmu_reg[i]);
+
+	/* Enable USE_STANDBY_WFI for all CORE */
+	pmu_raw_writel(EXYNOS5420_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
+
+	value  = pmu_raw_readl(EXYNOS_L2_OPTION(0));
+	value &= ~EXYNOS5_USE_RETENTION;
+	pmu_raw_writel(value, EXYNOS_L2_OPTION(0));
+
+	value = pmu_raw_readl(EXYNOS_L2_OPTION(1));
+	value &= ~EXYNOS5_USE_RETENTION;
+	pmu_raw_writel(value, EXYNOS_L2_OPTION(1));
+
+	/*
+	 * If L2_COMMON is turned off, clocks related to ATB async
+	 * bridge are gated. Thus, when ISP power is gated, LPI
+	 * may get stuck.
+	 */
+	value = pmu_raw_readl(EXYNOS5420_LPI_MASK);
+	value |= EXYNOS5420_ATB_ISP_ARM;
+	pmu_raw_writel(value, EXYNOS5420_LPI_MASK);
+
+	value  = pmu_raw_readl(EXYNOS5420_LPI_MASK1);
+	value |= EXYNOS5420_ATB_KFC;
+	pmu_raw_writel(value, EXYNOS5420_LPI_MASK1);
+
+	/* Prevent issue of new bus request from L2 memory */
+	value = pmu_raw_readl(EXYNOS5420_ARM_COMMON_OPTION);
+	value |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
+	pmu_raw_writel(value, EXYNOS5420_ARM_COMMON_OPTION);
+
+	value = pmu_raw_readl(EXYNOS5420_KFC_COMMON_OPTION);
+	value |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
+	pmu_raw_writel(value, EXYNOS5420_KFC_COMMON_OPTION);
+
+	/* This setting is to reduce suspend/resume time */
+	pmu_raw_writel(DUR_WAIT_RESET, EXYNOS5420_LOGIC_RESET_DURATION3);
+
+	/* Serialized CPU wakeup of Eagle */
+	pmu_raw_writel(SPREAD_ENABLE, EXYNOS5420_ARM_INTR_SPREAD_ENABLE);
+
+	pmu_raw_writel(SPREAD_USE_STANDWFI,
+			EXYNOS5420_ARM_INTR_SPREAD_USE_STANDBYWFI);
+
+	pmu_raw_writel(0x1, EXYNOS5420_UP_SCHEDULER);
+
+	pm_power_off = exynos5_power_off;
+	pr_info("EXYNOS5420 PMU initialized\n");
+}
+
+const struct exynos_pmu_data exynos5420_pmu_data = {
+	.pmu_config	= exynos5420_pmu_config,
+	.pmu_init	= exynos5420_pmu_init,
+	.powerdown_conf	= exynos5420_powerdown_conf,
+};
diff --git a/drivers/soc/samsung/exynos7-pmu.c b/drivers/soc/samsung/exynos7-pmu.c
new file mode 100644
index 0000000..1870fae
--- /dev/null
+++ b/drivers/soc/samsung/exynos7-pmu.c
@@ -0,0 +1,441 @@
+/*
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS7 - CPU PMU(Power Management Unit) support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bug.h>
+#include <linux/of_address.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
+
+#include "exynos-pmu.h"
+
+extern u32 exynos_get_eint_wake_mask(void);
+
+static const struct exynos_pmu_conf exynos7_pmu_config[] = {
+	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } } */
+	{ EXYNOS7_ATLAS_CPU0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU0_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU0_CPUSEQUENCER_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_ATLAS_CPU1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU1_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU1_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU1_CPUSEQUENCER_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_ATLAS_CPU2_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU2_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU2_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU2_CPUSEQUENCER_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_ATLAS_CPU3_SYS_PWR_REG,			{ 0x0, 0x0, 0x8 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU3_LOCAL_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU3_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DIS_IRQ_ATLAS_CPU3_CPUSEQUENCER_SYS_PWR_REG,	{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_ATLAS_NONCPU_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_ATLAS_DBG_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_ATLAS_L2_SYS_PWR_REG,				{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_TOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_TOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_TOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CPUCLKSTOP_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_MIF_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_DDRPHY_DLLLOCK_SYS_PWR_REG,			{ 0x1, 0x1, 0x1 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_TOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_TOP_BUS_SYS_PWR_REG,				{ 0x7, 0x0, 0x0 } },
+	{ EXYNOS7_TOP_RETENTION_SYS_PWR_REG,			{ 0x1, 0x0, 0x1 } },
+	{ EXYNOS7_TOP_PWR_SYS_PWR_REG,				{ 0x3, 0x0, 0x3 } },
+	{ EXYNOS7_TOP_BUS_MIF_SYS_PWR_REG,			{ 0x7, 0x0, 0x0 } },
+	{ EXYNOS7_TOP_RETENTION_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x1 } },
+	{ EXYNOS7_TOP_PWR_MIF_SYS_PWR_REG,			{ 0x3, 0x0, 0x3 } },
+	{ EXYNOS7_RET_OSCCLK_GATE_SYS_PWR_REG,			{ 0x1, 0x0, 0x1 } },
+	{ EXYNOS7_LOGIC_RESET_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_OSCCLK_GATE_SYS_PWR_REG,			{ 0x1, 0x0, 0x1 } },
+	{ EXYNOS7_SLEEP_RESET_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_LOGIC_RESET_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_OSCCLK_GATE_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x1 } },
+	{ EXYNOS7_SLEEP_RESET_MIF_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_RET_OSCCLK_GATE_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x1 } },
+	{ EXYNOS7_MEMORY_TOP_SYS_PWR_REG,			{ 0x3, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_TOP_ALV_SYS_PWR_REG,			{ 0x3, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_LPDDR4_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_AUD_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_JTAG_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_MMC2_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_TOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_UART_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_MMC0_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_MMC1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_EBIA_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_EBIB_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_SPI_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_ISOLATION_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_LLI_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_UFS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_ISOLATION_MIF_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_RETENTION_FSYSGENIO_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_PAD_ALV_SEL_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_XXTI_SYS_PWR_REG,				{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_XXTI26_SYS_PWR_REG,				{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_EXT_REGULATOR_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_GPIO_MODE_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_GPIO_MODE_FSYS0_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_GPIO_MODE_FSYS1_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_GPIO_MODE_BUS0_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_GPIO_MODE_MIF_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_GPIO_MODE_AUD_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_ATLAS_SYS_PWR_REG,				{ 0xF, 0xF, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_ATLAS_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_ATLAS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_ATLAS_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_ATLAS_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_ATLAS_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_ATLAS_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_SLEEP_ATLAS_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_AUD_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_BUS0_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_CAM0_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_CAM1_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_DISP_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_FSYS0_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_FSYS1_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_G2D_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_G3D_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_HEVC_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_ISP0_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_ISP1_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_MFC_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_MSCL_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_VPP_SYS_PWR_REG,				{ 0xF, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_AUD_SYS_PWR_REG,			{ 0x0, 0x1, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_BUS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_FSYS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_FSYS1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKRUN_CMU_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_AUD_SYS_PWR_REG,			{ 0x0, 0x1, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_BUS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_FSYS0_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_FSYS1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_CLKSTOP_CMU_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_AUD_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_BUS0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_DISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_FSYS0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_FSYS1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_G2D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_HEVC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_ISP0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_ISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_MSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_DISABLE_PLL_CMU_VPP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_AUD_SYS_PWR_REG,			{ 0x0, 0x1, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_BUS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_FSYS0_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_FSYS1_SYS_PWR_REG,		{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_LOGIC_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_AUD_SYS_PWR_REG,			{ 0x0, 0x3, 0x0 } },
+	{ EXYNOS7_MEMORY_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_FSYS0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_FSYS1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_MEMORY_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_AUD_SYS_PWR_REG,			{ 0x0, 0x1, 0x0 } },
+	{ EXYNOS7_RESET_CMU_BUS0_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_DISP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_FSYS0_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_FSYS1_SYS_PWR_REG,			{ 0x1, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_G2D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_G3D_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_HEVC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_ISP0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_ISP1_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_MFC_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_MSCL_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_CMU_VPP_SYS_PWR_REG,			{ 0x0, 0x0, 0x0 } },
+	{ EXYNOS7_RESET_SLEEP_BUS0_SYS_PWR_REG,			{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_RESET_SLEEP_FSYS0_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
+	{ EXYNOS7_RESET_SLEEP_FSYS1_SYS_PWR_REG,		{ 0x1, 0x1, 0x0 } },
+	{ PMU_TABLE_END, },
+};
+
+/* Extra PMU configurations (provided by hardware team) that are not part
+ * of the UM */
+static const struct exynos_pmu_conf_extra exynos7_pmu_config_extra[] = {
+	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } } */
+	{ EXYNOS7_PMU_SYNC_CTRL,		{ 0x0,      0x0,        0x0        } },
+	{ EXYNOS7_CENTRAL_SEQ_MIF_OPTION,	{ 0x1000,   0x1000,     0x0        } },
+	{ EXYNOS7_WAKEUP_MASK_MIF,		{ 0x100013, 0x100013,   0x0        } },
+	{ EXYNOS7_ATLAS_NONCPU_OPTION,		{ 0x11,     0x11,       0x11       } },
+	{ EXYNOS7_MEMORY_TOP_OPTION,		{ 0x11,     0x11,       0x1        } },
+	{ EXYNOS7_MEMORY_TOP_ALV_OPTION,	{ 0x11,     0x11,       0x11       } },
+	{ EXYNOS7_RESET_CMU_TOP_OPTION,		{ 0x0,      0x80000000, 0x0        } },
+	{ EXYNOS7_ATLAS_OPTION,			{ 0x101,    0x101,      0x80001101 } },
+	{ EXYNOS7_BUS0_OPTION,			{ 0x101,    0x101,      0x1101     } },
+	{ EXYNOS7_FSYS0_OPTION,			{ 0x101,    0x101,      0x1101     } },
+	{ EXYNOS7_FSYS1_OPTION,			{ 0x101,    0x101,      0x1101     } },
+	{ EXYNOS7_AUD_OPTION,			{ 0x101,    0xC0000101, 0x101      } },
+	{ EXYNOS7_G3D_OPTION,			{ 0x181,    0x181,	0x181      } },
+	{ EXYNOS7_SLEEP_RESET_OPTION,		{ 0x100000, 0x100000,   0x100000   } },
+	{ EXYNOS7_TOP_PWR_OPTION,		{ 0x1,      0x80800002, 0x1        } },
+	{ EXYNOS7_TOP_PWR_MIF_OPTION,		{ 0x1,      0x1,	0x1        } },
+	{ EXYNOS7_LOGIC_RESET_OPTION,		{ 0x0,      0x80000000, 0x0        } },
+	{ EXYNOS7_TOP_RETENTION_OPTION,		{ 0x0,      0x80000000, 0x0        } },
+	{ PMU_TABLE_END, },
+};
+
+static unsigned int const exynos7_list_feed[] = {
+	EXYNOS7_ATLAS_NONCPU_OPTION,
+	EXYNOS7_TOP_PWR_OPTION,
+	EXYNOS7_TOP_PWR_MIF_OPTION,
+	EXYNOS7_AUD_OPTION,
+	EXYNOS7_CAM0_OPTION,
+	EXYNOS7_DISP_OPTION,
+	EXYNOS7_G2D_OPTION,
+	EXYNOS7_G3D_OPTION,
+	EXYNOS7_HEVC_OPTION,
+	EXYNOS7_MSCL_OPTION,
+	EXYNOS7_MFC_OPTION,
+	EXYNOS7_BUS0_OPTION,
+	EXYNOS7_FSYS0_OPTION,
+	EXYNOS7_FSYS1_OPTION,
+	EXYNOS7_ISP0_OPTION,
+	EXYNOS7_ISP1_OPTION,
+	EXYNOS7_VPP_OPTION,
+};
+
+static void exynos7_set_wakeupmask(enum sys_powerdown mode)
+{
+	u32 intmask = 0;
+
+	pmu_raw_writel(exynos_get_eint_wake_mask(), EXYNOS7_EINT_WAKEUP_MASK);
+
+	switch (mode) {
+	case SYS_SLEEP:
+		/* BIT(31): deactivate wakeup event monitoring circuit */
+		intmask = 0x7FFFFFFF;
+		break;
+	default:
+		break;
+	}
+	pmu_raw_writel(intmask, EXYNOS7_WAKEUP_MASK);
+	pmu_raw_writel(0xFFFF0000, EXYNOS7_WAKEUP_MASK2);
+	pmu_raw_writel(0xFFFF0000, EXYNOS7_WAKEUP_MASK3);
+}
+
+static void exynos7_clear_wakeupmask(void)
+{
+	pmu_raw_writel(0, EXYNOS7_EINT_WAKEUP_MASK);
+	pmu_raw_writel(0, EXYNOS7_WAKEUP_MASK);
+	pmu_raw_writel(0, EXYNOS7_WAKEUP_MASK2);
+	pmu_raw_writel(0, EXYNOS7_WAKEUP_MASK3);
+}
+
+static void exynos7_pmu_central_seq(bool enable)
+{
+	unsigned int tmp;
+
+	/* central sequencer */
+	tmp = pmu_raw_readl(EXYNOS7_CENTRAL_SEQ_CONFIGURATION);
+	if (enable)
+		tmp &= ~EXYNOS7_CENTRALSEQ_PWR_CFG;
+	else
+		tmp |= EXYNOS7_CENTRALSEQ_PWR_CFG;
+	pmu_raw_writel(tmp, EXYNOS7_CENTRAL_SEQ_CONFIGURATION);
+
+	/* central sequencer MIF */
+	tmp = pmu_raw_readl(EXYNOS7_CENTRAL_SEQ_MIF_CONFIGURATION);
+	if (enable)
+		tmp &= ~EXYNOS7_CENTRALSEQ_PWR_CFG;
+	else
+		tmp |= EXYNOS7_CENTRALSEQ_PWR_CFG;
+	pmu_raw_writel(tmp, EXYNOS7_CENTRAL_SEQ_MIF_CONFIGURATION);
+}
+
+static void exynos7_pmu_pad_retention_release(void)
+{
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_AUD_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_MMC2_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_TOP_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_UART_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_MMC0_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_MMC1_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_EBIA_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_EBIB_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_SPI_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_MIF_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP, EXYNOS7_PAD_RETENTION_UFS_OPTION);
+	pmu_raw_writel(PAD_INITIATE_WAKEUP,
+			EXYNOS7_PAD_RETENTION_FSYSGENIO_OPTION);
+}
+
+static void exynos7_powerdown_conf(enum sys_powerdown mode)
+{
+	exynos7_set_wakeupmask(mode);
+	exynos7_pmu_central_seq(true);
+	if (!(pmu_raw_readl(EXYNOS7_PMU_DEBUG) &
+				EXYNOS7_CLKOUT_DISABLE))
+		pmu_raw_writel(0x1, EXYNOS7_XXTI_SYS_PWR_REG);
+}
+
+static void exynos7_show_wakeup_reason(void)
+{
+	unsigned int wakeup_stat;
+
+	wakeup_stat = pmu_raw_readl(EXYNOS7_WAKEUP_STAT);
+
+	if (wakeup_stat & EXYNOS7_WAKEUP_STAT_RTC_ALARM)
+		pr_info("Resume caused by RTC alarm\n");
+	else
+		pr_info("Resume caused by wakeup_stat 0x%08x\n",
+			wakeup_stat);
+}
+
+static void exynos7_powerup_conf(enum sys_powerdown mode)
+{
+	/* Check early wake up*/
+	unsigned int wakeup;
+
+	wakeup = pmu_raw_readl(EXYNOS7_CENTRAL_SEQ_CONFIGURATION);
+	wakeup &= EXYNOS7_CENTRALSEQ_PWR_CFG;
+	if (wakeup)
+		/* Proper wakeup*/
+		exynos7_pmu_pad_retention_release();
+	else
+		/* Early wakeup */
+		exynos7_pmu_central_seq(false);
+
+	exynos7_clear_wakeupmask();
+	exynos7_show_wakeup_reason();
+}
+
+static void exynos7_pmu_init(void)
+{
+	unsigned int cpu;
+	unsigned int tmp, i;
+	struct device_node *node;
+	static void __iomem *atlas_cmu_base;
+
+	 /* Enable only SC_FEEDBACK for the register list */
+	for (i = 0 ; i < ARRAY_SIZE(exynos7_list_feed) ; i++) {
+		tmp = pmu_raw_readl(exynos7_list_feed[i]);
+		tmp &= ~EXYNOS5_USE_SC_COUNTER;
+		tmp |= EXYNOS5_USE_SC_FEEDBACK;
+		pmu_raw_writel(tmp, exynos7_list_feed[i]);
+	}
+
+	/*
+	 * Disable automatic L2 flush, Disable L2 retention and
+	 * Enable STANDBYWFIL2, ACE/ACP
+	 */
+	tmp = pmu_raw_readl(EXYNOS7_ATLAS_L2_OPTION);
+	tmp &= ~(EXYNOS7_USE_AUTO_L2FLUSHREQ | EXYNOS7_USE_RETENTION);
+	tmp |= (EXYNOS7_USE_STANDBYWFIL2 |
+		EXYNOS7_USE_DEACTIVATE_ACE |
+		EXYNOS7_USE_DEACTIVATE_ACP);
+	pmu_raw_writel(tmp, EXYNOS7_ATLAS_L2_OPTION);
+
+	/*
+	 * Enable both SC_COUNTER and SC_FEEDBACK for the CPUs
+	 * Use STANDBYWFI and SMPEN to indicate that core is ready to enter
+	 * low power mode
+	 */
+	for (cpu = 0; cpu < 4; cpu++) {
+		tmp = pmu_raw_readl(EXYNOS7_CPU_OPTION(cpu));
+		tmp |= (EXYNOS5_USE_SC_FEEDBACK | EXYNOS5_USE_SC_COUNTER);
+		tmp |= EXYNOS7_USE_SMPEN;
+		tmp |= EXYNOS7_USE_STANDBYWFI;
+		tmp &= ~EXYNOS7_USE_STANDBYWFE;
+		pmu_raw_writel(tmp, EXYNOS7_CPU_OPTION(cpu));
+
+		tmp = pmu_raw_readl(EXYNOS7_CPU_DURATION(cpu));
+		tmp |= EXYNOS7_DUR_WAIT_RESET;
+		tmp &= ~EXYNOS7_DUR_SCALL;
+		tmp |= EXYNOS7_DUR_SCALL_VALUE;
+		pmu_raw_writel(tmp, EXYNOS7_CPU_DURATION(cpu));
+	}
+
+	/* Skip atlas block power-off during automatic power down sequence */
+	tmp = pmu_raw_readl(EXYNOS7_ATLAS_CPUSEQUENCER_OPTION);
+	tmp |= EXYNOS7_SKIP_BLK_PWR_DOWN;
+	pmu_raw_writel(tmp, EXYNOS7_ATLAS_CPUSEQUENCER_OPTION);
+
+	/* Limit in-rush current during local power up of cores */
+	tmp = pmu_raw_readl(EXYNOS7_UP_SCHEDULER);
+	tmp |= EXYNOS7_ENABLE_ATLAS_CPU;
+	pmu_raw_writel(tmp, EXYNOS7_UP_SCHEDULER);
+
+	/* Enable PS hold and hardware tripping */
+	tmp = pmu_raw_readl(EXYNOS7_PS_HOLD_CONTROL);
+	tmp |= EXYNOS7_PS_HOLD_OUTPUT;
+	tmp |= EXYNOS7_ENABLE_HW_TRIP;
+	pmu_raw_writel(tmp, EXYNOS7_PS_HOLD_CONTROL);
+
+	/* Enable debug area of atlas cpu */
+	tmp = pmu_raw_readl(EXYNOS7_ATLAS_DBG_CONFIGURATION);
+	tmp |= EXYNOS7_DBG_INITIATE_WAKEUP;
+	pmu_raw_writel(tmp, EXYNOS7_ATLAS_DBG_CONFIGURATION);
+
+	/*
+	 * Set clock freeze cycle count to 0 before and after arm clamp or
+	 * reset signal transition
+	 */
+	node = of_find_compatible_node(NULL, NULL,
+				"samsung,exynos7-clock-atlas");
+	if (node) {
+		atlas_cmu_base = of_iomap(node, 0);
+		if (!atlas_cmu_base)
+			return;
+
+		__raw_writel(0x0,
+				atlas_cmu_base + EXYNOS7_CORE_ARMCLK_STOPCTRL);
+		iounmap(atlas_cmu_base);
+	}
+}
+
+const struct exynos_pmu_data exynos7_pmu_data = {
+	.pmu_config		= exynos7_pmu_config,
+	.pmu_init		= exynos7_pmu_init,
+	.pmu_config_extra	= exynos7_pmu_config_extra,
+	.powerdown_conf		= exynos7_powerdown_conf,
+	.powerup_conf		= exynos7_powerup_conf,
+};
-- 
1.9.1

