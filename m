Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031601Ab3HIXHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:07:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:20518 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031456Ab3HIXEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="360454436"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/13] x86: Move cond_resched into the out of line get_user code
Date: Fri,  9 Aug 2013 16:04:16 -0700
Message-Id: <1376089460-5459-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

CONFIG_PREEMPT_VOLUNTARY kernels always do a cond_resched in get_user().
Currently this is done in the caller and in a inefficient way (multiple
function calls to decide to do nothing). Move the reschedule check
into the low level functions instead, where it can be merged cheaply
with the address limit check.

For the DEBUG_SLEEP case we still do the call in the caller.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h | 3 +--
 arch/x86/lib/getuser.S         | 9 +++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 6cbe976..1ab2d2a 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -165,7 +165,7 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 	int __ret_gu;							\
 	register __inttype(*(ptr)) __val_gu asm("%edx");		\
 	__chk_user_ptr(ptr);						\
-	might_fault();							\
+	might_fault_debug_only();					\
 	asm volatile("call __get_user_%P3"				\
 		     : "=a" (__ret_gu), "=r" (__val_gu)			\
 		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
@@ -541,4 +541,3 @@ extern struct movsl_mask {
 #endif
 
 #endif /* _ASM_X86_UACCESS_H */
-
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index a451235..0288aa9 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -33,11 +33,12 @@
 #include <asm/thread_info.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
+#include "user-common.h"
 
 	.text
 ENTRY(__get_user_1)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%_ASM_DX)
+	GET_THREAD_AND_SCHEDULE %_ASM_DX
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
 	ASM_STAC
@@ -52,7 +53,7 @@ ENTRY(__get_user_2)
 	CFI_STARTPROC
 	add $1,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
+	GET_THREAD_AND_SCHEDULE %_ASM_DX
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
 	ASM_STAC
@@ -67,7 +68,7 @@ ENTRY(__get_user_4)
 	CFI_STARTPROC
 	add $3,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
+	GET_THREAD_AND_SCHEDULE %_ASM_DX
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
 	ASM_STAC
@@ -83,7 +84,7 @@ ENTRY(__get_user_8)
 #ifdef CONFIG_X86_64
 	add $7,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
+	GET_THREAD_AND_SCHEDULE %_ASM_DX
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
 	ASM_STAC
-- 
1.8.3.1

