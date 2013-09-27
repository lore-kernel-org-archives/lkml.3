Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab3I0CDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:03:06 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:58471 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750843Ab3I0CDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:03:04 -0400
X-Greylist: delayed 2574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Sep 2013 22:03:04 EDT
From: Feng Kan <fkan@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 1/1] arm64: X-Gene AHBC platform bus driver
Date: Thu, 26 Sep 2013 18:19:21 -0700
Message-Id: <1380244761-15143-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver setup the AHBC for SPI and SD drivers to use.

Signed-off-by: Feng Kan <fkan@apm.com>

---
 arch/arm64/boot/dts/apm-storm.dtsi |    6 +
 drivers/bus/Kconfig                |    9 ++
 drivers/bus/Makefile               |    2 +
 drivers/bus/xgene_ahbc.c           |  193 ++++++++++++++++++++++++++++++++++++
 4 files changed, 210 insertions(+), 0 deletions(-)
 create mode 100644 drivers/bus/xgene_ahbc.c

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index d994806..b9477ec 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -178,6 +178,12 @@
 			};
 		};
 
+                ahbc: ahbc@1f2a0000 {
+                        device_type = "ahbc";
+                        compatible = "apm,xgene-ahbc";
+                        reg =  <0x0 0x1f2a0000 0x0 0x80000>;
+                };
+
 		serial0: serial@1c020000 {
 			device_type = "serial";
 			compatible = "ns16550";
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 1f70e84..6cc361c68 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -42,4 +42,13 @@ config ARM_CCI
 	help
 	  Driver supporting the CCI cache coherent interconnect for ARM
 	  platforms.
+
+config XGENE_AHBC
+	tristate "X-Gene SoC AHB Bus Driver"
+	depends on ARM64 && ARCH_XGENE
+	default y if ARCH_XGENE
+	help
+	  X-Gene SoC AHB bus driver is required for SPI and
+	  SDIO to function properly.
+
 endmenu
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 8947bdd..0c7a4ca 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -10,3 +10,5 @@ obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
 obj-$(CONFIG_OMAP_INTERCONNECT)	+= omap_l3_smx.o omap_l3_noc.o
 # CCI cache coherent interconnect for ARM platforms
 obj-$(CONFIG_ARM_CCI)		+= arm-cci.o
+
+obj-$(CONFIG_XGENE_AHBC)     += xgene_ahbc.o
diff --git a/drivers/bus/xgene_ahbc.c b/drivers/bus/xgene_ahbc.c
new file mode 100644
index 0000000..9554bb4
--- /dev/null
+++ b/drivers/bus/xgene_ahbc.c
@@ -0,0 +1,193 @@
+/**
+ * AppliedMicro X-Gene AHBC Driver
+ *
+ * Copyright (c) 2013, Applied Micro Circuits Corporation
+ * Author: Loc Ho <lho@apm.com>
+ * Author: Feng Kan <fkan@apm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/delay.h>
+#include <linux/memblock.h>
+
+#define AHBC_DRIVER_VER			"0.1"
+
+#define AIM_8_SIZE_CTL_ADDR					0x00000104
+#define AIM_8_AXI_LO_ADDR					0x00000108
+#define AIM_8_AXI_HI_ADDR					0x0000010c
+
+#define ARSB_F8_WR(src)			(((u32)(src)<<23) & 0x03800000)
+#define AWSB_F8_WR(src)			(((u32)(src)<<20) & 0x00700000)
+#define AIM_AXI_ADDRESS_LO_8_WR(src)	(((u32)(src)) & 0x000fffff)
+
+/*	Global Base Address	*/
+#define REGSPEC_AHBC_GLBL_DIAG_CSR_I_BASE_ADDR			0x01f2ad000ULL
+
+#define REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR			0x00000070
+#define REGSPEC_BLOCK_MEM_RDY_ADDR				0x00000074
+
+static void xgene_ahb_write(void *base, u32 offset, u32 val)
+{
+	if (base == NULL)
+		return;
+
+	writel_relaxed(val, base + offset);
+}
+
+static void xgene_ahbc_init_mem(struct platform_device *pdev)
+{
+	void *ahbc_base = platform_get_drvdata(pdev);
+	u32 diag_offset = REGSPEC_AHBC_GLBL_DIAG_CSR_I_BASE_ADDR & 0xFFFF;
+	void *diagcsr_base = ahbc_base + diag_offset;
+	int timeout;
+	u32 val;
+
+	if (ahbc_base == NULL)
+		return;
+
+	if (readl(diagcsr_base + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR) == 0)
+		return;
+
+	dev_dbg(&pdev->dev, "AHBC clear memory shutdown\n");
+	writel(0x00, diagcsr_base + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR);
+	readl(diagcsr_base + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR);
+
+	val = readl(diagcsr_base + REGSPEC_BLOCK_MEM_RDY_ADDR);
+	timeout = 5000;
+	while (val != 0xFFFFFFFF && timeout-- > 0) {
+		val = readl(diagcsr_base + REGSPEC_BLOCK_MEM_RDY_ADDR);
+		if (val != 0xFFFFFFFF)
+			udelay(1);
+	}
+	if (timeout <= 0)
+		dev_err(&pdev->dev, "AHBC failed to remove RAM out of reset\n");
+}
+
+static int xgene_ahbc_hw_init(struct platform_device *pdev)
+{
+	void *ahbc_base = platform_get_drvdata(pdev);
+	phys_addr_t ddr_phy;
+
+	/**
+	 * Set AHBC AIM windows for 4GB regardless of DDR size. This
+	 * must map to Kernel memory space.
+	 */
+	ddr_phy = memblock_phys_mem_size();
+	dev_dbg(&pdev->dev, "Setup AHBC AIM windows DDR 0x%llX\n", ddr_phy);
+	xgene_ahb_write(ahbc_base, AIM_8_SIZE_CTL_ADDR, 0x00000000);
+	xgene_ahb_write(ahbc_base, AIM_8_AXI_LO_ADDR,
+			ARSB_F8_WR(1) | AWSB_F8_WR(1) |
+			AIM_AXI_ADDRESS_LO_8_WR((u32) ddr_phy));
+	xgene_ahb_write(ahbc_base, AIM_8_AXI_HI_ADDR,
+			(u32) ((ddr_phy >> 32) << 20));
+
+	return 0;
+}
+
+static int __init xgene_ahbc_probe(struct platform_device *pdev)
+{
+	struct resource res;
+	int rc;
+	void *reg;
+
+	rc = of_address_to_resource(pdev->dev.of_node, 0, &res);
+	if (rc != 0) {
+		dev_err(&pdev->dev, "invalid resource address\n");
+		return -ENODEV;
+	}
+	reg = ioremap(res.start, res.end - res.start + 1);
+	if (reg == NULL) {
+		dev_err(&pdev->dev, "can not map resource\n");
+		return -ENODEV;
+	}
+
+	platform_set_drvdata(pdev, reg);
+
+	/* Initialize the hardware */
+	xgene_ahbc_init_mem(pdev);
+	xgene_ahbc_hw_init(pdev);
+
+	dev_info(&pdev->dev, "AHBC driver v%s\n", AHBC_DRIVER_VER);
+	return 0;
+}
+
+static int xgene_ahbc_remove(struct platform_device *pdev)
+{
+	void *ahbc_base = platform_get_drvdata(pdev);
+
+	iounmap(ahbc_base);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+#if defined(CONFIG_PM)
+static int xgene_ahbc_suspend(struct platform_device *dev, pm_message_t state)
+{
+	/* Nothing to do here */
+	return 0;
+}
+
+static int xgene_ahbc_resume(struct platform_device *pdev)
+{
+	/* Initialize the hardware */
+	xgene_ahbc_init_mem(pdev);
+	xgene_ahbc_hw_init(pdev);
+	return 0;
+}
+#endif
+
+static const struct of_device_id xgene_ahbc_match[] = {
+	{.compatible = "apm,xgene-ahbc",},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, xgene_ahbc_match);
+
+static struct platform_driver ahbc_driver = {
+	.probe = xgene_ahbc_probe,
+	.remove = xgene_ahbc_remove,
+#if defined(CONFIG_PM)
+	.suspend = xgene_ahbc_suspend,
+	.resume = xgene_ahbc_resume,
+#endif
+	.driver = {
+		   .name = "xgene-ahbc",
+		   .owner = THIS_MODULE,
+		   .of_match_table = xgene_ahbc_match,
+		   },
+};
+
+static int __init xgene_ahbc_init(void)
+{
+	return platform_driver_register(&ahbc_driver);
+}
+subsys_initcall(xgene_ahbc_init);
+
+static void __exit xgene_ahbc_exit(void)
+{
+	platform_driver_unregister(&ahbc_driver);
+}
+module_exit(xgene_ahbc_exit);
+
+MODULE_AUTHOR("Loc Ho <lho@apm.com>");
+MODULE_DESCRIPTION("X-Gene AHBC driver");
+MODULE_LICENSE("GPL");
-- 
1.7.6.1

