Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaJ2FRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:17:02 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:18346 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbaJ2FRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:17:01 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Rob Herring'" <robherring2@gmail.com>, "'Joe Perches'" <joe@perches.com>
CC: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 29 Oct 2014 13:16:52 +0800
Subject: [RFC V4 3/3] arm64:add bitrev.h file to support rbit instruction
Thread-Topic: [RFC V4 3/3] arm64:add bitrev.h file to support rbit
 instruction
Thread-Index: Ac/zKGffEmlPWtUCT7yIK/xKLtVDxQADp3GQAAAMGlAAAAxPoA==
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
 <1414392371.8884.2.camel@perches.com>
 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9T5H7CR032445

This patch add bitrev.h file to support rbit instruction,
so that we can do bitrev operation by hardware.
Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 arch/arm64/Kconfig              |  1 +
 arch/arm64/include/asm/bitrev.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)
 create mode 100644 arch/arm64/include/asm/bitrev.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9532f8d..b1ec1dd 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -35,6 +35,7 @@ config ARM64
 	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ARCH_BITREVERSE
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/arm64/include/asm/bitrev.h b/arch/arm64/include/asm/bitrev.h
new file mode 100644
index 0000000..292a5de
--- /dev/null
+++ b/arch/arm64/include/asm/bitrev.h
@@ -0,0 +1,28 @@
+#ifndef __ASM_ARM64_BITREV_H
+#define __ASM_ARM64_BITREV_H
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
-- 
2.1.1
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
