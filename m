Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbaFRGS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:18:26 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:39339 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933875AbaFRGQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:16:39 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v1 6/9] usb: xhci: Add NVIDIA Tegra XHCI host-controller driver
Date: Tue, 17 Jun 2014 23:16:17 -0700
Message-Id: <1403072180-4944-7-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the on-chip XHCI host controller present on Tegra SoCs.

The driver is currently very basic: it loads the controller with its
firmware, starts the controller, and is able to service messages sent
by the controller's firmware.  The hardware supports device mode as
well as runtime power-gating, but support for these is not yet
implemented here.

Based on work by:
  Ajay Gupta <ajayg@nvidia.com>
  Bharath Yadav <byadav@nvidia.com>

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/usb/host/Kconfig      |  12 +
 drivers/usb/host/Makefile     |   2 +
 drivers/usb/host/xhci-tegra.c | 900 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 914 insertions(+)
 create mode 100644 drivers/usb/host/xhci-tegra.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 61b7817..a8fb138 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -37,6 +37,18 @@ config USB_XHCI_MVEBU
 	  Say 'Y' to enable the support for the xHCI host controller
 	  found in Marvell Armada 375/38x ARM SOCs.
 
+config USB_XHCI_TEGRA
+	tristate "NVIDIA Tegra XHCI support"
+	depends on ARCH_TEGRA
+	select PINCTRL_TEGRA_XUSB
+	select TEGRA_XUSB_MBOX
+	select FW_LOADER
+	---help---
+	  Enables support for the on-chip XHCI controller present on NVIDIA
+	  Tegra124 and later SoCs.
+
+	  If unsure, say N.
+
 endif # USB_XHCI_HCD
 
 config USB_EHCI_HCD
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index af89a90..cbba340 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -41,6 +41,8 @@ obj-$(CONFIG_USB_EHCI_MSM)	+= ehci-msm.o
 obj-$(CONFIG_USB_EHCI_TEGRA)	+= ehci-tegra.o
 obj-$(CONFIG_USB_W90X900_EHCI)	+= ehci-w90x900.o
 
+obj-$(CONFIG_USB_XHCI_TEGRA)	+= xhci-tegra.o
+
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
new file mode 100644
index 0000000..609374e
--- /dev/null
+++ b/drivers/usb/host/xhci-tegra.c
@@ -0,0 +1,900 @@
+/*
+ * NVIDIA Tegra XHCI host controller driver
+ *
+ * Copyright (C) 2014 NVIDIA Corporation
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/of_device.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/reset.h>
+#include <linux/tegra-xusb-mbox.h>
+
+#include "xhci.h"
+
+#define TEGRA_XHCI_UTMI_PHYS 3
+#define TEGRA_XHCI_HSIC_PHYS 2
+#define TEGRA_XHCI_USB3_PHYS 2
+#define TEGRA_XHCI_MAX_PHYS (TEGRA_XHCI_UTMI_PHYS + TEGRA_XHCI_HSIC_PHYS + \
+			     TEGRA_XHCI_USB3_PHYS)
+
+#define TEGRA_XHCI_SS_CLK_HIGH_SPEED 120000000
+#define TEGRA_XHCI_SS_CLK_LOW_SPEED 12000000
+
+/* FPCI CFG registers */
+#define XUSB_CFG_1				0x004
+#define  XUSB_IO_SPACE_EN			BIT(0)
+#define  XUSB_MEM_SPACE_EN			BIT(1)
+#define  XUSB_BUS_MASTER_EN			BIT(2)
+#define XUSB_CFG_4				0x010
+#define XUSB_CFG_ARU_C11_CSBRANGE		0x41c
+#define XUSB_CFG_CSB_BASE_ADDR			0x800
+
+/* IPFS registers */
+#define IPFS_XUSB_HOST_CONFIGURATION_0		0x180
+#define  IPFS_EN_FPCI				BIT(0)
+#define IPFS_XUSB_HOST_INTR_MASK_0		0x188
+#define  IPFS_IP_INT_MASK			BIT(16)
+#define IPFS_XUSB_HOST_CLKGATE_HYSTERESIS_0	0x1bc
+
+#define CSB_PAGE_SELECT_MASK			0x7fffff
+#define CSB_PAGE_SELECT_SHIFT			9
+#define CSB_PAGE_OFFSET_MASK			0x1ff
+#define CSB_PAGE_SELECT(addr)	((addr) >> (CSB_PAGE_SELECT_SHIFT) &	\
+				 CSB_PAGE_SELECT_MASK)
+#define CSB_PAGE_OFFSET(addr)	((addr) & CSB_PAGE_OFFSET_MASK)
+
+/* Falcon CSB registers */
+#define XUSB_FALC_CPUCTL			0x100
+#define  CPUCTL_STARTCPU			BIT(1)
+#define  CPUCTL_STATE_HALTED			BIT(4)
+#define XUSB_FALC_BOOTVEC			0x104
+#define XUSB_FALC_DMACTL			0x10c
+#define XUSB_FALC_IMFILLRNG1			0x154
+#define  IMFILLRNG1_TAG_MASK			0xffff
+#define  IMFILLRNG1_TAG_HI_SHIFT		16
+#define XUSB_FALC_IMFILLCTL			0x158
+
+/* MP CSB registers */
+#define XUSB_CSB_MP_ILOAD_ATTR			0x101a00
+#define XUSB_CSB_MP_ILOAD_BASE_LO		0x101a04
+#define XUSB_CSB_MP_ILOAD_BASE_HI		0x101a08
+#define XUSB_CSB_MP_L2IMEMOP_SIZE		0x101a10
+#define  L2IMEMOP_SIZE_SRC_OFFSET_SHIFT		8
+#define  L2IMEMOP_SIZE_SRC_OFFSET_MASK		0x3ff
+#define  L2IMEMOP_SIZE_SRC_COUNT_SHIFT		24
+#define  L2IMEMOP_SIZE_SRC_COUNT_MASK		0xff
+#define XUSB_CSB_MP_L2IMEMOP_TRIG		0x101a14
+#define  L2IMEMOP_ACTION_SHIFT			24
+#define  L2IMEMOP_INVALIDATE_ALL		(0x40 << L2IMEMOP_ACTION_SHIFT)
+#define  L2IMEMOP_LOAD_LOCKED_RESULT		(0x11 << L2IMEMOP_ACTION_SHIFT)
+#define XUSB_CSB_MP_APMAP			0x10181c
+#define  APMAP_BOOTPATH				BIT(31)
+
+#define IMEM_BLOCK_SIZE				256
+
+struct tegra_xhci_fw_cfgtbl {
+	u32 boot_loadaddr_in_imem;
+	u32 boot_codedfi_offset;
+	u32 boot_codetag;
+	u32 boot_codesize;
+	u32 phys_memaddr;
+	u16 reqphys_memsize;
+	u16 alloc_phys_memsize;
+	u32 rodata_img_offset;
+	u32 rodata_section_start;
+	u32 rodata_section_end;
+	u32 main_fnaddr;
+	u32 fwimg_cksum;
+	u32 fwimg_created_time;
+	u32 imem_resident_start;
+	u32 imem_resident_end;
+	u32 idirect_start;
+	u32 idirect_end;
+	u32 l2_imem_start;
+	u32 l2_imem_end;
+	u32 version_id;
+	u8 init_ddirect;
+	u8 reserved[3];
+	u32 phys_addr_log_buffer;
+	u32 total_log_entries;
+	u32 dequeue_ptr;
+	u32 dummy_var[2];
+	u32 fwimg_len;
+	u8 magic[8];
+	u32 ss_low_power_entry_timeout;
+	u8 num_hsic_port;
+	u8 padding[139]; /* Padding bytes to make 256-bytes cfgtbl */
+};
+
+struct tegra_xhci_soc_config {
+	const char *firmware_file;
+};
+
+struct tegra_xhci_hcd {
+	struct device *dev;
+	struct usb_hcd *hcd;
+
+	int irq;
+
+	void __iomem *fpci_base;
+	void __iomem *ipfs_base;
+
+	const struct tegra_xhci_soc_config *soc_config;
+
+	struct notifier_block mbox_nb;
+	struct tegra_xusb_mbox *mbox;
+
+	struct regulator *s1p05v_reg;
+	struct regulator *s3p3v_reg;
+	struct regulator *s1p8v_reg;
+
+	struct clk *host_clk;
+	struct clk *falc_clk;
+	struct clk *ss_clk;
+	struct clk *ss_src_clk;
+	struct clk *hs_src_clk;
+	struct clk *fs_src_clk;
+	struct clk *pll_u_480m;
+	struct clk *clk_m;
+	struct clk *pll_e;
+
+	struct reset_control *host_rst;
+	struct reset_control *ss_rst;
+
+	struct phy *phys[TEGRA_XHCI_MAX_PHYS];
+
+	/* Firmware loading related */
+	void *fw_data;
+	size_t fw_size;
+	dma_addr_t fw_dma_addr;
+	bool fw_loaded;
+};
+
+static inline u32 fpci_readl(struct tegra_xhci_hcd *tegra, u32 addr)
+{
+	return readl(tegra->fpci_base + addr);
+}
+
+static inline void fpci_writel(struct tegra_xhci_hcd *tegra, u32 val, u32 addr)
+{
+	writel(val, tegra->fpci_base + addr);
+}
+
+static inline u32 ipfs_readl(struct tegra_xhci_hcd *tegra, u32 addr)
+{
+	return readl(tegra->ipfs_base + addr);
+}
+
+static inline void ipfs_writel(struct tegra_xhci_hcd *tegra, u32 val, u32 addr)
+{
+	writel(val, tegra->ipfs_base + addr);
+}
+
+static u32 csb_readl(struct tegra_xhci_hcd *tegra, u32 addr)
+{
+	u32 page, offset;
+
+	page = CSB_PAGE_SELECT(addr);
+	offset = CSB_PAGE_OFFSET(addr);
+	fpci_writel(tegra, page, XUSB_CFG_ARU_C11_CSBRANGE);
+	return fpci_readl(tegra, XUSB_CFG_CSB_BASE_ADDR + offset);
+}
+
+static void csb_writel(struct tegra_xhci_hcd *tegra, u32 val, u32 addr)
+{
+	u32 page, offset;
+
+	page = CSB_PAGE_SELECT(addr);
+	offset = CSB_PAGE_OFFSET(addr);
+	fpci_writel(tegra, page, XUSB_CFG_ARU_C11_CSBRANGE);
+	fpci_writel(tegra, val, XUSB_CFG_CSB_BASE_ADDR + offset);
+}
+
+static void tegra_xhci_cfg(struct tegra_xhci_hcd *tegra)
+{
+	u32 reg;
+
+	reg = ipfs_readl(tegra, IPFS_XUSB_HOST_CONFIGURATION_0);
+	reg |= IPFS_EN_FPCI;
+	ipfs_writel(tegra, reg, IPFS_XUSB_HOST_CONFIGURATION_0);
+	udelay(10);
+
+	/* Program Bar0 Space */
+	reg = fpci_readl(tegra, XUSB_CFG_4);
+	reg |= tegra->hcd->rsrc_start;
+	fpci_writel(tegra, reg, XUSB_CFG_4);
+	usleep_range(100, 200);
+
+	/* Enable Bus Master */
+	reg = fpci_readl(tegra, XUSB_CFG_1);
+	reg |= XUSB_IO_SPACE_EN | XUSB_MEM_SPACE_EN | XUSB_BUS_MASTER_EN;
+	fpci_writel(tegra, reg, XUSB_CFG_1);
+
+	/* Set intr mask to enable intr assertion */
+	reg = ipfs_readl(tegra, IPFS_XUSB_HOST_INTR_MASK_0);
+	reg |= IPFS_IP_INT_MASK;
+	ipfs_writel(tegra, reg, IPFS_XUSB_HOST_INTR_MASK_0);
+
+	/* Set hysteris to 0x80 */
+	ipfs_writel(tegra, 0x80, IPFS_XUSB_HOST_CLKGATE_HYSTERESIS_0);
+}
+
+static int tegra_xhci_load_firmware(struct tegra_xhci_hcd *tegra)
+{
+	struct device *dev = tegra->dev;
+	struct tegra_xhci_fw_cfgtbl *cfg_tbl;
+	u64 fw_base;
+	u32 val;
+	time_t fw_time;
+	struct tm fw_tm;
+
+	if (csb_readl(tegra, XUSB_CSB_MP_ILOAD_BASE_LO) != 0) {
+		dev_info(dev, "Firmware already loaded, Falcon state 0x%x\n",
+			 csb_readl(tegra, XUSB_FALC_CPUCTL));
+		return 0;
+	}
+
+	cfg_tbl = (struct tegra_xhci_fw_cfgtbl *)tegra->fw_data;
+
+	/* Program the size of DFI into ILOAD_ATTR */
+	csb_writel(tegra, tegra->fw_size, XUSB_CSB_MP_ILOAD_ATTR);
+
+	/*
+	 * Boot code of the firmware reads the ILOAD_BASE registers
+	 * to get to the start of the DFI in system memory.
+	 */
+	fw_base = tegra->fw_dma_addr + sizeof(*cfg_tbl);
+	csb_writel(tegra, fw_base, XUSB_CSB_MP_ILOAD_BASE_LO);
+	csb_writel(tegra, fw_base >> 32, XUSB_CSB_MP_ILOAD_BASE_HI);
+
+	/* Set BOOTPATH to 1 in APMAP. */
+	csb_writel(tegra, APMAP_BOOTPATH, XUSB_CSB_MP_APMAP);
+
+	/* Invalidate L2IMEM. */
+	csb_writel(tegra, L2IMEMOP_INVALIDATE_ALL, XUSB_CSB_MP_L2IMEMOP_TRIG);
+
+	/*
+	 * Initiate fetch of bootcode from system memory into L2IMEM.
+	 * Program bootcode location and size in system memory.
+	 */
+	val = (DIV_ROUND_UP(cfg_tbl->boot_codetag, IMEM_BLOCK_SIZE) &
+	       L2IMEMOP_SIZE_SRC_OFFSET_MASK) << L2IMEMOP_SIZE_SRC_OFFSET_SHIFT;
+	val |= (DIV_ROUND_UP(cfg_tbl->boot_codesize, IMEM_BLOCK_SIZE) &
+		L2IMEMOP_SIZE_SRC_COUNT_MASK) << L2IMEMOP_SIZE_SRC_COUNT_SHIFT;
+	csb_writel(tegra, val, XUSB_CSB_MP_L2IMEMOP_SIZE);
+
+	/* Trigger L2IMEM Load operation. */
+	csb_writel(tegra, L2IMEMOP_LOAD_LOCKED_RESULT,
+		   XUSB_CSB_MP_L2IMEMOP_TRIG);
+
+	/* Setup Falcon Auto-fill */
+	val = DIV_ROUND_UP(cfg_tbl->boot_codesize, IMEM_BLOCK_SIZE);
+	csb_writel(tegra, val, XUSB_FALC_IMFILLCTL);
+
+	val = DIV_ROUND_UP(cfg_tbl->boot_codetag, IMEM_BLOCK_SIZE) &
+		IMFILLRNG1_TAG_MASK;
+	val |= DIV_ROUND_UP(cfg_tbl->boot_codetag + cfg_tbl->boot_codesize,
+			    IMEM_BLOCK_SIZE) << IMFILLRNG1_TAG_HI_SHIFT;
+	csb_writel(tegra, val, XUSB_FALC_IMFILLRNG1);
+
+	csb_writel(tegra, 0, XUSB_FALC_DMACTL);
+	msleep(50);
+
+	csb_writel(tegra, cfg_tbl->boot_codetag, XUSB_FALC_BOOTVEC);
+
+	/* Start Falcon CPU */
+	csb_writel(tegra, CPUCTL_STARTCPU, XUSB_FALC_CPUCTL);
+	usleep_range(1000, 2000);
+
+	fw_time = cfg_tbl->fwimg_created_time;
+	time_to_tm(fw_time, 0, &fw_tm);
+	dev_info(dev,
+		 "Firmware timestamp: %ld-%02d-%02d %02d:%02d:%02d UTC, "
+		 "Falcon state 0x%x\n", fw_tm.tm_year + 1900,
+		 fw_tm.tm_mon + 1, fw_tm.tm_mday, fw_tm.tm_hour,
+		 fw_tm.tm_min, fw_tm.tm_sec,
+		 csb_readl(tegra, XUSB_FALC_CPUCTL));
+
+	/* Bail out if Falcon CPU is not in a good state */
+	if (csb_readl(tegra, XUSB_FALC_CPUCTL) == CPUCTL_STATE_HALTED)
+		return -EIO;
+
+	return 0;
+}
+
+static int tegra_xhci_set_ss_clk(struct tegra_xhci_hcd *tegra,
+				 unsigned long rate)
+{
+	unsigned long new_parent_rate, old_parent_rate;
+	int ret, div;
+	struct clk *clk = tegra->ss_src_clk;
+
+	if (clk_get_rate(clk) == rate)
+		return 0;
+
+	switch (rate) {
+	case TEGRA_XHCI_SS_CLK_HIGH_SPEED:
+		/* Reparent to PLLU_480M. Set div first to avoid overclocking */
+		old_parent_rate = clk_get_rate(clk_get_parent(clk));
+		new_parent_rate = clk_get_rate(tegra->pll_u_480m);
+		div = new_parent_rate / rate;
+		ret = clk_set_rate(clk, old_parent_rate / div);
+		if (ret)
+			return ret;
+		ret = clk_set_parent(clk, tegra->pll_u_480m);
+		if (ret)
+			return ret;
+		break;
+	case TEGRA_XHCI_SS_CLK_LOW_SPEED:
+		/* Reparent to CLK_M */
+		ret = clk_set_parent(clk, tegra->clk_m);
+		if (ret)
+			return ret;
+		ret = clk_set_rate(clk, rate);
+		if (ret)
+			return ret;
+		break;
+	default:
+		dev_err(tegra->dev, "Invalid SS rate: %lu\n", rate);
+		return -EINVAL;
+	}
+
+	if (clk_get_rate(clk) != rate) {
+		dev_err(tegra->dev, "SS clock doesn't match requested rate\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int tegra_xhci_clk_enable(struct tegra_xhci_hcd *tegra)
+{
+	clk_prepare_enable(tegra->pll_e);
+	clk_prepare_enable(tegra->host_clk);
+	clk_prepare_enable(tegra->ss_clk);
+	clk_prepare_enable(tegra->falc_clk);
+	clk_prepare_enable(tegra->fs_src_clk);
+	clk_prepare_enable(tegra->hs_src_clk);
+
+	return tegra_xhci_set_ss_clk(tegra, TEGRA_XHCI_SS_CLK_HIGH_SPEED);
+}
+
+static void tegra_xhci_clk_disable(struct tegra_xhci_hcd *tegra)
+{
+	clk_disable_unprepare(tegra->pll_e);
+	clk_disable_unprepare(tegra->host_clk);
+	clk_disable_unprepare(tegra->ss_clk);
+	clk_disable_unprepare(tegra->falc_clk);
+	clk_disable_unprepare(tegra->fs_src_clk);
+	clk_disable_unprepare(tegra->hs_src_clk);
+}
+
+static int tegra_xhci_regulator_enable(struct tegra_xhci_hcd *tegra)
+{
+	int ret;
+
+	ret = regulator_enable(tegra->s3p3v_reg);
+	if (ret < 0)
+		return ret;
+	ret = regulator_enable(tegra->s1p8v_reg);
+	if (ret < 0)
+		goto disable_s3p3v;
+	ret = regulator_enable(tegra->s1p05v_reg);
+	if (ret < 0)
+		goto disable_s1p8v;
+
+	return 0;
+
+disable_s1p8v:
+	regulator_disable(tegra->s1p8v_reg);
+disable_s3p3v:
+	regulator_disable(tegra->s3p3v_reg);
+	return ret;
+}
+
+static void tegra_xhci_regulator_disable(struct tegra_xhci_hcd *tegra)
+{
+	regulator_disable(tegra->s1p05v_reg);
+	regulator_disable(tegra->s1p8v_reg);
+	regulator_disable(tegra->s3p3v_reg);
+}
+
+static int tegra_xhci_phy_enable(struct tegra_xhci_hcd *tegra)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tegra->phys); i++) {
+		ret = phy_init(tegra->phys[i]);
+		if (ret)
+			goto disable_phy;
+		ret = phy_power_on(tegra->phys[i]);
+		if (ret) {
+			phy_exit(tegra->phys[i]);
+			goto disable_phy;
+		}
+	}
+
+	return 0;
+disable_phy:
+	for (i = i - 1; i >= 0; i--) {
+		phy_power_off(tegra->phys[i]);
+		phy_exit(tegra->phys[i]);
+	}
+	return ret;
+}
+
+static void tegra_xhci_phy_disable(struct tegra_xhci_hcd *tegra)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tegra->phys); i++) {
+		phy_power_off(tegra->phys[i]);
+		phy_exit(tegra->phys[i]);
+	}
+}
+
+static int tegra_xhci_mbox_notifier(struct notifier_block *nb,
+				    unsigned long event, void *p)
+{
+	struct tegra_xhci_hcd *tegra = container_of(nb, struct tegra_xhci_hcd,
+						    mbox_nb);
+	struct tegra_xusb_mbox_msg *msg = (struct tegra_xusb_mbox_msg *)p;
+	int ret;
+
+	switch (event) {
+	case MBOX_CMD_INC_SSPI_CLOCK:
+	case MBOX_CMD_DEC_SSPI_CLOCK:
+		ret = tegra_xhci_set_ss_clk(tegra, msg->data_in * 1000);
+		msg->data_out = clk_get_rate(tegra->ss_src_clk) / 1000;
+		if (ret)
+			msg->cmd_out = MBOX_CMD_NAK;
+		else
+			msg->cmd_out = MBOX_CMD_ACK;
+		return NOTIFY_STOP;
+	case MBOX_CMD_INC_FALC_CLOCK:
+	case MBOX_CMD_DEC_FALC_CLOCK:
+		msg->data_out = clk_get_rate(tegra->falc_clk) / 1000;
+		if (msg->data_in != msg->data_out)
+			msg->cmd_out = MBOX_CMD_NAK;
+		else
+			msg->cmd_out = MBOX_CMD_ACK;
+		return NOTIFY_STOP;
+	case MBOX_CMD_SET_BW:
+		/* No support for EMC scaling yet */
+		return NOTIFY_STOP;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static void tegra_xhci_quirks(struct device *dev, struct xhci_hcd *xhci)
+{
+	xhci->quirks |= XHCI_PLAT;
+}
+
+static int tegra_xhci_setup(struct usb_hcd *hcd)
+{
+	return xhci_gen_setup(hcd, tegra_xhci_quirks);
+}
+
+static const struct hc_driver tegra_xhci_hc_driver = {
+	.description =		"tegra-xhci-hcd",
+	.product_desc =		"Tegra xHCI Host Controller",
+	.hcd_priv_size =	sizeof(struct xhci_hcd *),
+
+	/*
+	 * generic hardware linkage
+	 */
+	.irq =			xhci_irq,
+	.flags =		HCD_MEMORY | HCD_USB3 | HCD_SHARED,
+
+	/*
+	 * basic lifecycle operations
+	 */
+	.reset =		tegra_xhci_setup,
+	.start =		xhci_run,
+	.stop =			xhci_stop,
+	.shutdown =		xhci_shutdown,
+
+	/*
+	 * managing i/o requests and associated device resources
+	 */
+	.urb_enqueue =		xhci_urb_enqueue,
+	.urb_dequeue =		xhci_urb_dequeue,
+	.alloc_dev =		xhci_alloc_dev,
+	.free_dev =		xhci_free_dev,
+	.alloc_streams =	xhci_alloc_streams,
+	.free_streams =		xhci_free_streams,
+	.add_endpoint =		xhci_add_endpoint,
+	.drop_endpoint =	xhci_drop_endpoint,
+	.endpoint_reset =	xhci_endpoint_reset,
+	.check_bandwidth =	xhci_check_bandwidth,
+	.reset_bandwidth =	xhci_reset_bandwidth,
+	.address_device =	xhci_address_device,
+	.enable_device =	xhci_enable_device,
+	.update_hub_device =	xhci_update_hub_device,
+	.reset_device =		xhci_discover_or_reset_device,
+
+	/*
+	 * scheduling support
+	 */
+	.get_frame_number =	xhci_get_frame,
+
+	/* Root hub support */
+	.hub_control =		xhci_hub_control,
+	.hub_status_data =	xhci_hub_status_data,
+	.bus_suspend =		xhci_bus_suspend,
+	.bus_resume =		xhci_bus_resume,
+};
+
+static const struct tegra_xhci_soc_config tegra124_soc_config = {
+	.firmware_file = "tegra12x/tegra_xusb_firmware",
+};
+
+static struct of_device_id tegra_xhci_of_match[] = {
+	{ .compatible = "nvidia,tegra124-xhci", .data = &tegra124_soc_config },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_xhci_of_match);
+
+static void tegra_xhci_probe_finish(const struct firmware *fw, void *context)
+{
+	struct tegra_xhci_hcd *tegra = context;
+	struct device *dev = tegra->dev;
+	struct xhci_hcd *xhci = NULL;
+	struct tegra_xhci_fw_cfgtbl *cfg_tbl;
+	int ret;
+
+	if (!fw)
+		goto put_usb2_hcd;
+
+	/* Load Falcon controller with its firmware */
+	cfg_tbl = (struct tegra_xhci_fw_cfgtbl *)fw->data;
+	tegra->fw_size = cfg_tbl->fwimg_len;
+	tegra->fw_data = dma_alloc_coherent(dev, tegra->fw_size,
+					    &tegra->fw_dma_addr,
+					    GFP_KERNEL);
+	if (!tegra->fw_data)
+		goto put_usb2_hcd;
+	memcpy(tegra->fw_data, fw->data, tegra->fw_size);
+
+	ret = tegra_xhci_load_firmware(tegra);
+	if (ret < 0)
+		goto put_usb2_hcd;
+
+	ret = usb_add_hcd(tegra->hcd, tegra->irq, IRQF_SHARED);
+	if (ret < 0)
+		goto put_usb2_hcd;
+	device_wakeup_enable(tegra->hcd->self.controller);
+
+	/*
+	 * USB 2.0 roothub is stored in drvdata now. Swap it with the Tegra HCD.
+	 */
+	tegra->hcd = dev_get_drvdata(dev);
+	dev_set_drvdata(dev, tegra);
+	xhci = hcd_to_xhci(tegra->hcd);
+	xhci->shared_hcd = usb_create_shared_hcd(&tegra_xhci_hc_driver,
+						 dev, dev_name(dev),
+						 tegra->hcd);
+	if (!xhci->shared_hcd)
+		goto dealloc_usb2_hcd;
+
+	/*
+	 * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
+	 * is called by usb_add_hcd().
+	 */
+	*((struct xhci_hcd **) xhci->shared_hcd->hcd_priv) = xhci;
+	ret = usb_add_hcd(xhci->shared_hcd, tegra->irq, IRQF_SHARED);
+	if (ret < 0)
+		goto put_usb3_hcd;
+
+	/* Enable firmware messages from controller */
+	ret = tegra_xusb_mbox_send(tegra->mbox, MBOX_CMD_MSG_ENABLED, 0);
+	if (ret < 0)
+		goto dealloc_usb3_hcd;
+
+	tegra->fw_loaded = true;
+	release_firmware(fw);
+	return;
+
+dealloc_usb3_hcd:
+	usb_remove_hcd(xhci->shared_hcd);
+put_usb3_hcd:
+	usb_put_hcd(xhci->shared_hcd);
+dealloc_usb2_hcd:
+	usb_remove_hcd(tegra->hcd);
+	kfree(xhci);
+put_usb2_hcd:
+	usb_put_hcd(tegra->hcd);
+	tegra->hcd = NULL;
+	release_firmware(fw);
+}
+
+static int tegra_xhci_probe(struct platform_device *pdev)
+{
+	struct tegra_xhci_hcd *tegra;
+	struct usb_hcd *hcd;
+	struct resource	*res;
+	struct phy *phy;
+	const struct of_device_id *match;
+	int ret, i, j;
+
+	BUILD_BUG_ON(sizeof(struct tegra_xhci_fw_cfgtbl) != 256);
+
+	tegra = devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
+	if (!tegra)
+		return -ENOMEM;
+	tegra->dev = &pdev->dev;
+	platform_set_drvdata(pdev, tegra);
+
+	match = of_match_device(tegra_xhci_of_match, &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "No device match found\n");
+		return -ENODEV;
+	}
+	tegra->soc_config = match->data;
+
+	/*
+	 * Right now device-tree probed devices don't get dma_mask set.
+	 * Since shared usb code relies on it, set it here for now.
+	 * Once we have dma capability bindings this can go away.
+	 */
+	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret)
+		return ret;
+
+	hcd = usb_create_hcd(&tegra_xhci_hc_driver, &pdev->dev,
+				    dev_name(&pdev->dev));
+	if (!hcd)
+		return -ENOMEM;
+	tegra->hcd = hcd;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		ret = PTR_ERR(hcd->regs);
+		goto put_hcd;
+	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	tegra->fpci_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(tegra->fpci_base)) {
+		ret = PTR_ERR(tegra->fpci_base);
+		goto put_hcd;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	tegra->ipfs_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(tegra->ipfs_base)) {
+		ret = PTR_ERR(tegra->ipfs_base);
+		goto put_hcd;
+	}
+
+	tegra->irq = platform_get_irq(pdev, 0);
+	if (tegra->irq < 0) {
+		ret = tegra->irq;
+		goto put_hcd;
+	}
+
+	tegra->host_rst = devm_reset_control_get(&pdev->dev, "xusb_host");
+	if (IS_ERR(tegra->host_rst)) {
+		ret = PTR_ERR(tegra->host_rst);
+		goto put_hcd;
+	}
+	tegra->ss_rst = devm_reset_control_get(&pdev->dev, "xusb_ss");
+	if (IS_ERR(tegra->ss_rst)) {
+		ret = PTR_ERR(tegra->ss_rst);
+		goto put_hcd;
+	}
+
+	tegra->host_clk = devm_clk_get(&pdev->dev, "xusb_host");
+	if (IS_ERR(tegra->host_clk)) {
+		ret = PTR_ERR(tegra->host_clk);
+		goto put_hcd;
+	}
+	tegra->falc_clk = devm_clk_get(&pdev->dev, "xusb_falcon_src");
+	if (IS_ERR(tegra->falc_clk)) {
+		ret = PTR_ERR(tegra->falc_clk);
+		goto put_hcd;
+	}
+	tegra->ss_clk = devm_clk_get(&pdev->dev, "xusb_ss");
+	if (IS_ERR(tegra->ss_clk)) {
+		ret = PTR_ERR(tegra->ss_clk);
+		goto put_hcd;
+	}
+	tegra->ss_src_clk = devm_clk_get(&pdev->dev, "xusb_ss_src");
+	if (IS_ERR(tegra->ss_src_clk)) {
+		ret = PTR_ERR(tegra->ss_src_clk);
+		goto put_hcd;
+	}
+	tegra->hs_src_clk = devm_clk_get(&pdev->dev, "xusb_hs_src");
+	if (IS_ERR(tegra->hs_src_clk)) {
+		ret = PTR_ERR(tegra->hs_src_clk);
+		goto put_hcd;
+	}
+	tegra->fs_src_clk = devm_clk_get(&pdev->dev, "xusb_fs_src");
+	if (IS_ERR(tegra->fs_src_clk)) {
+		ret = PTR_ERR(tegra->fs_src_clk);
+		goto put_hcd;
+	}
+	tegra->pll_u_480m = devm_clk_get(&pdev->dev, "pll_u_480m");
+	if (IS_ERR(tegra->pll_u_480m)) {
+		ret = PTR_ERR(tegra->pll_u_480m);
+		goto put_hcd;
+	}
+	tegra->clk_m = devm_clk_get(&pdev->dev, "clk_m");
+	if (IS_ERR(tegra->clk_m)) {
+		ret = PTR_ERR(tegra->clk_m);
+		goto put_hcd;
+	}
+	tegra->pll_e = devm_clk_get(&pdev->dev, "pll_e");
+	if (IS_ERR(tegra->pll_e)) {
+		ret = PTR_ERR(tegra->pll_e);
+		goto put_hcd;
+	}
+	ret = tegra_xhci_clk_enable(tegra);
+	if (ret)
+		goto put_hcd;
+
+	tegra->s3p3v_reg = devm_regulator_get(&pdev->dev, "s3p3v");
+	if (IS_ERR(tegra->s3p3v_reg)) {
+		ret = PTR_ERR(tegra->s3p3v_reg);
+		dev_info(&pdev->dev, "s3p3v get failed: %d\n", ret);
+		goto disable_clk;
+	}
+	tegra->s1p8v_reg = devm_regulator_get(&pdev->dev, "s1p8v");
+	if (IS_ERR(tegra->s1p8v_reg)) {
+		ret = PTR_ERR(tegra->s1p8v_reg);
+		dev_info(&pdev->dev, "s1p8v get failed: %d\n", ret);
+		goto disable_clk;
+	}
+	tegra->s1p05v_reg = devm_regulator_get(&pdev->dev, "s1p05v");
+	if (IS_ERR(tegra->s1p05v_reg)) {
+		ret = PTR_ERR(tegra->s1p05v_reg);
+		dev_info(&pdev->dev, "s1p05v get failed: %d\n", ret);
+		goto disable_clk;
+	}
+	ret = tegra_xhci_regulator_enable(tegra);
+	if (ret)
+		goto disable_clk;
+
+	tegra->mbox = tegra_xusb_mbox_lookup_by_phandle(pdev->dev.of_node,
+							"nvidia,xusb-mbox");
+	if (IS_ERR(tegra->mbox))
+		goto disable_regulator;
+	tegra->mbox_nb.notifier_call = tegra_xhci_mbox_notifier;
+	tegra_xusb_mbox_register_notifier(tegra->mbox, &tegra->mbox_nb);
+
+	j = 0;
+	for (i = 0; i < TEGRA_XHCI_UTMI_PHYS; i++) {
+		char prop[sizeof("utmi-N")];
+
+		sprintf(prop, "utmi-%d", i);
+		phy = devm_phy_optional_get(&pdev->dev, prop);
+		if (IS_ERR(phy)) {
+			ret = PTR_ERR(phy);
+			goto unregister_notifier;
+		}
+		tegra->phys[j++] = phy;
+	}
+	for (i = 0; i < TEGRA_XHCI_HSIC_PHYS; i++) {
+		char prop[sizeof("hsic-N")];
+
+		sprintf(prop, "hsic-%d", i);
+		phy = devm_phy_optional_get(&pdev->dev, prop);
+		if (IS_ERR(phy)) {
+			ret = PTR_ERR(phy);
+			goto unregister_notifier;
+		}
+		tegra->phys[j++] = phy;
+	}
+	for (i = 0; i < TEGRA_XHCI_USB3_PHYS; i++) {
+		char prop[sizeof("usb3-N")];
+
+		sprintf(prop, "usb3-%d", i);
+		phy = devm_phy_optional_get(&pdev->dev, prop);
+		if (IS_ERR(phy)) {
+			ret = PTR_ERR(phy);
+			goto unregister_notifier;
+		}
+		tegra->phys[j++] = phy;
+	}
+
+	/* Setup IPFS access and BAR0 space */
+	tegra_xhci_cfg(tegra);
+
+	ret = tegra_xhci_phy_enable(tegra);
+	if (ret < 0)
+		goto unregister_notifier;
+
+	ret = request_firmware_nowait(THIS_MODULE, true,
+				      tegra->soc_config->firmware_file,
+				      tegra->dev, GFP_KERNEL, tegra,
+				      tegra_xhci_probe_finish);
+	if (ret < 0)
+		goto disable_phy;
+
+	return 0;
+
+disable_phy:
+	tegra_xhci_phy_disable(tegra);
+unregister_notifier:
+	tegra_xusb_mbox_unregister_notifier(tegra->mbox, &tegra->mbox_nb);
+disable_regulator:
+	tegra_xhci_regulator_disable(tegra);
+disable_clk:
+	tegra_xhci_clk_disable(tegra);
+put_hcd:
+	usb_put_hcd(hcd);
+	return ret;
+}
+
+static int tegra_xhci_remove(struct platform_device *pdev)
+{
+	struct tegra_xhci_hcd *tegra = platform_get_drvdata(pdev);
+	struct usb_hcd *hcd = tegra->hcd;
+	struct xhci_hcd *xhci;
+
+	if (tegra->fw_loaded) {
+		xhci = hcd_to_xhci(hcd);
+		usb_remove_hcd(xhci->shared_hcd);
+		usb_put_hcd(xhci->shared_hcd);
+		usb_remove_hcd(hcd);
+		usb_put_hcd(hcd);
+		kfree(xhci);
+	} else if (hcd) {
+		/* Unbound after probe(), but before firmware loading. */
+		usb_put_hcd(hcd);
+	}
+
+	if (tegra->fw_data)
+		dma_free_coherent(tegra->dev, tegra->fw_size, tegra->fw_data,
+				  tegra->fw_dma_addr);
+
+	tegra_xusb_mbox_unregister_notifier(tegra->mbox, &tegra->mbox_nb);
+	tegra_xhci_phy_disable(tegra);
+	tegra_xhci_regulator_disable(tegra);
+	tegra_xhci_clk_disable(tegra);
+
+	return 0;
+}
+
+static struct platform_driver tegra_xhci_driver = {
+	.probe	= tegra_xhci_probe,
+	.remove	= tegra_xhci_remove,
+	.driver	= {
+		.name = "tegra-xhci",
+		.of_match_table = of_match_ptr(tegra_xhci_of_match),
+	},
+};
+module_platform_driver(tegra_xhci_driver);
+
+MODULE_DESCRIPTION("NVIDIA Tegra XHCI host-controller driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tegra-xhci");
-- 
2.0.0.526.g5318336

