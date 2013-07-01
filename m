Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3GAPjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:39:01 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59500 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab3GAPi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:38:58 -0400
Subject: [PATCH v3 1/3] mce: acpi/apei: Honour Firmware First for MCA banks
 listed in APEI HEST CMC
To: tony.luck@intel.com, bp@alien8.de
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ying.huang@intel.com
Date: Mon, 01 Jul 2013 21:08:47 +0530
Message-ID: <20130701153847.6197.88582.stgit@localhost.localdomain>
In-Reply-To: <20130701153728.6197.14022.stgit@localhost.localdomain>
References: <20130701153728.6197.14022.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070115-9574-0000-0000-000008897BC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Corrected Machine Check structure (CMC) in HEST has a flag which can be
set by the firmware to indicate to the OS that it prefers to process the
corrected error events first. In this scenario, the OS is expected to not
monitor for corrected errors (through CMCI/polling). Instead, the firmware
notifies the OS on corrected error events through GHES.

Linux already has support for GHES. This patch adds support for parsing CMC
structure and to disable CMCI/polling if the firmware first flag is set.

Further, the list of machine check bank structures at the end of CMC is used
to determine which MCA banks function in FF mode, so that we continue to
monitor error events on the other banks.


Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/x86/include/asm/mce.h                |    3 ++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    3 ++
 arch/x86/kernel/cpu/mcheck/mce.c          |   28 +++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   42 ++++++++++++++++++++++-------
 drivers/acpi/apei/hest.c                  |   37 ++++++++++++++++++++++++++
 5 files changed, 103 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6b52980..680480a 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -188,6 +188,9 @@ extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
 				    const char __user *ubuf,
 				    size_t usize, loff_t *off));
 
+/* Disable CMCI/polling for MCA bank claimed by firmware */
+extern void mce_disable_bank(int bank);
+
 /*
  * Exception handler
  */
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 5b7d4fa..09edd0b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -25,15 +25,18 @@ int mce_severity(struct mce *a, int tolerant, char **msg);
 struct dentry *mce_get_debugfs_dir(void);
 
 extern struct mce_bank *mce_banks;
+extern mce_banks_t mce_banks_ce_disabled;
 
 #ifdef CONFIG_X86_MCE_INTEL
 unsigned long mce_intel_adjust_timer(unsigned long interval);
 void mce_intel_cmci_poll(void);
 void mce_intel_hcpu_update(unsigned long cpu);
+void cmci_disable_bank(int bank);
 #else
 # define mce_intel_adjust_timer mce_adjust_timer_default
 static inline void mce_intel_cmci_poll(void) { }
 static inline void mce_intel_hcpu_update(unsigned long cpu) { }
+static inline void cmci_disable_bank(int bank) { }
 #endif
 
 void mce_timer_kick(unsigned long interval);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9239504..e432213 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -94,6 +94,15 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
 };
 
+/*
+ * MCA banks controlled through firmware first for corrected errors.
+ * This is a global list of banks for which we won't enable CMCI and we
+ * won't poll. Firmware controls these banks and is responsible for
+ * reporting corrected errors through GHES. Uncorrected/recoverable
+ * errors are still notified through a machine check.
+ */
+mce_banks_t mce_banks_ce_disabled;
+
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
 static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
@@ -1932,6 +1941,25 @@ static struct miscdevice mce_chrdev_device = {
 	&mce_chrdev_ops,
 };
 
+static void __mce_disable_bank(void *arg)
+{
+	int bank = *((int *)arg);
+	__clear_bit(bank, __get_cpu_var(mce_poll_banks));
+	cmci_disable_bank(bank);
+}
+
+void mce_disable_bank(int bank)
+{
+	if (bank >= mca_cfg.banks) {
+		pr_warning(FW_BUG 
+			"Ignoring request to disable invalid MCA bank %d.\n",
+			bank);
+		return;
+	}
+	set_bit(bank, mce_banks_ce_disabled);
+	on_each_cpu(__mce_disable_bank, &bank, 1);
+}
+
 /*
  * mce=off Disables machine check
  * mce=no_cmci Disables CMCI
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index ae1697c..488eae3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -191,6 +191,10 @@ static void cmci_discover(int banks)
 		if (test_bit(i, owned))
 			continue;
 
+		/* Skip banks in firmware first mode */
+		if (test_bit(i, mce_banks_ce_disabled))
+			continue;
+
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
 		/* Already owned by someone else? */
@@ -259,6 +263,19 @@ void cmci_recheck(void)
 	local_irq_restore(flags);
 }
 
+/* Caller must hold the lock on cmci_discover_lock */
+static void __cmci_disable_bank(int bank)
+{
+	u64 val;
+
+	if (!test_bit(bank, __get_cpu_var(mce_banks_owned)))
+		return;
+	rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
+	val &= ~MCI_CTL2_CMCI_EN;
+	wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
+	__clear_bit(bank, __get_cpu_var(mce_banks_owned));
+}
+
 /*
  * Disable CMCI on this CPU for all banks it owns when it goes down.
  * This allows other CPUs to claim the banks on rediscovery.
@@ -268,20 +285,12 @@ void cmci_clear(void)
 	unsigned long flags;
 	int i;
 	int banks;
-	u64 val;
 
 	if (!cmci_supported(&banks))
 		return;
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
-	for (i = 0; i < banks; i++) {
-		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
-			continue;
-		/* Disable CMCI */
-		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
-		val &= ~MCI_CTL2_CMCI_EN;
-		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
-		__clear_bit(i, __get_cpu_var(mce_banks_owned));
-	}
+	for (i = 0; i < banks; i++)
+		__cmci_disable_bank(i);
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
@@ -315,6 +324,19 @@ void cmci_reenable(void)
 		cmci_discover(banks);
 }
 
+void cmci_disable_bank(int bank)
+{
+	int banks;
+	unsigned long flags;
+
+	if (!cmci_supported(&banks))
+		return;
+
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	__cmci_disable_bank(bank);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+}
+
 static void intel_init_cmci(void)
 {
 	int banks;
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index f5ef5d5..b108b11 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -36,6 +36,7 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <acpi/apei.h>
+#include <asm/mce.h>
 
 #include "apei-internal.h"
 
@@ -121,6 +122,40 @@ int apei_hest_parse(apei_hest_func_t func, void *data)
 }
 EXPORT_SYMBOL_GPL(apei_hest_parse);
 
+/*
+ * Check if firmware advertises firmware first mode. We need FF bit to be set
+ * along with a set of MC banks which work in FF mode.
+ */
+static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
+{
+	int i;
+	struct acpi_hest_ia_corrected *cmc;
+	struct acpi_hest_ia_error_bank *mc_bank;
+
+	if (hest_hdr->type != ACPI_HEST_TYPE_IA32_CORRECTED_CHECK)
+		return 0;
+
+	cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
+	if (!cmc->enabled)
+		return 0;
+
+	/*
+	 * We expect HEST to provide a list of MC banks that report errors
+	 * in firmware first mode. Otherwise, return non-zero value to
+	 * indicate that we are done parsing HEST.
+	 */
+	if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST) || !cmc->num_hardware_banks)
+		return 1;
+
+	pr_info(HEST_PFX "Enabling Firmware First mode for corrected errors.\n");
+
+	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
+	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
+		mce_disable_bank(mc_bank->bank_number);
+
+	return 1;
+}
+
 struct ghes_arr {
 	struct platform_device **ghes_devs;
 	unsigned int count;
@@ -227,6 +262,8 @@ void __init acpi_hest_init(void)
 		goto err;
 	}
 
+	apei_hest_parse(hest_parse_cmc, NULL);
+
 	if (!ghes_disable) {
 		rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);
 		if (rc)

