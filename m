Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609Ab3JPRqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761300Ab3JPRpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [ 20/69] ARC: Fix signal frame management for SA_SIGINFO
Date: Wed, 16 Oct 2013 10:44:29 -0700
Message-Id: <20131016174315.362128296@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Ruppert <christian.ruppert@abilis.com>

commit 10469350e345599dfef3fa78a7c19fb230e674c1 upstream.

Previously, when a signal was registered with SA_SIGINFO, parameters 2
and 3 of the signal handler were written to registers r1 and r2 before
the register set was saved. This led to corruption of these two
registers after returning from the signal handler (the wrong values were
restored).
With this patch, registers are now saved before any parameters are
passed, thus maintaining the processor state from before signal entry.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/signal.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -101,7 +101,6 @@ SYSCALL_DEFINE0(rt_sigreturn)
 {
 	struct rt_sigframe __user *sf;
 	unsigned int magic;
-	int err;
 	struct pt_regs *regs = current_pt_regs();
 
 	/* Always make any pending restarted system calls return -EINTR */
@@ -119,15 +118,16 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	if (!access_ok(VERIFY_READ, sf, sizeof(*sf)))
 		goto badframe;
 
-	err = restore_usr_regs(regs, sf);
-	err |= __get_user(magic, &sf->sigret_magic);
-	if (err)
+	if (__get_user(magic, &sf->sigret_magic))
 		goto badframe;
 
 	if (unlikely(is_do_ss_needed(magic)))
 		if (restore_altstack(&sf->uc.uc_stack))
 			goto badframe;
 
+	if (restore_usr_regs(regs, sf))
+		goto badframe;
+
 	/* Don't restart from sigreturn */
 	syscall_wont_restart(regs);
 
@@ -191,6 +191,15 @@ setup_rt_frame(int signo, struct k_sigac
 		return 1;
 
 	/*
+	 * w/o SA_SIGINFO, struct ucontext is partially populated (only
+	 * uc_mcontext/uc_sigmask) for kernel's normal user state preservation
+	 * during signal handler execution. This works for SA_SIGINFO as well
+	 * although the semantics are now overloaded (the same reg state can be
+	 * inspected by userland: but are they allowed to fiddle with it ?
+	 */
+	err |= stash_usr_regs(sf, regs, set);
+
+	/*
 	 * SA_SIGINFO requires 3 args to signal handler:
 	 *  #1: sig-no (common to any handler)
 	 *  #2: struct siginfo
@@ -213,14 +222,6 @@ setup_rt_frame(int signo, struct k_sigac
 		magic = MAGIC_SIGALTSTK;
 	}
 
-	/*
-	 * w/o SA_SIGINFO, struct ucontext is partially populated (only
-	 * uc_mcontext/uc_sigmask) for kernel's normal user state preservation
-	 * during signal handler execution. This works for SA_SIGINFO as well
-	 * although the semantics are now overloaded (the same reg state can be
-	 * inspected by userland: but are they allowed to fiddle with it ?
-	 */
-	err |= stash_usr_regs(sf, regs, set);
 	err |= __put_user(magic, &sf->sigret_magic);
 	if (err)
 		return err;


