Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaG3EVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:21:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:53280 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaG3EVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:21:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="551067954"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH 06/17] ACPICA: Tables: Update for DMAR table changes.
Date: Wed, 30 Jul 2014 12:21:00 +0800
Message-Id: <a37d8e26b75746ac60fd528944855752968143d2.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Update table compiler and disassembler for new DMAR fields introduced
in Sept. 2013.
Note that Linux DMAR users need to be updated after applying this change.

[zetalog: changing drivers/iommu/dmar.c accordingly]

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/iommu/dmar.c  |   28 ++++++++++++++--------------
 include/acpi/actbl2.h |   14 +++++++-------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 9a4f05e..bbe33a8 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -84,7 +84,7 @@ void *dmar_alloc_dev_scope(void *start, void *end, int *cnt)
 	*cnt = 0;
 	while (start < end) {
 		scope = start;
-		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ACPI ||
+		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_NAMESPACE ||
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
 			(*cnt)++;
@@ -380,7 +380,7 @@ static int __init dmar_parse_one_andd(struct acpi_dmar_header *header)
 	struct acpi_dmar_andd *andd = (void *)header;
 
 	/* Check for NUL termination within the designated length */
-	if (strnlen(andd->object_name, header->length - 8) == header->length - 8) {
+	if (strnlen(andd->device_name, header->length - 8) == header->length - 8) {
 		WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
 			   "Your BIOS is broken; ANDD object name is not NUL-terminated\n"
 			   "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
@@ -390,7 +390,7 @@ static int __init dmar_parse_one_andd(struct acpi_dmar_header *header)
 		return -EINVAL;
 	}
 	pr_info("ANDD device: %x name: %s\n", andd->device_number,
-		andd->object_name);
+		andd->device_name);
 
 	return 0;
 }
@@ -448,17 +448,17 @@ dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 			(unsigned long long)rmrr->base_address,
 			(unsigned long long)rmrr->end_address);
 		break;
-	case ACPI_DMAR_TYPE_ATSR:
+	case ACPI_DMAR_TYPE_ROOT_ATS:
 		atsr = container_of(header, struct acpi_dmar_atsr, header);
 		pr_info("ATSR flags: %#x\n", atsr->flags);
 		break;
-	case ACPI_DMAR_HARDWARE_AFFINITY:
+	case ACPI_DMAR_TYPE_HARDWARE_AFFINITY:
 		rhsa = container_of(header, struct acpi_dmar_rhsa, header);
 		pr_info("RHSA base: %#016Lx proximity domain: %#x\n",
 		       (unsigned long long)rhsa->base_address,
 		       rhsa->proximity_domain);
 		break;
-	case ACPI_DMAR_TYPE_ANDD:
+	case ACPI_DMAR_TYPE_NAMESPACE:
 		/* We don't print this here because we need to sanity-check
 		   it first. So print it in dmar_parse_one_andd() instead. */
 		break;
@@ -539,15 +539,15 @@ parse_dmar_table(void)
 		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
 			ret = dmar_parse_one_rmrr(entry_header);
 			break;
-		case ACPI_DMAR_TYPE_ATSR:
+		case ACPI_DMAR_TYPE_ROOT_ATS:
 			ret = dmar_parse_one_atsr(entry_header);
 			break;
-		case ACPI_DMAR_HARDWARE_AFFINITY:
+		case ACPI_DMAR_TYPE_HARDWARE_AFFINITY:
 #ifdef CONFIG_ACPI_NUMA
 			ret = dmar_parse_one_rhsa(entry_header);
 #endif
 			break;
-		case ACPI_DMAR_TYPE_ANDD:
+		case ACPI_DMAR_TYPE_NAMESPACE:
 			ret = dmar_parse_one_andd(entry_header);
 			break;
 		default:
@@ -631,7 +631,7 @@ static void __init dmar_acpi_insert_dev_scope(u8 device_number,
 		for (scope = (void *)(drhd + 1);
 		     (unsigned long)scope < ((unsigned long)drhd) + drhd->header.length;
 		     scope = ((void *)scope) + scope->length) {
-			if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_ACPI)
+			if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_NAMESPACE)
 				continue;
 			if (scope->enumeration_id != device_number)
 				continue;
@@ -666,21 +666,21 @@ static int __init dmar_acpi_dev_scope_init(void)
 	for (andd = (void *)dmar_tbl + sizeof(struct acpi_table_dmar);
 	     ((unsigned long)andd) < ((unsigned long)dmar_tbl) + dmar_tbl->length;
 	     andd = ((void *)andd) + andd->header.length) {
-		if (andd->header.type == ACPI_DMAR_TYPE_ANDD) {
+		if (andd->header.type == ACPI_DMAR_TYPE_NAMESPACE) {
 			acpi_handle h;
 			struct acpi_device *adev;
 
 			if (!ACPI_SUCCESS(acpi_get_handle(ACPI_ROOT_OBJECT,
-							  andd->object_name,
+							  andd->device_name,
 							  &h))) {
 				pr_err("Failed to find handle for ACPI object %s\n",
-				       andd->object_name);
+				       andd->device_name);
 				continue;
 			}
 			acpi_bus_get_device(h, &adev);
 			if (!adev) {
 				pr_err("Failed to get device for ACPI object %s\n",
-				       andd->object_name);
+				       andd->device_name);
 				continue;
 			}
 			dmar_acpi_insert_dev_scope(andd->device_number, adev);
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 21314d3..ecff624 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -396,7 +396,7 @@ struct acpi_table_dbgp {
  *        Version 1
  *
  * Conforms to "Intel Virtualization Technology for Directed I/O",
- * Version 1.2, Sept. 2008
+ * Version 2.2, Sept. 2013
  *
  ******************************************************************************/
 
@@ -423,9 +423,9 @@ struct acpi_dmar_header {
 enum acpi_dmar_type {
 	ACPI_DMAR_TYPE_HARDWARE_UNIT = 0,
 	ACPI_DMAR_TYPE_RESERVED_MEMORY = 1,
-	ACPI_DMAR_TYPE_ATSR = 2,
-	ACPI_DMAR_HARDWARE_AFFINITY = 3,
-	ACPI_DMAR_TYPE_ANDD = 4,
+	ACPI_DMAR_TYPE_ROOT_ATS = 2,
+	ACPI_DMAR_TYPE_HARDWARE_AFFINITY = 3,
+	ACPI_DMAR_TYPE_NAMESPACE = 4,
 	ACPI_DMAR_TYPE_RESERVED = 5	/* 5 and greater are reserved */
 };
 
@@ -439,7 +439,7 @@ struct acpi_dmar_device_scope {
 	u8 bus;
 };
 
-/* Values for entry_type in struct acpi_dmar_device_scope */
+/* Values for entry_type in struct acpi_dmar_device_scope - device types */
 
 enum acpi_dmar_scope_type {
 	ACPI_DMAR_SCOPE_TYPE_NOT_USED = 0,
@@ -447,7 +447,7 @@ enum acpi_dmar_scope_type {
 	ACPI_DMAR_SCOPE_TYPE_BRIDGE = 2,
 	ACPI_DMAR_SCOPE_TYPE_IOAPIC = 3,
 	ACPI_DMAR_SCOPE_TYPE_HPET = 4,
-	ACPI_DMAR_SCOPE_TYPE_ACPI = 5,
+	ACPI_DMAR_SCOPE_TYPE_NAMESPACE = 5,
 	ACPI_DMAR_SCOPE_TYPE_RESERVED = 6	/* 6 and greater are reserved */
 };
 
@@ -516,7 +516,7 @@ struct acpi_dmar_andd {
 	struct acpi_dmar_header header;
 	u8 reserved[3];
 	u8 device_number;
-	char object_name[1];
+	char device_name[1];
 };
 
 /*******************************************************************************
-- 
1.7.10

