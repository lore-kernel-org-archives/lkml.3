Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3LPQuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:50:08 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35954 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3LPQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:49:45 -0500
From: jean.pihet@linaro.org
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Arnaldo <acme@ghostprotocols.net>, Will Deacon <will.deacon@arm.com>
Cc: patches@linaro.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 3/3] ARM64: perf: add support for frame pointer unwinding in compat mode
Date: Mon, 16 Dec 2013 17:49:22 +0100
Message-Id: <52af2f28.41590e0a.0251.ffffd957@mx.google.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387212562-8128-1-git-send-email-y>
References: <1387212562-8128-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <jean.pihet@linaro.org>

When profiling a 32-bit application, user space callchain unwinding
using the frame pointer is performed in compat mode. The code is taken
over from the AARCH32 code and adapted to work on AARCH64.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 arch/arm64/kernel/perf_event.c | 75 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 67 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 0e63c98..ac055be 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -1300,8 +1300,8 @@ early_initcall(init_hw_perf_events);
  * Callchain handling code.
  */
 struct frame_tail {
-	struct frame_tail   __user *fp;
-	unsigned long	    lr;
+	struct frame_tail	__user *fp;
+	unsigned long		lr;
 } __attribute__((packed));
 
 /*
@@ -1338,22 +1338,80 @@ user_backtrace(struct frame_tail __user *tail,
 	return buftail.fp;
 }
 
+/*
+ * The registers we're interested in are at the end of the variable
+ * length saved register structure. The fp points at the end of this
+ * structure so the address of this struct is:
+ * (struct compat_frame_tail *)(xxx->fp)-1
+ *
+ * This code has been adapted from the ARM OProfile support.
+ */
+struct compat_frame_tail {
+	compat_uptr_t	fp; // Is a (struct compat_frame_tail *) in compat mode
+	u32		sp;
+	u32		lr;
+} __attribute__((packed));
+
+static struct compat_frame_tail __user *
+compat_user_backtrace(struct compat_frame_tail __user *tail,
+		      struct perf_callchain_entry *entry)
+{
+	struct compat_frame_tail buftail;
+	unsigned long err;
+
+	/* Also check accessibility of one struct frame_tail beyond */
+	if (!access_ok(VERIFY_READ, tail, sizeof(buftail)))
+		return NULL;
+
+	pagefault_disable();
+	err = __copy_from_user_inatomic(&buftail, tail, sizeof(buftail));
+	pagefault_enable();
+
+	if (err)
+		return NULL;
+
+	perf_callchain_store(entry, buftail.lr);
+
+	/*
+	 * Frame pointers should strictly progress back up the stack
+	 * (towards higher addresses).
+	 */
+	if (tail + 1 >= (struct compat_frame_tail __user *)
+			compat_ptr(buftail.fp))
+		return NULL;
+
+	return (struct compat_frame_tail __user *)compat_ptr(buftail.fp) - 1;
+}
+
 void perf_callchain_user(struct perf_callchain_entry *entry,
 			 struct pt_regs *regs)
 {
-	struct frame_tail __user *tail;
-
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
 
 	perf_callchain_store(entry, regs->pc);
-	tail = (struct frame_tail __user *)regs->regs[29];
 
-	while (entry->nr < PERF_MAX_STACK_DEPTH &&
-	       tail && !((unsigned long)tail & 0xf))
-		tail = user_backtrace(tail, entry);
+	if (!compat_user_mode(regs)) {
+		/* AARCH64 mode */
+		struct frame_tail __user *tail;
+
+		tail = (struct frame_tail __user *)regs->regs[29];
+
+		while (entry->nr < PERF_MAX_STACK_DEPTH &&
+		       tail && !((unsigned long)tail & 0xf))
+			tail = user_backtrace(tail, entry);
+	} else {
+		/* AARCH32 compat mode */
+		struct compat_frame_tail __user *tail;
+
+		tail = (struct compat_frame_tail __user *)regs->compat_fp - 1;
+
+		while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
+			tail && !((unsigned long)tail & 0x3))
+			tail = compat_user_backtrace(tail, entry);
+	}
 }
 
 /*
@@ -1381,6 +1439,7 @@ void perf_callchain_kernel(struct perf_callchain_entry *entry,
 	frame.fp = regs->regs[29];
 	frame.sp = regs->sp;
 	frame.pc = regs->pc;
+
 	walk_stackframe(&frame, callchain_trace, entry);
 }
 
-- 
1.7.11.7

