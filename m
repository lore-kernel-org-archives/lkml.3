Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaFRN4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:56:10 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25781 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaFRN4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:56:08 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-6e-53a19a75012d
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] arm: get rid of hardcoded assumptions about kernel stack size
Date: Wed, 18 Jun 2014 17:50:22 +0400
Message-id: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xa7qlsxYGGyyZb2ix7dcjNov3y3oY
	LTY9vsZqcXnXHDaL25d5LaYf+8tm8fLjCRYHdo8189YwerQ097B53Lm2h81j85J6j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mo4cDKo4BZfxb6fc1kaGGfxdDFyckgImEhsOf6UCcIWk7hw
	bz1bFyMXh5DAUkaJxT8XQDl9TBKv9vSBVbEJ6En8m7WdDcQWEdCUOLX4IjNIEbPAU0aJr4sv
	MYIkhAX8JLZuOgBWxCKgKjGhZTsLiM0r4CLx6dtjqHUKEsuWz2SdwMi9gJFhFaNoamlyQXFS
	eq6hXnFibnFpXrpecn7uJkZIsHzZwbj4mNUhRgEORiUe3g9vFwQLsSaWFVfmHmKU4GBWEuE9
	VrwwWIg3JbGyKrUoP76oNCe1+BAjEwenVANj4NTyhHk2TY+Mdlzctv+J7MxqBq+w16x7JTqj
	A3mS8ljmng3hmveXI/7R753fOZ4aPXcQXXDY+k2swuOv0wU1Tdvfz9bxu5mxVuDAsqb/FpYV
	ue+KJ0RuUAlo2hGq47+w+MQr649GHI1PZ2wQfeJop9rp6hOdky7WP7l3cfW9sh+OrO+75jIr
	sRRnJBpqMRcVJwIACqyWrvQBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing kernel stack size on arm is not as simple as it should be:
1) THRED_SIZE macro doen't respect PAGE_SIZE and THREAD_SIZE_ORDER
2) stack size is hardcoded in get_thread_info macro

This patch fixes it by caculating THREAD_SIZE and thread_info address
taking into account PAGE_SIZE and THREAD_SIZE_ORDER.

Now changing stack size becomes simply changing THREAD_SIZE_ORDER.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/include/asm/assembler.h   | 8 +++++---
 arch/arm/include/asm/thread_info.h | 3 ++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 57f0584..906703a 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -24,6 +24,8 @@
 #include <asm/domain.h>
 #include <asm/opcodes-virt.h>
 #include <asm/asm-offsets.h>
+#include <asm/page.h>
+#include <asm/thread_info.h>
 
 #define IOMEM(x)	(x)
 
@@ -179,10 +181,10 @@
  * Get current thread_info.
  */
 	.macro	get_thread_info, rd
- ARM(	mov	\rd, sp, lsr #13	)
+ ARM(	mov	\rd, sp, lsr #THREAD_SIZE_ORDER + PAGE_SHIFT	)
  THUMB(	mov	\rd, sp			)
- THUMB(	lsr	\rd, \rd, #13		)
-	mov	\rd, \rd, lsl #13
+ THUMB(	lsr	\rd, \rd, #THREAD_SIZE_ORDER + PAGE_SHIFT	)
+	mov	\rd, \rd, lsl #THREAD_SIZE_ORDER + PAGE_SHIFT
 	.endm
 
 /*
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index f989d7c..f85d2b0 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -14,9 +14,10 @@
 
 #include <linux/compiler.h>
 #include <asm/fpstate.h>
+#include <asm/page.h>
 
 #define THREAD_SIZE_ORDER	1
-#define THREAD_SIZE		8192
+#define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 #define THREAD_START_SP		(THREAD_SIZE - 8)
 
 #ifndef __ASSEMBLY__
-- 
1.8.5.5

