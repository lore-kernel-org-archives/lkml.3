Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaLHUNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:13:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46552 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaLHUMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:12:36 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 3/6] PCI/MSI: of: add support for OF-provided msi_domain
Date: Mon,  8 Dec 2014 20:12:20 +0000
Message-Id: <1418069543-21969-4-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com>
References: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to populate the PHB msi_domain, use the "msi-parent"
attribute to lookup a corresponding irq domain. If found,
this is our MSI domain.

This gets plugged into the core PCI code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/pci/of.c    | 15 +++++++++++++++
 drivers/pci/probe.c |  1 +
 include/linux/pci.h |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/drivers/pci/of.c b/drivers/pci/of.c
index f092993..d8d1274 100644
--- a/drivers/pci/of.c
+++ b/drivers/pci/of.c
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/of.h>
@@ -59,3 +60,17 @@ struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus)
 		return of_node_get(bus->bridge->parent->of_node);
 	return NULL;
 }
+
+void pci_set_phb_of_msi_domain(struct pci_bus *bus)
+{
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	struct device_node *np;
+
+	if (!bus->dev.of_node)
+		return;
+	np = of_parse_phandle(bus->dev.of_node, "msi-parent", 0);
+	if (!np)
+		return;
+	dev_set_msi_domain(&bus->dev, irq_find_host(np));
+#endif
+}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d1009a2..65600e5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -672,6 +672,7 @@ static void pci_set_bus_speed(struct pci_bus *bus)
 
 void __weak pcibios_set_phb_msi_domain(struct pci_bus *bus)
 {
+	pci_set_phb_of_msi_domain(bus);
 }
 
 static void pci_set_bus_msi_domain(struct pci_bus *bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3266764..6a9713f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1825,6 +1825,7 @@ void pci_set_of_node(struct pci_dev *dev);
 void pci_release_of_node(struct pci_dev *dev);
 void pci_set_bus_of_node(struct pci_bus *bus);
 void pci_release_bus_of_node(struct pci_bus *bus);
+void pci_set_phb_of_msi_domain(struct pci_bus *bus);
 
 /* Arch may override this (weak) */
 struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus);
@@ -1845,6 +1846,7 @@ static inline void pci_set_of_node(struct pci_dev *dev) { }
 static inline void pci_release_of_node(struct pci_dev *dev) { }
 static inline void pci_set_bus_of_node(struct pci_bus *bus) { }
 static inline void pci_release_bus_of_node(struct pci_bus *bus) { }
+static inline void pci_set_phb_of_msi_domain(struct pci_bus *bus) {}
 #endif  /* CONFIG_OF */
 
 #ifdef CONFIG_EEH
-- 
2.1.3

