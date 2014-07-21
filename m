Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbaGUOF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:05:58 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14396 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaGUOE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:26 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, dhowells@redhat.com,
        yasutake.koichi@jp.panasonic.com, linux-am33-list@redhat.com
Subject: [PATCH 41/43] mn10300: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:27 +0200
Message-Id: <1405951409-16953-42-git-send-email-richard@sigma-star.at>
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
 arch/mn10300/kernel/signal.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 0c97202..a6c0858 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -186,20 +186,11 @@ static int setup_sigcontext(struct sigcontext __user *sc,
 /*
  * determine which stack to use..
  */
-static inline void __user *get_sigframe(struct k_sigaction *ka,
+static inline void __user *get_sigframe(struct ksignal *ksig,
 					struct pt_regs *regs,
 					size_t frame_size)
 {
-	unsigned long sp;
-
-	/* default to using normal stack */
-	sp = regs->sp;
-
-	/* this is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(sp) == 0)
-			sp = current->sas_ss_sp + current->sas_ss_size;
-	}
+	unsigned long sp = sigsp(regs->sp, ksig);
 
 	return (void __user *) ((sp - frame_size) & ~7UL);
 }
@@ -213,7 +204,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 	struct sigframe __user *frame;
 	int rsig, sig = ksig->sig;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -281,7 +272,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	struct rt_sigframe __user *frame;
 	int rsig, sig = ksig->sig;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
-- 
1.8.4.5

