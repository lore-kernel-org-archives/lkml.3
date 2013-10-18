Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3JRIl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:41:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:36924 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab3JRIjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:39:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,520,1378882800"; 
   d="scan'208";a="309451462"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com
Cc: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH v3 6/9] ACPI, APEI, CPER: Add UEFI 2.4 support for memory error
Date: Fri, 18 Oct 2013 04:23:41 -0400
Message-Id: <1382084624-10857-7-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In latest UEFI spec(by now it is 2.4) memory error definition
for CPER (UEFI 2.4 Appendix N Common Platform Error Record)
adds some new fields. These fields help people to locate
memory error on actual DIMM location.

Original-author: Tony Luck <tony.luck@intel.com>
Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/x86/kernel/cpu/mcheck/mce-apei.c |  3 +--
 drivers/acpi/apei/cper.c              |  7 ++++---
 drivers/acpi/apei/ghes.c              |  4 ++--
 drivers/edac/ghes_edac.c              |  5 ++---
 include/linux/cper.h                  | 11 +++++++++--
 5 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-apei.c b/arch/x86/kernel/cpu/mcheck/mce-apei.c
index cd8b166..de8b60a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-apei.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-apei.c
@@ -42,8 +42,7 @@ void apei_mce_report_mem_error(int corrected, struct cper_sec_mem_err *mem_err)
 	struct mce m;
 
 	/* Only corrected MC is reported */
-	if (!corrected || !(mem_err->validation_bits &
-				CPER_MEM_VALID_PHYSICAL_ADDRESS))
+	if (!corrected || !(mem_err->validation_bits & CPER_MEM_VALID_PA))
 		return;
 
 	mce_setup(&m);
diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index eb5f6d6..946ef52 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -8,7 +8,7 @@
  * various tables, such as ERST, BERT and HEST etc.
  *
  * For more information about CPER, please refer to Appendix N of UEFI
- * Specification version 2.3.
+ * Specification version 2.4.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version
@@ -191,16 +191,17 @@ static const char *cper_mem_err_type_strs[] = {
 	"memory sparing",
 	"scrub corrected error",
 	"scrub uncorrected error",
+	"physical memory map-out event",
 };
 
 static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
 {
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
 		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
-	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)
+	if (mem->validation_bits & CPER_MEM_VALID_PA)
 		printk("%s""physical_address: 0x%016llx\n",
 		       pfx, mem->physical_addr);
-	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK)
+	if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
 		printk("%s""physical_address_mask: 0x%016llx\n",
 		       pfx, mem->physical_addr_mask);
 	if (mem->validation_bits & CPER_MEM_VALID_NODE)
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 0db6e4f..a30bc31 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -419,7 +419,7 @@ static void ghes_handle_memory_failure(struct acpi_generic_data *gdata, int sev)
 
 	if (sec_sev == GHES_SEV_CORRECTED &&
 	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
-	    (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
+	    (mem_err->validation_bits & CPER_MEM_VALID_PA)) {
 		pfn = mem_err->physical_addr >> PAGE_SHIFT;
 		if (pfn_valid(pfn))
 			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
@@ -430,7 +430,7 @@ static void ghes_handle_memory_failure(struct acpi_generic_data *gdata, int sev)
 	}
 	if (sev == GHES_SEV_RECOVERABLE &&
 	    sec_sev == GHES_SEV_RECOVERABLE &&
-	    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+	    mem_err->validation_bits & CPER_MEM_VALID_PA) {
 		pfn = mem_err->physical_addr >> PAGE_SHIFT;
 		memory_failure_queue(pfn, 0, 0);
 	}
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index bb53467..0ad797b 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -297,15 +297,14 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 	}
 
 	/* Error address */
-	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+	if (mem_err->validation_bits & CPER_MEM_VALID_PA) {
 		e->page_frame_number = mem_err->physical_addr >> PAGE_SHIFT;
 		e->offset_in_page = mem_err->physical_addr & ~PAGE_MASK;
 	}
 
 	/* Error grain */
-	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK) {
+	if (mem_err->validation_bits & CPER_MEM_VALID_PA_MASK)
 		e->grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
-	}
 
 	/* Memory error location, mapped on e->location */
 	p = e->location;
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 09ebe21..2fc0ec3 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -218,8 +218,8 @@ enum {
 #define CPER_PROC_VALID_IP			0x1000
 
 #define CPER_MEM_VALID_ERROR_STATUS		0x0001
-#define CPER_MEM_VALID_PHYSICAL_ADDRESS		0x0002
-#define CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK	0x0004
+#define CPER_MEM_VALID_PA			0x0002
+#define CPER_MEM_VALID_PA_MASK			0x0004
 #define CPER_MEM_VALID_NODE			0x0008
 #define CPER_MEM_VALID_CARD			0x0010
 #define CPER_MEM_VALID_MODULE			0x0020
@@ -232,6 +232,9 @@ enum {
 #define CPER_MEM_VALID_RESPONDER_ID		0x1000
 #define CPER_MEM_VALID_TARGET_ID		0x2000
 #define CPER_MEM_VALID_ERROR_TYPE		0x4000
+#define CPER_MEM_VALID_RANK_NUMBER		0x8000
+#define CPER_MEM_VALID_CARD_HANDLE		0x10000
+#define CPER_MEM_VALID_MODULE_HANDLE		0x20000
 
 #define CPER_PCIE_VALID_PORT_TYPE		0x0001
 #define CPER_PCIE_VALID_VERSION			0x0002
@@ -347,6 +350,10 @@ struct cper_sec_mem_err {
 	__u64	responder_id;
 	__u64	target_id;
 	__u8	error_type;
+	__u8	reserved;
+	__u16	rank;
+	__u16	mem_array_handle;	/* card handle in UEFI 2.4 */
+	__u16	mem_dev_handle;		/* module handle in UEFI 2.4 */
 };
 
 struct cper_sec_pcie {
-- 
1.8.4.rc3

