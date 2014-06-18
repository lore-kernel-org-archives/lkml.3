Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbaFRUPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:15:30 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:46354 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaFRUP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:15:29 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin Cross <ccross@android.com>, stable@vger.kernel.org
Subject: [PATCH] ARM64: implement TASK_SIZE_OF
Date: Wed, 18 Jun 2014 13:10:09 -0700
Message-Id: <1403122209-26352-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/sched.h implements TASK_SIZE_OF as TASK_SIZE if it
is not set by the architecture headers.  TASK_SIZE uses the
current task to determine the size of the virtual address space.
On a 64-bit kernel this will cause reading /proc/pid/pagemap of a
64-bit process from a 32-bit process to return EOF when it reads
past 0xffffffff.

Implement TASK_SIZE_OF exactly the same as TASK_SIZE with
test_tsk_thread_flag instead of test_thread_flag.

Cc: stable@vger.kernel.org
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm64/include/asm/memory.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 993bce527b85..902eb708804a 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -56,6 +56,8 @@
 #define TASK_SIZE_32		UL(0x100000000)
 #define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
 				TASK_SIZE_32 : TASK_SIZE_64)
+#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
+				TASK_SIZE_32 : TASK_SIZE_64)
 #else
 #define TASK_SIZE		TASK_SIZE_64
 #endif /* CONFIG_COMPAT */
-- 
2.0.0.526.g5318336

