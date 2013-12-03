Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3LCNYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:24:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab3LCNYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:24:02 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v5 6/8] x86: modify ftrace function using the new int3-based framework
Date: Tue,  3 Dec 2013 14:21:25 +0100
Message-Id: <1386076887-2655-7-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
References: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit fd4363fff3d9 (x86: Introduce int3 (breakpoint)-based instruction
patching) uses the same technique that has been used in ftrace since 08d636b
("ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine")

It would be great to use the new generic implementation and clean up the x86
ftrace code a bit.

Let's start with ftrace_modify_code. It does basically the same as text_poke_bp.
In addition, it checks whether the replaced code is the expected one to avoid
problems with modules. The checking code can be split from
ftrace_modify_code_direct.

Note that we do not longer need to set modifying_ftrace_code in
ftrace_update_ftrace_func. The int3 interrupt will be handled by
poke_int3_handler.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 120 +++++++++++++++++++----------------------------
 1 file changed, 47 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d4bdd253fea7..5ade40e4a175 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -52,6 +52,33 @@ union ftrace_code_union {
 	} __attribute__((packed));
 };
 
+/*
+ * Note: Due to modules and __init, code can
+ *  disappear and change, we need to protect against faulting
+ *  as well as code changing. We do this by using the
+ *  probe_kernel_* functions.
+ */
+static int
+ftrace_check_code(unsigned long ip, unsigned const char *expected)
+{
+	unsigned char actual[MCOUNT_INSN_SIZE];
+
+	if (probe_kernel_read(actual, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	if (memcmp(actual, expected, MCOUNT_INSN_SIZE) != 0) {
+		WARN_ONCE(1,
+			  "ftrace check failed: %x %x%x%x%x vs. %x %x%x%x%x\n",
+			  actual[0],
+			  actual[1], actual[2], actual[3], actual[4],
+			  expected[0],
+			  expected[1], expected[2], expected[3], expected[4]);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
@@ -103,28 +130,12 @@ static int
 ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
 		   unsigned const char *new_code)
 {
-	unsigned char replaced[MCOUNT_INSN_SIZE];
-
-	/*
-	 * Note: Due to modules and __init, code can
-	 *  disappear and change, we need to protect against faulting
-	 *  as well as code changing. We do this by using the
-	 *  probe_kernel_* functions.
-	 *
-	 * No real locking needed, this code is run through
-	 * kstop_machine, or before SMP starts.
-	 */
+	int ret;
 
-	/* read the text we want to modify */
-	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
-		return -EFAULT;
-
-	/* Make sure it is what we expect it to be */
-	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
-		return -EINVAL;
+	ret = ftrace_check_code(ip, old_code);
 
 	/* replace the text with the new text */
-	if (do_ftrace_mod_code(ip, new_code))
+	if (!ret && do_ftrace_mod_code(ip, new_code))
 		return -EPERM;
 
 	sync_core();
@@ -132,6 +143,22 @@ ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
 	return 0;
 }
 
+static int
+ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+		   unsigned const char *new_code)
+{
+	int ret;
+
+	ret = ftrace_check_code(ip, old_code);
+
+	/* replace the text with the new text */
+	if (!ret)
+		ret = text_poke_bp((void *)ip, new_code, MCOUNT_INSN_SIZE,
+				   (void *)ip + MCOUNT_INSN_SIZE);
+
+	return ret;
+}
+
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
@@ -202,10 +229,6 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
  */
 atomic_t modifying_ftrace_code __read_mostly;
 
-static int
-ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
-		   unsigned const char *new_code);
-
 /*
  * Should never be called:
  *  As it is only called by __ftrace_replace_code() which is called by
@@ -230,9 +253,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(ip, (unsigned long)func);
 
-	/* See comment above by declaration of modifying_ftrace_code */
-	atomic_inc(&modifying_ftrace_code);
-
 	ret = ftrace_modify_code(ip, old, new);
 
 	/* Also update the regs callback function */
@@ -243,20 +263,9 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 		ret = ftrace_modify_code(ip, old, new);
 	}
 
-	atomic_dec(&modifying_ftrace_code);
-
 	return ret;
 }
 
-static int is_ftrace_caller(unsigned long ip)
-{
-	if (ip == (unsigned long)(&ftrace_call) ||
-		ip == (unsigned long)(&ftrace_regs_call))
-		return 1;
-
-	return 0;
-}
-
 /*
  * A breakpoint was added to the code address we are about to
  * modify, and this is the handle that will just skip over it.
@@ -266,13 +275,10 @@ static int is_ftrace_caller(unsigned long ip)
  */
 int ftrace_int3_handler(struct pt_regs *regs)
 {
-	unsigned long ip;
-
 	if (WARN_ON_ONCE(!regs))
 		return 0;
 
-	ip = regs->ip - 1;
-	if (!ftrace_location(ip) && !is_ftrace_caller(ip))
+	if (!ftrace_location(regs->ip - 1))
 		return 0;
 
 	regs->ip += MCOUNT_INSN_SIZE - 1;
@@ -621,38 +627,6 @@ void ftrace_replace_code(int enable)
 	}
 }
 
-static int
-ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
-		   unsigned const char *new_code)
-{
-	int ret;
-
-	ret = add_break(ip, old_code);
-	if (ret)
-		goto out;
-
-	run_sync();
-
-	ret = add_update_code(ip, new_code);
-	if (ret)
-		goto fail_update;
-
-	run_sync();
-
-	ret = ftrace_write(ip, new_code, 1);
-	if (ret) {
-		ret = -EPERM;
-		goto out;
-	}
-	run_sync();
- out:
-	return ret;
-
- fail_update:
-	probe_kernel_write((void *)ip, &old_code[0], 1);
-	goto out;
-}
-
 void arch_ftrace_update_code(int command)
 {
 	/* See comment above by declaration of modifying_ftrace_code */
-- 
1.8.4

