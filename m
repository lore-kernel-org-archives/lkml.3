Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3ENCRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:17:38 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49395 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab3ENCRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:17:04 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        michael@ellerman.id.au, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 4/5] powerpc: Use the new schedule_user API on userspace preemption
Date: Tue, 14 May 2013 10:16:43 +0800
Message-Id: <1368497804-21706-5-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368497804-21706-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1368497804-21706-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051402-2000-0000-0000-00000C19D8B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corresponds to
[PATCH] x86: Use the new schedule_user API on userspace preemption
  commit 0430499ce9d78691f3985962021b16bf8f8a8048

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/context_tracking.h |   10 ++++++++++
 arch/powerpc/kernel/entry_64.S              |    3 ++-
 2 files changed, 12 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/include/asm/context_tracking.h

diff --git a/arch/powerpc/include/asm/context_tracking.h b/arch/powerpc/include/asm/context_tracking.h
new file mode 100644
index 0000000..b6f5a33
--- /dev/null
+++ b/arch/powerpc/include/asm/context_tracking.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_POWERPC_CONTEXT_TRACKING_H
+#define _ASM_POWERPC_CONTEXT_TRACKING_H
+
+#ifdef CONFIG_CONTEXT_TRACKING
+#define SCHEDULE_USER bl	.schedule_user
+#else
+#define SCHEDULE_USER bl	.schedule
+#endif
+
+#endif
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 915fbb4..d418977 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -33,6 +33,7 @@
 #include <asm/irqflags.h>
 #include <asm/ftrace.h>
 #include <asm/hw_irq.h>
+#include <asm/context_tracking.h>
 
 /*
  * System calls.
@@ -634,7 +635,7 @@ _GLOBAL(ret_from_except_lite)
 	andi.	r0,r4,_TIF_NEED_RESCHED
 	beq	1f
 	bl	.restore_interrupts
-	bl	.schedule
+	SCHEDULE_USER
 	b	.ret_from_except_lite
 
 1:	bl	.save_nvgprs
-- 
1.7.9.5

