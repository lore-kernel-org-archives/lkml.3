Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaEFNfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:35:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54842 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaEFNfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:17 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Marek Vasut <marex@denx.de>
Subject: [PATCH 06/17] pci: host: pcie-designware: Use *base-mask* for configuring the iATU
Date: Tue, 6 May 2014 19:03:52 +0530
Message-ID: <1399383244-14556-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
address. So whenever the cpu issues a read/write request, the 4 most
significant bits are used by L3 to determine the target controller.
For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
the outbound translation window the *base* should be programmed as 0x000_0000.
Whenever we try to write to say 0x2000_0000, it will be translated to whatever
we have programmed in the translation window with base as 0x000_0000.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Mohit Kumar <mohit.kumar@st.com>
---
 .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
 drivers/pci/host/pcie-designware.c                 |   39 ++++++++++++++------
 drivers/pci/host/pcie-designware.h                 |    1 +
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
index d6fae13..c574dd3 100644
--- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
@@ -27,6 +27,7 @@ Optional properties for fsl,imx6q-pcie
 - power-on-gpio: gpio pin number of power-enable signal
 - wake-up-gpio: gpio pin number of incoming wakeup signal
 - disable-gpio: gpio pin number of outgoing rfkill/endpoint disable signal
+- base-mask: address mask for the PCIe controller target port
 
 Example:
 
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index c4e3732..243f148 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -463,6 +463,9 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		return -EINVAL;
 	}
 
+	if (of_property_read_u64(np, "base-mask", &pp->base_mask))
+		pp->base_mask = ~0x0ULL;
+
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
 					MAX_MSI_IRQS, &msi_domain_ops,
@@ -502,12 +505,15 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 
 static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
 {
+	u64 cfg0_base;
+
+	cfg0_base = pp->cfg0_base & pp->base_mask;
 	/* Program viewport 0 : OUTBOUND : CFG0 */
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
 			  PCIE_ATU_VIEWPORT);
-	dw_pcie_writel_rc(pp, pp->cfg0_base, PCIE_ATU_LOWER_BASE);
-	dw_pcie_writel_rc(pp, (pp->cfg0_base >> 32), PCIE_ATU_UPPER_BASE);
-	dw_pcie_writel_rc(pp, pp->cfg0_base + pp->config.cfg0_size - 1,
+	dw_pcie_writel_rc(pp, cfg0_base, PCIE_ATU_LOWER_BASE);
+	dw_pcie_writel_rc(pp, (cfg0_base >> 32), PCIE_ATU_UPPER_BASE);
+	dw_pcie_writel_rc(pp, cfg0_base + pp->config.cfg0_size - 1,
 			  PCIE_ATU_LIMIT);
 	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET);
@@ -517,13 +523,16 @@ static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
 
 static void dw_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
 {
+	u64 cfg1_base;
+
+	cfg1_base = pp->cfg1_base & pp->base_mask;
 	/* Program viewport 1 : OUTBOUND : CFG1 */
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_CFG1, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, pp->cfg1_base, PCIE_ATU_LOWER_BASE);
-	dw_pcie_writel_rc(pp, (pp->cfg1_base >> 32), PCIE_ATU_UPPER_BASE);
-	dw_pcie_writel_rc(pp, pp->cfg1_base + pp->config.cfg1_size - 1,
+	dw_pcie_writel_rc(pp, cfg1_base, PCIE_ATU_LOWER_BASE);
+	dw_pcie_writel_rc(pp, (cfg1_base >> 32), PCIE_ATU_UPPER_BASE);
+	dw_pcie_writel_rc(pp, cfg1_base + pp->config.cfg1_size - 1,
 			  PCIE_ATU_LIMIT);
 	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET);
@@ -532,13 +541,16 @@ static void dw_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
 
 static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
 {
+	u64 mem_base;
+
+	mem_base = pp->mem_base & pp->base_mask;
 	/* Program viewport 0 : OUTBOUND : MEM */
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_MEM, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, pp->mem_base, PCIE_ATU_LOWER_BASE);
-	dw_pcie_writel_rc(pp, (pp->mem_base >> 32), PCIE_ATU_UPPER_BASE);
-	dw_pcie_writel_rc(pp, pp->mem_base + pp->config.mem_size - 1,
+	dw_pcie_writel_rc(pp, mem_base, PCIE_ATU_LOWER_BASE);
+	dw_pcie_writel_rc(pp, (mem_base >> 32), PCIE_ATU_UPPER_BASE);
+	dw_pcie_writel_rc(pp, mem_base + pp->config.mem_size - 1,
 			  PCIE_ATU_LIMIT);
 	dw_pcie_writel_rc(pp, pp->config.mem_bus_addr, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.mem_bus_addr),
@@ -548,13 +560,16 @@ static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
 
 static void dw_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
 {
+	u64 io_base;
+
+	io_base = pp->io_base & pp->base_mask;
 	/* Program viewport 1 : OUTBOUND : IO */
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_IO, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, pp->io_base, PCIE_ATU_LOWER_BASE);
-	dw_pcie_writel_rc(pp, (pp->io_base >> 32), PCIE_ATU_UPPER_BASE);
-	dw_pcie_writel_rc(pp, pp->io_base + pp->config.io_size - 1,
+	dw_pcie_writel_rc(pp, io_base, PCIE_ATU_LOWER_BASE);
+	dw_pcie_writel_rc(pp, (io_base >> 32), PCIE_ATU_UPPER_BASE);
+	dw_pcie_writel_rc(pp, io_base + pp->config.io_size - 1,
 			  PCIE_ATU_LIMIT);
 	dw_pcie_writel_rc(pp, pp->config.io_bus_addr, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.io_bus_addr),
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index 3063b35..3fa12a6 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -35,6 +35,7 @@ struct pcie_port {
 	struct device		*dev;
 	u8			root_bus_nr;
 	void __iomem		*dbi_base;
+	u64			base_mask;
 	u64			cfg0_base;
 	void __iomem		*va_cfg0_base;
 	u64			cfg1_base;
-- 
1.7.9.5

