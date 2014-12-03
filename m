Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaLCVv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:51:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:50960 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaLCVv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:51:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,510,1413270000"; 
   d="scan'208";a="632250974"
Message-Id: <c5f50564109273ab7f1c5fab4490169ae573128d.1417641347.git.tony.luck@intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH] ACPI, EINJ: Enhance error injection tolerance level
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
        linux-acpi@vger.kernel.org
Date: Wed, 03 Dec 2014 13:22:39 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chen, Gong" <gong.chen@linux.intel.com>

Some BIOSes utilize PCI MMCFG space read/write opertion to trigger
specific errors. EINJ will report errors as below when hitting such
cases:

APEI: Can not request [mem 0x83f990a0-0x83f990a3] for APEI EINJ Trigger registers

It is because on x86 platform ACPI based PCI MMCFG logic has
reserved all MMCFG spaces so that EINJ can't reserve it again.
We already trust the ACPI/APEI code when using the EINJ interface
so it is not a big leap to also trust it to access the right
MMCFG addresses. Skip address checking to allow the access.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/apei/apei-base.c | 58 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 2cd7bdd6c8b3..e809d3c4904d 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -41,6 +41,9 @@
 #include <linux/interrupt.h>
 #include <linux/debugfs.h>
 #include <asm/unaligned.h>
+#ifdef CONFIG_PCI_MMCONFIG
+#include <asm/pci_x86.h>
+#endif
 
 #include "apei-internal.h"
 
@@ -449,7 +452,7 @@ int apei_resources_sub(struct apei_resources *resources1,
 }
 EXPORT_SYMBOL_GPL(apei_resources_sub);
 
-static int apei_get_nvs_callback(__u64 start, __u64 size, void *data)
+static int apei_get_res_callback(__u64 start, __u64 size, void *data)
 {
 	struct apei_resources *resources = data;
 	return apei_res_add(&resources->iomem, start, size);
@@ -457,9 +460,42 @@ static int apei_get_nvs_callback(__u64 start, __u64 size, void *data)
 
 static int apei_get_nvs_resources(struct apei_resources *resources)
 {
-	return acpi_nvs_for_each_region(apei_get_nvs_callback, resources);
+	return acpi_nvs_for_each_region(apei_get_res_callback, resources);
 }
 
+#ifdef CONFIG_PCI_MMCONFIG
+static int pci_mmcfg_for_each_region(int (*func)(__u64 start, __u64 size,
+				     void *data), void *data)
+{
+	struct pci_mmcfg_region *cfg;
+	int rc;
+
+	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
+		return 0;
+
+	if (list_empty(&pci_mmcfg_list))
+		return 0;
+
+	list_for_each_entry(cfg, &pci_mmcfg_list, list) {
+		rc = func(cfg->res.start, resource_size(&cfg->res), data);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int apei_get_mmcfg_resources(struct apei_resources *resources)
+{
+	return pci_mmcfg_for_each_region(apei_get_res_callback, resources);
+}
+#else
+static int apei_get_mmcfg_resources(struct apei_resources *resources)
+{
+	return 0;
+}
+#endif
+
 /*
  * IO memory/port resource management mechanism is used to check
  * whether memory/port area used by GARs conflicts with normal memory
@@ -470,7 +506,7 @@ int apei_resources_request(struct apei_resources *resources,
 {
 	struct apei_res *res, *res_bak = NULL;
 	struct resource *r;
-	struct apei_resources nvs_resources;
+	struct apei_resources nvs_resources, mmcfg_res;
 	int rc;
 
 	rc = apei_resources_sub(resources, &apei_resources_all);
@@ -485,10 +521,18 @@ int apei_resources_request(struct apei_resources *resources,
 	apei_resources_init(&nvs_resources);
 	rc = apei_get_nvs_resources(&nvs_resources);
 	if (rc)
-		goto res_fini;
+		goto nvs_res_fini;
 	rc = apei_resources_sub(resources, &nvs_resources);
 	if (rc)
-		goto res_fini;
+		goto nvs_res_fini;
+
+	apei_resources_init(&mmcfg_res);
+	rc = apei_get_mmcfg_resources(&mmcfg_res);
+	if (rc)
+		goto mmcfg_res_fini;
+	rc = apei_resources_sub(resources, &mmcfg_res);
+	if (rc)
+		goto mmcfg_res_fini;
 
 	rc = -EINVAL;
 	list_for_each_entry(res, &resources->iomem, list) {
@@ -536,7 +580,9 @@ err_unmap_iomem:
 			break;
 		release_mem_region(res->start, res->end - res->start);
 	}
-res_fini:
+mmcfg_res_fini:
+	apei_resources_fini(&mmcfg_res);
+nvs_res_fini:
 	apei_resources_fini(&nvs_resources);
 	return rc;
 }
-- 
2.1.0

