Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaCaUoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaCaUov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:44:51 -0400
Date: Mon, 31 Mar 2014 21:43:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] uprobes: Kill UPROBE_SKIP_SSTEP and can_skip_sstep()
Message-ID: <20140331194355.GA9275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331194337.GA9257@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UPROBE_COPY_INSN, UPROBE_SKIP_SSTEP, and uprobe->flags must die. This
patch kills UPROBE_SKIP_SSTEP. I never understood why it was added;
not only it doesn't help, it harms.

It can only help to avoid arch_uprobe_skip_sstep() if it was already
called before and failed. But this is ugly, if we want to know whether
we can emulate this instruction or not we should do this analysis in
arch_uprobe_analyze_insn(), not when we hit this probe for the first
time.

And in fact this logic is simply wrong. arch_uprobe_skip_sstep() can
fail or not depending on the task/register state, if this insn can be
emulated but, say, put_user() fails we need to xol it this time, but
this doesn't mean we shouldn't try to emulate it when this or another
thread hist this bp next time.

And this is the actual reason for this change. We need to emulate the
"call" insn, but push(return-address) can obviously fail.

Per-arch notes:

	x86: __skip_sstep() can only emulate "rep;nop". With this
	     change it will be called every time and most probably
	     for no reason.

	     This will be fixed by the next changes. We need to
	     change this suboptimal code anyway.

	arm: Should not be affected. It has its own "bool simulate"
	     flag checked in arch_uprobe_skip_sstep().

	ppc: Looks like, it can emulate almost everything. Does it
	     actually needs to record the fact that emulate_step()
	     failed? Hopefully not. But if yes, it can add the ppc-
	     specific flag into arch_uprobe.

TODO: rename arch_uprobe_skip_sstep() to arch_uprobe_emulate_insn(),

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   23 ++---------------------
 1 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 307d87c..7a3e14e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -60,8 +60,6 @@ static struct percpu_rw_semaphore dup_mmap_sem;
 
 /* Have a copy of original instruction */
 #define UPROBE_COPY_INSN	0
-/* Can skip singlestep */
-#define UPROBE_SKIP_SSTEP	1
 
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
@@ -491,12 +489,9 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 	uprobe->offset = offset;
 	init_rwsem(&uprobe->register_rwsem);
 	init_rwsem(&uprobe->consumer_rwsem);
-	/* For now assume that the instruction need not be single-stepped */
-	__set_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
 
 	/* add to uprobes_tree, sorted on inode:offset */
 	cur_uprobe = insert_uprobe(uprobe);
-
 	/* a uprobe exists for this inode:offset combination */
 	if (cur_uprobe) {
 		kfree(uprobe);
@@ -1628,20 +1623,6 @@ bool uprobe_deny_signal(void)
 	return true;
 }
 
-/*
- * Avoid singlestepping the original instruction if the original instruction
- * is a NOP or can be emulated.
- */
-static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
-{
-	if (test_bit(UPROBE_SKIP_SSTEP, &uprobe->flags)) {
-		if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
-			return true;
-		clear_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
-	}
-	return false;
-}
-
 static void mmf_recalc_uprobes(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
@@ -1859,13 +1840,13 @@ static void handle_swbp(struct pt_regs *regs)
 		goto out;
 
 	handler_chain(uprobe, regs);
-	if (can_skip_sstep(uprobe, regs))
+	if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
 		goto out;
 
 	if (!pre_ssout(uprobe, regs, bp_vaddr))
 		return;
 
-	/* can_skip_sstep() succeeded, or restart if can't singlestep */
+	/* arch_uprobe_skip_sstep() succeeded, or restart if can't singlestep */
 out:
 	put_uprobe(uprobe);
 }
-- 
1.5.5.1

