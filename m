Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392AbaEFHHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:07:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:53954 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934258AbaEFHEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:04:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,995,1389772800"; 
   d="scan'208";a="526662559"
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
Subject: [Patch Part3 V2 13/21] iommu/vt-d: fix bug in computing domain's iommu_snooping flag
Date: Tue,  6 May 2014 15:05:24 +0800
Message-Id: <1399359932-28972-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
References: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU units may dynamically attached to/detached from domains,
so we should scan all active IOMMU units when computing iommu_snooping
flag for a domain instead of only scanning IOMMU units associated
with the domain.

Also check snooping and superpage capabilities when hot-adding DMAR units.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0ebea100108f..080b4f24bd7c 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -633,50 +633,56 @@ static void domain_update_iommu_coherency(struct dmar_domain *domain)
 	rcu_read_unlock();
 }
 
-static void domain_update_iommu_snooping(struct dmar_domain *domain)
+static int domain_update_iommu_snooping(struct intel_iommu *skip)
 {
-	int i;
-
-	domain->iommu_snooping = 1;
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	int ret = 1;
 
-	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
-		if (!ecap_sc_support(g_iommus[i]->ecap)) {
-			domain->iommu_snooping = 0;
-			break;
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd) {
+		if (iommu != skip) {
+			if (!ecap_sc_support(iommu->ecap)) {
+				ret = 0;
+				break;
+			}
 		}
 	}
+	rcu_read_unlock();
+
+	return ret;
 }
 
-static void domain_update_iommu_superpage(struct dmar_domain *domain)
+static int domain_update_iommu_superpage(struct intel_iommu *skip)
 {
 	struct dmar_drhd_unit *drhd;
-	struct intel_iommu *iommu = NULL;
+	struct intel_iommu *iommu;
 	int mask = 0xf;
 
 	if (!intel_iommu_superpage) {
-		domain->iommu_superpage = 0;
-		return;
+		return 0;
 	}
 
 	/* set iommu_superpage to the smallest common denominator */
 	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
-		mask &= cap_super_page_val(iommu->cap);
-		if (!mask) {
-			break;
+		if (iommu != skip) {
+			mask &= cap_super_page_val(iommu->cap);
+			if (!mask)
+				break;
 		}
 	}
 	rcu_read_unlock();
 
-	domain->iommu_superpage = fls(mask);
+	return fls(mask);
 }
 
 /* Some capabilities may be different across iommus */
 static void domain_update_iommu_cap(struct dmar_domain *domain)
 {
 	domain_update_iommu_coherency(domain);
-	domain_update_iommu_snooping(domain);
-	domain_update_iommu_superpage(domain);
+	domain->iommu_snooping = domain_update_iommu_snooping(NULL);
+	domain->iommu_superpage = domain_update_iommu_superpage(NULL);
 }
 
 static struct intel_iommu *device_to_iommu(struct device *dev, u8 *bus, u8 *devfn)
-- 
1.7.10.4

