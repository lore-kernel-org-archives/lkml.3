Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaBXQNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:13:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbaBXQN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:13:29 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 3/3] ftrace/x86: BUG when ftrace recovery fails
Date: Mon, 24 Feb 2014 17:12:22 +0100
Message-Id: <1393258342-29978-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1393258342-29978-1-git-send-email-pmladek@suse.cz>
References: <1393258342-29978-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 69885e2f2095..51dffba12e24 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -425,7 +425,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 
 	/* If this does not have a breakpoint, we are done */
 	if (ins[0] != brk)
-		return -1;
+		return 0;
 
 	nop = ftrace_nop_replace();
 
@@ -632,7 +632,12 @@ void ftrace_replace_code(int enable)
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
@@ -656,16 +661,19 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 	run_sync();
 
 	ret = ftrace_write(ip, new_code, 1);
-	if (ret) {
-		ret = -EPERM;
-		goto out;
-	}
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
1.8.4

