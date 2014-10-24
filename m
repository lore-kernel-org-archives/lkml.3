Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaJXFKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:10:40 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:11602 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbaJXFKi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:10:38 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>
Date: Fri, 24 Oct 2014 13:10:33 +0800
Subject: [PATCH RFC] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit
Thread-Topic: [PATCH RFC] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to
 support rbit
Thread-Index: Ac/vSNa3pqIFIz3+QkO0bxiJmBEKOg==
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this change add CONFIG_HAVE_ARCH_BITREVERSE config option,
so that we can use arm/arm64 rbit instruction to do bitrev operation
by hardware.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 arch/arm/Kconfig                |  1 +
 arch/arm/include/asm/bitrev.h   | 21 +++++++++++++++++++++
 arch/arm64/Kconfig              |  1 +
 arch/arm64/include/asm/bitrev.h | 21 +++++++++++++++++++++
 include/linux/bitrev.h          |  9 +++++++++
 lib/Kconfig                     |  8 ++++++++
 lib/bitrev.c                    |  2 ++
 7 files changed, 63 insertions(+)
 create mode 100644 arch/arm/include/asm/bitrev.h
 create mode 100644 arch/arm64/include/asm/bitrev.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89c4b5c..426cbcc 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -16,6 +16,7 @@ config ARM
 	select DCACHE_WORD_ACCESS if HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select GENERIC_ALLOCATOR
 	select GENERIC_ATOMIC64 if (CPU_V7M || CPU_V6 || !CPU_32v6K || !AEABI)
+	select HAVE_ARCH_BITREVERSE if (CPU_V7M || CPU_V7)
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_IRQ_PROBE
diff --git a/arch/arm/include/asm/bitrev.h b/arch/arm/include/asm/bitrev.h
new file mode 100644
index 0000000..0df5866
--- /dev/null
+++ b/arch/arm/include/asm/bitrev.h
@@ -0,0 +1,21 @@
+#ifndef __ASM_ARM_BITREV_H
+#define __ASM_ARM_BITREV_H
+
+static inline __attribute_const__ u32 __arch_bitrev32(u32 x)
+{
+	__asm__ ("rbit %0, %1" : "=r" (x) : "r" (x));
+	return x;
+}
+
+static inline __attribute_const__ u16 __arch_bitrev16(u16 x)
+{
+	return __arch_bitrev32((u32)x) >> 16;
+}
+
+static inline __attribute_const__ u8 __arch_bitrev8(u8 x)
+{
+	return __arch_bitrev32((u32)x) >> 24;
+}
+
+#endif
+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ac9afde..a2566d7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -35,6 +35,7 @@ config ARM64
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_ARCH_BITREVERSE
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
diff --git a/arch/arm64/include/asm/bitrev.h b/arch/arm64/include/asm/bitrev.h
new file mode 100644
index 0000000..5d24c11
--- /dev/null
+++ b/arch/arm64/include/asm/bitrev.h
@@ -0,0 +1,21 @@
+#ifndef __ASM_ARM_BITREV_H
+#define __ASM_ARM_BITREV_H
+
+static inline __attribute_const__ u32 __arch_bitrev32(u32 x)
+{
+	__asm__ ("rbit %w0, %w1" : "=r" (x) : "r" (x));
+	return x;
+}
+
+static inline __attribute_const__ u16 __arch_bitrev16(u16 x)
+{
+	return __arch_bitrev32((u32)x) >> 16;
+}
+
+static inline __attribute_const__ u8 __arch_bitrev8(u8 x)
+{
+	return __arch_bitrev32((u32)x) >> 24;
+}
+
+#endif
+
diff --git a/include/linux/bitrev.h b/include/linux/bitrev.h
index 7ffe03f..ef5b2bb 100644
--- a/include/linux/bitrev.h
+++ b/include/linux/bitrev.h
@@ -3,6 +3,14 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_HAVE_ARCH_BITREVERSE
+#include <asm/bitrev.h>
+
+#define bitrev32 __arch_bitrev32
+#define bitrev16 __arch_bitrev16
+#define bitrev8 __arch_bitrev8
+
+#else
 extern u8 const byte_rev_table[256];
 
 static inline u8 bitrev8(u8 byte)
@@ -13,4 +21,5 @@ static inline u8 bitrev8(u8 byte)
 extern u16 bitrev16(u16 in);
 extern u32 bitrev32(u32 in);
 
+#endif /* CONFIG_HAVE_ARCH_BITREVERSE */
 #endif /* _LINUX_BITREV_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 54cf309..e0e0453 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -13,6 +13,14 @@ config RAID6_PQ
 config BITREVERSE
 	tristate
 
+config HAVE_ARCH_BITREVERSE
+	boolean
+	default n
+	help
+	  This option provides an config for the architecture which have instruction
+	  can do bitreverse operation, we use the hardware instruction if the architecture
+	  have this capability.
+
 config RATIONAL
 	boolean
 
diff --git a/lib/bitrev.c b/lib/bitrev.c
index 3956203..93d637a 100644
--- a/lib/bitrev.c
+++ b/lib/bitrev.c
@@ -1,3 +1,4 @@
+#ifndef CONFIG_HAVE_ARCH_BITREVERSE
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/bitrev.h>
@@ -57,3 +58,4 @@ u32 bitrev32(u32 x)
 	return (bitrev16(x & 0xffff) << 16) | bitrev16(x >> 16);
 }
 EXPORT_SYMBOL(bitrev32);
+#endif /* CONFIG_HAVE_ARCH_BITREVERSE */
-- 
2.1.1

