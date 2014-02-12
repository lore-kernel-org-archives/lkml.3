Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaBLIS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:18:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50319 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbaBLIOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:11 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "halfdog" <me@halfdog.net>,
        "H. Peter Anvin" <hpa@zytor.com>, "Borislav Petkov" <bp@suse.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.36478319@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 26/79] x86, fpu, amd: Clear exceptions in AMD FXSAVE
 workaround
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 26bef1318adc1b3a530ecc807ef99346db2aa8b0 upstream.

Before we do an EMMS in the AMD FXSAVE information leak workaround we
need to clear any pending exceptions, otherwise we trap with a
floating-point exception inside this code.

Reported-by: halfdog <me@halfdog.net>
Tested-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/CA%2B55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/traps.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -582,12 +582,13 @@ void __math_state_restore(struct task_st
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
-	alternative_input(
-		ASM_NOP8 ASM_NOP2,
-		"emms\n\t"	  	/* clear stack tags */
-		"fildl %P[addr]",	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (safe_address));
+	if (unlikely(static_cpu_has(X86_FEATURE_FXSAVE_LEAK))) {
+		asm volatile(
+			"fnclex\n\t"
+			"emms\n\t"
+			"fildl %P[addr]"	/* set F?P to defined value */
+			: : [addr] "m" (safe_address));
+	}
 
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.

