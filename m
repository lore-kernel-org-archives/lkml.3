Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbaGUOLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:11:11 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbaGUOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:17 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, vgupta@synopsys.com
Subject: [PATCH 28/43] arc: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:14 +0200
Message-Id: <1405951409-16953-29-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Use sigsp() instead of the open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/signal.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index c2031e2..cb3142a 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -141,17 +141,13 @@ badframe:
 /*
  * Determine which stack to use..
  */
-static inline void __user *get_sigframe(struct k_sigaction *ka,
+static inline void __user *get_sigframe(struct ksignal *ksig,
 					struct pt_regs *regs,
 					unsigned long framesize)
 {
-	unsigned long sp = regs->sp;
+	unsigned long sp = sigsp(regs->sp, ksig);
 	void __user *frame;
 
-	/* This is the X/Open sanctioned signal stack switching */
-	if ((ka->sa.sa_flags & SA_ONSTACK) && !sas_ss_flags(sp))
-		sp = current->sas_ss_sp + current->sas_ss_size;
-
 	/* No matter what happens, 'sp' must be word
 	 * aligned otherwise nasty things could happen
 	 */
@@ -185,7 +181,7 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 	unsigned int magic = 0;
 	int err = 0;
 
-	sf = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe));
+	sf = get_sigframe(ksig, regs, sizeof(struct rt_sigframe));
 	if (!sf)
 		return 1;
 
-- 
1.8.4.5

