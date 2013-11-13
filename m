Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3KMUrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:47:22 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39756 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3KMUrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:47:14 -0500
Date: Wed, 13 Nov 2013 21:47:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20131113204709.GA32550@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 11f918d3e2d3861b6931e97b3aa778e4984935aa x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error

Two fixes.

 Thanks,

	Ingo

------------------>
Jiri Slaby (1):
      x86/dumpstack: Fix printk_address for direct addresses

Thomas Renninger (1):
      x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error


 arch/x86/include/asm/kdebug.h   |  2 +-
 arch/x86/kernel/dumpstack.c     | 11 ++++++++---
 arch/x86/kernel/microcode_amd.c |  2 +-
 arch/x86/kernel/process_64.c    |  2 +-
 arch/x86/mm/fault.c             |  2 +-
 arch/x86/platform/uv/uv_nmi.c   |  2 +-
 6 files changed, 13 insertions(+), 8 deletions(-)

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
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index af99f71..c3d4cc9 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -431,7 +431,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
 	if (request_firmware(&fw, (const char *)fw_name, device)) {
-		pr_err("failed to load file %s\n", fw_name);
+		pr_debug("failed to load file %s\n", fw_name);
 		goto out;
 	}
 
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
index 7a517bb..e7e1cac 100644
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
index 2e863ad..8eeccba 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -399,7 +399,7 @@ static void uv_nmi_dump_cpu_ip(int cpu, struct pt_regs *regs)
 	printk(KERN_DEFAULT "UV: %4d %6d %-32.32s ",
 		cpu, current->pid, current->comm);
 
-	printk_address(regs->ip, 1);
+	printk_address(regs->ip);
 }
 
 /* Dump this cpu's state */
