Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbaLKTtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:49:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:59680 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751AbaLKTsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:48:23 -0500
Message-Id: <20141211193112.547808552@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 11 Dec 2014 19:48:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>
Subject: [patch 1/4] x86, pci, acpi: Redo sanity checks for root brigde probing
References: <20141211191853.613107396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=fix_x86_pci_acpi.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

commit e22ce93870de ("x86, PCI, ACPI: Kill private function
resource_to_addr() in arch/x86/pci/acpi.c") dropped the sanity checks
for resources initialized via acpi_dev_resource_memory().

It further dropped a check for address_length = 0 for the resources
which are initialized via acpi_dev_resource_address_space().

For translated addresses the range check operates on the non
translated end address. Assign orig_end after adding the translation
offset.

This causes that invalid resources are not dropped and the range check
for translated addresses fails.

[ tglx: Rewrote changelog.

  Added the address_length check to the x86 code and not into
  acpi_dev_resource_address_space(). While the acpi function should
  check this, we want to have a proper check which sets the
  IORESOURCE_DISABLED bit as it does for IO resources.

  Removed the pointless memset of addr. acpi_resource_to_address64()
  either fails or fills it completely ]

Fixes: commit e22ce93870de ("x86, PCI, ACPI: Kill private function resource_to_addr() in arch/x86/pci/acpi.c").
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/pci/acpi.c |   63 ++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

Index: tip/arch/x86/pci/acpi.c
===================================================================
--- tip.orig/arch/x86/pci/acpi.c
+++ tip/arch/x86/pci/acpi.c
@@ -221,10 +221,9 @@ static void teardown_mcfg_map(struct pci
 static acpi_status count_resource(struct acpi_resource *acpi_res, void *data)
 {
 	struct pci_root_info *info = data;
-	struct resource r = {
-		.flags = 0
-	};
+	struct resource r;
 
+	memset(&r, 0, sizeof(r));
 	if (!acpi_dev_resource_memory(acpi_res, &r) &&
 	    !acpi_dev_resource_address_space(acpi_res, &r))
 		return AE_OK;
@@ -239,14 +238,13 @@ static acpi_status setup_resource(struct
 {
 	struct pci_root_info *info = data;
 	u64 translation_offset = 0;
-	struct resource r = {
-		.flags = 0
-	};
+	struct resource r;
+	u64 orig_end;
 
+	memset(&r, 0, sizeof(r));
 	if (acpi_dev_resource_memory(acpi_res, &r)) {
-		r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
+		r.flags &= IORESOURCE_MEM;
 	} else if (acpi_dev_resource_address_space(acpi_res, &r)) {
-		u64 orig_end;
 		struct acpi_resource_address64 addr;
 
 		r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
@@ -256,40 +254,43 @@ static acpi_status setup_resource(struct
 		if (ACPI_FAILURE(acpi_resource_to_address64(acpi_res, &addr)))
 			return AE_OK;
 
+		if (!addr.address_length)
+			return AE_OK;
+
 		if (addr.resource_type == ACPI_MEMORY_RANGE &&
 		    addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
 			r.flags |= IORESOURCE_PREFETCH;
 
 		translation_offset = addr.translation_offset;
-		orig_end = r.end;
 		r.start += translation_offset;
 		r.end += translation_offset;
-
-		/* Exclude non-addressable range or non-addressable portion of range */
-		r.end = min(r.end, iomem_resource.end);
-		if (r.end <= r.start) {
-			dev_info(&info->bridge->dev,
-				"host bridge window [%#llx-%#llx] (ignored, not CPU addressable)\n",
-				 (unsigned long long)r.start, orig_end);
-			return AE_OK;
-		} else if (orig_end != r.end) {
-			dev_info(&info->bridge->dev,
-				"host bridge window [%#llx-%#llx] ([%#llx-%#llx] ignored, not CPU addressable)\n",
-				 (unsigned long long)r.start, orig_end,
-				 (unsigned long long)r.end + 1, orig_end);
-		}
+	} else {
+		return AE_OK;
 	}
 
-	if (r.flags && resource_size(&r)) {
-		r.name = info->name;
-		info->res[info->res_num] = r;
-		info->res_offset[info->res_num] = translation_offset;
-		info->res_num++;
-		if (!pci_use_crs)
-			dev_printk(KERN_DEBUG, &info->bridge->dev,
-				   "host bridge window %pR (ignored)\n", &r);
+	/* Exclude non-addressable range or non-addressable portion of range */
+	orig_end = r.end;
+	r.end = min(r.end, iomem_resource.end);
+	if (r.end <= r.start) {
+		dev_info(&info->bridge->dev,
+			"host bridge window [%#llx-%#llx] (ignored, not CPU addressable)\n",
+			 (unsigned long long)r.start, orig_end);
+		return AE_OK;
+	} else if (orig_end != r.end) {
+		dev_info(&info->bridge->dev,
+			"host bridge window [%#llx-%#llx] ([%#llx-%#llx] ignored, not CPU addressable)\n",
+			 (unsigned long long)r.start, orig_end,
+			 (unsigned long long)r.end + 1, orig_end);
 	}
 
+	r.name = info->name;
+	info->res[info->res_num] = r;
+	info->res_offset[info->res_num] = translation_offset;
+	info->res_num++;
+	if (!pci_use_crs)
+		dev_printk(KERN_DEBUG, &info->bridge->dev,
+			"host bridge window %pR (ignored)\n", &r);
+
 	return AE_OK;
 }
 


