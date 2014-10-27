Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaJ0ICW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:02:22 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:12237 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbaJ0ICU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:02:20 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>
Date: Mon, 27 Oct 2014 16:02:08 +0800
Subject: [RFC V3] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support rbit
  instruction
Thread-Topic: [RFC V3] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit  instruction
Thread-Index: Ac/vSNa3pqIFIz3+QkO0bxiJmBEKOgCZ3qpAAALvvtA=
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18259@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
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
 arch/arm/include/asm/bitrev.h   | 28 ++++++++++++++++++++++++++++
 arch/arm64/Kconfig              |  1 +
 arch/arm64/include/asm/bitrev.h | 28 ++++++++++++++++++++++++++++
 include/linux/bitrev.h          |  9 +++++++++
 lib/Kconfig                     |  9 +++++++++
 lib/bitrev.c                    |  2 ++
 7 files changed, 78 insertions(+)
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
index 0000000..c21a5f4
--- /dev/null
+++ b/arch/arm/include/asm/bitrev.h
@@ -0,0 +1,28 @@
+#ifndef __ASM_ARM_BITREV_H
+#define __ASM_ARM_BITREV_H
+
+static __always_inline __attribute_const__ u32 __arch_bitrev32(u32 x)
+{
+	if (__builtin_constant_p(x)) {
+		x = (x >> 16) | (x << 16);
+		x = ((x & 0xFF00FF00) >> 8) | ((x & 0x00FF00FF) << 8);
+		x = ((x & 0xF0F0F0F0) >> 4) | ((x & 0x0F0F0F0F) << 4);
+		x = ((x & 0xCCCCCCCC) >> 2) | ((x & 0x33333333) << 2);
+		return ((x & 0xAAAAAAAA) >> 1) | ((x & 0x55555555) << 1);
+	}
+	__asm__ ("rbit %0, %1" : "=r" (x) : "r" (x));
+	return x;
+}
+
+static __always_inline __attribute_const__ u16 __arch_bitrev16(u16 x)
+{
+	return __arch_bitrev32((u32)x) >> 16;
+}
+
+static __always_inline __attribute_const__ u8 __arch_bitrev8(u8 x)
+{
+	return __arch_bitrev32((u32)x) >> 24;
+}
+
+#endif
+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9532f8d..263c28c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -36,6 +36,7 @@ config ARM64
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_ARCH_BITREVERSE
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
diff --git a/arch/arm64/include/asm/bitrev.h b/arch/arm64/include/asm/bitrev.h
new file mode 100644
index 0000000..f725a71
--- /dev/null
+++ b/arch/arm64/include/asm/bitrev.h
@@ -0,0 +1,28 @@
+#ifndef __ASM_ARM_BITREV_H
+#define __ASM_ARM_BITREV_H
+
+static __always_inline __attribute_const__ u32 __arch_bitrev32(u32 x)
+{
+	if (__builtin_constant_p(x)) {
+		x = (x >> 16) | (x << 16);
+		x = ((x & 0xFF00FF00) >> 8) | ((x & 0x00FF00FF) << 8);
+		x = ((x & 0xF0F0F0F0) >> 4) | ((x & 0x0F0F0F0F) << 4);
+		x = ((x & 0xCCCCCCCC) >> 2) | ((x & 0x33333333) << 2);
+		return ((x & 0xAAAAAAAA) >> 1) | ((x & 0x55555555) << 1);
+	}
+	__asm__ ("rbit %w0, %w1" : "=r" (x) : "r" (x));
+	return x;
+}
+
+static __always_inline __attribute_const__ u16 __arch_bitrev16(u16 x)
+{
+	return __arch_bitrev32((u32)x) >> 16;
+}
+
+static __always_inline __attribute_const__ u8 __arch_bitrev8(u8 x)
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
index 54cf309..cd177ca 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -13,6 +13,15 @@ config RAID6_PQ
 config BITREVERSE
 	tristate
 
+config HAVE_ARCH_BITREVERSE
+	boolean
+	default n
+	depends on BITREVERSE
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
