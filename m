Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab3LFD0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:26:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab3LFDUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:20:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986881"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org
Subject: [Patch Part1 V2 02/20] iommu/vt-d: fix PCI device reference leakage on error recovery path
Date: Fri,  6 Dec 2013 11:21:05 +0800
Message-Id: <1386300083-6882-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function dmar_parse_dev_scope() should release the PCI device reference
count gained in function dmar_parse_one_dev_scope() on error recovery,
otherwise will cause PCI device object leakage.

This patch also introduces dmar_free_dev_scope(), which will be used
to support DMAR device hotplug.

Reviewed-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c |   14 ++++++++++++--
 include/linux/dmar.h |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 8b452c9..c17dbf7 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -100,7 +100,6 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 	if (!pdev) {
 		pr_warn("Device scope device [%04x:%02x:%02x.%02x] not found\n",
 			segment, scope->bus, path->device, path->function);
-		*dev = NULL;
 		return 0;
 	}
 	if ((scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT && \
@@ -151,7 +150,7 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 			ret = dmar_parse_one_dev_scope(scope,
 				&(*devices)[index], segment);
 			if (ret) {
-				kfree(*devices);
+				dmar_free_dev_scope(devices, cnt);
 				return ret;
 			}
 			index ++;
@@ -162,6 +161,17 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 	return 0;
 }
 
+void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt)
+{
+	if (*devices && *cnt) {
+		while (--*cnt >= 0)
+			pci_dev_put((*devices)[*cnt]);
+		kfree(*devices);
+		*devices = NULL;
+		*cnt = 0;
+	}
+}
+
 /**
  * dmar_parse_one_drhd - parses exactly one DMA remapping hardware definition
  * structure which uniquely represent one DMA remapping hardware unit
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index b029d1a..8adfce0 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -159,6 +159,7 @@ extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
 extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
 				struct pci_dev ***devices, u16 segment);
+extern void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt);
 extern int intel_iommu_init(void);
 #else /* !CONFIG_INTEL_IOMMU: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
-- 
1.7.10.4

