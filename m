Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaALDWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 22:22:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaALDWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 22:22:34 -0500
Date: Sat, 11 Jan 2014 19:22:00 -0800
From: tip-bot for Linus Torvalds <tipbot@zytor.com>
Message-ID: <tip-26bef1318adc1b3a530ecc807ef99346db2aa8b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, bp@suse.de,
        me@halfdog.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, bp@suse.de,
        me@halfdog.net
In-Reply-To: <CA+55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com>
References: <CA+55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, fpu, amd:
  Clear exceptions in AMD FXSAVE workaround
Git-Commit-ID: 26bef1318adc1b3a530ecc807ef99346db2aa8b0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 11 Jan 2014 19:22:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26bef1318adc1b3a530ecc807ef99346db2aa8b0
Gitweb:     http://git.kernel.org/tip/26bef1318adc1b3a530ecc807ef99346db2aa8b0
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Sat, 11 Jan 2014 19:15:52 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 11 Jan 2014 19:15:52 -0800

x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Before we do an EMMS in the AMD FXSAVE information leak workaround we
need to clear any pending exceptions, otherwise we trap with a
floating-point exception inside this code.

Reported-by: halfdog <me@halfdog.net>
Tested-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/CA%2B55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/fpu-internal.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index c49a613..cea1c76 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -293,12 +293,13 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. "m" is a random variable that should be in L1 */
-	alternative_input(
-		ASM_NOP8 ASM_NOP2,
-		"emms\n\t"		/* clear stack tags */
-		"fildl %P[addr]",	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (tsk->thread.fpu.has_fpu));
+	if (unlikely(static_cpu_has(X86_FEATURE_FXSAVE_LEAK))) {
+		asm volatile(
+			"fnclex\n\t"
+			"emms\n\t"
+			"fildl %P[addr]"	/* set F?P to defined value */
+			: : [addr] "m" (tsk->thread.fpu.has_fpu));
+	}
 
 	return fpu_restore_checking(&tsk->thread.fpu);
 }
