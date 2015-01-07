Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbbAGHmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:42:08 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:46338 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbbAGHlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:41:47 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 04/11] x86: kprobes: introduce early kprobes related code area.
Date: Wed, 7 Jan 2015 15:35:37 +0800
Message-ID: <1420616137-42898-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54ACE308.010F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: e6acf5f53586b36d7d0b09698632da94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces EARLY_KPROBES_CODES_AREA in x86 vmlinux for early
kprobes.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/x86/include/asm/insn.h    |  7 ++++---
 arch/x86/include/asm/kprobes.h | 45 ++++++++++++++++++++++++++++++++++--------
 arch/x86/kernel/vmlinux.lds.S  |  2 ++
 3 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 47f29b1..ea6f318 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -20,6 +20,9 @@
  * Copyright (C) IBM Corporation, 2009
  */
 
+#define MAX_INSN_SIZE	16
+
+#ifndef __ASSEMBLY__
 /* insn_attr_t is defined in inat.h */
 #include <asm/inat.h>
 
@@ -69,8 +72,6 @@ struct insn {
 	const insn_byte_t *next_byte;
 };
 
-#define MAX_INSN_SIZE	16
-
 #define X86_MODRM_MOD(modrm) (((modrm) & 0xc0) >> 6)
 #define X86_MODRM_REG(modrm) (((modrm) & 0x38) >> 3)
 #define X86_MODRM_RM(modrm) ((modrm) & 0x07)
@@ -197,5 +198,5 @@ static inline int insn_offset_immediate(struct insn *insn)
 {
 	return insn_offset_displacement(insn) + insn->displacement.nbytes;
 }
-
+#endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_INSN_H */
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 4421b5d..017f4bb 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -21,23 +21,52 @@
  *
  * See arch/x86/kernel/kprobes.c for x86 kprobes history.
  */
-#include <linux/types.h>
-#include <linux/ptrace.h>
-#include <linux/percpu.h>
-#include <asm/insn.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
 
-struct pt_regs;
-struct kprobe;
+#include <linux/types.h>
+#include <asm/insn.h>
 
-typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
 #define RELATIVEJUMP_OPCODE 0xe9
 #define RELATIVEJUMP_SIZE 5
 #define RELATIVECALL_OPCODE 0xe8
 #define RELATIVE_ADDR_SIZE 4
 #define MAX_STACK_SIZE 64
+#define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
+
+#ifdef __ASSEMBLY__
+
+#define KPROBE_OPCODE_SIZE     1
+#define MAX_OPTINSN_SIZE ((optprobe_template_end - optprobe_template_entry) + \
+	MAX_OPTIMIZED_LENGTH + RELATIVEJUMP_SIZE)
+
+#ifdef CONFIG_EARLY_KPROBES
+# define EARLY_KPROBES_CODES_AREA					\
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__early_kprobes_code_area_start) = .;		\
+	. = . + MAX_OPTINSN_SIZE * CONFIG_NR_EARLY_KPROBES_SLOTS;	\
+	VMLINUX_SYMBOL(__early_kprobes_code_area_end) = .;		\
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__early_kprobes_insn_slot_start) = .;		\
+	. = . + MAX_INSN_SIZE * KPROBE_OPCODE_SIZE *			\
+		CONFIG_NR_EARLY_KPROBES_SLOTS;				\
+	VMLINUX_SYMBOL(__early_kprobes_insn_slot_end) = .;
+#else
+# define EARLY_KPROBES_CODES_AREA
+#endif
+
+#else
+
+#include <linux/ptrace.h>
+#include <linux/percpu.h>
+
+
+struct pt_regs;
+struct kprobe;
+
+typedef u8 kprobe_opcode_t;
+#define KPROBE_OPCODE_SIZE     sizeof(kprobe_opcode_t)
 #define MIN_STACK_SIZE(ADDR)					       \
 	(((MAX_STACK_SIZE) < (((unsigned long)current_thread_info()) + \
 			      THREAD_SIZE - (unsigned long)(ADDR)))    \
@@ -52,7 +81,6 @@ extern __visible kprobe_opcode_t optprobe_template_entry;
 extern __visible kprobe_opcode_t optprobe_template_val;
 extern __visible kprobe_opcode_t optprobe_template_call;
 extern __visible kprobe_opcode_t optprobe_template_end;
-#define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
 #define MAX_OPTINSN_SIZE 				\
 	(((unsigned long)&optprobe_template_end -	\
 	  (unsigned long)&optprobe_template_entry) +	\
@@ -117,4 +145,5 @@ extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
 extern int kprobe_int3_handler(struct pt_regs *regs);
 extern int kprobe_debug_handler(struct pt_regs *regs);
+#endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_KPROBES_H */
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 00bf300..69f3f0e 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -26,6 +26,7 @@
 #include <asm/page_types.h>
 #include <asm/cache.h>
 #include <asm/boot.h>
+#include <asm/kprobes.h>
 
 #undef i386     /* in case the preprocessor is a 32bit one */
 
@@ -100,6 +101,7 @@ SECTIONS
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		EARLY_KPROBES_CODES_AREA
 		ENTRY_TEXT
 		IRQENTRY_TEXT
 		*(.fixup)
-- 
1.8.4

