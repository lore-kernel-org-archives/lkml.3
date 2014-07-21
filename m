Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaGUOFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:05:00 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14398 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbaGUOE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:27 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, benh@kernel.crashing.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 43/43] powerpc: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:29 +0200
Message-Id: <1405951409-16953-44-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Use sigsp() instead of the open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/powerpc/kernel/signal.c    | 10 ++--------
 arch/powerpc/kernel/signal_32.c |  4 ++--
 arch/powerpc/kernel/signal_64.c |  2 +-
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index aa9b048..cf8c7e4 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -31,20 +31,14 @@ int show_unhandled_signals = 1;
 /*
  * Allocate space for the signal frame
  */
-void __user * get_sigframe(struct k_sigaction *ka, unsigned long sp,
+void __user *get_sigframe(struct ksignal *ksig, unsigned long sp,
 			   size_t frame_size, int is_32)
 {
         unsigned long oldsp, newsp;
 
         /* Default to using normal stack */
         oldsp = get_clean_sp(sp, is_32);
-
-	/* Check for alt stack */
-	if ((ka->sa.sa_flags & SA_ONSTACK) &&
-	    current->sas_ss_size && !on_sig_stack(oldsp))
-		oldsp = (current->sas_ss_sp + current->sas_ss_size);
-
-	/* Get aligned frame */
+	oldsp = sigsp(oldsp, ksig);
 	newsp = (oldsp - frame_size) & ~0xFUL;
 
 	/* Check access */
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index aa0af88..b171001 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -994,7 +994,7 @@ int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
 
 	/* Set up Signal Frame */
 	/* Put a Real Time Context onto stack */
-	rt_sf = get_sigframe(&ksig->ka, get_tm_stackpointer(regs), sizeof(*rt_sf), 1);
+	rt_sf = get_sigframe(ksig, get_tm_stackpointer(regs), sizeof(*rt_sf), 1);
 	addr = rt_sf;
 	if (unlikely(rt_sf == NULL))
 		goto badframe;
@@ -1417,7 +1417,7 @@ int handle_signal32(struct ksignal *ksig, sigset_t *oldset, struct pt_regs *regs
 	unsigned long tramp;
 
 	/* Set up Signal Frame */
-	frame = get_sigframe(&ksig->ka, get_tm_stackpointer(regs), sizeof(*frame), 1);
+	frame = get_sigframe(ksig, get_tm_stackpointer(regs), sizeof(*frame), 1);
 	if (unlikely(frame == NULL))
 		goto badframe;
 	sc = (struct sigcontext __user *) &frame->sctx;
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 115d110..2cb0c94 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -714,7 +714,7 @@ int handle_rt_signal64(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs
 	unsigned long newsp = 0;
 	long err = 0;
 
-	frame = get_sigframe(&ksig->ka, get_tm_stackpointer(regs), sizeof(*frame), 0);
+	frame = get_sigframe(ksig, get_tm_stackpointer(regs), sizeof(*frame), 0);
 	if (unlikely(frame == NULL))
 		goto badframe;
 
-- 
1.8.4.5

