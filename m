Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab3FERCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:02:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:23077 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab3FERCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:02:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,808,1363132800"; 
   d="scan'208";a="29444477"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 5/6] arm64/xen: introduce CONFIG_XEN on ARM64
Date: Wed, 5 Jun 2013 18:02:06 +0100
Message-ID: <1370451727-26826-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306051605030.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306051605030.4589@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CONFIG_XEN on ARM64, compile arch/arm/xen under arch/arm64.
Add the ARMv8 specific hypercall wrappers to arch/arm/xen/hypercall.S.

Align few lines in hypercall.S since we are at it.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>

Changes in v2:
- remove depends on !GENERIC_ATOMIC64;
- compile enlighten.c and grant_table.c from arch/arm directly;
- fix the privcmd implementation: according to the aarch64 procedure
call ABI the first 7 parameters are passed on registers so we don't need
to push/pop anything.

Changes in v3:
- update comment to reflect the actual hypercall calling convention.

Changes in v4:
- build the entire arch/arm/xen directory under arch/arm64, ifdef
hypercall.S appropriately.
---
 arch/arm/xen/hypercall.S |   98 ++++++++++++++++++++++++++++++----------------
 arch/arm64/Kconfig       |   10 +++++
 arch/arm64/Makefile      |    1 +
 3 files changed, 75 insertions(+), 34 deletions(-)

diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
index 199cb2d..114b356 100644
--- a/arch/arm/xen/hypercall.S
+++ b/arch/arm/xen/hypercall.S
@@ -31,51 +31,93 @@
  */
 
 /*
- * The Xen hypercall calling convention is very similar to the ARM
- * procedure calling convention: the first paramter is passed in r0, the
- * second in r1, the third in r2 and the fourth in r3. Considering that
- * Xen hypercalls have 5 arguments at most, the fifth paramter is passed
- * in r4, differently from the procedure calling convention of using the
- * stack for that case.
+ * The Xen hypercall calling convention is very similar to the ARM/ARM64
+ * procedure calling convention: the first paramter is passed in r0/x0,
+ * the second in r1/x1, the third in r2/x2 and the fourth in r3/x3.
+ * Considering that Xen hypercalls have 5 arguments at most, the fifth
+ * paramter is always passed in r4/x4, differently from the ARM
+ * procedure calling convention of using the stack for that case.
  *
- * The hypercall number is passed in r12.
+ * The hypercall number is passed in r12/x16.
  *
- * The return value is in r0.
+ * The return value is in r0/x0.
  *
- * The hvc ISS is required to be 0xEA1, that is the Xen specific ARM
- * hypercall tag.
+ * The hvc ISS is required to be 0xEA1, that is the Xen specific
+ * ARM/ARM64 hypercall tag.
  */
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
-#include <asm/opcodes-virt.h>
 #include <xen/interface/xen.h>
 
 
 #define XEN_IMM 0xEA1
 
+
+#ifdef CONFIG_ARM
+
+#include <asm/opcodes-virt.h>
+
+ENTRY(privcmd_call)
+	stmdb sp!, {r4}
+	mov r12, r0
+	mov r0, r1
+	mov r1, r2
+	mov r2, r3
+	ldr r3, [sp, #8]
+	ldr r4, [sp, #4]
+	__HVC(XEN_IMM)
+	ldm sp!, {r4}
+	mov pc, lr
+ENDPROC(privcmd_call);
+
 #define HYPERCALL_SIMPLE(hypercall)		\
 ENTRY(HYPERVISOR_##hypercall)			\
 	mov r12, #__HYPERVISOR_##hypercall;	\
-	__HVC(XEN_IMM);						\
-	mov pc, lr;							\
+	__HVC(XEN_IMM);				\
+	mov pc, lr;				\
+ENDPROC(HYPERVISOR_##hypercall)
+
+#define HYPERCALL5(hypercall)			\
+ENTRY(HYPERVISOR_##hypercall)			\
+	stmdb sp!, {r4}				\
+	ldr r4, [sp, #4]			\
+	mov r12, #__HYPERVISOR_##hypercall;	\
+	__HVC(XEN_IMM);				\
+	ldm sp!, {r4}				\
+	mov pc, lr				\
 ENDPROC(HYPERVISOR_##hypercall)
 
+#else /* ARM64 specific code below */
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
+
+#define HYPERCALL_SIMPLE(hypercall)		\
+ENTRY(HYPERVISOR_##hypercall)			\
+	mov x16, #__HYPERVISOR_##hypercall;	\
+	hvc XEN_IMM;				\
+	ret;					\
+ENDPROC(HYPERVISOR_##hypercall)
+
+#define HYPERCALL5 HYPERCALL_SIMPLE
+#endif
+
+
 #define HYPERCALL0 HYPERCALL_SIMPLE
 #define HYPERCALL1 HYPERCALL_SIMPLE
 #define HYPERCALL2 HYPERCALL_SIMPLE
 #define HYPERCALL3 HYPERCALL_SIMPLE
 #define HYPERCALL4 HYPERCALL_SIMPLE
 
-#define HYPERCALL5(hypercall)			\
-ENTRY(HYPERVISOR_##hypercall)			\
-	stmdb sp!, {r4}						\
-	ldr r4, [sp, #4]					\
-	mov r12, #__HYPERVISOR_##hypercall;	\
-	__HVC(XEN_IMM);						\
-	ldm sp!, {r4}						\
-	mov pc, lr							\
-ENDPROC(HYPERVISOR_##hypercall)
 
                 .text
 
@@ -89,15 +131,3 @@ HYPERCALL2(memory_op);
 HYPERCALL2(physdev_op);
 HYPERCALL3(vcpu_op);
 
-ENTRY(privcmd_call)
-	stmdb sp!, {r4}
-	mov r12, r0
-	mov r0, r1
-	mov r1, r2
-	mov r2, r3
-	ldr r3, [sp, #8]
-	ldr r4, [sp, #4]
-	__HVC(XEN_IMM)
-	ldm sp!, {r4}
-	mov pc, lr
-ENDPROC(privcmd_call);
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
index c95c5cb..4b298aa 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -37,6 +37,7 @@ TEXT_OFFSET := 0x00080000
 export	TEXT_OFFSET GZFLAGS
 
 core-y		+= arch/arm64/kernel/ arch/arm64/mm/
+core-$(CONFIG_XEN)	+= arch/arm/xen/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
 
-- 
1.7.2.5

