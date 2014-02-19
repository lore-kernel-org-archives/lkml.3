Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaBSGH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:07:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:18482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaBSGHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:07:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="485626531"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V2 07/17] iommu/vt-d: free resources if failed to create domain for PCIe endpoint
Date: Wed, 19 Feb 2014 14:07:27 +0800
Message-Id: <1392790057-32434-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance function get_domain_for_dev() to release allocated resources
if failed to create domain for PCIe endpoint, otherwise the allocated
resources will get lost.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 67b114e..503cc73 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2015,7 +2015,7 @@ static int dmar_insert_dev_info(int segment, int bus, int devfn,
 /* domain is initialized */
 static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 {
-	struct dmar_domain *domain;
+	struct dmar_domain *domain, *free = NULL;
 	struct intel_iommu *iommu;
 	struct dmar_drhd_unit *drhd;
 	struct pci_dev *dev_tmp;
@@ -2062,17 +2062,16 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		free_domain_mem(domain);
 		goto error;
 	}
-	if (domain_init(domain, gaw)) {
-		domain_exit(domain);
+	free = domain;
+	if (domain_init(domain, gaw))
 		goto error;
-	}
 
 	/* register pcie-to-pci device */
 	if (dev_tmp) {
-		if (dmar_insert_dev_info(segment, bus, devfn, NULL, &domain)) {
-			domain_exit(domain);
+		if (dmar_insert_dev_info(segment, bus, devfn, NULL, &domain))
 			goto error;
-		}
+		else
+			free = NULL;
 	}
 
 found_domain:
@@ -2080,6 +2079,8 @@ found_domain:
 				 pdev, &domain) == 0)
 		return domain;
 error:
+	if (free)
+		domain_exit(free);
 	/* recheck it here, maybe others set it */
 	return find_domain(pdev);
 }
-- 
1.7.10.4

