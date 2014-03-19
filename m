Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbaCSQa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:30:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55938 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaCSQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:30:28 -0400
From: Christopher Covington <cov@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Alexander Kartashov <alekskartashov@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v2] arm64: Fix __range_ok macro
Date: Wed, 19 Mar 2014 12:29:37 -0400
Message-Id: <1395246577-22120-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1394059289-3972-1-git-send-email-cov@codeaurora.org>
References: <1394059289-3972-1-git-send-email-cov@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this, the following scenario is incorrectly determined
to be invalid.

addr 0x7f_ffffe000 size 8192 addr_limit 0x80_00000000

This behavior was observed while trying to vmsplice the stack
as part of a CRIU dump of a process on a system started with the
norandmaps kernel parameter.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm64/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 7ecc2b2..5974459 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
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
+	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, ls"		\
 		: "=&r" (flag), "=&r" (roksum)				\
 		: "1" (addr), "Ir" (size),				\
 		  "r" (current_thread_info()->addr_limit)		\
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

