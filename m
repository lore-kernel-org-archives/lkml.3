Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbaLOVls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:41:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:23357 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaLOVlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:41:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="499146084"
From: "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <5ab8b2e0b3e41b1bb4bdee09289200e12a0dfbe4.1418248436.git.tony.luck@intel.com>
Date: Wed, 10 Dec 2014 13:53:26 -0800
Subject: [PATCHv3] ACPI, EINJ: Enhance error injection tolerance level
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>, <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
        <linux-acpi@vger.kernel.org>
Message-Id: <075830@agluck-desk.sc.intel.com>
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

v3: Same as v2, except dropped the
  +#ifdef CONFIG_PCI_MMCONFIG
  +#include <asm/pci_x86.h>
  +#endif
hunk from apei-base.c as it is not needed

 arch/x86/pci/mmconfig-shared.c | 28 ++++++++++++++++++++++++++++
 drivers/acpi/apei/apei-base.c  | 32 ++++++++++++++++++++++++++------
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 326198a4434e..676e5e04e4d4 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -610,6 +610,32 @@ static int __init pci_parse_mcfg(struct acpi_table_header *header)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI_APEI
+extern int (*arch_apei_filter_addr)(int (*func)(__u64 start, __u64 size,
+				     void *data), void *data);
+
+static int pci_mmcfg_for_each_region(int (*func)(__u64 start, __u64 size,
+				     void *data), void *data)
+{
+	struct pci_mmcfg_region *cfg;
+	int rc;
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
+#define set_apei_filter() (arch_apei_filter_addr = pci_mmcfg_for_each_region)
+#else
+#define set_apei_filter()
+#endif
+
 static void __init __pci_mmcfg_init(int early)
 {
 	pci_mmcfg_reject_broken(early);
@@ -644,6 +670,8 @@ void __init pci_mmcfg_early_init(void)
 		else
 			acpi_sfi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
 		__pci_mmcfg_init(1);
+
+		set_apei_filter();
 	}
 }
 
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 2cd7bdd6c8b3..a85ac07f3da3 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -449,7 +449,7 @@ int apei_resources_sub(struct apei_resources *resources1,
 }
 EXPORT_SYMBOL_GPL(apei_resources_sub);
 
-static int apei_get_nvs_callback(__u64 start, __u64 size, void *data)
+static int apei_get_res_callback(__u64 start, __u64 size, void *data)
 {
 	struct apei_resources *resources = data;
 	return apei_res_add(&resources->iomem, start, size);
@@ -457,7 +457,15 @@ static int apei_get_nvs_callback(__u64 start, __u64 size, void *data)
 
 static int apei_get_nvs_resources(struct apei_resources *resources)
 {
-	return acpi_nvs_for_each_region(apei_get_nvs_callback, resources);
+	return acpi_nvs_for_each_region(apei_get_res_callback, resources);
+}
+
+int (*arch_apei_filter_addr)(int (*func)(__u64 start, __u64 size,
+				     void *data), void *data);
+static int apei_get_arch_resources(struct apei_resources *resources)
+
+{
+	return arch_apei_filter_addr(apei_get_res_callback, resources);
 }
 
 /*
@@ -470,7 +478,7 @@ int apei_resources_request(struct apei_resources *resources,
 {
 	struct apei_res *res, *res_bak = NULL;
 	struct resource *r;
-	struct apei_resources nvs_resources;
+	struct apei_resources nvs_resources, arch_res;
 	int rc;
 
 	rc = apei_resources_sub(resources, &apei_resources_all);
@@ -485,10 +493,20 @@ int apei_resources_request(struct apei_resources *resources,
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
+	if (arch_apei_filter_addr) {
+		apei_resources_init(&arch_res);
+		rc = apei_get_arch_resources(&arch_res);
+		if (rc)
+			goto arch_res_fini;
+		rc = apei_resources_sub(resources, &arch_res);
+		if (rc)
+			goto arch_res_fini;
+	}
 
 	rc = -EINVAL;
 	list_for_each_entry(res, &resources->iomem, list) {
@@ -536,7 +554,9 @@ err_unmap_iomem:
 			break;
 		release_mem_region(res->start, res->end - res->start);
 	}
-res_fini:
+arch_res_fini:
+	apei_resources_fini(&arch_res);
+nvs_res_fini:
 	apei_resources_fini(&nvs_resources);
 	return rc;
 }
-- 
2.1.0

