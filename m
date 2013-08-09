Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031542Ab3HIXGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:06:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:29511 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031441Ab3HIXEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="378778938"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 13/13] x86: drop cond rescheds from __copy_{from,to}_user
Date: Fri,  9 Aug 2013 16:04:20 -0700
Message-Id: <1376089460-5459-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The __copy_* variants are right now more expensive than the non __ copy*user
in CONFIG_PREEMPT_VOLUNTARY because they have a additional function call to
might_fault().

Since they are usually used in a row with other functions, which also
schedule or only in the thin compat layers and also __get/__put_user
do not do explicit reschedule check drop them here for the non debug
case.

Normal non __ copy*user will still schedule of course

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/uaccess_32.h | 6 +++---
 arch/x86/include/asm/uaccess_64.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

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
index 831f4a3..86959f5 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
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
 
-- 
1.8.3.1

