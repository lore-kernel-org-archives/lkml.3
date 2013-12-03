Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3LCNYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:24:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab3LCNYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:24:43 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v5 8/8] x86: enable/disable ftrace graph call using new int3-based framework
Date: Tue,  3 Dec 2013 14:21:27 +0100
Message-Id: <1386076887-2655-9-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
References: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more change related to replacing the existing Int3-based framework with
the new generic function introduced by the commit fd4363fff3d9
(x86: Introduce int3 (breakpoint)-based instruction patching)

ftrace_enable_ftrace_graph_caller and ftrace_disable_ftrace_graph_caller
modified the jump target directly without using the int3 guard. It worked
because writing the address was an atomic operation.

We do not really need to use the safe ftrace_modify_code here but it helps
to remove another arch-specific code. The result is more consistent
and better readable code which is might be worth the change.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 63 +++++++++++-------------------------------------
 1 file changed, 14 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 92fe8cac0802..20d20289f402 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -47,7 +47,7 @@ int ftrace_arch_code_modify_post_process(void)
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
 	struct {
-		char e8;
+		char inst;
 		int offset;
 	} __attribute__((packed));
 };
@@ -88,7 +88,7 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static union ftrace_code_union calc;
 
-	calc.e8		= 0xe8;
+	calc.inst	= 0xe8;
 	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
 
 	/*
@@ -98,27 +98,11 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	return calc.code;
 }
 
-static inline int
-within(unsigned long addr, unsigned long start, unsigned long end)
+static void ftrace_jump_replace(union ftrace_code_union *calc,
+				unsigned long ip, unsigned long addr)
 {
-	return addr >= start && addr < end;
-}
-
-static int
-do_ftrace_mod_code(unsigned long ip, const void *new_code)
-{
-	/*
-	 * On x86_64, kernel text mappings are mapped read-only with
-	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
-	 * of the kernel text mapping to modify the kernel text.
-	 *
-	 * For 32bit kernels, these mappings are same and we can use
-	 * kernel identity mapping to modify code.
-	 */
-	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
-		ip = (unsigned long)__va(__pa_symbol(ip));
-
-	return probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE);
+	calc->inst	= 0xe9;
+	calc->offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
 }
 
 static const unsigned char *ftrace_nop_replace(void)
@@ -369,45 +353,26 @@ int __init ftrace_dyn_arch_init(void *data)
 #ifdef CONFIG_DYNAMIC_FTRACE
 extern void ftrace_graph_call(void);
 
-static int ftrace_mod_jmp(unsigned long ip,
-			  int old_offset, int new_offset)
-{
-	unsigned char code[MCOUNT_INSN_SIZE];
-
-	if (probe_kernel_read(code, (void *)ip, MCOUNT_INSN_SIZE))
-		return -EFAULT;
-
-	if (code[0] != 0xe9 || old_offset != *(int *)(&code[1]))
-		return -EINVAL;
-
-	*(int *)(&code[1]) = new_offset;
-
-	if (do_ftrace_mod_code(ip, &code))
-		return -EPERM;
-
-	return 0;
-}
-
 int ftrace_enable_ftrace_graph_caller(void)
 {
 	unsigned long ip = (unsigned long)(&ftrace_graph_call);
-	int old_offset, new_offset;
+	union ftrace_code_union old, new;
 
-	old_offset = (unsigned long)(&ftrace_stub) - (ip + MCOUNT_INSN_SIZE);
-	new_offset = (unsigned long)(&ftrace_graph_caller) - (ip + MCOUNT_INSN_SIZE);
+	ftrace_jump_replace(&old, ip, (unsigned long)(&ftrace_stub));
+	ftrace_jump_replace(&new, ip, (unsigned long)(&ftrace_graph_caller));
 
-	return ftrace_mod_jmp(ip, old_offset, new_offset);
+	return ftrace_modify_code(ip, old.code, new.code);
 }
 
 int ftrace_disable_ftrace_graph_caller(void)
 {
 	unsigned long ip = (unsigned long)(&ftrace_graph_call);
-	int old_offset, new_offset;
+	union ftrace_code_union old, new;
 
-	old_offset = (unsigned long)(&ftrace_graph_caller) - (ip + MCOUNT_INSN_SIZE);
-	new_offset = (unsigned long)(&ftrace_stub) - (ip + MCOUNT_INSN_SIZE);
+	ftrace_jump_replace(&old, ip, (unsigned long)(&ftrace_graph_caller));
+	ftrace_jump_replace(&new, ip, (unsigned long)(&ftrace_stub));
 
-	return ftrace_mod_jmp(ip, old_offset, new_offset);
+	return ftrace_modify_code(ip, old.code, new.code);
 }
 
 #endif /* !CONFIG_DYNAMIC_FTRACE */
-- 
1.8.4

