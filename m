Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3GAJiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:38:04 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35100 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3GAJiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:38:01 -0400
Date: Mon, 1 Jul 2013 11:37:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] sched/mm changes for v3.11: Better
 might_sleep()/might_fault() voluntary preemption behavior
Message-ID: <20130701093757.GA16185@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-mm-for-linus

   HEAD: 662bbcb2747c2422cf98d3d97619509379eee466 mm, sched: Allow uaccess in atomic with pagefault_disable()

This tree contains a speedup which is achieved through better 
might_sleep()/might_fault() preemption point annotations for uaccess 
functions, by Michael S. Tsirkin:

1. The only reason uaccess routines might sleep is if they fault. Make 
   this explicit for all architectures.

2. A voluntary preemption point in uaccess functions means compiler can't
   inline them efficiently, this breaks assumptions that they are very
   fast and small that e.g. net code seems to make. Remove this preemption
   point so behaviour matches with what callers assume.

3. Accesses (e.g through socket ops) to kernel memory with KERNEL_DS like 
   net/sunrpc does will never sleep. Remove an unconditinal might_sleep() 
   in the might_fault() inline in kernel.h (used when PROVE_LOCKING is not
   set).

4. Accesses with pagefault_disable() return EFAULT but won't cause caller 
   to sleep. Check for that and thus avoid might_sleep() when 
   PROVE_LOCKING is set.

These changes offer a nice speedup for CONFIG_PREEMPT_VOLUNTARY=y kernels, 
here's a network bandwidth measurement between a virtual machine and the 
host:

 before:
        incoming: 7122.77   Mb/s
        outgoing: 8480.37   Mb/s

 after:
        incoming: 8619.24   Mb/s   [ +21.0% ]
        outgoing: 9455.42   Mb/s   [ +11.5% ]

I kept these changes in a separate tree, separate from scheduler changes, 
because it's a mixed MM and scheduler topic.

 Thanks,

	Ingo

------------------>
Michael S. Tsirkin (11):
      asm-generic: uaccess s/might_sleep/might_fault/
      arm64: uaccess s/might_sleep/might_fault/
      frv: uaccess s/might_sleep/might_fault/
      m32r: uaccess s/might_sleep/might_fault/
      microblaze: uaccess s/might_sleep/might_fault/
      mn10300: uaccess s/might_sleep/might_fault/
      powerpc: uaccess s/might_sleep/might_fault/
      tile: uaccess s/might_sleep/might_fault/
      x86: uaccess s/might_sleep/might_fault/
      mm, sched: Drop voluntary schedule from might_fault()
      mm, sched: Allow uaccess in atomic with pagefault_disable()


 arch/arm64/include/asm/uaccess.h      |  4 ++--
 arch/frv/include/asm/uaccess.h        |  4 ++--
 arch/m32r/include/asm/uaccess.h       | 12 ++++++------
 arch/microblaze/include/asm/uaccess.h |  6 +++---
 arch/mn10300/include/asm/uaccess.h    |  4 ++--
 arch/powerpc/include/asm/uaccess.h    | 16 ++++++++--------
 arch/tile/include/asm/uaccess.h       |  2 +-
 arch/x86/include/asm/uaccess_64.h     |  2 +-
 include/asm-generic/uaccess.h         | 10 +++++-----
 include/linux/kernel.h                |  7 ++-----
 mm/memory.c                           | 10 +++++++---
 11 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 008f848..edb3d5c 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -166,7 +166,7 @@ do {									\
 
 #define get_user(x, ptr)						\
 ({									\
-	might_sleep();							\
+	might_fault();							\
 	access_ok(VERIFY_READ, (ptr), sizeof(*(ptr))) ?			\
 		__get_user((x), (ptr)) :				\
 		((x) = 0, -EFAULT);					\
@@ -227,7 +227,7 @@ do {									\
 
 #define put_user(x, ptr)						\
 ({									\
-	might_sleep();							\
+	might_fault();							\
 	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr))) ?		\
 		__put_user((x), (ptr)) :				\
 		-EFAULT;						\
diff --git a/arch/frv/include/asm/uaccess.h b/arch/frv/include/asm/uaccess.h
index 0b67ec5..3ac9a59 100644
--- a/arch/frv/include/asm/uaccess.h
+++ b/arch/frv/include/asm/uaccess.h
@@ -280,14 +280,14 @@ extern long __memcpy_user(void *dst, const void *src, unsigned long count);
 static inline unsigned long __must_check
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-       might_sleep();
+       might_fault();
        return __copy_to_user_inatomic(to, from, n);
 }
 
 static inline unsigned long
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-       might_sleep();
+       might_fault();
        return __copy_from_user_inatomic(to, from, n);
 }
 
diff --git a/arch/m32r/include/asm/uaccess.h b/arch/m32r/include/asm/uaccess.h
index 1c7047b..84fe7ba 100644
--- a/arch/m32r/include/asm/uaccess.h
+++ b/arch/m32r/include/asm/uaccess.h
@@ -216,7 +216,7 @@ extern int fixup_exception(struct pt_regs *regs);
 ({									\
 	long __gu_err = 0;						\
 	unsigned long __gu_val;						\
-	might_sleep();							\
+	might_fault();							\
 	__get_user_size(__gu_val,(ptr),(size),__gu_err);		\
 	(x) = (__typeof__(*(ptr)))__gu_val;				\
 	__gu_err;							\
@@ -227,7 +227,7 @@ extern int fixup_exception(struct pt_regs *regs);
 	long __gu_err = -EFAULT;					\
 	unsigned long __gu_val = 0;					\
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
-	might_sleep();							\
+	might_fault();							\
 	if (access_ok(VERIFY_READ,__gu_addr,size))			\
 		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
 	(x) = (__typeof__(*(ptr)))__gu_val;				\
@@ -295,7 +295,7 @@ do {									\
 #define __put_user_nocheck(x,ptr,size)					\
 ({									\
 	long __pu_err;							\
-	might_sleep();							\
+	might_fault();							\
 	__put_user_size((x),(ptr),(size),__pu_err);			\
 	__pu_err;							\
 })
@@ -305,7 +305,7 @@ do {									\
 ({									\
 	long __pu_err = -EFAULT;					\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
-	might_sleep();							\
+	might_fault();							\
 	if (access_ok(VERIFY_WRITE,__pu_addr,size))			\
 		__put_user_size((x),__pu_addr,(size),__pu_err);		\
 	__pu_err;							\
@@ -597,7 +597,7 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  */
 #define copy_to_user(to,from,n)				\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__generic_copy_to_user((to),(from),(n));	\
 })
 
@@ -638,7 +638,7 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  */
 #define copy_from_user(to,from,n)			\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__generic_copy_from_user((to),(from),(n));	\
 })
 
diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index efe59d8..2fc8bf7 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -145,7 +145,7 @@ static inline unsigned long __must_check __clear_user(void __user *to,
 static inline unsigned long __must_check clear_user(void __user *to,
 							unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (unlikely(!access_ok(VERIFY_WRITE, to, n)))
 		return n;
 
@@ -371,7 +371,7 @@ extern long __user_bad(void);
 static inline long copy_from_user(void *to,
 		const void __user *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (access_ok(VERIFY_READ, from, n))
 		return __copy_from_user(to, from, n);
 	return n;
@@ -385,7 +385,7 @@ static inline long copy_from_user(void *to,
 static inline long copy_to_user(void __user *to,
 		const void *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (access_ok(VERIFY_WRITE, to, n))
 		return __copy_to_user(to, from, n);
 	return n;
diff --git a/arch/mn10300/include/asm/uaccess.h b/arch/mn10300/include/asm/uaccess.h
index 780560b..107508a 100644
--- a/arch/mn10300/include/asm/uaccess.h
+++ b/arch/mn10300/include/asm/uaccess.h
@@ -471,13 +471,13 @@ extern unsigned long __generic_copy_from_user(void *, const void __user *,
 
 #define __copy_to_user(to, from, n)			\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__copy_to_user_inatomic((to), (from), (n));	\
 })
 
 #define __copy_from_user(to, from, n)			\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__copy_from_user_inatomic((to), (from), (n));	\
 })
 
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 4db4959..9485b43 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -178,7 +178,7 @@ do {								\
 	long __pu_err;						\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
 	if (!is_kernel_addr((unsigned long)__pu_addr))		\
-		might_sleep();					\
+		might_fault();					\
 	__chk_user_ptr(ptr);					\
 	__put_user_size((x), __pu_addr, (size), __pu_err);	\
 	__pu_err;						\
@@ -188,7 +188,7 @@ do {								\
 ({									\
 	long __pu_err = -EFAULT;					\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
-	might_sleep();							\
+	might_fault();							\
 	if (access_ok(VERIFY_WRITE, __pu_addr, size))			\
 		__put_user_size((x), __pu_addr, (size), __pu_err);	\
 	__pu_err;							\
@@ -268,7 +268,7 @@ do {								\
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
 	__chk_user_ptr(ptr);					\
 	if (!is_kernel_addr((unsigned long)__gu_addr))		\
-		might_sleep();					\
+		might_fault();					\
 	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
@@ -282,7 +282,7 @@ do {								\
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
 	__chk_user_ptr(ptr);					\
 	if (!is_kernel_addr((unsigned long)__gu_addr))		\
-		might_sleep();					\
+		might_fault();					\
 	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
@@ -294,7 +294,7 @@ do {								\
 	long __gu_err = -EFAULT;					\
 	unsigned long  __gu_val = 0;					\
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
-	might_sleep();							\
+	might_fault();							\
 	if (access_ok(VERIFY_READ, __gu_addr, (size)))			\
 		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__typeof__(*(ptr)))__gu_val;				\
@@ -419,14 +419,14 @@ static inline unsigned long __copy_to_user_inatomic(void __user *to,
 static inline unsigned long __copy_from_user(void *to,
 		const void __user *from, unsigned long size)
 {
-	might_sleep();
+	might_fault();
 	return __copy_from_user_inatomic(to, from, size);
 }
 
 static inline unsigned long __copy_to_user(void __user *to,
 		const void *from, unsigned long size)
 {
-	might_sleep();
+	might_fault();
 	return __copy_to_user_inatomic(to, from, size);
 }
 
@@ -434,7 +434,7 @@ extern unsigned long __clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
 {
-	might_sleep();
+	might_fault();
 	if (likely(access_ok(VERIFY_WRITE, addr, size)))
 		return __clear_user(addr, size);
 	if ((unsigned long)addr < TASK_SIZE) {
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index 8a082bc..e4d44bd 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -442,7 +442,7 @@ extern unsigned long __copy_in_user_inatomic(
 static inline unsigned long __must_check
 __copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	return __copy_in_user_inatomic(to, from, n);
 }
 
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 142810c..4f7923d 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -235,7 +235,7 @@ extern long __copy_user_nocache(void *dst, const void __user *src,
 static inline int
 __copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
 {
-	might_sleep();
+	might_fault();
 	return __copy_user_nocache(dst, src, size, 1);
 }
 
diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index c184aa8..dc1269c 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -163,7 +163,7 @@ static inline __must_check long __copy_to_user(void __user *to,
 
 #define put_user(x, ptr)					\
 ({								\
-	might_sleep();						\
+	might_fault();						\
 	access_ok(VERIFY_WRITE, ptr, sizeof(*ptr)) ?		\
 		__put_user(x, ptr) :				\
 		-EFAULT;					\
@@ -225,7 +225,7 @@ extern int __put_user_bad(void) __attribute__((noreturn));
 
 #define get_user(x, ptr)					\
 ({								\
-	might_sleep();						\
+	might_fault();						\
 	access_ok(VERIFY_READ, ptr, sizeof(*ptr)) ?		\
 		__get_user(x, ptr) :				\
 		-EFAULT;					\
@@ -255,7 +255,7 @@ extern int __get_user_bad(void) __attribute__((noreturn));
 static inline long copy_from_user(void *to,
 		const void __user * from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (access_ok(VERIFY_READ, from, n))
 		return __copy_from_user(to, from, n);
 	else
@@ -265,7 +265,7 @@ static inline long copy_from_user(void *to,
 static inline long copy_to_user(void __user *to,
 		const void *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (access_ok(VERIFY_WRITE, to, n))
 		return __copy_to_user(to, from, n);
 	else
@@ -336,7 +336,7 @@ __clear_user(void __user *to, unsigned long n)
 static inline __must_check unsigned long
 clear_user(void __user *to, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (!access_ok(VERIFY_WRITE, to, n))
 		return n;
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e9ef6d6..4c7e2e5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -193,13 +193,10 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-#ifdef CONFIG_PROVE_LOCKING
+#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
 void might_fault(void);
 #else
-static inline void might_fault(void)
-{
-	might_sleep();
-}
+static inline void might_fault(void) { }
 #endif
 
 extern struct atomic_notifier_head panic_notifier_list;
diff --git a/mm/memory.c b/mm/memory.c
index 6dc1882..d7d54a1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4210,7 +4210,7 @@ void print_vma_addr(char *prefix, unsigned long ip)
 	up_read(&mm->mmap_sem);
 }
 
-#ifdef CONFIG_PROVE_LOCKING
+#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
 void might_fault(void)
 {
 	/*
@@ -4222,13 +4222,17 @@ void might_fault(void)
 	if (segment_eq(get_fs(), KERNEL_DS))
 		return;
 
-	might_sleep();
 	/*
 	 * it would be nicer only to annotate paths which are not under
 	 * pagefault_disable, however that requires a larger audit and
 	 * providing helpers like get_user_atomic.
 	 */
-	if (!in_atomic() && current->mm)
+	if (in_atomic())
+		return;
+
+	__might_sleep(__FILE__, __LINE__, 0);
+
+	if (current->mm)
 		might_lock_read(&current->mm->mmap_sem);
 }
 EXPORT_SYMBOL(might_fault);
