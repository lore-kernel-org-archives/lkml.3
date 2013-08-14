Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab3HNAHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:07:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:21639 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758962Ab3HNAH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:07:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,873,1367996400"; 
   d="scan'208";a="345964577"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/8] x86: Add 1/2/4/8 byte optimization to 64bit __copy_{from,to}_user_inatomic
Date: Tue, 13 Aug 2013 17:07:09 -0700
Message-Id: <1376438836-13339-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
References: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
-- 
1.8.3.1

