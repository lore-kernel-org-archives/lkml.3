Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965711AbaGRPQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:16:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51674 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965092AbaGRPQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:16:00 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v6 3/5] PCI: designware: enhance dw_pcie_host_init() to support v3.65 DW hardware
Date: Fri, 18 Jul 2014 11:14:27 -0400
Message-ID: <1405696469-7172-4-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com>
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keystone PCI controller is based on v3.65 designware hardware. This
version differs from newer versions of the hardware in few functional
areas discussed below that makes it necessary to change dw_pcie_host_init()
to support v3.65 based PCI controller.

 1. No support for ATU port. So any ATU specific resource handling code
    is to be bypassed for v3.65 h/w.
 2. MSI controller uses Application space to implement MSI and 32 MSI
    interrupts are multiplexed over 8 IRQs to the host. Hence the code
    to process MSI IRQ needs to be different. This patch allows platform
    driver to provide its own irq_domain_ops ptr to irq_domain_add_linear()
    through an API callback from the designware core driver.
 3. MSI interrupt generation requires EP to write to the RC's application
    register. So enhance the driver to allow setup of inbound access to
    MSI irq register as a post scan bus API callback.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Reviewed-by: Pratyush Anand <pratyush.anand@st.com>
Acked-by: Mohit KUMAR <mohit.kumar@st.com>

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>
CC: Marek Vasut <marex@denx.de>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Randy Dunlap <rdunlap@infradead.org>
CC: Grant Likely <grant.likely@linaro.org>

---
 drivers/pci/host/pcie-designware.c |   54 +++++++++++++++++++++++-------------
 drivers/pci/host/pcie-designware.h |    2 ++
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 905941c..35bb4af 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -420,8 +420,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	struct device_node *np = pp->dev->of_node;
 	struct of_pci_range range;
 	struct of_pci_range_parser parser;
+	int i, ret;
 	u32 val;
-	int i;
 
 	if (of_pci_range_parser_init(&parser, np)) {
 		dev_err(pp->dev, "missing ranges property\n");
@@ -467,21 +467,26 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 		}
 	}
 
-	pp->cfg0_base = pp->cfg.start;
-	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
 	pp->mem_base = pp->mem.start;
 
-	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
-					pp->config.cfg0_size);
 	if (!pp->va_cfg0_base) {
-		dev_err(pp->dev, "error with ioremap in function\n");
-		return -ENOMEM;
+		pp->cfg0_base = pp->cfg.start;
+		pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
+						pp->config.cfg0_size);
+		if (!pp->va_cfg0_base) {
+			dev_err(pp->dev, "error with ioremap in function\n");
+			return -ENOMEM;
+		}
 	}
-	pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
-					pp->config.cfg1_size);
+
 	if (!pp->va_cfg1_base) {
-		dev_err(pp->dev, "error with ioremap\n");
-		return -ENOMEM;
+		pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
+		pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
+						pp->config.cfg1_size);
+		if (!pp->va_cfg1_base) {
+			dev_err(pp->dev, "error with ioremap\n");
+			return -ENOMEM;
+		}
 	}
 
 	if (of_property_read_u32(np, "num-lanes", &pp->lanes)) {
@@ -490,16 +495,22 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	}
 
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
-					MAX_MSI_IRQS, &msi_domain_ops,
-					&dw_pcie_msi_chip);
-		if (!pp->irq_domain) {
-			dev_err(pp->dev, "irq domain init failed\n");
-			return -ENXIO;
-		}
+		if (!pp->ops->msi_host_init) {
+			pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
+						MAX_MSI_IRQS, &msi_domain_ops,
+						&dw_pcie_msi_chip);
+			if (!pp->irq_domain) {
+				dev_err(pp->dev, "irq domain init failed\n");
+				return -ENXIO;
+			}
 
-		for (i = 0; i < MAX_MSI_IRQS; i++)
-			irq_create_mapping(pp->irq_domain, i);
+			for (i = 0; i < MAX_MSI_IRQS; i++)
+				irq_create_mapping(pp->irq_domain, i);
+		} else {
+			ret = pp->ops->msi_host_init(pp, &dw_pcie_msi_chip);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	if (pp->ops->host_init)
@@ -759,6 +770,9 @@ static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 		BUG();
 	}
 
+	if (bus && pp->ops->scan_bus)
+		pp->ops->scan_bus(pp);
+
 	return bus;
 }
 
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index 387f69e..080c649 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -70,6 +70,8 @@ struct pcie_host_ops {
 	void (*msi_set_irq)(struct pcie_port *pp, int irq);
 	void (*msi_clear_irq)(struct pcie_port *pp, int irq);
 	u32 (*get_msi_data)(struct pcie_port *pp);
+	void (*scan_bus)(struct pcie_port *pp);
+	int (*msi_host_init)(struct pcie_port *pp, struct msi_chip *chip);
 };
 
 int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
-- 
1.7.9.5

