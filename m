Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbaDVOt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbaDVOsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:48:00 -0400
Date: Tue, 22 Apr 2014 16:47:42 +0200
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
Subject: [PATCH 2/5] uprobes/x86: Introduce uprobe_xol_ops->abort() and
	default_abort_op()
Message-ID: <20140422144742.GA8045@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422144719.GA7456@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_uprobe_abort_xol() calls handle_riprel_post_xol() even if
auprobe->ops != default_xol_ops. This is fine correctness wise, only
default_pre_xol_op() can set UPROBE_FIX_RIP_AX|UPROBE_FIX_RIP_CX and
otherwise handle_riprel_post_xol() is nop.

But this doesn't look clean and this doesn't allow us to move ->fixups
into the union in arch_uprobe. Move this handle_riprel_post_xol() call
into the new default_abort_op() hook and change arch_uprobe_abort_xol()
accordingly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 9690c65..8fce6ef 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -394,6 +394,7 @@ struct uprobe_xol_ops {
 	bool	(*emulate)(struct arch_uprobe *, struct pt_regs *);
 	int	(*pre_xol)(struct arch_uprobe *, struct pt_regs *);
 	int	(*post_xol)(struct arch_uprobe *, struct pt_regs *);
+	void	(*abort)(struct arch_uprobe *, struct pt_regs *);
 };
 
 static inline int sizeof_long(void)
@@ -444,9 +445,15 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 	return 0;
 }
 
+static void default_abort_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	handle_riprel_post_xol(auprobe, regs, NULL);
+}
+
 static struct uprobe_xol_ops default_xol_ops = {
 	.pre_xol  = default_pre_xol_op,
 	.post_xol = default_post_xol_op,
+	.abort	  = default_abort_op,
 };
 
 static bool branch_is_call(struct arch_uprobe *auprobe)
@@ -809,10 +816,11 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
 
-	current->thread.trap_nr = utask->autask.saved_trap_nr;
-	handle_riprel_post_xol(auprobe, regs, NULL);
-	instruction_pointer_set(regs, utask->vaddr);
+	if (auprobe->ops->abort)
+		auprobe->ops->abort(auprobe, regs);
 
+	current->thread.trap_nr = utask->autask.saved_trap_nr;
+	regs->ip = utask->vaddr;
 	/* clear TF if it was set by us in arch_uprobe_pre_xol() */
 	if (!utask->autask.saved_tf)
 		regs->flags &= ~X86_EFLAGS_TF;
-- 
1.5.5.1

