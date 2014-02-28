Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaB1TdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:33:21 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:19219 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751715AbaB1TdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:33:19 -0500
Date: Fri, 28 Feb 2014 14:33:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] x86: Rename copy_from_user_nmi() to copy_from_user_trace()
Message-ID: <20140228143316.211d4034@gandalf.local.home>
In-Reply-To: <20140228112946.1f194397@gandalf.local.home>
References: <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
	<20140227173150.4e5ed747@gandalf.local.home>
	<530FC1C6.5040209@zytor.com>
	<alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
	<20140228092341.12a40f7c@gandalf.local.home>
	<alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
	<1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
	<20140228154026.GH9987@twins.programming.kicks-ass.net>
	<5310B60F.30806@zytor.com>
	<20140228112946.1f194397@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ H. Peter, Here's the rename patch. I did not include your update. You
can add that first and then massage this patch on top. But this isn't
critical for mainline or stable, where as I believe your patch is. ]

The tracing utilities sometimes need to read from userspace (stack tracing),
and to do this it has as special copy_from_user function called
copy_from_user_nmi(). Well, as tracers can call this from outside of
nmi context, the "_nmi" part is a misnomer and "_trace" is a better
name.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/perf_event.h          |  2 +-
 arch/x86/include/asm/uaccess.h             |  2 +-
 arch/x86/kernel/cpu/perf_event.c           |  4 ++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 +-
 arch/x86/lib/usercopy.c                    | 10 ++++++----
 arch/x86/oprofile/backtrace.c              |  4 ++--
 7 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8249df4..7bf4b25 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -274,6 +274,6 @@ static inline void perf_check_microcode(void) { }
  static inline void amd_pmu_disable_virt(void) { }
 #endif
 
-#define arch_perf_out_copy_user copy_from_user_nmi
+#define arch_perf_out_copy_user copy_from_user_trace
 
 #endif /* _ASM_X86_PERF_EVENT_H */
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 8ec57c0..d734baf 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -515,7 +515,7 @@ struct __large_struct { unsigned long buf[100]; };
 	__put_user_size_ex((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
 extern unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
+copy_from_user_trace(void *to, const void __user *from, unsigned long n);
 extern __must_check long
 strncpy_from_user(char *dst, const char __user *src, long count);
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8e13293..7eda4af 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1988,7 +1988,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		frame.next_frame     = 0;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		bytes = copy_from_user_trace(&frame, fp, sizeof(frame));
 		if (bytes != 0)
 			break;
 
@@ -2040,7 +2040,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		bytes = copy_from_user_trace(&frame, fp, sizeof(frame));
 		if (bytes != 0)
 			break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ae96cfa..95d76c6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -788,7 +788,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		u8 *buf = this_cpu_read(insn_buffer);
 
 		size = ip - to; /* Must fit our buffer, see above */
-		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
+		bytes = copy_from_user_trace(buf, (void __user *)to, size);
 		if (bytes != 0)
 			return 0;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d82d155..0505ada 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -490,7 +490,7 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 			return X86_BR_NONE;
 
 		/* may fail if text not present */
-		bytes = copy_from_user_nmi(buf, (void __user *)from, size);
+		bytes = copy_from_user_trace(buf, (void __user *)from, size);
 		if (bytes != 0)
 			return X86_BR_NONE;
 
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index ddf9ecb..131ff16e 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -11,11 +11,13 @@
 #include <linux/sched.h>
 
 /*
- * We rely on the nested NMI work to allow atomic faults from the NMI path; the
- * nested NMI paths are careful to preserve CR2.
+ * Used by tracing, needs to restore state of the cr2 register if
+ * the copy triggered a page fault. That's because tracing can happen
+ * between the time a normal page fault occurred and the cr2 is read
+ * by the handler.
  */
 unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+copy_from_user_trace(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long ret;
 
@@ -33,4 +35,4 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(copy_from_user_nmi);
+EXPORT_SYMBOL_GPL(copy_from_user_trace);
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 5d04be5..7831650 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -46,7 +46,7 @@ dump_user_backtrace_32(struct stack_frame_ia32 *head)
 	struct stack_frame_ia32 *fp;
 	unsigned long bytes;
 
-	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	bytes = copy_from_user_trace(bufhead, head, sizeof(bufhead));
 	if (bytes != 0)
 		return NULL;
 
@@ -92,7 +92,7 @@ static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
 	struct stack_frame bufhead[2];
 	unsigned long bytes;
 
-	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	bytes = copy_from_user_trace(bufhead, head, sizeof(bufhead));
 	if (bytes != 0)
 		return NULL;
 
-- 
1.8.1.4

