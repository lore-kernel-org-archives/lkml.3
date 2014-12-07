Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaLGWEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:04:23 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39907 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaLGWEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:04:22 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Richard Weinberger <richard@nod.at>,
        Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: kernel: signal_32.c:  Remove unused function
Date: Sun,  7 Dec 2014 23:07:01 +0100
Message-Id: <1417990021-18696-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function sys_debug_setcontext() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/kernel/signal_32.c |  107 ---------------------------------------
 1 file changed, 107 deletions(-)

diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index b171001..a571614 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1297,113 +1297,6 @@ long sys_rt_sigreturn(int r3, int r4, int r5, int r6, int r7, int r8,
 	return 0;
 }
 
-#ifdef CONFIG_PPC32
-int sys_debug_setcontext(struct ucontext __user *ctx,
-			 int ndbg, struct sig_dbg_op __user *dbg,
-			 int r6, int r7, int r8,
-			 struct pt_regs *regs)
-{
-	struct sig_dbg_op op;
-	int i;
-	unsigned char tmp;
-	unsigned long new_msr = regs->msr;
-#ifdef CONFIG_PPC_ADV_DEBUG_REGS
-	unsigned long new_dbcr0 = current->thread.debug.dbcr0;
-#endif
-
-	for (i=0; i<ndbg; i++) {
-		if (copy_from_user(&op, dbg + i, sizeof(op)))
-			return -EFAULT;
-		switch (op.dbg_type) {
-		case SIG_DBG_SINGLE_STEPPING:
-#ifdef CONFIG_PPC_ADV_DEBUG_REGS
-			if (op.dbg_value) {
-				new_msr |= MSR_DE;
-				new_dbcr0 |= (DBCR0_IDM | DBCR0_IC);
-			} else {
-				new_dbcr0 &= ~DBCR0_IC;
-				if (!DBCR_ACTIVE_EVENTS(new_dbcr0,
-						current->thread.debug.dbcr1)) {
-					new_msr &= ~MSR_DE;
-					new_dbcr0 &= ~DBCR0_IDM;
-				}
-			}
-#else
-			if (op.dbg_value)
-				new_msr |= MSR_SE;
-			else
-				new_msr &= ~MSR_SE;
-#endif
-			break;
-		case SIG_DBG_BRANCH_TRACING:
-#ifdef CONFIG_PPC_ADV_DEBUG_REGS
-			return -EINVAL;
-#else
-			if (op.dbg_value)
-				new_msr |= MSR_BE;
-			else
-				new_msr &= ~MSR_BE;
-#endif
-			break;
-
-		default:
-			return -EINVAL;
-		}
-	}
-
-	/* We wait until here to actually install the values in the
-	   registers so if we fail in the above loop, it will not
-	   affect the contents of these registers.  After this point,
-	   failure is a problem, anyway, and it's very unlikely unless
-	   the user is really doing something wrong. */
-	regs->msr = new_msr;
-#ifdef CONFIG_PPC_ADV_DEBUG_REGS
-	current->thread.debug.dbcr0 = new_dbcr0;
-#endif
-
-	if (!access_ok(VERIFY_READ, ctx, sizeof(*ctx))
-	    || __get_user(tmp, (u8 __user *) ctx)
-	    || __get_user(tmp, (u8 __user *) (ctx + 1) - 1))
-		return -EFAULT;
-
-	/*
-	 * If we get a fault copying the context into the kernel's
-	 * image of the user's registers, we can't just return -EFAULT
-	 * because the user's registers will be corrupted.  For instance
-	 * the NIP value may have been updated but not some of the
-	 * other registers.  Given that we have done the access_ok
-	 * and successfully read the first and last bytes of the region
-	 * above, this should only happen in an out-of-memory situation
-	 * or if another thread unmaps the region containing the context.
-	 * We kill the task with a SIGSEGV in this situation.
-	 */
-	if (do_setcontext(ctx, regs, 1)) {
-		if (show_unhandled_signals)
-			printk_ratelimited(KERN_INFO "%s[%d]: bad frame in "
-					   "sys_debug_setcontext: %p nip %08lx "
-					   "lr %08lx\n",
-					   current->comm, current->pid,
-					   ctx, regs->nip, regs->link);
-
-		force_sig(SIGSEGV, current);
-		goto out;
-	}
-
-	/*
-	 * It's not clear whether or why it is desirable to save the
-	 * sigaltstack setting on signal delivery and restore it on
-	 * signal return.  But other architectures do this and we have
-	 * always done it up until now so it is probably better not to
-	 * change it.  -- paulus
-	 */
-	restore_altstack(&ctx->uc_stack);
-
-	set_thread_flag(TIF_RESTOREALL);
- out:
-	return 0;
-}
-#endif
-
 /*
  * OK, we're invoking a handler
  */
-- 
1.7.10.4

