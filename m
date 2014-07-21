Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbaGUOGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:06:20 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbaGUOEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:25 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 40/43] mips: Use sigsp()
Date: Mon, 21 Jul 2014 16:03:26 +0200
Message-Id: <1405951409-16953-41-git-send-email-richard@sigma-star.at>
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
 arch/mips/kernel/signal.c     | 10 ++++------
 arch/mips/kernel/signal32.c   |  4 ++--
 arch/mips/kernel/signal_n32.c |  2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index da4baac..1d57605 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -280,7 +280,7 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 	return err;
 }
 
-void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
+void __user *get_sigframe(struct ksignal *ksig, struct pt_regs *regs,
 			  size_t frame_size)
 {
 	unsigned long sp;
@@ -295,9 +295,7 @@ void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	 */
 	sp -= 32;
 
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if ((ka->sa.sa_flags & SA_ONSTACK) && (sas_ss_flags (sp) == 0))
-		sp = current->sas_ss_sp + current->sas_ss_size;
+	sp = sigsp(sp, ksig);
 
 	return (void __user *)((sp - frame_size) & (ICACHE_REFILLS_WORKAROUND_WAR ? ~(cpu_icache_line_size()-1) : ALMASK));
 }
@@ -434,7 +432,7 @@ static int setup_frame(void *sig_return, struct ksignal *ksig,
 	struct sigframe __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 		return -EFAULT;
 
@@ -473,7 +471,7 @@ static int setup_rt_frame(void *sig_return, struct ksignal *ksig,
 	struct rt_sigframe __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 		return -EFAULT;
 
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index eb8d0e2..d69179c 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -496,7 +496,7 @@ static int setup_frame_32(void *sig_return, struct ksignal *ksig,
 	struct sigframe32 __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 		return -EFAULT;
 
@@ -536,7 +536,7 @@ static int setup_rt_frame_32(void *sig_return, struct ksignal *ksig,
 	struct rt_sigframe32 __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 		return -EFAULT;
 
diff --git a/arch/mips/kernel/signal_n32.c b/arch/mips/kernel/signal_n32.c
index 7d04f28..f1d4751 100644
--- a/arch/mips/kernel/signal_n32.c
+++ b/arch/mips/kernel/signal_n32.c
@@ -108,7 +108,7 @@ static int setup_rt_frame_n32(void *sig_return, struct ksignal *ksig,
 	struct rt_sigframe_n32 __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
+	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 		return -EFAULT;
 
-- 
1.8.4.5

