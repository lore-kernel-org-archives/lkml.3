Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaF3Vqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:46:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47200 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaF3Vq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:46:27 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v3 4/5] PCI: designware: enhance dw core driver to support Keystone PCI host controller
Date: Mon, 30 Jun 2014 17:45:19 -0400
Message-ID: <1404164720-11066-5-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
References: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add API dw_pcie_v3_65_host_init() to support host controller initialization
for Keystone PCI driver. The Keystone PCI uses v3.65 version of the DW hardware
identified by compatibility string "dw,snps-pcie-v3.65". This allow for
different treatment for this version of the h/w during host initialization.
Key differences in v3.65 DW h/w are
	1. No ATU support
	2. Legacy and MSI irq functions are implemented in application
	   register space
	3. MSI interrupts are multiplexed over 8 IRQ lines to the Host side.
So a msi irq chip is needed and the irq domain ops ptr is passed in
dw_pcie_v3_65_host_init() to allow re-use of common MSI code in dw core.  The
Keystone PCI host controller requires a modified pci scan function to allow
setup BAR0 for EP's access to MSI_IRQ register in application register to
raise MSI irq.  So a ptr to pci hw ops struct is passed to the host init code.

Keystone PCI controller re-uses the DW Core driver code wherever there is
common functionality. So this patch makes these functions global and added
their prototypes in pcie-designware.h to allow re-use on Keystone.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Pratyush Anand <pratyush.anand@st.com>
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
 .../devicetree/bindings/pci/designware-pcie.txt    |    2 +
 drivers/pci/host/pcie-designware.c                 |   39 ++++++++++++++++++--
 drivers/pci/host/pcie-designware.h                 |    7 ++++
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
index d0d15ee..0cb10c0 100644
--- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
@@ -2,6 +2,8 @@
 
 Required properties:
 - compatible: should contain "snps,dw-pcie" to identify the core.
+  Additionally contains "dw,snps-pcie-v3.65" to identify v3.65 version of the DW
+  hardware.
 - #address-cells: set to <3>
 - #size-cells: set to <2>
 - device_type: set to "pci"
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index c11e4de..4dcbebe 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -556,6 +556,37 @@ static int dw_pcie_msi_host_init(struct pcie_port *pp,
 	return 0;
 }
 
+int __init dw_pcie_v3_65_host_init(struct pcie_port *pp, struct hw_pci *hw,
+				   struct device_node *msi_irqc_np,
+				   const struct irq_domain_ops *msi_irq_ops)
+{
+	int ret = -EINVAL;
+
+	/* check if compatible with v3.65 DW h/w */
+	if (!of_device_is_compatible(pp->dev->of_node, "dw,snps-pcie-v3.65")) {
+		dev_err(pp->dev,
+			"PCI Controller not compatible with v3.65 DW h/w\n");
+		goto out;
+	}
+	pp->version = DW_HW_V3_65;
+
+	/* v3.65 PCI controller is expected to provide its own PCI h/w ops */
+	if (!hw || !msi_irq_ops) {
+		dev_err(pp->dev,
+			"v3.65 PCI Controllers doesn't provide %s\n",
+			(hw == NULL) ? "PCI hw ops" : "PCI MSI irq domain ops");
+		goto out;
+	}
+
+	ret = dw_pcie_msi_host_init(pp, msi_irqc_np,  msi_irq_ops);
+	if (ret)
+		goto out;
+
+	ret = dw_pcie_common_host_init(pp, hw);
+out:
+	return ret;
+}
+
 int __init dw_pcie_host_init(struct pcie_port *pp)
 {
 	int ret;
@@ -763,7 +794,7 @@ static struct pci_ops dw_pcie_ops = {
 	.write = dw_pcie_wr_conf,
 };
 
-static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
+int dw_pcie_setup(int nr, struct pci_sys_data *sys)
 {
 	struct pcie_port *pp;
 
@@ -786,7 +817,7 @@ static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
 	return 1;
 }
 
-static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
+struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 {
 	struct pci_bus *bus;
 	struct pcie_port *pp = sys_to_pcie(sys);
@@ -803,7 +834,7 @@ static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 	return bus;
 }
 
-static int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct pcie_port *pp = sys_to_pcie(dev->bus->sysdata);
 	int irq;
@@ -815,7 +846,7 @@ static int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return irq;
 }
 
-static void dw_pcie_add_bus(struct pci_bus *bus)
+void dw_pcie_add_bus(struct pci_bus *bus)
 {
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		struct pcie_port *pp = sys_to_pcie(bus->sysdata);
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index db0260f..2681826 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -81,4 +81,11 @@ void dw_pcie_msi_init(struct pcie_port *pp);
 int dw_pcie_link_up(struct pcie_port *pp);
 void dw_pcie_setup_rc(struct pcie_port *pp);
 int dw_pcie_host_init(struct pcie_port *pp);
+int dw_pcie_v3_65_host_init(struct pcie_port *pp, struct hw_pci *hw,
+			   struct device_node *msi_irqc_np,
+			   const struct irq_domain_ops *msi_irq_ops);
+int dw_pcie_setup(int nr, struct pci_sys_data *sys);
+struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys);
+void dw_pcie_add_bus(struct pci_bus *bus);
+int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin);
 #endif /* _PCIE_DESIGNWARE_H */
-- 
1.7.9.5

