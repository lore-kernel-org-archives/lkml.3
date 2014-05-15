Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaEOAdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:33:23 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:63978 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaEOAdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:33:17 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [RFC PATCH 06/10] usb: xhci: Add Tegra XHCI host-controller driver
Date: Wed, 14 May 2014 17:33:02 -0700
Message-Id: <1400113986-339-7-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1400113986-339-1-git-send-email-abrestic@chromium.org>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the on-chip XHCI host controller present on NVIDIA
Tegra114 and later SoCs.

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
 .../devicetree/bindings/usb/nvidia,tegra-xhci.txt  |  42 ++
 drivers/usb/host/Kconfig                           |  12 +
 drivers/usb/host/Makefile                          |   2 +
 drivers/usb/host/xhci-tegra.c                      | 796 +++++++++++++++++++++
 drivers/usb/host/xhci-tegra.h                      | 131 ++++
 include/linux/usb/tegra_xusb.h                     |  66 ++
 6 files changed, 1049 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra-xhci.txt
 create mode 100644 drivers/usb/host/xhci-tegra.c
 create mode 100644 drivers/usb/host/xhci-tegra.h
 create mode 100644 include/linux/usb/tegra_xusb.h

diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra-xhci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra-xhci.txt
new file mode 100644
index 0000000..6d94bd6
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra-xhci.txt
@@ -0,0 +1,42 @@
+NVIDIA Tegra XHCI controller
+
+The device node for the Tegra XHCI host controller present on Tegra114 and
+later SoCs.
+
+Required properties:
+ - compatible: Should be "nvidia,tegra114-xhci" or "nvidia,tegra124-xhci".
+ - reg: Address and length of the register sets.  There should be three
+   entries in the following order: XHCI host registers, FPCI registers, and
+   IPFS registers.
+ - interrupts: Interrupts used by the controller.  There should be two
+   entries in the following order: XHCI host interrupt and firmware mailbox
+   interrupt.
+ - clocks: Handles to XUSB host and falcon clocks.
+ - clock-names: Should be "xusb_host" and "xusb_falcon_src", respecitively.
+ - resets: Handle to XUSB host reset.
+ - reset-names: Should be "xusb_host".
+ - phys: Handle to the XUSB PHY.
+ - phy-names: Should be "xusb".
+ - s1p05v-supply: 1.05V supply regulator.
+ - s1p8v-supply: 1.8V supply regulator.
+ - s3p3v-supply: 3.3V supply regulator.
+
+Example:
+	usb@0,70090000 {
+		compatible = "nvidia,tegra114-xhci", "nvidia,tegra124-xhci";
+		reg = <0x0 0x70090000 0x0 0x8000>,
+		      <0x0 0x70098000 0x0 0x1000>,
+		      <0x0 0x70099000 0x0 0x1000>;
+		interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA124_CLK_XUSB_HOST>,
+			 <&tegra_car TEGRA124_CLK_XUSB_FALCON_SRC>;
+		clock-names = "xusb_host", "xusb_falcon_src";
+		resets = <&tegra_car 89>;
+		reset-names = "xusb_host";
+		phy = <&xusb_phy>;
+		phy-names = "xusb";
+		s1p05v-supply = <&vdd_1v05_run>;
+		s3p3v-supply = <&vdd_3v3_lp0>;
+		s1p8v-supply = <&vddio_1v8>;
+	};
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 3d9e540..43f7977 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -29,6 +29,18 @@ if USB_XHCI_HCD
 config USB_XHCI_PLATFORM
 	tristate
 
+config USB_XHCI_TEGRA
+	tristate "Support for NVIDIA Tegra XHCI host controller"
+	depends on ARCH_TEGRA
+	select USB_XHCI_PLATFORM
+	select PHY_TEGRA_XUSB
+	select FW_LOADER
+	---help---
+	  Enables support for the on-chip XHCI controller present on NVIDIA
+	  Tegra114 and later SoCs.
+
+	  If unsure, say N.
+
 endif # USB_XHCI_HCD
 
 config USB_EHCI_HCD
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 7530468..5941d36 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -38,6 +38,8 @@ obj-$(CONFIG_USB_EHCI_MSM)	+= ehci-msm.o
 obj-$(CONFIG_USB_EHCI_TEGRA)	+= ehci-tegra.o
 obj-$(CONFIG_USB_W90X900_EHCI)	+= ehci-w90x900.o
 
+obj-$(CONFIG_USB_XHCI_TEGRA)	+= xhci-tegra.o
+
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
new file mode 100644
index 0000000..5c705b7
--- /dev/null
+++ b/drivers/usb/host/xhci-tegra.c
@@ -0,0 +1,796 @@
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
+#include <linux/usb/tegra_xusb.h>
+
+#include "xhci-tegra.h"
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
+	struct platform_device *xhci_pdev;
+
+	int mbox_irq;
+	struct notifier_block mbox_nb;
+
+	phys_addr_t host_phys_base;
+	void __iomem *fpci_base;
+	void __iomem *ipfs_base;
+
+	const struct tegra_xhci_soc_config *soc_config;
+
+	struct regulator *xusb_s1p05v_reg;
+	struct regulator *xusb_s3p3v_reg;
+	struct regulator *xusb_s1p8v_reg;
+
+	/* XUSB host clock */
+	struct clk *host_clk;
+	/* XUSB Falcon controller clock */
+	struct clk *falc_clk;
+	/* XUSB host reset */
+	struct reset_control *host_rst;
+
+	/* XUSB PHY */
+	struct phy *phy;
+
+	/* Firmware loading related */
+	void *fw_data;
+	size_t fw_size;
+	dma_addr_t fw_dma_addr;
+};
+
+static RAW_NOTIFIER_HEAD(tegra_xhci_mbox_notifiers);
+static DEFINE_MUTEX(tegra_xhci_mbox_lock);
+
+int tegra_xhci_register_mbox_notifier(struct notifier_block *nb)
+{
+	int ret;
+
+	mutex_lock(&tegra_xhci_mbox_lock);
+	ret = raw_notifier_chain_register(&tegra_xhci_mbox_notifiers, nb);
+	mutex_unlock(&tegra_xhci_mbox_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(tegra_xhci_register_mbox_notifier);
+
+void tegra_xhci_unregister_mbox_notifier(struct notifier_block *nb)
+{
+	mutex_lock(&tegra_xhci_mbox_lock);
+	raw_notifier_chain_unregister(&tegra_xhci_mbox_notifiers, nb);
+	mutex_unlock(&tegra_xhci_mbox_lock);
+}
+EXPORT_SYMBOL(tegra_xhci_unregister_mbox_notifier);
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
+	reg |= tegra->host_phys_base;
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
+static int tegra_xhci_mbox_send(struct tegra_xhci_hcd *tegra,
+				enum tegra_xusb_mbox_cmd type, u32 data)
+{
+	struct device *dev = tegra->dev;
+	unsigned long timeout;
+	u32 reg;
+
+	dev_dbg(dev, "MBOX send message 0x%x:0x%x\n", type, data);
+	mutex_lock(&tegra_xhci_mbox_lock);
+
+	timeout = jiffies + msecs_to_jiffies(20);
+	/* Wait for mailbox to become idle */
+	while ((fpci_readl(tegra, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_NONE)
+	       && time_is_after_jiffies(timeout)) {
+		mutex_unlock(&tegra_xhci_mbox_lock);
+		usleep_range(100, 200);
+		mutex_lock(&tegra_xhci_mbox_lock);
+	}
+	if (fpci_readl(tegra, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_NONE) {
+		dev_err(dev, "Mailbox failed to go idle\n");
+		goto timeout;
+	}
+
+	timeout = jiffies + msecs_to_jiffies(10);
+	/* Acquire mailbox */
+	fpci_writel(tegra, MBOX_OWNER_SW, XUSB_CFG_ARU_MBOX_OWNER);
+	while ((fpci_readl(tegra, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_SW) &&
+	       time_is_after_jiffies(timeout)) {
+		mutex_unlock(&tegra_xhci_mbox_lock);
+		usleep_range(100, 200);
+		mutex_lock(&tegra_xhci_mbox_lock);
+		fpci_writel(tegra, MBOX_OWNER_SW, XUSB_CFG_ARU_MBOX_OWNER);
+	}
+	if (fpci_readl(tegra, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_SW) {
+		dev_err(dev, "Acquire mailbox timeout\n");
+		goto timeout;
+	}
+
+	reg = (type & CMD_TYPE_MASK) << CMD_TYPE_SHIFT;
+	reg |= (data & CMD_DATA_MASK) << CMD_DATA_SHIFT;
+	fpci_writel(tegra, reg, XUSB_CFG_ARU_MBOX_DATA_IN);
+
+	reg = fpci_readl(tegra, XUSB_CFG_ARU_MBOX_CMD);
+	reg |= MBOX_INT_EN | MBOX_FALC_INT_EN;
+	fpci_writel(tegra, reg, XUSB_CFG_ARU_MBOX_CMD);
+
+	mutex_unlock(&tegra_xhci_mbox_lock);
+
+	return 0;
+timeout:
+	mutex_unlock(&tegra_xhci_mbox_lock);
+	return -ETIMEDOUT;
+}
+
+static irqreturn_t tegra_xhci_mbox_irq(int irq, void *p)
+{
+	struct tegra_xhci_hcd *tegra = (struct tegra_xhci_hcd *)p;
+	struct device *dev = tegra->dev;
+	u32 resp = 0, cmd_type, cmd_data, reg;
+
+	mutex_lock(&tegra_xhci_mbox_lock);
+
+	/* Clear mbox interrupts */
+	reg = fpci_readl(tegra, XUSB_CFG_ARU_SMI_INTR);
+	if (reg & MBOX_SMI_INTR_FW_HANG)
+		dev_err(dev, "Hang up inside firmware\n");
+	fpci_writel(tegra, reg, XUSB_CFG_ARU_SMI_INTR);
+
+	/* Get the mbox message from firmware */
+	reg = fpci_readl(tegra, XUSB_CFG_ARU_MBOX_DATA_OUT);
+	cmd_type = (reg >> CMD_TYPE_SHIFT) & CMD_TYPE_MASK;
+	cmd_data = (reg >> CMD_DATA_SHIFT) & CMD_DATA_MASK;
+
+	/* Decode the message and call the notifiers */
+	dev_dbg(dev, "MBOX receive message 0x%x:0x%x\n", cmd_type, cmd_data);
+	if (cmd_type < MBOX_CMD_MAX) {
+		struct mbox_notifier_data mbox_info;
+
+		mbox_info.msg_data = cmd_data;
+		mbox_info.resp_cmd = 0;
+		mbox_info.resp_data = 0;
+		raw_notifier_call_chain(&tegra_xhci_mbox_notifiers, cmd_type,
+					&mbox_info);
+		if (mbox_info.resp_cmd) {
+			resp = (mbox_info.resp_cmd & CMD_TYPE_MASK) <<
+				CMD_TYPE_SHIFT;
+			resp |= (mbox_info.resp_data & CMD_DATA_MASK) <<
+				CMD_DATA_SHIFT;
+		}
+	} else if (cmd_type == MBOX_CMD_ACK) {
+		dev_dbg(dev, "Firmware responds with ACK\n");
+	} else if (cmd_type == MBOX_CMD_NAK) {
+		dev_err(dev, "Firmware responds with NAK\n");
+	} else {
+		dev_err(dev, "Invalid command %x\n", cmd_type);
+	}
+
+	if (resp) {
+		/* Send ACK/NAK to firmware */
+		fpci_writel(tegra, resp, XUSB_CFG_ARU_MBOX_DATA_IN);
+		reg = fpci_readl(tegra, XUSB_CFG_ARU_MBOX_CMD);
+		reg |= MBOX_INT_EN | MBOX_FALC_INT_EN;
+		fpci_writel(tegra, reg, XUSB_CFG_ARU_MBOX_CMD);
+	} else {
+		/* Clear MBOX_SMI_INT_EN bit */
+		reg = fpci_readl(tegra, XUSB_CFG_ARU_MBOX_CMD);
+		reg &= ~MBOX_SMI_INT_EN;
+		fpci_writel(tegra, reg, XUSB_CFG_ARU_MBOX_CMD);
+		/* Clear mailbox ownership */
+		fpci_writel(tegra, MBOX_OWNER_NONE, XUSB_CFG_ARU_MBOX_OWNER);
+	}
+
+	mutex_unlock(&tegra_xhci_mbox_lock);
+
+	return IRQ_HANDLED;
+}
+
+static int tegra_xhci_default_mbox_notifier(struct notifier_block *nb,
+					    unsigned long event, void *p)
+{
+	struct tegra_xhci_hcd *tegra = container_of(nb, struct tegra_xhci_hcd,
+						    mbox_nb);
+	struct mbox_notifier_data *data = (struct mbox_notifier_data *)p;
+
+	switch (event) {
+	case MBOX_CMD_INC_FALC_CLOCK:
+	case MBOX_CMD_DEC_FALC_CLOCK:
+		data->resp_data = clk_get_rate(tegra->falc_clk) / 1000;
+		if (data->resp_data != data->msg_data)
+			data->resp_cmd = MBOX_CMD_NAK;
+		else
+			data->resp_cmd = MBOX_CMD_ACK;
+		return NOTIFY_STOP;
+	case MBOX_CMD_SET_BW:
+		/* No support for EMC scaling yet */
+		return NOTIFY_STOP;
+	default:
+		return NOTIFY_DONE;
+	}
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
+static int tegra_xhci_regulator_init(struct tegra_xhci_hcd *tegra)
+{
+	struct device *dev = tegra->dev;
+	int err = 0;
+
+	tegra->xusb_s3p3v_reg = devm_regulator_get(dev, "s3p3v");
+	if (IS_ERR(tegra->xusb_s3p3v_reg)) {
+		dev_err(dev, "s3p3v regulator not found: %ld.",
+			PTR_ERR(tegra->xusb_s3p3v_reg));
+		return PTR_ERR(tegra->xusb_s3p3v_reg);
+	}
+	err = regulator_enable(tegra->xusb_s3p3v_reg);
+	if (err < 0) {
+		dev_err(dev, "s3p3v regulator enable failed:%d\n", err);
+		return err;
+	}
+
+	tegra->xusb_s1p8v_reg = devm_regulator_get(dev, "s1p8v");
+	if (IS_ERR(tegra->xusb_s1p8v_reg)) {
+		dev_err(dev, "s1p8v regulator not found: %ld.",
+			PTR_ERR(tegra->xusb_s1p8v_reg));
+		err = PTR_ERR(tegra->xusb_s1p8v_reg);
+		goto err_put_s3p3v_reg;
+	} else {
+		err = regulator_enable(tegra->xusb_s1p8v_reg);
+		if (err < 0) {
+			dev_err(dev, "s1p8v regulator enable failed:%d\n", err);
+			goto err_put_s3p3v_reg;
+		}
+	}
+
+	tegra->xusb_s1p05v_reg = devm_regulator_get(dev, "s1p05v");
+	if (IS_ERR(tegra->xusb_s1p05v_reg)) {
+		dev_err(dev, "s1p05v regulator not found: %ld.",
+			PTR_ERR(tegra->xusb_s1p05v_reg));
+		err = PTR_ERR(tegra->xusb_s1p05v_reg);
+		goto err_put_s1p8v_reg;
+	} else {
+		err = regulator_enable(tegra->xusb_s1p05v_reg);
+		if (err < 0) {
+			dev_err(dev,
+				"s1p05v regulator enable failed:%d\n", err);
+			goto err_put_s1p8v_reg;
+		}
+	}
+
+	return 0;
+
+err_put_s1p8v_reg:
+	regulator_disable(tegra->xusb_s1p8v_reg);
+err_put_s3p3v_reg:
+	regulator_disable(tegra->xusb_s3p3v_reg);
+	return err;
+}
+
+static void tegra_xhci_regulator_deinit(struct tegra_xhci_hcd *tegra)
+{
+	regulator_disable(tegra->xusb_s1p05v_reg);
+	regulator_disable(tegra->xusb_s1p8v_reg);
+	regulator_disable(tegra->xusb_s3p3v_reg);
+}
+
+static int tegra_xhci_clk_init(struct tegra_xhci_hcd *tegra)
+{
+	struct device *dev = tegra->dev;
+	int err = 0;
+
+	tegra->host_clk = devm_clk_get(dev, "xusb_host");
+	if (IS_ERR(tegra->host_clk)) {
+		dev_err(dev, "Failed to get xusb_host clk\n");
+		err = PTR_ERR(tegra->host_clk);
+		return err;
+	}
+
+	tegra->falc_clk = devm_clk_get(dev, "xusb_falcon_src");
+	if (IS_ERR(tegra->falc_clk)) {
+		dev_err(dev, "Failed to get xusb_falcon_src clk\n");
+		err = PTR_ERR(tegra->falc_clk);
+		return err;
+	}
+
+	clk_prepare_enable(tegra->host_clk);
+	clk_prepare_enable(tegra->falc_clk);
+
+	return 0;
+}
+
+static void tegra_xhci_clk_deinit(struct tegra_xhci_hcd *tegra)
+{
+	clk_disable_unprepare(tegra->host_clk);
+	clk_disable_unprepare(tegra->falc_clk);
+}
+
+static const struct tegra_xhci_soc_config tegra114_soc_config = {
+	.firmware_file = "tegra11x/tegra_xusb_firmware",
+};
+
+static const struct tegra_xhci_soc_config tegra124_soc_config = {
+	.firmware_file = "tegra12x/tegra_xusb_firmware",
+};
+
+static struct of_device_id tegra_xhci_of_match[] = {
+	{ .compatible = "nvidia,tegra114-xhci", .data = &tegra114_soc_config },
+	{ .compatible = "nvidia,tegra124-xhci", .data = &tegra124_soc_config },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_xhci_of_match);
+
+static void tegra_xhci_probe_finish(const struct firmware *fw, void *context)
+{
+	struct tegra_xhci_hcd *tegra = context;
+	struct device *dev = tegra->dev;
+	struct platform_device *xhci = NULL;
+	struct resource xhci_resources[2];
+	struct resource	*res;
+	struct tegra_xhci_fw_cfgtbl *cfg_tbl;
+	int ret;
+
+	if (!fw) {
+		dev_err(dev, "Failed to load firmware file\n");
+		ret = -ENOENT;
+		goto out;
+	}
+
+	/* Load Falcon controller with its firmware */
+	cfg_tbl = (struct tegra_xhci_fw_cfgtbl *)fw->data;
+	tegra->fw_size = cfg_tbl->fwimg_len;
+	tegra->fw_data = dma_alloc_coherent(dev, tegra->fw_size,
+					    &tegra->fw_dma_addr,
+					    GFP_KERNEL);
+	if (!tegra->fw_data) {
+		dev_err(dev, "Failed to allocate DMA buffer for firmware\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(tegra->fw_data, fw->data, tegra->fw_size);
+
+	ret = tegra_xhci_load_firmware(tegra);
+	if (ret < 0) {
+		dev_err(dev, "Failed to load controller firmware\n");
+		goto out;
+	}
+
+	/* Set up mailbox notifier and interrupt handler */
+	tegra->mbox_nb.notifier_call = tegra_xhci_default_mbox_notifier;
+	ret = tegra_xhci_register_mbox_notifier(&tegra->mbox_nb);
+	if (ret < 0) {
+		dev_err(dev, "Failed to registe mbox handler\n");
+		goto out;
+	}
+	tegra->mbox_irq = platform_get_irq(to_platform_device(dev), 1);
+	if (!tegra->mbox_irq) {
+		dev_err(dev, "Missing MBOX IRQ\n");
+		ret = -ENODEV;
+		goto out;
+	}
+	ret = devm_request_threaded_irq(dev, tegra->mbox_irq, NULL,
+					tegra_xhci_mbox_irq, IRQF_ONESHOT,
+					"tegra_xhci_mbox_irq", tegra);
+	if (ret != 0) {
+		dev_err(dev, "Failed to request MBOX IRQ\n");
+		goto out;
+	}
+
+	/* Create child xhci-plat device */
+	memset(xhci_resources, 0, sizeof(xhci_resources));
+	res = platform_get_resource(to_platform_device(dev), IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "Missing XHCI IRQ\n");
+		ret = -ENODEV;
+		goto out;
+	}
+	xhci_resources[0].start = res->start;
+	xhci_resources[0].end = res->end;
+	xhci_resources[0].flags = res->flags;
+	xhci_resources[0].name = res->name;
+	res = platform_get_resource(to_platform_device(dev), IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "Missing XHCI registers\n");
+		ret = -ENODEV;
+		goto out;
+	}
+	xhci_resources[1].start = res->start;
+	xhci_resources[1].end = res->end;
+	xhci_resources[1].flags = res->flags;
+	xhci_resources[1].name = res->name;
+
+	xhci = platform_device_alloc("xhci-hcd", PLATFORM_DEVID_AUTO);
+	if (!xhci) {
+		dev_err(dev, "Failed to allocate XHCI host\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	xhci->dev.parent = dev;
+	ret = dma_coerce_mask_and_coherent(&xhci->dev,
+					   dev->coherent_dma_mask);
+	if (ret) {
+		dev_err(dev, "Failed to set XHCI dma mask\n");
+		goto out;
+	}
+	ret = platform_device_add_resources(xhci, xhci_resources,
+					    ARRAY_SIZE(xhci_resources));
+	if (ret) {
+		dev_err(dev, "Failed to add XHCI resources\n");
+		goto out;
+	}
+	ret = platform_device_add(xhci);
+	if (ret) {
+		dev_err(dev, "failed to register XHCI device\n");
+		goto out;
+	}
+	tegra->xhci_pdev = xhci;
+
+	/* Enable firmware messages from controller */
+	tegra_xhci_mbox_send(tegra, MBOX_CMD_MSG_ENABLED, 0);
+
+out:
+	release_firmware(fw);
+	if (ret)
+		platform_device_put(xhci);
+}
+
+static int tegra_xhci_probe(struct platform_device *pdev)
+{
+	struct tegra_xhci_hcd *tegra;
+	struct resource	*res;
+	const struct of_device_id *match;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct tegra_xhci_fw_cfgtbl) != 256);
+
+	tegra = devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
+	if (!tegra) {
+		dev_err(&pdev->dev, "memory alloc failed\n");
+		return -ENOMEM;
+	}
+	platform_set_drvdata(pdev, tegra);
+	tegra->dev = &pdev->dev;
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
+	/*
+	 * The firmware needs the XHCI host's base physical address.
+	 * Get it here and save it for later.
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Missing XHCI registers\n");
+		return -ENODEV;
+	}
+	tegra->host_phys_base = res->start;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	tegra->fpci_base = devm_ioremap_resource(&pdev->dev, res);
+	if (!tegra->fpci_base) {
+		dev_err(&pdev->dev, "Failed to map FPCI registers\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	tegra->ipfs_base = devm_ioremap_resource(&pdev->dev, res);
+	if (!tegra->ipfs_base) {
+		dev_err(&pdev->dev, "Failed to map IPFS registers\n");
+		return -ENOMEM;
+	}
+
+	tegra->phy = devm_phy_get(&pdev->dev, "xusb");
+	if (IS_ERR(tegra->phy)) {
+		dev_err(&pdev->dev, "Failed to get PHY\n");
+		return PTR_ERR(tegra->phy);
+	}
+	ret = phy_init(tegra->phy);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "PHY initialization failed\n");
+		return ret;
+	}
+
+	tegra->host_rst = devm_reset_control_get(&pdev->dev, "xusb_host");
+	if (IS_ERR(tegra->host_rst)) {
+		dev_err(&pdev->dev, "Failed to get host reset\n");
+		ret = PTR_ERR(tegra->host_rst);
+		goto err_deinit_phy;
+	}
+
+	ret = tegra_xhci_clk_init(tegra);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize XHCI clocks\n");
+		goto err_deinit_phy;
+	}
+
+	ret = tegra_xhci_regulator_init(tegra);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize XHCI regulators\n");
+		goto err_deinit_clk;
+	}
+
+	/* Setup IPFS access and BAR0 space */
+	tegra_xhci_cfg(tegra);
+
+	ret = phy_power_on(tegra->phy);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "PHY power up failed\n");
+		goto err_deinit_regulator;
+	}
+
+	ret = request_firmware_nowait(THIS_MODULE, true,
+				      tegra->soc_config->firmware_file,
+				      tegra->dev, GFP_KERNEL, tegra,
+				      tegra_xhci_probe_finish);
+	if (ret < 0) {
+		dev_err(tegra->dev, "Failed to request firmware\n");
+		goto err_shutdown_phy;
+	}
+
+	return 0;
+
+err_shutdown_phy:
+	phy_power_off(tegra->phy);
+err_deinit_regulator:
+	tegra_xhci_regulator_deinit(tegra);
+err_deinit_clk:
+	tegra_xhci_clk_deinit(tegra);
+err_deinit_phy:
+	phy_exit(tegra->phy);
+
+	return ret;
+}
+
+static int tegra_xhci_remove(struct platform_device *pdev)
+{
+	struct tegra_xhci_hcd *tegra = platform_get_drvdata(pdev);
+
+	phy_power_off(tegra->phy);
+	phy_exit(tegra->phy);
+
+	if (tegra->fw_data)
+		dma_free_coherent(tegra->dev, tegra->fw_size, tegra->fw_data,
+				  tegra->fw_dma_addr);
+
+	tegra_xhci_unregister_mbox_notifier(&tegra->mbox_nb);
+	tegra_xhci_regulator_deinit(tegra);
+	tegra_xhci_clk_deinit(tegra);
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
diff --git a/drivers/usb/host/xhci-tegra.h b/drivers/usb/host/xhci-tegra.h
new file mode 100644
index 0000000..b65bfdb
--- /dev/null
+++ b/drivers/usb/host/xhci-tegra.h
@@ -0,0 +1,131 @@
+/*
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
+#ifndef __XHCI_TEGRA_H
+#define __XHCI_TEGRA_H
+
+/* FPCI CFG registers */
+#define XUSB_CFG_0				0x0
+#define XUSB_CFG_1				0x4
+#define  XUSB_IO_SPACE_EN			BIT(0)
+#define  XUSB_MEM_SPACE_EN			BIT(1)
+#define  XUSB_BUS_MASTER_EN			BIT(2)
+#define XUSB_CFG_4				0x10
+#define XUSB_CFG_16				0x40
+#define XUSB_CFG_24				0x60
+#define XUSB_CFG_ARU_MBOX_CMD			0xe4
+#define  MBOX_FALC_INT_EN			BIT(27)
+#define  MBOX_PME_INT_EN			BIT(28)
+#define  MBOX_SMI_INT_EN			BIT(29)
+#define  MBOX_XHCI_INT_EN			BIT(30)
+#define  MBOX_INT_EN				BIT(31)
+#define XUSB_CFG_ARU_MBOX_DATA_IN		0xe8
+#define  CMD_DATA_SHIFT				0
+#define  CMD_DATA_MASK				0xffffff
+#define  CMD_TYPE_SHIFT				24
+#define  CMD_TYPE_MASK				0xff
+#define XUSB_CFG_ARU_MBOX_DATA_OUT		0xec
+#define XUSB_CFG_ARU_MBOX_OWNER			0xf0
+#define  MBOX_OWNER_NONE			0
+#define  MBOX_OWNER_FW				1
+#define  MBOX_OWNER_SW				2
+#define XUSB_CFG_FPCICFG			0xf8
+#define XUSB_CFG_ARU_C11PAGESEL0		0x400
+#define XUSB_CFG_ARU_C11PAGESEL1		0x404
+#define XUSB_CFG_ARU_C11_CSBRANGE		0x41c
+#define XUSB_CFG_ARU_SMI_INTR			0x428
+#define  MBOX_SMI_INTR_FW_HANG			BIT(1)
+#define  MBOX_SMI_INTR_EN			BIT(3)
+#define XUSB_CFG_ARU_RST			0x42c
+#define XUSB_CFG_ARU_CONTEXT			0x43c
+#define XUSB_CFG_ARU_FW_SCRATCH			0x440
+#define XUSB_CFG_ARU_CONTEXT_HS_PLS		0x478
+#define XUSB_CFG_ARU_CONTEXT_FS_PLS		0x47c
+#define XUSB_CFG_ARU_CONTEXT_HSFS_SPEED		0x480
+#define XUSB_CFG_ARU_CONTEXT_HSFS_PP		0x484
+#define XUSB_CFG_HSPX_CORE_HSICWRAP		0x658
+#define XUSB_CFG_CSB_BASE_ADDR			0x800
+
+/* IPFS registers */
+#define IPFS_XUSB_HOST_MSI_BAR_SZ_0		0xc0
+#define IPFS_XUSB_HOST_MSI_AXI_BAR_ST_0		0xc4
+#define IPFS_XUSB_HOST_FPCI_BAR_ST_0		0xc8
+#define IPFS_XUSB_HOST_MSI_VEC0_0		0x100
+#define IPFS_XUSB_HOST_MSI_EN_VEC0_0		0x140
+#define IPFS_XUSB_HOST_CONFIGURATION_0		0x180
+#define  IPFS_EN_FPCI				BIT(0)
+#define IPFS_XUSB_HOST_FPCI_ERROR_MASKS_0	0x184
+#define IPFS_XUSB_HOST_INTR_MASK_0		0x188
+#define  IPFS_IP_INT_MASK			BIT(16)
+#define IPFS_XUSB_HOST_IPFS_INTR_ENABLE_0	0x198
+#define IPFS_XUSB_HOST_UFPCI_CONFIG_0		0x19c
+#define IPFS_XUSB_HOST_CLKGATE_HYSTERESIS_0	0x1bc
+#define IPFS_XUSB_HOST_MCCIF_FIFOCTRL_0		0x1dc
+
+#define IMEM_BLOCK_SIZE				256
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
+#define XUSB_FALC_CMEMBASE			0x160
+#define XUSB_FALC_DMEMAPERT			0x164
+#define XUSB_FALC_IMEMC_START			0x180
+#define XUSB_FALC_IMEMD_START			0x184
+#define XUSB_FALC_IMEMT_START			0x188
+#define XUSB_FALC_ICD_CMD			0x200
+#define XUSB_FALC_ICD_RDATA			0x20C
+#define XUSB_FALC_SS_PVTPORTSC1			0x116000
+#define XUSB_FALC_SS_PVTPORTSC2			0x116004
+#define XUSB_FALC_SS_PVTPORTSC3			0x116008
+#define XUSB_FALC_HS_PVTPORTSC1			0x116800
+#define XUSB_FALC_HS_PVTPORTSC2			0x116804
+#define XUSB_FALC_HS_PVTPORTSC3			0x116808
+#define XUSB_FALC_FS_PVTPORTSC1			0x117000
+#define XUSB_FALC_FS_PVTPORTSC2			0x117004
+#define XUSB_FALC_FS_PVTPORTSC3			0x117008
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
+#endif /* __XHCI_TEGRA_H */
diff --git a/include/linux/usb/tegra_xusb.h b/include/linux/usb/tegra_xusb.h
new file mode 100644
index 0000000..1a654e7
--- /dev/null
+++ b/include/linux/usb/tegra_xusb.h
@@ -0,0 +1,66 @@
+/*
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
+#ifndef __TEGRA_XUSB_H
+#define __TEGRA_XUSB_H
+
+/* Command requests from the firmware */
+enum tegra_xusb_mbox_cmd {
+	MBOX_CMD_MSG_ENABLED = 1,
+	MBOX_CMD_INC_FALC_CLOCK,
+	MBOX_CMD_DEC_FALC_CLOCK,
+	MBOX_CMD_INC_SSPI_CLOCK,
+	MBOX_CMD_DEC_SSPI_CLOCK,
+	MBOX_CMD_SET_BW, /* no ACK/NAK required */
+	MBOX_CMD_SET_SS_PWR_GATING,
+	MBOX_CMD_SET_SS_PWR_UNGATING,
+	MBOX_CMD_SAVE_DFE_CTLE_CTX,
+	MBOX_CMD_AIRPLANE_MODE_ENABLED, /* unused */
+	MBOX_CMD_AIRPLANE_MODE_DISABLED, /* unused */
+	MBOX_CMD_START_HSIC_IDLE,
+	MBOX_CMD_STOP_HSIC_IDLE,
+	MBOX_CMD_DBC_WAKE_STACK, /* unused */
+	MBOX_CMD_HSIC_PRETEND_CONNECT,
+
+	MBOX_CMD_MAX,
+
+	/* Response message to above commands */
+	MBOX_CMD_ACK = 128,
+	MBOX_CMD_NAK
+};
+
+struct notifier_block;
+
+/*
+ * Tegra XUSB MBOX handler interface:
+ *   - Drivers which may handle mbox messages should register a notifier.
+ *   - The notifier event will be an mbox command (above) and the data will
+ *     be a pointer to struct mbox_notifier_data.
+ *   - If a notifier has handled the message, it should return NOTIFY_STOP
+ *     and populate resp_{cmd,data} appropriately.
+ *   - A resp_cmd of 0 indicates that no response should be sent.
+ */
+struct mbox_notifier_data {
+	u32 msg_data; /* Inbound message data */
+	u32 resp_cmd; /* Response message command */
+	u32 resp_data; /* Response message data */
+};
+
+extern int tegra_xhci_register_mbox_notifier(struct notifier_block *nb);
+extern void tegra_xhci_unregister_mbox_notifier(struct notifier_block *nb);
+
+#endif /* __TEGRA_XUSB_H */
-- 
1.9.1.423.g4596e3a

