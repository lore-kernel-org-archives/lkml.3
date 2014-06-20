Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934688AbaFTHGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:06:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:19824 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934353AbaFTHGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:06:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="356132788"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Patch] iommu/vt-d: fix bug in handling multiple RMRRs for the same PCI device
Date: Fri, 20 Jun 2014 15:08:06 +0800
Message-Id: <1403248086-13853-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function dmar_iommu_notify_scope_dev() makes a wrong assumption that
there's one RMRR for each PCI device at most, which causes DMA failure
on some HP platforms. So enhance dmar_iommu_notify_scope_dev() to
handle multiple RMRRs for the same PCI device.

Fixbug: https://bugzilla.novell.com/show_bug.cgi?id=879482

Cc: <stable@vger.kernel.org> # 3.15
Reported-by: Tom Mingarelli <thomas.mingarelli@hp.com>
Tested-by: Linda Knippers <linda.knippers@hp.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6bb32773c3ac..51b6b77dc3e5 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3816,14 +3816,11 @@ int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info)
 				((void *)rmrr) + rmrr->header.length,
 				rmrr->segment, rmrru->devices,
 				rmrru->devices_cnt);
-			if (ret > 0)
-				break;
-			else if(ret < 0)
+			if(ret < 0)
 				return ret;
 		} else if (info->event == BUS_NOTIFY_DEL_DEVICE) {
-			if (dmar_remove_dev_scope(info, rmrr->segment,
-				rmrru->devices, rmrru->devices_cnt))
-				break;
+			dmar_remove_dev_scope(info, rmrr->segment,
+				rmrru->devices, rmrru->devices_cnt);
 		}
 	}
 
-- 
1.7.10.4

