Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbaGUOI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:08:59 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14396 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaGUOEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:21 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, starvik@axis.com,
        jesper.nilsson@axis.com, linux-cris-kernel@axis.com
Subject: [PATCH 33/43] cris: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:19 +0200
Message-Id: <1405951409-16953-34-git-send-email-richard@sigma-star.at>
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
 arch/cris/arch-v10/kernel/signal.c | 14 ++++----------
 arch/cris/arch-v32/kernel/signal.c | 16 ++++------------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/signal.c b/arch/cris/arch-v10/kernel/signal.c
index 12aac1f..9b32d33 100644
--- a/arch/cris/arch-v10/kernel/signal.c
+++ b/arch/cris/arch-v10/kernel/signal.c
@@ -203,15 +203,9 @@ static int setup_sigcontext(struct sigcontext __user *sc,
  * - usually on the stack. */
 
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
+get_sigframe(struct ksignal *ksig, size_t frame_size)
 {
-	unsigned long sp = rdusp();
-
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (! on_sig_stack(sp))
-			sp = current->sas_ss_sp + current->sas_ss_size;
-	}
+	unsigned long sp = sigsp(rdusp(), ksig);
 
 	/* make sure the frame is dword-aligned */
 
@@ -235,7 +229,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 	unsigned long return_ip;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -287,7 +281,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	unsigned long return_ip;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
diff --git a/arch/cris/arch-v32/kernel/signal.c b/arch/cris/arch-v32/kernel/signal.c
index cc7a39a..78ce3b1 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -189,17 +189,9 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
 
 /* Figure out where to put the new signal frame - usually on the stack. */
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
+get_sigframe(struct ksignal *ksig, size_t frame_size)
 {
-	unsigned long sp;
-
-	sp = rdusp();
-
-	/* This is the X/Open sanctioned signal stack switching. */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (!on_sig_stack(sp))
-			sp = current->sas_ss_sp + current->sas_ss_size;
-	}
+	unsigned long sp = sigsp(rdusp(), ksig);
 
 	/* Make sure the frame is dword-aligned. */
 	sp &= ~3;
@@ -222,7 +214,7 @@ setup_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 	struct signal_frame __user *frame;
 
 	err = 0;
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -290,7 +282,7 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 	struct rt_signal_frame __user *frame;
 
 	err = 0;
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
-- 
1.8.4.5

