Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaFQF1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:27:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:34991 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605AbaFQF1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:27:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,492,1400050800"; 
   d="scan'208";a="549015151"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <lenb@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [RFC Patch V2 06/16] ACPI, ioapic: Add acpi_get_ioapic_id()
Date: Tue, 17 Jun 2014 13:29:45 +0800
Message-Id: <1402982995-13747-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

For ioapic hotplug, we need to parse apic id for ioapic registration.

We could check _MAT and MADT to get io apic id, just like cpu hotplug
path to get apic id.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/apic_id.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi.h   |    3 ++
 2 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apic_id.c b/drivers/acpi/apic_id.c
index ac3b10a9f92d..a74a3fcd8362 100644
--- a/drivers/acpi/apic_id.c
+++ b/drivers/acpi/apic_id.c
@@ -2,6 +2,10 @@
  * Copyright (C) 2005 Intel Corporation
  * Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
  *	All routines dealing with CPU APIC ID are moved from processor_core.c
+ *
+ * I/O APIC hotplug support
+ *	Yinghai Lu <yinghai@kernel.org>
+ *	Jiang Liu <jiang.liu@intel.com>
  */
 #include <linux/export.h>
 #include <linux/slab.h>
@@ -9,6 +13,9 @@
 
 #include "internal.h"
 
+static struct acpi_table_madt *madt;
+static int read_madt;
+
 static int map_lapic_id(struct acpi_subtable_header *entry,
 		 u32 acpi_id, int *apic_id)
 {
@@ -64,8 +71,6 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
-	static struct acpi_table_madt *madt;
-	static int read_madt;
 	int apic_id = -1;
 
 	if (!read_madt) {
@@ -200,3 +205,91 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 	return acpi_map_cpuid(apic_id, acpi_id);
 }
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);
+
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+static int map_ioapic_id(struct acpi_subtable_header *entry, u32 gsi_base,
+			 u64 *phys_addr, int *ioapic_id)
+{
+	struct acpi_madt_io_apic *ioapic = (struct acpi_madt_io_apic *)entry;
+
+	if (ioapic->global_irq_base != gsi_base)
+		return 0;
+
+	*phys_addr = ioapic->address;
+	*ioapic_id = ioapic->id;
+	return 1;
+}
+
+static int map_madt_ioapic_entry(u32 gsi_base, u64 *phys_addr)
+{
+	struct acpi_subtable_header *hdr;
+	unsigned long madt_end, entry;
+	int apic_id = -1;
+
+	if (!read_madt) {
+		if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
+					(struct acpi_table_header **)&madt)))
+			madt = NULL;
+		read_madt++;
+	}
+
+	if (!madt)
+		return apic_id;
+
+	entry = (unsigned long)madt;
+	madt_end = entry + madt->header.length;
+
+	/* Parse all entries looking for a match. */
+	entry += sizeof(struct acpi_table_madt);
+	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
+		hdr = (struct acpi_subtable_header *)entry;
+		if (hdr->type == ACPI_MADT_TYPE_IO_APIC &&
+		    map_ioapic_id(hdr, gsi_base, phys_addr, &apic_id))
+			break;
+		else
+			entry += hdr->length;
+	}
+
+	return apic_id;
+}
+
+static int map_mat_ioapic_entry(acpi_handle handle, u32 gsi_base,
+				u64 *phys_addr)
+{
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
+	struct acpi_subtable_header *header;
+	int apic_id = -1;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
+		goto exit;
+
+	if (!buffer.length || !buffer.pointer)
+		goto exit;
+
+	obj = buffer.pointer;
+	if (obj->type != ACPI_TYPE_BUFFER ||
+	    obj->buffer.length < sizeof(struct acpi_subtable_header)) {
+		goto exit;
+	}
+
+	header = (struct acpi_subtable_header *)obj->buffer.pointer;
+	if (header->type == ACPI_MADT_TYPE_IO_APIC)
+		map_ioapic_id(header, gsi_base, phys_addr, &apic_id);
+
+exit:
+	kfree(buffer.pointer);
+	return apic_id;
+}
+
+int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr)
+{
+	int apic_id;
+
+	apic_id = map_mat_ioapic_entry(handle, gsi_base, phys_addr);
+	if (apic_id == -1)
+		apic_id = map_madt_ioapic_entry(gsi_base, phys_addr);
+
+	return apic_id;
+}
+#endif /* CONFIG_ACPI_HOTPLUG_IOAPIC */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 5c432e842921..f478af87f575 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -148,6 +148,9 @@ int acpi_unmap_lsapic(int cpu);
 int acpi_get_apicid(acpi_handle, int type, u32 acpi_id);
 int acpi_map_cpuid(int apic_id, u32 acpi_id);
 int acpi_get_cpuid(acpi_handle, int type, u32 acpi_id);
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr);
+#endif
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
-- 
1.7.10.4

