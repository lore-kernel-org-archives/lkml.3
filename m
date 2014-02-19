Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaBSGNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:13:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:18482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaBSGHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:07:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="485626446"
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
Subject: [Patch Part2 V2 03/17] iommu/vt-d: avoid caching stale domain_device_info when hot-removing PCI device
Date: Wed, 19 Feb 2014 14:07:23 +0800
Message-Id: <1392790057-32434-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function device_notifier() in intel-iommu.c only remove domain_device_info
data structure associated with a PCI device when handling PCI device
driver unbinding events. If a PCI device has never been bound to a PCI
device driver, there won't be BUS_NOTIFY_UNBOUND_DRIVER event when
hot-removing the PCI device. So associated domain_device_info data
structure may get lost.

On the other hand, if iommu_pass_through is enabled, function
iommu_prepare_static_indentify_mapping() will create domain_device_info
data structure for each PCIe to PCIe bridge and PCIe endpoint,
no matter whether there are drivers associated with those PCIe devices
or not. So those domain_device_info data structures will get lost when
hot-removing the assocated PCIe devices if they have never bound to
any PCI device driver.

To be even worse, it's not only an memory leak issue, but also an
caching of stale information bug because the memory are kept in
device_domain_list and domain->devices lists.

Fix the bug by trying to remove domain_device_info data structure when
handling BUS_NOTIFY_DEL_DEVICE event.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f75d3ae..5a411e8 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3603,18 +3603,19 @@ static int device_notifier(struct notifier_block *nb,
 	if (iommu_dummy(pdev))
 		return 0;
 
+	if (action != BUS_NOTIFY_UNBOUND_DRIVER &&
+	    action != BUS_NOTIFY_DEL_DEVICE)
+		return 0;
+
 	domain = find_domain(pdev);
 	if (!domain)
 		return 0;
 
-	if (action == BUS_NOTIFY_UNBOUND_DRIVER) {
-		domain_remove_one_dev_info(domain, pdev);
-
-		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
-		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
-		    list_empty(&domain->devices))
-			domain_exit(domain);
-	}
+	domain_remove_one_dev_info(domain, pdev);
+	if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
+	    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
+	    list_empty(&domain->devices))
+		domain_exit(domain);
 
 	return 0;
 }
-- 
1.7.10.4

