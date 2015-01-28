Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004AbbA1WWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:22:14 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:58702 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbbA1ULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:11:51 -0500
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [PATCH] debug: prevent entering debug mode on panic/exception.
Date: Wed, 28 Jan 2015 17:02:14 +0530
Message-Id: <1422444734-29510-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

debug: prevent entering debug mode on panic/exception.

On non-developer devices, kgdb prevents the device from rebooting
after a panic.

Incase of panics and exceptions, to allow the device to reboot, prevent entering
debug mode to avoid getting stuck waiting for the user to interact with debugger.

To avoid entering the debugger on panic/exception without any extra configuration,
panic_timeout is being used which can be set via /proc/sys/kernel/panic at run time
and CONFIG_PANIC_TIMEOUT sets the default value.

Setting panic_timeout indicates that the user requested machine to perform
unattended reboot after panic. We dont want to get stuck waiting for the user
input incase of panic.

Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Colin Cross <ccross@android.com>
[Kiran: Added context to commit message.
panic_timeout is used instead of break_on_panic and
break_on_exception to honor CONFIG_PANIC_TIMEOUT
Modified the commit as per community feedback]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
---
PATCH:
Upgraded to PATCH from RFC.

v5:
Updated the commit message to indicate that panic_timeout indicates that user
requested machine to perform unatteneded reboot after panic.

v4:
As per Andrew's comment, simplified the commit message so that someone who
can't understand kgdb can understand the purpose of the patch

v3:
As per Daniel's comment,improved the comments to indicate how we are avoiding
getting stuck waiting for user input.

v2:
used panic_timeout instead of module params used in original android patch.
Updated the comments accordingly.

v1:
Initial patch sent for internal review.

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

