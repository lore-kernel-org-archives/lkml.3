Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbaGUOI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:08:57 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaGUOEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:21 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, dhowells@redhat.com
Subject: [PATCH 34/43] frv: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:20 +0200
Message-Id: <1405951409-16953-35-git-send-email-richard@sigma-star.at>
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
 arch/frv/kernel/signal.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 8e37cf2..dc3d59d 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -158,19 +158,10 @@ static int setup_sigcontext(struct sigcontext __user *sc, unsigned long mask)
 /*
  * Determine which stack to use..
  */
-static inline void __user *get_sigframe(struct k_sigaction *ka,
+static inline void __user *get_sigframe(struct ksignal *ksig,
 					size_t frame_size)
 {
-	unsigned long sp;
-
-	/* Default to using normal stack */
-	sp = __frame->sp;
-
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (! sas_ss_flags(sp))
-			sp = current->sas_ss_sp + current->sas_ss_size;
-	}
+	unsigned long sp = sigsp(__frame->sp, ksig);
 
 	return (void __user *) ((sp - frame_size) & ~7UL);
 
@@ -187,7 +178,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set)
 
 	set_fs(USER_DS);
 
-	frame = get_sigframe(&ksig->ka, sizeof(*frame));
+	frame = get_sigframe(ksig, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
@@ -268,7 +259,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set)
 
 	set_fs(USER_DS);
 
-	frame = get_sigframe(&ksig->ka, sizeof(*frame));
+	frame = get_sigframe(ksig, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
-- 
1.8.4.5

