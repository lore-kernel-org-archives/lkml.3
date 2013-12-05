Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3LERnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:43:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38425 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab3LERiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 78/90] powerpc/signals: Improved mark VSX not saved with small contexts fix
Date: Thu,  5 Dec 2013 17:36:00 +0000
Message-Id: <1386264972-5399-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit ec67ad82814bee92251fd963bf01c7a173856555 upstream.

In a recent patch:
  commit c13f20ac48328b05cd3b8c19e31ed6c132b44b42
  Author: Michael Neuling <mikey@neuling.org>
  powerpc/signals: Mark VSX not saved with small contexts

We fixed an issue but an improved solution was later discussed after the patch
was merged.

Firstly, this patch doesn't handle the 64bit signals case, which could also hit
this issue (but has never been reported).

Secondly, the original patch isn't clear what MSR VSX should be set to.  The
new approach below always clears the MSR VSX bit (to indicate no VSX is in the
context) and sets it only in the specific case where VSX is available (ie. when
VSX has been used and the signal context passed has space to provide the
state).

This reverts the original patch and replaces it with the improved solution.  It
also adds a 64 bit version.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/signal_32.c | 16 +++++++---------
 arch/powerpc/kernel/signal_64.c |  6 ++++++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index c2a2001..14d2c04 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -438,6 +438,12 @@ static int save_user_regs(struct pt_regs *regs, struct mcontext __user *frame,
 #endif /* CONFIG_ALTIVEC */
 	if (copy_fpr_to_user(&frame->mc_fregs, current))
 		return 1;
+
+	/*
+	 * Clear the MSR VSX bit to indicate there is no valid state attached
+	 * to this context, except in the specific case below where we set it.
+	 */
+	msr &= ~MSR_VSX;
 #ifdef CONFIG_VSX
 	/*
 	 * Copy VSR 0-31 upper half from thread_struct to local
@@ -450,15 +456,7 @@ static int save_user_regs(struct pt_regs *regs, struct mcontext __user *frame,
 		if (copy_vsx_to_user(&frame->mc_vsregs, current))
 			return 1;
 		msr |= MSR_VSX;
-	} else if (!ctx_has_vsx_region)
-		/*
-		 * With a small context structure we can't hold the VSX
-		 * registers, hence clear the MSR value to indicate the state
-		 * was not saved.
-		 */
-		msr &= ~MSR_VSX;
-
-
+	}
 #endif /* CONFIG_VSX */
 #ifdef CONFIG_SPE
 	/* save spe registers */
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index d183f87..ff33391 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -117,6 +117,12 @@ static long setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
 	flush_fp_to_thread(current);
 	/* copy fpr regs and fpscr */
 	err |= copy_fpr_to_user(&sc->fp_regs, current);
+
+	/*
+	 * Clear the MSR VSX bit to indicate there is no valid state attached
+	 * to this context, except in the specific case below where we set it.
+	 */
+	msr &= ~MSR_VSX;
 #ifdef CONFIG_VSX
 	/*
 	 * Copy VSX low doubleword to local buffer for formatting,
-- 
1.8.3.2

