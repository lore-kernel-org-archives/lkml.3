Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935219Ab3GWW6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:58:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934431Ab3GWW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 007/103] powerpc/tm: Fix restoration of MSR on 32bit signal return
Date: Tue, 23 Jul 2013 15:25:18 -0700
Message-Id: <20130723220419.383567032@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 2c27a18f8736da047bef2b997bdd48efc667e3c9 upstream.

Currently we clear out the MSR TM bits on signal return assuming that the
signal should never return to an active transaction.

This is bogus as the user may do this.  It's most likely the transaction will
be doomed due to a treclaim but that's a problem for the HW not the kernel.

The current code is a legacy of earlier kernel implementations which did
software rollback of active transactions in the kernel.  That code has now gone
but we didn't correctly fix up this part of the signals code which still makes
the assumption that it must be returning to a suspended transaction.

This pulls out both MSR TM bits from the user supplied context rather than just
setting TM suspend.  We pull out only the bits needed to ensure the user can't
do anything dangerous to the MSR.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/signal_32.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -754,7 +754,7 @@ static long restore_tm_user_regs(struct
 				 struct mcontext __user *tm_sr)
 {
 	long err;
-	unsigned long msr;
+	unsigned long msr, msr_hi;
 #ifdef CONFIG_VSX
 	int i;
 #endif
@@ -859,8 +859,11 @@ static long restore_tm_user_regs(struct
 	tm_enable();
 	/* This loads the checkpointed FP/VEC state, if used */
 	tm_recheckpoint(&current->thread, msr);
-	/* The task has moved into TM state S, so ensure MSR reflects this */
-	regs->msr = (regs->msr & ~MSR_TS_MASK) | MSR_TS_S;
+	/* Get the top half of the MSR */
+	if (__get_user(msr_hi, &tm_sr->mc_gregs[PT_MSR]))
+		return 1;
+	/* Pull in MSR TM from user context */
+	regs->msr = (regs->msr & ~MSR_TS_MASK) | ((msr_hi<<32) & MSR_TS_MASK);
 
 	/* This loads the speculative FP/VEC state, if used */
 	if (msr & MSR_FP) {


