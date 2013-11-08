Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3KHJNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:13:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab3KHJNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:13:42 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v2 1/8] x86: speed up int3-based patching using less paranoid write
Date: Fri,  8 Nov 2013 10:12:05 +0100
Message-Id: <1383901932-1945-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383901932-1945-1-git-send-email-pmladek@suse.cz>
References: <1383901932-1945-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is inspired by the int3-based patching code used in
ftrace. See the commit fd4363fff3d9 (x86: Introduce int3
(breakpoint)-based instruction patching).

When trying to use text_poke_bp in ftrace, the result was slower than
the original implementation.

It turned out that one difference was in text_poke vs. ftrace_write.
text_poke did many extra operations to make sure that the change
was atomic.

In fact, we do not need this luxury in text_poke_bp because
the modified code is guarded by the int3 handler. The int3
interrupt itself is added and removed by an atomic operation
because we modify only one byte.

This patch adds text_poke_part which is inspired by ftrace_write.
Then it is used in text_poke_bp instead of the paranoid text_poke.

For example, I tried to switch between 7 tracers: blk, branch,
function_graph, wakeup_rt, irqsoff, function, and nop. Every tracer
has also been enabled and disabled. With 100 cycles, I got these
times with text_poke:

    real    25m7.380s     25m13.44s     25m9.072s
    user    0m0.004s      0m0.004s      0m0.004s
    sys     0m3.480s      0m3.508s      0m3.420s

and with text_poke_part:

    real    3m23.335s     3m24.422s     3m26.686s
    user    0m0.004s      0m0.004s	0m0.004s
    sys     0m3.724s      0m3.772s	0m3.588s

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/alternative.c | 49 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df94598..0586dc1 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -8,6 +8,7 @@
 #include <linux/kprobes.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/uaccess.h>
 #include <linux/memory.h>
 #include <linux/stop_machine.h>
 #include <linux/slab.h>
@@ -586,6 +587,44 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	return addr;
 }
 
+/**
+ * text_poke_part - Update part of the instruction on a live kernel when using
+ * 		    int3 breakpoint
+ * @addr:   address to modify
+ * @opcode: source of the copy
+ * @len:    length to copy
+ *
+ * If we patch instructions using int3 interrupt, we do not need to be so
+ * careful about an atomic write. Adding and removing the interrupt is atomic
+ * because we modify only one byte. The rest of the instruction could be
+ * modified in several steps because it is guarded by the interrupt handler.
+ * Hence we could use faster code here. See also text_poke_bp below for more
+ * details.
+ *
+ * Note: Must be called under text_mutex.
+ */
+static int text_poke_part(void *addr, const void *opcode, size_t len)
+{
+	/*
+	 * On x86_64, kernel text mappings are mapped read-only with
+	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
+	 * of the kernel text mapping to modify the kernel text.
+	 *
+	 * For 32bit kernels, these mappings are same and we can use
+	 * kernel identity mapping to modify code.
+	 */
+	if (((unsigned long)addr >= (unsigned long)_text) &&
+	    ((unsigned long)addr < (unsigned long)_etext))
+		addr = __va(__pa_symbol(addr));
+
+	if (probe_kernel_write(addr, opcode, len))
+		return -EPERM;
+
+	sync_core();
+
+	return 0;
+}
+
 static void do_sync_core(void *info)
 {
 	sync_core();
@@ -648,15 +687,15 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	 */
 	smp_wmb();
 
-	text_poke(addr, &int3, sizeof(int3));
+	text_poke_part(addr, &int3, sizeof(int3));
 
 	on_each_cpu(do_sync_core, NULL, 1);
 
 	if (len - sizeof(int3) > 0) {
 		/* patch all but the first byte */
-		text_poke((char *)addr + sizeof(int3),
-			  (const char *) opcode + sizeof(int3),
-			  len - sizeof(int3));
+		text_poke_part((char *)addr + sizeof(int3),
+			       (const char *) opcode + sizeof(int3),
+			       len - sizeof(int3));
 		/*
 		 * According to Intel, this core syncing is very likely
 		 * not necessary and we'd be safe even without it. But
@@ -666,7 +705,7 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	}
 
 	/* patch the first byte */
-	text_poke(addr, opcode, sizeof(int3));
+	text_poke_part(addr, opcode, sizeof(int3));
 
 	on_each_cpu(do_sync_core, NULL, 1);
 
-- 
1.8.4

