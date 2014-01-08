Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaAHIxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:53:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:23106 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623AbaAHIwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:52:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,623,1384329600"; 
   d="scan'208";a="401946959"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu/vt-d: fix compilation error when CONFIG_INTEL_IOMMU is unset
Date: Wed,  8 Jan 2014 16:53:31 +0800
Message-Id: <1389171212-26054-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388989107-4795-3-git-send-email-jiang.liu@linux.intel.com>
References: <1388989107-4795-3-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit: 3b3dc052f79731f4a7389b760060928da18823c0 [6/22] iommu/vt-d: fix
PCI device reference leakage on error recovery path
config: x86_64-randconfig-r0-01080757 (attached as .config)

All error/warnings:
   drivers/iommu/dmar.c: In function 'dmar_parse_dev_scope':
>> drivers/iommu/dmar.c:153:5: error: implicit declaration of function
'dmar_free_dev_scope' [-Werror=implicit-function-declaration]
        dmar_free_dev_scope(devices, cnt);
        ^
   drivers/iommu/dmar.c: At top level:
>> drivers/iommu/dmar.c:164:6: warning: conflicting types for
'dmar_free_dev_scope' [enabled by default]
    void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt)
         ^
   drivers/iommu/dmar.c:153:5: note: previous implicit declaration of
'dmar_free_dev_scope' was here
        dmar_free_dev_scope(devices, cnt);

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Joerg,
	Could you please help to fold this into "[6/22] iommu/vt-d: fix
PCI device reference leakage on error recovery path"?
	This issue has been fixed in part2 of the patch series. But I
have only done compilation tests with part1 and part2 all together,
so this issue hasn't been revealed.

Thanks!
Gerry
---
 include/linux/dmar.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index bd5026b..30162f9 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -67,6 +67,9 @@ extern struct list_head dmar_drhd_units;
 
 extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
+extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
+				struct pci_dev ***devices, u16 segment);
+extern void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt);
 extern int enable_drhd_fault_handling(void);
 #else
 static inline int dmar_table_init(void)
@@ -151,9 +154,6 @@ struct dmar_atsr_unit {
 int dmar_parse_rmrr_atsr_dev(void);
 extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
-extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				struct pci_dev ***devices, u16 segment);
-extern void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt);
 extern int intel_iommu_init(void);
 #else /* !CONFIG_INTEL_IOMMU: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
-- 
1.7.10.4

