Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaDCUBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:01:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbaDCUBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:01:18 -0400
Date: Thu, 3 Apr 2014 22:00:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/7] uprobes/x86: Send SIGILL if arch_uprobe_post_xol()
	fails
Message-ID: <20140403200053.GD12639@redhat.com>
References: <20140331194337.GA9257@redhat.com> <20140403200015.GC12639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403200015.GC12639@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the error from arch_uprobe_post_xol() is silently ignored.
This doesn't look good and this can lead to the hard-to-debug problems.

1. Change handle_singlestep() to loudly complain and send SIGILL.

   Note: this only affects x86, ppc/arm can't fail.

2. Change arch_uprobe_post_xol() to call arch_uprobe_abort_xol() and
   avoid TF games if it is going to return an error.

   This can help to to analyze the problem, if nothing else we should
   not report ->ip = xol_slot in the core-file.

   Note: this means that handle_riprel_post_xol() can be called twice,
   but this is fine because it idempotent.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   16 ++++++++++++----
 kernel/events/uprobes.c   |    8 +++++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 43df132..3bdfb6e 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -594,6 +594,15 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	struct uprobe_task *utask = current->utask;
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
+
+	if (auprobe->ops->post_xol) {
+		int err = auprobe->ops->post_xol(auprobe, regs);
+		if (err) {
+			arch_uprobe_abort_xol(auprobe, regs);
+			return err;
+		}
+	}
+
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
 	/*
 	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
@@ -605,8 +614,6 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	if (auprobe->ops->post_xol)
-		return auprobe->ops->post_xol(auprobe, regs);
 	return 0;
 }
 
@@ -641,8 +648,9 @@ int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val,
 
 /*
  * This function gets called when XOL instruction either gets trapped or
- * the thread has a fatal signal, so reset the instruction pointer to its
- * probed address.
+ * the thread has a fatal signal, or if arch_uprobe_post_xol() failed.
+ * Reset the instruction pointer to its probed address for the potential
+ * restart or for post mortem analysis.
  */
 void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7a3e14e..2adbc97 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1858,10 +1858,11 @@ out:
 static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 {
 	struct uprobe *uprobe;
+	int err = 0;
 
 	uprobe = utask->active_uprobe;
 	if (utask->state == UTASK_SSTEP_ACK)
-		arch_uprobe_post_xol(&uprobe->arch, regs);
+		err = arch_uprobe_post_xol(&uprobe->arch, regs);
 	else if (utask->state == UTASK_SSTEP_TRAPPED)
 		arch_uprobe_abort_xol(&uprobe->arch, regs);
 	else
@@ -1875,6 +1876,11 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 	spin_lock_irq(&current->sighand->siglock);
 	recalc_sigpending(); /* see uprobe_deny_signal() */
 	spin_unlock_irq(&current->sighand->siglock);
+
+	if (unlikely(err)) {
+		uprobe_warn(current, "execute the probed insn, sending SIGILL.");
+		force_sig_info(SIGILL, SEND_SIG_FORCED, current);
+	}
 }
 
 /*
-- 
1.5.5.1


