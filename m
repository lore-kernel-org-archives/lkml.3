Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbbAHCdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:33:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:27186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963AbbAHCaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:30:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509087008"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [RFC Patch 10/19] ACPI: Normalize return value of resource parser functions
Date: Thu,  8 Jan 2015 10:32:57 +0800
Message-Id: <1420684386-5975-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normalize return value of resource parse functions as:
1) return "true" if resource is assigned.
2) return "false" and IORESOURCE_DISABLED setting in res->flags if
   resource is unassigned.
3) return "false" and zeroing res->flags if it's not an valid or
   expected resource.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index f4aeef22a9d8..db444c5cdd0e 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -80,6 +80,11 @@ static void acpi_dev_get_memresource(struct resource *res, u64 start, u64 len,
  * Check if the given ACPI resource object represents a memory resource and
  * if that's the case, use the information in it to populate the generic
  * resource object pointed to by @res.
+ *
+ * Return:
+ * 1) false with res->flags setting to zero: not the expected resource type
+ * 2) false with IORESOURCE_DISABLED in res->flags: valid unassigned resource
+ * 3) true: valid assigned resource
  */
 bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
 {
@@ -107,6 +112,7 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
 					 fixed_memory32->write_protect);
 		break;
 	default:
+		res->flags = 0;
 		return false;
 	}
 
@@ -145,6 +151,11 @@ static void acpi_dev_get_ioresource(struct resource *res, u64 start, u64 len,
  * Check if the given ACPI resource object represents an I/O resource and
  * if that's the case, use the information in it to populate the generic
  * resource object pointed to by @res.
+ *
+ * Return:
+ * 1) false with res->flags setting to zero: not the expected resource type
+ * 2) false with IORESOURCE_DISABLED in res->flags: valid unassigned resource
+ * 3) true: valid assigned resource
  */
 bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
 {
@@ -165,6 +176,7 @@ bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
 					ACPI_DECODE_10);
 		break;
 	default:
+		res->flags = 0;
 		return false;
 	}
 
@@ -214,12 +226,18 @@ static bool acpi_decode_space(struct resource *res,
  * Check if the given ACPI resource object represents an address space resource
  * and if that's the case, use the information in it to populate the generic
  * resource object pointed to by @res.
+ *
+ * Return:
+ * 1) false with res->flags setting to zero: not the expected resource type
+ * 2) false with IORESOURCE_DISABLED in res->flags: valid unassigned resource
+ * 3) true: valid assigned resource
  */
 bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 				     struct resource *res)
 {
 	struct acpi_resource_address64 addr;
 
+	res->flags = 0;
 	if (ACPI_FAILURE(acpi_resource_to_address64(ares, &addr)))
 		return false;
 
@@ -235,12 +253,18 @@ EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
  * Check if the given ACPI resource object represents an extended address space
  * resource and if that's the case, use the information in it to populate the
  * generic resource object pointed to by @res.
+ *
+ * Return:
+ * 1) false with res->flags setting to zero: not the expected resource type
+ * 2) false with IORESOURCE_DISABLED in res->flags: valid unassigned resource
+ * 3) true: valid assigned resource
  */
 bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
 					 struct resource *res)
 {
 	struct acpi_resource_extended_address64 *ext_addr;
 
+	res->flags = 0;
 	if (ares->type != ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64)
 		return false;
 
@@ -338,6 +362,11 @@ static void acpi_dev_get_irqresource(struct resource *res, u32 gsi,
  * represented by the resource and populate the generic resource object pointed
  * to by @res accordingly.  If the registration of the GSI is not successful,
  * IORESOURCE_DISABLED will be set it that object's flags.
+ *
+ * Return:
+ * 1) false with res->flags setting to zero: not the expected resource type
+ * 2) false with IORESOURCE_DISABLED in res->flags: valid unassigned resource
+ * 3) true: valid assigned resource
  */
 bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 				 struct resource *res)
@@ -371,6 +400,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 					 ext_irq->sharable, false);
 		break;
 	default:
+		res->flags = 0;
 		return false;
 	}
 
-- 
1.7.10.4

