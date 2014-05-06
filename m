Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbaEFHEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:04:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:39650 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934095AbaEFHEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:04:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,995,1389772800"; 
   d="scan'208";a="526662126"
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
Subject: [Patch Part3 V2 05/21] iommu/vt-d: only dynamically allocate domain id for virtual domains
Date: Tue,  6 May 2014 15:05:16 +0800
Message-Id: <1399359932-28972-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
References: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
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
 drivers/iommu/intel-iommu.c |   46 ++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 29f613e7eea3..0ab0cd236b16 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1551,15 +1551,27 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 
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
@@ -1766,8 +1778,6 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	struct context_entry *context;
 	unsigned long flags;
 	struct dma_pte *pgd;
-	unsigned long num;
-	unsigned long ndomains;
 	int id;
 	int agaw;
 	struct device_domain_info *info = NULL;
@@ -1792,20 +1802,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
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
@@ -2281,7 +2279,8 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	domain = alloc_domain(0);
 	if (!domain)
 		goto error;
-	if (iommu_attach_domain(domain, iommu) < 0) {
+	domain->id = iommu_attach_domain(domain, iommu);
+	if (domain->id < 0) {
 		free_domain_mem(domain);
 		domain = NULL;
 		goto error;
@@ -2442,6 +2441,7 @@ static int __init si_domain_init(int hw)
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
 	int nid, ret = 0;
+	bool first = true;
 
 	si_domain = alloc_domain(DOMAIN_FLAG_STATIC_IDENTITY);
 	if (!si_domain)
@@ -2452,6 +2452,12 @@ static int __init si_domain_init(int hw)
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

