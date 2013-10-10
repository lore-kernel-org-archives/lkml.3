Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab3JJU3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:29:44 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:50650 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab3JJU3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:29:43 -0400
Date: Thu, 10 Oct 2013 20:29:38 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc: fix e500 SPE float SIGFPE generation
Message-ID: <Pine.LNX.4.64.1310102028150.11458@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 10 Oct 2013 20:29:42.0173 (UTC) FILETIME=[7343A4D0:01CEC5F7]
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

This patch is not intended to depend on any of my previous patches
<http://lkml.org/lkml/2013/10/4/495>,
<http://lkml.org/lkml/2013/10/4/497>,
<http://lkml.org/lkml/2013/10/8/694>,
<http://lkml.org/lkml/2013/10/8/700> and
<http://lkml.org/lkml/2013/10/8/705>, although testing has been on top
of that patch series and having all six patches will produce the best
results.

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
