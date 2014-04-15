Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaDOXJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:09:35 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:44344 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaDOXJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:09:31 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com
Subject: [PATCH 4/8] Update iommu_attach_domain() and its callers
Date: Tue, 15 Apr 2014 17:09:05 -0600
Message-Id: <1397603349-30930-5-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
References: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Allow specification of the domain-id for the new domain.


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 4352731..0c00c2d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1003,7 +1003,8 @@ static struct dmar_domain *alloc_domain(void)
 }
 
 static int iommu_attach_domain(struct dmar_domain *domain,
-			       struct intel_iommu *iommu)
+			       struct intel_iommu *iommu,
+			       int domain_number)
 {
 	int num;
 	unsigned long ndomains;
@@ -1013,12 +1014,15 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 
 	spin_lock_irqsave(&iommu->lock, flags);
 
-	num = find_first_zero_bit(iommu->domain_ids, ndomains);
-	if (num >= ndomains) {
-		spin_unlock_irqrestore(&iommu->lock, flags);
-		printk(KERN_ERR "IOMMU: no free domain ids\n");
-		return -ENOMEM;
-	}
+	if (domain_number < 0) {
+		num = find_first_zero_bit(iommu->domain_ids, ndomains);
+		if (num >= ndomains) {
+			spin_unlock_irqrestore(&iommu->lock, flags);
+			pr_err("IOMMU: no free domain ids\n");
+			return -ENOMEM;
+		}
+	} else
+		num = domain_number;
 
 	domain->id = num;
 	set_bit(num, iommu->domain_ids);
@@ -1629,6 +1633,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	int bus = 0, devfn = 0;
 	int segment;
 	int ret;
+	int did = -1;   /* Default to "no domain_id supplied" */
 
 	domain = find_domain(pdev);
 	if (domain)
@@ -1675,7 +1680,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	}
 	iommu = drhd->iommu;
 
-	ret = iommu_attach_domain(domain, iommu);
+	ret = iommu_attach_domain(domain, iommu, did);
 	if (ret) {
 		free_domain_mem(domain);
 		goto error;
@@ -1894,7 +1899,7 @@ static int __init si_domain_init(int hw)
 		return -EFAULT;
 
 	for_each_active_iommu(iommu, drhd) {
-		ret = iommu_attach_domain(si_domain, iommu);
+		ret = iommu_attach_domain(si_domain, iommu, (int) -1);
 		if (ret) {
 			domain_exit(si_domain);
 			return -EFAULT;
-- 
Bill Sumner <bill.sumner@hp.com>

