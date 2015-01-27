Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbbA0VBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:01:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47405 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbbA0VBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:01:06 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <devicetree@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v5 4/8] PCI: add helper functions pci_get[put]_host_bridge_device()
Date: Tue, 27 Jan 2015 16:00:01 -0500
Message-ID: <1422392405-32196-5-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com>
References: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper function to get/put the root bus's host bridge device.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/pci/host-bridge.c |   14 ++++++++++++++
 include/linux/pci.h       |    3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 0e5f3c9..f58e05b 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -23,6 +23,20 @@ static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
 	return to_pci_host_bridge(root_bus->bridge);
 }
 
+struct device *pci_get_host_bridge_device(struct pci_dev *dev)
+{
+	struct pci_bus *root_bus = find_pci_root_bus(dev->bus);
+	struct device *bridge = root_bus->bridge;
+
+	kobject_get(&bridge->kobj);
+	return bridge;
+}
+
+void  pci_put_host_bridge_device(struct device *dev)
+{
+	kobject_put(&dev->kobj);
+}
+
 void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
 				 void (*release_fn)(struct pci_host_bridge *),
 				 void *release_data)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9603094..d677c66 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -513,6 +513,9 @@ static inline struct pci_dev *pci_upstream_bridge(struct pci_dev *dev)
 	return dev->bus->self;
 }
 
+struct device *pci_get_host_bridge_device(struct pci_dev *dev);
+void pci_put_host_bridge_device(struct device *dev);
+
 #ifdef CONFIG_PCI_MSI
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev)
 {
-- 
1.7.9.5

