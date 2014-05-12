Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbaELBpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:45:25 -0400
Received: from 1wt.eu ([62.212.114.60]:34826 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbaELBpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:45:19 -0400
Message-Id: <20140512003205.607397016@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 119/143] x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

Before we do an EMMS in the AMD FXSAVE information leak workaround we
need to clear any pending exceptions, otherwise we trap with a
floating-point exception inside this code.

Reported-by: halfdog <me@halfdog.net>
Tested-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/CA%2B55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
(cherry picked from commit 26bef1318adc1b3a530ecc807ef99346db2aa8b0)
[wt: in 2.6.32, patch applies to arch/x86/include/asm/i387.h. There's
 no static_cpu_has() so we use boot_cpu_has() like other kernels do
 with gcc3.
]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/i387.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 0b20bbb..cb42fad 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -242,12 +242,13 @@ clear_state:
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
-	alternative_input(
-		GENERIC_NOP8 GENERIC_NOP2,
-		"emms\n\t"	  	/* clear stack tags */
-		"fildl %[addr]", 	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (safe_address));
+	if (unlikely(boot_cpu_has(X86_FEATURE_FXSAVE_LEAK))) {
+		asm volatile(
+			"fnclex\n\t"
+			"emms\n\t"
+			"fildl %[addr]"        /* set F?P to defined value */
+			: : [addr] "m" (safe_address));
+	}
 end:
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
-- 
1.7.12.2.21.g234cd45.dirty



