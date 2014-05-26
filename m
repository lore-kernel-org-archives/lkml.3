Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaEZRAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:00:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:39338 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaEZQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122334"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 08/15] x86/xsaves: Use xsaves/xrstors for context switch
Date: Mon, 26 May 2014 10:01:15 -0700
Message-Id: <1401123682-5384-9-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

If xsaves is eanbled, use xsaves/xrstors for context switch to utilize
compacted format xsave area and modified optimization.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/xsave.h | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index e538a0e..cfee67e 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -127,22 +127,20 @@ static inline int xrstor_state(struct xsave_struct *fx, u64 mask)
 	return err;
 }
 
-static inline int fpu_xrstor_checking(struct xsave_struct *fx)
+/*
+ * Save xstate context for old process during context switch.
+ */
+static inline void fpu_xsave(struct fpu *fpu)
 {
-	int err;
-
-	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err)
-		     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
-		     : "memory");
+	xsave_state(&fpu->state->xsave, -1);
+}
 
-	return err;
+/*
+ * Restore xstate context for new process during context switch.
+ */
+static inline int fpu_xrstor_checking(struct xsave_struct *fx)
+{
+	return xrstor_state(fx, -1);
 }
 
 static inline int xsave_user(struct xsave_struct __user *buf)
@@ -192,15 +190,4 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
 	return err;
 }
 
-static inline void fpu_xsave(struct fpu *fpu)
-{
-	/* This, however, we can work around by forcing the compiler to select
-	   an addressing mode that doesn't require extended registers. */
-	alternative_input(
-		".byte " REX_PREFIX "0x0f,0xae,0x27",
-		".byte " REX_PREFIX "0x0f,0xae,0x37",
-		X86_FEATURE_XSAVEOPT,
-		[fx] "D" (&fpu->state->xsave), "a" (-1), "d" (-1) :
-		"memory");
-}
 #endif
-- 
1.8.1.2

