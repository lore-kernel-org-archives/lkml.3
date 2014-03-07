Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaCGPN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:13:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:56534 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753143AbaCGPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:08 -0500
Message-Id: <20140307151204.171814170@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 20/20] ftrace/x86: BUG when ftrace recovery fails
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0020-ftrace-x86-BUG-when-ftrace-recovery-fails.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Mladek <pmladek@suse.cz>

Ftrace modifies function calls using Int3 breakpoints on x86.
The breakpoints are handled only when the patching is in progress.
If something goes wrong, there is a recovery code that removes
the breakpoints. If this fails, the system might get silently
rebooted when a remaining break is not handled or an invalid
instruction is proceed.

We should BUG() when the breakpoint could not be removed. Otherwise,
the system silently crashes when the function finishes the Int3
handler is disabled.

Note that we need to modify remove_breakpoint() to return non-zero
value only when there is an error. The return value was ignored before,
so it does not cause any troubles.

Link: http://lkml.kernel.org/r/1393258342-29978-4-git-send-email-pmladek@suse.cz

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 4b66adf..52819e8 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -425,7 +425,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 
 	/* If this does not have a breakpoint, we are done */
 	if (ins[0] != brk)
-		return -1;
+		return 0;
 
 	nop = ftrace_nop_replace();
 
@@ -625,7 +625,12 @@ void ftrace_replace_code(int enable)
 	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
 	for_ftrace_rec_iter(iter) {
 		rec = ftrace_rec_iter_record(iter);
-		remove_breakpoint(rec);
+		/*
+		 * Breakpoints are handled only when this function is in
+		 * progress. The system could not work with them.
+		 */
+		if (remove_breakpoint(rec))
+			BUG();
 	}
 	run_sync();
 }
@@ -649,12 +654,19 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 	run_sync();
 
 	ret = ftrace_write(ip, new_code, 1);
+	/*
+	 * The breakpoint is handled only when this function is in progress.
+	 * The system could not work if we could not remove it.
+	 */
+	BUG_ON(ret);
  out:
 	run_sync();
 	return ret;
 
  fail_update:
-	ftrace_write(ip, old_code, 1);
+	/* Also here the system could not work with the breakpoint */
+	if (ftrace_write(ip, old_code, 1))
+		BUG();
 	goto out;
 }
 
-- 
1.8.5.3


