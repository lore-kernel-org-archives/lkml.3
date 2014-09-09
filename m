Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbaIIMNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:13:12 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43244 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbaIIMNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:13:11 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org
Subject: [PATCH] asm-generic/io.h: Implement read[bwlq]_relaxed()
Date: Tue,  9 Sep 2014 13:12:40 +0100
Message-Id: <1410264760-29756-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the read[bwlq]_relaxed() family are implemented on every
architecture except blackfin, m68k[1], metag, openrisc, s390[2] and
score. Increasingly drivers are being optimized to exploit relaxed
reads putting these architectures at risk of compilation failures for
shared drivers.

This patch addresses this by providing implementations of
read[bwlq]_relaxed() that are identical to the equivalent read[bwlq]().
All the above architectures include asm-generic/io.h .

Note that currently only eight architectures (alpha, arm, arm64, avr32,
hexagon, microblaze, mips and sh) implement write[bwlq]_relaxed() meaning
these functions are deliberately not included in this patch.

[1] m68k includes the relaxed family only when configured *without* MMU.
[2] s390 requires CONFIG_PCI to include the relaxed family.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
---
 include/asm-generic/io.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 975e1cc..85ea117 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -66,6 +66,16 @@ static inline u32 readl(const volatile void __iomem *addr)
 	return __le32_to_cpu(__raw_readl(addr));
 }

+#ifndef readb_relaxed
+#define readb_relaxed __raw_readb
+#endif
+#ifndef readw_relaxed
+#define readw_relaxed readw
+#endif
+#ifndef readl_relaxed
+#define readl_relaxed readl
+#endif
+
 #ifndef __raw_writeb
 static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
 {
@@ -105,6 +115,10 @@ static inline u64 readq(const volatile void __iomem *addr)
 	return __le64_to_cpu(__raw_readq(addr));
 }

+#ifndef readq_relaxed
+#define readq_relaxed readq
+#endif
+
 #ifndef __raw_writeq
 static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 {
--
1.9.3

