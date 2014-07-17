Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaGQJCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:02:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44044 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139AbaGQJC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:02:26 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <jg1.han@samsung.com>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 1/4] PCI: designware: Configuration space should be specified in 'reg'
Date: Thu, 17 Jul 2014 14:30:40 +0530
Message-ID: <1405587643-13808-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405587643-13808-1-git-send-email-kishon@ti.com>
References: <1405587643-13808-1-git-send-email-kishon@ti.com>
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
Cc: Marek Vasut <marex@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Mohit Kumar <mohit.kumar@st.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 .../devicetree/bindings/pci/designware-pcie.txt    |    4 ++++
 drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
index d0d15ee..ed0d9b9 100644
--- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
@@ -2,6 +2,10 @@
 
 Required properties:
 - compatible: should contain "snps,dw-pcie" to identify the core.
+- reg: Should contain the configuration address space.
+- reg-names: Must be "config" for the PCIe configuration space.
+    (The old way of getting the configuration address space from "ranges"
+    is deprecated and should be avoided.)
 - #address-cells: set to <3>
 - #size-cells: set to <2>
 - device_type: set to "pci"
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 1eaf4df..0b7b455 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -20,6 +20,7 @@
 #include <linux/of_pci.h>
 #include <linux/pci.h>
 #include <linux/pci_regs.h>
+#include <linux/platform_device.h>
 #include <linux/types.h>
 
 #include "pcie-designware.h"
@@ -396,11 +397,23 @@ static const struct irq_domain_ops msi_domain_ops = {
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
@@ -433,6 +446,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 			of_pci_range_to_resource(&range, np, &pp->cfg);
 			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
 			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
+			pp->cfg0_base = pp->cfg.start;
+			pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
 		}
 	}
 
@@ -445,8 +460,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		}
 	}
 
-	pp->cfg0_base = pp->cfg.start;
-	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
 	pp->mem_base = pp->mem.start;
 
 	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
-- 
1.7.9.5

