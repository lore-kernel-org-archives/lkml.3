Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaKIOqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 09:46:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:9864 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaKIOo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 09:44:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="485940434"
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
Subject: [Patch Part3 V7 4/8] iommu/vt-d: Search for ACPI _DSM method for DMAR hotplug
Date: Sun,  9 Nov 2014 22:47:59 +0800
Message-Id: <1415544483-27990-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com>
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
 drivers/iommu/dmar.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 0bd536d769a9..9847613085e1 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1942,21 +1942,48 @@ static int dmar_hotplug_remove(acpi_handle handle)
 	return ret;
 }
 
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
 static int dmar_device_hotplug(acpi_handle handle, bool insert)
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

