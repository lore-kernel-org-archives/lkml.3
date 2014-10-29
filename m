Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaJ2FOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:14:24 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:6736 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbaJ2FOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:14:22 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Rob Herring'" <robherring2@gmail.com>, Joe Perches <joe@perches.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 29 Oct 2014 13:14:18 +0800
Subject: [RFC V4 1/3] add CONFIG_HAVE_ARCH_BITREVERSE to support rbit
 instruction
Thread-Topic: [RFC V4 1/3] add CONFIG_HAVE_ARCH_BITREVERSE to support rbit
 instruction
Thread-Index: Ac/zKGffEmlPWtUCT7yIK/xKLtVDxQADp3GQ
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
 <1414392371.8884.2.camel@perches.com>
 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
In-Reply-To: <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9T5EXU5032413

this change add CONFIG_HAVE_ARCH_BITREVERSE config option,
so that we can use arm/arm64 rbit instruction to do bitrev operation
by hardware.

We also change byte_rev_table[] to be static,
to make sure no drivers can access it directly.

Change bitrev16() bitrev32() to be inline function,
don't need export symbol for these tiny functions.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 include/linux/bitrev.h | 21 ++++++++++++++++++---
 lib/Kconfig            |  9 +++++++++
 lib/bitrev.c           | 19 +++----------------
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/include/linux/bitrev.h b/include/linux/bitrev.h
index 7ffe03f..fa2682c 100644
--- a/include/linux/bitrev.h
+++ b/include/linux/bitrev.h
@@ -3,14 +3,29 @@
 
 #include <linux/types.h>
 
-extern u8 const byte_rev_table[256];
+#ifdef CONFIG_HAVE_ARCH_BITREVERSE
+#include <asm/bitrev.h>
+
+#define bitrev32 __arch_bitrev32
+#define bitrev16 __arch_bitrev16
+#define bitrev8 __arch_bitrev8
+
+#else
 
 static inline u8 bitrev8(u8 byte)
 {
 	return byte_rev_table[byte];
 }
 
-extern u16 bitrev16(u16 in);
-extern u32 bitrev32(u32 in);
+static inline u16 bitrev16(u16 x)
+{
+	return (bitrev8(x & 0xff) << 8) | bitrev8(x >> 8);
+}
+
+static inline u32 bitrev32(u32 x)
+{
+	return (bitrev16(x & 0xffff) << 16) | bitrev16(x >> 16);
+}
 
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
index 3956203..ba13610 100644
--- a/lib/bitrev.c
+++ b/lib/bitrev.c
@@ -1,3 +1,4 @@
+#ifndef CONFIG_HAVE_ARCH_BITREVERSE
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/bitrev.h>
@@ -6,7 +7,7 @@ MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
 MODULE_DESCRIPTION("Bit ordering reversal functions");
 MODULE_LICENSE("GPL");
 
-const u8 byte_rev_table[256] = {
+const static u8 byte_rev_table[256] = {
 	0x00, 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0,
 	0x10, 0x90, 0x50, 0xd0, 0x30, 0xb0, 0x70, 0xf0,
 	0x08, 0x88, 0x48, 0xc8, 0x28, 0xa8, 0x68, 0xe8,
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

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
