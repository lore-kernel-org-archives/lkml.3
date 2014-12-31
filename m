Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaLaPYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:24:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaLaPWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:22:49 -0500
From: Pratyush Anand <panand@redhat.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com, oleg@redhat.com,
        Pratyush Anand <panand@redhat.com>
Subject: [RFC 2/8] ARM64: Refactor kprobes-arm64
Date: Wed, 31 Dec 2014 20:51:18 +0530
Message-Id: <9a86c217f387f45568c18b724024b0d3e040d2c6.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the stuff of kprobes-arm64.c can also be used by uprobes.c. So
move all those part to common code area. In the process rename kprobe to
probe whereever possible.

No functional change.

Signed-off-by: Pratyush Anand <panand@redhat.com>
---
 arch/arm64/include/asm/probes.h                    | 25 +++----
 arch/arm64/kernel/Makefile                         |  2 +-
 arch/arm64/kernel/kprobes.c                        | 11 +--
 .../kernel/{kprobes-arm64.c => probes-arm64.c}     | 84 ++++++++++------------
 .../kernel/{kprobes-arm64.h => probes-arm64.h}     | 17 ++---
 arch/arm64/kernel/probes-condn-check.c             |  2 +-
 arch/arm64/kernel/probes-decode.h                  |  4 +-
 7 files changed, 70 insertions(+), 75 deletions(-)
 rename arch/arm64/kernel/{kprobes-arm64.c => probes-arm64.c} (79%)
 rename arch/arm64/kernel/{kprobes-arm64.h => probes-arm64.h} (60%)

diff --git a/arch/arm64/include/asm/probes.h b/arch/arm64/include/asm/probes.h
index 9dba74d8ee86..daa2ff822a2e 100644
--- a/arch/arm64/include/asm/probes.h
+++ b/arch/arm64/include/asm/probes.h
@@ -15,36 +15,37 @@
 #ifndef _ARM_PROBES_H
 #define _ARM_PROBES_H
 
-struct kprobe;
 struct arch_specific_insn;
 
 typedef u32 kprobe_opcode_t;
-typedef unsigned long (kprobes_pstate_check_t)(unsigned long);
+typedef u32 probe_opcode_t;
+typedef unsigned long (probes_pstate_check_t)(unsigned long);
 typedef unsigned long
-(kprobes_condition_check_t)(struct kprobe *p, struct pt_regs *);
+(probes_condition_check_t)(u32 opcode, struct arch_specific_insn *,
+	struct pt_regs *);
 typedef void
-(kprobes_prepare_t)(struct kprobe *, struct arch_specific_insn *);
-typedef void (kprobes_handler_t) (u32 opcode, long addr, struct pt_regs *);
+(probes_prepare_t)(u32 opcode, struct arch_specific_insn *);
+typedef void (probes_handler_t) (u32 opcode, long addr, struct pt_regs *);
 
 enum pc_restore_type {
 	NO_RESTORE,
 	RESTORE_PC,
 };
 
-struct kprobe_pc_restore {
+struct probe_pc_restore {
 	enum pc_restore_type type;
 	unsigned long addr;
 };
 
 /* architecture specific copy of original instruction */
 struct arch_specific_insn {
-	kprobe_opcode_t *insn;
-	kprobes_pstate_check_t *pstate_cc;
-	kprobes_condition_check_t *check_condn;
-	kprobes_prepare_t *prepare;
-	kprobes_handler_t *handler;
+	probe_opcode_t *insn;
+	probes_pstate_check_t *pstate_cc;
+	probes_condition_check_t *check_condn;
+	probes_prepare_t *prepare;
+	probes_handler_t *handler;
 	/* restore address after step xol */
-	struct kprobe_pc_restore restore;
+	struct probe_pc_restore restore;
 };
 
 #endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 6e4dcde27742..0ed83ba3d46d 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -31,7 +31,7 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
-arm64-obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-arm64.o		\
+arm64-obj-$(CONFIG_KPROBES)		+= kprobes.o probes-arm64.o		\
 					   probes-simulate-insn.o		\
 					   probes-condn-check.o
 arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
diff --git a/arch/arm64/kernel/kprobes.c b/arch/arm64/kernel/kprobes.c
index be7c33070252..1cf5db159bc9 100644
--- a/arch/arm64/kernel/kprobes.c
+++ b/arch/arm64/kernel/kprobes.c
@@ -30,7 +30,7 @@
 #include <asm/insn.h>
 
 #include "kprobes.h"
-#include "kprobes-arm64.h"
+#include "probes-arm64.h"
 
 #define MIN_STACK_SIZE(addr)	min((unsigned long)MAX_STACK_SIZE,	\
 	(unsigned long)current_thread_info() + THREAD_START_SP - (addr))
@@ -60,7 +60,7 @@ static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 static void __kprobes arch_prepare_simulate(struct kprobe *p)
 {
 	if (p->ainsn.prepare)
-		p->ainsn.prepare(p, &p->ainsn);
+		p->ainsn.prepare(p->opcode, &p->ainsn);
 
 	/* This instructions is not executed xol. No need to adjust the PC */
 	p->ainsn.restore.addr = 0;
@@ -91,7 +91,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		return -EINVAL;
 
 	/* decode instruction */
-	switch (arm_kprobe_decode_insn(insn, &p->ainsn)) {
+	switch (arm_probe_decode_insn(insn, &p->ainsn)) {
 	case INSN_REJECTED:	/* insn not supported */
 		return -EINVAL;
 
@@ -275,7 +275,8 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
 	case KPROBE_HIT_ACTIVE:
-		if (!p->ainsn.check_condn || p->ainsn.check_condn(p, regs)) {
+		if (!p->ainsn.check_condn || p->ainsn.check_condn(p->opcode,
+					&p->ainsn, regs)) {
 			kprobes_inc_nmissed_count(p);
 			setup_singlestep(p, regs, kcb, 1);
 		} else	{
@@ -408,7 +409,7 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 			if (reenter_kprobe(p, regs, kcb))
 				return;
 		} else if (!p->ainsn.check_condn ||
-			   p->ainsn.check_condn(p, regs)) {
+			   p->ainsn.check_condn(p->opcode, &p->ainsn, regs)) {
 			/* Probe hit and conditional execution check ok. */
 			set_current_kprobe(p);
 			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
diff --git a/arch/arm64/kernel/kprobes-arm64.c b/arch/arm64/kernel/probes-arm64.c
similarity index 79%
rename from arch/arm64/kernel/kprobes-arm64.c
rename to arch/arm64/kernel/probes-arm64.c
index bee7816cfd75..c258b390cbc1 100644
--- a/arch/arm64/kernel/kprobes-arm64.c
+++ b/arch/arm64/kernel/probes-arm64.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm64/kernel/kprobes-arm64.c
+ * arch/arm64/kernel/probes-arm64.c
  *
  * Copyright (C) 2013 Linaro Limited.
  *
@@ -14,81 +14,73 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kprobes.h>
 #include <linux/module.h>
-#include <asm/kprobes.h>
+#include <asm/probes.h>
 
 #include "probes-decode.h"
-#include "kprobes-arm64.h"
+#include "probes-arm64.h"
 #include "probes-simulate-insn.h"
 
 /*
- * condition check functions for kprobes simulation
+ * condition check functions for (k/u)probes simulation
  */
-static unsigned long __kprobes
-__check_pstate(struct kprobe *p, struct pt_regs *regs)
+static unsigned long
+__check_pstate(u32 opcode, struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	struct arch_specific_insn *asi = &p->ainsn;
 	unsigned long pstate = regs->pstate & 0xffffffff;
 
 	return asi->pstate_cc(pstate);
 }
 
-static unsigned long __kprobes
-__check_cbz(struct kprobe *p, struct pt_regs *regs)
+static unsigned long
+__check_cbz(u32 opcode, struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	return check_cbz((u32)p->opcode, regs);
+	return check_cbz(opcode, regs);
 }
 
-static unsigned long __kprobes
-__check_cbnz(struct kprobe *p, struct pt_regs *regs)
+static unsigned long
+__check_cbnz(u32 opcode, struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	return check_cbnz((u32)p->opcode, regs);
+	return check_cbnz(opcode, regs);
 }
 
-static unsigned long __kprobes
-__check_tbz(struct kprobe *p, struct pt_regs *regs)
+static unsigned long
+__check_tbz(u32 opcode, struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	return check_tbz((u32)p->opcode, regs);
+	return check_tbz(opcode, regs);
 }
 
-static unsigned long __kprobes
-__check_tbnz(struct kprobe *p, struct pt_regs *regs)
+static unsigned long
+__check_tbnz(u32 opcode, struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	return check_tbnz((u32)p->opcode, regs);
+	return check_tbnz(opcode, regs);
 }
 
 /*
  * prepare functions for instruction simulation
  */
-static void __kprobes
-prepare_none(struct kprobe *p, struct arch_specific_insn *asi)
+static void
+prepare_none(u32 opcode, struct arch_specific_insn *asi)
 {
 }
 
-static void __kprobes
-prepare_bcond(struct kprobe *p, struct arch_specific_insn *asi)
+static void
+prepare_bcond(u32 opcode, struct arch_specific_insn *asi)
 {
-	kprobe_opcode_t insn = p->opcode;
-
 	asi->check_condn = __check_pstate;
-	asi->pstate_cc = kprobe_condition_checks[insn & 0xf];
+	asi->pstate_cc = probe_condition_checks[opcode & 0xf];
 }
 
-static void __kprobes
-prepare_cbz_cbnz(struct kprobe *p, struct arch_specific_insn *asi)
+static void
+prepare_cbz_cbnz(u32 opcode, struct arch_specific_insn *asi)
 {
-	kprobe_opcode_t insn = p->opcode;
-
-	asi->check_condn = (insn & (1 << 24)) ? __check_cbnz : __check_cbz;
+	asi->check_condn = (opcode & (1 << 24)) ? __check_cbnz : __check_cbz;
 }
 
-static void __kprobes
-prepare_tbz_tbnz(struct kprobe *p, struct arch_specific_insn *asi)
+static void
+prepare_tbz_tbnz(u32 opcode, struct arch_specific_insn *asi)
 {
-	kprobe_opcode_t insn = p->opcode;
-
-	asi->check_condn = (insn & (1 << 24)) ? __check_tbnz : __check_tbz;
+	asi->check_condn = (opcode & (1 << 24)) ? __check_tbnz : __check_tbz;
 }
 
 
@@ -116,7 +108,7 @@ static const struct aarch64_decode_item load_literal_subtable[] = {
 	DECODE_END,
 };
 
-/* AArch64 instruction decode table for kprobes:
+/* AArch64 instruction decode table for (k/u)probes:
  * The instruction will fall into one of the 3 groups:
  *  1. Single stepped out-of-the-line slot.
  *     -Most instructions fall in this group, those does not
@@ -194,7 +186,7 @@ static const struct aarch64_decode_item aarch64_decode_table[] = {
 	 * Encoding: 1101 0101 00xx xxxx xxxx xxxx xxxx xxxx
 	 *
 	 * Note: MSR immediate (update PSTATE daif) is not safe handling
-	 * within kprobes, rejected.
+	 * within (k/u)probes, rejected.
 	 *
 	 * Don't re-arrange these decode table entries.
 	 */
@@ -265,8 +257,8 @@ static const struct aarch64_decode_item aarch64_decode_table[] = {
 	DECODE_END,
 };
 
-static int __kprobes
-kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+static int
+probe_decode_insn(probe_opcode_t insn, struct arch_specific_insn *asi,
 		   const struct aarch64_decode_item *tbl)
 {
 	unsigned int entry, ret = INSN_REJECTED;
@@ -295,19 +287,19 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 
 	case DECODE_TYPE_TABLE:
 		/* recurse with next level decode table */
-		ret = kprobe_decode_insn(insn, asi,
+		ret = probe_decode_insn(insn, asi,
 					 decode_sub_table(tbl[entry]));
 	};
 	return ret;
 }
 
 /* Return:
- *   INSN_REJECTED     If instruction is one not allowed to kprobe,
+ *   INSN_REJECTED     If instruction is one not allowed to (k/u)probe,
  *   INSN_GOOD         If instruction is supported and uses instruction slot,
  *   INSN_GOOD_NO_SLOT If instruction is supported but doesn't use its slot.
  */
-enum kprobe_insn __kprobes
-arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+enum probe_insn
+arm_probe_decode_insn(probe_opcode_t insn, struct arch_specific_insn *asi)
 {
-	return kprobe_decode_insn(insn, asi, aarch64_decode_table);
+	return probe_decode_insn(insn, asi, aarch64_decode_table);
 }
diff --git a/arch/arm64/kernel/kprobes-arm64.h b/arch/arm64/kernel/probes-arm64.h
similarity index 60%
rename from arch/arm64/kernel/kprobes-arm64.h
rename to arch/arm64/kernel/probes-arm64.h
index ff8a55f61cda..a748d0ddfeef 100644
--- a/arch/arm64/kernel/kprobes-arm64.h
+++ b/arch/arm64/kernel/probes-arm64.h
@@ -1,5 +1,5 @@
 /*
- * arch/arm64/kernel/kprobes-arm64.h
+ * arch/arm64/kernel/probes-arm64.h
  *
  * Copyright (C) 2013 Linaro Limited.
  *
@@ -13,18 +13,19 @@
  * General Public License for more details.
  */
 
-#ifndef _ARM_KERNEL_KPROBES_ARM64_H
-#define _ARM_KERNEL_KPROBES_ARM64_H
+#ifndef _ARM_KERNEL_PROBES_ARM64_H
+#define _ARM_KERNEL_PROBES_ARM64_H
 
-enum kprobe_insn {
+enum probe_insn {
 	INSN_REJECTED,
 	INSN_GOOD_NO_SLOT,
 	INSN_GOOD,
 };
 
-extern kprobes_pstate_check_t * const kprobe_condition_checks[16];
+typedef u32 probe_opcode_t;
+extern probes_pstate_check_t * const probe_condition_checks[16];
 
-enum kprobe_insn __kprobes
-arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi);
+enum probe_insn
+arm_probe_decode_insn(probe_opcode_t insn, struct arch_specific_insn *asi);
 
-#endif /* _ARM_KERNEL_KPROBES_ARM64_H */
+#endif /* _ARM_KERNEL_PROBES_ARM64_H */
diff --git a/arch/arm64/kernel/probes-condn-check.c b/arch/arm64/kernel/probes-condn-check.c
index e68aa0c86b94..8da70b6d59a6 100644
--- a/arch/arm64/kernel/probes-condn-check.c
+++ b/arch/arm64/kernel/probes-condn-check.c
@@ -114,7 +114,7 @@ static unsigned long __kprobes __check_al(unsigned long pstate)
 	return true;
 }
 
-kprobes_pstate_check_t * const kprobe_condition_checks[16] = {
+probes_pstate_check_t * const probe_condition_checks[16] = {
 	&__check_eq, &__check_ne, &__check_cs, &__check_cc,
 	&__check_mi, &__check_pl, &__check_vs, &__check_vc,
 	&__check_hi, &__check_ls, &__check_ge, &__check_lt,
diff --git a/arch/arm64/kernel/probes-decode.h b/arch/arm64/kernel/probes-decode.h
index 3650ab356251..887ffb217e17 100644
--- a/arch/arm64/kernel/probes-decode.h
+++ b/arch/arm64/kernel/probes-decode.h
@@ -37,8 +37,8 @@ struct aarch64_decode_header {
 };
 
 struct aarch64_decode_actions {
-	kprobes_prepare_t *prepare;
-	kprobes_handler_t *handler;
+	probes_prepare_t *prepare;
+	probes_handler_t *handler;
 };
 
 struct aarch64_decode_table {
-- 
2.1.0

