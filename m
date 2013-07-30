Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3G3BOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:14:55 -0400
Received: from mx1.corp.phx1.mozilla.com ([63.245.216.69]:34838 "EHLO
	smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3G3BOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:14:53 -0400
From: Jed Davis <jld@mozilla.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Robert Richter <rric@kernel.org>,
        linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net
Cc: Jed Davis <jld@mozilla.com>
Subject: [PATCH 2/2] x86: Fix copy_from_user_nmi return to match copy_from_user.
Date: Mon, 29 Jul 2013 18:12:41 -0700
Message-Id: <1375146761-4339-2-git-send-email-jld@mozilla.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375146761-4339-1-git-send-email-jld@mozilla.com>
References: <1375146761-4339-1-git-send-email-jld@mozilla.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_from_user returns the number of bytes not copied.  This change
makes copy_from_user_nmi behave the same way, instead of returning the
number of bytes that were copied, to help prevent bugs caused by this
surprising difference (and simplify callers, which mostly want to know
if the number of uncopied bytes is nonzero).

Signed-off-by: Jed Davis <jld@mozilla.com>
---
 arch/x86/include/asm/perf_event.h          | 9 +--------
 arch/x86/kernel/cpu/perf_event.c           | 8 ++------
 arch/x86/kernel/cpu/perf_event_intel_ds.c  | 6 ++----
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 4 +---
 arch/x86/lib/usercopy.c                    | 2 +-
 arch/x86/oprofile/backtrace.c              | 8 ++------
 6 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index ddae5bd..8249df4 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -274,13 +274,6 @@ static inline void perf_check_microcode(void) { }
  static inline void amd_pmu_disable_virt(void) { }
 #endif
 
-static inline unsigned long copy_from_user_nmi_for_perf(void *to,
-							const void __user *from,
-							unsigned long n)
-{
-	return n - copy_from_user_nmi(to, from, n);
-}
-
-#define arch_perf_out_copy_user copy_from_user_nmi_for_perf
+#define arch_perf_out_copy_user copy_from_user_nmi
 
 #endif /* _ASM_X86_PERF_EVENT_H */
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
-- 
1.8.3.2

