Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaDEMqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 08:46:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbaDEMqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 08:46:18 -0400
Date: Sat, 5 Apr 2014 14:46:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 9/9] uprobes/x86: Teach arch_uprobe_post_xol() to
	restart if possible
Message-ID: <20140405124614.GA31950@redhat.com>
References: <20140404185142.GA14756@redhat.com> <1396648607.4769.3.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396648607.4769.3.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, Jim Keniston wrote:
>
> On Fri, 2014-04-04 at 20:51 +0200, Oleg Nesterov wrote:
> >
> > Currently only adjust_ret_addr() can fail, and this can only happen if
> > another thread unmapped our stack after we executed "call" out-of-line.
> > Most probably the application if buggy, but even in this case it can
> > have a handler for SIGSEGV/etc. And in theory it can be even correct
> > and do something non-trivial with its memory.
> >
> > Of course we can't restart unconditionally, so arch_uprobe_post_xol()
> > does this only if ->post_xol() returns -ERESTART even if currently this
> > is the only possible error.
>
> When re-executing the call instruction, I'd think the stack pointer
> would be wrong the second time around, unless you pop off the return
> address from the first try.

Of course! Like ttt_post_xol_op() in the next patch does, can't understand
how I forgot.

Thanks a lot! Please see v3 below.

I also updated the changelog. Please do not ask me to cleanup the games
with ->sp now. I'll try to do this later when we finish the bug fixes.
The current code should be unified with the code we will add. And I think
that adjust_ret_address() should die. What we need is uprobe_push(), there
is no need for copy_from_user() afaics. The value we need to push is
utask->vaddr + correction-calculated-at-analyze-time.


-------------------------------------------------------------------------------
Subject: [PATCH v3 9/9] uprobes/x86: Teach arch_uprobe_post_xol() to restart if possible

SIGILL after the failed arch_uprobe_post_xol() should only be used as
a last resort, we should try to restart the probed insn if possible.

Currently only adjust_ret_addr() can fail, and this can only happen if
another thread unmapped our stack after we executed "call" out-of-line.
Most probably the application if buggy, but even in this case it can
have a handler for SIGSEGV/etc. And in theory it can be even correct
and do something non-trivial with its memory.

Of course we can't restart unconditionally, so arch_uprobe_post_xol()
does this only if ->post_xol() returns -ERESTART even if currently this
is the only possible error.

default_post_xol_op(UPROBE_FIX_CALL) can always restart, but as Jim
pointed out it should not forget to pop off the return address pushed
by this insn executed out-of-line.

Note: this is not "perfect", we do not want the extra handler_chain()
after restart, but I think this is the best solution we can realistically
do without too much uglifications.

TODO: This adds yet another is_ia32_task() check, and the next patches
will add more. I will try cleanup this later, after we fix the pending
problems. And to remind, it seems that adjust_ret_addr() should die.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index e72903e..cdd6909 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -443,16 +443,22 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 {
 	struct uprobe_task *utask = current->utask;
 	long correction = (long)(utask->vaddr - utask->xol_vaddr);
-	int ret = 0;
 
 	handle_riprel_post_xol(auprobe, regs, &correction);
 	if (auprobe->fixups & UPROBE_FIX_IP)
 		regs->ip += correction;
 
-	if (auprobe->fixups & UPROBE_FIX_CALL)
-		ret = adjust_ret_addr(regs->sp, correction);
+	if (auprobe->fixups & UPROBE_FIX_CALL) {
+		if (adjust_ret_addr(regs->sp, correction)) {
+			if (is_ia32_task())
+				regs->sp += 4;
+			else
+				regs->sp += 8;
+			return -ERESTART;
+		}
+	}
 
-	return ret;
+	return 0;
 }
 
 static struct uprobe_xol_ops default_xol_ops = {
@@ -599,6 +605,12 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		int err = auprobe->ops->post_xol(auprobe, regs);
 		if (err) {
 			arch_uprobe_abort_xol(auprobe, regs);
+			/*
+			 * Restart the probed insn. ->post_xol() must ensure
+			 * this is really possible if it returns -ERESTART.
+			 */
+			if (err == -ERESTART)
+				return 0;
 			return err;
 		}
 	}
-- 
1.5.5.1


