Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaJJXZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:25:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:54726 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaJJXZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,695,1406617200"; 
   d="scan'208";a="587028031"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] x86: Move copy_from_user_nmi() inline
Date: Fri, 10 Oct 2014 16:25:15 -0700
Message-Id: <1412983517-12419-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
References: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Move copy_from_user_nmi() inline. This allows the compiler to directly
do the __builtin_constant_p() optimizations in __copy_from_user_nocheck.

This then allows to optimize an 8 byte (32bit) or 16byte copy (64bit)
into two direct __get_user() instead of using the generic copy function.

This covers the 8/16 byte copies dump_stack uses when called from
the performance critical perf nmi pmi handler.

First this is much faster by itself (single memory access vs complicated
function). But it also is a lot faster for any page fault, which are
common in backtracing. Currently copy_from_user() does every page
fault twice, to generate an exact unread-bytes count. This adds a lot
of overhead. The inline __get_user code can do this without significant
overhead, it bails out on the first fault.

copy_from_user_nmi() is only placed from a few places, so there
isn't any significant code size increase from inlining this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h | 29 +++++++++++++++++++++++++++--
 arch/x86/lib/usercopy.c        | 36 ------------------------------------
 2 files changed, 27 insertions(+), 38 deletions(-)
 delete mode 100644 arch/x86/lib/usercopy.c

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index e50a84f..30c391c 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -523,8 +523,6 @@ struct __large_struct { unsigned long buf[100]; };
 #define put_user_ex(x, ptr)						\
 	__put_user_size_ex((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
-extern unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
 extern __must_check long
 strncpy_from_user(char *dst, const char __user *src, long count);
 
@@ -741,5 +739,32 @@ copy_to_user(void __user *to, const void *from, unsigned long n)
 #undef __copy_from_user_overflow
 #undef __copy_to_user_overflow
 
+/*
+ * We rely on the nested NMI work to allow atomic faults from the NMI path; the
+ * nested NMI paths are careful to preserve CR2.
+ *
+ * Inline this function so that the caller gets the __builtin_constant_p
+ * optimizations in __copy_from_user_nocheck
+ */
+static __must_check __always_inline unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+{
+	unsigned long ret;
+
+	if (__range_not_ok(from, n, user_addr_max()))
+		return 0;
+
+	/*
+	 * Even though this function is typically called from NMI/IRQ context
+	 * disable pagefaults so that its behaviour is consistent even when
+	 * called form other contexts.
+	 */
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(to, from, n);
+	pagefault_enable();
+
+	return ret;
+}
+
 #endif /* _ASM_X86_UACCESS_H */
 
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
deleted file mode 100644
index ddf9ecb..0000000
--- a/arch/x86/lib/usercopy.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * User address space access functions.
- *
- *  For licencing details see kernel-base/COPYING
- */
-
-#include <linux/highmem.h>
-#include <linux/module.h>
-
-#include <asm/word-at-a-time.h>
-#include <linux/sched.h>
-
-/*
- * We rely on the nested NMI work to allow atomic faults from the NMI path; the
- * nested NMI paths are careful to preserve CR2.
- */
-unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
-{
-	unsigned long ret;
-
-	if (__range_not_ok(from, n, TASK_SIZE))
-		return 0;
-
-	/*
-	 * Even though this function is typically called from NMI/IRQ context
-	 * disable pagefaults so that its behaviour is consistent even when
-	 * called form other contexts.
-	 */
-	pagefault_disable();
-	ret = __copy_from_user_inatomic(to, from, n);
-	pagefault_enable();
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(copy_from_user_nmi);
-- 
1.9.3

