Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaEXHKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:10:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35443 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaEXHJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:09:27 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 23/24] ARM64:ILP32: Fix signal return for ILP32 when the user modified the signal stack.
Date: Sat, 24 May 2014 00:02:18 -0700
Message-Id: <1400914939-9708-24-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user decided to change the stack_t that was on the stack when returning from the signal handler, the stack_t's padding for ILP32 might be not zero.  So we need to use the syscall version of restore_altstack (ilp32_sys_sigaltstack).

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/kernel/signal.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index fd49b58..d5682b6 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -34,6 +34,7 @@
 #include <asm/fpsimd.h>
 #include <asm/signal32.h>
 #include <asm/vdso.h>
+#include <asm/syscalls.h>
 
 /*
  * Do a signal return; undo the signal stack. These are aligned to 128-bit.
@@ -149,6 +150,17 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	if (restore_sigframe(regs, frame))
 		goto badframe;
 
+#ifdef CONFIG_ARM64_ILP32
+	/* ILP32 has to be handled "special" due to maybe not zeroing out
+	   the upper 32bits of the pointer if the user changed the frame. */
+	if (is_ilp32_compat_task()) {
+		if (ilp32_sys_sigaltstack(&frame->uc.uc_stack,
+					  NULL) == -EFAULT)
+			goto badframe;
+		return regs->regs[0];
+	}
+#endif
+
 	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
-- 
1.7.2.5

