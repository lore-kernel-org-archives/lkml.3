Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3JYNbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:31:36 -0400
Received: from ip-77-221-165-120.dsl.twang.net ([77.221.165.120]:54210 "EHLO
	hsia.quadriga.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752117Ab3JYNbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:31:34 -0400
X-Greylist: delayed 1472 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Oct 2013 09:31:34 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: x86@kernel.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        joe@perches.com
Subject: [PATCH -resend 1/1] dumpstack: fix printk_address for direct addresses
Date: Fri, 25 Oct 2013 15:06:58 +0200
Message-Id: <1382706418-8435-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider modules like this:
static int my_init(void)
{
  char *map = (void *)0x5;
  *map = 3;
  return 0;
}
module_init(my_init);

When we turn off FRAME_POINTERs, the very first instruction in that
function causes a BUG. The problem is that we print IP in the BUG
report using %pB (from printk_address). And %pB decrements the pointer
by one to fix printing addresses of functions with tail calls. This
was added in commit 71f9e59800e5ad4e6b683348424c9fe54306cd43 (x86,
dumpstack: Use %pB format specifier for stack trace) to fix the call
stack printouts.

So instead of correct output:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000005
IP: [<ffffffffa01ac000>] my_init+0x0/0x10 [pb173]

We get:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000005
IP: [<ffffffffa0152000>] 0xffffffffa0151fff

To fix that, we use %pS only for stack addresses printouts (via newly
added printk_stack_address) and %pB for regs->ip (via printk_address).
I.e. we revert to the old behaviour for all except call stacks. And
since from all those reliable is 1, we remove that parameter from
printk_address.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: joe@perches.com
---

I sent this patch 2 weeks ago. Only Joe commented that the prints
should be done inline instead. But I don't agree as prining the output
from one point is better IMHO.

So after discussing what to do with this patch with Ingo, I am
re-sending. 

Opinions?

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
index 45ab4d6..176ad94 100644
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
index 9126dfb..019b6ec 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -402,7 +402,7 @@ static void uv_nmi_dump_cpu_ip(int cpu, struct pt_regs *regs)
 	printk(KERN_DEFAULT "UV: %4d %6d %-32.32s ",
 		cpu, current->pid, current->comm);
 
-	printk_address(regs->ip, 1);
+	printk_address(regs->ip);
 }
 
 /* Dump this cpu's state */
-- 
1.8.4

