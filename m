Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaGKGRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:17:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:55697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaGKGRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:17:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="560333081"
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
Subject: [Patch Part3 V4 04/21] iommu/vt-d: Introduce helper functions to make code symmetric for readability
Date: Fri, 11 Jul 2014 14:19:28 +0800
Message-Id: <1405059585-10620-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405059585-10620-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce domain_attach_iommu()/domain_detach_iommu() and refine
iommu_attach_domain()/iommu_detach_domain() to make code symmetric
and improve readability.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |  147 +++++++++++++++++++++++--------------------
 1 file changed, 80 insertions(+), 67 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 52250b3e58d1..eae9b0d8bc60 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1523,32 +1523,39 @@ static struct dmar_domain *alloc_domain(int flags)
 	return domain;
 }
 
-static int iommu_attach_domain(struct dmar_domain *domain,
-			       struct intel_iommu *iommu)
+static int __iommu_attach_domain(struct dmar_domain *domain,
+				 struct intel_iommu *iommu)
 {
 	int num;
 	unsigned long ndomains;
-	unsigned long flags;
 
 	ndomains = cap_ndoms(iommu->cap);
-
-	spin_lock_irqsave(&iommu->lock, flags);
-
 	num = find_first_zero_bit(iommu->domain_ids, ndomains);
-	if (num >= ndomains) {
-		spin_unlock_irqrestore(&iommu->lock, flags);
-		printk(KERN_ERR "IOMMU: no free domain ids\n");
-		return -ENOMEM;
+	if (num < ndomains) {
+		set_bit(num, iommu->domain_ids);
+		iommu->domains[num] = domain;
+	} else {
+		num = -ENOSPC;
 	}
 
-	domain->id = num;
-	domain->iommu_count++;
-	set_bit(num, iommu->domain_ids);
-	set_bit(iommu->seq_id, domain->iommu_bmp);
-	iommu->domains[num] = domain;
+	return num;
+}
+
+static int iommu_attach_domain(struct dmar_domain *domain,
+			       struct intel_iommu *iommu)
+{
+	int num;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	num = __iommu_attach_domain(domain, iommu);
+	if (num < 0)
+		pr_err("IOMMU: no free domain ids\n");
+	else
+		domain->id = num;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
-	return 0;
+	return num;
 }
 
 static void iommu_detach_domain(struct dmar_domain *domain,
@@ -1558,17 +1565,53 @@ static void iommu_detach_domain(struct dmar_domain *domain,
 	int num, ndomains;
 
 	spin_lock_irqsave(&iommu->lock, flags);
-	ndomains = cap_ndoms(iommu->cap);
-	for_each_set_bit(num, iommu->domain_ids, ndomains) {
-		if (iommu->domains[num] == domain) {
-			clear_bit(num, iommu->domain_ids);
-			iommu->domains[num] = NULL;
-			break;
+	if (domain_type_is_vm_or_si(domain)) {
+		ndomains = cap_ndoms(iommu->cap);
+		for_each_set_bit(num, iommu->domain_ids, ndomains) {
+			if (iommu->domains[num] == domain) {
+				clear_bit(num, iommu->domain_ids);
+				iommu->domains[num] = NULL;
+				break;
+			}
 		}
+	} else {
+		clear_bit(domain->id, iommu->domain_ids);
+		iommu->domains[domain->id] = NULL;
 	}
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
+static void domain_attach_iommu(struct dmar_domain *domain,
+			       struct intel_iommu *iommu)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&domain->iommu_lock, flags);
+	if (!test_and_set_bit(iommu->seq_id, domain->iommu_bmp)) {
+		domain->iommu_count++;
+		if (domain->iommu_count == 1)
+			domain->nid = iommu->node;
+		domain_update_iommu_cap(domain);
+	}
+	spin_unlock_irqrestore(&domain->iommu_lock, flags);
+}
+
+static int domain_detach_iommu(struct dmar_domain *domain,
+			       struct intel_iommu *iommu)
+{
+	unsigned long flags;
+	int count = INT_MAX;
+
+	spin_lock_irqsave(&domain->iommu_lock, flags);
+	if (test_and_clear_bit(iommu->seq_id, domain->iommu_bmp)) {
+		count = --domain->iommu_count;
+		domain_update_iommu_cap(domain);
+	}
+	spin_unlock_irqrestore(&domain->iommu_lock, flags);
+
+	return count;
+}
+
 static struct iova_domain reserved_iova_list;
 static struct lock_class_key reserved_rbtree_key;
 
@@ -1706,9 +1749,7 @@ static void domain_exit(struct dmar_domain *domain)
 	/* clear attached or cached domains */
 	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd)
-		if (domain_type_is_vm(domain) ||
-		    test_bit(iommu->seq_id, domain->iommu_bmp))
-			iommu_detach_domain(domain, iommu);
+		iommu_detach_domain(domain, iommu);
 	rcu_read_unlock();
 
 	dma_free_pagelist(freelist);
@@ -1762,16 +1803,12 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 		}
 
 		if (found == 0) {
-			num = find_first_zero_bit(iommu->domain_ids, ndomains);
-			if (num >= ndomains) {
+			id = __iommu_attach_domain(domain, iommu);
+			if (id < 0) {
 				spin_unlock_irqrestore(&iommu->lock, flags);
-				printk(KERN_ERR "IOMMU: no free domain ids\n");
+				pr_err("IOMMU: no free domain ids\n");
 				return -EFAULT;
 			}
-
-			set_bit(num, iommu->domain_ids);
-			iommu->domains[num] = domain;
-			id = num;
 		}
 
 		/* Skip top levels of page tables for
@@ -1830,14 +1867,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	iommu_enable_dev_iotlb(info);
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
-	spin_lock_irqsave(&domain->iommu_lock, flags);
-	if (!test_and_set_bit(iommu->seq_id, domain->iommu_bmp)) {
-		domain->iommu_count++;
-		if (domain->iommu_count == 1)
-			domain->nid = iommu->node;
-		domain_update_iommu_cap(domain);
-	}
-	spin_unlock_irqrestore(&domain->iommu_lock, flags);
+	domain_attach_iommu(domain, iommu);
+
 	return 0;
 }
 
@@ -2085,7 +2116,7 @@ static inline void unlink_domain_info(struct device_domain_info *info)
 static void domain_remove_dev_info(struct dmar_domain *domain)
 {
 	struct device_domain_info *info, *tmp;
-	unsigned long flags, flags2;
+	unsigned long flags;
 
 	spin_lock_irqsave(&device_domain_lock, flags);
 	list_for_each_entry_safe(info, tmp, &domain->devices, link) {
@@ -2097,16 +2128,7 @@ static void domain_remove_dev_info(struct dmar_domain *domain)
 
 		if (domain_type_is_vm(domain)) {
 			iommu_detach_dependent_devices(info->iommu, info->dev);
-			/* clear this iommu in iommu_bmp, update iommu count
-			 * and capabilities
-			 */
-			spin_lock_irqsave(&domain->iommu_lock, flags2);
-			if (test_and_clear_bit(info->iommu->seq_id,
-					       domain->iommu_bmp)) {
-				domain->iommu_count--;
-				domain_update_iommu_cap(domain);
-			}
-			spin_unlock_irqrestore(&domain->iommu_lock, flags2);
+			domain_detach_iommu(domain, info->iommu);
 		}
 
 		free_devinfo_mem(info);
@@ -2236,11 +2258,11 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	if (!domain)
 		return NULL;
 
-	if (iommu_attach_domain(domain, iommu)) {
+	if (iommu_attach_domain(domain, iommu) < 0) {
 		free_domain_mem(domain);
 		return NULL;
 	}
-
+	domain_attach_iommu(domain, iommu);
 	if (domain_init(domain, gaw)) {
 		domain_exit(domain);
 		return NULL;
@@ -2413,10 +2435,11 @@ static int __init si_domain_init(int hw)
 
 	for_each_active_iommu(iommu, drhd) {
 		ret = iommu_attach_domain(si_domain, iommu);
-		if (ret) {
+		if (ret < 0) {
 			domain_exit(si_domain);
 			return -EFAULT;
 		}
+		domain_attach_iommu(si_domain, iommu);
 	}
 
 	if (md_domain_init(si_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
@@ -4155,19 +4178,9 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
 	if (found == 0) {
-		unsigned long tmp_flags;
-		spin_lock_irqsave(&domain->iommu_lock, tmp_flags);
-		clear_bit(iommu->seq_id, domain->iommu_bmp);
-		domain->iommu_count--;
-		domain_update_iommu_cap(domain);
-		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
-
-		if (!domain_type_is_vm_or_si(domain)) {
-			spin_lock_irqsave(&iommu->lock, tmp_flags);
-			clear_bit(domain->id, iommu->domain_ids);
-			iommu->domains[domain->id] = NULL;
-			spin_unlock_irqrestore(&iommu->lock, tmp_flags);
-		}
+		domain_detach_iommu(domain, iommu);
+		if (!domain_type_is_vm_or_si(domain))
+			iommu_detach_domain(domain, iommu);
 	}
 }
 
-- 
1.7.10.4

