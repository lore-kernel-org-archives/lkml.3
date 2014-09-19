Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbaISFSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:18:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:41499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579AbaISFRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:17:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,552,1406617200"; 
   d="scan'208";a="602019882"
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
Subject: [Patch Part3 V6 4/8] iommu/vt-d: Search for ACPI _DSM method for DMAR hotplug
Date: Fri, 19 Sep 2014 13:18:51 +0800
Message-Id: <1411103935-31301-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411103935-31301-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411103935-31301-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Intel VT-d specification, _DSM method to support DMAR
hotplug should exist directly under corresponding ACPI object
representing PCI host bridge. But some BIOSes doesn't conform to
this, so search for _DSM method in the subtree starting from the
ACPI object representing the PCI host bridge.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Reviewed-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/dmar.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index ab504cf0f34a..9249836d0a6a 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1925,21 +1925,48 @@ static int dmar_hotplug_remove(acpi_handle handle)
 	return ret;
 }
 
-static int dmar_device_hotplug(acpi_handle handle, bool insert)
+static acpi_status dmar_get_dsm_handle(acpi_handle handle, u32 lvl,
+				       void *context, void **retval)
+{
+	acpi_handle *phdl = retval;
+
+	if (dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD)) {
+		*phdl = handle;
+		return AE_CTRL_TERMINATE;
+	}
+
+	return AE_OK;
+}
+
+int dmar_device_hotplug(acpi_handle handle, bool insert)
 {
 	int ret;
+	acpi_handle tmp = NULL;
+	acpi_status status;
 
 	if (!dmar_in_use())
 		return 0;
 
-	if (!dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD))
+	if (dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD)) {
+		tmp = handle;
+	} else {
+		status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
+					     ACPI_UINT32_MAX,
+					     dmar_get_dsm_handle,
+					     NULL, NULL, &tmp);
+		if (ACPI_FAILURE(status)) {
+			pr_warn("Failed to locate _DSM method.\n");
+			return -ENXIO;
+		}
+	}
+	if (tmp == NULL)
 		return 0;
 
 	down_write(&dmar_global_lock);
 	if (insert)
-		ret = dmar_hotplug_insert(handle);
+		ret = dmar_hotplug_insert(tmp);
 	else
-		ret = dmar_hotplug_remove(handle);
+		ret = dmar_hotplug_remove(tmp);
 	up_write(&dmar_global_lock);
 
 	return ret;
-- 
1.7.10.4

