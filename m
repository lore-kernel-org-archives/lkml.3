Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbaDVOsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:48:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704AbaDVOsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:48:07 -0400
Date: Tue, 22 Apr 2014 16:47:49 +0200
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
Subject: [PATCH 4/5] uprobes/x86: Move UPROBE_FIX_SETF logic from
	arch_uprobe_post_xol() to default_post_xol_op()
Message-ID: <20140422144749.GA8055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422144719.GA7456@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UPROBE_FIX_SETF is only needed to handle "popf" correctly but it is
processed by the generic arch_uprobe_post_xol() code. This doesn't
allows us to make ->fixups private for default_xol_ops.

1 Change default_post_xol_op(UPROBE_FIX_SETF) to set ->saved_tf = T.

   "popf" always reads the flags from stack, it doesn't matter if TF
   was set or not before single-step. Ignoring the naming, this is
   even more logical, "saved_tf" means "owned by application" and we
   do not own this flag after "popf".

2. Change arch_uprobe_post_xol() to save ->saved_tf into the local
   "bool send_sigtrap" before ->post_xol().

2. Change arch_uprobe_post_xol() to ignore UPROBE_FIX_SETF and just
   check ->saved_tf after ->post_xol().

With this patch ->fixups and ->rip_rela_target_address are only used
by default_xol_ops hooks, we are ready to remove them from the common
part of arch_uprobe.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 4e2cdd5..e6314a2 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -441,6 +441,9 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 			return -ERESTART;
 		}
 	}
+	/* popf; tell the caller to not touch TF */
+	if (auprobe->fixups & UPROBE_FIX_SETF)
+		utask->autask.saved_tf = true;
 
 	return 0;
 }
@@ -746,15 +749,15 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
 int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
+	bool send_sigtrap = utask->autask.saved_tf;
+	int err = 0;
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
 
 	if (auprobe->ops->post_xol) {
-		int err = auprobe->ops->post_xol(auprobe, regs);
+		err = auprobe->ops->post_xol(auprobe, regs);
 		if (err) {
-			if (!utask->autask.saved_tf)
-				regs->flags &= ~X86_EFLAGS_TF;
 			/*
 			 * Restore ->ip for restart or post mortem analysis.
 			 * ->post_xol() must not return -ERESTART unless this
@@ -762,8 +765,8 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 			 */
 			regs->ip = utask->vaddr;
 			if (err == -ERESTART)
-				return 0;
-			return err;
+				err = 0;
+			send_sigtrap = false;
 		}
 	}
 	/*
@@ -771,12 +774,13 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	 * so we can get an extra SIGTRAP if we do not clear TF. We need
 	 * to examine the opcode to make it right.
 	 */
-	if (utask->autask.saved_tf)
+	if (send_sigtrap)
 		send_sig(SIGTRAP, current, 0);
-	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
+
+	if (!utask->autask.saved_tf)
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	return 0;
+	return err;
 }
 
 /* callback routine for handling exceptions. */
-- 
1.5.5.1

