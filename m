Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaACAVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:21:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23256 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaACAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:06:13 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 28/33] ACPI, ioapic: Add acpi_get_ioapic_id()
Date: Thu,  2 Jan 2014 16:06:00 -0800
Message-Id: <1388707565-16535-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ioapic hotplug, we need to pass apic id for ioapic registration.

We could check _MAT and MADT to get io apic id, just like cpu hotplug
path to get apic id.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/apic_id.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/acpi.h   |  9 +++++
 2 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apic_id.c b/drivers/acpi/apic_id.c
index bf4e6de..724444e 100644
--- a/drivers/acpi/apic_id.c
+++ b/drivers/acpi/apic_id.c
@@ -1,5 +1,7 @@
 /*
  * acpi_get_cpuid
+ * acpi_get_ioapic_id for ioapic hotplug support
+ *
  */
 #include <linux/export.h>
 #include <linux/slab.h>
@@ -59,11 +61,11 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 	return 1;
 }
 
+static struct acpi_table_madt *madt;
+static int read_madt;
 static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
-	static struct acpi_table_madt *madt;
-	static int read_madt;
 	int apic_id = -1;
 
 	if (!read_madt) {
@@ -199,3 +201,94 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 	return acpi_map_cpuid(apic_id, acpi_id);
 }
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);
+
+#ifdef CONFIG_PCI_IOAPIC
+static int map_ioapic_id(struct acpi_subtable_header *entry, u32 gsi_base,
+		  u64 *phys_addr, int *ioapic_id)
+{
+	struct acpi_madt_io_apic *ioapic =
+		(struct acpi_madt_io_apic *)entry;
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
+
+	entry += sizeof(struct acpi_table_madt);
+	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
+		struct acpi_subtable_header *header =
+			(struct acpi_subtable_header *)entry;
+		if (header->type == ACPI_MADT_TYPE_IO_APIC) {
+			if (map_ioapic_id(header, gsi_base, phys_addr,
+						 &apic_id))
+				break;
+		}
+		entry += header->length;
+	}
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
+	int apic_id = -1;
+
+	apic_id = map_mat_ioapic_entry(handle, gsi_base, phys_addr);
+	if (apic_id == -1)
+		apic_id = map_madt_ioapic_entry(gsi_base, phys_addr);
+
+	return apic_id;
+}
+
+#endif /* CONFIG_PCI_IOAPIC */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 2f73b81..ee8058e 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -137,6 +137,15 @@ int acpi_unmap_lsapic(int cpu);
 int acpi_get_apicid(acpi_handle, int type, u32 acpi_id);
 int acpi_map_cpuid(int apic_id, u32 acpi_id);
 int acpi_get_cpuid(acpi_handle, int type, u32 acpi_id);
+#ifdef CONFIG_PCI_IOAPIC
+int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr);
+#else
+static inline int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base,
+					 u64 *phys_addr)
+{
+	return -1;
+}
+#endif
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
-- 
1.8.4

