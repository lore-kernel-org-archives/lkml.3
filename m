Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaGKGWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:22:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:55697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaGKGRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:17:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="560333127"
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
Subject: [Patch Part3 V4 05/21] iommu/vt-d: Allocate dynamic domain id for virtual domains only
Date: Fri, 11 Jul 2014 14:19:29 +0800
Message-Id: <1405059585-10620-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the same domain id is allocated for si_domain on each IOMMU,
otherwise the IOTLB flush for si_domain will fail.

Now the rules to allocate and manage domain id are:
1) For normal and static identity domains, domain id is allocated
   when creating domain structure. And this id will be written into
   context entry.
2) For virtual machine domain, a virtual id is allocated when creating
   domain. And when binding virtual machine domain to an iommu, a real
   domain id is allocated on demand and this domain id will be written
   into context entry. So domain->id for virtual machine domain may be
   different from the domain id written into context entry(used by
   hardware).

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   47 ++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index eae9b0d8bc60..968e3d32e305 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1549,15 +1549,27 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 
 	spin_lock_irqsave(&iommu->lock, flags);
 	num = __iommu_attach_domain(domain, iommu);
+	spin_unlock_irqrestore(&iommu->lock, flags);
 	if (num < 0)
 		pr_err("IOMMU: no free domain ids\n");
-	else
-		domain->id = num;
-	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return num;
 }
 
+static int iommu_attach_vm_domain(struct dmar_domain *domain,
+				  struct intel_iommu *iommu)
+{
+	int num;
+	unsigned long ndomains;
+
+	ndomains = cap_ndoms(iommu->cap);
+	for_each_set_bit(num, iommu->domain_ids, ndomains)
+		if (iommu->domains[num] == domain)
+			return num;
+
+	return __iommu_attach_domain(domain, iommu);
+}
+
 static void iommu_detach_domain(struct dmar_domain *domain,
 				struct intel_iommu *iommu)
 {
@@ -1764,8 +1776,6 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	struct context_entry *context;
 	unsigned long flags;
 	struct dma_pte *pgd;
-	unsigned long num;
-	unsigned long ndomains;
 	int id;
 	int agaw;
 	struct device_domain_info *info = NULL;
@@ -1790,20 +1800,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	pgd = domain->pgd;
 
 	if (domain_type_is_vm_or_si(domain)) {
-		int found = 0;
-
-		/* find an available domain id for this device in iommu */
-		ndomains = cap_ndoms(iommu->cap);
-		for_each_set_bit(num, iommu->domain_ids, ndomains) {
-			if (iommu->domains[num] == domain) {
-				id = num;
-				found = 1;
-				break;
-			}
-		}
-
-		if (found == 0) {
-			id = __iommu_attach_domain(domain, iommu);
+		if (domain_type_is_vm(domain)) {
+			id = iommu_attach_vm_domain(domain, iommu);
 			if (id < 0) {
 				spin_unlock_irqrestore(&iommu->lock, flags);
 				pr_err("IOMMU: no free domain ids\n");
@@ -2257,8 +2255,8 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	domain = alloc_domain(0);
 	if (!domain)
 		return NULL;
-
-	if (iommu_attach_domain(domain, iommu) < 0) {
+	domain->id = iommu_attach_domain(domain, iommu);
+	if (domain->id < 0) {
 		free_domain_mem(domain);
 		return NULL;
 	}
@@ -2428,6 +2426,7 @@ static int __init si_domain_init(int hw)
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
 	int nid, ret = 0;
+	bool first = true;
 
 	si_domain = alloc_domain(DOMAIN_FLAG_STATIC_IDENTITY);
 	if (!si_domain)
@@ -2438,6 +2437,12 @@ static int __init si_domain_init(int hw)
 		if (ret < 0) {
 			domain_exit(si_domain);
 			return -EFAULT;
+		} else if (first) {
+			si_domain->id = ret;
+			first = false;
+		} else if (si_domain->id != ret) {
+			domain_exit(si_domain);
+			return -EFAULT;
 		}
 		domain_attach_iommu(si_domain, iommu);
 	}
-- 
1.7.10.4

