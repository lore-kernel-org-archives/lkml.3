Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3GAKpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:45:52 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64455 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3GAKpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:45:51 -0400
Date: Mon, 1 Jul 2013 12:45:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] x86/ras changes for v3.11
Message-ID: <20130701104546.GA18638@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   HEAD: fb476cffd5e345434c03f3c0e82a7e8d87f98ab0 Merge tag 'please-pull-mce' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/ras

The changes in this tree are:

 - ACPI APEI (ACPI Platform Error Interface) improvements, by Chen Gong

 - misc MCE fixes/cleanups

out-of-topic modifications in x86-ras-for-linus:
------------------------------------------------
drivers/acpi/apei/einj.c           # c5a1303: ACPI/APEI: Add parameter check be
                                   # b8edb64: ACPI, APEI, EINJ: Fix error retur
kernel/resource.c                  # c5a1303: ACPI/APEI: Add parameter check be

 Thanks,

	Ingo

------------------>
Chen Gong (3):
      ACPI/APEI: Add parameter check before error injection
      ACPI/APEI: Update einj documentation for param1/param2
      x86/mce: Update MCE severity condition check

Mathias Krause (1):
      x86, mce: Fix "braodcast" typo

Naveen N. Rao (1):
      mce: acpi/apei: Add comments to clarify usage of the various bitfields in the MCA subsystem

Wei Yongjun (1):
      ACPI, APEI, EINJ: Fix error return code in einj_init()


 Documentation/acpi/apei/einj.txt          |  9 +++++--
 arch/x86/include/asm/mce.h                |  2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c   |  4 ++--
 arch/x86/kernel/cpu/mcheck/mce-severity.c | 15 ++++--------
 arch/x86/kernel/cpu/mcheck/mce.c          |  5 +++-
 arch/x86/kernel/cpu/mcheck/mce_intel.c    | 12 ++++++++++
 drivers/acpi/apei/einj.c                  | 39 ++++++++++++++++++++++++++++---
 kernel/resource.c                         |  1 +
 8 files changed, 68 insertions(+), 19 deletions(-)

diff --git a/Documentation/acpi/apei/einj.txt b/Documentation/acpi/apei/einj.txt
index e20b6da..a58b63d 100644
--- a/Documentation/acpi/apei/einj.txt
+++ b/Documentation/acpi/apei/einj.txt
@@ -47,11 +47,16 @@ directory apei/einj. The following files are provided.
 
 - param1
   This file is used to set the first error parameter value. Effect of
-  parameter depends on error_type specified.
+  parameter depends on error_type specified. For example, if error
+  type is memory related type, the param1 should be a valid physical
+  memory address.
 
 - param2
   This file is used to set the second error parameter value. Effect of
-  parameter depends on error_type specified.
+  parameter depends on error_type specified. For example, if error
+  type is memory related type, the param2 should be a physical memory
+  address mask. Linux requires page or narrower granularity, say,
+  0xfffffffffffff000.
 
 - notrigger
   The EINJ mechanism is a two step process. First inject the error, then
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index fa5f71e..6b52980 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -61,7 +61,7 @@
 #define MCJ_CTX_IRQ		0x2  /* inject context: IRQ */
 #define MCJ_NMI_BROADCAST	0x4  /* do NMI broadcasting */
 #define MCJ_EXCEPTION		0x8  /* raise as exception */
-#define MCJ_IRQ_BRAODCAST	0x10 /* do IRQ broadcasting */
+#define MCJ_IRQ_BROADCAST	0x10 /* do IRQ broadcasting */
 
 #define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index ddc72f8..5ac2d1f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -153,7 +153,7 @@ static void raise_mce(struct mce *m)
 		return;
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	if (m->inject_flags & (MCJ_IRQ_BRAODCAST | MCJ_NMI_BROADCAST)) {
+	if (m->inject_flags & (MCJ_IRQ_BROADCAST | MCJ_NMI_BROADCAST)) {
 		unsigned long start;
 		int cpu;
 
@@ -167,7 +167,7 @@ static void raise_mce(struct mce *m)
 				cpumask_clear_cpu(cpu, mce_inject_cpumask);
 		}
 		if (!cpumask_empty(mce_inject_cpumask)) {
-			if (m->inject_flags & MCJ_IRQ_BRAODCAST) {
+			if (m->inject_flags & MCJ_IRQ_BROADCAST) {
 				/*
 				 * don't wait because mce_irq_ipi is necessary
 				 * to be sync with following raise_local
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index beb1f16..e2703520 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -110,22 +110,17 @@ static struct severity {
 	/* known AR MCACODs: */
 #ifdef	CONFIG_MEMORY_FAILURE
 	MCESEV(
-		KEEP, "HT thread notices Action required: data load error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
-		MCGMASK(MCG_STATUS_EIPV, 0)
+		KEEP, "Action required but unaffected thread is continuable",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR),
+		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
 		),
 	MCESEV(
-		AR, "Action required: data load error",
+		AR, "Action required: data load error in a user process",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
 		USER
 		),
 	MCESEV(
-		KEEP, "HT thread notices Action required: instruction fetch error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
-		MCGMASK(MCG_STATUS_EIPV, 0)
-		),
-	MCESEV(
-		AR, "Action required: instruction fetch error",
+		AR, "Action required: instruction fetch error in a user process",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
 		USER
 		),
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9239504..bf49cdb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -89,7 +89,10 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
-/* MCA banks polled by the period polling timer for corrected events */
+/*
+ * MCA banks polled by the period polling timer for corrected events.
+ * With Intel CMCI, this only has MCA banks which do not support CMCI (if any).
+ */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
 };
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index ae1697c..d5640530 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -24,6 +24,18 @@
  * Also supports reliable discovery of shared banks.
  */
 
+/*
+ * CMCI can be delivered to multiple cpus that share a machine check bank
+ * so we need to designate a single cpu to process errors logged in each bank
+ * in the interrupt handler (otherwise we would have many races and potential
+ * double reporting of the same error).
+ * Note that this can change when a cpu is offlined or brought online since
+ * some MCA banks are shared across cpus. When a cpu is offlined, cmci_clear()
+ * disables CMCI on all banks owned by the cpu and clears this bitfield. At
+ * this point, cmci_rediscover() kicks in and a different cpu may end up
+ * taking ownership of some of the shared MCA banks that were previously
+ * owned by the offlined cpu.
+ */
 static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
 
 /*
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 8d457b5..fb57d03 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -32,6 +32,7 @@
 #include <linux/seq_file.h>
 #include <linux/nmi.h>
 #include <linux/delay.h>
+#include <linux/mm.h>
 #include <acpi/acpi.h>
 
 #include "apei-internal.h"
@@ -41,6 +42,10 @@
 #define SPIN_UNIT		100			/* 100ns */
 /* Firmware should respond within 1 milliseconds */
 #define FIRMWARE_TIMEOUT	(1 * NSEC_PER_MSEC)
+#define ACPI5_VENDOR_BIT	BIT(31)
+#define MEM_ERROR_MASK		(ACPI_EINJ_MEMORY_CORRECTABLE | \
+				ACPI_EINJ_MEMORY_UNCORRECTABLE | \
+				ACPI_EINJ_MEMORY_FATAL)
 
 /*
  * ACPI version 5 provides a SET_ERROR_TYPE_WITH_ADDRESS action.
@@ -367,7 +372,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 	 * This will cause resource conflict with regular memory.  So
 	 * remove it from trigger table resources.
 	 */
-	if ((param_extension || acpi5) && (type & 0x0038) && param2) {
+	if ((param_extension || acpi5) && (type & MEM_ERROR_MASK) && param2) {
 		struct apei_resources addr_resources;
 		apei_resources_init(&addr_resources);
 		trigger_param_region = einj_get_trigger_parameter_region(
@@ -427,7 +432,7 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 		struct set_error_type_with_address *v5param = einj_param;
 
 		v5param->type = type;
-		if (type & 0x80000000) {
+		if (type & ACPI5_VENDOR_BIT) {
 			switch (vendor_flags) {
 			case SETWA_FLAGS_APICID:
 				v5param->apicid = param1;
@@ -512,7 +517,34 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 static int einj_error_inject(u32 type, u64 param1, u64 param2)
 {
 	int rc;
+	unsigned long pfn;
 
+	/*
+	 * We need extra sanity checks for memory errors.
+	 * Other types leap directly to injection.
+	 */
+
+	/* ensure param1/param2 existed */
+	if (!(param_extension || acpi5))
+		goto inject;
+
+	/* ensure injection is memory related */
+	if (type & ACPI5_VENDOR_BIT) {
+		if (vendor_flags != SETWA_FLAGS_MEM)
+			goto inject;
+	} else if (!(type & MEM_ERROR_MASK))
+		goto inject;
+
+	/*
+	 * Disallow crazy address masks that give BIOS leeway to pick
+	 * injection address almost anywhere. Insist on page or
+	 * better granularity and that target address is normal RAM.
+	 */
+	pfn = PFN_DOWN(param1 & param2);
+	if (!page_is_ram(pfn) || ((param2 & PAGE_MASK) != PAGE_MASK))
+		return -EINVAL;
+
+inject:
 	mutex_lock(&einj_mutex);
 	rc = __einj_error_inject(type, param1, param2);
 	mutex_unlock(&einj_mutex);
@@ -590,7 +622,7 @@ static int error_type_set(void *data, u64 val)
 	 * Vendor defined types have 0x80000000 bit set, and
 	 * are not enumerated by ACPI_EINJ_GET_ERROR_TYPE
 	 */
-	vendor = val & 0x80000000;
+	vendor = val & ACPI5_VENDOR_BIT;
 	tval = val & 0x7fffffff;
 
 	/* Only one error type can be specified */
@@ -694,6 +726,7 @@ static int __init einj_init(void)
 	if (rc)
 		goto err_release;
 
+	rc = -ENOMEM;
 	einj_param = einj_get_parameter_address();
 	if ((param_extension || acpi5) && einj_param) {
 		fentry = debugfs_create_x64("param1", S_IRUSR | S_IWUSR,
diff --git a/kernel/resource.c b/kernel/resource.c
index d738698..77bf11a 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -409,6 +409,7 @@ int __weak page_is_ram(unsigned long pfn)
 {
 	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
 }
+EXPORT_SYMBOL_GPL(page_is_ram);
 
 void __weak arch_remove_reservations(struct resource *avail)
 {
