Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3JZNvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:51:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37216 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3JZNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:51:12 -0400
Date: Sat, 26 Oct 2013 06:50:46 -0700
From: tip-bot for Jiri Slaby <tipbot@zytor.com>
Message-ID: <tip-8d4c812a3e5fff476c8900bab19a6af489cbd4be@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        namhyung@gmail.com, jslaby@suse.cz, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jslaby@suse.cz, namhyung@gmail.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1382706418-8435-1-git-send-email-jslaby@suse.cz>
References: <1382706418-8435-1-git-send-email-jslaby@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/dumpstack:
  Fix printk_address for direct addresses
Git-Commit-ID: 8d4c812a3e5fff476c8900bab19a6af489cbd4be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 26 Oct 2013 06:50:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d4c812a3e5fff476c8900bab19a6af489cbd4be
Gitweb:     http://git.kernel.org/tip/8d4c812a3e5fff476c8900bab19a6af489cbd4be
Author:     Jiri Slaby <jslaby@suse.cz>
AuthorDate: Fri, 25 Oct 2013 15:06:58 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 26 Oct 2013 12:19:25 +0200

x86/dumpstack: Fix printk_address for direct addresses

Consider a kernel crash in a module, simulated the following way:

 static int my_init(void)
 {
         char *map = (void *)0x5;
         *map = 3;
         return 0;
 }
 module_init(my_init);

When we turn off FRAME_POINTERs, the very first instruction in
that function causes a BUG. The problem is that we print IP in
the BUG report using %pB (from printk_address). And %pB
decrements the pointer by one to fix printing addresses of
functions with tail calls.

This was added in commit 71f9e59800e5ad4 ("x86, dumpstack: Use
%pB format specifier for stack trace") to fix the call stack
printouts.

So instead of correct output:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000005
  IP: [<ffffffffa01ac000>] my_init+0x0/0x10 [pb173]

We get:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000005
  IP: [<ffffffffa0152000>] 0xffffffffa0151fff

To fix that, we use %pS only for stack addresses printouts (via
newly added printk_stack_address) and %pB for regs->ip (via
printk_address). I.e. we revert to the old behaviour for all
except call stacks. And since from all those reliable is 1, we
remove that parameter from printk_address.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: joe@perches.com
Cc: jirislaby@gmail.com
Link: http://lkml.kernel.org/r/1382706418-8435-1-git-send-email-jslaby@suse.cz
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/kdebug.h |  2 +-
 arch/x86/kernel/dumpstack.c   | 11 ++++++++---
 arch/x86/kernel/process_64.c  |  2 +-
 arch/x86/mm/fault.c           |  2 +-
 arch/x86/platform/uv/uv_nmi.c |  2 +-
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index 2c37aad..32ce713 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -21,7 +21,7 @@ enum die_val {
 	DIE_NMIUNKNOWN,
 };
 
-extern void printk_address(unsigned long address, int reliable);
+extern void printk_address(unsigned long address);
 extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index deb6421..d9c12d3 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -25,12 +25,17 @@ unsigned int code_bytes = 64;
 int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
 static int die_counter;
 
-void printk_address(unsigned long address, int reliable)
+static void printk_stack_address(unsigned long address, int reliable)
 {
 	pr_cont(" [<%p>] %s%pB\n",
 		(void *)address, reliable ? "" : "? ", (void *)address);
 }
 
+void printk_address(unsigned long address)
+{
+	pr_cont(" [<%p>] %pS\n", (void *)address, (void *)address);
+}
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static void
 print_ftrace_graph_addr(unsigned long addr, void *data,
@@ -151,7 +156,7 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
 	touch_nmi_watchdog();
 	printk(data);
-	printk_address(addr, reliable);
+	printk_stack_address(addr, reliable);
 }
 
 static const struct stacktrace_ops print_trace_ops = {
@@ -281,7 +286,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 #else
 	/* Executive summary in case the oops scrolled away */
 	printk(KERN_ALERT "RIP ");
-	printk_address(regs->ip, 1);
+	printk_address(regs->ip);
 	printk(" RSP <%016lx>\n", regs->sp);
 #endif
 	return 0;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index bb1dc51..8e9fe8d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -63,7 +63,7 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned int ds, cs, es;
 
 	printk(KERN_DEFAULT "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
-	printk_address(regs->ip, 1);
+	printk_address(regs->ip);
 	printk(KERN_DEFAULT "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
 			regs->sp, regs->flags);
 	printk(KERN_DEFAULT "RAX: %016lx RBX: %016lx RCX: %016lx\n",
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3aaeffc..18feeb3 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -596,7 +596,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 	printk(KERN_CONT " at %p\n", (void *) address);
 	printk(KERN_ALERT "IP:");
-	printk_address(regs->ip, 1);
+	printk_address(regs->ip);
 
 	dump_pagetable(address);
 }
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 9b8ac60..d3d0268 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -406,7 +406,7 @@ static void uv_nmi_dump_cpu_ip(int cpu, struct pt_regs *regs)
 	printk(KERN_DEFAULT "UV: %4d %6d %-32.32s ",
 		cpu, current->pid, current->comm);
 
-	printk_address(regs->ip, 1);
+	printk_address(regs->ip);
 }
 
 /* Dump this cpu's state */
