Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbaGUOIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:08:04 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbaGUOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:24 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, geert@linux-m68k.org,
        linux-m68k@vger.kernel.org
Subject: [PATCH 37/43] m68k: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:23 +0200
Message-Id: <1405951409-16953-38-git-send-email-richard@sigma-star.at>
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
 arch/m68k/kernel/signal.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index c8e6fa8..967a8b7 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -835,18 +835,10 @@ static inline int rt_setup_ucontext(struct ucontext __user *uc, struct pt_regs *
 }
 
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
+get_sigframe(struct ksignal *ksig, size_t frame_size)
 {
-	unsigned long usp;
-
-	/* Default to using normal stack.  */
-	usp = rdusp();
+	unsigned long usp = sigsp(rdusp(), ksig);
 
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (!sas_ss_flags(usp))
-			usp = current->sas_ss_sp + current->sas_ss_size;
-	}
 	return (void __user *)((usp - frame_size) & -8UL);
 }
 
@@ -866,7 +858,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 		return -EFAULT;
 	}
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame) + fsize);
+	frame = get_sigframe(ksig, sizeof(*frame) + fsize);
 
 	if (fsize)
 		err |= copy_to_user (frame + 1, regs + 1, fsize);
@@ -951,7 +943,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 		return -EFAULT;
 	}
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, sizeof(*frame));
 
 	if (fsize)
 		err |= copy_to_user (&frame->uc.uc_extra, regs + 1, fsize);
-- 
1.8.4.5

