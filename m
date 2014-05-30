Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbaE3PMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:12:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505AbaE3PMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:12:31 -0400
Date: Fri, 30 May 2014 08:12:15 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-f9de314b340f4816671f037e79ed01f685ac9787@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-10-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-10-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves: Use xsaves/xrstors for context switch
Git-Commit-ID: f9de314b340f4816671f037e79ed01f685ac9787
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

Commit-ID:  f9de314b340f4816671f037e79ed01f685ac9787
Gitweb:     http://git.kernel.org/tip/f9de314b340f4816671f037e79ed01f685ac9787
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:37 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:31:25 -0700

x86/xsaves: Use xsaves/xrstors for context switch

If xsaves is eanbled, use xsaves/xrstors for context switch to support
compacted format xsave area to occupy less memory and modified optimization
to improve saving performance.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-10-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/xsave.h | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index f9177a2..8b75824 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -129,22 +129,20 @@ static inline int xrstor_state(struct xsave_struct *fx, u64 mask)
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
@@ -194,15 +192,4 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
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
