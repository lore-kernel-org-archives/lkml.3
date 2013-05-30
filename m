Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935515Ab3E3QUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:20:00 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64500 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935428Ab3E3QTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:19:00 -0400
X-IronPort-AV: E=Sophos;i="4.87,772,1363132800"; 
   d="scan'208";a="28290766"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH RFC 6/6] arm64/xen: introduce CONFIG_XEN and hypercall.S on ARM64
Date: Thu, 30 May 2013 17:18:33 +0100
Message-ID: <1369930713-6063-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CONFIG_XEN and the implementation of hypercall.S (that is
the only ARMv8 specific code in Xen support for ARM).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm64/Kconfig         |   11 +++++
 arch/arm64/Makefile        |    1 +
 arch/arm64/xen/Makefile    |    1 +
 arch/arm64/xen/hypercall.S |  105 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/xen/Makefile
 create mode 100644 arch/arm64/xen/hypercall.S

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 56b3f6d..f35751f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -182,6 +182,17 @@ config HW_PERF_EVENTS
 
 source "mm/Kconfig"
 
+config XEN_DOM0
+	def_bool y
+	depends on XEN
+
+config XEN
+	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
+	depends on ARM64 && OF
+	depends on !GENERIC_ATOMIC64
+	help
+	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM64.
+
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index c95c5cb..79dd13d 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -37,6 +37,7 @@ TEXT_OFFSET := 0x00080000
 export	TEXT_OFFSET GZFLAGS
 
 core-y		+= arch/arm64/kernel/ arch/arm64/mm/
+core-$(CONFIG_XEN)		+= arch/arm64/xen/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
 
diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
new file mode 100644
index 0000000..4384103
--- /dev/null
+++ b/arch/arm64/xen/Makefile
@@ -0,0 +1 @@
+obj-y		:= enlighten.o hypercall.o grant-table.o
diff --git a/arch/arm64/xen/hypercall.S b/arch/arm64/xen/hypercall.S
new file mode 100644
index 0000000..131e4a6
--- /dev/null
+++ b/arch/arm64/xen/hypercall.S
@@ -0,0 +1,105 @@
+/******************************************************************************
+ * hypercall.S
+ *
+ * Xen hypercall wrappers
+ *
+ * Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Citrix, 2012
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+/*
+ * The Xen hypercall calling convention is very similar to the ARM AEBI
+ * procedure calling convention: the first paramter is passed in x0, the
+ * second in x1, the third in x2 and the fourth in x3. Considering that
+ * Xen hypercalls have 5 arguments at most, the fifth paramter is passed
+ * in rx, differently from the procedure calling convention of using the
+ * stack for that case.
+ *
+ * The hypercall number is passed in x16.
+ *
+ * The return value is in x0.
+ *
+ * The hvc ISS is required to be 0xEA1, that is the Xen specific ARM
+ * hypercall tag.
+ *
+ * Parameter structs passed to hypercalls are laid out according to
+ * the ARM EABI standard.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <xen/interface/xen.h>
+
+
+#define XEN_IMM 0xEA1
+
+#define HYPERCALL_SIMPLE(hypercall)		\
+ENTRY(HYPERVISOR_##hypercall)			\
+	mov x16, #__HYPERVISOR_##hypercall;	\
+	hvc XEN_IMM;						\
+	ret;								\
+ENDPROC(HYPERVISOR_##hypercall)
+
+#define HYPERCALL0 HYPERCALL_SIMPLE
+#define HYPERCALL1 HYPERCALL_SIMPLE
+#define HYPERCALL2 HYPERCALL_SIMPLE
+#define HYPERCALL3 HYPERCALL_SIMPLE
+#define HYPERCALL4 HYPERCALL_SIMPLE
+
+#define HYPERCALL5(hypercall)			\
+ENTRY(HYPERVISOR_##hypercall)			\
+	stmdb sp!, {x4}						\
+	ldr x4, [sp, #4]					\
+	mov x16, #__HYPERVISOR_##hypercall;	\
+	hvc XEN_IMM;						\
+	ldm sp!, {r4}						\
+	ret									\
+ENDPROC(HYPERVISOR_##hypercall)
+
+                .text
+
+HYPERCALL2(xen_version);
+HYPERCALL3(console_io);
+HYPERCALL3(grant_table_op);
+HYPERCALL2(sched_op);
+HYPERCALL2(event_channel_op);
+HYPERCALL2(hvm_op);
+HYPERCALL2(memory_op);
+HYPERCALL2(physdev_op);
+HYPERCALL3(vcpu_op);
+
+ENTRY(privcmd_call)
+	push x4, xzr
+	mov x16, x0
+	mov x0, x1
+	mov x1, x2
+	mov x2, x3
+	ldr x3, [sp, #8]
+	ldr x4, [sp, #4]
+	hvc XEN_IMM
+	pop x5, xzr
+	ret
+ENDPROC(privcmd_call);
-- 
1.7.2.5

