Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3GBLc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:32:58 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:50749 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3GBLc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:32:56 -0400
Subject: Re: [PATCH v3 3/3] mce,
 acpi/apei: Soft-offline a page on firmware GHES notification
To: tony.luck@intel.com, bp@alien8.de
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ying.huang@intel.com
Date: Tue, 02 Jul 2013 17:02:48 +0530
Message-ID: <20130702112424.6401.11586.stgit@localhost.localdomain>
In-Reply-To: <20130701230800.GO23515@pd.tnic>
References: <20130701230800.GO23515@pd.tnic>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070211-3864-0000-0000-000008E59CB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the updated patch. I also added printk_ratelimit() in line with the
rest of the GHES code.

Thanks,
Naveen

--
If the firmware indicates in GHES error data entry that the error threshold
has exceeded for a corrected error event, then we try to soft-offline the
page. This could be called in interrupt context, so we queue this up similar
to how we handle memory failure scenarios.


Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 drivers/acpi/apei/ghes.c |   38 +++++++++++++++++++++++++++++---------
 include/linux/mm.h       |    1 +
 mm/memory-failure.c      |    5 ++++-
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index fcd7d91..74ef688 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -409,6 +409,34 @@ static void ghes_clear_estatus(struct ghes *ghes)
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
 
+static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
+{
+#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
+	int sec_sev = ghes_severity(gdata->error_severity);
+	struct cper_sec_mem_err *mem_err;
+	mem_err = (struct cper_sec_mem_err *)(gdata+1);
+	if (sec_sev == GHES_SEV_CORRECTED &&
+	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
+	    (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
+		unsigned long pfn;
+		pfn = mem_err->physical_addr >> PAGE_SHIFT;
+		if (pfn_valid(pfn))
+			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
+		else if (printk_ratelimit())
+			pr_warning(FW_WARN GHES_PFX
+			"Invalid address in generic error data: %#llx\n",
+			mem_err->physical_addr);
+	}
+	if (sev == GHES_SEV_RECOVERABLE &&
+	    sec_sev == GHES_SEV_RECOVERABLE &&
+	    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+		unsigned long pfn;
+		pfn = mem_err->physical_addr >> PAGE_SHIFT;
+		memory_failure_queue(pfn, 0, 0);
+	}
+#endif
+}
+
 static void ghes_do_proc(struct ghes *ghes,
 			 const struct acpi_hest_generic_status *estatus)
 {
@@ -428,15 +456,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
 						  mem_err);
 #endif
-#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
-			if (sev == GHES_SEV_RECOVERABLE &&
-			    sec_sev == GHES_SEV_RECOVERABLE &&
-			    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
-				unsigned long pfn;
-				pfn = mem_err->physical_addr >> PAGE_SHIFT;
-				memory_failure_queue(pfn, 0, 0);
-			}
-#endif
+			ghes_handle_memory_failure(gdata, sev);
 		}
 #ifdef CONFIG_ACPI_APEI_PCIEAER
 		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e0c8528..958e9efd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1784,6 +1784,7 @@ enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
 	MF_MUST_KILL = 1 << 2,
+	MF_SOFT_OFFLINE = 1 << 3,
 };
 extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ceb0c7f..0d6717e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1286,7 +1286,10 @@ static void memory_failure_work_func(struct work_struct *work)
 		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
 		if (!gotten)
 			break;
-		memory_failure(entry.pfn, entry.trapno, entry.flags);
+		if (entry.flags & MF_SOFT_OFFLINE)
+			soft_offline_page(pfn_to_page(entry.pfn), entry.flags);
+		else
+			memory_failure(entry.pfn, entry.trapno, entry.flags);
 	}
 }
 

