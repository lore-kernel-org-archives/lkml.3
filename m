Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423275Ab3CWBcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:32:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:44419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422827Ab3CWBZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338470"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/29] x86, tsx: Add RTM intrinsics
Date: Fri, 22 Mar 2013 18:24:56 -0700
Message-Id: <1364001923-10796-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This adds the basic RTM (Restricted Transactional Memory)
intrinsics for TSX, implemented with alternative() so that they can be
transparently used without checking CPUID first.

When the CPU does not support TSX we just always jump to the abort handler.

These intrinsics are only expected to be used by some low level code
that presents higher level interface (like locks).

This is using the same interface as gcc and icc. There's a way to implement
the intrinsics more efficiently with newer compilers that support asm goto,
but to avoid undue dependencies on new tool chains this is not used here.

Also the current way looks slightly nicer, at the cost of only two more
instructions.

Also don't require a TSX aware assembler -- all new instructions are implemented
with .byte.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/rtm.h |   82 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/rtm.h

diff --git a/arch/x86/include/asm/rtm.h b/arch/x86/include/asm/rtm.h
new file mode 100644
index 0000000..7075a04
--- /dev/null
+++ b/arch/x86/include/asm/rtm.h
@@ -0,0 +1,82 @@
+#ifndef _RTM_OFFICIAL_H
+#define _RTM_OFFICIAL_H 1
+
+#include <linux/compiler.h>
+#include <asm/alternative.h>
+#include <asm/cpufeature.h>
+#include <asm/nops.h>
+
+/*
+ * RTM -- restricted transactional memory ISA
+ *
+ * Official RTM intrinsics interface matching gcc/icc, but works
+ * on older gcc compatible compilers and binutils.
+ *
+ * _xbegin() starts a transaction. When it returns a value different
+ * from _XBEGIN_STARTED a non transactional fallback path
+ * should be executed.
+ *
+ * This is a special kernel variant that supports binary patching.
+ * When the CPU does not support RTM we always jump to the abort handler.
+ * And _xtest() always returns 0.
+
+ * This means these intrinsics can be used without checking cpu_has_rtm
+ * first.
+ *
+ * This is the low level interface mapping directly to the instructions.
+ * Usually kernel code will use a higher level abstraction instead (like locks)
+ *
+ * Note this can be implemented more efficiently on compilers that support
+ * "asm goto". But we don't want to require this right now.
+ */
+
+#define _XBEGIN_STARTED		(~0u)
+#define _XABORT_EXPLICIT	(1 << 0)
+#define _XABORT_RETRY		(1 << 1)
+#define _XABORT_CONFLICT	(1 << 2)
+#define _XABORT_CAPACITY	(1 << 3)
+#define _XABORT_DEBUG		(1 << 4)
+#define _XABORT_NESTED		(1 << 5)
+#define _XABORT_CODE(x)		(((x) >> 24) & 0xff)
+
+#define _XABORT_SOFTWARE	-5	/* not part of ISA */
+
+static __always_inline int _xbegin(void)
+{
+	int ret;
+	alternative_io("mov %[fallback],%[ret] ; " ASM_NOP6,
+		       "mov %[started],%[ret] ; "
+		       ".byte 0xc7,0xf8 ; .long 0 # XBEGIN 0",
+		       X86_FEATURE_RTM,
+		       [ret] "=a" (ret),
+		       [fallback] "i" (_XABORT_SOFTWARE),
+		       [started] "i" (_XBEGIN_STARTED) : "memory");
+	return ret;
+}
+
+static __always_inline void _xend(void)
+{
+	/* Not patched because these should be not executed in fallback */
+	asm volatile(".byte 0x0f,0x01,0xd5 # XEND" : : : "memory");
+}
+
+static __always_inline void _xabort(const unsigned int status)
+{
+	alternative_input(ASM_NOP3,
+			  ".byte 0xc6,0xf8,%P0 # XABORT",
+			  X86_FEATURE_RTM,
+			  "i" (status) : "memory");
+}
+
+static __always_inline int _xtest(void)
+{
+	unsigned char out;
+	alternative_io("xor %0,%0 ; " ASM_NOP5,
+		       ".byte 0x0f,0x01,0xd6 ; setnz %0 # XTEST",
+		       X86_FEATURE_RTM,
+		       "=r" (out),
+		       "i" (0) : "memory");
+	return out;
+}
+
+#endif
-- 
1.7.7.6

