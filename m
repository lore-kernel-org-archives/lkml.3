Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab3FCPeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:34:01 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:56479 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab3FCPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:33:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,793,1363132800"; 
   d="scan'208";a="27531010"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 5/5] arm64/xen: introduce CONFIG_XEN and hypercall.S on ARM64
Date: Mon, 3 Jun 2013 16:33:44 +0100
Message-ID: <1370273624-26976-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CONFIG_XEN and the implementation of hypercall.S (that is
the only ARMv8 specific code in Xen support for ARM).

Compile enlighten.c and grant_table.c from arch/arm.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Changes in v2:
- remove depends on !GENERIC_ATOMIC64;
- compile enlighten.c and grant_table.c from arch/arm directly;
- fix the privcmd implementation: according to the aarch64 procedure
call ABI the first 7 parameters are passed on registers so we don't need
to push/pop anything.
---
 arch/arm64/Kconfig         |   10 +++++
 arch/arm64/Makefile        |    1 +
 arch/arm64/xen/Makefile    |    2 +
 arch/arm64/xen/hypercall.S |   94 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/xen/Makefile
 create mode 100644 arch/arm64/xen/hypercall.S

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 56b3f6d..b5d6ada 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -182,6 +182,16 @@ config HW_PERF_EVENTS
 
 source "mm/Kconfig"
 
+config XEN_DOM0
+	def_bool y
+	depends on XEN
+
+config XEN
+	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
+	depends on ARM64 && OF
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
index 0000000..be24040
--- /dev/null
+++ b/arch/arm64/xen/Makefile
@@ -0,0 +1,2 @@
+xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o)
+obj-y		:= xen-arm.o hypercall.o
diff --git a/arch/arm64/xen/hypercall.S b/arch/arm64/xen/hypercall.S
new file mode 100644
index 0000000..8e362cc
--- /dev/null
+++ b/arch/arm64/xen/hypercall.S
@@ -0,0 +1,94 @@
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
+#define HYPERCALL5 HYPERCALL_SIMPLE
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
+	mov x16, x0
+	mov x0, x1
+	mov x1, x2
+	mov x2, x3
+	mov x3, x4
+	mov x4, x5
+	hvc XEN_IMM
+	ret
+ENDPROC(privcmd_call);
-- 
1.7.2.5

