Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaGKGRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:17:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:55697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbaGKGRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:17:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="560333253"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part3 V4 11/21] iommu/vt-d: Introduce helper domain_pfn_within_range() to simplify code
Date: Fri, 11 Jul 2014 14:19:35 +0800
Message-Id: <1405059585-10620-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper function domain_pfn_within_range() to simplify code
and improve readability.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0852b7021e4a..c9e65edaa2ad 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -549,6 +549,14 @@ static inline int domain_type_is_vm_or_si(struct dmar_domain *domain)
 				DOMAIN_FLAG_STATIC_IDENTITY);
 }
 
+static inline int domain_pfn_supported(struct dmar_domain *domain,
+				       unsigned long pfn)
+{
+	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
+
+	return !(addr_width < BITS_PER_LONG && pfn >> addr_width);
+}
+
 static int __iommu_calculate_agaw(struct intel_iommu *iommu, int max_gaw)
 {
 	unsigned long sagaw;
@@ -822,14 +830,13 @@ out:
 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				      unsigned long pfn, int *target_level)
 {
-	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
 	struct dma_pte *parent, *pte = NULL;
 	int level = agaw_to_level(domain->agaw);
 	int offset;
 
 	BUG_ON(!domain->pgd);
 
-	if (addr_width < BITS_PER_LONG && pfn >> addr_width)
+	if (!domain_pfn_supported(domain, pfn))
 		/* Address beyond IOMMU's addressing capabilities. */
 		return NULL;
 
@@ -912,12 +919,11 @@ static void dma_pte_clear_range(struct dmar_domain *domain,
 				unsigned long start_pfn,
 				unsigned long last_pfn)
 {
-	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
 	unsigned int large_page = 1;
 	struct dma_pte *first_pte, *pte;
 
-	BUG_ON(addr_width < BITS_PER_LONG && start_pfn >> addr_width);
-	BUG_ON(addr_width < BITS_PER_LONG && last_pfn >> addr_width);
+	BUG_ON(!domain_pfn_supported(domain, start_pfn));
+	BUG_ON(!domain_pfn_supported(domain, last_pfn));
 	BUG_ON(start_pfn > last_pfn);
 
 	/* we don't need lock here; nobody else touches the iova range */
@@ -978,10 +984,8 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
 				   unsigned long start_pfn,
 				   unsigned long last_pfn)
 {
-	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
-
-	BUG_ON(addr_width < BITS_PER_LONG && start_pfn >> addr_width);
-	BUG_ON(addr_width < BITS_PER_LONG && last_pfn >> addr_width);
+	BUG_ON(!domain_pfn_supported(domain, start_pfn));
+	BUG_ON(!domain_pfn_supported(domain, last_pfn));
 	BUG_ON(start_pfn > last_pfn);
 
 	dma_pte_clear_range(domain, start_pfn, last_pfn);
@@ -1083,11 +1087,10 @@ struct page *domain_unmap(struct dmar_domain *domain,
 			  unsigned long start_pfn,
 			  unsigned long last_pfn)
 {
-	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
 	struct page *freelist = NULL;
 
-	BUG_ON(addr_width < BITS_PER_LONG && start_pfn >> addr_width);
-	BUG_ON(addr_width < BITS_PER_LONG && last_pfn >> addr_width);
+	BUG_ON(!domain_pfn_supported(domain, start_pfn));
+	BUG_ON(!domain_pfn_supported(domain, last_pfn));
 	BUG_ON(start_pfn > last_pfn);
 
 	/* we don't need lock here; nobody else touches the iova range */
@@ -1974,12 +1977,11 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 {
 	struct dma_pte *first_pte = NULL, *pte = NULL;
 	phys_addr_t uninitialized_var(pteval);
-	int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
 	unsigned long sg_res;
 	unsigned int largepage_lvl = 0;
 	unsigned long lvl_pages = 0;
 
-	BUG_ON(addr_width < BITS_PER_LONG && (iov_pfn + nr_pages - 1) >> addr_width);
+	BUG_ON(!domain_pfn_supported(domain, iov_pfn + nr_pages - 1));
 
 	if ((prot & (DMA_PTE_READ|DMA_PTE_WRITE)) == 0)
 		return -EINVAL;
-- 
1.7.10.4

