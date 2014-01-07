Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaAGJAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:00:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:40167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbaAGJAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454739723"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V1 03/14] iommu/vt-d: simplify function get_domain_for_dev()
Date: Tue,  7 Jan 2014 17:00:23 +0800
Message-Id: <1389085234-22296-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function get_domain_for_dev() is a little complex, simplify it
by factoring out dmar_search_domain_by_dev_info() and
dmar_insert_dev_info().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |  161 ++++++++++++++++++++-----------------------
 1 file changed, 75 insertions(+), 86 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 1704e97..da65884 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1957,18 +1957,70 @@ find_domain(struct pci_dev *pdev)
 	return NULL;
 }
 
+static inline struct dmar_domain *
+dmar_search_domain_by_dev_info(int segment, int bus, int devfn)
+{
+	struct device_domain_info *info;
+
+	list_for_each_entry(info, &device_domain_list, global)
+		if (info->segment == segment && info->bus == bus &&
+		    info->devfn == devfn)
+			return info->domain;
+
+	return NULL;
+}
+
+static int dmar_insert_dev_info(int segment, int bus, int devfn,
+				struct pci_dev *dev, struct dmar_domain **domp)
+{
+	struct dmar_domain *found, *domain = *domp;
+	struct device_domain_info *info;
+	unsigned long flags;
+
+	info = alloc_devinfo_mem();
+	if (!info)
+		return -ENOMEM;
+
+	info->segment = segment;
+	info->bus = bus;
+	info->devfn = devfn;
+	info->dev = dev;
+	info->domain = domain;
+	if (!dev)
+		domain->flags |= DOMAIN_FLAG_P2P_MULTIPLE_DEVICES;
+
+	spin_lock_irqsave(&device_domain_lock, flags);
+	if (dev)
+		found = find_domain(dev);
+	else
+		found = dmar_search_domain_by_dev_info(segment, bus, devfn);
+	if (found) {
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		free_devinfo_mem(info);
+		if (found != domain) {
+			domain_exit(domain);
+			*domp = found;
+		}
+	} else {
+		list_add(&info->link, &domain->devices);
+		list_add(&info->global, &device_domain_list);
+		if (dev)
+			dev->dev.archdata.iommu = info;
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+	}
+
+	return 0;
+}
+
 /* domain is initialized */
 static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 {
-	struct dmar_domain *domain, *found = NULL;
+	struct dmar_domain *domain;
 	struct intel_iommu *iommu;
 	struct dmar_drhd_unit *drhd;
-	struct device_domain_info *info, *tmp;
-	struct pci_dev *dev_tmp;
+	struct pci_dev *bridge;
 	unsigned long flags;
-	int bus = 0, devfn = 0;
-	int segment;
-	int ret;
+	int segment, bus, devfn;
 
 	domain = find_domain(pdev);
 	if (domain)
@@ -1976,119 +2028,56 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 
 	segment = pci_domain_nr(pdev->bus);
 
-	dev_tmp = pci_find_upstream_pcie_bridge(pdev);
-	if (dev_tmp) {
-		if (pci_is_pcie(dev_tmp)) {
-			bus = dev_tmp->subordinate->number;
+	bridge = pci_find_upstream_pcie_bridge(pdev);
+	if (bridge) {
+		if (pci_is_pcie(bridge)) {
+			bus = bridge->subordinate->number;
 			devfn = 0;
 		} else {
-			bus = dev_tmp->bus->number;
-			devfn = dev_tmp->devfn;
+			bus = bridge->bus->number;
+			devfn = bridge->devfn;
 		}
 		spin_lock_irqsave(&device_domain_lock, flags);
-		list_for_each_entry(info, &device_domain_list, global) {
-			if (info->segment == segment &&
-			    info->bus == bus && info->devfn == devfn) {
-				found = info->domain;
-				break;
-			}
-		}
+		domain = dmar_search_domain_by_dev_info(segment, bus, devfn);
 		spin_unlock_irqrestore(&device_domain_lock, flags);
 		/* pcie-pci bridge already has a domain, uses it */
-		if (found) {
-			domain = found;
+		if (domain)
 			goto found_domain;
-		}
 	}
 
-	domain = alloc_domain();
-	if (!domain)
-		goto error;
-
-	/* Allocate new domain for the device */
 	drhd = dmar_find_matched_drhd_unit(pdev);
 	if (!drhd) {
 		printk(KERN_ERR "IOMMU: can't find DMAR for device %s\n",
 			pci_name(pdev));
-		free_domain_mem(domain);
 		return NULL;
 	}
 	iommu = drhd->iommu;
 
-	ret = iommu_attach_domain(domain, iommu);
-	if (ret) {
+	/* Allocate new domain for the device */
+	domain = alloc_domain();
+	if (!domain)
+		goto error;
+	if (iommu_attach_domain(domain, iommu)) {
 		free_domain_mem(domain);
 		goto error;
 	}
-
 	if (domain_init(domain, gaw)) {
 		domain_exit(domain);
 		goto error;
 	}
 
 	/* register pcie-to-pci device */
-	if (dev_tmp) {
-		info = alloc_devinfo_mem();
-		if (!info) {
+	if (bridge) {
+		if (dmar_insert_dev_info(segment, bus, devfn, NULL, &domain)) {
 			domain_exit(domain);
 			goto error;
 		}
-		info->segment = segment;
-		info->bus = bus;
-		info->devfn = devfn;
-		info->dev = NULL;
-		info->domain = domain;
-		/* This domain is shared by devices under p2p bridge */
-		domain->flags |= DOMAIN_FLAG_P2P_MULTIPLE_DEVICES;
-
-		/* pcie-to-pci bridge already has a domain, uses it */
-		found = NULL;
-		spin_lock_irqsave(&device_domain_lock, flags);
-		list_for_each_entry(tmp, &device_domain_list, global) {
-			if (tmp->segment == segment &&
-			    tmp->bus == bus && tmp->devfn == devfn) {
-				found = tmp->domain;
-				break;
-			}
-		}
-		if (found) {
-			spin_unlock_irqrestore(&device_domain_lock, flags);
-			free_devinfo_mem(info);
-			domain_exit(domain);
-			domain = found;
-		} else {
-			list_add(&info->link, &domain->devices);
-			list_add(&info->global, &device_domain_list);
-			spin_unlock_irqrestore(&device_domain_lock, flags);
-		}
 	}
 
 found_domain:
-	info = alloc_devinfo_mem();
-	if (!info)
-		goto error;
-	info->segment = segment;
-	info->bus = pdev->bus->number;
-	info->devfn = pdev->devfn;
-	info->dev = pdev;
-	info->domain = domain;
-	spin_lock_irqsave(&device_domain_lock, flags);
-	/* somebody is fast */
-	found = find_domain(pdev);
-	if (found != NULL) {
-		spin_unlock_irqrestore(&device_domain_lock, flags);
-		if (found != domain) {
-			domain_exit(domain);
-			domain = found;
-		}
-		free_devinfo_mem(info);
+	if (dmar_insert_dev_info(segment, pdev->bus->number, pdev->devfn,
+				 pdev, &domain) == 0)
 		return domain;
-	}
-	list_add(&info->link, &domain->devices);
-	list_add(&info->global, &device_domain_list);
-	pdev->dev.archdata.iommu = info;
-	spin_unlock_irqrestore(&device_domain_lock, flags);
-	return domain;
 error:
 	/* recheck it here, maybe others set it */
 	return find_domain(pdev);
-- 
1.7.10.4

