Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaAGJE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:04:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:20795 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426AbaAGJAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454739909"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [Patch Part2 V1 06/14] iommu/vt-d: fix incorrect iommu_count for si_domain
Date: Tue,  7 Jan 2014 17:00:26 +0800
Message-Id: <1389085234-22296-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iommu_count for si_domain (static identity) is always zero,
which will cause trouble when trying to tear down si_domain.

[   14.609681] IOMMU: Setting RMRR:
[   14.613496] Ignoring identity map for HW passthrough device 0000:00:1a.0 [0xbdcfd000 - 0xbdd1dfff]
[   14.623809] Ignoring identity map for HW passthrough device 0000:00:1d.0 [0xbdcfd000 - 0xbdd1dfff]
[   14.634162] IOMMU: Prepare 0-16MiB unity mapping for LPC
[   14.640329] Ignoring identity map for HW passthrough device 0000:00:1f.0 [0x0 - 0xffffff]
[   14.673360] IOMMU: dmar init failed
[   14.678157] kmem_cache_destroy iommu_devinfo: Slab cache still has objects
[   14.686076] CPU: 12 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-gerry+ #59
[   14.694176] Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS SE5C600.86B.99.99.x059.091020121352 09/10/2012
[   14.707412]  0000000000000000 ffff88042dd33db0 ffffffff8156223d ffff880c2cc37c00
[   14.716407]  ffff88042dd33dc8 ffffffff811790b1 ffff880c2d3533b8 ffff88042dd33e00
[   14.725468]  ffffffff81dc7a6a ffffffff81b1e8e0 ffffffff81f84058 ffffffff81d8a711
[   14.734464] Call Trace:
[   14.737453]  [<ffffffff8156223d>] dump_stack+0x4d/0x66
[   14.743430]  [<ffffffff811790b1>] kmem_cache_destroy+0xf1/0x100
[   14.750279]  [<ffffffff81dc7a6a>] intel_iommu_init+0x122/0x56a
[   14.757035]  [<ffffffff81d8a711>] ? iommu_setup+0x27d/0x27d
[   14.763491]  [<ffffffff81d8a739>] pci_iommu_init+0x28/0x52
[   14.769846]  [<ffffffff81000342>] do_one_initcall+0x122/0x180
[   14.776506]  [<ffffffff81077738>] ? parse_args+0x1e8/0x320
[   14.782866]  [<ffffffff81d850e8>] kernel_init_freeable+0x1e1/0x26c
[   14.789994]  [<ffffffff81d84833>] ? do_early_param+0x88/0x88
[   14.796556]  [<ffffffff8154ffc0>] ? rest_init+0xd0/0xd0
[   14.802626]  [<ffffffff8154ffce>] kernel_init+0xe/0x130
[   14.808698]  [<ffffffff815756ac>] ret_from_fork+0x7c/0xb0
[   14.814963]  [<ffffffff8154ffc0>] ? rest_init+0xd0/0xd0
[   14.821640] kmem_cache_destroy iommu_domain: Slab cache still has objects
[   14.829456] CPU: 12 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-gerry+ #59
[   14.837562] Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS SE5C600.86B.99.99.x059.091020121352 09/10/2012
[   14.850803]  0000000000000000 ffff88042dd33db0 ffffffff8156223d ffff88102c1ee3c0
[   14.861222]  ffff88042dd33dc8 ffffffff811790b1 ffff880c2d3533b8 ffff88042dd33e00
[   14.870284]  ffffffff81dc7a76 ffffffff81b1e8e0 ffffffff81f84058 ffffffff81d8a711
[   14.879271] Call Trace:
[   14.882227]  [<ffffffff8156223d>] dump_stack+0x4d/0x66
[   14.888197]  [<ffffffff811790b1>] kmem_cache_destroy+0xf1/0x100
[   14.895034]  [<ffffffff81dc7a76>] intel_iommu_init+0x12e/0x56a
[   14.901781]  [<ffffffff81d8a711>] ? iommu_setup+0x27d/0x27d
[   14.908238]  [<ffffffff81d8a739>] pci_iommu_init+0x28/0x52
[   14.914594]  [<ffffffff81000342>] do_one_initcall+0x122/0x180
[   14.921244]  [<ffffffff81077738>] ? parse_args+0x1e8/0x320
[   14.927598]  [<ffffffff81d850e8>] kernel_init_freeable+0x1e1/0x26c
[   14.934738]  [<ffffffff81d84833>] ? do_early_param+0x88/0x88
[   14.941309]  [<ffffffff8154ffc0>] ? rest_init+0xd0/0xd0
[   14.947380]  [<ffffffff8154ffce>] kernel_init+0xe/0x130
[   14.953430]  [<ffffffff815756ac>] ret_from_fork+0x7c/0xb0
[   14.959689]  [<ffffffff8154ffc0>] ? rest_init+0xd0/0xd0
[   14.966299] kmem_cache_destroy iommu_iova: Slab cache still has objects
[   14.973923] CPU: 12 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-gerry+ #59
[   14.982020] Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS SE5C600.86B.99.99.x059.091020121352 09/10/2012
[   14.995263]  0000000000000000 ffff88042dd33db0 ffffffff8156223d ffff88042cb5c980
[   15.004265]  ffff88042dd33dc8 ffffffff811790b1 ffff880c2d3533b8 ffff88042dd33e00
[   15.013322]  ffffffff81dc7a82 ffffffff81b1e8e0 ffffffff81f84058 ffffffff81d8a711
[   15.022318] Call Trace:
[   15.025238]  [<ffffffff8156223d>] dump_stack+0x4d/0x66
[   15.031202]  [<ffffffff811790b1>] kmem_cache_destroy+0xf1/0x100
[   15.038038]  [<ffffffff81dc7a82>] intel_iommu_init+0x13a/0x56a
[   15.044786]  [<ffffffff81d8a711>] ? iommu_setup+0x27d/0x27d
[   15.051242]  [<ffffffff81d8a739>] pci_iommu_init+0x28/0x52
[   15.057601]  [<ffffffff81000342>] do_one_initcall+0x122/0x180
[   15.064254]  [<ffffffff81077738>] ? parse_args+0x1e8/0x320
[   15.070608]  [<ffffffff81d850e8>] kernel_init_freeable+0x1e1/0x26c
[   15.077747]  [<ffffffff81d84833>] ? do_early_param+0x88/0x88
[   15.084300]  [<ffffffff8154ffc0>] ? rest_init+0xd0/0xd0
[   15.090362]  [<ffffffff8154ffce>] kernel_init+0xe/0x130
[   15.096431]  [<ffffffff815756ac>] ret_from_fork+0x7c/0xb0
[   15.102693]  [<ffffffff8154ffc0>] ? rest_init+0xd0/0xd0
[   15.189273] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/intel-iommu.c |   64 ++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d5ad21d..7038b38 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -425,7 +425,8 @@ static LIST_HEAD(unmaps_to_do);
 static int timer_on;
 static long list_size;
 
-static void domain_remove_dev_info(struct dmar_domain *domain);
+static void domain_remove_dev_info(struct dmar_domain *domain,
+				   struct intel_iommu *match);
 static void domain_remove_one_dev_info(struct dmar_domain *domain,
 				       struct pci_dev *pdev);
 
@@ -1300,15 +1301,22 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 		for_each_set_bit(i, iommu->domain_ids, cap_ndoms(iommu->cap)) {
 			domain = iommu->domains[i];
 			clear_bit(i, iommu->domain_ids);
+			domain_remove_dev_info(domain, iommu);
 
 			spin_lock_irqsave(&domain->iommu_lock, flags);
-			count = --domain->iommu_count;
+			if (test_and_clear_bit(iommu->seq_id,
+					       domain->iommu_bmp))
+				count = --domain->iommu_count;
+			else
+				count = 1;
 			spin_unlock_irqrestore(&domain->iommu_lock, flags);
-			if (count == 0) {
-				if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
-					vm_domain_exit(domain);
-				else
-					domain_exit(domain);
+
+			/* Keep VM domains, user still has reference to them */
+			if (count == 0 &&
+			    !(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)) {
+				domain_exit(domain);
+				if (domain == si_domain)
+					si_domain = NULL;
 			}
 		}
 	}
@@ -1336,8 +1344,11 @@ static struct dmar_domain *alloc_domain(void)
 		return NULL;
 
 	domain->nid = -1;
+	domain->iommu_count = 0;
 	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = 0;
+	spin_lock_init(&domain->iommu_lock);
+	INIT_LIST_HEAD(&domain->devices);
 
 	return domain;
 }
@@ -1361,6 +1372,7 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 	}
 
 	domain->id = num;
+	domain->iommu_count++;
 	set_bit(num, iommu->domain_ids);
 	set_bit(iommu->seq_id, domain->iommu_bmp);
 	iommu->domains[num] = domain;
@@ -1461,8 +1473,6 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
 	unsigned long sagaw;
 
 	init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
-	spin_lock_init(&domain->iommu_lock);
-
 	domain_reserve_special_ranges(domain);
 
 	/* calculate AGAW */
@@ -1481,7 +1491,6 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
 			return -ENODEV;
 	}
 	domain->agaw = agaw;
-	INIT_LIST_HEAD(&domain->devices);
 
 	if (ecap_coherent(iommu->ecap))
 		domain->iommu_coherency = 1;
@@ -1494,7 +1503,6 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
 		domain->iommu_snooping = 0;
 
 	domain->iommu_superpage = fls(cap_super_page_val(iommu->cap));
-	domain->iommu_count = 1;
 	domain->nid = iommu->node;
 
 	/* always allocate the top pgd */
@@ -1518,7 +1526,7 @@ static void domain_exit(struct dmar_domain *domain)
 	if (!intel_iommu_strict)
 		flush_unmaps_timeout(0);
 
-	domain_remove_dev_info(domain);
+	domain_remove_dev_info(domain, NULL);
 	/* destroy iovas */
 	put_iova_domain(&domain->iovad);
 
@@ -1918,27 +1926,29 @@ static inline void unlink_domain_info(struct device_domain_info *info)
 		info->dev->dev.archdata.iommu = NULL;
 }
 
-static void domain_remove_dev_info(struct dmar_domain *domain)
+static void domain_remove_dev_info(struct dmar_domain *domain,
+				   struct intel_iommu *match)
 {
-	struct device_domain_info *info;
+	struct device_domain_info *info, *tmp;
 	unsigned long flags;
 	struct intel_iommu *iommu;
+	LIST_HEAD(list);
 
 	spin_lock_irqsave(&device_domain_lock, flags);
-	while (!list_empty(&domain->devices)) {
-		info = list_entry(domain->devices.next,
-			struct device_domain_info, link);
-		unlink_domain_info(info);
-		spin_unlock_irqrestore(&device_domain_lock, flags);
+	list_for_each_entry_safe(info, tmp, &domain->devices, link)
+		if (!match || match == device_to_iommu(info->segment,
+					info->bus, info->devfn)) {
+			unlink_domain_info(info);
+			list_add(&info->link, &list);
+		}
+	spin_unlock_irqrestore(&device_domain_lock, flags);
 
+	list_for_each_entry_safe(info, tmp, &list, link) {
 		iommu_disable_dev_iotlb(info);
 		iommu = device_to_iommu(info->segment, info->bus, info->devfn);
 		iommu_detach_dev(iommu, info->bus, info->devfn);
 		free_devinfo_mem(info);
-
-		spin_lock_irqsave(&device_domain_lock, flags);
 	}
-	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
 
 /*
@@ -3862,8 +3872,11 @@ static struct dmar_domain *iommu_alloc_vm_domain(void)
 
 	domain->id = atomic_inc_return(&vm_domid);
 	domain->nid = -1;
+	domain->iommu_count = 0;
 	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
+	spin_lock_init(&domain->iommu_lock);
+	INIT_LIST_HEAD(&domain->devices);
 
 	return domain;
 }
@@ -3873,8 +3886,6 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	int adjust_width;
 
 	init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
-	spin_lock_init(&domain->iommu_lock);
-
 	domain_reserve_special_ranges(domain);
 
 	/* calculate AGAW */
@@ -3882,9 +3893,6 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	adjust_width = guestwidth_to_adjustwidth(guest_width);
 	domain->agaw = width_to_agaw(adjust_width);
 
-	INIT_LIST_HEAD(&domain->devices);
-
-	domain->iommu_count = 0;
 	domain->iommu_coherency = 0;
 	domain->iommu_snooping = 0;
 	domain->iommu_superpage = 0;
@@ -3993,7 +4001,7 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 			    dmar_domain->flags & DOMAIN_FLAG_STATIC_IDENTITY)
 				domain_remove_one_dev_info(old_domain, pdev);
 			else
-				domain_remove_dev_info(old_domain);
+				domain_remove_dev_info(old_domain, NULL);
 		}
 	}
 
-- 
1.7.10.4

