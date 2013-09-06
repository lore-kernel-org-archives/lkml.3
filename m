Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3IFO1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:27:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:34497 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab3IFO1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:27:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,854,1371106800"; 
   d="scan'208";a="392020032"
From: Lan Tianyu <tianyu.lan@intel.com>
To: tianyu.lan@intel.com, lenb@kernel.org, rjw@sisk.pl, yinghai@kernel.org,
        bhelgaas@google.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/4] X86/PCI/ACPI: Rework setup_resource() via functions ACPI resource functions
Date: Fri,  6 Sep 2013 10:24:46 -0400
Message-Id: <1378477486-8758-5-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1378477486-8758-1-git-send-email-tianyu.lan@intel.com>
References: <1378477486-8758-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using ACPI resource functions to convert ACPI resource to generic resource
instead of resource_to_addr(). Remove resource_to_addr().

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 arch/x86/pci/acpi.c | 81 ++++++++---------------------------------------------
 1 file changed, 12 insertions(+), 69 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index d641897..d4f85a1 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -219,62 +219,15 @@ static void teardown_mcfg_map(struct pci_root_info *info)
 #endif
 
 static acpi_status
-resource_to_addr(struct acpi_resource *resource,
-			struct acpi_resource_address64 *addr)
-{
-	acpi_status status;
-	struct acpi_resource_memory24 *memory24;
-	struct acpi_resource_memory32 *memory32;
-	struct acpi_resource_fixed_memory32 *fixed_memory32;
-
-	memset(addr, 0, sizeof(*addr));
-	switch (resource->type) {
-	case ACPI_RESOURCE_TYPE_MEMORY24:
-		memory24 = &resource->data.memory24;
-		addr->resource_type = ACPI_MEMORY_RANGE;
-		addr->minimum = memory24->minimum;
-		addr->address_length = memory24->address_length;
-		addr->maximum = addr->minimum + addr->address_length - 1;
-		return AE_OK;
-	case ACPI_RESOURCE_TYPE_MEMORY32:
-		memory32 = &resource->data.memory32;
-		addr->resource_type = ACPI_MEMORY_RANGE;
-		addr->minimum = memory32->minimum;
-		addr->address_length = memory32->address_length;
-		addr->maximum = addr->minimum + addr->address_length - 1;
-		return AE_OK;
-	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-		fixed_memory32 = &resource->data.fixed_memory32;
-		addr->resource_type = ACPI_MEMORY_RANGE;
-		addr->minimum = fixed_memory32->address;
-		addr->address_length = fixed_memory32->address_length;
-		addr->maximum = addr->minimum + addr->address_length - 1;
-		return AE_OK;
-	case ACPI_RESOURCE_TYPE_ADDRESS16:
-	case ACPI_RESOURCE_TYPE_ADDRESS32:
-	case ACPI_RESOURCE_TYPE_ADDRESS64:
-		status = acpi_resource_to_address64(resource, addr);
-		if (ACPI_SUCCESS(status) &&
-		    (addr->resource_type == ACPI_MEMORY_RANGE ||
-		    addr->resource_type == ACPI_IO_RANGE) &&
-		    addr->address_length > 0) {
-			return AE_OK;
-		}
-		break;
-	}
-	return AE_ERROR;
-}
-
-static acpi_status
 count_resource(struct acpi_resource *acpi_res, void *data)
 {
 	struct pci_root_info *info = data;
-	struct acpi_resource_address64 addr;
-	acpi_status status;
+	struct resource res;
 
-	status = resource_to_addr(acpi_res, &addr);
-	if (ACPI_SUCCESS(status))
+	if (acpi_dev_resource_address_space(acpi_res, &res)
+	    || acpi_dev_resource_memory(acpi_res, &res))
 		info->res_num++;
+
 	return AE_OK;
 }
 
@@ -282,27 +235,18 @@ static acpi_status
 setup_resource(struct acpi_resource *acpi_res, void *data)
 {
 	struct pci_root_info *info = data;
-	struct resource *res;
+	struct resource *res = &info->res[info->res_num];
 	struct acpi_resource_address64 addr;
-	acpi_status status;
-	unsigned long flags;
 	u64 start, orig_end, end;
 
-	status = resource_to_addr(acpi_res, &addr);
-	if (!ACPI_SUCCESS(status))
-		return AE_OK;
+	memset(&addr, 0x00, sizeof(addr));
 
-	if (addr.resource_type == ACPI_MEMORY_RANGE) {
-		flags = IORESOURCE_MEM;
-		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
-			flags |= IORESOURCE_PREFETCH;
-	} else if (addr.resource_type == ACPI_IO_RANGE) {
-		flags = IORESOURCE_IO;
-	} else
+	if (!(acpi_dev_resource_address_space_with_addr(acpi_res, &addr, res)
+	    || acpi_dev_resource_memory(acpi_res, res)))
 		return AE_OK;
 
-	start = addr.minimum + addr.translation_offset;
-	orig_end = end = addr.maximum + addr.translation_offset;
+	start = res->start;
+	orig_end = end = res->end;
 
 	/* Exclude non-addressable range or non-addressable portion of range */
 	end = min(end, (u64)iomem_resource.end);
@@ -310,6 +254,7 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 		dev_info(&info->bridge->dev,
 			"host bridge window [%#llx-%#llx] "
 			"(ignored, not CPU addressable)\n", start, orig_end);
+		memset(&info->res[info->res_num], 0x00, sizeof(*res));
 		return AE_OK;
 	} else if (orig_end != end) {
 		dev_info(&info->bridge->dev,
@@ -318,11 +263,9 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 			start, orig_end, end + 1, orig_end);
 	}
 
-	res = &info->res[info->res_num];
 	res->name = info->name;
-	res->flags = flags;
-	res->start = start;
 	res->end = end;
+
 	info->res_offset[info->res_num] = addr.translation_offset;
 	info->res_num++;
 
-- 
1.8.2.1

