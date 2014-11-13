Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774AbaKMSEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:04:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39282 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbaKMSEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:04:45 -0500
Date: Thu, 13 Nov 2014 19:04:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>, Tony Luck <tony.luck@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141113180436.GG14070@pd.tnic>
References: <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic>
 <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141112162225.GF16807@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 05:22:25PM +0100, Borislav Petkov wrote:
> > Less intrusive is certainly true.
> 
> Right, I can do it in the meantime and we can always experiment more
> later. Getting rid of _TIF_MCE_NOTIFY is a good thing already.

Yep, it looks pretty simple - not tested yet, it builds though.

---
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 276392f121fb..d74c85def853 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -186,7 +186,6 @@ enum mcp_flags {
 void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
 int mce_notify_irq(void);
-void mce_notify_process(void);
 
 DECLARE_PER_CPU(struct mce, injectm);
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 854053889d4d..9a121e3cdf1e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -75,7 +75,7 @@ struct thread_info {
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
-#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+/* unused, was #define TIF_MCE_NOTIFY		10	* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_UPROBE		12	/* breakpointed or singlestepping */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
@@ -100,7 +100,6 @@ struct thread_info {
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
@@ -140,8 +139,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
-	 _TIF_USER_RETURN_NOTIFY)
+	(_TIF_SIGPENDING |  _TIF_NOTIFY_RESUME | _TIF_USER_RETURN_NOTIFY)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 61a9668cebfd..0e82c2cc6b0c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -14,6 +14,7 @@
 #include <linux/capability.h>
 #include <linux/miscdevice.h>
 #include <linux/ratelimit.h>
+#include <linux/task_work.h>
 #include <linux/kallsyms.h>
 #include <linux/rcupdate.h>
 #include <linux/kobject.h>
@@ -111,6 +112,8 @@ static DEFINE_PER_CPU(struct work_struct, mce_work);
 
 static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
 
+static struct callback_head mce_task_work;
+
 /*
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
@@ -1157,7 +1160,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (worst == MCE_AR_SEVERITY) {
 			/* schedule action before return to userland */
 			mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
-			set_thread_flag(TIF_MCE_NOTIFY);
+			task_work_add(current, &mce_task_work, true);
 		} else if (kill_it) {
 			force_sig(SIGBUS, current);
 		}
@@ -1185,14 +1188,13 @@ int memory_failure(unsigned long pfn, int vector, int flags)
 #endif
 
 /*
- * Called in process context that interrupted by MCE and marked with
- * TIF_MCE_NOTIFY, just before returning to erroneous userland.
- * This code is allowed to sleep.
+ * Called in process context that interrupted by MCE just before returning to
+ * erroneous userland. This code is allowed to sleep.
  * Attempt possible recovery such as calling the high level VM handler to
  * process any corrupted pages, and kill/signal current process if required.
  * Action required errors are handled here.
  */
-void mce_notify_process(void)
+static void mce_notify_process(struct callback_head *unused)
 {
 	unsigned long pfn;
 	struct mce_info *mi = mce_find_info();
@@ -1202,8 +1204,6 @@ void mce_notify_process(void)
 		mce_panic("Lost physical address for unconsumed uncorrectable error", NULL, NULL);
 	pfn = mi->paddr >> PAGE_SHIFT;
 
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
 	pr_err("Uncorrected hardware memory error in user-access at %llx",
 		 mi->paddr);
 	/*
@@ -1704,6 +1704,7 @@ void mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_timer();
 	INIT_WORK(this_cpu_ptr(&mce_work), mce_process_work);
 	init_irq_work(this_cpu_ptr(&mce_irq_work), &mce_irq_work_cb);
+	init_task_work(&mce_task_work, mce_notify_process);
 }
 
 /*
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

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
