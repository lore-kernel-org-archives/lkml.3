Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaI2ObO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:31:14 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50515 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754199AbaI2ObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:31:09 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v13 08/12] of/pci: Add pci_get_new_domain_nr() and of_get_pci_domain_nr()
Date: Mon, 29 Sep 2014 15:29:27 +0100
Message-Id: <1412000971-9242-9-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pci_get_new_domain_nr() to allocate a new domain number and
of_get_pci_domain_nr() to retrieve the PCI domain number of a given device
from DT.  Host bridge drivers or architecture-specific code can choose to
implement their PCI domain number policy using these two functions.

Using of_get_pci_domain_nr() guarantees a stable PCI domain number on every
boot provided that all host bridge controllers are assigned a number in the
device tree using "linux,pci-domain" property.  Mixing use of
pci_get_new_domain_nr() and of_get_pci_domain_nr() is not recommended as it
can lead to potentially conflicting domain numbers being assigned to root
buses behind different host bridges.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/of/of_pci.c    | 25 +++++++++++++++++++++++++
 drivers/pci/pci.c      |  9 +++++++++
 include/linux/of_pci.h |  7 +++++++
 include/linux/pci.h    |  3 +++
 4 files changed, 44 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 8481996..82d172f 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -89,6 +89,31 @@ int of_pci_parse_bus_range(struct device_node *node, struct resource *res)
 }
 EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
 
+/**
+ * This function will try to obtain the host bridge domain number by
+ * finding a property called "linux,pci-domain" of the given device node.
+ *
+ * @node: device tree node with the domain information
+ *
+ * Returns the associated domain number from DT in the range [0-0xffff], or
+ * a negative value if the required property is not found.
+ */
+int of_get_pci_domain_nr(struct device_node *node)
+{
+	const __be32 *value;
+	int len;
+	u16 domain;
+
+	value = of_get_property(node, "linux,pci-domain", &len);
+	if (!value || len < sizeof(*value))
+		return -EINVAL;
+
+	domain = (u16)be32_to_cpup(value);
+
+	return domain;
+}
+EXPORT_SYMBOL_GPL(of_get_pci_domain_nr);
+
 #ifdef CONFIG_PCI_MSI
 
 static LIST_HEAD(of_pci_msi_chip_list);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2c9ac70..d36f35f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4406,6 +4406,15 @@ static void pci_no_domains(void)
 #endif
 }
 
+#ifdef CONFIG_PCI_DOMAINS
+static atomic_t __domain_nr = ATOMIC_INIT(-1);
+
+int pci_get_new_domain_nr(void)
+{
+	return atomic_inc_return(&__domain_nr);
+}
+#endif
+
 /**
  * pci_ext_cfg_avail - can we access extended PCI config space?
  *
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index dde3a4a..71062e9 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -15,6 +15,7 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
 int of_pci_get_devfn(struct device_node *np);
 int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
+int of_get_pci_domain_nr(struct device_node *node);
 #else
 static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
 {
@@ -43,6 +44,12 @@ of_pci_parse_bus_range(struct device_node *node, struct resource *res)
 {
 	return -EINVAL;
 }
+
+static inline int
+of_get_pci_domain_nr(struct device_node *node)
+{
+	return -1;
+}
 #endif
 
 #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a494e5d..150da2d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1285,10 +1285,12 @@ void pci_cfg_access_unlock(struct pci_dev *dev);
  */
 #ifdef CONFIG_PCI_DOMAINS
 extern int pci_domains_supported;
+int pci_get_new_domain_nr(void);
 #else
 enum { pci_domains_supported = 0 };
 static inline int pci_domain_nr(struct pci_bus *bus) { return 0; }
 static inline int pci_proc_domain(struct pci_bus *bus) { return 0; }
+static inline int pci_get_new_domain_nr(void) { return -ENOSYS; }
 #endif /* CONFIG_PCI_DOMAINS */
 
 /*
@@ -1417,6 +1419,7 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
 
 static inline int pci_domain_nr(struct pci_bus *bus) { return 0; }
 static inline struct pci_dev *pci_dev_get(struct pci_dev *dev) { return NULL; }
+static inline int pci_get_new_domain_nr(void) { return -ENOSYS; }
 
 #define dev_is_pci(d) (false)
 #define dev_is_pf(d) (false)
-- 
2.1.1

