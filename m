Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbaGUOJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:09:48 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbaGUOEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:20 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, realmz6@gmail.com,
        adi-buildroot-devel@lists.sourceforge.net
Subject: [PATCH 31/43] blackfin: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:17 +0200
Message-Id: <1405951409-16953-32-git-send-email-richard@sigma-star.at>
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
 arch/blackfin/kernel/signal.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index 1389cd3..ef27557 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -135,19 +135,11 @@ static inline int rt_setup_sigcontext(struct sigcontext *sc, struct pt_regs *reg
 	return err;
 }
 
-static inline void *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
+static inline void *get_sigframe(struct ksignal *ksig,
 				 size_t frame_size)
 {
-	unsigned long usp;
+	unsigned long usp = sigsp(rdusp(), ksig);
 
-	/* Default to using normal stack.  */
-	usp = rdusp();
-
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (!on_sig_stack(usp))
-			usp = current->sas_ss_sp + current->sas_ss_size;
-	}
 	return (void *)((usp - frame_size) & -8UL);
 }
 
@@ -157,7 +149,7 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 	struct rt_sigframe *frame;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, sizeof(*frame));
 
 	err |= __put_user((current_thread_info()->exec_domain
 			   && current_thread_info()->exec_domain->signal_invmap
-- 
1.8.4.5

