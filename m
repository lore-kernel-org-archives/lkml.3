Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaEZRAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:00:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:54646 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbaEZQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122337"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 09/15] x86/xsaves: Use xsave/xrstor for saving and restoring user space context
Date: Mon, 26 May 2014 10:01:16 -0700
Message-Id: <1401123682-5384-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

We use legacy xsave/xrstor for user space context. No xsaveopt or xsaves is
used here.

We don't use modified optimization which is implemented in xsaveopt and xsaves
because xrstor/xrstors might track a different application.

We don't use compacted format xsave area in xsaves for backward compatibility
because old applications which don't understand compacted format of xsave area.
This may cosume more user context memory than compacted format. But in this
way legacy applications don't need any change to work with kernel.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/xsave.h | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index cfee67e..a8f31d0 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -143,6 +143,16 @@ static inline int fpu_xrstor_checking(struct xsave_struct *fx)
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
@@ -156,35 +166,28 @@ static inline int xsave_user(struct xsave_struct __user *buf)
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
-- 
1.8.1.2

