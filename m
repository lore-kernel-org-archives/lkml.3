Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3LCNXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:23:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab3LCNXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:23:21 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v5 4/8] x86: speed up int3-based patching using direct write
Date: Tue,  3 Dec 2013 14:21:23 +0100
Message-Id: <1386076887-2655-5-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
References: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to use text_poke_bp_iter in ftrace, the result was slower than
the original implementation.

It turned out that one difference was in text_poke vs. ftrace_write.
text_poke did many extra operations to make sure that code was read-write
and the change was atomic.

In fact, we do not need the atomic operation inside text_poke_bp_iter because
the modified code is guarded by the int3 handler. The int3 interrupt itself
is added and removed by an atomic operation because we modify only one byte.

Also if we patch many functions, it is more effective to set the whole text code
read-write instead of remapping each address into a helper address space.

This patch adds text_poke_part which is inspired by ftrace_write.
Then it is used in text_poke_bp_iter instead of the slower text_poke.
It adds the limitation that text_poke_bp_iter user is responsible for
setting the patched code read-write.

Note that we can't use it in text_poke because it is not effective
to set the page or two read-write just because patching one piece.

For example, I tried to switch between 7 tracers: blk, branch, function_graph,
wakeup_rt, irqsoff, function, and nop. Every tracer has also been enabled and
disabled. With 100 cycles, I got these times with text_poke:

    real    25m7.380s     25m13.44s     25m9.072s
    user    0m0.004s      0m0.004s      0m0.004s
    sys     0m3.480s      0m3.508s      0m3.420s

and with text_poke_part:

    real    3m23.335s     3m24.422s     3m26.686s
    user    0m0.004s      0m0.004s	0m0.004s
    sys     0m3.724s      0m3.772s	0m3.588s

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/kernel/alternative.c | 67 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2f6088282724..9f8dd4f9e852 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -598,6 +598,51 @@ int __kprobes text_poke(void *addr, const void *opcode, size_t len)
 	return 0;
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
+ * Hence we could use faster code here. See also text_poke_bp_iter below
+ * for more details.
+ *
+ * Note: This function must be called under text_mutex. Also the caller is
+ * responsible for setting the patched code read-write. This is more effective
+ * only when you patch many addresses at the same time.
+ */
+static int text_poke_part(void *addr, const void *opcode, size_t len)
+{
+	int ret;
+
+	/* The patching makes sense only for a text code */
+	if (unlikely((unsigned long)addr < (unsigned long)_text) ||
+	    unlikely((unsigned long)addr >= (unsigned long)_etext))
+		return -EFAULT;
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
+	/*
+	 * On x86_64, the kernel text mapping is always mapped read-only with
+	 * CONFIG_DEBUG_RODATA. Instead, we need to use the kernel identity
+	 * mapping that can be set read-write, for example using
+	 * set_kernel_text_rw().
+	 */
+	addr = __va(__pa_symbol(addr));
+#endif
+
+	ret = probe_kernel_write(addr, opcode, len);
+	if (unlikely(ret))
+		return -EPERM;
+
+	sync_core();
+	return 0;
+}
+
 static void do_sync_core(void *info)
 {
 	sync_core();
@@ -752,7 +797,7 @@ static int add_iter_breakpoint(struct text_poke_bp_iter *iterator,
 
 	if (likely(!ret))
 		/* write the breakpoint */
-		ret = text_poke(addr, &bp_int3, sizeof(bp_int3));
+		ret = text_poke_part(addr, &bp_int3, sizeof(bp_int3));
 
 	return ret;
 }
@@ -770,9 +815,9 @@ static int update_iter_code(struct text_poke_bp_iter *iterator,
 
 	/* write all but the first byte */
 	addr = iterator->get_addr(iter);
-	return text_poke(addr + sizeof(bp_int3),
-			 opcode + sizeof(bp_int3),
-			 bp_int3_len - sizeof(bp_int3));
+	return text_poke_part(addr + sizeof(bp_int3),
+			      opcode + sizeof(bp_int3),
+			      bp_int3_len - sizeof(bp_int3));
 }
 
 static int finish_iter_update(struct text_poke_bp_iter *iterator,
@@ -786,7 +831,7 @@ static int finish_iter_update(struct text_poke_bp_iter *iterator,
 	if (opcode) {
 		/* write the first byte if defined */
 		addr = iterator->get_addr(iter);
-		ret = text_poke(addr, opcode, sizeof(bp_int3));
+		ret = text_poke_part(addr, opcode, sizeof(bp_int3));
 	}
 
 	/* Patching has finished. Let's update the status flag if any. */
@@ -822,9 +867,9 @@ static void recover_iter(struct text_poke_bp_iter *iterator,
 	if (memcmp(actual + sizeof(bp_int3),
 		   old_opcode + sizeof(bp_int3),
 		   bp_int3_len - sizeof(bp_int3)) != 0) {
-		err = text_poke(addr + sizeof(bp_int3),
-				old_opcode + sizeof(bp_int3),
-				bp_int3_len - sizeof(bp_int3));
+		err = text_poke_part(addr + sizeof(bp_int3),
+				     old_opcode + sizeof(bp_int3),
+				     bp_int3_len - sizeof(bp_int3));
 		/* we should not continue if recovering has failed */
 		BUG_ON(err);
 		/*
@@ -836,7 +881,7 @@ static void recover_iter(struct text_poke_bp_iter *iterator,
 	}
 
 	/* Finally, put back the first byte from the old code */
-	err = text_poke(addr, old_opcode, sizeof(bp_int3));
+	err = text_poke_part(addr, old_opcode, sizeof(bp_int3));
 	/* we can not continue if the interrupt is still there */
 	BUG_ON(err);
 }
@@ -864,7 +909,9 @@ static void recover_iter(struct text_poke_bp_iter *iterator,
  * It is a bit more paranoid than text_poke_bp because it checks the actual
  * code before patching. This is a good practice proposed by the ftrace code.
  *
- * Note: This function must be called under text_mutex.
+ * Note: This function must be called under text_mutex. Also the caller is
+ * responsible for making the patched code read-write, for example using
+ * set_kernel_text_rw() and set_all_modules_text_rw()
  */
 int text_poke_bp_list(struct text_poke_bp_iter *iterator)
 {
-- 
1.8.4

