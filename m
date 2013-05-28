Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab3E1NWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:22:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3E1NWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:22:52 -0400
Date: Tue, 28 May 2013 06:22:02 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-1af1717dbf96eba8a74a2d6a99e75a7795075a02@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, mst@redhat.com,
        peterz@infradead.org, benh@kernel.crashing.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, benh@kernel.crashing.org,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1369577426-26721-7-git-send-email-mst@redhat.com>
References: <1369577426-26721-7-git-send-email-mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/mm] powerpc: uaccess s/might_sleep/might_fault/
Git-Commit-ID: 1af1717dbf96eba8a74a2d6a99e75a7795075a02
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

Commit-ID:  1af1717dbf96eba8a74a2d6a99e75a7795075a02
Gitweb:     http://git.kernel.org/tip/1af1717dbf96eba8a74a2d6a99e75a7795075a02
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 26 May 2013 17:31:38 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:41:09 +0200

powerpc: uaccess s/might_sleep/might_fault/

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Arnd Bergmann suggested that the following code
	if (!is_kernel_addr((unsigned long)__pu_addr))
		might_fault();
can be further simplified by adding a version of might_fault
that includes the kernel addr check.

Will be considered as a further optimization in future.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1369577426-26721-7-git-send-email-mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/include/asm/uaccess.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

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
