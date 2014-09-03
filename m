Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbaICVX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:23:59 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:58404 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbaICVXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:23:11 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 22/24] ARM64:ILP32: Fix signal return for ILP32 when the user modified the signal stack
Date: Wed,  3 Sep 2014 14:19:16 -0700
Message-Id: <1409779158-30963-23-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user decided to change the stack_t that was on the stack when returning
from the signal handler, the stack_t's padding for ILP32 might be not zero.
So we need to use the syscall version of restore_altstack (ilp32_sys_sigaltstack).

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/kernel/signal.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 5311147..6316d54 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -35,6 +35,7 @@
 #include <asm/fpsimd.h>
 #include <asm/signal32.h>
 #include <asm/vdso.h>
+#include <asm/syscalls.h>
 
 /*
  * Do a signal return; undo the signal stack. These are aligned to 128-bit.
@@ -149,6 +150,19 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	if (restore_sigframe(regs, frame))
 		goto badframe;
 
+#ifdef CONFIG_ARM64_ILP32
+	/*
+	 * ILP32 has to be handled "special" due to maybe not zeroing out
+	 * the upper 32bits of the pointer if the user changed the frame.
+	 */
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

