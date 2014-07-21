Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbaGUOE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:04:28 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbaGUOEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:20 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, hskinnemoen@gmail.com,
        egtvedt@samfundet.no
Subject: [PATCH 30/43] avr32: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:16 +0200
Message-Id: <1405951409-16953-31-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Use sigsp() instead of the open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/kernel/signal.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index dda150f..d309fbc 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -127,12 +127,9 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs)
 }
 
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, int framesize)
+get_sigframe(struct ksignal *ksig, struct pt_regs *regs, int framesize)
 {
-	unsigned long sp = regs->sp;
-
-	if ((ka->sa.sa_flags & SA_ONSTACK) && !sas_ss_flags(sp))
-		sp = current->sas_ss_sp + current->sas_ss_size;
+	unsigned long sp = sigsp(regs->sp, ksig);
 
 	return (void __user *)((sp - framesize) & ~3);
 }
@@ -143,7 +140,7 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 	struct rt_sigframe __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	err = -EFAULT;
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 		goto out;
-- 
1.8.4.5

