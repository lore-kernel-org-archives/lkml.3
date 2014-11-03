Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaKCK7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:59:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaKCK7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:59:35 -0500
Date: Mon, 3 Nov 2014 02:57:31 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
Cc: rjw@rjwysocki.net, bp@alien8.de, rdunlap@infradead.org, mingo@kernel.org,
        jiang.liu@linux.intel.com, hpa@zytor.com, bhelgaas@google.com,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        joro@8bytes.org, tony.luck@intel.com, konrad.wilk@oracle.com
Reply-To: jiang.liu@linux.intel.com, hpa@zytor.com, bhelgaas@google.com,
        rjw@rjwysocki.net, bp@alien8.de, rdunlap@infradead.org,
        mingo@kernel.org, joro@8bytes.org, tglx@linutronix.de,
        tony.luck@intel.com, konrad.wilk@oracle.com,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, PCI, ACPI:
  Kill private function resource_to_addr() in arch/x86/pci/acpi.c
Git-Commit-ID: e22ce93870deae0e9a54e1539f0088538f187780
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e22ce93870deae0e9a54e1539f0088538f187780
Gitweb:     http://git.kernel.org/tip/e22ce93870deae0e9a54e1539f0088538f187780
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:34 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 11:56:07 +0100

x86, PCI, ACPI: Kill private function resource_to_addr() in arch/x86/pci/acpi.c

Private function resource_to_addr() is used to parse ACPI resources
for PCI host bridge. There are public interfaces available for that
purpose, so replace resource_to_addr() with public interfaces.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/acpi.c | 144 +++++++++++++++++++---------------------------------
 1 file changed, 53 insertions(+), 91 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index cfd1b13..3f72d93 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -218,114 +218,76 @@ static void teardown_mcfg_map(struct pci_root_info *info)
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
+	u64 translation_offset = 0;
+	struct resource r = {
+		.flags = 0
+	};
+
+	if (acpi_dev_resource_memory(acpi_res, &r)) {
+		r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
+	} else if (acpi_dev_resource_address_space(acpi_res, &r)) {
+		u64 orig_end;
+		struct acpi_resource_address64 addr;
+
+		r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
+		if (r.flags == 0)
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
+			r.flags |= IORESOURCE_PREFETCH;
 
-	start = addr.minimum + addr.translation_offset;
-	orig_end = end = addr.maximum + addr.translation_offset;
+		translation_offset = addr.translation_offset;
+		orig_end = r.end;
+		r.start += translation_offset;
+		r.end += translation_offset;
 
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
+		r.end = min(r.end, iomem_resource.end);
+		if (r.end <= r.start) {
+			dev_info(&info->bridge->dev,
+				"host bridge window [%#llx-%#llx] (ignored, not CPU addressable)\n",
+				 r.start, orig_end);
+			return AE_OK;
+		} else if (orig_end != r.end) {
+			dev_info(&info->bridge->dev,
+				"host bridge window [%#llx-%#llx] ([%#llx-%#llx] ignored, not CPU addressable)\n",
+				r.start, orig_end, r.end + 1, orig_end);
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
+	if (r.flags && resource_size(&r)) {
+		r.name = info->name;
+		info->res[info->res_num] = r;
+		info->res_offset[info->res_num] = translation_offset;
+		info->res_num++;
+		if (!pci_use_crs)
+			dev_printk(KERN_DEBUG, &info->bridge->dev,
+				   "host bridge window %pR (ignored)\n", &r);
+	}
 
 	return AE_OK;
 }
