Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbbAFAoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 19:44:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:32710 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbbAFAon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 19:44:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="507891116"
To: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <CALCETrV6=aWoAckieQkPJ4BCr9VzU=9080EmLfeL4ZWm+Hr55g@mail.gmail.com>
Subject: [PATCH] x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce tricks
From: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>, <fweisbec@gmail.com>
Date: Mon, 05 Jan 2015 16:44:42 -0800
Message-Id: <54ab2ffa301102cd6e@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now switch to the kernel stack when a machine check interrupts
during user mode.  This means that we can perform recovery actions
in the tail of do_machine_check()

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
On top of Andy's x86/paranoid branch
Andy: Should I really move that:
	pr_err("Uncorrected hardware memory error ...
inside the ist_begin_non_atomic() section?

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 51b26e895933..9b3de99dc004 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -190,7 +190,6 @@ enum mcp_flags {
 void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
 int mce_notify_irq(void);
-void mce_notify_process(void);
 
 DECLARE_PER_CPU(struct mce, injectm);
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 8b13b0fbda8e..e82e95abc92b 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -75,7 +75,6 @@ struct thread_info {
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
-#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_UPROBE		12	/* breakpointed or singlestepping */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
@@ -100,7 +99,6 @@ struct thread_info {
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
@@ -140,7 +138,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
+	(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME |				\
 	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE)
 
 /* flags to check in __switch_to() */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 800d423f1e92..f17a4f1aaa5d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1004,51 +1004,6 @@ static void mce_clear_state(unsigned long *toclear)
 }
 
 /*
- * Need to save faulting physical address associated with a process
- * in the machine check handler some place where we can grab it back
- * later in mce_notify_process()
- */
-#define	MCE_INFO_MAX	16
-
-struct mce_info {
-	atomic_t		inuse;
-	struct task_struct	*t;
-	__u64			paddr;
-	int			restartable;
-} mce_info[MCE_INFO_MAX];
-
-static void mce_save_info(__u64 addr, int c)
-{
-	struct mce_info *mi;
-
-	for (mi = mce_info; mi < &mce_info[MCE_INFO_MAX]; mi++) {
-		if (atomic_cmpxchg(&mi->inuse, 0, 1) == 0) {
-			mi->t = current;
-			mi->paddr = addr;
-			mi->restartable = c;
-			return;
-		}
-	}
-
-	mce_panic("Too many concurrent recoverable errors", NULL, NULL);
-}
-
-static struct mce_info *mce_find_info(void)
-{
-	struct mce_info *mi;
-
-	for (mi = mce_info; mi < &mce_info[MCE_INFO_MAX]; mi++)
-		if (atomic_read(&mi->inuse) && mi->t == current)
-			return mi;
-	return NULL;
-}
-
-static void mce_clear_info(struct mce_info *mi)
-{
-	atomic_set(&mi->inuse, 0);
-}
-
-/*
  * The actual machine check handler. This only handles real
  * exceptions when something got corrupted coming in through int 18.
  *
@@ -1086,6 +1041,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
 	DECLARE_BITMAP(valid_banks, MAX_NR_BANKS);
 	char *msg = "Unknown";
+	u64 recover_paddr = ~0ull;
+	int flags = MF_ACTION_REQUIRED;
 
 	prev_state = ist_enter(regs);
 
@@ -1207,9 +1164,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (no_way_out)
 			mce_panic("Fatal machine check on current CPU", &m, msg);
 		if (worst == MCE_AR_SEVERITY) {
-			/* schedule action before return to userland */
-			mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
-			set_thread_flag(TIF_MCE_NOTIFY);
+			recover_paddr = m.addr;
+			if (!(m.mcgstatus & MCG_STATUS_RIPV))
+				flags |= MF_MUST_KILL;
 		} else if (kill_it) {
 			force_sig(SIGBUS, current);
 		}
@@ -1220,6 +1177,26 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 out:
 	sync_core();
+
+	if (recover_paddr == ~0ull)
+		goto done;
+
+	pr_err("Uncorrected hardware memory error in user-access at %llx",
+		 recover_paddr);
+	/*
+	 * We must call memory_failure() here even if the current process is
+	 * doomed. We still need to mark the page as poisoned and alert any
+	 * other users of the page.
+	 */
+	ist_begin_non_atomic(regs);
+	local_irq_enable();
+	if (memory_failure(recover_paddr >> PAGE_SHIFT, MCE_VECTOR, flags) < 0) {
+		pr_err("Memory error not recovered");
+		force_sig(SIGBUS, current);
+	}
+	local_irq_disable();
+	ist_end_non_atomic();
+done:
 	ist_exit(regs, prev_state);
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
@@ -1238,42 +1215,6 @@ int memory_failure(unsigned long pfn, int vector, int flags)
 #endif
 
 /*
- * Called in process context that interrupted by MCE and marked with
- * TIF_MCE_NOTIFY, just before returning to erroneous userland.
- * This code is allowed to sleep.
- * Attempt possible recovery such as calling the high level VM handler to
- * process any corrupted pages, and kill/signal current process if required.
- * Action required errors are handled here.
- */
-void mce_notify_process(void)
-{
-	unsigned long pfn;
-	struct mce_info *mi = mce_find_info();
-	int flags = MF_ACTION_REQUIRED;
-
-	if (!mi)
-		mce_panic("Lost physical address for unconsumed uncorrectable error", NULL, NULL);
-	pfn = mi->paddr >> PAGE_SHIFT;
-
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
-	pr_err("Uncorrected hardware memory error in user-access at %llx",
-		 mi->paddr);
-	/*
-	 * We must call memory_failure() here even if the current process is
-	 * doomed. We still need to mark the page as poisoned and alert any
-	 * other users of the page.
-	 */
-	if (!mi->restartable)
-		flags |= MF_MUST_KILL;
-	if (memory_failure(pfn, MCE_VECTOR, flags) < 0) {
-		pr_err("Memory error not recovered");
-		force_sig(SIGBUS, current);
-	}
-	mce_clear_info(mi);
-}
-
-/*
  * Action optional processing happens here (picking up
  * from the list of faulting pages that do_machine_check()
  * placed into the "ring").
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index ed37a768d0fc..2a33c8f68319 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -740,12 +740,6 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
 	user_exit();
 
-#ifdef CONFIG_X86_MCE
-	/* notify userspace of pending MCEs */
-	if (thread_info_flags & _TIF_MCE_NOTIFY)
-		mce_notify_process();
-#endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
-
 	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
 
