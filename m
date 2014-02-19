Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaBSGWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:22:41 -0500
Received: from koorogi.info ([198.74.62.75]:34676 "EHLO mail.koorogi.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbaBSGWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:22:37 -0500
From: Bobby Bingham <koorogi@koorogi.info>
To: akpm@linux-foundation.org, linux-sh@vger.kernel.org
Cc: Bobby Bingham <koorogi@koorogi.info>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] sh: don't pass saved userspace state to exception handlers
Date: Wed, 19 Feb 2014 00:03:16 -0600
Message-Id: <8e2edd2e2709408c8e1b27a1b8a221c011125beb.1392789383.git.koorogi@koorogi.info>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <cover.1392789383.git.koorogi@koorogi.info>
References: <cover.1392789383.git.koorogi@koorogi.info>
In-Reply-To: <cover.1392789383.git.koorogi@koorogi.info>
References: <cover.1392789383.git.koorogi@koorogi.info>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler is permitted to generate code which overwrites the parameters
to a function. If those parameters include the only saved copy we have of
userspace's registers, we're in trouble.

Signed-off-by: Bobby Bingham <koorogi@koorogi.info>
---
 arch/sh/include/asm/traps_32.h | 16 ++++------------
 arch/sh/kernel/traps_32.c      | 23 +++++++----------------
 2 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/arch/sh/include/asm/traps_32.h b/arch/sh/include/asm/traps_32.h
index cfd55ff..17e129f 100644
--- a/arch/sh/include/asm/traps_32.h
+++ b/arch/sh/include/asm/traps_32.h
@@ -42,18 +42,10 @@ static inline void trigger_address_error(void)
 asmlinkage void do_address_error(struct pt_regs *regs,
 				 unsigned long writeaccess,
 				 unsigned long address);
-asmlinkage void do_divide_error(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage void do_reserved_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage void do_illegal_slot_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage void do_exception_error(unsigned long r4, unsigned long r5,
-				   unsigned long r6, unsigned long r7,
-				   struct pt_regs __regs);
+asmlinkage void do_divide_error(unsigned long r4);
+asmlinkage void do_reserved_inst(void);
+asmlinkage void do_illegal_slot_inst(void);
+asmlinkage void do_exception_error(void);
 
 #define BUILD_TRAP_HANDLER(name)					\
 asmlinkage void name##_trap_handler(unsigned long r4, unsigned long r5,	\
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index 68e99f0..ff63934 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -594,9 +594,7 @@ int is_dsp_inst(struct pt_regs *regs)
 #endif /* CONFIG_SH_DSP */
 
 #ifdef CONFIG_CPU_SH2A
-asmlinkage void do_divide_error(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs)
+asmlinkage void do_divide_error(unsigned long r4)
 {
 	siginfo_t info;
 
@@ -613,11 +611,9 @@ asmlinkage void do_divide_error(unsigned long r4, unsigned long r5,
 }
 #endif
 
-asmlinkage void do_reserved_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs)
+asmlinkage void do_reserved_inst(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = current_pt_regs();
 	unsigned long error_code;
 	struct task_struct *tsk = current;
 
@@ -701,11 +697,9 @@ static int emulate_branch(unsigned short inst, struct pt_regs *regs)
 }
 #endif
 
-asmlinkage void do_illegal_slot_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs)
+asmlinkage void do_illegal_slot_inst(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = current_pt_regs();
 	unsigned long inst;
 	struct task_struct *tsk = current;
 
@@ -730,15 +724,12 @@ asmlinkage void do_illegal_slot_inst(unsigned long r4, unsigned long r5,
 	die_if_no_fixup("illegal slot instruction", regs, inst);
 }
 
-asmlinkage void do_exception_error(unsigned long r4, unsigned long r5,
-				   unsigned long r6, unsigned long r7,
-				   struct pt_regs __regs)
+asmlinkage void do_exception_error(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
 	long ex;
 
 	ex = lookup_exception_vector();
-	die_if_kernel("exception", regs, ex);
+	die_if_kernel("exception", current_pt_regs(), ex);
 }
 
 void per_cpu_trap_init(void)
-- 
1.8.5.5

