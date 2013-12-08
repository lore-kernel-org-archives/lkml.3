Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3LHHaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 02:30:23 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63998 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3LHHaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 02:30:20 -0500
From: Luming Yu <luming.yu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>
Subject: [PATCH] Add HLE devl head file and several usages in kernel 
Date: Sun,  8 Dec 2013 15:30:08 +0800
Message-Id: <1386487808-10128-1-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For new Instruction Prefixes XACQUIRE and XRELEASE to enable kernel to use 
the new memory model that affects the critical sections with a hope to enable 
atomic memory concurrency in the absence of data conflicts based on description
in chapter 12 of Intel SDM optimization guide. My understanding is that it can 
give your atomic operations some certian of relif from strictly sequentially 
consistent atomic semantics to acquire-release model in terms of happens-before
semantic that only applies to the dependent variables.  
see gcc.gnu.org/wiki/Atomic/GCCMM/AtomicSync 

Signed-off-by: Luming Yu <luming.yu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/alternative.h   |   3 +
 arch/x86/include/asm/atomic.h        |  12 +--
 arch/x86/include/asm/hle-emulation.h | 204 +++++++++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/include/asm/hle-emulation.h

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 0a3f9c9..f38cd3a 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -6,6 +6,7 @@
 #include <linux/stringify.h>
 #include <asm/asm.h>
 #include <asm/ptrace.h>
+#include <asm/hle-emulation.h>
 
 /*
  * Alternative inline assembly for SMP.
@@ -37,6 +38,8 @@
 		"671:"
 
 #define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "
+#define LOCK_PREFIXA LOCK_PREFIX_HERE __HLE_ACQUIRE "\n\tlock; "
+#define LOCK_PREFIXR LOCK_PREFIX_HERE __HLE_RELEASE "\n\tlock; "
 
 #else /* ! CONFIG_SMP */
 #define LOCK_PREFIX_HERE ""
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index b17f4f4..91d331c 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -47,7 +47,7 @@ static inline void atomic_set(atomic_t *v, int i)
  */
 static inline void atomic_add(int i, atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "addl %1,%0"
+	asm volatile(LOCK_PREFIXA "addl %1,%0"
 		     : "+m" (v->counter)
 		     : "ir" (i));
 }
@@ -61,7 +61,7 @@ static inline void atomic_add(int i, atomic_t *v)
  */
 static inline void atomic_sub(int i, atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "subl %1,%0"
+	asm volatile(LOCK_PREFIXR "subl %1,%0"
 		     : "+m" (v->counter)
 		     : "ir" (i));
 }
@@ -88,7 +88,7 @@ static inline int atomic_sub_and_test(int i, atomic_t *v)
  */
 static inline void atomic_inc(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "incl %0"
+	asm volatile(LOCK_PREFIXA "incl %0"
 		     : "+m" (v->counter));
 }
 
@@ -100,7 +100,7 @@ static inline void atomic_inc(atomic_t *v)
  */
 static inline void atomic_dec(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "decl %0"
+	asm volatile(LOCK_PREFIXR "decl %0"
 		     : "+m" (v->counter));
 }
 
@@ -114,7 +114,7 @@ static inline void atomic_dec(atomic_t *v)
  */
 static inline int atomic_dec_and_test(atomic_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "decl", v->counter, "%0", "e");
+	GEN_UNARY_RMWcc(LOCK_PREFIXR "decl", v->counter, "%0", "e");
 }
 
 /**
@@ -127,7 +127,7 @@ static inline int atomic_dec_and_test(atomic_t *v)
  */
 static inline int atomic_inc_and_test(atomic_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "incl", v->counter, "%0", "e");
+	GEN_UNARY_RMWcc(LOCK_PREFIXA "incl", v->counter, "%0", "e");
 }
 
 /**
diff --git a/arch/x86/include/asm/hle-emulation.h b/arch/x86/include/asm/hle-emulation.h
new file mode 100644
index 0000000..4670002
--- /dev/null
+++ b/arch/x86/include/asm/hle-emulation.h
@@ -0,0 +1,204 @@
+#ifndef _HLE_H
+#define _HLE_H 1
+
+/*
+ * Copyright (c) 2012,2013 Intel Corporation
+ * Author: Andi Kleen
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that: (1) source code distributions
+ * retain the above copyright notice and this paragraph in its entirety, (2)
+ * distributions including binary code include the above copyright notice and
+ * this paragraph in its entirety in the documentation or other materials
+ * provided with the distribution
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+/*
+  Emulation for gcc HLE intrinsics on older compilers.
+
+  gcc 4.8+ implements HLE as an additional memory ordering model for the C11+
+  atomic intrinsics.  gcc has its own flavour which are similar to C11,
+  but use a different naming convention.
+
+  We cannot directly emulate the full memory model.
+
+  So the operations are mapped to __hle_acquire_<name> and __hle_release_
+  without an explicit memory model parameter.
+
+  The other problem is that C11 atomics use argument overloading
+  to support different types. While that would be possible to emulate
+  it would generate very ugly macros. We instead add the type size
+  as a postfix.
+
+  So for example:
+
+  int foo;
+  __atomic_or_fetch(&foo, 1, __ATOMIC_ACQUIRE|__ATOMIC_HLE_ACQUIRE)
+
+  become
+
+  __hle_acquire_or_fetch4(&foo, 1);
+
+  Also C11 has some operations that do not map directly to x86 
+  atomic instructions. Since HLE requires that a single instruction,
+  we omit those. That includes nand, xor, and, or.  While they could
+  be mapped to CMPXCHG this would require a spin loop, which is 
+  better not done implicitely. There is also no HLE load.
+
+  x86 supports HLE prefixes for all atomic operations, but not all
+  can currently be generated in this scheme, as many operations
+  have no support for fetch.
+
+  A real compiler could generate them by detecting that the fetch
+  value is not used, but we don't have this luxury. For this we have
+  non _fetch variants. These also support and, or, xor (but not nand),
+  as a extension.
+
+  Intrinsics for sbb, adc, neg, btr, bts, btc are not supported.
+
+  We also don't implement the non _n generic version of some operations.
+
+  Available operations:
+  (8 only valid on 64bit)
+
+  __hle_{acquire,release}_add_fetch{1,2,4,8}
+  __hle_{acquire,release}_sub_fetch{1,2,4,8}
+  __hle_{acquire,release}_fetch_add{1,2,4,8}
+  __hle_{acquire,release}_fetch_sub{1,2,4,8}
+  __hle_{acquire,release}_{add,sub,or,xor,and}{1,2,4,8}	(extension)
+  __hle_{acquire,release}_store_n{1,2,4,8}
+  __hle_{acquire,release}_clear{1,2,4,8}
+  __hle_{acquire,release}_exchange_n{1,2,4,8}
+  __hle_{acquire,release}_compare_exchange_n{1,2,4,8}
+  __hle_{acquire,release}_test_and_set{1,2,4,8}		(sets to 1)
+
+  gcc documentation:
+
+  http://gcc.gnu.org/onlinedocs/gcc-4.8.0/gcc/_005f_005fatomic-Builtins.html#_005f_005fatomic-Builtins
+
+*/
+
+#define __hle_force_inline __attribute__((always_inline)) inline
+
+#define __HLE_ACQUIRE ".byte 0xf2 ; " 
+#define __HLE_RELEASE ".byte 0xf3 ; " 
+
+/* Since there are so many combinations we have to use macros heavily. */
+
+#define __HLE_ADD_FETCH(type, prefix, asm_prefix, size)			\
+	static __hle_force_inline type					\
+	__hle_##prefix##_add_fetch##size(type *ptr, type val)		\
+	{								\
+		type oldval = val;					\
+		asm volatile(asm_prefix " ; lock ; xadd %0,%1"		\
+			     : "+q" (val), "+m" (*ptr) :: "memory");	\
+		return val + oldval;					\
+	} 								\
+	static __hle_force_inline type					\
+	__hle_##prefix##_sub_fetch##size(type *ptr, type val)		\
+	{								\
+		type oldval = val;					\
+		val = -val;						\
+		asm volatile(asm_prefix " ; lock ; xadd %0,%1"		\
+			     : "+q" (val), "+m" (*ptr) :: "memory");	\
+		return val - oldval;					\
+	} 
+
+
+#define __HLE_FETCH_ADD(type, prefix, asm_prefix, size)			\
+	static __hle_force_inline type					\
+	__hle_##prefix##_fetch_add##size(type *ptr, type val)		\
+	{								\
+		asm volatile(asm_prefix " ; lock ; xadd %0,%1"		\
+			     : "+q" (val), "+m" (*ptr) :: "memory");	\
+		return val;						\
+	} 								\
+	static __hle_force_inline type					\
+	__hle_##prefix##_fetch_sub##size(type *ptr, type val)		\
+	{								\
+		val = -val;						\
+		asm volatile(asm_prefix " ; lock ; xadd %0,%1"		\
+			     : "+q" (val), "+m" (*ptr) :: "memory");	\
+		return val;						\
+	} 
+
+#define __HLE_STORE(type, prefix, asm_prefix, size)			\
+	static __hle_force_inline void					\
+	__hle_##prefix##_store_n##size(type *ptr, unsigned val)		\
+	{								\
+		asm volatile(asm_prefix "mov %1,%0" : 			\
+				"=m" (*ptr) : "q" (val)			\
+				: "memory");				\
+	}								\
+	static __hle_force_inline void					\
+	__hle_##prefix##_clear##size(type *ptr)				\
+	{								\
+		__hle_##prefix##_store_n##size(ptr, 0);			\
+	}
+
+#define __HLE_EXCHANGE(type, prefix, asm_prefix, size) 			\
+	static __hle_force_inline type					\
+	__hle_##prefix##_exchange_n##size(type *ptr, type val)		\
+	{								\
+		asm volatile(asm_prefix " ; lock ; xchg %0,%1"		\
+			     : "+q" (val), "+m" (*ptr) :: "memory");	\
+		return val;						\
+	} 								\
+	static __hle_force_inline int					\
+	__hle_##prefix##_test_and_set##size(type *ptr)			\
+	{								\
+		return __hle_##prefix##_exchange_n##size(ptr, 1) == 1;	\
+	}								\
+	static __hle_force_inline int					\
+	__hle_##prefix##_compare_exchange_n##size(type *ptr, type *oldp, \
+			type newv)					\
+	{								\
+		unsigned char res;					\
+		asm volatile(asm_prefix " ; lock ; cmpxchg %3,%1"	\
+			     " ; setz %2"				\
+			     : "+a" (*oldp), "+m" (*ptr), "=r" (res) 	\
+			     : "r" (newv) 				\
+			     : "memory");				\
+		return res;						\
+	} 
+
+#define __HLE_NONFETCH_OP(type, prefix, asm_prefix, size, op)	\
+	static __hle_force_inline void				\
+	__hle_##prefix##_##op##size(type *ptr, type val)		\
+	{								\
+		asm volatile(asm_prefix " ; lock ; " #op " %1,%0"	\
+			     : "+m" (*ptr) : "q" (val) : "memory");	\
+	}
+
+#define __HLE_OP(type, size) \
+__HLE_ADD_FETCH(type, acquire, __HLE_ACQUIRE, size)	\
+__HLE_ADD_FETCH(type, release, __HLE_RELEASE, size)	\
+__HLE_FETCH_ADD(type, acquire, __HLE_ACQUIRE, size)	\
+__HLE_FETCH_ADD(type, release, __HLE_RELEASE, size)	\
+__HLE_EXCHANGE(type, acquire, __HLE_ACQUIRE, size)	\
+__HLE_EXCHANGE(type, release, __HLE_RELEASE, size)	\
+__HLE_STORE(type, acquire, __HLE_ACQUIRE, size)		\
+__HLE_STORE(type, release, __HLE_RELEASE, size)		\
+__HLE_NONFETCH_OP(type, acquire, __HLE_ACQUIRE, size, add)	\
+__HLE_NONFETCH_OP(type, acquire, __HLE_ACQUIRE, size, sub)	\
+__HLE_NONFETCH_OP(type, acquire, __HLE_ACQUIRE, size, or)	\
+__HLE_NONFETCH_OP(type, acquire, __HLE_ACQUIRE, size, and)	\
+__HLE_NONFETCH_OP(type, acquire, __HLE_ACQUIRE, size, xor)	\
+__HLE_NONFETCH_OP(type, release, __HLE_RELEASE, size, add)	\
+__HLE_NONFETCH_OP(type, release, __HLE_RELEASE, size, sub)	\
+__HLE_NONFETCH_OP(type, release, __HLE_RELEASE, size, or)	\
+__HLE_NONFETCH_OP(type, release, __HLE_RELEASE, size, and)	\
+__HLE_NONFETCH_OP(type, release, __HLE_RELEASE, size, xor)
+
+#if __SIZEOF_POINTER__ == 8
+__HLE_OP(unsigned long long, 8)
+#endif
+__HLE_OP(unsigned, 	 4)
+__HLE_OP(unsigned short, 2)
+__HLE_OP(unsigned char,  1)
+
+#endif
-- 
1.8.1.4

