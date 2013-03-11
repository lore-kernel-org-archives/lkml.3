Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3CKLC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:02:58 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54839 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKLC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:02:56 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v4][PATCH 2/7] powerpc/book3e: store critical/machine/debug exception thread info
Date: Mon, 11 Mar 2013 19:02:41 +0800
Message-ID: <1362999766-20897-3-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362999766-20897-1-git-send-email-tiejun.chen@windriver.com>
References: <1362999766-20897-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to store thread info to these exception thread info like something
we already did for PPC32.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/exceptions-64e.S |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 7fd6af0..7df9a1f 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -67,6 +67,18 @@
 	std	r10,PACA_##level##_STACK(r13);
 #endif
 
+/* Store something to exception thread info */
+#define	BOOK3E_STORE_EXC_LEVEL_THEAD_INFO(type)					\
+	ld	r14,PACAKSAVE(r13);						\
+	CURRENT_THREAD_INFO(r14, r14);						\
+	CURRENT_THREAD_INFO(r15, r1);						\
+	ld	r10,TI_FLAGS(r14);		     				\
+	std	r10,TI_FLAGS(r15);			     			\
+	ld	r10,TI_PREEMPT(r14);		     				\
+	std	r10,TI_PREEMPT(r15);		     				\
+	ld	r10,TI_TASK(r14);			     			\
+	std	r10,TI_TASK(r15);
+
 /* Exception prolog code for all exceptions */
 #define EXCEPTION_PROLOG(n, intnum, type, addition)	    		    \
 	mtspr	SPRN_SPRG_##type##_SCRATCH,r13;	/* get spare registers */   \
@@ -104,6 +116,7 @@
 	BOOK3E_LOAD_EXC_LEVEL_STACK(CRIT);					\
 	ld	r1,PACA_CRIT_STACK(r13);				    \
 	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
+	BOOK3E_STORE_EXC_LEVEL_THEAD_INFO(CRIT);				\
 1:
 #define SPRN_CRIT_SRR0	SPRN_CSRR0
 #define SPRN_CRIT_SRR1	SPRN_CSRR1
@@ -114,6 +127,7 @@
 	BOOK3E_LOAD_EXC_LEVEL_STACK(DBG);					\
 	ld	r1,PACA_DBG_STACK(r13);					    \
 	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
+	BOOK3E_STORE_EXC_LEVEL_THEAD_INFO(DBG);					\
 1:
 #define SPRN_DBG_SRR0	SPRN_DSRR0
 #define SPRN_DBG_SRR1	SPRN_DSRR1
@@ -124,6 +138,7 @@
 	BOOK3E_LOAD_EXC_LEVEL_STACK(MC);					\
 	ld	r1,PACA_MC_STACK(r13);					    \
 	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
+	BOOK3E_STORE_EXC_LEVEL_THEAD_INFO(MC);					\
 1:
 #define SPRN_MC_SRR0	SPRN_MCSRR0
 #define SPRN_MC_SRR1	SPRN_MCSRR1
-- 
1.7.9.5

