Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaILNTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbaILNTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:19:06 -0400
From: Aaron Tomlin <atomlin@redhat.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com, jcastillo@redhat.com,
        atomlin@redhat.com, oleg@redhat.com, riel@redhat.com,
        prarit@redhat.com, jgh@redhat.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, x86@kernel.org, rostedt@goodmis.org,
        hannes@cmpxchg.org, aneesh.kumar@linux.vnet.ibm.com,
        akpm@linux-foundation.org, akpm@google.com,
        linuxppc-dev@lists.ozlabs.org, minchan@kernel.org, mpe@ellerman.id.au
Subject: [PATCH v4 2/3] sched: Add helper for task stack page overrun checking
Date: Fri, 12 Sep 2014 14:16:18 +0100
Message-Id: <1410527779-8133-3-git-send-email-atomlin@redhat.com>
In-Reply-To: <1410527779-8133-1-git-send-email-atomlin@redhat.com>
References: <1410527779-8133-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This facility is used in a few places so let's introduce
a helper function to improve code readability.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 arch/powerpc/mm/fault.c    | 4 +---
 arch/x86/mm/fault.c        | 4 +---
 include/linux/sched.h      | 2 ++
 kernel/trace/trace_stack.c | 2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 35d0760c..99b2f27 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -507,7 +507,6 @@ bail:
 void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 {
 	const struct exception_table_entry *entry;
-	unsigned long *stackend;
 
 	/* Are we prepared to handle this fault?  */
 	if ((entry = search_exception_tables(regs->nip)) != NULL) {
@@ -536,8 +535,7 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 	printk(KERN_ALERT "Faulting instruction address: 0x%08lx\n",
 		regs->nip);
 
-	stackend = end_of_stack(current);
-	if (*stackend != STACK_END_MAGIC)
+	if (task_stack_end_corrupted(current))
 		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
 
 	die("Kernel access of bad area", regs, sig);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index bc23a70..6240bc7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -648,7 +648,6 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	   unsigned long address, int signal, int si_code)
 {
 	struct task_struct *tsk = current;
-	unsigned long *stackend;
 	unsigned long flags;
 	int sig;
 
@@ -708,8 +707,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 
 	show_fault_oops(regs, error_code, address);
 
-	stackend = end_of_stack(tsk);
-	if (*stackend != STACK_END_MAGIC)
+	if (task_stack_end_corrupted(tsk))
 		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7ef34b7..a80e35d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2615,6 +2615,8 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
 }
 
 #endif
+#define task_stack_end_corrupted(task) \
+		(*(end_of_stack(task)) != STACK_END_MAGIC)
 
 static inline int object_is_on_stack(void *obj)
 {
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 1636e41..16eddb3 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -170,7 +170,7 @@ check_stack(unsigned long ip, unsigned long *stack)
 			i++;
 	}
 
-	if (*end_of_stack(current) != STACK_END_MAGIC) {
+	if (task_stack_end_corrupted(current)) {
 		print_max_stack();
 		BUG();
 	}
-- 
1.9.3

