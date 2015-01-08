Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbbAHCbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:31:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:27186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbbAHCbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:31:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509087056"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [RFC Patch 13/19] ACPI: Return translation offset when parsing ACPI address space resources
Date: Thu,  8 Jan 2015 10:33:00 +0800
Message-Id: <1420684386-5975-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change function acpi_dev_resource_address_space() and
acpi_dev_resource_ext_address_space() to return address space
translation offset.

It's based on a patch from Yinghai Lu <yinghai@kernel.org>.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c        |   22 +++++++++++++++-------
 drivers/pnp/pnpacpi/rsparser.c |    4 ++--
 include/linux/acpi.h           |    6 ++++--
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index e82149e44347..d3aa56674bd4 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -184,7 +184,7 @@ bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_io);
 
-static bool acpi_decode_space(struct resource *res,
+static bool acpi_decode_space(struct resource *res, resource_size_t *offset,
 			      struct acpi_resource_address *base,
 			      struct acpi_resource_address64_common *addr)
 {
@@ -217,6 +217,9 @@ static bool acpi_decode_space(struct resource *res,
 		return false;
 	}
 
+	if (offset)
+		*offset = addr->translation_offset;
+
 	if (base->producer_consumer == ACPI_PRODUCER)
 		res->flags |= IORESOURCE_WINDOW;
 
@@ -230,6 +233,7 @@ static bool acpi_decode_space(struct resource *res,
  * acpi_dev_resource_address_space - Extract ACPI address space information.
  * @ares: Input ACPI resource object.
  * @res: Output generic resource object.
+ * @offset: Output translation offset
  *
  * Check if the given ACPI resource object represents an address space resource
  * and if that's the case, use the information in it to populate the generic
@@ -241,7 +245,8 @@ static bool acpi_decode_space(struct resource *res,
  * 3) true: valid assigned resource
  */
 bool acpi_dev_resource_address_space(struct acpi_resource *ares,
-				     struct resource *res)
+				     struct resource *res,
+				     resource_size_t *offset)
 {
 	struct acpi_resource_address64 addr;
 
@@ -249,7 +254,8 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 	if (ACPI_FAILURE(acpi_resource_to_address64(ares, &addr)))
 		return false;
 
-	return acpi_decode_space(res, &addr.common.base, &addr.common.addr);
+	return acpi_decode_space(res, offset,
+				 &addr.common.base, &addr.common.addr);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
 
@@ -257,6 +263,7 @@ EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
  * acpi_dev_resource_ext_address_space - Extract ACPI address space information.
  * @ares: Input ACPI resource object.
  * @res: Output generic resource object.
+ * @offset: Output translation offset
  *
  * Check if the given ACPI resource object represents an extended address space
  * resource and if that's the case, use the information in it to populate the
@@ -268,7 +275,8 @@ EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
  * 3) true: valid assigned resource
  */
 bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
-					 struct resource *res)
+					 struct resource *res,
+					 resource_size_t *offset)
 {
 	struct acpi_resource_extended_address64 *ext_addr;
 
@@ -278,7 +286,7 @@ bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
 
 	ext_addr = &ares->data.ext_address64;
 
-	return acpi_decode_space(res, &ext_addr->common.base,
+	return acpi_decode_space(res, offset, &ext_addr->common.base,
 				 &ext_addr->common.addr);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_ext_address_space);
@@ -478,8 +486,8 @@ static acpi_status acpi_dev_process_resource(struct acpi_resource *ares,
 
 	if (acpi_dev_resource_memory(ares, &r)
 	    || acpi_dev_resource_io(ares, &r)
-	    || acpi_dev_resource_address_space(ares, &r)
-	    || acpi_dev_resource_ext_address_space(ares, &r))
+	    || acpi_dev_resource_address_space(ares, &r, NULL)
+	    || acpi_dev_resource_ext_address_space(ares, &r, NULL))
 		return acpi_dev_new_resource_entry(&r, c);
 
 	for (i = 0; acpi_dev_resource_interrupt(ares, i, &r); i++) {
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 66977ebf13b3..e7bd483704e2 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -183,8 +183,8 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 	struct resource r = {0};
 	int i, flags;
 
-	if (acpi_dev_resource_address_space(res, &r)
-	    || acpi_dev_resource_ext_address_space(res, &r)) {
+	if (acpi_dev_resource_address_space(res, &r, NULL)
+	    || acpi_dev_resource_ext_address_space(res, &r, NULL)) {
 		pnp_add_resource(dev, &r);
 		return AE_OK;
 	}
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 856d381b1d5b..bde8119f5897 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -288,9 +288,11 @@ extern int pnpacpi_disabled;
 bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res);
 bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res);
 bool acpi_dev_resource_address_space(struct acpi_resource *ares,
-				     struct resource *res);
+				     struct resource *res,
+				     resource_size_t *offset);
 bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
-					 struct resource *res);
+					 struct resource *res,
+					 resource_size_t *offset);
 unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable);
 bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 				 struct resource *res);
-- 
1.7.10.4

