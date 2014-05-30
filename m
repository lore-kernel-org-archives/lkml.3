Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbaE3PMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:12:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638AbaE3PMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:12:15 -0400
Date: Fri, 30 May 2014 08:12:03 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-f31a9f7c71691569359fa7fb8b0acaa44bce0324@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-9-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-9-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves: Use xsaves/
 xrstors to save and restore xsave area
Git-Commit-ID: f31a9f7c71691569359fa7fb8b0acaa44bce0324
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f31a9f7c71691569359fa7fb8b0acaa44bce0324
Gitweb:     http://git.kernel.org/tip/f31a9f7c71691569359fa7fb8b0acaa44bce0324
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:36 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:31:21 -0700

x86/xsaves: Use xsaves/xrstors to save and restore xsave area

If xsaves is eanbled, use xsaves/xrstors instrucitons to save and restore
xstate. xsaves and xrstors support compacted format, init optimization,
modified optimization, and supervisor states.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-9-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/xsave.h | 84 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 76c2459..f9177a2 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -65,6 +65,70 @@ extern int init_fpu(struct task_struct *child);
 			_ASM_EXTABLE(1b, 3b)		\
 			: [err] "=r" (err)
 
+/*
+ * Save processor xstate to xsave area.
+ */
+static inline int xsave_state(struct xsave_struct *fx, u64 mask)
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
+
+	return err;
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
@@ -130,26 +194,6 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
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
