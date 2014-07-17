Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaGQJC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:02:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51520 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbaGQJCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:02:50 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <jg1.han@samsung.com>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 2/4] PCI: designware: use untranslated address while programming ATU
Date: Thu, 17 Jul 2014 14:30:41 +0530
Message-ID: <1405587643-13808-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405587643-13808-1-git-send-email-kishon@ti.com>
References: <1405587643-13808-1-git-send-email-kishon@ti.com>
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

This is needed when the dt node is modelled something like below
axi {
	compatible = "simple-bus";
	#size-cells = <1>;
	#address-cells = <1>;
	ranges = <0x0        0x20000000 0x10000000 // 28-bit bus
		  0x51000000 0x51000000 0x3000>;
	pcie@51000000 {
		reg = <0x1000 0x2000>, <0x51002000 0x14c>, <0x51000000 0x2000>;
		reg-names = "config", "ti_conf", "rc_dbics";
		#address-cells = <3>;
		#size-cells = <2>;
		ranges = <0x81000000 0 0          0x03000 0 0x00010000
			  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
	};
};

Here the CPU address for configuration space is 0x20013000 and the controller
address for configuration space is 0x13000. The controller address should be
used while programming the ATU (in order for translation to happen properly in
DRA7xx).

Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/pci/host/pcie-designware.c |   55 +++++++++++++++++++++++++++---------
 drivers/pci/host/pcie-designware.h |    4 +++
 2 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 0b7b455..8aab1d6 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -401,8 +401,15 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	struct of_pci_range range;
 	struct of_pci_range_parser parser;
 	struct resource *cfg_res;
-	u32 val;
-	int i;
+	u32 val, na, ns;
+	const __be32 *addrp;
+	int i, index;
+
+	/* Find the address cell size and the number of cells in order to get
+	 * the untranslated address.
+	 */
+	of_property_read_u32(np, "#address-cells", &na);
+	ns = of_n_size_cells(np);
 
 	cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
 	if (cfg_res) {
@@ -410,6 +417,12 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		pp->config.cfg1_size = resource_size(cfg_res)/2;
 		pp->cfg0_base = cfg_res->start;
 		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
+
+		/* Find the untranslated configuration space address */
+		index = of_property_match_string(np, "reg-names", "config");
+		addrp = of_get_address(np, index, false, false);
+		pp->cfg0_mod_base = of_read_number(addrp, ns);
+		pp->cfg1_mod_base = pp->cfg0_mod_base + pp->config.cfg0_size;
 	} else {
 		dev_err(pp->dev, "missing *config* reg space\n");
 	}
@@ -435,12 +448,20 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 			pp->config.io_size = resource_size(&pp->io);
 			pp->config.io_bus_addr = range.pci_addr;
 			pp->io_base = range.cpu_addr;
+
+			/* Find the untranslated IO space address */
+			pp->io_mod_base = of_read_number(parser.range -
+							 parser.np + na, ns);
 		}
 		if (restype == IORESOURCE_MEM) {
 			of_pci_range_to_resource(&range, np, &pp->mem);
 			pp->mem.name = "MEM";
 			pp->config.mem_size = resource_size(&pp->mem);
 			pp->config.mem_bus_addr = range.pci_addr;
+
+			/* Find the untranslated MEM space address */
+			pp->mem_mod_base = of_read_number(parser.range -
+							  parser.np + na, ns);
 		}
 		if (restype == 0) {
 			of_pci_range_to_resource(&range, np, &pp->cfg);
@@ -448,6 +469,12 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
 			pp->cfg0_base = pp->cfg.start;
 			pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
+
+			/* Find the untranslated configuration space address */
+			pp->cfg0_mod_base = of_read_number(parser.range -
+							   parser.np + na, ns);
+			pp->cfg1_mod_base = pp->cfg0_mod_base +
+					    pp->config.cfg0_size;
 		}
 	}
 
@@ -522,9 +549,9 @@ static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
 	/* Program viewport 0 : OUTBOUND : CFG0 */
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
 			  PCIE_ATU_VIEWPORT);
-	dw_pcie_writel_rc(pp, pp->cfg0_base, PCIE_ATU_LOWER_BASE);
-	dw_pcie_writel_rc(pp, (pp->cfg0_base >> 32), PCIE_ATU_UPPER_BASE);
-	dw_pcie_writel_rc(pp, pp->cfg0_base + pp->config.cfg0_size - 1,
+	dw_pcie_writel_rc(pp, pp->cfg0_mod_base, PCIE_ATU_LOWER_BASE);
+	dw_pcie_writel_rc(pp, (pp->cfg0_mod_base >> 32), PCIE_ATU_UPPER_BASE);
+	dw_pcie_writel_rc(pp, pp->cfg0_mod_base + pp->config.cfg0_size - 1,
 			  PCIE_ATU_LIMIT);
 	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET);
@@ -538,9 +565,9 @@ static void dw_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_CFG1, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, pp->cfg1_base, PCIE_ATU_LOWER_BASE);
-	dw_pcie_writel_rc(pp, (pp->cfg1_base >> 32), PCIE_ATU_UPPER_BASE);
-	dw_pcie_writel_rc(pp, pp->cfg1_base + pp->config.cfg1_size - 1,
+	dw_pcie_writel_rc(pp, pp->cfg1_mod_base, PCIE_ATU_LOWER_BASE);
+	dw_pcie_writel_rc(pp, (pp->cfg1_mod_base >> 32), PCIE_ATU_UPPER_BASE);
+	dw_pcie_writel_rc(pp, pp->cfg1_mod_base + pp->config.cfg1_size - 1,
 			  PCIE_ATU_LIMIT);
 	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET);
@@ -553,9 +580,9 @@ static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_MEM, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, pp->mem_base, PCIE_ATU_LOWER_BASE);
-	dw_pcie_writel_rc(pp, (pp->mem_base >> 32), PCIE_ATU_UPPER_BASE);
-	dw_pcie_writel_rc(pp, pp->mem_base + pp->config.mem_size - 1,
+	dw_pcie_writel_rc(pp, pp->mem_mod_base, PCIE_ATU_LOWER_BASE);
+	dw_pcie_writel_rc(pp, (pp->mem_mod_base >> 32), PCIE_ATU_UPPER_BASE);
+	dw_pcie_writel_rc(pp, pp->mem_mod_base + pp->config.mem_size - 1,
 			  PCIE_ATU_LIMIT);
 	dw_pcie_writel_rc(pp, pp->config.mem_bus_addr, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.mem_bus_addr),
@@ -569,9 +596,9 @@ static void dw_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_IO, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, pp->io_base, PCIE_ATU_LOWER_BASE);
-	dw_pcie_writel_rc(pp, (pp->io_base >> 32), PCIE_ATU_UPPER_BASE);
-	dw_pcie_writel_rc(pp, pp->io_base + pp->config.io_size - 1,
+	dw_pcie_writel_rc(pp, pp->io_mod_base, PCIE_ATU_LOWER_BASE);
+	dw_pcie_writel_rc(pp, (pp->io_mod_base >> 32), PCIE_ATU_UPPER_BASE);
+	dw_pcie_writel_rc(pp, pp->io_mod_base + pp->config.io_size - 1,
 			  PCIE_ATU_LIMIT);
 	dw_pcie_writel_rc(pp, pp->config.io_bus_addr, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.io_bus_addr),
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index 77f592f..add6527 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -36,11 +36,15 @@ struct pcie_port {
 	u8			root_bus_nr;
 	void __iomem		*dbi_base;
 	u64			cfg0_base;
+	u64			cfg0_mod_base;
 	void __iomem		*va_cfg0_base;
 	u64			cfg1_base;
+	u64			cfg1_mod_base;
 	void __iomem		*va_cfg1_base;
 	u64			io_base;
+	u64			io_mod_base;
 	u64			mem_base;
+	u64			mem_mod_base;
 	struct resource		cfg;
 	struct resource		io;
 	struct resource		mem;
-- 
1.7.9.5

