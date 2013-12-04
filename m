Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab3LDWwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:52:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3LDWwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:52:21 -0500
Date: Wed, 4 Dec 2013 14:51:40 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-e0f6dec35f9286e78879fe1ac92803fd69fc4fdc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, jesse.brandeburg@intel.com,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        jesse.brandeburg@intel.com
In-Reply-To: <529E8719.4070202@zytor.com>
References: <529E8719.4070202@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, bitops:
  Correct the assembly constraints to testing bitops
Git-Commit-ID: e0f6dec35f9286e78879fe1ac92803fd69fc4fdc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 14:51:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0f6dec35f9286e78879fe1ac92803fd69fc4fdc
Gitweb:     http://git.kernel.org/tip/e0f6dec35f9286e78879fe1ac92803fd69fc4fdc
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 4 Dec 2013 14:31:28 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 4 Dec 2013 14:31:28 -0800

x86, bitops: Correct the assembly constraints to testing bitops

In checkin:

0c44c2d0f459 x86: Use asm goto to implement better modify_and_test() functions

the various functions which do modify and test were unified and
optimized using "asm goto".  However, this change missed the detail
that the bitops require an "Ir" constraint rather than an "er"
constraint ("I" = integer constant from 0-31, "e" = signed 32-bit
integer constant).  This would cause code to miscompile if these
functions were used on constant bit positions 32-255 and the build to
fail if used on constant bit positions above 255.

Add the constraints as a parameter to the GEN_BINARY_RMWcc() macro to
avoid this problem.

Reported-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/529E8719.4070202@zytor.com
---
 arch/x86/include/asm/atomic.h      | 4 ++--
 arch/x86/include/asm/atomic64_64.h | 4 ++--
 arch/x86/include/asm/bitops.h      | 6 +++---
 arch/x86/include/asm/local.h       | 4 ++--
 arch/x86/include/asm/rmwcc.h       | 8 ++++----
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index da31c8b..b17f4f4 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -77,7 +77,7 @@ static inline void atomic_sub(int i, atomic_t *v)
  */
 static inline int atomic_sub_and_test(int i, atomic_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", v->counter, i, "%0", "e");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", v->counter, "er", i, "%0", "e");
 }
 
 /**
@@ -141,7 +141,7 @@ static inline int atomic_inc_and_test(atomic_t *v)
  */
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", v->counter, i, "%0", "s");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", v->counter, "er", i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 3f065c9..46e9052 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -72,7 +72,7 @@ static inline void atomic64_sub(long i, atomic64_t *v)
  */
 static inline int atomic64_sub_and_test(long i, atomic64_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, i, "%0", "e");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, "er", i, "%0", "e");
 }
 
 /**
@@ -138,7 +138,7 @@ static inline int atomic64_inc_and_test(atomic64_t *v)
  */
 static inline int atomic64_add_negative(long i, atomic64_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, i, "%0", "s");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, "er", i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 6d76d09..9fc1af7 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -205,7 +205,7 @@ static inline void change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, nr, "%0", "c");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", "c");
 }
 
 /**
@@ -251,7 +251,7 @@ static inline int __test_and_set_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, nr, "%0", "c");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, "Ir", nr, "%0", "c");
 }
 
 /**
@@ -304,7 +304,7 @@ static inline int __test_and_change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_change_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, nr, "%0", "c");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, "Ir", nr, "%0", "c");
 }
 
 static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index 5b23e60..4ad6560 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -52,7 +52,7 @@ static inline void local_sub(long i, local_t *l)
  */
 static inline int local_sub_and_test(long i, local_t *l)
 {
-	GEN_BINARY_RMWcc(_ASM_SUB, l->a.counter, i, "%0", "e");
+	GEN_BINARY_RMWcc(_ASM_SUB, l->a.counter, "er", i, "%0", "e");
 }
 
 /**
@@ -92,7 +92,7 @@ static inline int local_inc_and_test(local_t *l)
  */
 static inline int local_add_negative(long i, local_t *l)
 {
-	GEN_BINARY_RMWcc(_ASM_ADD, l->a.counter, i, "%0", "s");
+	GEN_BINARY_RMWcc(_ASM_ADD, l->a.counter, "er", i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 1ff990f..8f7866a 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -16,8 +16,8 @@ cc_label:								\
 #define GEN_UNARY_RMWcc(op, var, arg0, cc) 				\
 	__GEN_RMWcc(op " " arg0, var, cc)
 
-#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
-	__GEN_RMWcc(op " %1, " arg0, var, cc, "er" (val))
+#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
+	__GEN_RMWcc(op " %1, " arg0, var, cc, vcon (val))
 
 #else /* !CC_HAVE_ASM_GOTO */
 
@@ -33,8 +33,8 @@ do {									\
 #define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
 	__GEN_RMWcc(op " " arg0, var, cc)
 
-#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
-	__GEN_RMWcc(op " %2, " arg0, var, cc, "er" (val))
+#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
+	__GEN_RMWcc(op " %2, " arg0, var, cc, vcon (val))
 
 #endif /* CC_HAVE_ASM_GOTO */
 
