Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab3L2Cjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:39:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55386 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab3L2CKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:35 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael Neuling" <mikey@neuling.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.859058816@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 088/185] powerpc/signals: Improved mark VSX not saved
 with small contexts fix
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/signal_32.c | 16 +++++++---------
 arch/powerpc/kernel/signal_64.c |  6 ++++++
 2 files changed, 13 insertions(+), 9 deletions(-)

--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -445,6 +445,12 @@ static int save_user_regs(struct pt_regs
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
@@ -457,15 +463,7 @@ static int save_user_regs(struct pt_regs
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
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -116,6 +116,12 @@ static long setup_sigcontext(struct sigc
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

