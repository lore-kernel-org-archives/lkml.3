Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3KDQzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:55:12 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:38312 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3KDQzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:55:10 -0500
Date: Mon, 4 Nov 2013 16:55:05 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Liu Yu <yu.liu@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Shan Hai <shan.hai@windriver.com>
Subject: [PATCH 6/6] powerpc: fix e500 SPE float SIGFPE generation
In-Reply-To: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
Message-ID: <Pine.LNX.4.64.1311041654520.4290@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 04 Nov 2013 16:55:09.0481 (UTC) FILETIME=[9EDE7990:01CED97E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Myers <joseph@codesourcery.com>

The e500 SPE floating-point emulation code is called from
SPEFloatingPointException and SPEFloatingPointRoundException in
arch/powerpc/kernel/traps.c.  Those functions have support for
generating SIGFPE, but do_spe_mathemu and speround_handler don't
generate a return value to indicate that this should be done.  Such a
return value should depend on whether an exception is raised that has
been set via prctl to generate SIGFPE.  This patch adds the relevant
logic in these functions so that SIGFPE is generated as expected by
the glibc testsuite.

Signed-off-by: Joseph Myers <joseph@codesourcery.com>

---

Previous submission: <http://lkml.org/lkml/2013/10/10/626>.

diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index 01a0abb..28337c9 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/prctl.h>
 
 #include <asm/uaccess.h>
 #include <asm/reg.h>
@@ -691,6 +692,23 @@ update_regs:
 	pr_debug("va: %08x  %08x\n", va.wp[0], va.wp[1]);
 	pr_debug("vb: %08x  %08x\n", vb.wp[0], vb.wp[1]);
 
+	if (current->thread.fpexc_mode & PR_FP_EXC_SW_ENABLE) {
+		if ((FP_CUR_EXCEPTIONS & FP_EX_DIVZERO)
+		    && (current->thread.fpexc_mode & PR_FP_EXC_DIV))
+			return 1;
+		if ((FP_CUR_EXCEPTIONS & FP_EX_OVERFLOW)
+		    && (current->thread.fpexc_mode & PR_FP_EXC_OVF))
+			return 1;
+		if ((FP_CUR_EXCEPTIONS & FP_EX_UNDERFLOW)
+		    && (current->thread.fpexc_mode & PR_FP_EXC_UND))
+			return 1;
+		if ((FP_CUR_EXCEPTIONS & FP_EX_INEXACT)
+		    && (current->thread.fpexc_mode & PR_FP_EXC_RES))
+			return 1;
+		if ((FP_CUR_EXCEPTIONS & FP_EX_INVALID)
+		    && (current->thread.fpexc_mode & PR_FP_EXC_INV))
+			return 1;
+	}
 	return 0;
 
 illegal:
@@ -867,6 +885,8 @@ int speround_handler(struct pt_regs *regs)
 
 	pr_debug("  to fgpr: %08x  %08x\n", fgpr.wp[0], fgpr.wp[1]);
 
+	if (current->thread.fpexc_mode & PR_FP_EXC_SW_ENABLE)
+		return (current->thread.fpexc_mode & PR_FP_EXC_RES) ? 1 : 0;
 	return 0;
 }
 

-- 
Joseph S. Myers
joseph@codesourcery.com
