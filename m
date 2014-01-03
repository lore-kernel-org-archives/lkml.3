Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaACAWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:22:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21509 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaACAGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:06:11 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 27/33] ACPI: Move acpi_get_cpuid() to separated file
Date: Thu,  2 Jan 2014 16:05:59 -0800
Message-Id: <1388707565-16535-28-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will need to reuse searching MADT for ioapic, but should add
related function like acpi_get_ioapic_id to processor_core.c
to pollute the file.

Move related cpu apic id search to separated file.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/Makefile         |   1 +
 drivers/acpi/apic_id.c        | 201 ++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/processor_core.c | 193 ----------------------------------------
 include/acpi/processor.h      |   3 -
 include/linux/acpi.h          |   4 +
 5 files changed, 206 insertions(+), 196 deletions(-)
 create mode 100644 drivers/acpi/apic_id.c

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 0331f91..d922feb 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -34,6 +34,7 @@ acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 acpi-y				+= bus.o glue.o
 acpi-y				+= scan.o
 acpi-y				+= resource.o
+acpi-y				+= apic_id.o
 acpi-y				+= acpi_processor.o
 acpi-y				+= processor_core.o
 acpi-y				+= ec.o
diff --git a/drivers/acpi/apic_id.c b/drivers/acpi/apic_id.c
new file mode 100644
index 0000000..bf4e6de
--- /dev/null
+++ b/drivers/acpi/apic_id.c
@@ -0,0 +1,201 @@
+/*
+ * acpi_get_cpuid
+ */
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/acpi.h>
+
+#include "internal.h"
+
+static int map_lapic_id(struct acpi_subtable_header *entry,
+		 u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_apic *lapic =
+		(struct acpi_madt_local_apic *)entry;
+
+	if (!(lapic->lapic_flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	if (lapic->processor_id != acpi_id)
+		return 0;
+
+	*apic_id = lapic->id;
+	return 1;
+}
+
+static int map_x2apic_id(struct acpi_subtable_header *entry,
+			 int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_x2apic *apic =
+		(struct acpi_madt_local_x2apic *)entry;
+
+	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	if (device_declaration && (apic->uid == acpi_id)) {
+		*apic_id = apic->local_apic_id;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int map_lsapic_id(struct acpi_subtable_header *entry,
+		int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_sapic *lsapic =
+		(struct acpi_madt_local_sapic *)entry;
+
+	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	if (device_declaration) {
+		if ((entry->length < 16) || (lsapic->uid != acpi_id))
+			return 0;
+	} else if (lsapic->processor_id != acpi_id)
+		return 0;
+
+	*apic_id = (lsapic->id << 8) | lsapic->eid;
+	return 1;
+}
+
+static int map_madt_entry(int type, u32 acpi_id)
+{
+	unsigned long madt_end, entry;
+	static struct acpi_table_madt *madt;
+	static int read_madt;
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
+		if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
+			if (map_lapic_id(header, acpi_id, &apic_id))
+				break;
+		} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
+			if (map_x2apic_id(header, type, acpi_id, &apic_id))
+				break;
+		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
+			if (map_lsapic_id(header, type, acpi_id, &apic_id))
+				break;
+		}
+		entry += header->length;
+	}
+	return apic_id;
+}
+
+static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
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
+	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
+		map_lapic_id(header, acpi_id, &apic_id);
+	} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
+		map_x2apic_id(header, type, acpi_id, &apic_id);
+	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
+		map_lsapic_id(header, type, acpi_id, &apic_id);
+	}
+
+exit:
+	kfree(buffer.pointer);
+	return apic_id;
+}
+
+int acpi_get_apicid(acpi_handle handle, int type, u32 acpi_id)
+{
+	int apic_id;
+
+	apic_id = map_mat_entry(handle, type, acpi_id);
+	if (apic_id == -1)
+		apic_id = map_madt_entry(type, acpi_id);
+
+	return apic_id;
+}
+
+int acpi_map_cpuid(int apic_id, u32 acpi_id)
+{
+#ifdef CONFIG_SMP
+	int i;
+#endif
+
+	if (apic_id == -1) {
+		/*
+		 * On UP processor, there is no _MAT or MADT table.
+		 * So above apic_id is always set to -1.
+		 *
+		 * BIOS may define multiple CPU handles even for UP processor.
+		 * For example,
+		 *
+		 * Scope (_PR)
+                 * {
+		 *     Processor (CPU0, 0x00, 0x00000410, 0x06) {}
+		 *     Processor (CPU1, 0x01, 0x00000410, 0x06) {}
+		 *     Processor (CPU2, 0x02, 0x00000410, 0x06) {}
+		 *     Processor (CPU3, 0x03, 0x00000410, 0x06) {}
+		 * }
+		 *
+		 * Ignores apic_id and always returns 0 for the processor
+		 * handle with acpi id 0 if nr_cpu_ids is 1.
+		 * This should be the case if SMP tables are not found.
+		 * Return -1 for other CPU's handle.
+		 */
+		if (nr_cpu_ids <= 1 && acpi_id == 0)
+			return acpi_id;
+		else
+			return apic_id;
+	}
+
+#ifdef CONFIG_SMP
+	for_each_possible_cpu(i) {
+		if (cpu_physical_id(i) == apic_id)
+			return i;
+	}
+#else
+	/* In UP kernel, only processor 0 is valid */
+	if (apic_id == 0)
+		return apic_id;
+#endif
+	return -1;
+}
+
+int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
+{
+	int apic_id;
+
+	apic_id = acpi_get_apicid(handle, type, acpi_id);
+
+	return acpi_map_cpuid(apic_id, acpi_id);
+}
+EXPORT_SYMBOL_GPL(acpi_get_cpuid);
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 559e762..ad9a850 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -38,199 +38,6 @@ static struct dmi_system_id processor_idle_dmi_table[] __initdata = {
 	{},
 };
 
-static int map_lapic_id(struct acpi_subtable_header *entry,
-		 u32 acpi_id, int *apic_id)
-{
-	struct acpi_madt_local_apic *lapic =
-		(struct acpi_madt_local_apic *)entry;
-
-	if (!(lapic->lapic_flags & ACPI_MADT_ENABLED))
-		return 0;
-
-	if (lapic->processor_id != acpi_id)
-		return 0;
-
-	*apic_id = lapic->id;
-	return 1;
-}
-
-static int map_x2apic_id(struct acpi_subtable_header *entry,
-			 int device_declaration, u32 acpi_id, int *apic_id)
-{
-	struct acpi_madt_local_x2apic *apic =
-		(struct acpi_madt_local_x2apic *)entry;
-
-	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
-		return 0;
-
-	if (device_declaration && (apic->uid == acpi_id)) {
-		*apic_id = apic->local_apic_id;
-		return 1;
-	}
-
-	return 0;
-}
-
-static int map_lsapic_id(struct acpi_subtable_header *entry,
-		int device_declaration, u32 acpi_id, int *apic_id)
-{
-	struct acpi_madt_local_sapic *lsapic =
-		(struct acpi_madt_local_sapic *)entry;
-
-	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
-		return 0;
-
-	if (device_declaration) {
-		if ((entry->length < 16) || (lsapic->uid != acpi_id))
-			return 0;
-	} else if (lsapic->processor_id != acpi_id)
-		return 0;
-
-	*apic_id = (lsapic->id << 8) | lsapic->eid;
-	return 1;
-}
-
-static int map_madt_entry(int type, u32 acpi_id)
-{
-	unsigned long madt_end, entry;
-	static struct acpi_table_madt *madt;
-	static int read_madt;
-	int apic_id = -1;
-
-	if (!read_madt) {
-		if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
-					(struct acpi_table_header **)&madt)))
-			madt = NULL;
-		read_madt++;
-	}
-
-	if (!madt)
-		return apic_id;
-
-	entry = (unsigned long)madt;
-	madt_end = entry + madt->header.length;
-
-	/* Parse all entries looking for a match. */
-
-	entry += sizeof(struct acpi_table_madt);
-	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
-		struct acpi_subtable_header *header =
-			(struct acpi_subtable_header *)entry;
-		if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
-			if (map_lapic_id(header, acpi_id, &apic_id))
-				break;
-		} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
-			if (map_x2apic_id(header, type, acpi_id, &apic_id))
-				break;
-		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
-			if (map_lsapic_id(header, type, acpi_id, &apic_id))
-				break;
-		}
-		entry += header->length;
-	}
-	return apic_id;
-}
-
-static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
-{
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object *obj;
-	struct acpi_subtable_header *header;
-	int apic_id = -1;
-
-	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
-		goto exit;
-
-	if (!buffer.length || !buffer.pointer)
-		goto exit;
-
-	obj = buffer.pointer;
-	if (obj->type != ACPI_TYPE_BUFFER ||
-	    obj->buffer.length < sizeof(struct acpi_subtable_header)) {
-		goto exit;
-	}
-
-	header = (struct acpi_subtable_header *)obj->buffer.pointer;
-	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
-		map_lapic_id(header, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
-		map_x2apic_id(header, type, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
-		map_lsapic_id(header, type, acpi_id, &apic_id);
-	}
-
-exit:
-	kfree(buffer.pointer);
-	return apic_id;
-}
-
-int acpi_get_apicid(acpi_handle handle, int type, u32 acpi_id)
-{
-	int apic_id;
-
-	apic_id = map_mat_entry(handle, type, acpi_id);
-	if (apic_id == -1)
-		apic_id = map_madt_entry(type, acpi_id);
-
-	return apic_id;
-}
-
-int acpi_map_cpuid(int apic_id, u32 acpi_id)
-{
-#ifdef CONFIG_SMP
-	int i;
-#endif
-
-	if (apic_id == -1) {
-		/*
-		 * On UP processor, there is no _MAT or MADT table.
-		 * So above apic_id is always set to -1.
-		 *
-		 * BIOS may define multiple CPU handles even for UP processor.
-		 * For example,
-		 *
-		 * Scope (_PR)
-                 * {
-		 *     Processor (CPU0, 0x00, 0x00000410, 0x06) {}
-		 *     Processor (CPU1, 0x01, 0x00000410, 0x06) {}
-		 *     Processor (CPU2, 0x02, 0x00000410, 0x06) {}
-		 *     Processor (CPU3, 0x03, 0x00000410, 0x06) {}
-		 * }
-		 *
-		 * Ignores apic_id and always returns 0 for the processor
-		 * handle with acpi id 0 if nr_cpu_ids is 1.
-		 * This should be the case if SMP tables are not found.
-		 * Return -1 for other CPU's handle.
-		 */
-		if (nr_cpu_ids <= 1 && acpi_id == 0)
-			return acpi_id;
-		else
-			return apic_id;
-	}
-
-#ifdef CONFIG_SMP
-	for_each_possible_cpu(i) {
-		if (cpu_physical_id(i) == apic_id)
-			return i;
-	}
-#else
-	/* In UP kernel, only processor 0 is valid */
-	if (apic_id == 0)
-		return apic_id;
-#endif
-	return -1;
-}
-
-int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
-{
-	int apic_id;
-
-	apic_id = acpi_get_apicid(handle, type, acpi_id);
-
-	return acpi_map_cpuid(apic_id, acpi_id);
-}
-EXPORT_SYMBOL_GPL(acpi_get_cpuid);
-
 static bool __init processor_physically_present(acpi_handle handle)
 {
 	int cpuid, type;
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 6eb1d3c..337e731 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -314,9 +314,6 @@ static inline int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
 
 /* in processor_core.c */
 void acpi_processor_set_pdc(acpi_handle handle);
-int acpi_get_apicid(acpi_handle, int type, u32 acpi_id);
-int acpi_map_cpuid(int apic_id, u32 acpi_id);
-int acpi_get_cpuid(acpi_handle, int type, u32 acpi_id);
 
 /* in processor_throttling.c */
 int acpi_processor_tstate_has_changed(struct acpi_processor *pr);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d9099b1..2f73b81 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -134,6 +134,10 @@ int acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu);
 int acpi_unmap_lsapic(int cpu);
 #endif /* CONFIG_ACPI_HOTPLUG_CPU */
 
+int acpi_get_apicid(acpi_handle, int type, u32 acpi_id);
+int acpi_map_cpuid(int apic_id, u32 acpi_id);
+int acpi_get_cpuid(acpi_handle, int type, u32 acpi_id);
+
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
 void acpi_irq_stats_init(void);
-- 
1.8.4

