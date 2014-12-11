Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbaLKTst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:48:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:59695 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750AbaLKTs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:48:27 -0500
Message-Id: <20141211193112.725667793@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 11 Dec 2014 19:48:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>
Subject: [patch 3/4] x86: pci: acpi: Fix the range check for IO resources
References: <20141211191853.613107396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-pci-check-proper-range.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The range check in setup_res() checks the IO range against
iomem_resource. That's just wrong.

Move the check into a separate function and use ioport_resource for IO
ranges.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/acpi.c |   51 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 18 deletions(-)

Index: tip/arch/x86/pci/acpi.c
===================================================================
--- tip.orig/arch/x86/pci/acpi.c
+++ tip/arch/x86/pci/acpi.c
@@ -240,12 +240,41 @@ static acpi_status count_resource(struct
 	return AE_OK;
 }
 
+static bool valid_resource_range(struct resource *r, struct device *dev)
+{
+	struct resource *ior;
+	u64 end;
+
+	ior = (r->flags & IORESOURCE_IO) ? &ioport_resource : &iomem_resource;
+
+	/*
+	 * Exclude non-addressable range or non-addressable portion of
+	 * range. We only check end because ior->start is always 0.
+	 */
+	end = r->end;
+	r->end = min(r->end, ior->end);
+	if (r->end <= r->start) {
+		dev_info(dev, "host bridge %s window [%#llx-%#llx] invalid range\n",
+			 r->flags & IORESOURCE_IO ? "io" : "mem",
+			 (unsigned long long)r->start, end);
+		return false;
+	}
+
+	if (r->end == end)
+		return true;
+
+	dev_info(dev, "host bridge %s window [%#llx-%#llx] truncated to [%#llx-%#llx]\n",
+		 r->flags & IORESOURCE_IO ? "io" : "mem",
+		 (unsigned long long)r->start, end,
+		 (unsigned long long)r->start, (unsigned long long)r->end);
+	return true;
+}
+
 static acpi_status setup_resource(struct acpi_resource *acpi_res, void *data)
 {
 	struct pci_root_info *info = data;
 	u64 translation_offset = 0;
 	struct resource r;
-	u64 orig_end;
 
 	memset(&r, 0, sizeof(r));
 	if (!acpi_dev_resource_memory(acpi_res, &r)) {
@@ -269,31 +298,17 @@ static acpi_status setup_resource(struct
 		r.end += translation_offset;
 	}
 
-	if (!is_valid_resource(&r))
+	if (!is_valid_resource(&r) ||
+	    !valid_resource_range(&r, &info->bridge->dev))
 		return AE_OK;
 
-	/* Exclude non-addressable range or non-addressable portion of range */
-	orig_end = r.end;
-	r.end = min(r.end, iomem_resource.end);
-	if (r.end <= r.start) {
-		dev_info(&info->bridge->dev,
-			"host bridge window [%#llx-%#llx] (ignored, not CPU addressable)\n",
-			 (unsigned long long)r.start, orig_end);
-		return AE_OK;
-	} else if (orig_end != r.end) {
-		dev_info(&info->bridge->dev,
-			"host bridge window [%#llx-%#llx] ([%#llx-%#llx] ignored, not CPU addressable)\n",
-			 (unsigned long long)r.start, orig_end,
-			 (unsigned long long)r.end + 1, orig_end);
-	}
-
 	r.name = info->name;
 	info->res[info->res_num] = r;
 	info->res_offset[info->res_num] = translation_offset;
 	info->res_num++;
 	if (!pci_use_crs)
 		dev_printk(KERN_DEBUG, &info->bridge->dev,
-			"host bridge window %pR (ignored)\n", &r);
+			"host bridge window %pR ignored\n", &r);
 
 	return AE_OK;
 }


