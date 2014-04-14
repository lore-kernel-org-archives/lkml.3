Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaDNRNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:13:33 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:41405 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaDNRNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:13:30 -0400
From: Konstantin Tokarev <ktokarev@smartlabs.tv>
Organization: SmartLabs
To: Matt Fleming <matt.fleming@intel.com>, Paul Mundt <paul.mundt@gmail.com>
Subject: [PATCH] sh: Implemented syscall_{get|set}_arguments for i != 0
Date: Mon, 14 Apr 2014 21:13:26 +0400
User-Agent: KMail/1.13.5 (Linux/3.1.6-desktop-69mib; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201404142113.26822.ktokarev@smartlabs.tv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5cd11ca62acfcde2757fbcc9bbb55e9449d2d50b Mon Sep 17 00:00:00 2001
From: Konstantin Tokarev <ktokarev@smartlabs.tv>
Date: Mon, 14 Apr 2014 20:38:00 +0400
Subject: [PATCH] sh: Implemented syscall_{get|set}_arguments for i != 0.

syscall_get_arguments and syscall_set_arguments implementations for SH
will not call BUG() when invokend with i != 0 anymore.

Signed-off-by: Konstantin Tokarev <ktokarev@smartlabs.tv>
---
 arch/sh/include/asm/syscall_32.h |   74 
+++++++++++++++++++++-----------------
 1 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/arch/sh/include/asm/syscall_32.h 
b/arch/sh/include/asm/syscall_32.h
index 7d80df4..52fb5ad 100755
--- a/arch/sh/include/asm/syscall_32.h
+++ b/arch/sh/include/asm/syscall_32.h
@@ -44,53 +44,61 @@ static inline void syscall_set_return_value(struct 
task_struct *task,
 		regs->regs[0] = val;
 }
 
-static inline void syscall_get_arguments(struct task_struct *task,
-					 struct pt_regs *regs,
-					 unsigned int i, unsigned int n,
-					 unsigned long *args)
+static inline unsigned long sh_get_syscall_arg(struct pt_regs *regs,
+					       unsigned int n)
 {
-	/*
-	 * Do this simply for now. If we need to start supporting
-	 * fetching arguments from arbitrary indices, this will need some
-	 * extra logic. Presently there are no in-tree users that depend
-	 * on this behaviour.
-	 */
-	BUG_ON(i);
-
 	/* Argument pattern is: R4, R5, R6, R7, R0, R1 */
 	switch (n) {
-	case 6: args[5] = regs->regs[1];
-	case 5: args[4] = regs->regs[0];
-	case 4: args[3] = regs->regs[7];
-	case 3: args[2] = regs->regs[6];
-	case 2: args[1] = regs->regs[5];
-	case 1:	args[0] = regs->regs[4];
+	case 5: return regs->regs[1];
+	case 4: return regs->regs[0];
+	case 3: return regs->regs[7];
+	case 2: return regs->regs[6];
+	case 1: return regs->regs[5];
+	case 0: return regs->regs[4];
+	default:
+		BUG();
+	}
+	return ~0;
+}
+
+static inline void sh_set_syscall_arg(struct pt_regs *regs,
+				      unsigned int n,
+				      unsigned long val)
+{
+	switch (n) {
+	case 5:
+		regs->regs[1] = val;
+	case 4:
+		regs->regs[0] = val;
+	case 3:
+		regs->regs[7] = val;
+	case 2:
+		regs->regs[6] = val;
+	case 1:
+		regs->regs[5] = val;
 	case 0:
-		break;
+		regs->regs[4] = val;
 	default:
 		BUG();
 	}
 }
 
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	while (n--)
+		*args++ = sh_get_syscall_arg(regs, i++);
+}
+
 static inline void syscall_set_arguments(struct task_struct *task,
 					 struct pt_regs *regs,
 					 unsigned int i, unsigned int n,
 					 const unsigned long *args)
 {
-	/* Same note as above applies */
-	BUG_ON(i);
-
-	switch (n) {
-	case 6: regs->regs[1] = args[5];
-	case 5: regs->regs[0] = args[4];
-	case 4: regs->regs[7] = args[3];
-	case 3: regs->regs[6] = args[2];
-	case 2: regs->regs[5] = args[1];
-	case 1: regs->regs[4] = args[0];
-		break;
-	default:
-		BUG();
-	}
+	while (n--)
+		sh_set_syscall_arg(regs, i++, *args++);
 }
 
 #endif /* __ASM_SH_SYSCALL_32_H */
-- 
1.7.2.5

