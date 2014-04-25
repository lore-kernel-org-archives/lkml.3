Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaDYAiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:38:01 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:20551 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaDYAhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:37:16 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com, jerry.hoemann@hp.com
Subject: [PATCH 4/8] iommu/vt-d: Update iommu_attach_domain() and its callers
Date: Thu, 24 Apr 2014 18:36:34 -0600
Message-Id: <1398386198-19304-5-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow specification of the domain-id for the new domain.
This patch only adds the 'did' parameter to iommu_attach_domain()
and modifies all of its callers to specify the default value of -1
which says "no did specified, allocate a new one".

This is no functional change from current behaviour -- just enables
a functional change to be made in a later patch.

Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 4116377..226c1d0 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1181,7 +1181,8 @@ static struct dmar_domain *alloc_domain(bool vm)
 }
 
 static int iommu_attach_domain(struct dmar_domain *domain,
-			       struct intel_iommu *iommu)
+			       struct intel_iommu *iommu,
+			       int domain_number)
 {
 	int num;
 	unsigned long ndomains;
@@ -1191,12 +1192,15 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 
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
 	domain->iommu_count++;
@@ -1875,6 +1879,7 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	struct pci_dev *dev_tmp = NULL;
 	unsigned long flags;
 	u8 bus, devfn, bridge_bus, bridge_devfn;
+	int did = -1;   /* Default to "no domain_id supplied" */
 
 	domain = find_domain(dev);
 	if (domain)
@@ -1915,7 +1920,7 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	domain = alloc_domain(false);
 	if (!domain)
 		goto error;
-	if (iommu_attach_domain(domain, iommu)) {
+	if (iommu_attach_domain(domain, iommu, did)) {
 		free_domain_mem(domain);
 		domain = NULL;
 		goto error;
@@ -2083,7 +2088,7 @@ static int __init si_domain_init(int hw)
 	si_domain->flags = DOMAIN_FLAG_STATIC_IDENTITY;
 
 	for_each_active_iommu(iommu, drhd) {
-		ret = iommu_attach_domain(si_domain, iommu);
+		ret = iommu_attach_domain(si_domain, iommu, (int) -1);
 		if (ret) {
 			domain_exit(si_domain);
 			return -EFAULT;
-- 
Bill Sumner <bill.sumner@hp.com>

