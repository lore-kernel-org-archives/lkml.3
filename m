Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaDOLvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:51:04 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57091 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbaDOLu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:50:58 -0400
From: Mohit Kumar <mohit.kumar@st.com>
To: <spear-devel@list.st.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Pratyush Anand <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: [PATCH V8 8/9] pcie: SPEAr13xx: Add designware wrapper support
Date: Tue, 15 Apr 2014 17:19:50 +0530
Message-ID: <344c498ec0e2d4fceb7653ad79cc94a53a4b07f1.1397555158.git.mohit.kumar@st.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1397555158.git.mohit.kumar@st.com>
References: <cover.1397555158.git.mohit.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-14_01:2014-04-14,2014-04-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

SPEAr1310 and SPEAr1340 SOC uses designware PCIe controller. Add
SPEAr13xx PCIe driver based on designware controller driver.

SPEAr1310 has 3 PCIe ports and SPEAr1340 has 1, which are multiplexed
with ahci/sata pins. By default evaluation board of both controller
works for ahci mode.
To use these patches on SPEAr1340/1310 evaluation board, do the
necessary modifications on board and enable (okay) pcie and miphy
from respective evb dtsi file.

Add Mohit Kumar as maintainer for ST SPEAr13xx PCIe driver.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Mohit Kumar <mohit.kumar@st.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: spear-devel@list.st.com
Cc: linux-pci@vger.kernel.org
---
 MAINTAINERS                       |    6 +
 arch/arm/boot/dts/spear1310.dtsi  |    6 +
 arch/arm/boot/dts/spear1340.dtsi  |    2 +
 arch/arm/boot/dts/spear13xx.dtsi  |    4 +-
 arch/arm/mach-spear/Kconfig       |    1 +
 drivers/pci/host/Kconfig          |    8 +
 drivers/pci/host/Makefile         |    1 +
 drivers/pci/host/pcie-spear13xx.c |  407 +++++++++++++++++++++++++++++++++++++
 8 files changed, 433 insertions(+), 2 deletions(-)
 create mode 100644 drivers/pci/host/pcie-spear13xx.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2421c8d..574218f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6734,6 +6734,12 @@ L:	linux-pci@vger.kernel.org
 S:	Maintained
 F:	drivers/pci/host/*designware*
 
+PCIE DRIVER FOR ST SPEAR13XX
+M:	Mohit Kumar <mohit.kumar@st.com>
+L:	linux-pci@vger.kernel.org
+S:	Maintained
+F:	drivers/pci/host/pcie-spear13xx.c
+
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
diff --git a/arch/arm/boot/dts/spear1310.dtsi b/arch/arm/boot/dts/spear1310.dtsi
index 53f73a2..77bebae 100644
--- a/arch/arm/boot/dts/spear1310.dtsi
+++ b/arch/arm/boot/dts/spear1310.dtsi
@@ -90,6 +90,8 @@
 			interrupt-map-mask = <0 0 0 0>;
 			interrupt-map = <0x0 0 &gic 0 68 0x4>;
 			num-lanes = <1>;
+			phys = <&miphy0 1>;
+			phy-names = "pcie-phy";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			device_type = "pci";
@@ -106,6 +108,8 @@
 			interrupt-map-mask = <0 0 0 0>;
 			interrupt-map = <0x0 0 &gic 0 69 0x4>;
 			num-lanes = <1>;
+			phys = <&miphy1 1>;
+			phy-names = "pcie-phy";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			device_type = "pci";
@@ -122,6 +126,8 @@
 			interrupt-map-mask = <0 0 0 0>;
 			interrupt-map = <0x0 0 &gic 0 70 0x4>;
 			num-lanes = <1>;
+			phys = <&miphy2 1>;
+			phy-names = "pcie-phy";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			device_type = "pci";
diff --git a/arch/arm/boot/dts/spear1340.dtsi b/arch/arm/boot/dts/spear1340.dtsi
index bc492f5..0d8fe32 100644
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@ -55,6 +55,8 @@
 			interrupt-map-mask = <0 0 0 0>;
 			interrupt-map = <0x0 0 &gic 0 68 0x4>;
 			num-lanes = <1>;
+			phys = <&miphy0 1>;
+			phy-names = "pcie-phy";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			device_type = "pci";
diff --git a/arch/arm/boot/dts/spear13xx.dtsi b/arch/arm/boot/dts/spear13xx.dtsi
index 3a72508..a6eb543 100644
--- a/arch/arm/boot/dts/spear13xx.dtsi
+++ b/arch/arm/boot/dts/spear13xx.dtsi
@@ -83,8 +83,8 @@
 		#size-cells = <1>;
 		compatible = "simple-bus";
 		ranges = <0x50000000 0x50000000 0x10000000
-			  0xb0000000 0xb0000000 0x10000000
-			  0xd0000000 0xd0000000 0x02000000
+			  0x80000000 0x80000000 0x20000000
+			  0xb0000000 0xb0000000 0x22000000
 			  0xd8000000 0xd8000000 0x01000000
 			  0xe0000000 0xe0000000 0x10000000>;
 
diff --git a/arch/arm/mach-spear/Kconfig b/arch/arm/mach-spear/Kconfig
index ce1e70f..b44dd1a 100644
--- a/arch/arm/mach-spear/Kconfig
+++ b/arch/arm/mach-spear/Kconfig
@@ -21,6 +21,7 @@ config ARCH_SPEAR13XX
 	select HAVE_ARM_TWD if SMP
 	select PINCTRL
 	select MFD_SYSCON
+	select MIGHT_HAVE_PCI
 	help
 	  Supports for ARM's SPEAR13XX family
 
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index a6f67ec..5fd1098 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -33,4 +33,12 @@ config PCI_RCAR_GEN2
 	  There are 3 internal PCI controllers available with a single
 	  built-in EHCI/OHCI host controller present on each one.
 
+config PCIE_SPEAR13XX
+	tristate "STMicroelectronics SPEAr PCIe controller"
+	depends on ARCH_SPEAR13XX
+	select PCIEPORTBUS
+	select PCIE_DW
+	help
+	  Say Y here if you want PCIe support on SPEAr13XX SoCs.
+
 endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
index 13fb333..42a491d 100644
--- a/drivers/pci/host/Makefile
+++ b/drivers/pci/host/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_PCI_IMX6) += pci-imx6.o
 obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
 obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
 obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
+obj-$(CONFIG_PCIE_SPEAR13XX) += pcie-spear13xx.o
diff --git a/drivers/pci/host/pcie-spear13xx.c b/drivers/pci/host/pcie-spear13xx.c
new file mode 100644
index 0000000..47e8e91
--- /dev/null
+++ b/drivers/pci/host/pcie-spear13xx.c
@@ -0,0 +1,407 @@
+/*
+ * PCIe host controller driver for ST Microelectronics SPEAr13xx SoCs
+ *
+ * SPEAr13xx PCIe Glue Layer Source Code
+ *
+ * Copyright (C) 2010-2014 ST Microelectronics
+ * Pratyush Anand <pratyush.anand@st.com>
+ * Mohit Kumar <mohit.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/pci.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/resource.h>
+
+#include "pcie-designware.h"
+
+struct spear13xx_pcie {
+	void __iomem		*app_base;
+	struct phy		*phy;
+	struct clk		*clk;
+	struct pcie_port	pp;
+	bool			is_gen1;
+};
+
+struct pcie_app_reg {
+	u32	app_ctrl_0;		/* cr0 */
+	u32	app_ctrl_1;		/* cr1 */
+	u32	app_status_0;		/* cr2 */
+	u32	app_status_1;		/* cr3 */
+	u32	msg_status;		/* cr4 */
+	u32	msg_payload;		/* cr5 */
+	u32	int_sts;		/* cr6 */
+	u32	int_clr;		/* cr7 */
+	u32	int_mask;		/* cr8 */
+	u32	mst_bmisc;		/* cr9 */
+	u32	phy_ctrl;		/* cr10 */
+	u32	phy_status;		/* cr11 */
+	u32	cxpl_debug_info_0;	/* cr12 */
+	u32	cxpl_debug_info_1;	/* cr13 */
+	u32	ven_msg_ctrl_0;		/* cr14 */
+	u32	ven_msg_ctrl_1;		/* cr15 */
+	u32	ven_msg_data_0;		/* cr16 */
+	u32	ven_msg_data_1;		/* cr17 */
+	u32	ven_msi_0;		/* cr18 */
+	u32	ven_msi_1;		/* cr19 */
+	u32	mst_rmisc;		/* cr20 */
+};
+
+/* CR0 ID */
+#define RX_LANE_FLIP_EN_ID			0
+#define TX_LANE_FLIP_EN_ID			1
+#define SYS_AUX_PWR_DET_ID			2
+#define APP_LTSSM_ENABLE_ID			3
+#define SYS_ATTEN_BUTTON_PRESSED_ID		4
+#define SYS_MRL_SENSOR_STATE_ID			5
+#define SYS_PWR_FAULT_DET_ID			6
+#define SYS_MRL_SENSOR_CHGED_ID			7
+#define SYS_PRE_DET_CHGED_ID			8
+#define SYS_CMD_CPLED_INT_ID			9
+#define APP_INIT_RST_0_ID			11
+#define APP_REQ_ENTR_L1_ID			12
+#define APP_READY_ENTR_L23_ID			13
+#define APP_REQ_EXIT_L1_ID			14
+#define DEVICE_TYPE_EP				(0 << 25)
+#define DEVICE_TYPE_LEP				(1 << 25)
+#define DEVICE_TYPE_RC				(4 << 25)
+#define SYS_INT_ID				29
+#define MISCTRL_EN_ID				30
+#define REG_TRANSLATION_ENABLE			31
+
+/* CR1 ID */
+#define APPS_PM_XMT_TURNOFF_ID			2
+#define APPS_PM_XMT_PME_ID			5
+
+/* CR3 ID */
+#define XMLH_LTSSM_STATE_DETECT_QUIET		0x00
+#define XMLH_LTSSM_STATE_DETECT_ACT		0x01
+#define XMLH_LTSSM_STATE_POLL_ACTIVE		0x02
+#define XMLH_LTSSM_STATE_POLL_COMPLIANCE	0x03
+#define XMLH_LTSSM_STATE_POLL_CONFIG		0x04
+#define XMLH_LTSSM_STATE_PRE_DETECT_QUIET	0x05
+#define XMLH_LTSSM_STATE_DETECT_WAIT		0x06
+#define XMLH_LTSSM_STATE_CFG_LINKWD_START	0x07
+#define XMLH_LTSSM_STATE_CFG_LINKWD_ACEPT	0x08
+#define XMLH_LTSSM_STATE_CFG_LANENUM_WAIT	0x09
+#define XMLH_LTSSM_STATE_CFG_LANENUM_ACEPT	0x0A
+#define XMLH_LTSSM_STATE_CFG_COMPLETE		0x0B
+#define XMLH_LTSSM_STATE_CFG_IDLE		0x0C
+#define XMLH_LTSSM_STATE_RCVRY_LOCK		0x0D
+#define XMLH_LTSSM_STATE_RCVRY_SPEED		0x0E
+#define XMLH_LTSSM_STATE_RCVRY_RCVRCFG		0x0F
+#define XMLH_LTSSM_STATE_RCVRY_IDLE		0x10
+#define XMLH_LTSSM_STATE_L0			0x11
+#define XMLH_LTSSM_STATE_L0S			0x12
+#define XMLH_LTSSM_STATE_L123_SEND_EIDLE	0x13
+#define XMLH_LTSSM_STATE_L1_IDLE		0x14
+#define XMLH_LTSSM_STATE_L2_IDLE		0x15
+#define XMLH_LTSSM_STATE_L2_WAKE		0x16
+#define XMLH_LTSSM_STATE_DISABLED_ENTRY		0x17
+#define XMLH_LTSSM_STATE_DISABLED_IDLE		0x18
+#define XMLH_LTSSM_STATE_DISABLED		0x19
+#define XMLH_LTSSM_STATE_LPBK_ENTRY		0x1A
+#define XMLH_LTSSM_STATE_LPBK_ACTIVE		0x1B
+#define XMLH_LTSSM_STATE_LPBK_EXIT		0x1C
+#define XMLH_LTSSM_STATE_LPBK_EXIT_TIMEOUT	0x1D
+#define XMLH_LTSSM_STATE_HOT_RESET_ENTRY	0x1E
+#define XMLH_LTSSM_STATE_HOT_RESET		0x1F
+#define XMLH_LTSSM_STATE_MASK			0x3F
+#define XMLH_LINK_UP				(1 << 6)
+
+/* CR4 ID */
+#define CFG_MSI_EN_ID				18
+
+/* CR6 */
+#define INTA_CTRL_INT				(1 << 7)
+#define INTB_CTRL_INT				(1 << 8)
+#define INTC_CTRL_INT				(1 << 9)
+#define INTD_CTRL_INT				(1 << 10)
+#define MSI_CTRL_INT				(1 << 26)
+
+/* CR19 ID */
+#define VEN_MSI_REQ_ID				11
+#define VEN_MSI_FUN_NUM_ID			8
+#define VEN_MSI_TC_ID				5
+#define VEN_MSI_VECTOR_ID			0
+#define VEN_MSI_REQ_EN		((u32)0x1 << VEN_MSI_REQ_ID)
+#define VEN_MSI_FUN_NUM_MASK	((u32)0x7 << VEN_MSI_FUN_NUM_ID)
+#define VEN_MSI_TC_MASK		((u32)0x7 << VEN_MSI_TC_ID)
+#define VEN_MSI_VECTOR_MASK	((u32)0x1F << VEN_MSI_VECTOR_ID)
+
+#define PCI_CAP_ID_EXP_OFFSET			0x70
+
+#define to_spear13xx_pcie(x)	container_of(x, struct spear13xx_pcie, pp)
+
+static int spear13xx_pcie_establish_link(struct pcie_port *pp)
+{
+	u32 val;
+	int count = 0;
+	struct spear13xx_pcie *spear13xx_pcie = to_spear13xx_pcie(pp);
+	struct pcie_app_reg *app_reg = spear13xx_pcie->app_base;
+	u32 exp_cap_off = PCI_CAP_ID_EXP_OFFSET;
+
+	if (dw_pcie_link_up(pp)) {
+		dev_err(pp->dev, "link already up\n");
+		return 0;
+	}
+
+	dw_pcie_setup_rc(pp);
+
+	/*
+	 * this controller support only 128 bytes read size, however its
+	 * default value in capability register is 512 bytes. So force
+	 * it to 128 here.
+	 */
+	dw_pcie_cfg_read(pp->dbi_base, exp_cap_off + PCI_EXP_DEVCTL, 4, &val);
+	val &= ~PCI_EXP_DEVCTL_READRQ;
+	dw_pcie_cfg_write(pp->dbi_base, exp_cap_off + PCI_EXP_DEVCTL, 4, val);
+
+	dw_pcie_cfg_write(pp->dbi_base, PCI_VENDOR_ID, 2, 0x104A);
+	dw_pcie_cfg_write(pp->dbi_base, PCI_DEVICE_ID, 2, 0xCD80);
+
+	/*
+	 * if is_gen1 is set then handle it, so that some buggy card
+	 * also works
+	 */
+	if (spear13xx_pcie->is_gen1) {
+		dw_pcie_cfg_read(pp->dbi_base, exp_cap_off + PCI_EXP_LNKCAP, 4,
+				&val);
+		if ((val & PCI_EXP_LNKCAP_SLS) != PCI_EXP_LNKCAP_SLS_2_5GB) {
+			val &= ~((u32)PCI_EXP_LNKCAP_SLS);
+			val |= PCI_EXP_LNKCAP_SLS_2_5GB;
+			dw_pcie_cfg_write(pp->dbi_base, exp_cap_off +
+					PCI_EXP_LNKCAP, 4, val);
+		}
+
+		dw_pcie_cfg_read(pp->dbi_base, exp_cap_off + PCI_EXP_LNKCTL2,
+				4, &val);
+		if ((val & PCI_EXP_LNKCAP_SLS) != PCI_EXP_LNKCAP_SLS_2_5GB) {
+			val &= ~((u32)PCI_EXP_LNKCAP_SLS);
+			val |= PCI_EXP_LNKCAP_SLS_2_5GB;
+			dw_pcie_cfg_write(pp->dbi_base, exp_cap_off +
+					PCI_EXP_LNKCTL2, 4, val);
+		}
+	}
+
+	/* enable ltssm */
+	writel(DEVICE_TYPE_RC | (1 << MISCTRL_EN_ID)
+			| (1 << APP_LTSSM_ENABLE_ID)
+			| ((u32)1 << REG_TRANSLATION_ENABLE),
+			&app_reg->app_ctrl_0);
+
+	/* check if the link is up or not */
+	while (!dw_pcie_link_up(pp)) {
+		mdelay(100);
+		count++;
+		if (count == 10) {
+			dev_err(pp->dev, "link Fail\n");
+			return -EINVAL;
+		}
+	}
+	dev_info(pp->dev, "link up\n");
+
+	return 0;
+}
+
+static irqreturn_t spear13xx_pcie_irq_handler(int irq, void *arg)
+{
+	struct pcie_port *pp = arg;
+	struct spear13xx_pcie *spear13xx_pcie = to_spear13xx_pcie(pp);
+	struct pcie_app_reg *app_reg = spear13xx_pcie->app_base;
+	unsigned int status;
+
+	status = readl(&app_reg->int_sts);
+
+	if (status & MSI_CTRL_INT) {
+		if (!IS_ENABLED(CONFIG_PCI_MSI))
+			BUG();
+		dw_handle_msi_irq(pp);
+	}
+
+	writel(status, &app_reg->int_clr);
+
+	return IRQ_HANDLED;
+}
+
+static void spear13xx_pcie_enable_interrupts(struct pcie_port *pp)
+{
+	struct spear13xx_pcie *spear13xx_pcie = to_spear13xx_pcie(pp);
+	struct pcie_app_reg *app_reg = spear13xx_pcie->app_base;
+
+	/* Enable MSI interrupt */
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		dw_pcie_msi_init(pp);
+		writel(readl(&app_reg->int_mask) |
+				MSI_CTRL_INT, &app_reg->int_mask);
+	}
+}
+
+static int spear13xx_pcie_link_up(struct pcie_port *pp)
+{
+	struct spear13xx_pcie *spear13xx_pcie = to_spear13xx_pcie(pp);
+	struct pcie_app_reg *app_reg = spear13xx_pcie->app_base;
+
+	if (readl(&app_reg->app_status_1) & XMLH_LINK_UP)
+		return 1;
+
+	return 0;
+}
+
+static void spear13xx_pcie_host_init(struct pcie_port *pp)
+{
+	spear13xx_pcie_establish_link(pp);
+	spear13xx_pcie_enable_interrupts(pp);
+}
+
+static struct pcie_host_ops spear13xx_pcie_host_ops = {
+	.link_up = spear13xx_pcie_link_up,
+	.host_init = spear13xx_pcie_host_init,
+};
+
+static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	pp->irq = platform_get_irq(pdev, 0);
+	if (!pp->irq) {
+		dev_err(dev, "failed to get irq\n");
+		return -ENODEV;
+	}
+	ret = devm_request_irq(dev, pp->irq, spear13xx_pcie_irq_handler,
+				IRQF_SHARED, "spear1340-pcie", pp);
+	if (ret) {
+		dev_err(dev, "failed to request irq %d\n", pp->irq);
+		return ret;
+	}
+
+	pp->root_bus_nr = -1;
+	pp->ops = &spear13xx_pcie_host_ops;
+
+	spin_lock_init(&pp->conf_lock);
+	ret = dw_pcie_host_init(pp);
+	if (ret) {
+		dev_err(dev, "failed to initialize host\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __init spear13xx_pcie_probe(struct platform_device *pdev)
+{
+	struct spear13xx_pcie *spear13xx_pcie;
+	struct pcie_port *pp;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = pdev->dev.of_node;
+	struct resource *dbi_base;
+	int ret;
+
+	spear13xx_pcie = devm_kzalloc(dev, sizeof(*spear13xx_pcie),
+				GFP_KERNEL);
+	if (!spear13xx_pcie) {
+		dev_err(dev, "no memory for SPEAr13xx pcie\n");
+		return -ENOMEM;
+	}
+
+	spear13xx_pcie->phy = devm_phy_get(dev, "pcie-phy");
+	if (IS_ERR(spear13xx_pcie->phy)) {
+		ret = PTR_ERR(spear13xx_pcie->phy);
+		if (ret == -EPROBE_DEFER)
+			dev_info(dev, "probe deferred\n");
+		else
+			dev_err(dev, "couldn't get pcie-phy\n");
+		return ret;
+	}
+
+	phy_init(spear13xx_pcie->phy);
+
+	spear13xx_pcie->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(spear13xx_pcie->clk)) {
+		dev_err(dev, "couldn't get clk for pcie\n");
+		return PTR_ERR(spear13xx_pcie->clk);
+	}
+	ret = clk_prepare_enable(spear13xx_pcie->clk);
+	if (ret) {
+		dev_err(dev, "couldn't enable clk for pcie\n");
+		return ret;
+	}
+
+	pp = &spear13xx_pcie->pp;
+
+	pp->dev = dev;
+
+	dbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pp->dbi_base = devm_ioremap_resource(dev, dbi_base);
+	if (IS_ERR(pp->dbi_base)) {
+		dev_err(dev, "couldn't remap dbi base %p\n", dbi_base);
+		ret = PTR_ERR(pp->dbi_base);
+		goto fail_clk;
+	}
+	spear13xx_pcie->app_base = pp->dbi_base + 0x2000;
+
+	if (of_property_read_bool(np, "st,pcie-is-gen1"))
+		spear13xx_pcie->is_gen1 = true;
+
+	ret = add_pcie_port(pp, pdev);
+	if (ret < 0)
+		goto fail_clk;
+
+	platform_set_drvdata(pdev, spear13xx_pcie);
+	return 0;
+
+fail_clk:
+	clk_disable_unprepare(spear13xx_pcie->clk);
+
+	return ret;
+}
+
+static int __exit spear13xx_pcie_remove(struct platform_device *pdev)
+{
+	struct spear13xx_pcie *spear13xx_pcie = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(spear13xx_pcie->clk);
+
+	phy_exit(spear13xx_pcie->phy);
+
+	return 0;
+}
+
+static const struct of_device_id spear13xx_pcie_of_match[] = {
+	{ .compatible = "st,spear1340-pcie", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, spear13xx_pcie_of_match);
+
+static struct platform_driver spear13xx_pcie_driver = {
+	.probe		= spear13xx_pcie_probe,
+	.remove		= spear13xx_pcie_remove,
+	.driver = {
+		.name	= "spear-pcie",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(spear13xx_pcie_of_match),
+	},
+};
+
+/* SPEAr13xx PCIe driver does not allow module unload */
+
+static int __init pcie_init(void)
+{
+	return platform_driver_register(&spear13xx_pcie_driver);
+}
+module_init(pcie_init);
+
+MODULE_DESCRIPTION("ST Microelectronics SPEAr13xx PCIe host controller driver");
+MODULE_AUTHOR("Pratyush Anand <pratyush.anand@st.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.0.1

