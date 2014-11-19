Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaKSKls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:41:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:12718 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbaKSKlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:41:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,415,1413270000"; 
   d="scan'208";a="634397004"
From: ruiv.wang@gmail.com
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, gong.chen@linux.intel.com, bp@alien8.de,
        rui.y.wang@intel.com
Subject: [PATCH v3] x86/mce: Try printing all machine check banks known before panic
Date: Wed, 19 Nov 2014 17:22:41 +0800
Message-Id: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rui Wang <rui.y.wang@intel.com>

There are cases when an machine check panics without giving any information
about the error:

[  177.806166] Kernel panic - not syncing: Machine check from unknown source

No information besides that it is a machine check. This happens in two cases:
1) The CPU logs the error with the MCi_STATUS.EN bit set to zero, and Linux
   ignores EN=0 entries (as it should).
2) In normal processing the MCE handler ignores banks that do not contain fatal
   or unrecoverable errors (these would later be found and logged by the CMCI
   handler). If we panic, these will never be logged, but could be important
   to diagnose the problem.

This patch aims to record and print all known machine check banks if we
decide to panic.

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   53 +++++++++++++++++++++++++++++++++++--
 1 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 61a9668ce..97cf0b1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -85,6 +85,16 @@ static char			*mce_helper_argv[2] = { mce_helper, NULL };
 static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
 
 static DEFINE_PER_CPU(struct mce, mces_seen);
+
+/*
+ * All valid error banks seen during MCE are temporarily saved here.
+ * There are multiple components which can report an error. For now
+ * 8 might be enough but it's subject to change in the future.
+ */
+#define MAX_ERRORS	8
+static struct mce banks_saved[MAX_ERRORS];
+int	banks_idx;
+
 static int			cpu_missing;
 
 /* CMCI storm detection filter */
@@ -363,6 +373,16 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		pr_emerg(HW_ERR "Some CPUs didn't answer in synchronization\n");
 	if (exp)
 		pr_emerg(HW_ERR "Machine check: %s\n", exp);
+
+	/* Sometimes a CPU signals MCEs with MCi_STATUS.EN bit set to zero;
+	 * sometimes there are CMCI errors not consumed yet. We print them
+	 * here as they could be important to diagnose the problem.
+	 */
+	for (i = 0; i < banks_idx; i++) {
+		pr_emerg_once(HW_ERR "Possibly missed machine check banks:\n");
+		print_mce(&banks_saved[i]);
+	}
+
 	if (!fake_panic) {
 		if (panic_timeout == 0)
 			panic_timeout = mca_cfg.panic_timeout;
@@ -837,6 +857,8 @@ static int mce_start(int *no_way_out)
 		 * Monarch: Starts executing now, the others wait.
 		 */
 		atomic_set(&mce_executing, 1);
+		memset(banks_saved, 0, sizeof(banks_saved));
+		banks_idx = 0;
 	} else {
 		/*
 		 * Subject: Now start the scanning loop one by one in
@@ -1016,7 +1038,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 {
 	struct mca_config *cfg = &mca_cfg;
 	struct mce m, *final;
-	int i;
+	int i, k;
 	int worst = 0;
 	int severity;
 	/*
@@ -1082,6 +1104,33 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if ((m.status & MCI_STATUS_VAL) == 0)
 			continue;
 
+		mce_read_aux(&m, i);
+
+		/*
+		 * Temporarily save all valid banks including those handled
+		 * by CMCIs. If we panic, we can print them. If we don't panic,
+		 * then we can forget them (because we will print them from
+		 * machine_check_poll() sooner  or later). There  are many
+		 * duplications because banks are  shared, only  save each
+		 * distinct error once.
+		 *
+		 * Everything is serialized so no locking/atomics needed.
+		 */
+		for (k = 0; k < banks_idx; k++) {
+			if (banks_saved[k].status == m.status &&
+				banks_saved[k].addr == m.addr &&
+				banks_saved[k].misc == m.misc)
+
+				goto mce_skip;
+		}
+
+		if (banks_idx < MAX_ERRORS)
+			memcpy(&banks_saved[banks_idx++], &m,
+				sizeof(struct mce));
+		else
+			pr_warn_once("mce: MAX_ERRORS too low\n");
+mce_skip:
+
 		/*
 		 * Non uncorrected or non signaled errors are handled by
 		 * machine_check_poll. Leave them alone, unless this panics.
@@ -1112,8 +1161,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 			continue;
 		}
 
-		mce_read_aux(&m, i);
-
 		/*
 		 * Action optional error. Queue address for later processing.
 		 * When the ring overflows we just ignore the AO error.
-- 
1.7.5.4

