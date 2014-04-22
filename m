Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaDVOsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:48:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946AbaDVOsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:48:06 -0400
Date: Tue, 22 Apr 2014 16:47:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] uprobes/x86: Don't use arch_uprobe_abort_xol() in
	arch_uprobe_post_xol()
Message-ID: <20140422144746.GA8048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422144719.GA7456@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

014940bad8e4 "uprobes/x86: Send SIGILL if arch_uprobe_post_xol() fails"
changed arch_uprobe_post_xol() to use arch_uprobe_abort_xol() if ->post_xol
fails. This was correct and helped to avoid the additional complications,
we need to clear X86_EFLAGS_TF in this case.

However, now that we have uprobe_xol_ops->abort() hook it would be better
to avoid arch_uprobe_abort_xol() here. ->post_xol() should likely do what
->abort() does anyway, we should not do the same work twice. Currently only
handle_riprel_post_xol() can be called twice, this is unnecessary but safe.
Still this is not clean and can lead to the problems in future.

Change arch_uprobe_post_xol() to clear X86_EFLAGS_TF and restore ->ip by
hand and avoid arch_uprobe_abort_xol(). This temporary uglifies the usage
of autask.saved_tf, we will cleanup this later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 8fce6ef..4e2cdd5 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -748,22 +748,24 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	struct uprobe_task *utask = current->utask;
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
+	current->thread.trap_nr = utask->autask.saved_trap_nr;
 
 	if (auprobe->ops->post_xol) {
 		int err = auprobe->ops->post_xol(auprobe, regs);
 		if (err) {
-			arch_uprobe_abort_xol(auprobe, regs);
+			if (!utask->autask.saved_tf)
+				regs->flags &= ~X86_EFLAGS_TF;
 			/*
-			 * Restart the probed insn. ->post_xol() must ensure
-			 * this is really possible if it returns -ERESTART.
+			 * Restore ->ip for restart or post mortem analysis.
+			 * ->post_xol() must not return -ERESTART unless this
+			 * is really possible.
 			 */
+			regs->ip = utask->vaddr;
 			if (err == -ERESTART)
 				return 0;
 			return err;
 		}
 	}
-
-	current->thread.trap_nr = utask->autask.saved_trap_nr;
 	/*
 	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
 	 * so we can get an extra SIGTRAP if we do not clear TF. We need
@@ -808,9 +810,8 @@ int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val,
 
 /*
  * This function gets called when XOL instruction either gets trapped or
- * the thread has a fatal signal, or if arch_uprobe_post_xol() failed.
- * Reset the instruction pointer to its probed address for the potential
- * restart or for post mortem analysis.
+ * the thread has a fatal signal. Reset the instruction pointer to its
+ * probed address for the potential restart or for post mortem analysis.
  */
 void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-- 
1.5.5.1

