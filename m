Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255AbaEFHEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:04:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:54817 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934184AbaEFHEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:04:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,995,1389772800"; 
   d="scan'208";a="526662227"
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
Subject: [Patch Part3 V2 07/21] iommu/vt-d: avoid freeing virtual machine domain in free_dmar_iommu()
Date: Tue,  6 May 2014 15:05:18 +0800
Message-Id: <1399359932-28972-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
References: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtual machine domains are created by intel_iommu_domain_init() and
should be destroyed by intel_iommu_domain_destroy(). So avoid freeing
virtual machine domain data structure in free_dmar_iommu() when
doamin->iommu_count reaches zero, otherwise it may cause invalid
memory access because the IOMMU framework still holds references
to the domain structure.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 1f10fcd1c696..5e865c1265ad 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1482,7 +1482,8 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 
 			domain = iommu->domains[i];
 			clear_bit(i, iommu->domain_ids);
-			if (domain_detach_iommu(domain, iommu) == 0)
+			if (domain_detach_iommu(domain, iommu) == 0 &&
+			    !domain_type_is_vm(domain))
 				domain_exit(domain);
 		}
 	}
-- 
1.7.10.4

