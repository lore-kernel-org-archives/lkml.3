Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbbA1UVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:21:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:65013 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbbA1UVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:21:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677269392"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [Patch v2 21/22] ACPI: Add interfaces to parse IOAPIC ID for IOAPIC hotplug
Date: Wed, 28 Jan 2015 18:57:39 +0800
Message-Id: <1422442660-455-22-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

We need to parse APIC ID for IOAPIC registration for IOAPIC hotplug.
ACPI _MAT method and MADT table are used to figure out IOAPIC ID, just
like parsing CPU APIC ID for CPU hotplug.

[ tglx: Fixed docbook comment ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <lenb@kernel.org>
Link: http://lkml.kernel.org/r/1414387308-27148-8-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/acpi/processor_core.c |  123 ++++++++++++++++++++++++++++++++++++++---
 include/linux/acpi.h          |    4 ++
 2 files changed, 118 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 02e48394276c..7962651cdbd4 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -4,6 +4,10 @@
  *
  *	Alex Chiang <achiang@hp.com>
  *	- Unified x86/ia64 implementations
+ *
+ * I/O APIC hotplug support
+ *	Yinghai Lu <yinghai@kernel.org>
+ *	Jiang Liu <jiang.liu@intel.com>
  */
 #include <linux/export.h>
 #include <linux/acpi.h>
@@ -12,6 +16,21 @@
 #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_core");
 
+static struct acpi_table_madt *get_madt_table(void)
+{
+	static struct acpi_table_madt *madt;
+	static int read_madt;
+
+	if (!read_madt) {
+		if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
+					(struct acpi_table_header **)&madt)))
+			madt = NULL;
+		read_madt++;
+	}
+
+	return madt;
+}
+
 static int map_lapic_id(struct acpi_subtable_header *entry,
 		 u32 acpi_id, int *apic_id)
 {
@@ -67,17 +86,10 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
-	static struct acpi_table_madt *madt;
-	static int read_madt;
 	int phys_id = -1;	/* CPU hardware ID */
+	struct acpi_table_madt *madt;
 
-	if (!read_madt) {
-		if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
-					(struct acpi_table_header **)&madt)))
-			madt = NULL;
-		read_madt++;
-	}
-
+	madt = get_madt_table();
 	if (!madt)
 		return phys_id;
 
@@ -203,3 +215,96 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 	return acpi_map_cpuid(phys_id, acpi_id);
 }
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);
+
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+static int get_ioapic_id(struct acpi_subtable_header *entry, u32 gsi_base,
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
+static int parse_madt_ioapic_entry(u32 gsi_base, u64 *phys_addr)
+{
+	struct acpi_subtable_header *hdr;
+	unsigned long madt_end, entry;
+	struct acpi_table_madt *madt;
+	int apic_id = -1;
+
+	madt = get_madt_table();
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
+		    get_ioapic_id(hdr, gsi_base, phys_addr, &apic_id))
+			break;
+		else
+			entry += hdr->length;
+	}
+
+	return apic_id;
+}
+
+static int parse_mat_ioapic_entry(acpi_handle handle, u32 gsi_base,
+				  u64 *phys_addr)
+{
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_subtable_header *header;
+	union acpi_object *obj;
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
+	    obj->buffer.length < sizeof(struct acpi_subtable_header))
+		goto exit;
+
+	header = (struct acpi_subtable_header *)obj->buffer.pointer;
+	if (header->type == ACPI_MADT_TYPE_IO_APIC)
+		get_ioapic_id(header, gsi_base, phys_addr, &apic_id);
+
+exit:
+	kfree(buffer.pointer);
+	return apic_id;
+}
+
+/**
+ * acpi_get_ioapic_id - Get IOAPIC ID and physical address matching @gsi_base
+ * @handle:	ACPI object for IOAPIC device
+ * @gsi_base:	GSI base to match with
+ * @phys_addr:	Pointer to store physical address of matching IOAPIC record
+ *
+ * Walk resources returned by ACPI_MAT method, then ACPI MADT table, to search
+ * for an ACPI IOAPIC record matching @gsi_base.
+ * Return IOAPIC id and store physical address in @phys_addr if found a match,
+ * otherwise return <0.
+ */
+int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr)
+{
+	int apic_id;
+
+	apic_id = parse_mat_ioapic_entry(handle, gsi_base, phys_addr);
+	if (apic_id == -1)
+		apic_id = parse_madt_ioapic_entry(gsi_base, phys_addr);
+
+	return apic_id;
+}
+#endif /* CONFIG_ACPI_HOTPLUG_IOAPIC */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index e53822148b6a..24c7aa8b1d20 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -152,6 +152,10 @@ int acpi_map_cpu(acpi_handle handle, int physid, int *pcpu);
 int acpi_unmap_cpu(int cpu);
 #endif /* CONFIG_ACPI_HOTPLUG_CPU */
 
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr);
+#endif
+
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
 int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base);
-- 
1.7.10.4

