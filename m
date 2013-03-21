Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3CUAJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:09:08 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:61648 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab3CUAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:09:03 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 3/4] ARM: context tracking: handle post exception/syscall/IRQ work
Date: Wed, 20 Mar 2013 17:02:00 -0700
Message-Id: <1363824121-26169-4-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1363824121-26169-1-git-send-email-khilman@linaro.org>
References: <1363824121-26169-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_work_pending() may be called on IRQ, exception or syscall exit (for
reschedule, signal handling, etc.) , but user_enter() may have already
been called (e.g. by syscall return path.)

Since do_work_pending() is still in kernel mode, keep context_tracker
up to date by using user_exit/user_enter.

Based on commit edf55fda35c7dc7f2d9241c3abaddaf759b457c6 (x86: Exit
RCU extended QS on notify resume)

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm/kernel/signal.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 296786b..42514fd 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -12,6 +12,7 @@
 #include <linux/personality.h>
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
+#include <linux/context_tracking.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -575,12 +576,15 @@ static int do_signal(struct pt_regs *regs, int syscall)
 asmlinkage int
 do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 {
+	int retval = 0;
+
+	user_exit();
 	do {
 		if (likely(thread_flags & _TIF_NEED_RESCHED)) {
 			schedule();
 		} else {
 			if (unlikely(!user_mode(regs)))
-				return 0;
+				break;
 			local_irq_enable();
 			if (thread_flags & _TIF_SIGPENDING) {
 				int restart = do_signal(regs, syscall);
@@ -590,7 +594,8 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 					 * Deal with it without leaving
 					 * the kernel space.
 					 */
-					return restart;
+					retval = restart;
+					break;
 				}
 				syscall = 0;
 			} else {
@@ -601,5 +606,6 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 		local_irq_disable();
 		thread_flags = current_thread_info()->flags;
 	} while (thread_flags & _TIF_WORK_MASK);
-	return 0;
+	user_enter();
+	return retval;
 }
-- 
1.8.2

