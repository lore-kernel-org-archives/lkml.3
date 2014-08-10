Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaHJPaD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 11:30:03 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45659 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHJPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 11:30:01 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] unicore32: Fix build error
Date: Sun, 10 Aug 2014 08:29:55 -0700
Message-Id: <1407684595-30785-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unicore32 builds fail with

arch/unicore32/kernel/signal.c: In function ‘setup_frame’:
arch/unicore32/kernel/signal.c:257: error:
			‘usig’ undeclared (first use in this function)
arch/unicore32/kernel/signal.c:279: error:
			‘usig’ undeclared (first use in this function)
arch/unicore32/kernel/signal.c: In function ‘handle_signal’:
arch/unicore32/kernel/signal.c:306: warning: unused variable ‘tsk’
arch/unicore32/kernel/signal.c: In function ‘do_signal’:
arch/unicore32/kernel/signal.c:376: error:
			implicit declaration of function ‘get_signsl’
make[1]: *** [arch/unicore32/kernel/signal.o] Error 1
make: *** [arch/unicore32/kernel/signal.o] Error 2

Bisect points to commit 649671c90eaf ("unicore32: Use get_signal()
signal_setup_done()").

This code never even compiled. Reverting the patch does not work,
since previously used functions no longer exist, so try to fix it up.
Compile tested only.

Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/unicore32/kernel/signal.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
index 780d773..7c8fb70 100644
--- a/arch/unicore32/kernel/signal.c
+++ b/arch/unicore32/kernel/signal.c
@@ -254,7 +254,8 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 
 	err |= setup_sigframe(frame, regs, set);
 	if (err == 0)
-		err |= setup_return(regs, &ksig->ka, frame->retcode, frame, usig);
+		err |= setup_return(regs, &ksig->ka, frame->retcode, frame,
+				    ksig->sig);
 
 	return err;
 }
@@ -276,7 +277,8 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	err |= __save_altstack(&frame->sig.uc.uc_stack, regs->UCreg_sp);
 	err |= setup_sigframe(&frame->sig, regs, set);
 	if (err == 0)
-		err |= setup_return(regs, &ksig->ka, frame->sig.retcode, frame, usig);
+		err |= setup_return(regs, &ksig->ka, frame->sig.retcode, frame,
+				    ksig->sig);
 
 	if (err == 0) {
 		/*
@@ -303,7 +305,6 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs,
 			  int syscall)
 {
 	struct thread_info *thread = current_thread_info();
-	struct task_struct *tsk = current;
 	sigset_t *oldset = sigmask_to_save();
 	int usig = ksig->sig;
 	int ret;
@@ -373,7 +374,7 @@ static void do_signal(struct pt_regs *regs, int syscall)
 	if (!user_mode(regs))
 		return;
 
-	if (get_signsl(&ksig)) {
+	if (get_signal(&ksig)) {
 		handle_signal(&ksig, regs, syscall);
 		return;
 	}
-- 
1.9.1

