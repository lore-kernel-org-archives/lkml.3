Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbaCEWlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:41:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47632 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaCEWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:41:37 -0500
From: Christopher Covington <cov@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] arm64: Fix __addr_ok and __range_ok macros
Date: Wed,  5 Mar 2014 17:41:28 -0500
Message-Id: <1394059289-3972-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this, the following scenario is incorrectly determined
to be invalid.

addr 0x7f_ffffe000 size 8192 addr_limit 0x80_00000000

This behavior was observed while trying to vmsplice the stack
as part of a CRIU dump of a process.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm64/include/asm/uaccess.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index edb3d5c..9309024 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -66,12 +66,12 @@ static inline void set_fs(mm_segment_t fs)
 #define segment_eq(a,b)	((a) == (b))
 
 /*
- * Return 1 if addr < current->addr_limit, 0 otherwise.
+ * Return 1 if addr <= current->addr_limit, 0 otherwise.
  */
 #define __addr_ok(addr)							\
 ({									\
 	unsigned long flag;						\
-	asm("cmp %1, %0; cset %0, lo"					\
+	asm("cmp %1, %0; cset %0, ls"					\
 		: "=&r" (flag)						\
 		: "r" (addr), "0" (current_thread_info()->addr_limit)	\
 		: "cc");						\
@@ -83,7 +83,7 @@ static inline void set_fs(mm_segment_t fs)
  * Returns 1 if the range is valid, 0 otherwise.
  *
  * This is equivalent to the following test:
- * (u65)addr + (u65)size < (u65)current->addr_limit
+ * (u65)addr + (u65)size <= current->addr_limit
  *
  * This needs 65-bit arithmetic.
  */
@@ -91,7 +91,7 @@ static inline void set_fs(mm_segment_t fs)
 ({									\
 	unsigned long flag, roksum;					\
 	__chk_user_ptr(addr);						\
-	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, cc"		\
+	asm("adds %1, %1, %3; ccmp %1, %4, #3, cc; cset %0, ls"		\
 		: "=&r" (flag), "=&r" (roksum)				\
 		: "1" (addr), "Ir" (size),				\
 		  "r" (current_thread_info()->addr_limit)		\
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

