Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaKJXzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:55:46 -0500
Received: from mga14.intel.com ([192.55.52.115]:18761 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaKJXzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:55:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414540344"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/8] x86: Add intrinsics/macros for new rd/wr fs/gs base instructions
Date: Mon, 10 Nov 2014 15:55:34 -0800
Message-Id: <1415663739-25525-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415663739-25525-1-git-send-email-andi@firstfloor.org>
References: <1415663739-25525-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add C intrinsics and assembler macros for the new rd/wr fs/gs base
instructions and for swapgs.

Very straight forward. Used in followon patch.

For assembler only a few standard registers used by entry_64.S
are defined.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/fsgs.h | 54 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 arch/x86/include/asm/fsgs.h

diff --git a/arch/x86/include/asm/fsgs.h b/arch/x86/include/asm/fsgs.h
new file mode 100644
index 0000000..1df5085
--- /dev/null
+++ b/arch/x86/include/asm/fsgs.h
@@ -0,0 +1,54 @@
+#ifndef _ASM_FSGS_H
+#define _ASM_FSGS_H 1
+
+#ifndef __ASSEMBLY__
+
+static inline void swapgs(void)
+{
+	asm volatile("swapgs" ::: "memory");
+}
+
+/* Must be protected by X86_FEATURE_FSGSBASE check. */
+
+static inline unsigned long rdgsbase(void)
+{
+	unsigned long gs;
+	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xc8 # rdgsbaseq %%rax"
+			: "=a" (gs)
+			:: "memory");
+	return gs;
+}
+
+static inline unsigned long rdfsbase(void)
+{
+	unsigned long fs;
+	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xc0 # rdfsbaseq %%rax"
+			: "=a" (fs)
+			:: "memory");
+	return fs;
+}
+
+static inline void wrgsbase(unsigned long gs)
+{
+	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xd8 # wrgsbaseq %%rax"
+			:: "a" (gs)
+			: "memory");
+}
+
+static inline void wrfsbase(unsigned long fs)
+{
+	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xd0 # wrfsbaseq %%rax"
+			:: "a" (fs)
+			: "memory");
+}
+
+#else
+
+/* Handle old assemblers. */
+#define RDGSBASE_R15 .byte 0xf3,0x49,0x0f,0xae,0xcf
+#define WRGSBASE_RDI .byte 0xf3,0x48,0x0f,0xae,0xdf
+#define WRGSBASE_R15 .byte 0xf3,0x49,0x0f,0xae,0xdf
+
+#endif /* __ASSEMBLY__ */
+
+#endif
-- 
1.9.3

