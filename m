Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbbAGHls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:41:48 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:64198 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbbAGHlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:41:45 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 02/11] ARM: kprobes: introduce early kprobes related code area.
Date: Wed, 7 Jan 2015 15:35:29 +0800
Message-ID: <1420616129-42809-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arm's vmlinux.lds, introduces code area inside text section.
Executable area used by early kprobes will be allocated from there.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/include/asm/kprobes.h | 29 +++++++++++++++++++++++++++--
 arch/arm/kernel/vmlinux.lds.S  |  2 ++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index 3ea9be5..99f16dc 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -17,16 +17,40 @@
 #define _ARM_KPROBES_H
 
 #include <linux/types.h>
-#include <linux/ptrace.h>
-#include <linux/notifier.h>
 
 #define __ARCH_WANT_KPROBES_INSN_SLOT
 #define MAX_INSN_SIZE			2
 
+#ifdef __ASSEMBLY__
+
+#define KPROBE_OPCODE_SIZE	4
+#define MAX_OPTINSN_SIZE (optprobe_template_end - optprobe_template_entry)
+
+#ifdef CONFIG_EARLY_KPROBES
+#define EARLY_KPROBES_CODES_AREA					\
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__early_kprobes_code_area_start) = .;		\
+	. = . + MAX_OPTINSN_SIZE * CONFIG_NR_EARLY_KPROBES_SLOTS;	\
+	VMLINUX_SYMBOL(__early_kprobes_code_area_end) = .;		\
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__early_kprobes_insn_slot_start) = .;		\
+	. = . + MAX_INSN_SIZE * KPROBE_OPCODE_SIZE * CONFIG_NR_EARLY_KPROBES_SLOTS;\
+	VMLINUX_SYMBOL(__early_kprobes_insn_slot_end) = .;
+
+#else
+#define EARLY_KPROBES_CODES_AREA
+#endif
+
+#else
+
+#include <linux/ptrace.h>
+#include <linux/notifier.h>
+
 #define flush_insn_slot(p)		do { } while (0)
 #define kretprobe_blacklist_size	0
 
 typedef u32 kprobe_opcode_t;
+#define KPROBE_OPCODE_SIZE	sizeof(kprobe_opcode_t)
 struct kprobe;
 #include <asm/probes.h>
 
@@ -83,4 +107,5 @@ struct arch_optimized_insn {
 	 */
 };
 
+#endif /* __ASSEMBLY__ */
 #endif /* _ARM_KPROBES_H */
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index b31aa73..12ff76d 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -11,6 +11,7 @@
 #ifdef CONFIG_ARM_KERNMEM_PERMS
 #include <asm/pgtable.h>
 #endif
+#include <asm/kprobes.h>
 	
 #define PROC_INFO							\
 	. = ALIGN(4);							\
@@ -108,6 +109,7 @@ SECTIONS
 			SCHED_TEXT
 			LOCK_TEXT
 			KPROBES_TEXT
+			EARLY_KPROBES_CODES_AREA
 			IDMAP_TEXT
 #ifdef CONFIG_MMU
 			*(.fixup)
-- 
1.8.4

