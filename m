Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaCMH2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 03:28:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33557 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaCMH2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 03:28:33 -0400
Date: Thu, 13 Mar 2014 00:27:57 -0700
From: tip-bot for Jean Pihet <tipbot@zytor.com>
Message-ID: <tip-a0cb501f9de391077eb18e4675e2be95c3dcf84c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, acme@ghostprotocols.net, jean.pihet@linaro.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, acme@ghostprotocols.net, jean.pihet@linaro.org,
        jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1391451509-31265-3-git-send-email-jean.pihet@linaro.org>
References: <1391451509-31265-3-git-send-email-jean.pihet@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ARM64, perf:
  Add support for frame pointer unwinding in compat mode
Git-Commit-ID: a0cb501f9de391077eb18e4675e2be95c3dcf84c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0cb501f9de391077eb18e4675e2be95c3dcf84c
Gitweb:     http://git.kernel.org/tip/a0cb501f9de391077eb18e4675e2be95c3dcf84c
Author:     Jean Pihet <jean.pihet@linaro.org>
AuthorDate: Mon, 3 Feb 2014 19:18:28 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 12 Mar 2014 13:45:29 +0100

ARM64, perf: Add support for frame pointer unwinding in compat mode

When profiling a 32-bit application, user space callchain
unwinding using the frame pointer is performed in compat mode.
The code is taken over from the AARCH32 code and adapted to work
on AARCH64.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Arnaldo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: patches@linaro.org
Cc: linaro-kernel@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1391451509-31265-3-git-send-email-jean.pihet@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm64/kernel/perf_event.c | 75 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 67 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 5b1cd79..e868c72 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -1348,8 +1348,8 @@ early_initcall(init_hw_perf_events);
  * Callchain handling code.
  */
 struct frame_tail {
-	struct frame_tail   __user *fp;
-	unsigned long	    lr;
+	struct frame_tail	__user *fp;
+	unsigned long		lr;
 } __attribute__((packed));
 
 /*
@@ -1386,22 +1386,80 @@ user_backtrace(struct frame_tail __user *tail,
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
+	compat_uptr_t	fp; /* a (struct compat_frame_tail *) in compat mode */
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
@@ -1429,6 +1487,7 @@ void perf_callchain_kernel(struct perf_callchain_entry *entry,
 	frame.fp = regs->regs[29];
 	frame.sp = regs->sp;
 	frame.pc = regs->pc;
+
 	walk_stackframe(&frame, callchain_trace, entry);
 }
 
