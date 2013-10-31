Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3JaJaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:30:46 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:33699 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3JaJaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:30:19 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 2/2] IOMMU: Use list_for_each_entry_safe() for dmar_domain->devices traversal
Date: Thu, 31 Oct 2013 17:26:04 +0800
Message-ID: <1383211564-39716-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace list_for_each_safe() + list_entry() with the simpler
list_for_each_entry_safe().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/intel-iommu.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 15e9b57..98faa1d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3777,11 +3777,10 @@ static void iommu_detach_dependent_devices(struct intel_iommu *iommu,
 static void domain_remove_one_dev_info(struct dmar_domain *domain,
 					  struct pci_dev *pdev)
 {
-	struct device_domain_info *info;
+	struct device_domain_info *info, *tmp;
 	struct intel_iommu *iommu;
 	unsigned long flags;
 	int found = 0;
-	struct list_head *entry, *tmp;
 
 	iommu = device_to_iommu(pci_domain_nr(pdev->bus), pdev->bus->number,
 				pdev->devfn);
@@ -3789,8 +3788,7 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 		return;
 
 	spin_lock_irqsave(&device_domain_lock, flags);
-	list_for_each_safe(entry, tmp, &domain->devices) {
-		info = list_entry(entry, struct device_domain_info, link);
+	list_for_each_entry_safe(info, tmp, &domain->devices, link) {
 		if (info->segment == pci_domain_nr(pdev->bus) &&
 		    info->bus == pdev->bus->number &&
 		    info->devfn == pdev->devfn) {
-- 
1.7.1


