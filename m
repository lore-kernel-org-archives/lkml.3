Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3J2OJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:09:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab3J2OJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:09:19 -0400
Date: Tue, 29 Oct 2013 07:08:34 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e00b12e64be9a34ef071de7b6052ca9ea29dd460@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        acme@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@infradead.org, ak@linux.intel.com,
        tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <20131024105206.GM2490@laptop.programming.kicks-ass.net>
References: <20131024105206.GM2490@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Further optimize copy_from_user_nmi()
Git-Commit-ID: e00b12e64be9a34ef071de7b6052ca9ea29dd460
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:08:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e00b12e64be9a34ef071de7b6052ca9ea29dd460
Gitweb:     http://git.kernel.org/tip/e00b12e64be9a34ef071de7b6052ca9ea29dd460
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 24 Oct 2013 12:52:06 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:54 +0100

perf/x86: Further optimize copy_from_user_nmi()

Now that we can deal with nested NMI due to IRET re-enabling NMIs and
can deal with faults from NMI by making sure we preserve CR2 over NMIs
we can in fact simply access user-space memory from NMI context.

So rewrite copy_from_user_nmi() to use __copy_from_user_inatomic() and
rework the fault path to do the minimal required work before taking
the in_atomic() fault handler.

In particular avoid perf_sw_event() which would make perf recurse on
itself (it should be harmless as our recursion protections should be
able to deal with this -- but why tempt fate).

Also rename notify_page_fault() to kprobes_fault() as that is a much
better name; there is no notifier in it and its specific to kprobes.

Don measured that his worst case NMI path shrunk from ~300K cycles to
~150K cycles.

Cc: Stephane Eranian <eranian@google.com>
Cc: jmario@redhat.com
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: dave.hansen@linux.intel.com
Tested-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131024105206.GM2490@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/lib/usercopy.c | 43 +++++++++++++++----------------------------
 arch/x86/mm/fault.c     | 41 +++++++++++++++++++++--------------------
 2 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 4f74d94..5465b86 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -11,39 +11,26 @@
 #include <linux/sched.h>
 
 /*
- * best effort, GUP based copy_from_user() that is NMI-safe
+ * We rely on the nested NMI work to allow atomic faults from the NMI path; the
+ * nested NMI paths are careful to preserve CR2.
  */
 unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 {
-	unsigned long offset, addr = (unsigned long)from;
-	unsigned long size, len = 0;
-	struct page *page;
-	void *map;
-	int ret;
+	unsigned long ret;
 
 	if (__range_not_ok(from, n, TASK_SIZE))
-		return len;
-
-	do {
-		ret = __get_user_pages_fast(addr, 1, 0, &page);
-		if (!ret)
-			break;
-
-		offset = addr & (PAGE_SIZE - 1);
-		size = min(PAGE_SIZE - offset, n - len);
-
-		map = kmap_atomic(page);
-		memcpy(to, map+offset, size);
-		kunmap_atomic(map);
-		put_page(page);
-
-		len  += size;
-		to   += size;
-		addr += size;
-
-	} while (len < n);
-
-	return len;
+		return 0;
+
+	/*
+	 * Even though this function is typically called from NMI/IRQ context
+	 * disable pagefaults so that its behaviour is consistent even when
+	 * called form other contexts.
+	 */
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(to, from, n);
+	pagefault_enable();
+
+	return n - ret;
 }
 EXPORT_SYMBOL_GPL(copy_from_user_nmi);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3aaeffc..7a517bb 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -51,7 +51,7 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
 	return 0;
 }
 
-static inline int __kprobes notify_page_fault(struct pt_regs *regs)
+static inline int __kprobes kprobes_fault(struct pt_regs *regs)
 {
 	int ret = 0;
 
@@ -1048,7 +1048,7 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 			return;
 
 		/* kprobes don't want to hook the spurious faults: */
-		if (notify_page_fault(regs))
+		if (kprobes_fault(regs))
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -1060,23 +1060,8 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	}
 
 	/* kprobes don't want to hook the spurious faults: */
-	if (unlikely(notify_page_fault(regs)))
+	if (unlikely(kprobes_fault(regs)))
 		return;
-	/*
-	 * It's safe to allow irq's after cr2 has been saved and the
-	 * vmalloc fault has been handled.
-	 *
-	 * User-mode registers count as a user access even for any
-	 * potential system fault or CPU buglet:
-	 */
-	if (user_mode_vm(regs)) {
-		local_irq_enable();
-		error_code |= PF_USER;
-		flags |= FAULT_FLAG_USER;
-	} else {
-		if (regs->flags & X86_EFLAGS_IF)
-			local_irq_enable();
-	}
 
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
@@ -1088,8 +1073,6 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		}
 	}
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
-
 	/*
 	 * If we're in an interrupt, have no user context or are running
 	 * in an atomic region then we must not take the fault:
@@ -1099,6 +1082,24 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		return;
 	}
 
+	/*
+	 * It's safe to allow irq's after cr2 has been saved and the
+	 * vmalloc fault has been handled.
+	 *
+	 * User-mode registers count as a user access even for any
+	 * potential system fault or CPU buglet:
+	 */
+	if (user_mode_vm(regs)) {
+		local_irq_enable();
+		error_code |= PF_USER;
+		flags |= FAULT_FLAG_USER;
+	} else {
+		if (regs->flags & X86_EFLAGS_IF)
+			local_irq_enable();
+	}
+
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
+
 	if (error_code & PF_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 
