Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaIKINA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:13:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:35740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaIKIDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:03:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="601322227"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch v5 01/15] x86, PCI, ACPI: Kill private function resource_to_addr() in arch/x86/pci/acpi.c
Date: Thu, 11 Sep 2014 16:05:44 +0800
Message-Id: <1410422758-24942-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Private function resource_to_addr() is used to parse ACPI resources
for PCI host bridge. There are public interfaces available for that
purpose, so replace resource_to_addr() with public interfaces.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/pci/acpi.c |  142 ++++++++++++++++++---------------------------------
 1 file changed, 51 insertions(+), 91 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index cfd1b132b8e3..0e716fa56ae5 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -218,114 +218,74 @@ static void teardown_mcfg_map(struct pci_root_info *info)
 }
 #endif
 
-static acpi_status resource_to_addr(struct acpi_resource *resource,
-				    struct acpi_resource_address64 *addr)
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
 static acpi_status count_resource(struct acpi_resource *acpi_res, void *data)
 {
 	struct pci_root_info *info = data;
-	struct acpi_resource_address64 addr;
-	acpi_status status;
+	struct resource r = {
+		.flags = 0
+	};
 
-	status = resource_to_addr(acpi_res, &addr);
-	if (ACPI_SUCCESS(status))
+	if (!acpi_dev_resource_memory(acpi_res, &r) &&
+	    !acpi_dev_resource_address_space(acpi_res, &r))
+		return AE_OK;
+
+	if ((r.flags & (IORESOURCE_IO | IORESOURCE_MEM)) && resource_size(&r))
 		info->res_num++;
+
 	return AE_OK;
 }
 
 static acpi_status setup_resource(struct acpi_resource *acpi_res, void *data)
 {
 	struct pci_root_info *info = data;
-	struct resource *res;
-	struct acpi_resource_address64 addr;
-	acpi_status status;
-	unsigned long flags;
-	u64 start, orig_end, end;
+	struct resource *res = &info->res[info->res_num];
+	u64 translation_offset = 0;
+
+	memset(res, 0, sizeof(*res));
+	if (acpi_dev_resource_memory(acpi_res, res)) {
+		res->flags &= IORESOURCE_MEM | IORESOURCE_IO;
+	} else if (acpi_dev_resource_address_space(acpi_res, res)) {
+		u64 orig_end;
+		struct acpi_resource_address64 addr;
+
+		res->flags &= IORESOURCE_MEM | IORESOURCE_IO;
+		if (res->flags == 0)
+			return AE_OK;
 
-	status = resource_to_addr(acpi_res, &addr);
-	if (!ACPI_SUCCESS(status))
-		return AE_OK;
+		if (ACPI_FAILURE(acpi_resource_to_address64(acpi_res, &addr)))
+			return AE_OK;
 
-	if (addr.resource_type == ACPI_MEMORY_RANGE) {
-		flags = IORESOURCE_MEM;
-		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
-			flags |= IORESOURCE_PREFETCH;
-	} else if (addr.resource_type == ACPI_IO_RANGE) {
-		flags = IORESOURCE_IO;
-	} else
-		return AE_OK;
+		if (addr.resource_type == ACPI_MEMORY_RANGE &&
+		    addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
+			res->flags |= IORESOURCE_PREFETCH;
 
-	start = addr.minimum + addr.translation_offset;
-	orig_end = end = addr.maximum + addr.translation_offset;
+		translation_offset = addr.translation_offset;
+		orig_end = res->end;
+		res->start += translation_offset;
+		res->end += translation_offset;
 
-	/* Exclude non-addressable range or non-addressable portion of range */
-	end = min(end, (u64)iomem_resource.end);
-	if (end <= start) {
-		dev_info(&info->bridge->dev,
-			"host bridge window [%#llx-%#llx] "
-			"(ignored, not CPU addressable)\n", start, orig_end);
-		return AE_OK;
-	} else if (orig_end != end) {
-		dev_info(&info->bridge->dev,
-			"host bridge window [%#llx-%#llx] "
-			"([%#llx-%#llx] ignored, not CPU addressable)\n", 
-			start, orig_end, end + 1, orig_end);
+		/* Exclude non-addressable range or non-addressable portion of range */
+		res->end = min(res->end, (u64)iomem_resource.end);
+		if (res->end <= res->start) {
+			dev_info(&info->bridge->dev,
+				"host bridge window [%#llx-%#llx] (ignored, not CPU addressable)\n",
+				 res->start, orig_end);
+			return AE_OK;
+		} else if (orig_end != res->end) {
+			dev_info(&info->bridge->dev,
+				"host bridge window [%#llx-%#llx] ([%#llx-%#llx] ignored, not CPU addressable)\n",
+				res->start, orig_end, res->end + 1, orig_end);
+		}
 	}
 
-	res = &info->res[info->res_num];
-	res->name = info->name;
-	res->flags = flags;
-	res->start = start;
-	res->end = end;
-	info->res_offset[info->res_num] = addr.translation_offset;
-	info->res_num++;
-
-	if (!pci_use_crs)
-		dev_printk(KERN_DEBUG, &info->bridge->dev,
-			   "host bridge window %pR (ignored)\n", res);
+	if (res->flags && resource_size(res)) {
+		res->name = info->name;
+		info->res_offset[info->res_num] = translation_offset;
+		info->res_num++;
+		if (!pci_use_crs)
+			dev_printk(KERN_DEBUG, &info->bridge->dev,
+				   "host bridge window %pR (ignored)\n", res);
+	}
 
 	return AE_OK;
 }
-- 
1.7.10.4

