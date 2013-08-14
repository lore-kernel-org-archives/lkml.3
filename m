Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab3HNAHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:07:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:44590 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627Ab3HNAHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:07:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,873,1367996400"; 
   d="scan'208";a="386655097"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 7/8] x86: Remove cond_resched() from uaccess code
Date: Tue, 13 Aug 2013 17:07:15 -0700
Message-Id: <1376438836-13339-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
References: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

As suggested by Linus, remove cond_resched() from the x86 uaccess code.
Now we only do might_fault() in debug kernels.

This means *_user() is not a reschedule point anymore for
CONFIG_PREEMPT_VOLUNTARY, only explicit cond_resched()s are.

Even in the debug kernels we should probably move
it out of line where possible, but that's left for future patches.

I did some tests with ftrace's max wakeup latency tracer
and CONFIG_PREEMPT_VOLUNTARY:

          no-resched   resched
aim7      45 us        319 us
ebizzy    123 us       117 us
hackbench 416 us       50 us
kbench    14960 us     19741 us

I'm not sure the results are very conclusive, as they go both
ways. Most likely it costs a bit.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h    |  4 ++--
 arch/x86/include/asm/uaccess_32.h |  6 +++---
 arch/x86/include/asm/uaccess_64.h | 12 ++++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 8fa3bd6..c860ebe 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -165,7 +165,7 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 	int __ret_gu;							\
 	register __inttype(*(ptr)) __val_gu asm("%edx");		\
 	__chk_user_ptr(ptr);						\
-	might_fault();							\
+	might_fault_debug_only();					\
 	asm volatile("call __get_user_%P3"				\
 		     : "=a" (__ret_gu), "=r" (__val_gu)			\
 		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
@@ -246,7 +246,7 @@ extern void __put_user_8(void);
 	int __ret_pu;						\
 	__typeof__(*(ptr)) __pu_val;				\
 	__chk_user_ptr(ptr);					\
-	might_fault();						\
+	might_fault_debug_only();				\
 	__pu_val = x;						\
 	switch (sizeof(*(ptr))) {				\
 	case 1:							\
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 7f760a9..e656ee9 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -81,7 +81,7 @@ __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 static __always_inline unsigned long __must_check
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-	might_fault();
+	might_fault_debug_only();
 	return __copy_to_user_inatomic(to, from, n);
 }
 
@@ -136,7 +136,7 @@ __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
 static __always_inline unsigned long
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-	might_fault();
+	might_fault_debug_only();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
@@ -158,7 +158,7 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 static __always_inline unsigned long __copy_from_user_nocache(void *to,
 				const void __user *from, unsigned long n)
 {
-	might_fault();
+	might_fault_debug_only();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 64476bb..5a3bb4e 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -58,7 +58,7 @@ static inline unsigned long __must_check copy_from_user(void *to,
 {
 	int sz = __compiletime_object_size(to);
 
-	might_fault();
+	might_fault_debug_only();
 	if (likely(sz == -1 || sz >= n))
 		n = _copy_from_user(to, from, n);
 #ifdef CONFIG_DEBUG_VM
@@ -71,7 +71,7 @@ static inline unsigned long __must_check copy_from_user(void *to,
 static __always_inline __must_check
 int copy_to_user(void __user *dst, const void *src, unsigned size)
 {
-	might_fault();
+	might_fault_debug_only();
 
 	return _copy_to_user(dst, src, size);
 }
@@ -122,7 +122,7 @@ int __copy_from_user_nocheck(void *dst, const void __user *src, unsigned size)
 static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
 {
-	might_fault();
+	might_fault_debug_only();
 	return __copy_from_user_nocheck(dst, src, size);
 }
 
@@ -172,7 +172,7 @@ int __copy_to_user_nocheck(void __user *dst, const void *src, unsigned size)
 static __always_inline __must_check
 int __copy_to_user(void __user *dst, const void *src, unsigned size)
 {
-	might_fault();
+	might_fault_debug_only();
 	return __copy_to_user_nocheck(dst, src, size);
 }
 
@@ -181,7 +181,7 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
 
-	might_fault();
+	might_fault_debug_only();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst,
 					 (__force void *)src, size);
@@ -247,7 +247,7 @@ extern long __copy_user_nocache(void *dst, const void __user *src,
 static inline int
 __copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
 {
-	might_fault();
+	might_fault_debug_only();
 	return __copy_user_nocache(dst, src, size, 1);
 }
 
-- 
1.8.3.1

