Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaLHUOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:14:00 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46532 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbaLHUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:12:33 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 1/6] device core: Introduce per-device MSI domain pointer
Date: Mon,  8 Dec 2014 20:12:18 +0000
Message-Id: <1418069543-21969-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com>
References: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As MSI-type features are creeping into non-PCI devices, it is
starting to make sense to give our struct device some form of
support for this, by allowing a pointer to an MSI irq domain to
be set/retrieved.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/device.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index ce1f2160..f3aaaf6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -690,6 +690,7 @@ struct acpi_dev_node {
  * 		along with subsystem-level and driver-level callbacks.
  * @pins:	For device pin management.
  *		See Documentation/pinctrl.txt for details.
+ * @msi_domain: The generic MSI domain this device is using.
  * @numa_node:	NUMA node this device is close to.
  * @dma_mask:	Dma mask (if dma'ble device).
  * @coherent_dma_mask: Like dma_mask, but for alloc_coherent mapping as not all
@@ -750,6 +751,9 @@ struct device {
 	struct dev_pm_info	power;
 	struct dev_pm_domain	*pm_domain;
 
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	struct irq_domain	*msi_domain; /* MSI domain device uses */
+#endif
 #ifdef CONFIG_PINCTRL
 	struct dev_pin_info	*pins;
 #endif
@@ -837,6 +841,22 @@ static inline void set_dev_node(struct device *dev, int node)
 }
 #endif
 
+static inline struct irq_domain *dev_get_msi_domain(const struct device *dev)
+{
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	return dev->msi_domain;
+#else
+	return NULL;
+#endif
+}
+
+static inline void dev_set_msi_domain(struct device *dev, struct irq_domain *d)
+{
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	dev->msi_domain = d;
+#endif
+}
+
 static inline void *dev_get_drvdata(const struct device *dev)
 {
 	return dev->driver_data;
-- 
2.1.3

