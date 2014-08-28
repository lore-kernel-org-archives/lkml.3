Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232AbaH1CU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:20:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:27484 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284AbaH1CUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:20:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,415,1406617200"; 
   d="scan'208";a="582676622"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Len Brown <lenb@kernel.org>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [Patch v4 04/16] ACPI: Rename processor_core.c as apic_id.c
Date: Thu, 28 Aug 2014 10:22:29 +0800
Message-Id: <1409192561-19744-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all code in processor_core.c is APIC ID related, so rename it as
apic_id.c. Later IOAPIC ID related code will be added into apic_id.c.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/Makefile         |    2 +-
 drivers/acpi/apic_id.c        |  202 ++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/processor_core.c |  205 -----------------------------------------
 include/acpi/processor.h      |    3 -
 include/linux/acpi.h          |    3 +
 5 files changed, 206 insertions(+), 209 deletions(-)
 create mode 100644 drivers/acpi/apic_id.c
 delete mode 100644 drivers/acpi/processor_core.c

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 505d4d79fe3e..03ddd03f2bcd 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -35,7 +35,7 @@ acpi-y				+= bus.o glue.o
 acpi-y				+= scan.o
 acpi-y				+= resource.o
 acpi-y				+= acpi_processor.o
-acpi-y				+= processor_core.o
+acpi-y				+= apic_id.o
 acpi-$(CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC) += processor_pdc.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
diff --git a/drivers/acpi/apic_id.c b/drivers/acpi/apic_id.c
new file mode 100644
index 000000000000..ada5fd48bad4
--- /dev/null
+++ b/drivers/acpi/apic_id.c
@@ -0,0 +1,202 @@
+/*
+ * Copyright (C) 2005 Intel Corporation
+ * Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
+ *
+ *	Alex Chiang <achiang@hp.com>
+ *	- Unified x86/ia64 implementations
+ */
+#include <linux/export.h>
+#include <linux/acpi.h>
+#include "internal.h"
+
+static int map_lapic_id(struct acpi_subtable_header *entry,
+		 u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_apic *lapic =
+		(struct acpi_madt_local_apic *)entry;
+
+	if (!(lapic->lapic_flags & ACPI_MADT_ENABLED))
+		return -ENODEV;
+
+	if (lapic->processor_id != acpi_id)
+		return -EINVAL;
+
+	*apic_id = lapic->id;
+	return 0;
+}
+
+static int map_x2apic_id(struct acpi_subtable_header *entry,
+			 int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_x2apic *apic =
+		(struct acpi_madt_local_x2apic *)entry;
+
+	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
+		return -ENODEV;
+
+	if (device_declaration && (apic->uid == acpi_id)) {
+		*apic_id = apic->local_apic_id;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int map_lsapic_id(struct acpi_subtable_header *entry,
+		int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_sapic *lsapic =
+		(struct acpi_madt_local_sapic *)entry;
+
+	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
+		return -ENODEV;
+
+	if (device_declaration) {
+		if ((entry->length < 16) || (lsapic->uid != acpi_id))
+			return -EINVAL;
+	} else if (lsapic->processor_id != acpi_id)
+		return -EINVAL;
+
+	*apic_id = (lsapic->id << 8) | lsapic->eid;
+	return 0;
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
+			if (!map_lapic_id(header, acpi_id, &apic_id))
+				break;
+		} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
+			if (!map_x2apic_id(header, type, acpi_id, &apic_id))
+				break;
+		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
+			if (!map_lsapic_id(header, type, acpi_id, &apic_id))
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
+	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC)
+		map_lapic_id(header, acpi_id, &apic_id);
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC)
+		map_lsapic_id(header, type, acpi_id, &apic_id);
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC)
+		map_x2apic_id(header, type, acpi_id, &apic_id);
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
+		 * {
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
deleted file mode 100644
index b048f3752c2b..000000000000
--- a/drivers/acpi/processor_core.c
+++ /dev/null
@@ -1,205 +0,0 @@
-/*
- * Copyright (C) 2005 Intel Corporation
- * Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
- *
- *	Alex Chiang <achiang@hp.com>
- *	- Unified x86/ia64 implementations
- */
-#include <linux/export.h>
-#include <linux/acpi.h>
-#include <acpi/processor.h>
-
-#define _COMPONENT		ACPI_PROCESSOR_COMPONENT
-ACPI_MODULE_NAME("processor_core");
-
-static int map_lapic_id(struct acpi_subtable_header *entry,
-		 u32 acpi_id, int *apic_id)
-{
-	struct acpi_madt_local_apic *lapic =
-		(struct acpi_madt_local_apic *)entry;
-
-	if (!(lapic->lapic_flags & ACPI_MADT_ENABLED))
-		return -ENODEV;
-
-	if (lapic->processor_id != acpi_id)
-		return -EINVAL;
-
-	*apic_id = lapic->id;
-	return 0;
-}
-
-static int map_x2apic_id(struct acpi_subtable_header *entry,
-			 int device_declaration, u32 acpi_id, int *apic_id)
-{
-	struct acpi_madt_local_x2apic *apic =
-		(struct acpi_madt_local_x2apic *)entry;
-
-	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
-		return -ENODEV;
-
-	if (device_declaration && (apic->uid == acpi_id)) {
-		*apic_id = apic->local_apic_id;
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
-static int map_lsapic_id(struct acpi_subtable_header *entry,
-		int device_declaration, u32 acpi_id, int *apic_id)
-{
-	struct acpi_madt_local_sapic *lsapic =
-		(struct acpi_madt_local_sapic *)entry;
-
-	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
-		return -ENODEV;
-
-	if (device_declaration) {
-		if ((entry->length < 16) || (lsapic->uid != acpi_id))
-			return -EINVAL;
-	} else if (lsapic->processor_id != acpi_id)
-		return -EINVAL;
-
-	*apic_id = (lsapic->id << 8) | lsapic->eid;
-	return 0;
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
-			if (!map_lapic_id(header, acpi_id, &apic_id))
-				break;
-		} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
-			if (!map_x2apic_id(header, type, acpi_id, &apic_id))
-				break;
-		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
-			if (!map_lsapic_id(header, type, acpi_id, &apic_id))
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
-	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC)
-		map_lapic_id(header, acpi_id, &apic_id);
-	else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC)
-		map_lsapic_id(header, type, acpi_id, &apic_id);
-	else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC)
-		map_x2apic_id(header, type, acpi_id, &apic_id);
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
-		 * {
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
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 9b9b6f29bbf3..99fc22c9e61f 100644
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
index 807cbc46d73e..05ed6886f1f8 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -140,6 +140,9 @@ void acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa);
 int acpi_numa_memory_affinity_init (struct acpi_srat_mem_affinity *ma);
 void acpi_numa_arch_fixup(void);
 
+int acpi_get_apicid(acpi_handle, int type, u32 acpi_id);
+int acpi_map_cpuid(int apic_id, u32 acpi_id);
+int acpi_get_cpuid(acpi_handle, int type, u32 acpi_id);
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 /* Arch dependent functions for cpu hotplug support */
 int acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu);
-- 
1.7.10.4

