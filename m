Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaJUIE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:04:56 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:11041 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaJUIEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:04:49 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>
Cc: <iommu@lists.linux-foundation.org>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/5] iommu/vt-d: Update iommu_attach_domain() and its callers
Date: Tue, 21 Oct 2014 16:04:15 +0800
Message-Id: <1413878659-1383-2-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow specification of the domain-id for the new domain.
This patch only adds the 'did' parameter to iommu_attach_domain()
and modifies all of its callers to specify the default value of -1
which says "no did specified, allocate a new one".

This is no functional change from current behaviour -- just enables
a functional change to be made in a later patch.

Bill Sumner:
    Original version.

Li, Zhenhua:
    Minor change, add change to function __iommu_attach_domain.

Signed-off-by: Bill Sumner 
Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel-iommu.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a27d6cb..1c7350d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1531,31 +1531,36 @@ static struct dmar_domain *alloc_domain(int flags)
 }
 
 static int __iommu_attach_domain(struct dmar_domain *domain,
-				 struct intel_iommu *iommu)
+				 struct intel_iommu *iommu,
+				 int domain_number)
 {
 	int num;
 	unsigned long ndomains;
 
 	ndomains = cap_ndoms(iommu->cap);
-	num = find_first_zero_bit(iommu->domain_ids, ndomains);
-	if (num < ndomains) {
-		set_bit(num, iommu->domain_ids);
-		iommu->domains[num] = domain;
-	} else {
-		num = -ENOSPC;
-	}
+	if (domain_number < 0) {
+		num = find_first_zero_bit(iommu->domain_ids, ndomains);
+		if (num < ndomains) {
+			set_bit(num, iommu->domain_ids);
+			iommu->domains[num] = domain;
+		} else {
+			num = -ENOSPC;
+		}
+	} else
+		num = domain_number;
 
 	return num;
 }
 
 static int iommu_attach_domain(struct dmar_domain *domain,
-			       struct intel_iommu *iommu)
+			       struct intel_iommu *iommu,
+			       int domain_number)
 {
 	int num;
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu->lock, flags);
-	num = __iommu_attach_domain(domain, iommu);
+	num = __iommu_attach_domain(domain, iommu, domain_number);
 	spin_unlock_irqrestore(&iommu->lock, flags);
 	if (num < 0)
 		pr_err("IOMMU: no free domain ids\n");
@@ -1574,7 +1579,7 @@ static int iommu_attach_vm_domain(struct dmar_domain *domain,
 		if (iommu->domains[num] == domain)
 			return num;
 
-	return __iommu_attach_domain(domain, iommu);
+	return __iommu_attach_domain(domain, iommu, -1);
 }
 
 static void iommu_detach_domain(struct dmar_domain *domain,
@@ -2230,6 +2235,7 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	u16 dma_alias;
 	unsigned long flags;
 	u8 bus, devfn;
+	int did = -1;   /* Default to "no domain_id supplied" */
 
 	domain = find_domain(dev);
 	if (domain)
@@ -2263,7 +2269,7 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	domain = alloc_domain(0);
 	if (!domain)
 		return NULL;
-	domain->id = iommu_attach_domain(domain, iommu);
+	domain->id = iommu_attach_domain(domain, iommu, did);
 	if (domain->id < 0) {
 		free_domain_mem(domain);
 		return NULL;
@@ -2441,7 +2447,7 @@ static int __init si_domain_init(int hw)
 		return -EFAULT;
 
 	for_each_active_iommu(iommu, drhd) {
-		ret = iommu_attach_domain(si_domain, iommu);
+		ret = iommu_attach_domain(si_domain, iommu, -1);
 		if (ret < 0) {
 			domain_exit(si_domain);
 			return -EFAULT;
-- 
2.0.0-rc0

