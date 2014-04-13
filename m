Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbaDMRq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbaDMRp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:45:59 -0400
Date: Sun, 13 Apr 2014 19:45:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/15] uprobes/x86: Teach arch_uprobe_post_xol() to
	restart if possible
Message-ID: <20140413174553.GA11871@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413174508.GA11811@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/x86/kernel/uprobes.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index e0f1406..1ea7e1a 100644
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

