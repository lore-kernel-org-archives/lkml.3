Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbbAHCal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:30:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:27186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744AbbAHCai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:30:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509086955"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [RFC Patch 06/19] ACPI: Unify the parsing of address_space and ext_address_space
Date: Thu,  8 Jan 2015 10:32:53 +0800
Message-Id: <1420684386-5975-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

With the unions in place which let us identify the substructs we can
use a single parser for address_space and ext_address_space.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |   88 ++++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 55 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index deb70a839f80..d1ceba02afde 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -178,6 +178,35 @@ bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_io);
 
+static bool acpi_decode_space(struct resource *res,
+			      struct acpi_resource_address *base,
+			      struct acpi_resource_address64_common *addr)
+{
+	u8 iodec = addr->granularity == 0xfff ? ACPI_DECODE_10 : ACPI_DECODE_16;
+	bool window = base->producer_consumer == ACPI_PRODUCER;
+	bool wp = base->info.mem.write_protect;
+	u64 len = addr->address_length;
+
+	res->start = addr->minimum;
+	res->end = addr->maximum;
+
+	switch(base->resource_type) {
+	case ACPI_MEMORY_RANGE:
+		acpi_dev_memresource_flags(res, len, wp, window);
+		break;
+	case ACPI_IO_RANGE:
+		acpi_dev_ioresource_flags(res, len, iodec, window);
+		break;
+	case ACPI_BUS_NUMBER_RANGE:
+		res->flags = IORESOURCE_BUS;
+		break;
+	default:
+		return false;
+	}
+
+	return !(res->flags & IORESOURCE_DISABLED);
+}
+
 /**
  * acpi_dev_resource_address_space - Extract ACPI address space information.
  * @ares: Input ACPI resource object.
@@ -190,39 +219,12 @@ EXPORT_SYMBOL_GPL(acpi_dev_resource_io);
 bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 				     struct resource *res)
 {
-	acpi_status status;
 	struct acpi_resource_address64 addr;
-	bool window;
-	u8 io_decode;
-
-	status = acpi_resource_to_address64(ares, &addr);
-	if (ACPI_FAILURE(status))
-		return false;
 
-	res->start = addr.minimum;
-	res->end = addr.maximum;
-	window = addr.producer_consumer == ACPI_PRODUCER;
-
-	switch(addr.resource_type) {
-	case ACPI_MEMORY_RANGE:
-		acpi_dev_memresource_flags(res, addr.address_length,
-					   addr.info.mem.write_protect,
-					   window);
-		break;
-	case ACPI_IO_RANGE:
-		io_decode = addr.granularity == 0xfff ?
-				ACPI_DECODE_10 : ACPI_DECODE_16;
-		acpi_dev_ioresource_flags(res, addr.address_length,
-					  io_decode, window);
-		break;
-	case ACPI_BUS_NUMBER_RANGE:
-		res->flags = IORESOURCE_BUS;
-		break;
-	default:
+	if (ACPI_FAILURE(acpi_resource_to_address64(ares, &addr)))
 		return false;
-	}
 
-	return !(res->flags & IORESOURCE_DISABLED);
+	return acpi_decode_space(res, &addr.common.base, &addr.common.addr);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
 
@@ -239,38 +241,14 @@ bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
 					 struct resource *res)
 {
 	struct acpi_resource_extended_address64 *ext_addr;
-	bool window;
-	u8 io_decode;
 
 	if (ares->type != ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64)
 		return false;
 
 	ext_addr = &ares->data.ext_address64;
 
-	res->start = ext_addr->minimum;
-	res->end = ext_addr->maximum;
-	window = ext_addr->producer_consumer == ACPI_PRODUCER;
-
-	switch(ext_addr->resource_type) {
-	case ACPI_MEMORY_RANGE:
-		acpi_dev_memresource_flags(res, ext_addr->address_length,
-					   ext_addr->info.mem.write_protect,
-					   window);
-		break;
-	case ACPI_IO_RANGE:
-		io_decode = ext_addr->granularity == 0xfff ?
-				ACPI_DECODE_10 : ACPI_DECODE_16;
-		acpi_dev_ioresource_flags(res, ext_addr->address_length,
-					  io_decode, window);
-		break;
-	case ACPI_BUS_NUMBER_RANGE:
-		res->flags = IORESOURCE_BUS;
-		break;
-	default:
-		return false;
-	}
-
-	return !(res->flags & IORESOURCE_DISABLED);
+	return acpi_decode_space(res, &ext_addr->common.base,
+				 &ext_addr->common.addr);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_ext_address_space);
 
-- 
1.7.10.4

