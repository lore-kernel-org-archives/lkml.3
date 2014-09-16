Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaIPQFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:05:16 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42455 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaIPQFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:05:14 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        keescook@chromium.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        heiko.carstens@de.ibm.com, tglx@linutronix.de,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] parisc: Use secure_computing_strict, not secure_computing
Date: Tue, 16 Sep 2014 09:05:03 -0700
Message-Id: <db9b257536558b5f068e97717bb0f25bcc603ae4.1410883257.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit a4412fc9486e, the secure_computing function is only
available if seccomp filters are implemented by the architecture.
Architectures without seccomp filters use secure_computing_strict
instead.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

This is minimally tested because my cross-compiler toolchain for parisc
is quite broken.  ptrace.c seems to *compile*, but it doesn't assemble.

 arch/parisc/kernel/ptrace.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 3bab72462ab5..5961cc86d6d2 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -270,11 +270,11 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	/* Do the secure computing check first. */
-	if (secure_computing(regs->gr[20])) {
-		/* seccomp failures shouldn't expose any additional code. */
-		return -1;
-	}
+	/*
+	 * Do the secure computing check first. seccomp failures
+	 * shouldn't expose any additional code.
+	 */
+	secure_computing_strict(regs->gr[20]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
-- 
1.9.3

