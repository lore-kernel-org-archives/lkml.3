Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbaGUOE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:04:29 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbaGUOEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:20 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, msalter@redhat.com,
        a-jacquiot@ti.com, linux-c6x-dev@linux-c6x.org
Subject: [PATCH 32/43] c6x: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:18 +0200
Message-Id: <1405951409-16953-33-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Use sigsp() instead of the open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/kernel/signal.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/c6x/kernel/signal.c b/arch/c6x/kernel/signal.c
index 8bf9aad..fe68226 100644
--- a/arch/c6x/kernel/signal.c
+++ b/arch/c6x/kernel/signal.c
@@ -127,17 +127,11 @@ static int setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
 	return err;
 }
 
-static inline void __user *get_sigframe(struct k_sigaction *ka,
+static inline void __user *get_sigframe(struct ksignal *ksig,
 					struct pt_regs *regs,
 					unsigned long framesize)
 {
-	unsigned long sp = regs->sp;
-
-	/*
-	 * This is the X/Open sanctioned signal stack switching.
-	 */
-	if ((ka->sa.sa_flags & SA_ONSTACK) && sas_ss_flags(sp) == 0)
-		sp = current->sas_ss_sp + current->sas_ss_size;
+	unsigned long sp = sigsp(regs->sp, ksig);
 
 	/*
 	 * No matter what happens, 'sp' must be dword
@@ -153,7 +147,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	unsigned long __user *retcode;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
-- 
1.8.4.5

