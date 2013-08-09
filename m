Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031604Ab3HIXGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:06:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:20522 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031506Ab3HIXEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="360454437"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/13] x86: Move cond resched for copy_{from,to}_user into low level code 64bit
Date: Fri,  9 Aug 2013 16:04:17 -0700
Message-Id: <1376089460-5459-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Move the cond_resched() check for CONFIG_PREEMPT_VOLUNTARY into
the low level copy_*_user code. This avoids some code bloat and
makes check much more efficient by avoiding unnecessary function calls.

This is currently only for the non __ variants.

For the sleep debug case the call is still done in the caller.

I did not do this for copy_in_user() or the nocache variants because there's
no obvious place to put the check, and those calls are comparatively rare.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/uaccess_64.h | 4 ++--
 arch/x86/lib/copy_user_64.S       | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 64476bb..b327057 100644
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
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index a30ca15..7039fc9 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -18,6 +18,7 @@
 #include <asm/alternative-asm.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
+#include "user-common.h"
 
 /*
  * By placing feature2 after feature1 in altinstructions section, we logically
@@ -73,7 +74,7 @@
 /* Standard copy_to_user with segment limit checking */
 ENTRY(_copy_to_user)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%rax)
+	GET_THREAD_AND_SCHEDULE %rax
 	movq %rdi,%rcx
 	addq %rdx,%rcx
 	jc bad_to_user
@@ -88,7 +89,7 @@ ENDPROC(_copy_to_user)
 /* Standard copy_from_user with segment limit checking */
 ENTRY(_copy_from_user)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%rax)
+	GET_THREAD_AND_SCHEDULE %rax
 	movq %rsi,%rcx
 	addq %rdx,%rcx
 	jc bad_from_user
-- 
1.8.3.1

