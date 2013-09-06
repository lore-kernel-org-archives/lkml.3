Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3IFVn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:43:29 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60208 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3IFVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:43:25 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk
Cc: behanw@converseincode.com, Mark Charlebois <charlebm@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Jones <davej@redhat.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] arm: LLVMLinux: Calculate pt_regs address from fp
Date: Fri,  6 Sep 2013 17:42:41 -0400
Message-Id: <1378503762-7236-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378503762-7236-1-git-send-email-behanw@converseincode.com>
References: <1378503762-7236-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Use the frame pointer to calculate the end of the stack for current_pt_regs()
The existing code uses the stack pointer to do this calculation.
Using the frame pointer yeilds the same value in a more portable way.
This change supports being able to compile the kernel with gcc and clang.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 arch/arm/include/asm/ptrace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 04c99f3..8aec2db 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -138,9 +138,9 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 	return regs->ARM_sp;
 }
 
-#define current_pt_regs(void) ({				\
-	register unsigned long sp asm ("sp");			\
-	(struct pt_regs *)((sp | (THREAD_SIZE - 1)) - 7) - 1;	\
+#define current_pt_regs(void) ({					\
+	(struct pt_regs *)(((unsigned long)(__builtin_frame_address(0))	\
+		| (THREAD_SIZE - 1)) - 7) - 1;				\
 })
 
 #endif /* __ASSEMBLY__ */
-- 
1.8.1.2

