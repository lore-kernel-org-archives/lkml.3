Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3C2KCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:02:01 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:34203 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab3C2KBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:01:03 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 4/6] powerpc: Use the new schedule_user API on userspace preemption
Date: Fri, 29 Mar 2013 18:00:19 +0800
Message-Id: <1364551221-23177-5-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032909-4790-0000-0000-0000079F0526
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corresponds to
[PATCH] x86: Use the new schedule_user API on userspace preemption
  commit 0430499ce9d78691f3985962021b16bf8f8a8048

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/context_tracking.h |   11 +++++++++++
 arch/powerpc/kernel/entry_64.S              |    3 ++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/context_tracking.h b/arch/powerpc/include/asm/context_tracking.h
index 377146e..4da287e 100644
--- a/arch/powerpc/include/asm/context_tracking.h
+++ b/arch/powerpc/include/asm/context_tracking.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_POWERPC_CONTEXT_TRACKING_H
 #define _ASM_POWERPC_CONTEXT_TRACKING_H
 
+#ifndef __ASSEMBLY__
 #include <linux/context_tracking.h>
 #include <asm/ptrace.h>
 
@@ -25,4 +26,14 @@ static inline void __exception_exit(struct pt_regs *regs)
 #endif
 }
 
+#else /* __ASSEMBLY__ */
+
+#ifdef CONFIG_CONTEXT_TRACKING
+#define SCHEDULE_USER bl	.schedule_user
+#else
+#define SCHEDULE_USER bl	.schedule
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
 #endif
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 256c5bf..f7e4622 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -33,6 +33,7 @@
 #include <asm/irqflags.h>
 #include <asm/ftrace.h>
 #include <asm/hw_irq.h>
+#include <asm/context_tracking.h>
 
 /*
  * System calls.
@@ -618,7 +619,7 @@ _GLOBAL(ret_from_except_lite)
 	andi.	r0,r4,_TIF_NEED_RESCHED
 	beq	1f
 	bl	.restore_interrupts
-	bl	.schedule
+	SCHEDULE_USER
 	b	.ret_from_except_lite
 
 1:	bl	.save_nvgprs
-- 
1.7.9.5

