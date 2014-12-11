Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbaLKTsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:48:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:59704 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787AbaLKTs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:48:28 -0500
Message-Id: <20141211193112.813391696@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 11 Dec 2014 19:48:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>
Subject: [patch 4/4] acpi: ioapic: Respect the resource flags
References: <20141211191853.613107396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=acpi-ioapoc-respect-resource-flags.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi parser can set the DISABLED flag on a resource. In
setup_res() we clear all flags except MEM, so we ignore the DISABLED
flag. Add proper checks and preserve the flags.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/acpi/ioapic.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

Index: tip/drivers/acpi/ioapic.c
===================================================================
--- tip.orig/drivers/acpi/ioapic.c
+++ tip/drivers/acpi/ioapic.c
@@ -40,29 +40,33 @@ struct acpi_pci_ioapic {
 static LIST_HEAD(ioapic_list);
 static DEFINE_MUTEX(ioapic_list_lock);
 
+static inline bool is_valid_mem_resource(struct resource *res)
+{
+	return !(res->flags & IORESOURCE_DISABLED) &&
+		(res->flags & IORESOURCE_MEM);
+}
+
 static acpi_status setup_res(struct acpi_resource *acpi_res, void *data)
 {
+	struct acpi_resource_address64 addr;
 	struct resource *res = data;
 
 	memset(res, 0, sizeof(*res));
-	if (acpi_dev_resource_memory(acpi_res, res)) {
-		res->flags &= IORESOURCE_MEM;
-		if (res->flags)
-			return AE_OK;
-	} else if (acpi_dev_resource_address_space(acpi_res, res)) {
-		struct acpi_resource_address64 addr;
+	if (acpi_dev_resource_memory(acpi_res, res))
+		return AE_OK;
 
-		res->flags &= IORESOURCE_MEM;
-		if (res->flags &&
-		    ACPI_SUCCESS(acpi_resource_to_address64(acpi_res, &addr)) &&
-		    addr.info.mem.caching != ACPI_PREFETCHABLE_MEMORY) {
-			res->start += addr.translation_offset;
-			res->end += addr.translation_offset;
-			return AE_OK;
-		}
+	if (!acpi_dev_resource_address_space(acpi_res, res) ||
+	    !is_valid_mem_resource(res))
+		return AE_OK;
+	/*
+	 * FIXME: This lacks a proper comment, why the resource
+	 * address needs to be translated.
+	 */
+	if (ACPI_SUCCESS(acpi_resource_to_address64(acpi_res, &addr)) &&
+	    addr.info.mem.caching != ACPI_PREFETCHABLE_MEMORY) {
+		res->start += addr.translation_offset;
+		res->end += addr.translation_offset;
 	}
-	res->flags = 0;
-
 	return AE_OK;
 }
 
@@ -150,7 +154,7 @@ static acpi_status handle_ioapic_add(acp
 
 		res = &ioapic->res;
 		acpi_walk_resources(handle, METHOD_NAME__CRS, setup_res, res);
-		if (res->flags == IORESOURCE_UNSET) {
+		if (!is_valid_mem_resource(res)) {
 			acpi_handle_warn(handle, "failed to get resource\n");
 			goto exit_free;
 		} else if (request_resource(&iomem_resource, res)) {


