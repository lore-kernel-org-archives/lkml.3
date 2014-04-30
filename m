Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaD3CEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:04:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:12329 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaD3CE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:04:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="523496432"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 08/27] ACPICA: Update handling of PCI ID lists.
Date: Wed, 30 Apr 2014 10:04:20 +0800
Message-Id: <d6a663f690cde8e3a40ca0262cdd43b344df48c7.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

More of a style cleanup. if hw_build_pci_list is to return a non-zero
status, it now deletes any partial ID list that has been constructed.
if it returns AE_OK, the caller is responsible for list deletion.
David Box.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/hwpci.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/hwpci.c b/drivers/acpi/acpica/hwpci.c
index e701d8c..6aade8e 100644
--- a/drivers/acpi/acpica/hwpci.c
+++ b/drivers/acpi/acpica/hwpci.c
@@ -140,11 +140,12 @@ acpi_hw_derive_pci_id(struct acpi_pci_id *pci_id,
 		/* Walk the list, updating the PCI device/function/bus numbers */
 
 		status = acpi_hw_process_pci_list(pci_id, list_head);
-	}
 
-	/* Always delete the list */
+		/* Delete the list */
+
+		acpi_hw_delete_pci_list(list_head);
+	}
 
-	acpi_hw_delete_pci_list(list_head);
 	return_ACPI_STATUS(status);
 }
 
@@ -187,6 +188,10 @@ acpi_hw_build_pci_list(acpi_handle root_pci_device,
 	while (1) {
 		status = acpi_get_parent(current_device, &parent_device);
 		if (ACPI_FAILURE(status)) {
+
+			/* Must delete the list before exit */
+
+			acpi_hw_delete_pci_list(*return_list_head);
 			return (status);
 		}
 
@@ -199,6 +204,10 @@ acpi_hw_build_pci_list(acpi_handle root_pci_device,
 
 		list_element = ACPI_ALLOCATE(sizeof(struct acpi_pci_device));
 		if (!list_element) {
+
+			/* Must delete the list before exit */
+
+			acpi_hw_delete_pci_list(*return_list_head);
 			return (AE_NO_MEMORY);
 		}
 
-- 
1.7.10

