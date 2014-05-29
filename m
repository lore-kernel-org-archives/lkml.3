Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbaE2Gp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:45:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59850 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932730AbaE2Gjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:39:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        <kishon@ti.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Marek Vasut <marex@denx.de>
Subject: [PATCH v2 03/18] PCI: designware: Configuration space should be specified in 'reg'
Date: Thu, 29 May 2014 12:08:05 +0530
Message-ID: <1401345500-20188-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401345500-20188-1-git-send-email-kishon@ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The configuration address space has so far been specified in *ranges*,
however it should be specified in *reg* making it a platform MEM resource.
Hence used 'platform_get_resource_*' API to get configuration address
space in the designware driver.

Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
 drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
index d6fae13..8314360 100644
--- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
@@ -6,6 +6,7 @@ Required properties:
 	as "samsung,exynos5440-pcie" or "fsl,imx6q-pcie".
 - reg: base addresses and lengths of the pcie controller,
 	the phy controller, additional register for the phy controller.
+	The configuration address space should also be specified here.
 - interrupts: interrupt values for level interrupt,
 	pulse interrupt, special interrupt.
 - clocks: from common clock binding: handle to pci clock.
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index c4e3732..603b386 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -20,6 +20,7 @@
 #include <linux/of_pci.h>
 #include <linux/pci.h>
 #include <linux/pci_regs.h>
+#include <linux/platform_device.h>
 #include <linux/types.h>
 
 #include "pcie-designware.h"
@@ -392,11 +393,23 @@ static const struct irq_domain_ops msi_domain_ops = {
 int __init dw_pcie_host_init(struct pcie_port *pp)
 {
 	struct device_node *np = pp->dev->of_node;
+	struct platform_device *pdev = to_platform_device(pp->dev);
 	struct of_pci_range range;
 	struct of_pci_range_parser parser;
+	struct resource *cfg_res;
 	u32 val;
 	int i;
 
+	cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
+	if (cfg_res) {
+		pp->config.cfg0_size = resource_size(cfg_res)/2;
+		pp->config.cfg1_size = resource_size(cfg_res)/2;
+		pp->cfg0_base = cfg_res->start;
+		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
+	} else {
+		dev_err(pp->dev, "missing *config* reg space\n");
+	}
+
 	if (of_pci_range_parser_init(&parser, np)) {
 		dev_err(pp->dev, "missing ranges property\n");
 		return -EINVAL;
@@ -429,6 +442,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 			of_pci_range_to_resource(&range, np, &pp->cfg);
 			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
 			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
+			pp->cfg0_base = pp->cfg.start;
+			pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
 		}
 	}
 
@@ -441,8 +456,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		}
 	}
 
-	pp->cfg0_base = pp->cfg.start;
-	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
 	pp->mem_base = pp->mem.start;
 
 	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
-- 
1.7.9.5

