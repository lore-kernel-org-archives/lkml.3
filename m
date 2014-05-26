Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaEZRAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:00:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:43464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaEZQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122331"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 07/15] x86/xsaves: Use xsaves/xrstors for saving and restoring xsave area
Date: Mon, 26 May 2014 10:01:14 -0700
Message-Id: <1401123682-5384-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

If xsaves is eanbled, use xsaves/xrstors for saving and restoring xstate.
xsaves supports compacted format, init optimization, modified optimization,
and supervisor states.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/xsave.h | 82 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 62 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 76c2459..e538a0e 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -65,6 +65,68 @@ extern int init_fpu(struct task_struct *child);
 			_ASM_EXTABLE(1b, 3b)		\
 			: [err] "=r" (err)
 
+/*
+ * Save processor xstate to xsave area.
+ */
+static inline void xsave_state(struct xsave_struct *fx, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err = 0;
+
+	/*
+	 * If xsaves is enabled, xsaves replaces xsaveopt because
+	 * it supports compact format and supervisor states in addition to
+	 * modified optimization in xsaveopt.
+	 *
+	 * Otherwise, if xsaveopt is enabled, xsaveopt replaces xsave
+	 * because xsaveopt supports modified optimization which is not
+	 * supported by xsave.
+	 *
+	 * If none of xsaves and xsaveopt is enabled, use xsave.
+	 */
+	alternative_input_2(
+		"1:"XSAVE,
+		"1:"XSAVEOPT,
+		X86_FEATURE_XSAVEOPT,
+		"1:"XSAVES,
+		X86_FEATURE_XSAVES,
+		[fx] "D" (fx), "a" (lmask), "d" (hmask) :
+		"memory");
+	asm volatile("2:\n\t"
+		     xstate_fault
+		     : "0" (0)
+		     : "memory");
+}
+
+/*
+ * Restore processor xstate from xsave area.
+ */
+static inline int xrstor_state(struct xsave_struct *fx, u64 mask)
+{
+	int err = 0;
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
+	/*
+	 * Use xrstors to restore context if it is enabled. xrstors supports
+	 * compacted format of xsave area which is not supported by xrstor.
+	 */
+	alternative_input(
+		"1: " XRSTOR,
+		"1: " XRSTORS,
+		X86_FEATURE_XSAVES,
+		"D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+		: "memory");
+
+	asm volatile("2:\n"
+		     xstate_fault
+		     : "0" (0)
+		     : "memory");
+
+	return err;
+}
+
 static inline int fpu_xrstor_checking(struct xsave_struct *fx)
 {
 	int err;
@@ -130,26 +192,6 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
 	return err;
 }
 
-static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
-{
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-
-	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
-		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
-		     :   "memory");
-}
-
-static inline void xsave_state(struct xsave_struct *fx, u64 mask)
-{
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-
-	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x27\n\t"
-		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
-		     :   "memory");
-}
-
 static inline void fpu_xsave(struct fpu *fpu)
 {
 	/* This, however, we can work around by forcing the compiler to select
-- 
1.8.1.2

