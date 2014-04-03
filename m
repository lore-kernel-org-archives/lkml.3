Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaDCUCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:02:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbaDCUB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:01:57 -0400
Date: Thu, 3 Apr 2014 22:01:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/7] uprobes/x86: Teach arch_uprobe_post_xol() to restart
	if possible
Message-ID: <20140403200155.GE12639@redhat.com>
References: <20140331194337.GA9257@redhat.com> <20140403200015.GC12639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403200015.GC12639@redhat.com>
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

Note: this is not "perfect" because handler_chain() we actually do not
want the extra handler_chain() after restart, but I think this is the
best solution we can realistically do without too much uglifications.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 3bdfb6e..78c4bb3 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -443,16 +443,17 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
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
+		if (adjust_ret_addr(regs->sp, correction))
+			return -ERESTART;
+	}
 
-	return ret;
+	return 0;
 }
 
 static struct uprobe_xol_ops default_xol_ops = {
@@ -599,6 +600,12 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
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


