Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab3JPPLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:11:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:50940 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760659Ab3JPPLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:11:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="393857817"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com
Cc: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH v2 9/9] ACPI / trace: Add trace interface for eMCA driver
Date: Wed, 16 Oct 2013 10:56:06 -0400
Message-Id: <1381935366-11731-10-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use trace interface to elaborate all H/W error related
information.

v2 -> v1: move trace interface into ras_event.h

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/Kconfig        |   7 ++-
 drivers/acpi/Makefile       |   4 ++
 drivers/acpi/acpi_extlog.c  |  28 +++++++++++-
 drivers/acpi/apei/cper.c    |  13 ++++--
 drivers/acpi/extlog_trace.c | 107 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/extlog_trace.h |  16 +++++++
 include/linux/cper.h        |   2 +
 include/ras/ras_event.h     |  61 +++++++++++++++++++++++++
 8 files changed, 232 insertions(+), 6 deletions(-)
 create mode 100644 drivers/acpi/extlog_trace.c
 create mode 100644 drivers/acpi/extlog_trace.h

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 819c06b..0cc8fc8 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -372,13 +372,18 @@ config ACPI_BGRT
 
 source "drivers/acpi/apei/Kconfig"
 
+config EXTLOG_TRACE
+	def_bool n
+
 config ACPI_EXTLOG
 	tristate "Extended Error Log support"
 	depends on X86_MCE
+	select EXTLOG_TRACE
 	default n
 	help
 	  Enhanced MCA Logging allows firmware to provide additional error
 	  information to system software, synchronous with MCE or CMCI. This
-	  driver adds support for that functionality.
+	  driver adds support for that functionality plus an additional special
+	  tracepoint which carries that information to userspace.
 
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index bce34af..a6e41b7 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -83,4 +83,8 @@ obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
 
 obj-$(CONFIG_ACPI_APEI)		+= apei/
 
+# extended log support
+acpi-$(CONFIG_EXTLOG_TRACE)	+= extlog_trace.o
+CFLAGS_extlog_trace.o := -I$(src)
+
 obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index d55b072..01e6a89 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -15,6 +15,7 @@
 #include <asm/mce.h>
 
 #include "apei/apei-internal.h"
+#include "extlog_trace.h"
 
 #define EXT_ELOG_ENTRY_MASK	GENMASK_ULL(52, 0) /* elog entry address mask */
 
@@ -44,6 +45,8 @@ struct extlog_l1_head {
 
 static u8 extlog_dsm_uuid[] = "663E35AF-CC10-41A4-88EA-5470AF055295";
 
+static const uuid_le invalid_uuid = NULL_UUID_LE;
+
 /* L1 table related physical address */
 static u64 elog_base;
 static size_t elog_size;
@@ -132,7 +135,12 @@ static int print_extlog_rcd(const char *pfx,
 
 static int extlog_print(const char *pfx, int cpu, int bank)
 {
-	struct acpi_generic_status *estatus;
+	struct acpi_generic_status *estatus, *tmp;
+	struct acpi_generic_data *gdata;
+	const uuid_le *fru_id = &invalid_uuid;
+	char *fru_text = "";
+	uuid_le *sec_type;
+	static u64 err_count;
 	int rc;
 
 	estatus = extlog_elog_entry_check(cpu, bank);
@@ -143,7 +151,23 @@ static int extlog_print(const char *pfx, int cpu, int bank)
 	/* clear record status to enable BIOS to update it again */
 	estatus->block_status = 0;
 
-	rc = print_extlog_rcd(pfx, (struct acpi_generic_status *)elog_buf, cpu);
+	tmp = (struct acpi_generic_status *)elog_buf;
+	gdata = (struct acpi_generic_data *)(tmp + 1);
+	rc = print_extlog_rcd(pfx, tmp, cpu);
+
+	/* trace extended error log */
+	err_count++;
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+		fru_id = (uuid_le *)gdata->fru_id;
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+		fru_text = gdata->fru_text;
+	sec_type = (uuid_le *)gdata->section_type;
+	if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
+		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
+		if (gdata->error_data_length >= sizeof(*mem_err))
+			trace_mem_error(fru_id, fru_text, err_count,
+					gdata->error_severity, mem_err);
+	}
 
 	return rc;
 }
diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index f5bc227..44bde6a 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -59,11 +59,12 @@ static const char *cper_severity_strs[] = {
 	"info",
 };
 
-static const char *cper_severity_str(unsigned int severity)
+const char *cper_severity_str(unsigned int severity)
 {
 	return severity < ARRAY_SIZE(cper_severity_strs) ?
 		cper_severity_strs[severity] : "unknown";
 }
+EXPORT_SYMBOL_GPL(cper_severity_str);
 
 /*
  * cper_print_bits - print strings for set bits
@@ -198,6 +199,13 @@ static const char *cper_mem_err_type_strs[] = {
 	"physical memory map-out event",
 };
 
+const char *cper_mem_err_type_str(unsigned int etype)
+{
+	return etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
+		cper_mem_err_type_strs[etype] : "unknown";
+}
+EXPORT_SYMBOL_GPL(cper_mem_err_type_str);
+
 static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
 {
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
@@ -235,8 +243,7 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
 		u8 etype = mem->error_type;
 		printk("%s""error_type: %d, %s\n", pfx, etype,
-		       etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
-		       cper_mem_err_type_strs[etype] : "unknown");
+			cper_mem_err_type_str(etype));
 	}
 	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {
 		const char *bank = NULL, *device = NULL;
diff --git a/drivers/acpi/extlog_trace.c b/drivers/acpi/extlog_trace.c
new file mode 100644
index 0000000..2864080
--- /dev/null
+++ b/drivers/acpi/extlog_trace.c
@@ -0,0 +1,107 @@
+#include <linux/export.h>
+#include <linux/dmi.h>
+#include "extlog_trace.h"
+
+#define CREATE_TRACE_POINTS
+#define TRACE_INCLUDE_PATH ../../include/ras
+#include <ras/ras_event.h>
+
+static char mem_location[LOC_LEN];
+static char dimm_location[LOC_LEN];
+
+static void mem_err_location(struct cper_sec_mem_err *mem)
+{
+	char *p;
+	u32 n = 0;
+
+	memset(mem_location, 0, LOC_LEN);
+	p = mem_location;
+	if (mem->validation_bits & CPER_MEM_VALID_NODE)
+		n += sprintf(p + n, " node: %d", mem->node);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_CARD)
+		n += sprintf(p + n, " card: %d", mem->card);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
+		n += sprintf(p + n, " module: %d", mem->module);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
+		n += sprintf(p + n, " rank: %d", mem->rank);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_BANK)
+		n += sprintf(p + n, " bank: %d", mem->bank);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
+		n += sprintf(p + n, " device: %d", mem->device);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_ROW)
+		n += sprintf(p + n, " row: %d", mem->row);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_COLUMN)
+		n += sprintf(p + n, " column: %d", mem->column);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
+		n += sprintf(p + n, " bit_position: %d", mem->bit_pos);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
+		n += sprintf(p + n, " requestor_id: 0x%016llx",
+				mem->requestor_id);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
+		n += sprintf(p + n, " responder_id: 0x%016llx",
+				mem->responder_id);
+	if (n >= LOC_LEN)
+		goto end;
+	if (mem->validation_bits & CPER_MEM_VALID_TARGET_ID)
+		n += sprintf(p + n, " target_id: 0x%016llx", mem->target_id);
+end:
+	return;
+}
+
+static void dimm_err_location(struct cper_sec_mem_err *mem)
+{
+	const char *bank = NULL, *device = NULL;
+
+	memset(dimm_location, 0, LOC_LEN);
+	if (!(mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE))
+		return;
+
+	dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
+	if (bank != NULL && device != NULL)
+		snprintf(dimm_location, LOC_LEN - 1, "%s %s", bank, device);
+	else
+		snprintf(dimm_location, LOC_LEN - 1, "DMI handle: 0x%.4x",
+			 mem->mem_dev_handle);
+}
+
+void trace_mem_error(const uuid_le *fru_id, char *fru_text,
+			    u64 err_count, u32 severity,
+			    struct cper_sec_mem_err *mem)
+{
+	u32 etype = ~0U;
+	u64 phy_addr = 0;
+
+	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
+		etype = mem->error_type;
+	if (mem->validation_bits & CPER_MEM_VALID_PA) {
+		phy_addr = mem->physical_addr;
+		if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
+			phy_addr &= mem->physical_addr_mask;
+	}
+	mem_err_location(mem);
+	dimm_err_location(mem);
+
+	trace_extlog_mem_event(etype, dimm_location, fru_id, fru_text,
+			       err_count, severity, phy_addr, mem_location);
+}
+EXPORT_SYMBOL_GPL(trace_mem_error);
diff --git a/drivers/acpi/extlog_trace.h b/drivers/acpi/extlog_trace.h
new file mode 100644
index 0000000..67bb2c5
--- /dev/null
+++ b/drivers/acpi/extlog_trace.h
@@ -0,0 +1,16 @@
+#ifndef __DEBUG_EXTLOG_H
+#define __DEBUG_EXTLOG_H
+
+#include <linux/cper.h>
+
+#ifdef CONFIG_EXTLOG_TRACE
+extern void trace_mem_error(const uuid_le *fru_id, char *fru_text,
+		u64 err_count, u32 severity, struct cper_sec_mem_err *mem);
+#else
+void trace_mem_error(const uuid_le *fru_id, char *fru_text,
+		u64 err_count, u32 severity, struct cper_sec_mem_err *mem)
+{
+}
+#endif
+
+#endif
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 2fc0ec3..c6d87fc 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -395,6 +395,8 @@ struct cper_sec_pcie {
 #pragma pack()
 
 u64 cper_next_record_id(void);
+const char *cper_severity_str(unsigned int);
+const char *cper_mem_err_type_str(unsigned int);
 void cper_print_bits(const char *prefix, unsigned int bits,
 		     const char * const strs[], unsigned int strs_size);
 
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 21cdb0b..fce14b6 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -8,6 +8,67 @@
 #include <linux/tracepoint.h>
 #include <linux/edac.h>
 #include <linux/ktime.h>
+#include <linux/cper.h>
+
+/*
+ * MCE Extended Error Log trace event
+ *
+ * These events are generated when hardware detects a corrected or
+ * uncorrected event.
+ *
+ */
+
+/* memory trace event */
+
+#define LOC_LEN		512
+#define MSG_LEN		((LOC_LEN) * 2)
+
+TRACE_EVENT(extlog_mem_event,
+	TP_PROTO(u32 etype,
+		char *dimm_loc,
+		const uuid_le *fru_id,
+		char *fru_text,
+		u64 error_count,
+		u32 severity,
+		u64 phy_addr,
+		char *mem_loc),
+
+	TP_ARGS(etype, dimm_loc, fru_id, fru_text, error_count, severity,
+		phy_addr, mem_loc),
+
+	TP_STRUCT__entry(
+		__field(u32, etype)
+		__dynamic_array(char, dimm_info, LOC_LEN)
+		__field(u64, error_count)
+		__field(u32, severity)
+		__dynamic_array(char, msg, MSG_LEN)
+	),
+
+	TP_fast_assign(
+		__entry->error_count = error_count;
+		__entry->severity = severity;
+		__entry->etype = etype;
+		if (dimm_loc[0] != '\0')
+			snprintf(__get_dynamic_array(dimm_info), LOC_LEN - 1,
+				"on %s", dimm_loc);
+		else
+			__assign_str(dimm_info, "");
+		if (phy_addr != 0)
+			snprintf(__get_dynamic_array(msg), MSG_LEN - 1,
+				"(FRU: %pUl %.20s physical addr: 0x%016llx%s)",
+				fru_id, fru_text, phy_addr, mem_loc);
+		else
+			__assign_str(msg, "");
+	),
+
+	TP_printk("%llu %s error%s: %s %s %s",
+			__entry->error_count,
+			cper_severity_str(__entry->severity),
+			__entry->error_count > 1 ? "s" : "",
+			cper_mem_err_type_str(__entry->etype),
+			__get_str(dimm_info),
+			__get_str(msg))
+);
 
 /*
  * Hardware Events Report
-- 
1.8.4.rc3

