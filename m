Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936305Ab3DIUQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:16:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935899Ab3DIUP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:15:59 -0400
Date: Tue, 9 Apr 2013 22:13:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH v1 6/9] uretprobes: Return probe exit, invoke handlers
Message-ID: <20130409201302.GA30570@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com> <1365004839-21982-7-git-send-email-anton@redhat.com> <20130407105308.GA2899@linux.vnet.ibm.com> <20130409140530.GA20577@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409140530.GA20577@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Oleg Nesterov wrote:
>
> > Should we a check here before using top most ri.
> > What if the application had done a longjmp and the trampoline he hit
> > corresponds to something thats below in the stack?
> >
> > Not sure if this what you meant by leaking return instances in your next
> > patch.
>
> Oh yes, this should be documented more explicitly in the changelog of
> this patch or 7/9 (which tries to document the limitations but should
> be more clear).
>
> Currently we do not support longjmp() and we assume that the probed
> function should do the regular return. We should certainly try to improve
> this, but I really think that this should go into the next series.
>
> Because this is nontrivial, needs more discussion, and I'm afraid should
> be per-arch. Even on x86 (which can check the stack) this is not simple,
> in general we can't know how to check that (to simplify) the first frame
> is already invalid. Just for example, we could check regs->sp and detect
> that longjmp() was called but sigaltstack() can easily fool this logic.
>
> Or we can change prepare_uretprobe() to alloc the new slot for the
> trampoline every time (and mark it as "trampoline" for handle_swbp() of
> course), this way we can easily discard the invalid ret_instance's in
> handler_uretprobe(). But this doesn't solve all problems and this is
> not really nice/simple.
>
> In short. I think we should document the limitations more clearly, push
> this functionality, then try to improve things. Do you agree?

IOW. Will you agree with v2 below?

Changes:

	- s/handler_uretprobe/handle_trampoline/

	- s/handler_uretprobe_chain/handle_uretprobe_chain/

	- add the TODO: comments into the changelog and
	  handle_trampoline().


-------------------------------------------------------------------------------
[PATCH v2] uretprobes: Return probe exit, invoke handlers

Uretprobe handlers are invoked when the trampoline is hit, on completion
the trampoline is replaced with the saved return address and the uretprobe
instance deleted.

TODO: handle_trampoline() assumes that ->return_instances is always valid.
We should teach it to handle longjmp() which can invalidate the pending
return_instance's. This is nontrivial, we will try to do this in a separate
series.

Signed-off-by: Anton Arapov <anton@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 64 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index e352e18..b9c4325 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1633,6 +1633,62 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 	up_read(&uprobe->register_rwsem);
 }
 
+static void
+handle_uretprobe_chain(struct return_instance *ri, struct pt_regs *regs)
+{
+	struct uprobe *uprobe = ri->uprobe;
+	struct uprobe_consumer *uc;
+
+	down_read(&uprobe->register_rwsem);
+	for (uc = uprobe->consumers; uc; uc = uc->next) {
+		if (uc->ret_handler)
+			uc->ret_handler(uc, ri->func, regs);
+	}
+	up_read(&uprobe->register_rwsem);
+}
+
+static bool handle_trampoline(struct pt_regs *regs)
+{
+	struct uprobe_task *utask;
+	struct return_instance *ri, *tmp;
+	bool chained;
+
+	utask = current->utask;
+	if (!utask)
+		return false;
+
+	ri = utask->return_instances;
+	if (!ri)
+		return false;
+
+	/*
+	 * TODO: we should throw out return_instance's invalidated by
+	 * longjmp(), currently we assume that the probed function always
+	 * returns.
+	 */
+	instruction_pointer_set(regs, ri->orig_ret_vaddr);
+
+	for (;;) {
+		handle_uretprobe_chain(ri, regs);
+
+		chained = ri->chained;
+		put_uprobe(ri->uprobe);
+
+		tmp = ri;
+		ri = ri->next;
+		kfree(tmp);
+
+		if (!chained)
+			break;
+
+		BUG_ON(!ri);
+	}
+
+	utask->return_instances = ri;
+
+	return true;
+}
+
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1644,8 +1700,15 @@ static void handle_swbp(struct pt_regs *regs)
 	int uninitialized_var(is_swbp);
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
-	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
+	if (bp_vaddr == get_trampoline_vaddr()) {
+		if (handle_trampoline(regs))
+			return;
 
+		pr_warn("uprobe: unable to handle uretprobe pid/tgid=%d/%d\n",
+						current->pid, current->tgid);
+	}
+
+	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
 	if (!uprobe) {
 		if (is_swbp > 0) {
 			/* No matching uprobe; signal SIGTRAP. */
-- 
1.5.5.1


