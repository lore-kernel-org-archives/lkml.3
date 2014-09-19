Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaISLsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:48:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbaISLsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:48:03 -0400
Date: Fri, 19 Sep 2014 04:46:44 -0700
From: tip-bot for Aaron Tomlin <tipbot@zytor.com>
Message-ID: <tip-a70857e46dd13e87ae06bf0e64cb6a2d4f436265@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        seiji.aguchi@hds.com, mpe@ellerman.id.au, atomlin@redhat.com,
        jolsa@redhat.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, masami.hiramatsu.pt@hitachi.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, mpe@ellerman.id.au, seiji.aguchi@hds.com,
        atomlin@redhat.com, jolsa@redhat.com, akpm@linux-foundation.org,
        rostedt@goodmis.org, isimatu.yasuaki@jp.fujitsu.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <1410527779-8133-3-git-send-email-atomlin@redhat.com>
References: <1410527779-8133-3-git-send-email-atomlin@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Add helper for task stack page overrun checking
Git-Commit-ID: a70857e46dd13e87ae06bf0e64cb6a2d4f436265
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

Commit-ID:  a70857e46dd13e87ae06bf0e64cb6a2d4f436265
Gitweb:     http://git.kernel.org/tip/a70857e46dd13e87ae06bf0e64cb6a2d4f436265
Author:     Aaron Tomlin <atomlin@redhat.com>
AuthorDate: Fri, 12 Sep 2014 14:16:18 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:23 +0200

sched: Add helper for task stack page overrun checking

This facility is used in a few places so let's introduce
a helper function to improve code readability.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: aneesh.kumar@linux.vnet.ibm.com
Cc: dzickus@redhat.com
Cc: bmr@redhat.com
Cc: jcastillo@redhat.com
Cc: oleg@redhat.com
Cc: riel@redhat.com
Cc: prarit@redhat.com
Cc: jgh@redhat.com
Cc: minchan@kernel.org
Cc: mpe@ellerman.id.au
Cc: tglx@linutronix.de
Cc: hannes@cmpxchg.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1410527779-8133-3-git-send-email-atomlin@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 118dca7..18f5262 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2617,6 +2617,8 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
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
