Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbaAGJAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:00:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:20795 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760AbaAGJA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454739863"
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
Subject: [Patch Part2 V1 05/14] iommu/vt-d: create device_domain_info structure for intermediate P2P bridges
Date: Tue,  7 Jan 2014 17:00:25 +0800
Message-Id: <1389085234-22296-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creating DMAR domain for a PCI device, we will only associate the
PCI device and upstream (PCIe) bridge with the domain and skip all
intermediate P2P bridges.

Function domain_context_mapping() will attach the created domain to the
PCI device, the upstream (PCIe) bridge and all intermediate P2P bridge.
Later when domain_remove_dev_info() is called, it only detaches the
domain from the PCI device and its upstream (PCIe) bridge and leaves
the domain still attached to all intermediate P2P bridges.

This stale state may cause troubles when we assign the affected PCI
hierarchy to a virtual machine later. So also create device_domain_info
for intermediate P2P bridges when creating domain for PCI device.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/intel-iommu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 2bbb877..d5ad21d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2018,7 +2018,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	struct dmar_domain *domain;
 	struct intel_iommu *iommu;
 	struct dmar_drhd_unit *drhd;
-	struct pci_dev *bridge;
+	struct pci_dev *bridge, *parent;
 	unsigned long flags;
 	int segment, bus, devfn;
 
@@ -2072,6 +2072,13 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 			domain_exit(domain);
 			goto error;
 		}
+		/* also register intermediate P2P bridges */
+		for (parent = pdev->bus->self; parent != bridge;
+		     parent = parent->bus->self) {
+			if (dmar_insert_dev_info(segment, parent->bus->number,
+						 parent->devfn, NULL, &domain))
+				goto error;
+		}
 	}
 
 found_domain:
-- 
1.7.10.4

