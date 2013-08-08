Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966137Ab3HHSaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:30:15 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39711 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966091Ab3HHSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:30:10 -0400
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: tony.luck@intel.com, bp@alien8.de, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        m.chehab@samsung.com
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [PATCH 2/3] mce: acpi/apei: trace: Add trace event for ghes memory error
Date: Thu,  8 Aug 2013 23:57:50 +0530
Message-Id: <1375986471-27113-3-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080818-0260-0000-0000-000003710CFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a trace event for memory error event from generic hardware error
source. We expose all members from the generic error status block, the
generic error data and the cper memory error record.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 include/trace/events/ras.h | 157 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
index 4a66142..1d8d404 100644
--- a/include/trace/events/ras.h
+++ b/include/trace/events/ras.h
@@ -73,5 +73,162 @@ TRACE_EVENT(aer_event,
 
 #endif /* _TRACE_AER_H */
 
+#if (!defined(_TRACE_GHES_H) || defined(TRACE_HEADER_MULTI_READ)) && defined(TRACE_EVENT_GHES)
+#define _TRACE_GHES_H
+
+#include <linux/tracepoint.h>
+
+/* Values for generic error status block_status */
+#define estatus_block_status_strs			\
+	{BIT(0),	"uncorrected error"},		\
+	{BIT(1),	"corrected error"},		\
+	{BIT(2),	"multiple uncorrected errors"},	\
+	{BIT(3),	"multiple corrected errors"}
+
+/* Values for error_severity */
+#define error_severity_strs				\
+	{BIT(0),	"recoverable"},			\
+	{BIT(1),	"fatal"},			\
+	{BIT(2),	"corrected"},			\
+	{BIT(3),	"info"}
+
+/* Values for generic error data flags */
+#define gdata_flags_strs				\
+	{BIT(0),	"primary"},			\
+	{BIT(1),	"containment warning"},		\
+	{BIT(2),	"reset"},			\
+	{BIT(3),	"error threshold exceeded"},	\
+	{BIT(4),	"resource not accessible"},	\
+	{BIT(5),	"latent error"}
+
+/* Values for memory error validation bits */
+#define mem_validation_bits_strs			\
+	{BIT(0),	"ERROR_STATUS"},		\
+	{BIT(1),	"PHYSICAL_ADDRESS"},		\
+	{BIT(2),	"PHYSICAL_ADDRESS_MASK"},	\
+	{BIT(3),	"NODE"},			\
+	{BIT(4),	"CARD"},			\
+	{BIT(5),	"MODULE"},			\
+	{BIT(6),	"BANK"},			\
+	{BIT(7),	"DEVICE"},			\
+	{BIT(8),	"ROW"},				\
+	{BIT(9),	"COLUMN"},			\
+	{BIT(10),	"BIT_POSITION"},		\
+	{BIT(11),	"REQUESTOR_ID"},		\
+	{BIT(12),	"RESPONDER_ID"},		\
+	{BIT(13),	"TARGET_ID"},			\
+	{BIT(14),	"ERROR_TYPE"}
+
+/* Values for memory error type */
+#define __show_mem_error_type(type)			\
+	__print_symbolic(type,				\
+		{0,	"unknown"},			\
+		{1,	"no error"},			\
+		{2,	"single-bit ECC"},		\
+		{3,	"multi-bit ECC"},		\
+		{4,	"single-symbol chipkill ECC"},	\
+		{5,	"multi-symbol chipkill ECC"},	\
+		{6,	"master abort"},		\
+		{7,	"target abort"},		\
+		{8,	"parity error"},		\
+		{9,	"watchdog timeout"},		\
+		{10,	"invalid address"},		\
+		{11,	"mirror broken"},		\
+		{12,	"memory sparing"},		\
+		{13,	"scrub corrected error"},	\
+		{14,	"scrub uncorrected error"})
+
+
+TRACE_EVENT(ghes_platform_memory_event,
+	TP_PROTO(const struct acpi_hest_generic_status *estatus,
+		 const struct acpi_hest_generic_data *gdata,
+		 const struct cper_sec_mem_err *mem),
+
+	TP_ARGS(estatus, gdata, mem),
+
+	TP_STRUCT__entry(
+		__field(	u32,	estatus_block_status		)
+		__field(	u32,	estatus_raw_data_offset		)
+		__field(	u32,	estatus_raw_data_length		)
+		__field(	u32,	estatus_data_length		)
+		__field(	u32,	estatus_error_severity		)
+		__array(	u8,	gdata_section_type,	16	)
+		__field(	u32,	gdata_error_severity		)
+		__field(	u16,	gdata_revision			)
+		__field(	u8,	gdata_validation_bits		)
+		__field(	u8,	gdata_flags			)
+		__field(	u32,	gdata_error_data_length		)
+		__array(	u8,	gdata_fru_id,		16	)
+		__array(	u8,	gdata_fru_text,		20	)
+		__field(	u64,	mem_validation_bits		)
+		__field(	u64,	mem_error_status		)
+		__field(	u64,	mem_physical_addr		)
+		__field(	u64,	mem_physical_addr_mask		)
+		__field(	u16,	mem_node			)
+		__field(	u16,	mem_card			)
+		__field(	u16,	mem_module			)
+		__field(	u16,	mem_bank			)
+		__field(	u16,	mem_device			)
+		__field(	u16,	mem_row				)
+		__field(	u16,	mem_column			)
+		__field(	u16,	mem_bit_pos			)
+		__field(	u64,	mem_requestor_id		)
+		__field(	u64,	mem_responder_id		)
+		__field(	u64,	mem_target_id			)
+		__field(	u8,	mem_error_type			)
+	),
+
+	TP_fast_assign(
+		__entry->estatus_block_status		= estatus->block_status;
+		__entry->estatus_raw_data_offset	= estatus->raw_data_offset;
+		__entry->estatus_raw_data_length	= estatus->raw_data_length;
+		__entry->estatus_data_length		= estatus->data_length;
+		__entry->estatus_error_severity		= estatus->error_severity;
+		memcpy(&__entry->gdata_section_type, &gdata->section_type, 16);
+		__entry->gdata_error_severity		= gdata->error_severity;
+		__entry->gdata_revision			= gdata->revision;
+		__entry->gdata_validation_bits		= gdata->validation_bits;
+		__entry->gdata_flags			= gdata->flags;
+		__entry->gdata_error_data_length	= gdata->error_data_length;
+		memcpy(&__entry->gdata_fru_id, &gdata->fru_id, 16);
+		memcpy(&__entry->gdata_fru_text, &gdata->fru_text, 20);
+		__entry->mem_validation_bits		= mem->validation_bits;
+		__entry->mem_error_status		= mem->error_status;
+		__entry->mem_physical_addr		= mem->physical_addr;
+		__entry->mem_physical_addr_mask		= mem->physical_addr_mask;
+		__entry->mem_node			= mem->node;
+		__entry->mem_card			= mem->card;
+		__entry->mem_module			= mem->module;
+		__entry->mem_bank			= mem->bank;
+		__entry->mem_device			= mem->device;
+		__entry->mem_row			= mem->row;
+		__entry->mem_column			= mem->column;
+		__entry->mem_bit_pos			= mem->bit_pos;
+		__entry->mem_requestor_id		= mem->requestor_id;
+		__entry->mem_responder_id		= mem->responder_id;
+		__entry->mem_target_id			= mem->target_id;
+		__entry->mem_error_type			= mem->error_type;
+	),
+
+	TP_printk("%s, event status: %s; generic data entry severity: %s, flags: %s, fru: %.20s, memory error section: validation bits: %s, error status: 0x%016llx, physical addr: 0x%016llx, physical addr mask: 0x%016llx, node: %d, card: %d, module: %d, bank: %d, device: %d, row: %d, column: %d, bit position: %d, requestor id: 0x%016llx, responder id: 0x%016llx, target id: 0x%016llx, error type: %s",
+		__print_flags(__entry->estatus_error_severity, "|", error_severity_strs),
+		__print_flags(__entry->estatus_block_status & 0x0f, "|", estatus_block_status_strs),
+		__print_flags(__entry->gdata_error_severity, "|", error_severity_strs),
+		__entry->gdata_flags ?
+		__print_flags(__entry->gdata_flags, "|", gdata_flags_strs) : "(null)",
+		(__entry->gdata_validation_bits & CPER_SEC_VALID_FRU_TEXT) ?
+		(char *)__entry->gdata_fru_text : "(null)",
+		__entry->mem_validation_bits ?
+		__print_flags(__entry->mem_validation_bits, "|", mem_validation_bits_strs) : "(null)",
+		__entry->mem_error_status, __entry->mem_physical_addr, __entry->mem_physical_addr_mask,
+		__entry->mem_node, __entry->mem_card, __entry->mem_module, __entry->mem_bank,
+		__entry->mem_device, __entry->mem_row, __entry->mem_column, __entry->mem_bit_pos,
+		__entry->mem_requestor_id, __entry->mem_responder_id, __entry->mem_target_id,
+		__show_mem_error_type(__entry->mem_error_type)
+	)
+);
+
+#endif /* _TRACE_GHES_H */
+
 /* This part must be outside protection */
 #include <trace/define_trace.h>
-- 
1.8.3.4

