Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3JKGrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:47:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:61034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab3JKGrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1078,1371106800"; 
   d="scan'208";a="409269370"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output format
Date: Fri, 11 Oct 2013 02:32:45 -0400
Message-Id: <1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep up only the most important fields for memory error
reporting. The detail information will be moved to perf/trace
interface.

Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/apei/cper.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index 2a4389f..567410e 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -206,29 +206,29 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
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
@@ -296,15 +296,6 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 }
 
-static const char *cper_estatus_section_flag_strs[] = {
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
@@ -312,11 +303,8 @@ static void cper_estatus_print_section(
 	__u16 severity;
 
 	severity = gdata->error_severity;
-	printk("%s""section: %d, severity: %d, %s\n", pfx, sec_no, severity,
+	printk("%s""sub_event[%d], severity: %s\n", pfx, sec_no,
 	       cper_severity_str(severity));
-	printk("%s""flags: 0x%02x\n", pfx, gdata->flags);
-	cper_print_bits(pfx, gdata->flags, cper_estatus_section_flag_strs,
-			ARRAY_SIZE(cper_estatus_section_flag_strs));
 	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
 		printk("%s""fru_id: %pUl\n", pfx, (uuid_le *)gdata->fru_id);
 	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
@@ -360,10 +348,8 @@ void cper_estatus_print(const char *pfx,
 	int sec_no = 0;
 	__u16 severity;
 
-	printk("%s""Generic Hardware Error Status\n", pfx);
 	severity = estatus->error_severity;
-	printk("%s""severity: %d, %s\n", pfx, severity,
-	       cper_severity_str(severity));
+	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
 	data_len = estatus->data_length;
 	gdata = (struct acpi_generic_data *)(estatus + 1);
 	while (data_len >= sizeof(*gdata)) {
-- 
1.8.4.rc3

