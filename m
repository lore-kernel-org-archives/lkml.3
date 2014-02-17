Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaBQPXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:23:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbaBQPXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:23:21 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 1/4] x86: Clean up remove_breakpoint() in ftrace code
Date: Mon, 17 Feb 2014 16:22:50 +0100
Message-Id: <1392650573-3390-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftrace recovery code does not work on x86_64. I tried to
debug it and got a bit confused by remove_breakpoint(). One problem
was reusing the "nop" pointer for different types of code. Also
the combination of two level if-condition and goto was a bit
tricky.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 58 ++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e6253195a301..e7f3f3f565de 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -405,17 +405,16 @@ static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 
 /*
  * On error, we need to remove breakpoints. This needs to
- * be done caefully. If the address does not currently have a
+ * be done carefully. If the address does not currently have a
  * breakpoint, we know we are done. Otherwise, we look at the
- * remaining 4 bytes of the instruction. If it matches a nop
- * we replace the breakpoint with the nop. Otherwise we replace
- * it with the call instruction.
+ * remaining 4 bytes of the instruction. It has to be a valid
+ * code. If not, don't touch the breakpoint, we would just
+ * create a disaster.
  */
 static int remove_breakpoint(struct dyn_ftrace *rec)
 {
 	unsigned char ins[MCOUNT_INSN_SIZE];
-	unsigned char brk = BREAKPOINT_INSTRUCTION;
-	const unsigned char *nop;
+	const unsigned char *valid_ins;
 	unsigned long ftrace_addr;
 	unsigned long ip = rec->ip;
 
@@ -424,38 +423,33 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 		return -EFAULT;
 
 	/* If this does not have a breakpoint, we are done */
-	if (ins[0] != brk)
+	if (ins[0] != BREAKPOINT_INSTRUCTION)
 		return -1;
 
-	nop = ftrace_nop_replace();
+	/* Check if it is nop instruction */
+	valid_ins = ftrace_nop_replace();
+	if (memcmp(&ins[1], &valid_ins[1], MCOUNT_INSN_SIZE - 1) == 0)
+		goto update;
 
-	/*
-	 * If the last 4 bytes of the instruction do not match
-	 * a nop, then we assume that this is a call to ftrace_addr.
-	 */
-	if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0) {
-		/*
-		 * For extra paranoidism, we check if the breakpoint is on
-		 * a call that would actually jump to the ftrace_addr.
-		 * If not, don't touch the breakpoint, we make just create
-		 * a disaster.
-		 */
-		ftrace_addr = get_ftrace_addr(rec);
-		nop = ftrace_call_replace(ip, ftrace_addr);
-
-		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) == 0)
-			goto update;
-
-		/* Check both ftrace_addr and ftrace_old_addr */
-		ftrace_addr = get_ftrace_old_addr(rec);
-		nop = ftrace_call_replace(ip, ftrace_addr);
 
-		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0)
-			return -EINVAL;
-	}
+	/* Or it might be ftrace call instruction */
+	ftrace_addr = get_ftrace_addr(rec);
+	valid_ins = ftrace_call_replace(ip, ftrace_addr);
+	if (memcmp(&ins[1], &valid_ins[1], MCOUNT_INSN_SIZE - 1) == 0)
+		goto update;
+
+	/* Last chance, it might be the old ftrace call instruction */
+	ftrace_addr = get_ftrace_old_addr(rec);
+	valid_ins = ftrace_call_replace(ip, ftrace_addr);
+	if (memcmp(&ins[1], &valid_ins[1], MCOUNT_INSN_SIZE - 1) == 0)
+		goto update;
+
+	/* Hmm, it is an unknown code. Rather bail out. */
+	return -EINVAL;
 
  update:
-	return probe_kernel_write((void *)ip, &nop[0], 1);
+	/* Put back the first byte */
+	return probe_kernel_write((void *)ip, valid_ins, 1);
 }
 
 static int add_update_code(unsigned long ip, unsigned const char *new)
-- 
1.8.4

