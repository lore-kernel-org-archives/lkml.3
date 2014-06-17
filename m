Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbaFQF1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:27:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:34959 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbaFQF1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:27:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,492,1400050800"; 
   d="scan'208";a="549015094"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <lenb@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [RFC Patch V2 03/16] ACPI, x86/PCI: Move resource_to_addr() to acpi generic
Date: Tue, 17 Jun 2014 13:29:42 +0800
Message-Id: <1402982995-13747-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Rui Wang reported ioapic hot-add does not work on his machine
that _CRS have MEMORY_FIXED.
He also proposed to expose resource_to_addr() and use it for ioapic.

We should move it to acpi generic, as ioapi.c current is in
drivers/pci/.

Or should move it to acpica?

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/pci/acpi.c     |   50 ++---------------------------------------------
 drivers/acpi/resource.c |   46 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h    |    3 +++
 3 files changed, 51 insertions(+), 48 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 91bef49df228..e766cc7d3abe 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -218,59 +218,13 @@ static void teardown_mcfg_map(struct pci_root_info *info)
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
 	struct acpi_resource_address64 addr;
 	acpi_status status;
 
-	status = resource_to_addr(acpi_res, &addr);
+	status = acpi_mem_addr_resource_to_address64(acpi_res, &addr);
 	if (ACPI_SUCCESS(status))
 		info->res_num++;
 	return AE_OK;
@@ -285,7 +239,7 @@ static acpi_status setup_resource(struct acpi_resource *acpi_res, void *data)
 	unsigned long flags;
 	u64 start, orig_end, end;
 
-	status = resource_to_addr(acpi_res, &addr);
+	status = acpi_mem_addr_resource_to_address64(acpi_res, &addr);
 	if (!ACPI_SUCCESS(status))
 		return AE_OK;
 
diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 0bdacc5e26a3..e91deebf0930 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -424,6 +424,52 @@ void acpi_dev_free_resource_list(struct list_head *list)
 }
 EXPORT_SYMBOL_GPL(acpi_dev_free_resource_list);
 
+acpi_status acpi_mem_addr_resource_to_address64(struct acpi_resource *resource,
+			struct acpi_resource_address64 *addr)
+{
+	acpi_status status;
+	struct acpi_resource_memory24 *memory24;
+	struct acpi_resource_memory32 *memory32;
+	struct acpi_resource_fixed_memory32 *fixed_memory32;
+
+	memset(addr, 0, sizeof(*addr));
+	switch (resource->type) {
+	case ACPI_RESOURCE_TYPE_MEMORY24:
+		memory24 = &resource->data.memory24;
+		addr->resource_type = ACPI_MEMORY_RANGE;
+		addr->minimum = memory24->minimum;
+		addr->address_length = memory24->address_length;
+		addr->maximum = addr->minimum + addr->address_length - 1;
+		return AE_OK;
+	case ACPI_RESOURCE_TYPE_MEMORY32:
+		memory32 = &resource->data.memory32;
+		addr->resource_type = ACPI_MEMORY_RANGE;
+		addr->minimum = memory32->minimum;
+		addr->address_length = memory32->address_length;
+		addr->maximum = addr->minimum + addr->address_length - 1;
+		return AE_OK;
+	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
+		fixed_memory32 = &resource->data.fixed_memory32;
+		addr->resource_type = ACPI_MEMORY_RANGE;
+		addr->minimum = fixed_memory32->address;
+		addr->address_length = fixed_memory32->address_length;
+		addr->maximum = addr->minimum + addr->address_length - 1;
+		return AE_OK;
+	case ACPI_RESOURCE_TYPE_ADDRESS16:
+	case ACPI_RESOURCE_TYPE_ADDRESS32:
+	case ACPI_RESOURCE_TYPE_ADDRESS64:
+		status = acpi_resource_to_address64(resource, addr);
+		if (ACPI_SUCCESS(status) &&
+		    (addr->resource_type == ACPI_MEMORY_RANGE ||
+		    addr->resource_type == ACPI_IO_RANGE) &&
+		    addr->address_length > 0) {
+			return AE_OK;
+		}
+		break;
+	}
+	return AE_ERROR;
+}
+
 struct res_proc_context {
 	struct list_head *list;
 	int (*preproc)(struct acpi_resource *, void *);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 7a8f2cd66c8b..b479e10f6621 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -286,6 +286,9 @@ unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable);
 bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 				 struct resource *res);
 
+acpi_status acpi_mem_addr_resource_to_address64(struct acpi_resource *resource,
+			struct acpi_resource_address64 *addr);
+
 struct resource_list_entry {
 	struct list_head node;
 	struct resource res;
-- 
1.7.10.4

