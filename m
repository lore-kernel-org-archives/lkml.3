Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbaLKTs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:48:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:59686 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787AbaLKTsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:48:25 -0500
Message-Id: <20141211193112.630941351@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 11 Dec 2014 19:48:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>
Subject: [patch 2/4] x86: pci: acpi: Respect ioresource flags
References: <20141211191853.613107396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-pci-respect-ioresource-flags.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_res() blindly clear all resource->flags except IO and MEM. So if
a resource is marked disabled by the acpi code, setup_res() will use
it nevertheless.

Preserve the flags and add proper checks to setup_res() and
__release_pci_root_info(). The latter is simplified while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/acpi.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

Index: tip/arch/x86/pci/acpi.c
===================================================================
--- tip.orig/arch/x86/pci/acpi.c
+++ tip/arch/x86/pci/acpi.c
@@ -218,6 +218,12 @@ static void teardown_mcfg_map(struct pci
 }
 #endif
 
+static bool is_valid_resource(struct resource *res)
+{
+	return (res->flags & (IORESOURCE_MEM | IORESOURCE_IO)) &&
+		!(res->flags & IORESOURCE_DISABLED);
+}
+
 static acpi_status count_resource(struct acpi_resource *acpi_res, void *data)
 {
 	struct pci_root_info *info = data;
@@ -228,7 +234,7 @@ static acpi_status count_resource(struct
 	    !acpi_dev_resource_address_space(acpi_res, &r))
 		return AE_OK;
 
-	if ((r.flags & (IORESOURCE_IO | IORESOURCE_MEM)) && resource_size(&r))
+	if (is_valid_resource(&r))
 		info->res_num++;
 
 	return AE_OK;
@@ -242,13 +248,10 @@ static acpi_status setup_resource(struct
 	u64 orig_end;
 
 	memset(&r, 0, sizeof(r));
-	if (acpi_dev_resource_memory(acpi_res, &r)) {
-		r.flags &= IORESOURCE_MEM;
-	} else if (acpi_dev_resource_address_space(acpi_res, &r)) {
+	if (!acpi_dev_resource_memory(acpi_res, &r)) {
 		struct acpi_resource_address64 addr;
 
-		r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
-		if (r.flags == 0)
+		if (!acpi_dev_resource_address_space(acpi_res, &r))
 			return AE_OK;
 
 		if (ACPI_FAILURE(acpi_resource_to_address64(acpi_res, &addr)))
@@ -264,10 +267,11 @@ static acpi_status setup_resource(struct
 		translation_offset = addr.translation_offset;
 		r.start += translation_offset;
 		r.end += translation_offset;
-	} else {
-		return AE_OK;
 	}
 
+	if (!is_valid_resource(&r))
+		return AE_OK;
+
 	/* Exclude non-addressable range or non-addressable portion of range */
 	orig_end = r.end;
 	r.end = min(r.end, iomem_resource.end);
@@ -367,19 +371,12 @@ static void free_pci_root_info_res(struc
 
 static void __release_pci_root_info(struct pci_root_info *info)
 {
+	struct resource *res = info->res;
 	int i;
-	struct resource *res;
-
-	for (i = 0; i < info->res_num; i++) {
-		res = &info->res[i];
-
-		if (!res->parent)
-			continue;
-
-		if (!(res->flags & (IORESOURCE_MEM | IORESOURCE_IO)))
-			continue;
 
-		release_resource(res);
+	for (i = 0; i < info->res_num; i++, res++) {
+		if (res->parent && is_valid_resource(res))
+			release_resource(res);
 	}
 
 	free_pci_root_info_res(info);


