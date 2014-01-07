Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaAGJAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:00:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:40167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbaAGJAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454739595"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V1 01/14] iommu/vt-d: factor out dmar_alloc_dev_scope() for later reuse
Date: Tue,  7 Jan 2014 17:00:21 +0800
Message-Id: <1389085234-22296-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out function dmar_alloc_dev_scope() from dmar_parse_dev_scope()
for later reuse.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c |   28 ++++++++++++++++------------
 include/linux/dmar.h |    1 +
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 248332e..4a4c9a1 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -117,13 +117,9 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 	return 0;
 }
 
-int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				struct pci_dev ***devices, u16 segment)
+void *dmar_alloc_dev_scope(void *start, void *end, int *cnt)
 {
 	struct acpi_dmar_device_scope *scope;
-	void * tmp = start;
-	int index;
-	int ret;
 
 	*cnt = 0;
 	while (start < end) {
@@ -138,15 +134,24 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 		start += scope->length;
 	}
 	if (*cnt == 0)
-		return 0;
+		return NULL;
+
+	return kcalloc(*cnt, sizeof(struct pci_dev *), GFP_KERNEL);
+}
+
+int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
+				struct pci_dev ***devices, u16 segment)
+{
+	struct acpi_dmar_device_scope *scope;
+	int index, ret;
 
-	*devices = kcalloc(*cnt, sizeof(struct pci_dev *), GFP_KERNEL);
-	if (!*devices)
+	*devices = dmar_alloc_dev_scope(start, end, cnt);
+	if (*cnt == 0)
+		return 0;
+	else if (!*devices)
 		return -ENOMEM;
 
-	start = tmp;
-	index = 0;
-	while (start < end) {
+	for (index = 0; start < end; start += scope->length) {
 		scope = start;
 		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE) {
@@ -158,7 +163,6 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 			}
 			index ++;
 		}
-		start += scope->length;
 	}
 
 	return 0;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index bd5026b..198eb09 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -151,6 +151,7 @@ struct dmar_atsr_unit {
 int dmar_parse_rmrr_atsr_dev(void);
 extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
+extern void *dmar_alloc_dev_scope(void *start, void *end, int *cnt);
 extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
 				struct pci_dev ***devices, u16 segment);
 extern void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt);
-- 
1.7.10.4

