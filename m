Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966151Ab3HHSaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:30:23 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57026 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966068Ab3HHSaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:30:18 -0400
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: tony.luck@intel.com, bp@alien8.de, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        m.chehab@samsung.com
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace event
Date: Thu,  8 Aug 2013 23:57:51 +0530
Message-Id: <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080818-6102-0000-0000-000003FD524F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable memory error trace event in cper.c

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 drivers/acpi/apei/cper.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index 33dc6a0..19a9c0b 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -32,6 +32,10 @@
 #include <linux/pci.h>
 #include <linux/aer.h>
 
+#define CREATE_TRACE_POINTS
+#define TRACE_EVENT_GHES
+#include <trace/events/ras.h>
+
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
@@ -193,8 +197,13 @@ static const char *cper_mem_err_type_strs[] = {
 	"scrub uncorrected error",
 };
 
-static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
+static void cper_print_mem(const char *pfx,
+		const struct acpi_hest_generic_status *estatus,
+		const struct acpi_hest_generic_data *gdata,
+		const struct cper_sec_mem_err *mem)
 {
+	trace_ghes_platform_memory_event(estatus, gdata, mem);
+
 	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
 		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
 	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)
@@ -292,8 +301,10 @@ static const char *apei_estatus_section_flag_strs[] = {
 	"latent error",
 };
 
-static void apei_estatus_print_section(
-	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
+static void apei_estatus_print_section(const char *pfx,
+		const struct acpi_hest_generic_status *estatus,
+		const struct acpi_hest_generic_data *gdata,
+		int sec_no)
 {
 	uuid_le *sec_type = (uuid_le *)gdata->section_type;
 	__u16 severity;
@@ -320,7 +331,7 @@ static void apei_estatus_print_section(
 		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
 		printk("%s""section_type: memory error\n", pfx);
 		if (gdata->error_data_length >= sizeof(*mem_err))
-			cper_print_mem(pfx, mem_err);
+			cper_print_mem(pfx, estatus, gdata, mem_err);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
@@ -355,7 +366,7 @@ void apei_estatus_print(const char *pfx,
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
 	while (data_len > sizeof(*gdata)) {
 		gedata_len = gdata->error_data_length;
-		apei_estatus_print_section(pfx, gdata, sec_no);
+		apei_estatus_print_section(pfx, estatus, gdata, sec_no);
 		data_len -= gedata_len + sizeof(*gdata);
 		gdata = (void *)(gdata + 1) + gedata_len;
 		sec_no++;
-- 
1.8.3.4

