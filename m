Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaBQPYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:24:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbaBQPYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:24:01 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 3/4] x86: BUG when ftrace patching recovery fails
Date: Mon, 17 Feb 2014 16:22:52 +0100
Message-Id: <1392650573-3390-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ftrace modifies function calls using Int3 breakpoints on x86.
The breakpoints are handled only when the patching is in progress.
If something goes wrong, there is a recovery code that removes
the breakpoints. If this fails, the system might get silently
rebooted when a remaining break is not handled or an invalid
instruction is proceed.

A better solution is to BUG() when the recovery fails. It helps
to point to the sinner responsible for the reboot.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 30d63c4a4195..525a9f954c8b 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -424,7 +424,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 
 	/* If this does not have a breakpoint, we are done */
 	if (ins[0] != BREAKPOINT_INSTRUCTION)
-		return -1;
+		return 0;
 
 	/* Check if it is nop instruction */
 	valid_ins = ftrace_nop_replace();
@@ -625,8 +625,15 @@ void ftrace_replace_code(int enable)
 	ftrace_bug(ret, rec ? rec->ip : 0);
 	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
 	for_ftrace_rec_iter(iter) {
+		int err;
+
 		rec = ftrace_rec_iter_record(iter);
-		remove_breakpoint(rec);
+		err = remove_breakpoint(rec);
+		/*
+		 * The breakpoints will not be handled after this function
+		 * finishes. Let's stop on a well defined point.
+		 */
+		BUG_ON(err);
 	}
 }
 
-- 
1.8.4

