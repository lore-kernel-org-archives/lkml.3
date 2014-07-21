Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbaGUOEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:04:31 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14396 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbaGUOEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:23 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, takata@linux-m32r.org,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org
Subject: [PATCH 36/43] m32r: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:22 +0200
Message-Id: <1405951409-16953-37-git-send-email-richard@sigma-star.at>
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
 arch/m32r/kernel/signal.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index cce3fd3..95408b8 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -162,15 +162,9 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
  * Determine which stack to use..
  */
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, unsigned long sp, size_t frame_size)
+get_sigframe(struct ksignal *ksig, unsigned long sp, size_t frame_size)
 {
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(sp) == 0)
-			sp = current->sas_ss_sp + current->sas_ss_size;
-	}
-
-	return (void __user *)((sp - frame_size) & -8ul);
+	return (void __user *)((sigsp(sp, ksig) - frame_size) & -8ul);
 }
 
 static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
@@ -180,7 +174,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	int err = 0;
 	int signal, sig = ksig->sig;
 
-	frame = get_sigframe(&ksig->ka, regs->spu, sizeof(*frame));
+	frame = get_sigframe(ksig, regs->spu, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
-- 
1.8.4.5

