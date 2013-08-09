Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031563Ab3HIXEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:04:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:29511 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031547Ab3HIXE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="384045638"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/13] x86: Add 32bit versions of SAVE_ALL/RESTORE_ALL to calling.h
Date: Fri,  9 Aug 2013 16:04:13 -0700
Message-Id: <1376089460-5459-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add 32bit versions of SAVE/RESTORE_ALL to calling.h. Needed for
the following patches. These are much simplified over both 64bit
and the 32bit entry* version, just saving and restoring all registers
without anything fancy.

These are different from the entry_32.S versions in not changing
the segment registers or cld. So only suitable for in kernel use, not when
transitioning from or to user space. The resulting stack frame is not
a standard pt_regs frame. The main use case is calling C code from
assembler when all the registers need to be preserved.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/calling.h | 49 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index 0fa6750..3365cea 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -48,6 +48,8 @@ For 32-bit we have the following conventions - kernel is built with
 
 #include <asm/dwarf2.h>
 
+#ifdef CONFIG_X86_64
+
 /*
  * 64-bit system call stack frame layout defines and helpers,
  * for assembly code:
@@ -192,3 +194,50 @@ For 32-bit we have the following conventions - kernel is built with
 	.macro icebp
 	.byte 0xf1
 	.endm
+
+#else
+
+/*
+ * For 32bit only simplified versions of SAVE_ALL/RESTORE_ALL. These
+ * are different from the entry_32.S versions in not changing the segment
+ * registers. So only suitable for in kernel use, not when transitioning
+ * from or to user space. The resulting stack frame is not a standard
+ * pt_regs frame. The main use case is calling C code from assembler
+ * when all the registers need to be preserved.
+ */
+
+	.macro SAVE_ALL
+	pushl_cfi %eax
+	CFI_REL_OFFSET eax, 0
+	pushl_cfi %ebp
+	CFI_REL_OFFSET ebp, 0
+	pushl_cfi %edi
+	CFI_REL_OFFSET edi, 0
+	pushl_cfi %esi
+	CFI_REL_OFFSET esi, 0
+	pushl_cfi %edx
+	CFI_REL_OFFSET edx, 0
+	pushl_cfi %ecx
+	CFI_REL_OFFSET ecx, 0
+	pushl_cfi %ebx
+	CFI_REL_OFFSET ebx, 0
+	.endm
+
+	.macro RESTORE_ALL
+	popl_cfi %ebx
+	CFI_RESTORE ebx
+	popl_cfi %ecx
+	CFI_RESTORE ecx
+	popl_cfi %edx
+	CFI_RESTORE edx
+	popl_cfi %esi
+	CFI_RESTORE esi
+	popl_cfi %edi
+	CFI_RESTORE edi
+	popl_cfi %ebp
+	CFI_RESTORE ebp
+	popl_cfi %eax
+	CFI_RESTORE eax
+	.endm
+
+#endif
-- 
1.8.3.1

