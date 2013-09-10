Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3IJXa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:30:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45678 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3IJXa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:30:57 -0400
Date: Tue, 10 Sep 2013 16:30:41 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-ff47ab4ff3cddfa7bc1b25b990e24abe2ae474ff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1376687844-19857-2-git-send-email-andi@firstfloor.org>
References: <1376687844-19857-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uaccess] x86: Add 1/2/4/
 8 byte optimization to 64bit __copy_{from,to}_user_inatomic
Git-Commit-ID: ff47ab4ff3cddfa7bc1b25b990e24abe2ae474ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 10 Sep 2013 16:30:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff47ab4ff3cddfa7bc1b25b990e24abe2ae474ff
Gitweb:     http://git.kernel.org/tip/ff47ab4ff3cddfa7bc1b25b990e24abe2ae474ff
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 16 Aug 2013 14:17:19 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 10 Sep 2013 15:27:43 -0700

x86: Add 1/2/4/8 byte optimization to 64bit __copy_{from,to}_user_inatomic

The 64bit __copy_{from,to}_user_inatomic always called
copy_from_user_generic, but skipped the special optimizations for 1/2/4/8
byte accesses.

This especially hurts the futex call, which accesses the 4 byte futex
user value with a complicated fast string operation in a function call,
instead of a single movl.

Use __copy_{from,to}_user for _inatomic instead to get the same
optimizations. The only problem was the might_fault() in those functions.
So move that to new wrapper and call __copy_{f,t}_user_nocheck()
from *_inatomic directly.

32bit already did this correctly by duplicating the code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1376687844-19857-2-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/uaccess_64.h | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 4f7923d..64476bb 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -77,11 +77,10 @@ int copy_to_user(void __user *dst, const void *src, unsigned size)
 }
 
 static __always_inline __must_check
-int __copy_from_user(void *dst, const void __user *src, unsigned size)
+int __copy_from_user_nocheck(void *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
 
-	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
@@ -121,11 +120,17 @@ int __copy_from_user(void *dst, const void __user *src, unsigned size)
 }
 
 static __always_inline __must_check
-int __copy_to_user(void __user *dst, const void *src, unsigned size)
+int __copy_from_user(void *dst, const void __user *src, unsigned size)
+{
+	might_fault();
+	return __copy_from_user_nocheck(dst, src, size);
+}
+
+static __always_inline __must_check
+int __copy_to_user_nocheck(void __user *dst, const void *src, unsigned size)
 {
 	int ret = 0;
 
-	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst, src, size);
 	switch (size) {
@@ -165,6 +170,13 @@ int __copy_to_user(void __user *dst, const void *src, unsigned size)
 }
 
 static __always_inline __must_check
+int __copy_to_user(void __user *dst, const void *src, unsigned size)
+{
+	might_fault();
+	return __copy_to_user_nocheck(dst, src, size);
+}
+
+static __always_inline __must_check
 int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
@@ -220,13 +232,13 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
-	return copy_user_generic(dst, (__force const void *)src, size);
+	return __copy_from_user_nocheck(dst, (__force const void *)src, size);
 }
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 {
-	return copy_user_generic((__force void *)dst, src, size);
+	return __copy_to_user_nocheck((__force void *)dst, src, size);
 }
 
 extern long __copy_user_nocache(void *dst, const void __user *src,
