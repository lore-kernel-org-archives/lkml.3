Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaKRMJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:09:33 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39822 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaKRMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:09:32 -0500
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC] debug: add parameters to prevent entering debug mode on errors
Date: Tue, 18 Nov 2014 17:38:36 +0530
Message-Id: <1416312516-4551-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

debug: add parameters to prevent entering debug mode on errors

On non-developer devices kgdb prevents CONFIG_PANIC_TIMEOUT from rebooting the
device after a panic. Add module parameters debug_core.break_on_exception and
debug_core.break_on_panic to allow skipping debug on panics and exceptions
respectively.  Both default to true to preserve existing behavior.

Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Colin Cross <ccross@android.com>
[Kiran: Added context to commit message]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
This is one of the number of patches from the Android AOSP common.git tree,
which is used on almost all Android devices.  I wanted to submit it for review
to see if it should go upstream.

 kernel/debug/debug_core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 1adf62b..af06122 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -87,6 +87,10 @@ static int kgdb_use_con;
 bool dbg_is_early = true;
 /* Next cpu to become the master debug core */
 int dbg_switch_cpu;
+/* Flag for entering kdb when a panic occurs */
+static bool break_on_panic = true;
+/* Flag for entering kdb when an exception occurs */
+static bool break_on_exception = true;
 
 /* Use kdb or gdbserver mode */
 int dbg_kdb_mode = 1;
@@ -101,6 +105,8 @@ early_param("kgdbcon", opt_kgdb_con);
 
 module_param(kgdb_use_con, int, 0644);
 module_param(kgdbreboot, int, 0644);
+module_param(break_on_panic, bool, 0644);
+module_param(break_on_exception, bool, 0644);
 
 /*
  * Holds information about breakpoints in a kernel. These breakpoints are
@@ -690,6 +696,9 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 	if (arch_kgdb_ops.enable_nmi)
 		arch_kgdb_ops.enable_nmi(0);
 
+	if (unlikely(signo != SIGTRAP && !break_on_exception))
+		return 1;
+
 	memset(ks, 0, sizeof(struct kgdb_state));
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
@@ -821,6 +830,9 @@ static int kgdb_panic_event(struct notifier_block *self,
 			    unsigned long val,
 			    void *data)
 {
+	if (!break_on_panic)
+		return NOTIFY_DONE;
+
 	if (dbg_kdb_mode)
 		kdb_printf("PANIC: %s\n", (char *)data);
 	kgdb_breakpoint();
-- 
1.8.2.1

