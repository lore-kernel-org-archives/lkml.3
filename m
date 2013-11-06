Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3KFNT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:19:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3KFNTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:19:55 -0500
Date: Wed, 6 Nov 2013 05:19:23 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-0a196848ca365ec582c6d86659be456be6d4ed96@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131030201622.GR16117@laptop.programming.kicks-ass.net>
References: <20131030201622.GR16117@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix arch_perf_out_copy_user default
Git-Commit-ID: 0a196848ca365ec582c6d86659be456be6d4ed96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:19:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a196848ca365ec582c6d86659be456be6d4ed96
Gitweb:     http://git.kernel.org/tip/0a196848ca365ec582c6d86659be456be6d4ed96
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 30 Oct 2013 21:16:22 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:34:25 +0100

perf: Fix arch_perf_out_copy_user default

The arch_perf_output_copy_user() default of
__copy_from_user_inatomic() returns bytes not copied, while all other
argument functions given DEFINE_OUTPUT_COPY() return bytes copied.

Since copy_from_user_nmi() is the odd duck out by returning bytes
copied where all other *copy_{to,from}* functions return bytes not
copied, change it over and ammend DEFINE_OUTPUT_COPY() to expect bytes
not copied.

Oddly enough DEFINE_OUTPUT_COPY() already returned bytes not copied
while expecting its worker functions to return bytes copied.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: will.deacon@arm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20131030201622.GR16117@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c           |  4 ++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 +-
 arch/x86/lib/usercopy.c                    |  2 +-
 arch/x86/oprofile/backtrace.c              |  4 ++--
 kernel/events/internal.h                   | 35 ++++++++++++++++++++++--------
 6 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8a87a32..8e13293 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1989,7 +1989,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		frame.return_address = 0;
 
 		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
-		if (bytes != sizeof(frame))
+		if (bytes != 0)
 			break;
 
 		if (!valid_user_frame(fp, sizeof(frame)))
@@ -2041,7 +2041,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		frame.return_address = 0;
 
 		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
-		if (bytes != sizeof(frame))
+		if (bytes != 0)
 			break;
 
 		if (!valid_user_frame(fp, sizeof(frame)))
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index c1760ff..ae96cfa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -789,7 +789,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 
 		size = ip - to; /* Must fit our buffer, see above */
 		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
-		if (bytes != size)
+		if (bytes != 0)
 			return 0;
 
 		kaddr = buf;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 90ee6c1..d82d155 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -491,7 +491,7 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 
 		/* may fail if text not present */
 		bytes = copy_from_user_nmi(buf, (void __user *)from, size);
-		if (bytes != size)
+		if (bytes != 0)
 			return X86_BR_NONE;
 
 		addr = buf;
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 5465b86..ddf9ecb 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -31,6 +31,6 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	ret = __copy_from_user_inatomic(to, from, n);
 	pagefault_enable();
 
-	return n - ret;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(copy_from_user_nmi);
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index d6aa6e8..5d04be5 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -47,7 +47,7 @@ dump_user_backtrace_32(struct stack_frame_ia32 *head)
 	unsigned long bytes;
 
 	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
-	if (bytes != sizeof(bufhead))
+	if (bytes != 0)
 		return NULL;
 
 	fp = (struct stack_frame_ia32 *) compat_ptr(bufhead[0].next_frame);
@@ -93,7 +93,7 @@ static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
 	unsigned long bytes;
 
 	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
-	if (bytes != sizeof(bufhead))
+	if (bytes != 0)
 		return NULL;
 
 	oprofile_add_trace(bufhead[0].return_address);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index ca65997..569b2187 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -82,16 +82,16 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
 }
 
 #define DEFINE_OUTPUT_COPY(func_name, memcpy_func)			\
-static inline unsigned int						\
+static inline unsigned long						\
 func_name(struct perf_output_handle *handle,				\
-	  const void *buf, unsigned int len)				\
+	  const void *buf, unsigned long len)				\
 {									\
 	unsigned long size, written;					\
 									\
 	do {								\
-		size = min_t(unsigned long, handle->size, len);		\
-									\
+		size    = min(handle->size, len);			\
 		written = memcpy_func(handle->addr, buf, size);		\
+		written = size - written;				\
 									\
 		len -= written;						\
 		handle->addr += written;				\
@@ -110,20 +110,37 @@ func_name(struct perf_output_handle *handle,				\
 	return len;							\
 }
 
-static inline int memcpy_common(void *dst, const void *src, size_t n)
+static inline unsigned long
+memcpy_common(void *dst, const void *src, unsigned long n)
 {
 	memcpy(dst, src, n);
-	return n;
+	return 0;
 }
 
 DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
 
-#define MEMCPY_SKIP(dst, src, n) (n)
+static inline unsigned long
+memcpy_skip(void *dst, const void *src, unsigned long n)
+{
+	return 0;
+}
 
-DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
+DEFINE_OUTPUT_COPY(__output_skip, memcpy_skip)
 
 #ifndef arch_perf_out_copy_user
-#define arch_perf_out_copy_user __copy_from_user_inatomic
+#define arch_perf_out_copy_user arch_perf_out_copy_user
+
+static inline unsigned long
+arch_perf_out_copy_user(void *dst, const void *src, unsigned long n)
+{
+	unsigned long ret;
+
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(dst, src, n);
+	pagefault_enable();
+
+	return ret;
+}
 #endif
 
 DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
