Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbaICVUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:20:23 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33435 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560AbaICVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:29 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 16/24] ARM64:ILP32: Support core dump for ILP32
Date: Wed,  3 Sep 2014 14:19:10 -0700
Message-Id: <1409779158-30963-17-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports core dumping on ILP32.
We need a few extra macros (COMPAT_PR_REG_SIZE and COMPAT_PRSTATUS_SIZE) due
to size differences of the register sets.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/elf.h |   23 +++++++++++++++++++++--
 arch/arm64/kernel/ptrace.c   |   12 ++++++------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index ca27c02..795dc9f 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -179,8 +179,8 @@ extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 
 /* AArch32 registers. */
 #define COMPAT_A32_ELF_NGREG		18
-typedef unsigned int			compat_elf_greg_t;
-typedef compat_elf_greg_t		compat_elf_gregset_t[COMPAT_A32_ELF_NGREG];
+typedef unsigned int			compat_a32_elf_greg_t;
+typedef compat_a32_elf_greg_t		compat_a32_elf_gregset_t[COMPAT_A32_ELF_NGREG];
 
 /* AArch32 EABI. */
 #define EF_ARM_EABI_MASK		0xff000000
@@ -209,6 +209,25 @@ typedef elf_gregset_t			compat_elf_gregset_t;
 
 #endif
 
+/*
+ * If ILP32 is turned on, we want to define the compat_elf_greg_t to the non compat
+ * one and define PR_REG_SIZE/PRSTATUS_SIZE/SET_PR_FPVALID so we pick up the correct
+ * ones for AARCH32.
+ */
+#ifdef CONFIG_ARM64_ILP32
+typedef elf_greg_t			compat_elf_greg_t;
+typedef elf_gregset_t			compat_elf_gregset_t;
+#define COMPAT_PR_REG_SIZE(S)		(is_a32_compat_task() ? 72 : 272)
+#define COMPAT_PRSTATUS_SIZE(S)		(is_a32_compat_task() ? 124 : 352)
+#define COMPAT_SET_PR_FPVALID(S, V)							\
+do {										\
+	*(int *) (((void *) &((S)->pr_reg)) + PR_REG_SIZE((S)->pr_reg)) = (V);	\
+} while (0)
+#else
+typedef compat_a32_elf_greg_t compat_elf_greg_t;
+typedef compat_a32_elf_gregset_t compat_elf_gregset_t;
+#endif
+
 #define compat_elf_check_arch(x)	compat_a32_elf_check_arch(x)
 
 #endif /* CONFIG_COMPAT */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index efabfc4..ffdd1a8 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -796,8 +796,8 @@ static const struct user_regset aarch32_regsets[] = {
 	[REGSET_COMPAT_GPR] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = COMPAT_A32_ELF_NGREG,
-		.size = sizeof(compat_elf_greg_t),
-		.align = sizeof(compat_elf_greg_t),
+		.size = sizeof(compat_a32_elf_greg_t),
+		.align = sizeof(compat_a32_elf_greg_t),
 		.get = compat_gpr_get,
 		.set = compat_gpr_set
 	},
@@ -830,7 +830,7 @@ static int compat_ptrace_read_user(struct task_struct *tsk, compat_ulong_t off,
 		tmp = tsk->mm->start_data;
 	else if (off == COMPAT_PT_TEXT_END_ADDR)
 		tmp = tsk->mm->end_code;
-	else if (off < sizeof(compat_elf_gregset_t))
+	else if (off < sizeof(compat_a32_elf_gregset_t))
 		return copy_regset_to_user(tsk, &user_aarch32_view,
 					   REGSET_COMPAT_GPR, off,
 					   sizeof(compat_ulong_t), ret);
@@ -851,7 +851,7 @@ static int compat_ptrace_write_user(struct task_struct *tsk, compat_ulong_t off,
 	if (off & 3 || off >= COMPAT_USER_SZ)
 		return -EIO;
 
-	if (off >= sizeof(compat_elf_gregset_t))
+	if (off >= sizeof(compat_a32_elf_gregset_t))
 		return 0;
 
 	set_fs(KERNEL_DS);
@@ -1014,7 +1014,7 @@ long compat_a32_arch_ptrace(struct task_struct *child, compat_long_t request,
 			ret = copy_regset_to_user(child,
 						  &user_aarch32_view,
 						  REGSET_COMPAT_GPR,
-						  0, sizeof(compat_elf_gregset_t),
+						  0, sizeof(compat_a32_elf_gregset_t),
 						  datap);
 			break;
 
@@ -1022,7 +1022,7 @@ long compat_a32_arch_ptrace(struct task_struct *child, compat_long_t request,
 			ret = copy_regset_from_user(child,
 						    &user_aarch32_view,
 						    REGSET_COMPAT_GPR,
-						    0, sizeof(compat_elf_gregset_t),
+						    0, sizeof(compat_a32_elf_gregset_t),
 						    datap);
 			break;
 
-- 
1.7.2.5

