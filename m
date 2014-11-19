Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbaKSVXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:23:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933870AbaKSVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Martin <Dave.Martin@arm.com>, Wang Nan <wangnan0@huawei.com>
Subject: [PATCH 3.10 55/70] ARM: Correct BUG() assembly to ensure it is endian-agnostic
Date: Wed, 19 Nov 2014 12:52:46 -0800
Message-Id: <20141119205212.741833560@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

commit 63328070eff2f4fd730c86966a0dbc976147c39f upstream.

Currently BUG() uses .word or .hword to create the necessary illegal
instructions. However if we are building BE8 then these get swapped
by the linker into different illegal instructions in the text. This
means that the BUG() macro does not get trapped properly.

Change to using <asm/opcodes.h> to provide the necessary ARM instruction
building as we cannot rely on gcc/gas having the `.inst` instructions
which where added to try and resolve this issue (reported by Dave Martin
<Dave.Martin@arm.com>).

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/bug.h |   10 ++++++----
 arch/arm/kernel/traps.c    |    8 +++++---
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/arch/arm/include/asm/bug.h
+++ b/arch/arm/include/asm/bug.h
@@ -2,6 +2,8 @@
 #define _ASMARM_BUG_H
 
 #include <linux/linkage.h>
+#include <linux/types.h>
+#include <asm/opcodes.h>
 
 #ifdef CONFIG_BUG
 
@@ -12,10 +14,10 @@
  */
 #ifdef CONFIG_THUMB2_KERNEL
 #define BUG_INSTR_VALUE 0xde02
-#define BUG_INSTR_TYPE ".hword "
+#define BUG_INSTR(__value) __inst_thumb16(__value)
 #else
 #define BUG_INSTR_VALUE 0xe7f001f2
-#define BUG_INSTR_TYPE ".word "
+#define BUG_INSTR(__value) __inst_arm(__value)
 #endif
 
 
@@ -33,7 +35,7 @@
 
 #define __BUG(__file, __line, __value)				\
 do {								\
-	asm volatile("1:\t" BUG_INSTR_TYPE #__value "\n"	\
+	asm volatile("1:\t" BUG_INSTR(__value) "\n"  \
 		".pushsection .rodata.str, \"aMS\", %progbits, 1\n" \
 		"2:\t.asciz " #__file "\n" 			\
 		".popsection\n" 				\
@@ -48,7 +50,7 @@ do {								\
 
 #define __BUG(__file, __line, __value)				\
 do {								\
-	asm volatile(BUG_INSTR_TYPE #__value);			\
+	asm volatile(BUG_INSTR(__value) "\n");			\
 	unreachable();						\
 } while (0)
 #endif  /* CONFIG_DEBUG_BUGVERBOSE */
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -347,15 +347,17 @@ void arm_notify_die(const char *str, str
 int is_valid_bugaddr(unsigned long pc)
 {
 #ifdef CONFIG_THUMB2_KERNEL
-	unsigned short bkpt;
+	u16 bkpt;
+	u16 insn = __opcode_to_mem_thumb16(BUG_INSTR_VALUE);
 #else
-	unsigned long bkpt;
+	u32 bkpt;
+	u32 insn = __opcode_to_mem_arm(BUG_INSTR_VALUE);
 #endif
 
 	if (probe_kernel_address((unsigned *)pc, bkpt))
 		return 0;
 
-	return bkpt == BUG_INSTR_VALUE;
+	return bkpt == insn;
 }
 
 #endif


