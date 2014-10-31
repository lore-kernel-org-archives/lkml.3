Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbaJaFkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 01:40:25 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:5733 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbaJaFkY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 01:40:24 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 31 Oct 2014 13:40:20 +0800
Subject: [RFC V6 1/3] add CONFIG_HAVE_ARCH_BITREVERSE to support rbit
 instruction
Thread-Topic: [RFC V6 1/3] add CONFIG_HAVE_ARCH_BITREVERSE to support rbit
 instruction
Thread-Index: Ac/0SYsLYyTdMNPAS1SmHcF7f8oZ+gAcg3/Q
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
References: <1414392371.8884.2.camel@perches.com>
 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
 <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
 <20141030135749.GE32589@arm.com>
In-Reply-To: <20141030135749.GE32589@arm.com>
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
so that we can use some architecture's bitrev hardware instruction
to do bitrev operation.

Introduce __constant_bitrev* macro for constant bitrev operation.

Change __bitrev16() __bitrev32() to be inline function,
don't need export symbol for these tiny functions.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 include/linux/bitrev.h | 77 +++++++++++++++++++++++++++++++++++++++++++++++---
 lib/Kconfig            |  9 ++++++
 lib/bitrev.c           | 17 ++---------
 3 files changed, 84 insertions(+), 19 deletions(-)

diff --git a/include/linux/bitrev.h b/include/linux/bitrev.h
index 7ffe03f..fb790b8 100644
--- a/include/linux/bitrev.h
+++ b/include/linux/bitrev.h
@@ -3,14 +3,83 @@
 
 #include <linux/types.h>
 
-extern u8 const byte_rev_table[256];
+#ifdef CONFIG_HAVE_ARCH_BITREVERSE
+#include <asm/bitrev.h>
+
+#define __bitrev32 __arch_bitrev32
+#define __bitrev16 __arch_bitrev16
+#define __bitrev8 __arch_bitrev8
 
-static inline u8 bitrev8(u8 byte)
+#else
+extern u8 const byte_rev_table[256];
+static inline u8 __bitrev8(u8 byte)
 {
 	return byte_rev_table[byte];
 }
 
-extern u16 bitrev16(u16 in);
-extern u32 bitrev32(u32 in);
+static inline u16 __bitrev16(u16 x)
+{
+	return (__bitrev8(x & 0xff) << 8) | __bitrev8(x >> 8);
+}
+
+static inline u32 __bitrev32(u32 x)
+{
+	return (__bitrev16(x & 0xffff) << 16) | __bitrev16(x >> 16);
+}
+
+#endif /* CONFIG_HAVE_ARCH_BITREVERSE */
+
+#define __constant_bitrev32(x)	\
+({					\
+	u32 __x = x;			\
+	__x = (__x >> 16) | (__x << 16);	\
+	__x = ((__x & (u32)0xFF00FF00UL) >> 8) | ((__x & (u32)0x00FF00FFUL) << 8);	\
+	__x = ((__x & (u32)0xF0F0F0F0UL) >> 4) | ((__x & (u32)0x0F0F0F0FUL) << 4);	\
+	__x = ((__x & (u32)0xCCCCCCCCUL) >> 2) | ((__x & (u32)0x33333333UL) << 2);	\
+	__x = ((__x & (u32)0xAAAAAAAAUL) >> 1) | ((__x & (u32)0x55555555UL) << 1);	\
+	__x;								\
+})
+
+#define __constant_bitrev16(x)	\
+({					\
+	u16 __x = x;			\
+	__x = (__x >> 8) | (__x << 8);	\
+	__x = ((__x & (u16)0xF0F0U) >> 4) | ((__x & (u16)0x0F0FU) << 4);	\
+	__x = ((__x & (u16)0xCCCCU) >> 2) | ((__x & (u16)0x3333U) << 2);	\
+	__x = ((__x & (u16)0xAAAAU) >> 1) | ((__x & (u16)0x5555U) << 1);	\
+	__x;								\
+})
+
+#define __constant_bitrev8(x)	\
+({					\
+	u8 __x = x;			\
+	__x = (__x >> 4) | (__x << 4);	\
+	__x = ((__x & (u8)0xCCU) >> 2) | ((__x & (u8)0x33U) << 2);	\
+	__x = ((__x & (u8)0xAAU) >> 1) | ((__x & (u8)0x55U) << 1);	\
+	__x;								\
+})
+
+#define bitrev32(x) \
+({			\
+	u32 __x = x;	\
+	__builtin_constant_p(__x) ?	\
+	__constant_bitrev32(__x) :			\
+	__bitrev32(__x);				\
+})
+
+#define bitrev16(x) \
+({			\
+	u16 __x = x;	\
+	__builtin_constant_p(__x) ?	\
+	__constant_bitrev16(__x) :			\
+	__bitrev16(__x);				\
+ })
 
+#define bitrev8(x) \
+({			\
+	u8 __x = x;	\
+	__builtin_constant_p(__x) ?	\
+	__constant_bitrev8(__x) :			\
+	__bitrev8(__x)	;			\
+ })
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
index 3956203..40ffda9 100644
--- a/lib/bitrev.c
+++ b/lib/bitrev.c
@@ -1,3 +1,4 @@
+#ifndef CONFIG_HAVE_ARCH_BITREVERSE
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/bitrev.h>
@@ -42,18 +43,4 @@ const u8 byte_rev_table[256] = {
 };
 EXPORT_SYMBOL_GPL(byte_rev_table);
 
-u16 bitrev16(u16 x)
-{
-	return (bitrev8(x & 0xff) << 8) | bitrev8(x >> 8);
-}
-EXPORT_SYMBOL(bitrev16);
-
-/**
- * bitrev32 - reverse the order of bits in a u32 value
- * @x: value to be bit-reversed
- */
-u32 bitrev32(u32 x)
-{
-	return (bitrev16(x & 0xffff) << 16) | bitrev16(x >> 16);
-}
-EXPORT_SYMBOL(bitrev32);
+#endif /* CONFIG_HAVE_ARCH_BITREVERSE */
-- 
2.1.1
