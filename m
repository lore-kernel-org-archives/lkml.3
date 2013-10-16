Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653Ab3JPPLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:11:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:55689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759569Ab3JPPLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:11:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="420062900"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com
Cc: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH v2 8/9] ACPI, APEI, CPER: Cleanup CPER memory error output format
Date: Wed, 16 Oct 2013 10:56:05 -0400
Message-Id: <1381935366-11731-9-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep up only the most important fields for memory error
reporting. The detail information will be moved to perf/trace
interface.

Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/apei/cper.c | 69 +++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index b1a8a55..f5bc227 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -33,6 +33,9 @@
 #include <linux/pci.h>
 #include <linux/aer.h>
 
+#define INDENT_SP	" "
+#define HW_CE_INFO \
+	"Above error has been corrected by h/w and no further action required"
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
@@ -206,29 +209,29 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
 		printk("%s""physical_address_mask: 0x%016llx\n",
 		       pfx, mem->physical_addr_mask);
 	if (mem->validation_bits & CPER_MEM_VALID_NODE)
-		printk("%s""node: %d\n", pfx, mem->node);
+		pr_debug("node: %d\n", mem->node);
 	if (mem->validation_bits & CPER_MEM_VALID_CARD)
-		printk("%s""card: %d\n", pfx, mem->card);
+		pr_debug("card: %d\n", mem->card);
 	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
-		printk("%s""module: %d\n", pfx, mem->module);
+		pr_debug("module: %d\n", mem->module);
 	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
-		printk("%s""rank: %d\n", pfx, mem->rank);
+		pr_debug("rank: %d\n", mem->rank);
 	if (mem->validation_bits & CPER_MEM_VALID_BANK)
-		printk("%s""bank: %d\n", pfx, mem->bank);
+		pr_debug("bank: %d\n", mem->bank);
 	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
-		printk("%s""device: %d\n", pfx, mem->device);
+		pr_debug("device: %d\n", mem->device);
 	if (mem->validation_bits & CPER_MEM_VALID_ROW)
-		printk("%s""row: %d\n", pfx, mem->row);
+		pr_debug("row: %d\n", mem->row);
 	if (mem->validation_bits & CPER_MEM_VALID_COLUMN)
-		printk("%s""column: %d\n", pfx, mem->column);
+		pr_debug("column: %d\n", mem->column);
 	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
-		printk("%s""bit_position: %d\n", pfx, mem->bit_pos);
+		pr_debug("bit_position: %d\n", mem->bit_pos);
 	if (mem->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
-		printk("%s""requestor_id: 0x%016llx\n", pfx, mem->requestor_id);
+		pr_debug("requestor_id: 0x%016llx\n", mem->requestor_id);
 	if (mem->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
-		printk("%s""responder_id: 0x%016llx\n", pfx, mem->responder_id);
+		pr_debug("responder_id: 0x%016llx\n", mem->responder_id);
 	if (mem->validation_bits & CPER_MEM_VALID_TARGET_ID)
-		printk("%s""target_id: 0x%016llx\n", pfx, mem->target_id);
+		pr_debug("target_id: 0x%016llx\n", mem->target_id);
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
 		u8 etype = mem->error_type;
 		printk("%s""error_type: %d, %s\n", pfx, etype,
@@ -296,55 +299,45 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 }
 
-static const char * const cper_estatus_section_flag_strs[] = {
-	"primary",
-	"containment warning",
-	"reset",
-	"error threshold exceeded",
-	"resource not accessible",
-	"latent error",
-};
-
 static void cper_estatus_print_section(
 	const char *pfx, const struct acpi_generic_data *gdata, int sec_no)
 {
 	uuid_le *sec_type = (uuid_le *)gdata->section_type;
 	__u16 severity;
+	char newpfx[64];
 
 	severity = gdata->error_severity;
-	printk("%s""section: %d, severity: %d, %s\n", pfx, sec_no, severity,
+	printk("%s""Error %d, type: %s\n", pfx, sec_no,
 	       cper_severity_str(severity));
-	printk("%s""flags: 0x%02x\n", pfx, gdata->flags);
-	cper_print_bits(pfx, gdata->flags, cper_estatus_section_flag_strs,
-			ARRAY_SIZE(cper_estatus_section_flag_strs));
 	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
 		printk("%s""fru_id: %pUl\n", pfx, (uuid_le *)gdata->fru_id);
 	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
 		printk("%s""fru_text: %.20s\n", pfx, gdata->fru_text);
 
+	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
 	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
 		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
-		printk("%s""section_type: general processor error\n", pfx);
+		printk("%s""section_type: general processor error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*proc_err))
-			cper_print_proc_generic(pfx, proc_err);
+			cper_print_proc_generic(newpfx, proc_err);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
 		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
-		printk("%s""section_type: memory error\n", pfx);
+		printk("%s""section_type: memory error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*mem_err))
-			cper_print_mem(pfx, mem_err);
+			cper_print_mem(newpfx, mem_err);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
 		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
-		printk("%s""section_type: PCIe error\n", pfx);
+		printk("%s""section_type: PCIe error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*pcie))
-			cper_print_pcie(pfx, pcie, gdata);
+			cper_print_pcie(newpfx, pcie, gdata);
 		else
 			goto err_section_too_small;
 	} else
-		printk("%s""section type: unknown, %pUl\n", pfx, sec_type);
+		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
 
 	return;
 
@@ -358,21 +351,25 @@ void cper_estatus_print(const char *pfx,
 	struct acpi_generic_data *gdata;
 	unsigned int data_len, gedata_len;
 	int sec_no = 0;
+	char newpfx[64];
 	__u16 severity;
 
-	printk("%s""Generic Hardware Error Status\n", pfx);
 	severity = estatus->error_severity;
-	printk("%s""severity: %d, %s\n", pfx, severity,
-	       cper_severity_str(severity));
+	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
 	data_len = estatus->data_length;
 	gdata = (struct acpi_generic_data *)(estatus + 1);
+	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
 	while (data_len >= sizeof(*gdata)) {
 		gedata_len = gdata->error_data_length;
-		cper_estatus_print_section(pfx, gdata, sec_no);
+		cper_estatus_print_section(newpfx, gdata, sec_no);
 		data_len -= gedata_len + sizeof(*gdata);
 		gdata = (void *)(gdata + 1) + gedata_len;
 		sec_no++;
 	}
+	if (severity != CPER_SEV_FATAL)
+		printk("%s%s\n", pfx,
+		       "Above error has been corrected by h/w "
+		       "and require no further action");
 }
 EXPORT_SYMBOL_GPL(cper_estatus_print);
 
-- 
1.8.4.rc3

