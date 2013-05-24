Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab3EXOTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab3EXOSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:18:12 -0400
Date: Fri, 24 May 2013 17:18:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 07/11] powerpc: uaccess s/might_sleep/might_fault/
Message-ID: <1369404522-12927-7-git-send-email-mst@redhat.com>
References: <cover.1368702323.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1368702323.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Arnd Bergmann suggested that the following code
	if (!is_kernel_addr((unsigned long)__pu_addr))
		might_fault();
can be further simplified by adding a version of might_fault
that includes the kernel addr check.

Will be considered as a further optimization in future.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
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
-- 
MST
