Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBSGHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:07:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:18482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaBSGHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:07:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="485626471"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V2 04/17] iommu/vt-d: factor out dmar_alloc_dev_scope() for later reuse
Date: Wed, 19 Feb 2014 14:07:24 +0800
Message-Id: <1392790057-32434-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
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
index 1581565..58dde75 100644
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
index eccb0c0..1b08ce8 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -69,6 +69,7 @@ extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
 extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
 				struct pci_dev ***devices, u16 segment);
+extern void *dmar_alloc_dev_scope(void *start, void *end, int *cnt);
 extern void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt);
 
 /* Intel IOMMU detection */
-- 
1.7.10.4

