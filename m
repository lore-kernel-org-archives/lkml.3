Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3HPX4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 19:56:20 -0400
Received: from mx2.corp.phx1.mozilla.com ([63.245.216.70]:57548 "EHLO
	smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3HPX4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 19:56:03 -0400
From: Jed Davis <jld@mozilla.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Robert Richter <rric@kernel.org>,
        linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net
Cc: Jed Davis <jld@mozilla.com>
Subject: [PATCH v2] x86, perf: Fix arch_perf_out_copy_user and copy_from_user_nmi return values
Date: Fri, 16 Aug 2013 16:44:53 -0700
Message-Id: <1376696693-24798-1-git-send-email-jld@mozilla.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130730131818.GA31198@rric.localhost>
References: <20130730131818.GA31198@rric.localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All architectures except x86 use __copy_from_user_inatomic to provide
arch_perf_out_copy_user; like the other copy_from routines, it returns
the number of bytes not copied.  perf was expecting the number of bytes
that had been copied.  This change corrects that, and thereby allows
PERF_SAMPLE_STACK_USER to be enabled on non-x86 architectures.

x86 uses copy_from_user_nmi, which deviates from the other copy_from
routines by returning the number of bytes copied.  This change therefore
also reverses copy_from_user_nmi's return value, so that the perf change
doesn't break user stack copies on x86, and to help prevent bugs caused
by this surprising difference (and simplify callers, which mostly want
to know if the number of uncopied bytes is nonzero).

Signed-off-by: Jed Davis <jld@mozilla.com>
---
 arch/x86/kernel/cpu/perf_event.c           | 8 ++------
 arch/x86/kernel/cpu/perf_event_intel_ds.c  | 6 ++----
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 4 +---
 arch/x86/lib/usercopy.c                    | 2 +-
 arch/x86/oprofile/backtrace.c              | 8 ++------
 kernel/events/internal.h                   | 9 +++++----
 6 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a7c7305..038c18c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1983,12 +1983,10 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 
 	fp = compat_ptr(ss_base + regs->bp);
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
-		unsigned long bytes;
 		frame.next_frame     = 0;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
-		if (bytes != sizeof(frame))
+		if (copy_from_user_nmi(&frame, fp, sizeof(frame)))
 			break;
 
 		if (!valid_user_frame(fp, sizeof(frame)))
@@ -2035,12 +2033,10 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		return;
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
-		unsigned long bytes;
 		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
-		if (bytes != sizeof(frame))
+		if (copy_from_user_nmi(&frame, fp, sizeof(frame)))
 			break;
 
 		if (!valid_user_frame(fp, sizeof(frame)))
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3065c57..5208fe1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -729,10 +729,8 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 
 		old_to = to;
 		if (!kernel_ip(ip)) {
-			int bytes, size = MAX_INSN_SIZE;
-
-			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
-			if (bytes != size)
+			if (copy_from_user_nmi(buf, (void __user *)to,
+					       MAX_INSN_SIZE))
 				return 0;
 
 			kaddr = buf;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d5be06a..2833514 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -449,7 +449,6 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 {
 	struct insn insn;
 	void *addr;
-	int bytes, size = MAX_INSN_SIZE;
 	int ret = X86_BR_NONE;
 	int ext, to_plm, from_plm;
 	u8 buf[MAX_INSN_SIZE];
@@ -477,8 +476,7 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 			return X86_BR_NONE;
 
 		/* may fail if text not present */
-		bytes = copy_from_user_nmi(buf, (void __user *)from, size);
-		if (bytes != size)
+		if (copy_from_user_nmi(buf, (void __user *)from, MAX_INSN_SIZE))
 			return X86_BR_NONE;
 
 		addr = buf;
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 4f74d94..7a13c98 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -44,6 +44,6 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 
 	} while (len < n);
 
-	return len;
+	return n - len;
 }
 EXPORT_SYMBOL_GPL(copy_from_user_nmi);
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index d6aa6e8..e778d41 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -44,10 +44,8 @@ dump_user_backtrace_32(struct stack_frame_ia32 *head)
 	/* Also check accessibility of one struct frame_head beyond: */
 	struct stack_frame_ia32 bufhead[2];
 	struct stack_frame_ia32 *fp;
-	unsigned long bytes;
 
-	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
-	if (bytes != sizeof(bufhead))
+	if (copy_from_user_nmi(bufhead, head, sizeof(bufhead)))
 		return NULL;
 
 	fp = (struct stack_frame_ia32 *) compat_ptr(bufhead[0].next_frame);
@@ -90,10 +88,8 @@ static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
 {
 	/* Also check accessibility of one struct frame_head beyond: */
 	struct stack_frame bufhead[2];
-	unsigned long bytes;
 
-	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
-	if (bytes != sizeof(bufhead))
+	if (copy_from_user_nmi(bufhead, head, sizeof(bufhead)))
 		return NULL;
 
 	oprofile_add_trace(bufhead[0].return_address);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index ca65997..f77120f 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -81,7 +81,8 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
 }
 
-#define DEFINE_OUTPUT_COPY(func_name, memcpy_func)			\
+/* func_name and copy_func return the number of bytes not copied */
+#define DEFINE_OUTPUT_COPY(func_name, copy_func)			\
 static inline unsigned int						\
 func_name(struct perf_output_handle *handle,				\
 	  const void *buf, unsigned int len)				\
@@ -91,7 +92,7 @@ func_name(struct perf_output_handle *handle,				\
 	do {								\
 		size = min_t(unsigned long, handle->size, len);		\
 									\
-		written = memcpy_func(handle->addr, buf, size);		\
+		written = size - copy_func(handle->addr, buf, size);	\
 									\
 		len -= written;						\
 		handle->addr += written;				\
@@ -113,12 +114,12 @@ func_name(struct perf_output_handle *handle,				\
 static inline int memcpy_common(void *dst, const void *src, size_t n)
 {
 	memcpy(dst, src, n);
-	return n;
+	return 0;
 }
 
 DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
 
-#define MEMCPY_SKIP(dst, src, n) (n)
+#define MEMCPY_SKIP(dst, src, n) (0)
 
 DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
 
-- 
1.8.3.2

