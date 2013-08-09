Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031586Ab3HIXGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:06:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:10655 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031496Ab3HIXEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="378778934"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/13] x86: Move cond_resched into the out of line put_user code
Date: Fri,  9 Aug 2013 16:04:15 -0700
Message-Id: <1376089460-5459-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

CONFIG_PREEMPT_VOLUNTARY kernels always do a cond_resched in put_user().
Currently this is done in the caller and in a inefficient way (multiple
function calls to decide to do nothing). Move the reschedule check
into the low level functions instead, where it can be merged cheaply
with the address limit check.

For the DEBUG_SLEEP case we still do the call in the caller.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h |  2 +-
 arch/x86/lib/putuser.S         | 12 +++++++++++-
 arch/x86/lib/user-common.h     | 12 ++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/lib/user-common.h

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 8fa3bd6..6cbe976 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -246,7 +246,7 @@ extern void __put_user_8(void);
 	int __ret_pu;						\
 	__typeof__(*(ptr)) __pu_val;				\
 	__chk_user_ptr(ptr);					\
-	might_fault();						\
+	might_fault_debug_only();				\
 	__pu_val = x;						\
 	switch (sizeof(*(ptr))) {				\
 	case 1:							\
diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index fc6ba17..9ba7f52 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -16,6 +16,8 @@
 #include <asm/errno.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
+#include <asm/calling.h>
+#include "user-common.h"
 
 
 /*
@@ -31,7 +33,7 @@
  */
 
 #define ENTER	CFI_STARTPROC ; \
-		GET_THREAD_INFO(%_ASM_BX)
+		GET_THREAD_AND_SCHEDULE %_ASM_BX
 #define EXIT	ASM_CLAC ;	\
 		ret ;		\
 		CFI_ENDPROC
@@ -99,3 +101,11 @@ END(bad_put_user)
 #ifdef CONFIG_X86_32
 	_ASM_EXTABLE(5b,bad_put_user)
 #endif
+
+ENTRY(user_schedule)
+	CFI_STARTPROC
+	SAVE_ALL
+	call _cond_resched
+	RESTORE_ALL
+	ret
+	CFI_ENDPROC
diff --git a/arch/x86/lib/user-common.h b/arch/x86/lib/user-common.h
new file mode 100644
index 0000000..d61cd1a
--- /dev/null
+++ b/arch/x86/lib/user-common.h
@@ -0,0 +1,12 @@
+	.macro GET_THREAD_AND_SCHEDULE reg
+	GET_THREAD_INFO(\reg)
+#ifdef CONFIG_PREEMPT_VOLUNTARY
+	testl $_TIF_NEED_RESCHED,TI_flags(\reg)
+	jnz   1f
+2:
+	.section .fixup,"ax"
+1:	call user_schedule
+	jmp  2b
+	.previous
+#endif
+	.endm
-- 
1.8.3.1

