Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaJBKJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:09:19 -0400
Received: from 8bytes.org ([81.169.241.247]:45151 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaJBKJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:09:16 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, jroedel@suse.de,
        joro@8bytes.org
Subject: [PATCH 1/2] iommu/vt-d: Store bus information in RMRR PCI device path
Date: Thu,  2 Oct 2014 12:09:07 +0200
Message-Id: <1412244548-27617-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412244548-27617-1-git-send-email-joro@8bytes.org>
References: <1412244548-27617-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This will be used later to match broken RMRR entries.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/dmar.c | 1 +
 include/linux/dmar.h | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 06d268a..6ba28b0 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -155,6 +155,7 @@ dmar_alloc_pci_notify_info(struct pci_dev *dev, unsigned long event)
 	if (event == BUS_NOTIFY_ADD_DEVICE) {
 		for (tmp = dev; tmp; tmp = tmp->bus->self) {
 			level--;
+			info->path[level].bus = tmp->bus->number;
 			info->path[level].device = PCI_SLOT(tmp->devfn);
 			info->path[level].function = PCI_FUNC(tmp->devfn);
 			if (pci_is_root_bus(tmp->bus))
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 1deece4..593fff9 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -56,13 +56,19 @@ struct dmar_drhd_unit {
 	struct intel_iommu *iommu;
 };
 
+struct dmar_pci_path {
+	u8 bus;
+	u8 device;
+	u8 function;
+};
+
 struct dmar_pci_notify_info {
 	struct pci_dev			*dev;
 	unsigned long			event;
 	int				bus;
 	u16				seg;
 	u16				level;
-	struct acpi_dmar_pci_path	path[];
+	struct dmar_pci_path		path[];
 }  __attribute__((packed));
 
 extern struct rw_semaphore dmar_global_lock;
-- 
1.9.1

