Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3CKLEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:04:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:37709 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3CKLCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:02:54 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v4][PATCH 1/7] powerpc/book3e: load critical/machine/debug exception stack
Date: Mon, 11 Mar 2013 19:02:40 +0800
Message-ID: <1362999766-20897-2-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362999766-20897-1-git-send-email-tiejun.chen@windriver.com>
References: <1362999766-20897-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always alloc critical/machine/debug check exceptions. This is
different from the normal exception. So we should load these exception
stack properly like we did for booke.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/exceptions-64e.S |   49 +++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 1e7782b..7fd6af0 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -36,6 +36,37 @@
  */
 #define	SPECIAL_EXC_FRAME_SIZE	INT_FRAME_SIZE
 
+/* only on book3e */
+#define DBG_STACK_BASE		dbgirq_ctx
+#define MC_STACK_BASE		mcheckirq_ctx
+#define CRIT_STACK_BASE		critirq_ctx
+
+#ifdef CONFIG_RELOCATABLE
+#define LOAD_STACK_BASE(reg, level)			\
+	tovirt(r2,r2);					\
+	LOAD_REG_ADDR(reg, level##_STACK_BASE);
+#else
+#define LOAD_STACK_BASE(reg, level)			\
+	LOAD_REG_IMMEDIATE(reg, level##_STACK_BASE);
+#endif
+
+#ifdef CONFIG_SMP
+#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
+	mfspr	r14,SPRN_PIR;				\
+	slwi	r14,r14,3;				\
+	LOAD_STACK_BASE(r10, level);			\
+	add	r10,r10,r14;				\
+	ld	r10,0(r10);				\
+	addi	r10,r10,THREAD_SIZE;			\
+	std	r10,PACA_##level##_STACK(r13);
+#else
+#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
+	LOAD_STACK_BASE(r10, level);			\
+	ld	r10,0(r10);				\
+	addi	r10,r10,THREAD_SIZE;			\
+	std	r10,PACA_##level##_STACK(r13);
+#endif
+
 /* Exception prolog code for all exceptions */
 #define EXCEPTION_PROLOG(n, intnum, type, addition)	    		    \
 	mtspr	SPRN_SPRG_##type##_SCRATCH,r13;	/* get spare registers */   \
@@ -68,20 +99,32 @@
 #define SPRN_GDBELL_SRR1	SPRN_GSRR1
 
 #define CRIT_SET_KSTACK						            \
+	andi.	r10,r11,MSR_PR;							\
+	bne	1f;								\
+	BOOK3E_LOAD_EXC_LEVEL_STACK(CRIT);					\
 	ld	r1,PACA_CRIT_STACK(r13);				    \
-	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
+	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
+1:
 #define SPRN_CRIT_SRR0	SPRN_CSRR0
 #define SPRN_CRIT_SRR1	SPRN_CSRR1
 
 #define DBG_SET_KSTACK						            \
+	andi.	r10,r11,MSR_PR;							\
+	bne	1f;								\
+	BOOK3E_LOAD_EXC_LEVEL_STACK(DBG);					\
 	ld	r1,PACA_DBG_STACK(r13);					    \
-	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
+	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
+1:
 #define SPRN_DBG_SRR0	SPRN_DSRR0
 #define SPRN_DBG_SRR1	SPRN_DSRR1
 
 #define MC_SET_KSTACK						            \
+	andi.	r10,r11,MSR_PR;							\
+	bne	1f;								\
+	BOOK3E_LOAD_EXC_LEVEL_STACK(MC);					\
 	ld	r1,PACA_MC_STACK(r13);					    \
-	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
+	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
+1:
 #define SPRN_MC_SRR0	SPRN_MCSRR0
 #define SPRN_MC_SRR1	SPRN_MCSRR1
 
-- 
1.7.9.5

