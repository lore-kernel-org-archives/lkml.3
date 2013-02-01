Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3BAK2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:28:42 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44006 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab3BAK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:28:08 -0500
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH 4/5] powerpc: Use the new schedule_user API on userspace preemption
Date: Fri,  1 Feb 2013 18:27:44 +0800
Message-Id: <1359714465-6297-5-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359714465-6297-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1359714465-6297-1-git-send-email-zhong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020110-2000-0000-0000-00000AD126FD
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
index 3adccd8..2e042ba 100644
--- a/arch/powerpc/include/asm/context_tracking.h
+++ b/arch/powerpc/include/asm/context_tracking.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_POWERPC_CONTEXT_TRACKING_H
 #define _ASM_POWERPC_CONTEXT_TRACKING_H
 
+#ifndef __ASSEMBLY__
 #include <linux/context_tracking.h>
 #include <asm/ptrace.h>
 
@@ -17,4 +18,14 @@ static inline void exception_exit(struct pt_regs *regs)
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
index 3d990d3..91f09ec 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -33,6 +33,7 @@
 #include <asm/irqflags.h>
 #include <asm/ftrace.h>
 #include <asm/hw_irq.h>
+#include <asm/context_tracking.h>
 
 /*
  * System calls.
@@ -595,7 +596,7 @@ _GLOBAL(ret_from_except_lite)
 	andi.	r0,r4,_TIF_NEED_RESCHED
 	beq	1f
 	bl	.restore_interrupts
-	bl	.schedule
+	SCHEDULE_USER
 	b	.ret_from_except_lite
 
 1:	bl	.save_nvgprs
-- 
1.7.9.5

