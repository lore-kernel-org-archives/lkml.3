Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197AbaEFHD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:03:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:39650 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934095AbaEFHDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:03:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,995,1389772800"; 
   d="scan'208";a="526662055"
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
Subject: [Patch Part3 V2 03/21] iommu/vt-d: introduce helper functions to improve code readability
Date: Tue,  6 May 2014 15:05:14 +0800
Message-Id: <1399359932-28972-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
References: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce domain_type_is_vm() and domain_type_is_vm_or_si() to improve
code readability.

Also kill useless macro DOMAIN_FLAG_P2P_MULTIPLE_DEVICES.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   59 +++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0b3e6981a2da..63f351a39c63 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -320,16 +320,13 @@ static inline int first_pte_in_page(struct dma_pte *pte)
 static struct dmar_domain *si_domain;
 static int hw_pass_through = 1;
 
-/* devices under the same p2p bridge are owned in one domain */
-#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 << 0)
-
 /* domain represents a virtual machine, more than one devices
  * across iommus may be owned in one domain, e.g. kvm guest.
  */
-#define DOMAIN_FLAG_VIRTUAL_MACHINE	(1 << 1)
+#define DOMAIN_FLAG_VIRTUAL_MACHINE	(1 << 0)
 
 /* si_domain contains mulitple devices */
-#define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 2)
+#define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 1)
 
 /* define the limit of IOMMUs supported in each domain */
 #ifdef	CONFIG_X86
@@ -539,6 +536,16 @@ void free_iova_mem(struct iova *iova)
 	kmem_cache_free(iommu_iova_cache, iova);
 }
 
+static inline int domain_type_is_vm(struct dmar_domain *domain)
+{
+	return domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE;
+}
+
+static inline int domain_type_is_vm_or_si(struct dmar_domain *domain)
+{
+	return domain->flags & (DOMAIN_FLAG_VIRTUAL_MACHINE |
+				DOMAIN_FLAG_STATIC_IDENTITY);
+}
 
 static int __iommu_calculate_agaw(struct intel_iommu *iommu, int max_gaw)
 {
@@ -579,9 +586,7 @@ static struct intel_iommu *domain_get_iommu(struct dmar_domain *domain)
 	int iommu_id;
 
 	/* si_domain and vm domain should not get here. */
-	BUG_ON(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE);
-	BUG_ON(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY);
-
+	BUG_ON(domain_type_is_vm_or_si(domain));
 	iommu_id = find_first_bit(domain->iommu_bmp, g_num_of_iommus);
 	if (iommu_id < 0 || iommu_id >= g_num_of_iommus)
 		return NULL;
@@ -1499,7 +1504,7 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 	free_context_table(iommu);
 }
 
-static struct dmar_domain *alloc_domain(bool vm)
+static struct dmar_domain *alloc_domain(int flags)
 {
 	/* domain id for virtual machine, it won't be set in context */
 	static atomic_t vm_domid = ATOMIC_INIT(0);
@@ -1509,16 +1514,13 @@ static struct dmar_domain *alloc_domain(bool vm)
 	if (!domain)
 		return NULL;
 
+	memset(domain, 0, sizeof(*domain));
 	domain->nid = -1;
-	domain->iommu_count = 0;
-	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
-	domain->flags = 0;
+	domain->flags = flags;
 	spin_lock_init(&domain->iommu_lock);
 	INIT_LIST_HEAD(&domain->devices);
-	if (vm) {
+	if (flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
 		domain->id = atomic_inc_return(&vm_domid);
-		domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
-	}
 
 	return domain;
 }
@@ -1706,7 +1708,7 @@ static void domain_exit(struct dmar_domain *domain)
 	/* clear attached or cached domains */
 	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd)
-		if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE ||
+		if (domain_type_is_vm(domain) ||
 		    test_bit(iommu->seq_id, domain->iommu_bmp))
 			iommu_detach_domain(domain, iommu);
 	rcu_read_unlock();
@@ -1748,8 +1750,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	id = domain->id;
 	pgd = domain->pgd;
 
-	if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE ||
-	    domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) {
+	if (domain_type_is_vm_or_si(domain)) {
 		int found = 0;
 
 		/* find an available domain id for this device in iommu */
@@ -2115,7 +2116,7 @@ static void domain_remove_dev_info(struct dmar_domain *domain)
 		iommu_disable_dev_iotlb(info);
 		iommu_detach_dev(info->iommu, info->bus, info->devfn);
 
-		if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) {
+		if (domain_type_is_vm(domain)) {
 			iommu_detach_dependent_devices(info->iommu, info->dev);
 			/* clear this iommu in iommu_bmp, update iommu count
 			 * and capabilities
@@ -2181,8 +2182,6 @@ static struct dmar_domain *dmar_insert_dev_info(struct intel_iommu *iommu,
 	info->dev = dev;
 	info->domain = domain;
 	info->iommu = iommu;
-	if (!dev)
-		domain->flags |= DOMAIN_FLAG_P2P_MULTIPLE_DEVICES;
 
 	spin_lock_irqsave(&device_domain_lock, flags);
 	if (dev)
@@ -2257,7 +2256,7 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 		goto error;
 
 	/* Allocate and initialize new domain for the device */
-	domain = alloc_domain(false);
+	domain = alloc_domain(0);
 	if (!domain)
 		goto error;
 	if (iommu_attach_domain(domain, iommu)) {
@@ -2421,12 +2420,10 @@ static int __init si_domain_init(int hw)
 	struct intel_iommu *iommu;
 	int nid, ret = 0;
 
-	si_domain = alloc_domain(false);
+	si_domain = alloc_domain(DOMAIN_FLAG_STATIC_IDENTITY);
 	if (!si_domain)
 		return -EFAULT;
 
-	si_domain->flags = DOMAIN_FLAG_STATIC_IDENTITY;
-
 	for_each_active_iommu(iommu, drhd) {
 		ret = iommu_attach_domain(si_domain, iommu);
 		if (ret) {
@@ -3860,9 +3857,7 @@ static int device_notifier(struct notifier_block *nb,
 
 	down_read(&dmar_global_lock);
 	domain_remove_one_dev_info(domain, dev);
-	if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
-	    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
-	    list_empty(&domain->devices))
+	if (!domain_type_is_vm_or_si(domain) && list_empty(&domain->devices))
 		domain_exit(domain);
 	up_read(&dmar_global_lock);
 
@@ -4111,8 +4106,7 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
 
-		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
-		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY)) {
+		if (!domain_type_is_vm_or_si(domain)) {
 			spin_lock_irqsave(&iommu->lock, tmp_flags);
 			clear_bit(domain->id, iommu->domain_ids);
 			iommu->domains[domain->id] = NULL;
@@ -4151,7 +4145,7 @@ static int intel_iommu_domain_init(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain;
 
-	dmar_domain = alloc_domain(true);
+	dmar_domain = alloc_domain(DOMAIN_FLAG_VIRTUAL_MACHINE);
 	if (!dmar_domain) {
 		printk(KERN_ERR
 			"intel_iommu_domain_init: dmar_domain == NULL\n");
@@ -4195,8 +4189,7 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 
 		old_domain = find_domain(dev);
 		if (old_domain) {
-			if (dmar_domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE ||
-			    dmar_domain->flags & DOMAIN_FLAG_STATIC_IDENTITY)
+			if (domain_type_is_vm_or_si(dmar_domain))
 				domain_remove_one_dev_info(old_domain, dev);
 			else
 				domain_remove_dev_info(old_domain);
-- 
1.7.10.4

