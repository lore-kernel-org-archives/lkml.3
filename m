Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3F1MEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:04:14 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43947 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3F1MEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:04:12 -0400
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
To: tony.luck@intel.com, bp@alien8.de
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ying.huang@intel.com
Date: Fri, 28 Jun 2013 17:34:02 +0530
Message-ID: <20130628120224.7781.45438.stgit@localhost.localdomain>
In-Reply-To: <20130621072725.GB22006@pd.tnic>
References: <20130621072725.GB22006@pd.tnic>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062811-8256-0000-0000-0000081F5363
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony, Boris,
Here is a patch which implements this technique. Kindly take a look and let me
know what you think.

Thanks,
Naveen

--
If the firmware indicates in GHES error data entry that the error threshold
has exceeded for a corrected error event, then we try to soft-offline the
page.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 drivers/acpi/apei/ghes.c |    7 ++++++
 include/linux/mm.h       |    1 +
 mm/memory-failure.c      |   53 ++++++++++++++++++++++++++++++----------------
 3 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index fcd7d91..17137cf 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -422,6 +422,13 @@ static void ghes_do_proc(struct ghes *ghes,
 				 CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
 			mem_err = (struct cper_sec_mem_err *)(gdata+1);
+			if (sec_sev == GHES_SEV_CORRECTED &&
+			    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
+			    (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
+				unsigned long pfn;
+				pfn = mem_err->physical_addr >> PAGE_SHIFT;
+				soft_memory_failure_queue(pfn, 0, 0);
+			}
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
 
 #ifdef CONFIG_X86_MCE
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e0c8528..f9907d2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1787,6 +1787,7 @@ enum mf_flags {
 };
 extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
+extern void soft_memory_failure_queue(unsigned long pfn, int trapno, int flags);
 extern int unpoison_memory(unsigned long pfn);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ceb0c7f..50caefd 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1222,6 +1222,7 @@ struct memory_failure_entry {
 	unsigned long pfn;
 	int trapno;
 	int flags;
+	bool soft_offline;
 };
 
 struct memory_failure_cpu {
@@ -1233,6 +1234,28 @@ struct memory_failure_cpu {
 
 static DEFINE_PER_CPU(struct memory_failure_cpu, memory_failure_cpu);
 
+void __memory_failure_queue(unsigned long pfn, int trapno, int flags, int soft_offline)
+{
+	struct memory_failure_cpu *mf_cpu;
+	unsigned long proc_flags;
+	struct memory_failure_entry entry = {
+		.pfn =		pfn,
+		.trapno =	trapno,
+		.flags =	flags,
+		.soft_offline = soft_offline
+	};
+
+	mf_cpu = &get_cpu_var(memory_failure_cpu);
+	spin_lock_irqsave(&mf_cpu->lock, proc_flags);
+	if (kfifo_put(&mf_cpu->fifo, &entry))
+		schedule_work_on(smp_processor_id(), &mf_cpu->work);
+	else
+		pr_err("Memory failure: buffer overflow when queuing memory failure at 0x%#lx\n",
+		       pfn);
+	spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
+	put_cpu_var(memory_failure_cpu);
+}
+
 /**
  * memory_failure_queue - Schedule handling memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -1250,28 +1273,19 @@ static DEFINE_PER_CPU(struct memory_failure_cpu, memory_failure_cpu);
  *
  * Can run in IRQ context.
  */
+
 void memory_failure_queue(unsigned long pfn, int trapno, int flags)
 {
-	struct memory_failure_cpu *mf_cpu;
-	unsigned long proc_flags;
-	struct memory_failure_entry entry = {
-		.pfn =		pfn,
-		.trapno =	trapno,
-		.flags =	flags,
-	};
-
-	mf_cpu = &get_cpu_var(memory_failure_cpu);
-	spin_lock_irqsave(&mf_cpu->lock, proc_flags);
-	if (kfifo_put(&mf_cpu->fifo, &entry))
-		schedule_work_on(smp_processor_id(), &mf_cpu->work);
-	else
-		pr_err("Memory failure: buffer overflow when queuing memory failure at 0x%#lx\n",
-		       pfn);
-	spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
-	put_cpu_var(memory_failure_cpu);
+	__memory_failure_queue(pfn, trapno, flags, false);
 }
 EXPORT_SYMBOL_GPL(memory_failure_queue);
 
+void soft_memory_failure_queue(unsigned long pfn, int trapno, int flags)
+{
+	__memory_failure_queue(pfn, trapno, flags, true);
+}
+EXPORT_SYMBOL_GPL(soft_memory_failure_queue);
+
 static void memory_failure_work_func(struct work_struct *work)
 {
 	struct memory_failure_cpu *mf_cpu;
@@ -1286,7 +1300,10 @@ static void memory_failure_work_func(struct work_struct *work)
 		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
 		if (!gotten)
 			break;
-		memory_failure(entry.pfn, entry.trapno, entry.flags);
+		if (entry.soft_offline)
+			soft_offline_page(pfn_to_page(entry.pfn), entry.flags);
+		else
+			memory_failure(entry.pfn, entry.trapno, entry.flags);
 	}
 }
 

