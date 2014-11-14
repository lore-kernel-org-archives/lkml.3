Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072AbaKNPyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:54:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63795 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965683AbaKNPyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:54:41 -0500
From: Andre Przywara <andre.przywara@arm.com>
To: will.deacon@arm.com, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] arm64: add Cortex-A57 erratum 832075 workaround
Date: Fri, 14 Nov 2014 15:54:11 +0000
Message-Id: <1415980452-20366-6-git-send-email-andre.przywara@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
References: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM erratum 832075 applies to certain revisions of Cortex-A57,
one of the workarounds is to change device loads into using
load-aquire semantics.
This is achieved using the alternatives framework.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |    5 +++--
 arch/arm64/include/asm/io.h         |   23 +++++++++++++++++++----
 arch/arm64/kernel/cpu_errata.c      |    7 +++++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 92b6ee4..0362f80 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -21,9 +21,10 @@
 #define MAX_CPU_FEATURES	(8 * sizeof(elf_hwcap))
 #define cpu_feature(x)		ilog2(HWCAP_ ## x)
 
-#define ARM64_WORKAROUND_CLEAN_CACHE	0
+#define ARM64_WORKAROUND_CLEAN_CACHE		0
+#define ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE	1
 
-#define NCAPS				1
+#define NCAPS					2
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 79f1d519..75825b6 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -28,6 +28,8 @@
 #include <asm/barrier.h>
 #include <asm/pgtable.h>
 #include <asm/early_ioremap.h>
+#include <asm/alternative.h>
+#include <asm/cpufeature.h>
 
 #include <xen/xen.h>
 
@@ -57,28 +59,41 @@ static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
 static inline u8 __raw_readb(const volatile void __iomem *addr)
 {
 	u8 val;
-	asm volatile("ldrb %w0, [%1]" : "=r" (val) : "r" (addr));
+	asm volatile(ALTERNATIVE("ldrb %w0, [%1]",
+				 "ldarb %w0, [%1]",
+				 ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE)
+		     : "=r" (val) : "r" (addr));
 	return val;
 }
 
 static inline u16 __raw_readw(const volatile void __iomem *addr)
 {
 	u16 val;
-	asm volatile("ldrh %w0, [%1]" : "=r" (val) : "r" (addr));
+
+	asm volatile(ALTERNATIVE("ldrh %w0, [%1]",
+				 "ldarh %w0, [%1]",
+				 ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE)
+		     : "=r" (val) : "r" (addr));
 	return val;
 }
 
 static inline u32 __raw_readl(const volatile void __iomem *addr)
 {
 	u32 val;
-	asm volatile("ldr %w0, [%1]" : "=r" (val) : "r" (addr));
+	asm volatile(ALTERNATIVE("ldr %w0, [%1]",
+				 "ldar %w0, [%1]",
+				 ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE)
+		     : "=r" (val) : "r" (addr));
 	return val;
 }
 
 static inline u64 __raw_readq(const volatile void __iomem *addr)
 {
 	u64 val;
-	asm volatile("ldr %0, [%1]" : "=r" (val) : "r" (addr));
+	asm volatile(ALTERNATIVE("ldr %0, [%1]",
+				 "ldar %0, [%1]",
+				 ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE)
+		     : "=r" (val) : "r" (addr));
 	return val;
 }
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 875fb2c..f232849 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -24,6 +24,7 @@
 #include <asm/cpufeature.h>
 
 #define MIDR_CORTEX_A53 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
+#define MIDR_CORTEX_A57 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 
 /*
  * Add a struct or another datatype to the union below if you need
@@ -70,6 +71,12 @@ struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x02),
 	},
 	{
+	/* Cortex-A57 r0p0 - r1p2 */
+		.desc = "ARM erratum 832075",
+		.capability = ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE,
+		MIDR_RANGE(MIDR_CORTEX_A57, 0x00, 0x12),
+	},
+	{
 	}
 };
 
-- 
1.7.9.5

