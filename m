Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaIKIDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:03:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:35740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbaIKIDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:03:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="601322308"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Patch v5 04/15] ACPI: Add interfaces to parse IOAPIC ID for IOAPIC hotplug
Date: Thu, 11 Sep 2014 16:05:47 +0800
Message-Id: <1410422758-24942-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

We need to parse APIC ID for IOAPIC registration for IOAPIC hotplug.
ACPI _MAT method and MADT table are used to figure out IOAPIC ID, just
like parsing CPU APIC ID for CPU hotplug.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/processor_core.c |  122 ++++++++++++++++++++++++++++++++++++++---
 include/linux/acpi.h          |    4 ++
 2 files changed, 117 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index b048f3752c2b..ccf297c33163 100644
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
 	int apic_id = -1;
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
 		return apic_id;
 
@@ -203,3 +215,95 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
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
+	struct acpi_table_madt *madt;
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
+	    obj->buffer.length < sizeof(struct acpi_subtable_header))
+		goto exit;
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
+/**
+ * acpi_get_ioapic_id() - Get IOAPIC ID and physical address matching @gsi_base
+ * @handle ACPI object for IOAPIC device
+ * @gsi_base GSI base to match with
+ * @phys_add hold physical address of matching IOAPIC record
+ *
+ * Walk resources returned by ACPI_MAT method, then ACPI MADT table, to search
+ * for an ACPI IOAPIC record matching @gsi_base.
+ * Return IOAPIC id and physical address if found a match, otherwise return <0.
+ */
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
index 807cbc46d73e..3574f137242e 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -146,6 +146,10 @@ int acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu);
 int acpi_unmap_lsapic(int cpu);
 #endif /* CONFIG_ACPI_HOTPLUG_CPU */
 
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr);
+#endif
+
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
 void acpi_irq_stats_init(void);
-- 
1.7.10.4

