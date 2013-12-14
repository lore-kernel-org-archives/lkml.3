Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3LMXKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:10:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:26757 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab3LMXKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:10:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,482,1384329600"; 
   d="scan'208";a="452093151"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 2/2] x86: replace futex_atomic_cmpxchg_inatomic() with user_atomic_cmpxchg_inatomic
Date: Sat, 14 Dec 2013 14:25:03 +0800
Message-Id: <1387002303-6620-2-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1387002303-6620-1-git-send-email-qiaowei.ren@intel.com>
References: <1387002303-6620-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex_atomic_cmpxchg_inatomic() is only the 32bit implementation of
user_atomic_cmpxchg_inatomic(). This patch replaces it with
user_atomic_cmpxchg_inatomic().

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/include/asm/futex.h |   27 ++-------------------------
 1 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index be27ba1..a9f7de4 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -41,6 +41,8 @@
 		       "+m" (*uaddr), "=&r" (tem)		\
 		     : "r" (oparg), "i" (-EFAULT), "1" (0))
 
+#define futex_atomic_cmpxchg_inatomic user_atomic_cmpxchg_inatomic
+
 static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
@@ -107,30 +109,5 @@ static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
-						u32 oldval, u32 newval)
-{
-	int ret = 0;
-
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
-		return -EFAULT;
-
-	asm volatile("\t" ASM_STAC "\n"
-		     "1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
-		     "2:\t" ASM_CLAC "\n"
-		     "\t.section .fixup, \"ax\"\n"
-		     "3:\tmov     %3, %0\n"
-		     "\tjmp     2b\n"
-		     "\t.previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : "+r" (ret), "=a" (oldval), "+m" (*uaddr)
-		     : "i" (-EFAULT), "r" (newval), "1" (oldval)
-		     : "memory"
-	);
-
-	*uval = oldval;
-	return ret;
-}
-
 #endif
 #endif /* _ASM_X86_FUTEX_H */
-- 
1.7.1

