Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaHLQ04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:26:56 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54724 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753065AbaHLQ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:26:51 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v9 09/12] OF: Introduce helper function for getting PCI domain_nr
Date: Tue, 12 Aug 2014 17:25:22 +0100
Message-Id: <1407860725-25202-10-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_pci_get_domain_nr() to retrieve the PCI domain number
of a given device from DT. If the information is not present,
the function can be requested to allocate a new domain number.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/of/of_pci.c    | 34 ++++++++++++++++++++++++++++++++++
 include/linux/of_pci.h |  7 +++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 8481996..a107edb 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -89,6 +89,40 @@ int of_pci_parse_bus_range(struct device_node *node, struct resource *res)
 }
 EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
 
+static atomic_t of_domain_nr = ATOMIC_INIT(-1);
+
+/**
+ * This function will try to obtain the host bridge domain number by
+ * using of_alias_get_id() call with "pci-domain" as a stem. If that
+ * fails, a local allocator will be used. The local allocator can
+ * be requested to return a new domain_nr if the information is missing
+ * from the device tree.
+ *
+ * @node: device tree node with the domain information
+ * @allocate_if_missing: if DT lacks information about the domain nr,
+ * allocate a new number.
+ *
+ * Returns the associated domain number from DT, or a new domain number
+ * if DT information is missing and @allocate_if_missing is true. If
+ * @allocate_if_missing is false then the last allocated domain number
+ * will be returned.
+ */
+int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
+{
+	int domain;
+
+	domain = of_alias_get_id(node, "pci-domain");
+	if (domain == -ENODEV) {
+		if (allocate_if_missing)
+			domain = atomic_inc_return(&of_domain_nr);
+		else
+			domain = atomic_read(&of_domain_nr);
+	}
+
+	return domain;
+}
+EXPORT_SYMBOL_GPL(of_pci_get_domain_nr);
+
 #ifdef CONFIG_PCI_MSI
 
 static LIST_HEAD(of_pci_msi_chip_list);
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index dde3a4a..3a3824c 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -15,6 +15,7 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
 int of_pci_get_devfn(struct device_node *np);
 int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
+int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing);
 #else
 static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
 {
@@ -43,6 +44,12 @@ of_pci_parse_bus_range(struct device_node *node, struct resource *res)
 {
 	return -EINVAL;
 }
+
+static inline int
+of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
+{
+	return -1;
+}
 #endif
 
 #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
-- 
2.0.4

