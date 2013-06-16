Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3FPEqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:46:16 -0400
Received: from ozlabs.org ([203.10.76.45]:34593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab3FPEqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:46:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3/9] s390: Replace weird use of PTR_RET.
Date: Sun, 16 Jun 2013 14:12:42 +0930
Message-Id: <1371357768-4968-3-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au>
 <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saves repeating "(void __force *)__uptr" but it's less clear.  Using
the output of PTR_RET() to determine the error rather than just
testing IS_ERR() is odd.

For example, I *assume* __gptr_to_uptr() never returns NULL?  Because
the __ret would be 0 for the old code.  The new version is clearer, IMHO:
it would try to get_user() on that address.

If you hate this variant, I can just s/PTR_RET/PTR_ERR_OR_ZERO/ instead.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/s390/kvm/gaccess.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 302e0e5..99d789e 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -42,9 +42,11 @@ static inline void __user *__gptr_to_uptr(struct kvm_vcpu *vcpu,
 ({								\
 	__typeof__(gptr) __uptr = __gptr_to_uptr(vcpu, gptr, 1);\
 	int __mask = sizeof(__typeof__(*(gptr))) - 1;		\
-	int __ret = PTR_RET((void __force *)__uptr);		\
+	int __ret;						\
 								\
-	if (!__ret) {						\
+	if (IS_ERR((void __force *)__uptr)) {			\
+		__ret = PTR_ERR((void __force *)__uptr);	\
+	} else {						\
 		BUG_ON((unsigned long)__uptr & __mask);		\
 		__ret = get_user(x, __uptr);			\
 	}							\
@@ -55,9 +57,11 @@ static inline void __user *__gptr_to_uptr(struct kvm_vcpu *vcpu,
 ({								\
 	__typeof__(gptr) __uptr = __gptr_to_uptr(vcpu, gptr, 1);\
 	int __mask = sizeof(__typeof__(*(gptr))) - 1;		\
-	int __ret = PTR_RET((void __force *)__uptr);		\
+	int __ret;						\
 								\
-	if (!__ret) {						\
+	if (IS_ERR((void __force *)__uptr)) {			\
+		__ret = PTR_ERR((void __force *)__uptr);	\
+	} else {						\
 		BUG_ON((unsigned long)__uptr & __mask);		\
 		__ret = put_user(x, __uptr);			\
 	}							\
-- 
1.8.1.2

