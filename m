Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbaGUOGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:06:37 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14398 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaGUOEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:25 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, monstr@monstr.eu
Subject: [PATCH 39/43] microblaze: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:25 +0200
Message-Id: <1405951409-16953-40-git-send-email-richard@sigma-star.at>
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
 arch/microblaze/kernel/signal.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index 83137e8..8955a38 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -145,13 +145,10 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
  * Determine which stack to use..
  */
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
+get_sigframe(struct ksignal *ksig, struct pt_regs *regs, size_t frame_size)
 {
 	/* Default to using normal stack */
-	unsigned long sp = regs->r1;
-
-	if ((ka->sa.sa_flags & SA_ONSTACK) != 0 && !on_sig_stack(sp))
-		sp = current->sas_ss_sp + current->sas_ss_size;
+	unsigned long sp = sigsp(regs->r1, ksig);
 
 	return (void __user *)((sp - frame_size) & -8UL);
 }
@@ -168,7 +165,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	pte_t *ptep;
 #endif
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
-- 
1.8.4.5

