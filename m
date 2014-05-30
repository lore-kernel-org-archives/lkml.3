Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733AbaE3PMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:12:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbaE3PMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:12:43 -0400
Date: Fri, 30 May 2014 08:12:32 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-facbf4d91ae64f84ef93a00e4037135cd9f4b2ab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-11-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-11-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves: Use xsave/
 xrstor for saving and restoring user space context
Git-Commit-ID: facbf4d91ae64f84ef93a00e4037135cd9f4b2ab
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

Commit-ID:  facbf4d91ae64f84ef93a00e4037135cd9f4b2ab
Gitweb:     http://git.kernel.org/tip/facbf4d91ae64f84ef93a00e4037135cd9f4b2ab
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:38 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:32:57 -0700

x86/xsaves: Use xsave/xrstor for saving and restoring user space context

We use legacy xsave/xrstor to save and restore standard form of xsave area
in user space context. No xsaveopt or xsaves is used here for two reasons.

First, we don't want to use modified optimization which is implemented in
xsaveopt and xsaves because xrstor/xrstors might track a wrong user space
application.

Secondly, we don't use compacted format of xsave area for backward
compatibility because legacy user space applications only don't understand
the compacted format of the xsave area.

Using standard form of the xsave area may allocate more memory for
user context than compacted form, but preserves compatibility with
legacy applications.  Furthermore, even with holes, the relevant cache
lines don't get touched and thus the performance impact is limited.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-11-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/xsave.h | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 8b75824..0d15231 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -145,6 +145,16 @@ static inline int fpu_xrstor_checking(struct xsave_struct *fx)
 	return xrstor_state(fx, -1);
 }
 
+/*
+ * Save xstate to user space xsave area.
+ *
+ * We don't use modified optimization because xrstor/xrstors might track
+ * a different application.
+ *
+ * We don't use compacted format xsave area for
+ * backward compatibility for old applications which don't understand
+ * compacted format of xsave area.
+ */
 static inline int xsave_user(struct xsave_struct __user *buf)
 {
 	int err;
@@ -158,35 +168,28 @@ static inline int xsave_user(struct xsave_struct __user *buf)
 		return -EFAULT;
 
 	__asm__ __volatile__(ASM_STAC "\n"
-			     "1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
+			     "1:"XSAVE"\n"
 			     "2: " ASM_CLAC "\n"
-			     ".section .fixup,\"ax\"\n"
-			     "3:  movl $-1,%[err]\n"
-			     "    jmp  2b\n"
-			     ".previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : [err] "=r" (err)
+			     xstate_fault
 			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
 			     : "memory");
 	return err;
 }
 
+/*
+ * Restore xstate from user space xsave area.
+ */
 static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
 {
-	int err;
+	int err = 0;
 	struct xsave_struct *xstate = ((__force struct xsave_struct *)buf);
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 
 	__asm__ __volatile__(ASM_STAC "\n"
-			     "1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
+			     "1:"XRSTOR"\n"
 			     "2: " ASM_CLAC "\n"
-			     ".section .fixup,\"ax\"\n"
-			     "3:  movl $-1,%[err]\n"
-			     "    jmp  2b\n"
-			     ".previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : [err] "=r" (err)
+			     xstate_fault
 			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
 			     : "memory");	/* memory required? */
 	return err;
