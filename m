Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaDYAiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:38:04 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:20553 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaDYAhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:37:17 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com, jerry.hoemann@hp.com
Subject: [PATCH 2/8] iommu/vt-d: Consolidate lines for a new private header
Date: Thu, 24 Apr 2014 18:36:32 -0600
Message-Id: <1398386198-19304-3-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 In intel-iommu.c, move downward the few lines near the
 front that should not move to an intel-iommu-private.h
 file (mostly data-item definitions.) Also move upward
 a couple of inline functions that allocate and free pages.
 This leaves at the front of the file a consolidated block
 of the lines that would move to an intel-iommu-private.h file.

Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 74 +++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f80b4bb..49fdac5 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -163,17 +163,6 @@ static inline unsigned long virt_to_dma_pfn(void *p)
 	return page_to_dma_pfn(virt_to_page(p));
 }
 
-/* global iommu list, set NULL for ignored DMAR units */
-static struct intel_iommu **g_iommus;
-
-static void __init check_tylersburg_isoch(void);
-static int rwbf_quirk;
-
-/*
- * set to 1 to panic kernel if can't successfully enable VT-d
- * (used when kernel is launched w/ TXT)
- */
-static int force_on;
 
 /*
  * 0: Present
@@ -312,15 +301,6 @@ static inline int first_pte_in_page(struct dma_pte *pte)
 	return !((unsigned long)pte & ~VTD_PAGE_MASK);
 }
 
-/*
- * This domain is a statically identity mapping domain.
- *	1. This domain creats a static 1:1 mapping to all usable memory.
- *	2. It maps to each iommu if successful.
- *	3. Each iommu mapps to this domain if successful.
- */
-static struct dmar_domain *si_domain;
-static int hw_pass_through = 1;
-
 /* devices under the same p2p bridge are owned in one domain */
 #define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 << 0)
 
@@ -394,12 +374,50 @@ struct dmar_atsr_unit {
 	u8 include_all:1;		/* include all ports */
 };
 
+static inline void *alloc_pgtable_page(int node)
+{
+	struct page *page;
+	void *vaddr = NULL;
+
+	page = alloc_pages_node(node, GFP_ATOMIC | __GFP_ZERO, 0);
+	if (page)
+		vaddr = page_address(page);
+	return vaddr;
+}
+
+static inline void free_pgtable_page(void *vaddr)
+{
+	free_page((unsigned long)vaddr);
+}
+
 static LIST_HEAD(dmar_atsr_units);
 static LIST_HEAD(dmar_rmrr_units);
 
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
 
+
+static void __init check_tylersburg_isoch(void);
+
+/* global iommu list, set NULL for ignored DMAR units */
+static struct intel_iommu **g_iommus;
+static int rwbf_quirk;
+
+/*
+ * set to 1 to panic kernel if can't successfully enable VT-d
+ * (used when kernel is launched w/ TXT)
+ */
+static int force_on;
+
+/*
+ * This domain is a statically identity mapping domain.
+ *	1. This domain creats a static 1:1 mapping to all usable memory.
+ *	2. It maps to each iommu if successful.
+ *	3. Each iommu mapps to this domain if successful.
+ */
+static struct dmar_domain *si_domain;
+static int hw_pass_through = 1;
+
 static void flush_unmaps_timeout(unsigned long data);
 
 static DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
@@ -494,22 +512,6 @@ static struct kmem_cache *iommu_domain_cache;
 static struct kmem_cache *iommu_devinfo_cache;
 static struct kmem_cache *iommu_iova_cache;
 
-static inline void *alloc_pgtable_page(int node)
-{
-	struct page *page;
-	void *vaddr = NULL;
-
-	page = alloc_pages_node(node, GFP_ATOMIC | __GFP_ZERO, 0);
-	if (page)
-		vaddr = page_address(page);
-	return vaddr;
-}
-
-static inline void free_pgtable_page(void *vaddr)
-{
-	free_page((unsigned long)vaddr);
-}
-
 static inline void *alloc_domain_mem(void)
 {
 	return kmem_cache_alloc(iommu_domain_cache, GFP_ATOMIC);
-- 
Bill Sumner <bill.sumner@hp.com>

