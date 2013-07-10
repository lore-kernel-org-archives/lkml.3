Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3GJU0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:26:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab3GJUZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:25:56 -0400
Date: Wed, 10 Jul 2013 22:25:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH 1/2] x86: introduce int3-based instruction patching
In-Reply-To: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a method for run-time instrucntion patching on a live SMP kernel 
based on int3 breakpoint, completely avoiding the need for stop_machine().

The way this is achieved:

	- add a int3 trap to the address that will be patched
	- sync cores
	- update all but the first byte of the patched range
	- sync cores
	- replalace the first byte (int3) by the first byte of
	  replacing opcode
	- sync cores

If any CPU instruction execution would collide with the patching,
it'd be trapped by the int3 breakpoint and redirected to the provided
"handler" (which would typically mean just skipping over the patched
region, acting as "nop" has been there, in case we are doing nop -> jump
and jump -> nop transitions).

Ftrace has been using this very technique since 08d636b ("ftrace/x86:
Have arch x86_64 use breakpoints instead of stop machine") for ages
already, and jump labels are another obvious potential user of this.

Based on activities of Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
a few years ago.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/x86/include/asm/alternative.h |    1 +
 arch/x86/kernel/alternative.c      |  100 ++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                   |    2 +-
 3 files changed, 102 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 58ed6d9..3abf8dd 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -233,6 +233,7 @@ struct text_poke_param {
 };
 
 extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 extern void text_poke_smp_batch(struct text_poke_param *params, int n);
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index c15cf9a..f61242a 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -11,6 +11,7 @@
 #include <linux/memory.h>
 #include <linux/stop_machine.h>
 #include <linux/slab.h>
+#include <linux/kdebug.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
@@ -596,6 +597,105 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	return addr;
 }
 
+static void do_sync_core(void *info)
+{
+	sync_core();
+}
+
+static bool bp_patching_in_progress;
+static void *bp_int3_handler, *bp_int3_addr;
+
+static int int3_notify(struct notifier_block *self, unsigned long val, void *data)
+{
+	struct die_args *args = data;
+	struct pt_regs *regs = args->regs;
+
+	/* bp_patching_in_progress */
+	smp_rmb();
+
+	if (likely(!bp_patching_in_progress))
+		return NOTIFY_DONE;
+
+	/* we are not interested in non-int3 faults and ring > 0 faults */
+	if (val != DIE_INT3 || !regs || user_mode_vm(regs)
+			    || (unsigned long) bp_int3_addr != regs->ip)
+		return NOTIFY_DONE;
+
+	/* set up the specified breakpoint handler */
+	args->regs->ip = (unsigned long) bp_int3_handler;
+
+	return NOTIFY_STOP;
+}
+/*
+ * text_poke_bp() -- update instructions on live kernel on SMP
+ * @addr:	address to patch
+ * @opcode:	opcode of new instruction
+ * @len:	length to copy
+ * @fixup:	address to jump to when the temporary breakpoint is hit
+ *
+
+ * Modify multi-byte instruction by using int3 breakpoint on SMP.
+ * In contrary to text_poke_smp(), we completely avoid stop_machine() here,
+ * and achieve the synchronization using int3 breakpoint.
+ *
+ * The way it is done:
+ *	- add a int3 trap to the address that will be patched
+ *	- sync cores
+ *	- update all but the first byte of the patched range
+ *	- sync cores
+ *	- replalace the first byte (int3) by the first byte of
+ *	  replacing opcode
+ *	- sync cores
+ *
+ * Note: must be called under text_mutex.
+ */
+void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
+{
+	unsigned char int3 = 0xcc;
+
+	bp_int3_handler = handler;
+	bp_int3_addr = (u8 *)addr + sizeof(int3);
+	bp_patching_in_progress = true;
+	/* corresponding read barrier in int3 notifier for
+	 * making sure the in_progress flags is correctly ordered wrt.
+	 * patching */
+	smp_wmb();
+
+	text_poke(addr, &int3, sizeof(int3));
+
+	if (len - sizeof(int3) > 0) {
+		/* patch all but the first byte */
+		text_poke((char *)addr + sizeof(int3),
+			  (const char *) opcode + sizeof(int3),
+			  len - sizeof(int3));
+
+		on_each_cpu(do_sync_core, NULL, 1);
+	}
+
+	/* patch the first byte */
+	text_poke(addr, opcode, sizeof(int3));
+
+	on_each_cpu(do_sync_core, NULL, 1);
+
+	bp_patching_in_progress = false;
+	smp_wmb();
+
+	return addr;
+}
+
+/* this one needs to run before anything else handles it as a
+ * regular exception */
+static struct notifier_block int3_nb = {
+	.priority = 0x7fffffff,
+	.notifier_call = int3_notify
+};
+
+static int __init int3_init (void)
+{
+	return register_die_notifier(&int3_nb);
+}
+
+arch_initcall(int3_init);
 /*
  * Cross-modifying kernel text with stop_machine().
  * This code originally comes from immediate value.
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index bddf3b2..d6db7bd 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1709,7 +1709,7 @@ EXPORT_SYMBOL_GPL(unregister_kprobes);
 
 static struct notifier_block kprobe_exceptions_nb = {
 	.notifier_call = kprobe_exceptions_notify,
-	.priority = 0x7fffffff /* we need to be notified first */
+	.priority = 0x7ffffff0 /* High priority, but not first.  */
 };
 
 unsigned long __weak arch_deref_entry_point(void *entry)
-- 
1.7.3.1

