Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaKZJQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:16:45 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40246 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaKZJQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:16:42 -0500
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v3] debug: prevent entering debug mode on errors
Date: Wed, 26 Nov 2014 14:44:26 +0530
Message-Id: <1416993266-16514-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

debug: prevent entering debug mode on errors

On non-developer devices kgdb prevents CONFIG_PANIC_TIMEOUT from rebooting the
device after a panic.

In case of panics and exceptions, to honor CONFIG_PANIC_TIMEOUT, prevent
entering debug mode to avoid getting stuck waiting for the user to interact
with debugger.

Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Colin Cross <ccross@android.com>
[Kiran: Added context to commit message.
panic_timeout is used instead of break_on_panic and
break_on_exception to honor CONFIG_PANIC_TIMEOUT]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
 kernel/debug/debug_core.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 1adf62b..0012a1f 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -689,6 +689,14 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 
 	if (arch_kgdb_ops.enable_nmi)
 		arch_kgdb_ops.enable_nmi(0);
+	/*
+	 * Avoid entering the debugger if we were triggered due to an oops
+	 * but panic_timeout indicates the system should automatically
+	 * reboot on panic. We don't want to get stuck waiting for input
+	 * on such systems, especially if its "just" an oops.
+	 */
+	if (signo != SIGTRAP && panic_timeout)
+		return 1;
 
 	memset(ks, 0, sizeof(struct kgdb_state));
 	ks->cpu			= raw_smp_processor_id();
@@ -821,6 +829,15 @@ static int kgdb_panic_event(struct notifier_block *self,
 			    unsigned long val,
 			    void *data)
 {
+	/*
+	 * Avoid entering the debugger if we were triggered due to a panic
+	 * We don't want to get stuck waiting for input from user in such case.
+	 * panic_timeout indicates the system should automatically
+	 * reboot on panic.
+	 */
+	if (panic_timeout)
+		return NOTIFY_DONE;
+
 	if (dbg_kdb_mode)
 		kdb_printf("PANIC: %s\n", (char *)data);
 	kgdb_breakpoint();
-- 
1.8.2.1

