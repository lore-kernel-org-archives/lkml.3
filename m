Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaHNHWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:22:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:28552 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbaHNHWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:22:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,861,1400050800"; 
   d="scan'208";a="584699199"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH v2 3/5] x86, MCE: Remove mce_ring for SRAO error
Date: Thu, 14 Aug 2014 02:49:44 -0400
Message-Id: <1407998986-1834-4-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use unified genpool to save SRAO error events and put AO error
handling in the same notification chain with mce error decoding.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/1406797523-28710-4-git-send-email-gong.chen@linux.intel.com
[ Boris: correct a lot. ]
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/mce.h       |   2 +-
 arch/x86/kernel/cpu/mcheck/mce.c | 110 ++++++++++++++-------------------------
 drivers/acpi/acpi_extlog.c       |   2 +-
 drivers/edac/i7core_edac.c       |   2 +-
 drivers/edac/mce_amd.c           |   2 +-
 drivers/edac/sb_edac.c           |   2 +-
 6 files changed, 43 insertions(+), 77 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 958b90f761e5..a713dabd000b 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -114,7 +114,7 @@ struct mca_config {
 };
 
 extern struct mca_config mca_cfg;
-extern void mce_register_decode_chain(struct notifier_block *nb);
+extern void mce_register_decode_chain(struct notifier_block *nb, bool drain);
 extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
 #include <linux/percpu.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7534cfce43e9..0e64a3c69b2b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -234,11 +234,18 @@ static void drain_mcelog_buffer(void)
 	} while (next != prev);
 }
 
+static struct notifier_block mce_srao_nb;
 
-void mce_register_decode_chain(struct notifier_block *nb)
+void mce_register_decode_chain(struct notifier_block *nb, bool drain)
 {
+	/* Ensure SRAO notifier has the highest priority in the decode chain. */
+	if (nb != &mce_srao_nb && nb->priority == INT_MAX)
+		nb->priority -= 1;
+
 	atomic_notifier_chain_register(&x86_mce_decoder_chain, nb);
-	drain_mcelog_buffer();
+
+	if (drain)
+		drain_mcelog_buffer();
 }
 EXPORT_SYMBOL_GPL(mce_register_decode_chain);
 
@@ -462,61 +469,6 @@ static inline void mce_gather_info(struct mce *m, struct pt_regs *regs)
 	}
 }
 
-/*
- * Simple lockless ring to communicate PFNs from the exception handler with the
- * process context work function. This is vastly simplified because there's
- * only a single reader and a single writer.
- */
-#define MCE_RING_SIZE 16	/* we use one entry less */
-
-struct mce_ring {
-	unsigned short start;
-	unsigned short end;
-	unsigned long ring[MCE_RING_SIZE];
-};
-static DEFINE_PER_CPU(struct mce_ring, mce_ring);
-
-/* Runs with CPU affinity in workqueue */
-static int mce_ring_empty(void)
-{
-	struct mce_ring *r = &__get_cpu_var(mce_ring);
-
-	return r->start == r->end;
-}
-
-static int mce_ring_get(unsigned long *pfn)
-{
-	struct mce_ring *r;
-	int ret = 0;
-
-	*pfn = 0;
-	get_cpu();
-	r = &__get_cpu_var(mce_ring);
-	if (r->start == r->end)
-		goto out;
-	*pfn = r->ring[r->start];
-	r->start = (r->start + 1) % MCE_RING_SIZE;
-	ret = 1;
-out:
-	put_cpu();
-	return ret;
-}
-
-/* Always runs in MCE context with preempt off */
-static int mce_ring_add(unsigned long pfn)
-{
-	struct mce_ring *r = &__get_cpu_var(mce_ring);
-	unsigned next;
-
-	next = (r->end + 1) % MCE_RING_SIZE;
-	if (next == r->start)
-		return -1;
-	r->ring[r->end] = pfn;
-	wmb();
-	r->end = next;
-	return 0;
-}
-
 int mce_available(struct cpuinfo_x86 *c)
 {
 	if (mca_cfg.disabled)
@@ -526,7 +478,7 @@ int mce_available(struct cpuinfo_x86 *c)
 
 static void mce_schedule_work(void)
 {
-	if (!mce_ring_empty())
+	if (!mce_genpool_empty())
 		schedule_work(&mce_work);
 }
 
@@ -553,6 +505,27 @@ static void mce_report_event(struct pt_regs *regs)
 	irq_work_queue(&mce_irq_work);
 }
 
+static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
+				void *data)
+{
+	struct mce *mce = (struct mce *)data;
+	unsigned long pfn;
+
+	if (!mce)
+		return NOTIFY_DONE;
+
+	if (mce->usable_addr && (mce->severity == MCE_AO_SEVERITY)) {
+		pfn = mce->addr >> PAGE_SHIFT;
+		memory_failure(pfn, MCE_VECTOR, 0);
+	}
+
+	return NOTIFY_OK;
+}
+static struct notifier_block mce_srao_nb = {
+	.notifier_call	= srao_decode_notifier,
+	.priority = INT_MAX,
+};
+
 /*
  * Read ADDR and MISC registers.
  */
@@ -1113,15 +1086,10 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 		mce_read_aux(&m, i);
 
-		/*
-		 * Action optional error. Queue address for later processing.
-		 * When the ring overflows we just ignore the AO error.
-		 * RED-PEN add some logging mechanism when
-		 * usable_address or mce_add_ring fails.
-		 * RED-PEN don't ignore overflow for mca_cfg.tolerant == 0
-		 */
-		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
-			mce_ring_add(m.addr >> PAGE_SHIFT);
+		/* assuming valid severity level != 0 */
+		m.severity = severity;
+		m.usable_addr = mce_usable_address(&m);
+		mce_genpool_add(&m);
 
 		mce_log(&m);
 
@@ -1222,14 +1190,11 @@ void mce_notify_process(void)
 /*
  * Action optional processing happens here (picking up
  * from the list of faulting pages that do_machine_check()
- * placed into the "ring").
+ * placed into the genpool).
  */
 static void mce_process_work(struct work_struct *dummy)
 {
-	unsigned long pfn;
-
-	while (mce_ring_get(&pfn))
-		memory_failure(pfn, MCE_VECTOR, 0);
+	mce_genpool_process();
 }
 
 #ifdef CONFIG_X86_MCE_INTEL
@@ -2027,6 +1992,7 @@ __setup("mce", mcheck_enable);
 int __init mcheck_init(void)
 {
 	mcheck_intel_therm_init();
+	mce_register_decode_chain(&mce_srao_nb, false);
 
 	return 0;
 }
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index b3842ffc19ba..07e012e74c1b 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -286,7 +286,7 @@ static int __init extlog_init(void)
 	 */
 	old_edac_report_status = get_edac_report_status();
 	set_edac_report_status(EDAC_REPORTING_DISABLED);
-	mce_register_decode_chain(&extlog_mce_dec);
+	mce_register_decode_chain(&extlog_mce_dec, true);
 	/* enable OS to be involved to take over management from BIOS */
 	((struct extlog_l1_head *)extlog_l1_addr)->flags |= FLAG_OS_OPTIN;
 
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 9cd0b301f81b..7e347c4ce641 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -2432,7 +2432,7 @@ static int __init i7core_init(void)
 	pci_rc = pci_register_driver(&i7core_driver);
 
 	if (pci_rc >= 0) {
-		mce_register_decode_chain(&i7_mce_dec);
+		mce_register_decode_chain(&i7_mce_dec, true);
 		return 0;
 	}
 
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index f78c1c54dbd5..718c41c41f07 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -914,7 +914,7 @@ static int __init mce_amd_init(void)
 
 	pr_info("MCE: In-kernel MCE decoding enabled.\n");
 
-	mce_register_decode_chain(&amd_mce_dec_nb);
+	mce_register_decode_chain(&amd_mce_dec_nb, true);
 
 	return 0;
 }
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index deea0dc9999b..d2dc2929568d 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -2153,7 +2153,7 @@ static int __init sbridge_init(void)
 
 	pci_rc = pci_register_driver(&sbridge_driver);
 	if (pci_rc >= 0) {
-		mce_register_decode_chain(&sbridge_mce_dec);
+		mce_register_decode_chain(&sbridge_mce_dec, true);
 		if (get_edac_report_status() == EDAC_REPORTING_DISABLED)
 			sbridge_printk(KERN_WARNING, "Loading driver, error reporting disabled.\n");
 		return 0;
-- 
2.0.0.rc2

