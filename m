Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbbA1UZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:25:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:19584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbbA1UZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:25:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677268766"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Patch v2 03/22] ACPI: Implement proper length checks for mem resources
Date: Wed, 28 Jan 2015 18:57:21 +0800
Message-Id: <1422442660-455-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Check whether the resulting length is the same as the given
length. Check for start <= end as well.

We need to hand in the resource for this, so we can apply the flags
directly.

[Jiang] Remove enforcement that resource starting address must be
non-zero.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |   62 ++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 1c616a56e007..3e7d9f6eb875 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -34,21 +34,37 @@
 #define valid_IRQ(i) (true)
 #endif
 
-static unsigned long acpi_dev_memresource_flags(u64 len, u8 write_protect,
-						bool window)
+static bool acpi_dev_resource_len_valid(u64 start, u64 end, u64 len, bool io)
 {
-	unsigned long flags = IORESOURCE_MEM;
+	u64 reslen = end - start + 1;
 
-	if (len == 0)
-		flags |= IORESOURCE_DISABLED;
+	/*
+	 * CHECKME: len might be required to check versus a minimum
+	 * length as well. 1 for io is fine, but for memory it does
+	 * not make any sense at all.
+	 */
+	if (len && reslen && reslen == len && start <= end)
+		return true;
+
+	pr_info("ACPI: invalid or unassigned resource %s [%016llx - %016llx] length [%016llx]\n",
+		io ? "io" : "mem", start, end, len);
+
+	return false;
+}
+
+static void acpi_dev_memresource_flags(struct resource *res, u64 len,
+				       u8 write_protect, bool window)
+{
+	res->flags = IORESOURCE_MEM;
+
+	if (!acpi_dev_resource_len_valid(res->start, res->end, len, false))
+		res->flags |= IORESOURCE_DISABLED;
 
 	if (write_protect == ACPI_READ_WRITE_MEMORY)
-		flags |= IORESOURCE_MEM_WRITEABLE;
+		res->flags |= IORESOURCE_MEM_WRITEABLE;
 
 	if (window)
-		flags |= IORESOURCE_WINDOW;
-
-	return flags;
+		res->flags |= IORESOURCE_WINDOW;
 }
 
 static void acpi_dev_get_memresource(struct resource *res, u64 start, u64 len,
@@ -56,7 +72,7 @@ static void acpi_dev_get_memresource(struct resource *res, u64 start, u64 len,
 {
 	res->start = start;
 	res->end = start + len - 1;
-	res->flags = acpi_dev_memresource_flags(len, write_protect, false);
+	acpi_dev_memresource_flags(res, len, write_protect, false);
 }
 
 /**
@@ -77,24 +93,18 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
 	switch (ares->type) {
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 		memory24 = &ares->data.memory24;
-		if (!memory24->minimum && !memory24->address_length)
-			return false;
 		acpi_dev_get_memresource(res, memory24->minimum,
 					 memory24->address_length,
 					 memory24->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 		memory32 = &ares->data.memory32;
-		if (!memory32->minimum && !memory32->address_length)
-			return false;
 		acpi_dev_get_memresource(res, memory32->minimum,
 					 memory32->address_length,
 					 memory32->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 		fixed_memory32 = &ares->data.fixed_memory32;
-		if (!fixed_memory32->address && !fixed_memory32->address_length)
-			return false;
 		acpi_dev_get_memresource(res, fixed_memory32->address,
 					 fixed_memory32->address_length,
 					 fixed_memory32->write_protect);
@@ -102,7 +112,8 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
 	default:
 		return false;
 	}
-	return true;
+
+	return !(res->flags & IORESOURCE_DISABLED);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_memory);
 
@@ -186,7 +197,6 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 	acpi_status status;
 	struct acpi_resource_address64 addr;
 	bool window;
-	u64 len;
 	u8 io_decode;
 
 	status = acpi_resource_to_address64(ares, &addr);
@@ -199,10 +209,9 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 
 	switch(addr.resource_type) {
 	case ACPI_MEMORY_RANGE:
-		len = addr.address.maximum - addr.address.minimum + 1;
-		res->flags = acpi_dev_memresource_flags(len,
-						addr.info.mem.write_protect,
-						window);
+		acpi_dev_memresource_flags(res, addr.address.address_length,
+					   addr.info.mem.write_protect,
+					   window);
 		break;
 	case ACPI_IO_RANGE:
 		io_decode = addr.address.granularity == 0xfff ?
@@ -236,7 +245,6 @@ bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
 {
 	struct acpi_resource_extended_address64 *ext_addr;
 	bool window;
-	u64 len;
 	u8 io_decode;
 
 	if (ares->type != ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64)
@@ -250,10 +258,10 @@ bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
 
 	switch(ext_addr->resource_type) {
 	case ACPI_MEMORY_RANGE:
-		len = ext_addr->address.maximum - ext_addr->address.minimum + 1;
-		res->flags = acpi_dev_memresource_flags(len,
-					ext_addr->info.mem.write_protect,
-					window);
+		acpi_dev_memresource_flags(res,
+					   ext_addr->address.address_length,
+					   ext_addr->info.mem.write_protect,
+					   window);
 		break;
 	case ACPI_IO_RANGE:
 		io_decode = ext_addr->address.granularity == 0xfff ?
-- 
1.7.10.4

