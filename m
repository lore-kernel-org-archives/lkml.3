Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988Ab3FSR5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:57:35 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37972 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3FSR5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:57:32 -0400
Subject: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA banks
 listed in APEI HEST CMC
To: tony.luck@intel.com, bp@alien8.de
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ying.huang@intel.com
Date: Wed, 19 Jun 2013 23:27:17 +0530
Message-ID: <20130619175438.2852.93449.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061917-9264-0000-0000-000003F984A1
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


- Naveen

--
Changes:
- Incorporated comments from Boris and Tony from the previous thread at
  http://thread.gmane.org/gmane.linux.acpi.devel/60802
- Added patch to disable firmware first mode through a boot option.


Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/x86/include/asm/mce.h                |    3 ++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    3 ++
 arch/x86/kernel/cpu/mcheck/mce.c          |   25 ++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   40 +++++++++++++++++++++++------
 drivers/acpi/apei/hest.c                  |   36 ++++++++++++++++++++++++++
 5 files changed, 99 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index fa5f71e..380fff8 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -188,6 +188,9 @@ extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
 				    const char __user *ubuf,
 				    size_t usize, loff_t *off));
 
+/* Disable CMCI/polling for MCA bank claimed by firmware */
+extern void mce_disable_ce_bank(int bank);
+
 /*
  * Exception handler
  */
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 5b7d4fa..193edc1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -25,6 +25,9 @@ int mce_severity(struct mce *a, int tolerant, char **msg);
 struct dentry *mce_get_debugfs_dir(void);
 
 extern struct mce_bank *mce_banks;
+extern mce_banks_t mce_banks_ce_disabled;
+
+void cmci_disable_bank(int bank);
 
 #ifdef CONFIG_X86_MCE_INTEL
 unsigned long mce_intel_adjust_timer(unsigned long interval);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9239504..9512034 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -94,6 +94,9 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
 };
 
+/* MCA banks controlled through firmware first for corrected errors */
+mce_banks_t mce_banks_ce_disabled;
+
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
 static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
@@ -1932,6 +1935,28 @@ static struct miscdevice mce_chrdev_device = {
 	&mce_chrdev_ops,
 };
 
+static void __mce_disable_ce_bank(void *arg)
+{
+	int bank = *((int *)arg);
+
+	/* Ensure we don't poll this bank */
+	__clear_bit(bank, __get_cpu_var(mce_poll_banks));
+	/* Disable CMCI */
+	cmci_disable_bank(bank);
+}
+
+void mce_disable_ce_bank(int bank)
+{
+	if (bank >= mca_cfg.banks) {
+		pr_warning(FW_BUG 
+			"Ignoring request to disable invalid MCA bank %d.\n",
+			bank);
+		return;
+	}
+	set_bit(bank, mce_banks_ce_disabled);
+	on_each_cpu(__mce_disable_ce_bank, &bank, 1);
+}
+
 /*
  * mce=off Disables machine check
  * mce=no_cmci Disables CMCI
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index ae1697c..78256c0 100644
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
@@ -259,6 +263,20 @@ void cmci_recheck(void)
 	local_irq_restore(flags);
 }
 
+/* Caller must hold the lock on cmci_discover_lock */
+static void __cmci_disable_bank(int bank)
+{
+	u64 val;
+
+	if (!test_bit(bank, __get_cpu_var(mce_banks_owned)))
+		return;
+	/* Disable CMCI */
+	rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
+	val &= ~MCI_CTL2_CMCI_EN;
+	wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
+	__clear_bit(bank, __get_cpu_var(mce_banks_owned));
+}
+
 /*
  * Disable CMCI on this CPU for all banks it owns when it goes down.
  * This allows other CPUs to claim the banks on rediscovery.
@@ -268,19 +286,12 @@ void cmci_clear(void)
 	unsigned long flags;
 	int i;
 	int banks;
-	u64 val;
 
 	if (!cmci_supported(&banks))
 		return;
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
-		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
-			continue;
-		/* Disable CMCI */
-		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
-		val &= ~MCI_CTL2_CMCI_EN;
-		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
-		__clear_bit(i, __get_cpu_var(mce_banks_owned));
+		__cmci_disable_bank(i);
 	}
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
@@ -315,6 +326,19 @@ void cmci_reenable(void)
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
index f5ef5d5..d8c69ba 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -36,6 +36,7 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <acpi/apei.h>
+#include <asm/mce.h>
 
 #include "apei-internal.h"
 
@@ -121,6 +122,39 @@ int apei_hest_parse(apei_hest_func_t func, void *data)
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
+	if (!cmc->enabled || !(cmc->flags & ACPI_HEST_FIRMWARE_FIRST))
+		return 0;
+
+	/*
+	 * We expect HEST to provide a list of MC banks that
+	 * report errors through firmware first mode.
+	 */
+	if (cmc->num_hardware_banks == 0)
+		return 0;
+
+	pr_info(HEST_PFX "Enabling Firmware First mode for corrected errors.\n");
+
+	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
+	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
+		mce_disable_ce_bank(mc_bank->bank_number);
+
+	return 0;
+}
+
 struct ghes_arr {
 	struct platform_device **ghes_devs;
 	unsigned int count;
@@ -227,6 +261,8 @@ void __init acpi_hest_init(void)
 		goto err;
 	}
 
+	apei_hest_parse(hest_parse_cmc, NULL);
+
 	if (!ghes_disable) {
 		rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);
 		if (rc)

