Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3DMKri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 06:47:38 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:57843 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3DMKrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 06:47:01 -0400
Subject: [RFC PATCH 5/6] crypto: serpent - add AVX2/x86_64 assembler
 implementation of serpent cipher
To: linux-crypto@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Sat, 13 Apr 2013 13:46:55 +0300
Message-ID: <20130413104655.10667.18089.stgit@localhost6.localdomain6>
In-Reply-To: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
References: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds AVX2/x86-64 implementation of Serpent cipher, requiring 16 parallel
blocks for input (256 bytes). Implementation is based on the AVX implementation
and extends to use the 256-bit wide YMM registers. Since serpent does not use
table look-ups, this implementation should be close to two times faster than
the AVX implementation.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/Makefile                  |    2 
 arch/x86/crypto/serpent-avx2-asm_64.S     |  800 +++++++++++++++++++++++++++++
 arch/x86/crypto/serpent_avx2_glue.c       |  562 ++++++++++++++++++++
 arch/x86/crypto/serpent_avx_glue.c        |   62 ++
 arch/x86/include/asm/crypto/serpent-avx.h |   24 +
 crypto/Kconfig                            |   23 +
 crypto/testmgr.c                          |   15 +
 7 files changed, 1468 insertions(+), 20 deletions(-)
 create mode 100644 arch/x86/crypto/serpent-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/serpent_avx2_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 1f6e0c2..a21af59 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -43,6 +43,7 @@ endif
 # These modules require assembler to support AVX2.
 ifeq ($(avx2_supported),yes)
 	obj-$(CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64) += blowfish-avx2.o
+	obj-$(CONFIG_CRYPTO_SERPENT_AVX2_X86_64) += serpent-avx2.o
 	obj-$(CONFIG_CRYPTO_TWOFISH_AVX2_X86_64) += twofish-avx2.o
 endif
 
@@ -72,6 +73,7 @@ endif
 
 ifeq ($(avx2_supported),yes)
 	blowfish-avx2-y := blowfish-avx2-asm_64.o blowfish_avx2_glue.o
+	serpent-avx2-y := serpent-avx2-asm_64.o serpent_avx2_glue.o
 	twofish-avx2-y := twofish-avx2-asm_64.o twofish_avx2_glue.o
 endif
 
diff --git a/arch/x86/crypto/serpent-avx2-asm_64.S b/arch/x86/crypto/serpent-avx2-asm_64.S
new file mode 100644
index 0000000..b222085
--- /dev/null
+++ b/arch/x86/crypto/serpent-avx2-asm_64.S
@@ -0,0 +1,800 @@
+/*
+ * x86_64/AVX2 assembler optimized version of Serpent
+ *
+ * Copyright © 2012-2013 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
+ * Based on AVX assembler implementation of Serpent by:
+ *  Copyright © 2012 Johannes Goetzfried
+ *      <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/linkage.h>
+#include "glue_helper-asm-avx2.S"
+
+.file "serpent-avx2-asm_64.S"
+
+.data
+.align 16
+
+.Lbswap128_mask:
+	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+.Lxts_gf128mul_and_shl1_mask_0:
+	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
+.Lxts_gf128mul_and_shl1_mask_1:
+	.byte 0x0e, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0
+
+.text
+
+#define CTX %rdi
+
+#define RNOT %ymm0
+#define tp  %ymm1
+
+#define RA1 %ymm2
+#define RA2 %ymm3
+#define RB1 %ymm4
+#define RB2 %ymm5
+#define RC1 %ymm6
+#define RC2 %ymm7
+#define RD1 %ymm8
+#define RD2 %ymm9
+#define RE1 %ymm10
+#define RE2 %ymm11
+
+#define RK0 %ymm12
+#define RK1 %ymm13
+#define RK2 %ymm14
+#define RK3 %ymm15
+
+#define RK0x %xmm12
+#define RK1x %xmm13
+#define RK2x %xmm14
+#define RK3x %xmm15
+
+#define S0_1(x0, x1, x2, x3, x4)      \
+	vpor		x0,   x3, tp; \
+	vpxor		x3,   x0, x0; \
+	vpxor		x2,   x3, x4; \
+	vpxor		RNOT, x4, x4; \
+	vpxor		x1,   tp, x3; \
+	vpand		x0,   x1, x1; \
+	vpxor		x4,   x1, x1; \
+	vpxor		x0,   x2, x2;
+#define S0_2(x0, x1, x2, x3, x4)      \
+	vpxor		x3,   x0, x0; \
+	vpor		x0,   x4, x4; \
+	vpxor		x2,   x0, x0; \
+	vpand		x1,   x2, x2; \
+	vpxor		x2,   x3, x3; \
+	vpxor		RNOT, x1, x1; \
+	vpxor		x4,   x2, x2; \
+	vpxor		x2,   x1, x1;
+
+#define S1_1(x0, x1, x2, x3, x4)      \
+	vpxor		x0,   x1, tp; \
+	vpxor		x3,   x0, x0; \
+	vpxor		RNOT, x3, x3; \
+	vpand		tp,   x1, x4; \
+	vpor		tp,   x0, x0; \
+	vpxor		x2,   x3, x3; \
+	vpxor		x3,   x0, x0; \
+	vpxor		x3,   tp, x1;
+#define S1_2(x0, x1, x2, x3, x4)      \
+	vpxor		x4,   x3, x3; \
+	vpor		x4,   x1, x1; \
+	vpxor		x2,   x4, x4; \
+	vpand		x0,   x2, x2; \
+	vpxor		x1,   x2, x2; \
+	vpor		x0,   x1, x1; \
+	vpxor		RNOT, x0, x0; \
+	vpxor		x2,   x0, x0; \
+	vpxor		x1,   x4, x4;
+
+#define S2_1(x0, x1, x2, x3, x4)      \
+	vpxor		RNOT, x3, x3; \
+	vpxor		x0,   x1, x1; \
+	vpand		x2,   x0, tp; \
+	vpxor		x3,   tp, tp; \
+	vpor		x0,   x3, x3; \
+	vpxor		x1,   x2, x2; \
+	vpxor		x1,   x3, x3; \
+	vpand		tp,   x1, x1;
+#define S2_2(x0, x1, x2, x3, x4)      \
+	vpxor		x2,   tp, tp; \
+	vpand		x3,   x2, x2; \
+	vpor		x1,   x3, x3; \
+	vpxor		RNOT, tp, tp; \
+	vpxor		tp,   x3, x3; \
+	vpxor		tp,   x0, x4; \
+	vpxor		x2,   tp, x0; \
+	vpor		x2,   x1, x1;
+
+#define S3_1(x0, x1, x2, x3, x4)      \
+	vpxor		x3,   x1, tp; \
+	vpor		x0,   x3, x3; \
+	vpand		x0,   x1, x4; \
+	vpxor		x2,   x0, x0; \
+	vpxor		tp,   x2, x2; \
+	vpand		x3,   tp, x1; \
+	vpxor		x3,   x2, x2; \
+	vpor		x4,   x0, x0; \
+	vpxor		x3,   x4, x4;
+#define S3_2(x0, x1, x2, x3, x4)      \
+	vpxor		x0,   x1, x1; \
+	vpand		x3,   x0, x0; \
+	vpand		x4,   x3, x3; \
+	vpxor		x2,   x3, x3; \
+	vpor		x1,   x4, x4; \
+	vpand		x1,   x2, x2; \
+	vpxor		x3,   x4, x4; \
+	vpxor		x3,   x0, x0; \
+	vpxor		x2,   x3, x3;
+
+#define S4_1(x0, x1, x2, x3, x4)      \
+	vpand		x0,   x3, tp; \
+	vpxor		x3,   x0, x0; \
+	vpxor		x2,   tp, tp; \
+	vpor		x3,   x2, x2; \
+	vpxor		x1,   x0, x0; \
+	vpxor		tp,   x3, x4; \
+	vpor		x0,   x2, x2; \
+	vpxor		x1,   x2, x2;
+#define S4_2(x0, x1, x2, x3, x4)      \
+	vpand		x0,   x1, x1; \
+	vpxor		x4,   x1, x1; \
+	vpand		x2,   x4, x4; \
+	vpxor		tp,   x2, x2; \
+	vpxor		x0,   x4, x4; \
+	vpor		x1,   tp, x3; \
+	vpxor		RNOT, x1, x1; \
+	vpxor		x0,   x3, x3;
+
+#define S5_1(x0, x1, x2, x3, x4)      \
+	vpor		x0,   x1, tp; \
+	vpxor		tp,   x2, x2; \
+	vpxor		RNOT, x3, x3; \
+	vpxor		x0,   x1, x4; \
+	vpxor		x2,   x0, x0; \
+	vpand		x4,   tp, x1; \
+	vpor		x3,   x4, x4; \
+	vpxor		x0,   x4, x4;
+#define S5_2(x0, x1, x2, x3, x4)      \
+	vpand		x3,   x0, x0; \
+	vpxor		x3,   x1, x1; \
+	vpxor		x2,   x3, x3; \
+	vpxor		x1,   x0, x0; \
+	vpand		x4,   x2, x2; \
+	vpxor		x2,   x1, x1; \
+	vpand		x0,   x2, x2; \
+	vpxor		x2,   x3, x3;
+
+#define S6_1(x0, x1, x2, x3, x4)      \
+	vpxor		x0,   x3, x3; \
+	vpxor		x2,   x1, tp; \
+	vpxor		x0,   x2, x2; \
+	vpand		x3,   x0, x0; \
+	vpor		x3,   tp, tp; \
+	vpxor		RNOT, x1, x4; \
+	vpxor		tp,   x0, x0; \
+	vpxor		x2,   tp, x1;
+#define S6_2(x0, x1, x2, x3, x4)      \
+	vpxor		x4,   x3, x3; \
+	vpxor		x0,   x4, x4; \
+	vpand		x0,   x2, x2; \
+	vpxor		x1,   x4, x4; \
+	vpxor		x3,   x2, x2; \
+	vpand		x1,   x3, x3; \
+	vpxor		x0,   x3, x3; \
+	vpxor		x2,   x1, x1;
+
+#define S7_1(x0, x1, x2, x3, x4)      \
+	vpxor		RNOT, x1, tp; \
+	vpxor		RNOT, x0, x0; \
+	vpand		x2,   tp, x1; \
+	vpxor		x3,   x1, x1; \
+	vpor		tp,   x3, x3; \
+	vpxor		x2,   tp, x4; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x0,   x3, x3; \
+	vpor		x1,   x0, x0;
+#define S7_2(x0, x1, x2, x3, x4)      \
+	vpand		x0,   x2, x2; \
+	vpxor		x4,   x0, x0; \
+	vpxor		x3,   x4, x4; \
+	vpand		x0,   x3, x3; \
+	vpxor		x1,   x4, x4; \
+	vpxor		x4,   x2, x2; \
+	vpxor		x1,   x3, x3; \
+	vpor		x0,   x4, x4; \
+	vpxor		x1,   x4, x4;
+
+#define SI0_1(x0, x1, x2, x3, x4)     \
+	vpxor		x0,   x1, x1; \
+	vpor		x1,   x3, tp; \
+	vpxor		x1,   x3, x4; \
+	vpxor		RNOT, x0, x0; \
+	vpxor		tp,   x2, x2; \
+	vpxor		x0,   tp, x3; \
+	vpand		x1,   x0, x0; \
+	vpxor		x2,   x0, x0;
+#define SI0_2(x0, x1, x2, x3, x4)     \
+	vpand		x3,   x2, x2; \
+	vpxor		x4,   x3, x3; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x3,   x1, x1; \
+	vpand		x0,   x3, x3; \
+	vpxor		x0,   x1, x1; \
+	vpxor		x2,   x0, x0; \
+	vpxor		x3,   x4, x4;
+
+#define SI1_1(x0, x1, x2, x3, x4)     \
+	vpxor		x3,   x1, x1; \
+	vpxor		x2,   x0, tp; \
+	vpxor		RNOT, x2, x2; \
+	vpor		x1,   x0, x4; \
+	vpxor		x3,   x4, x4; \
+	vpand		x1,   x3, x3; \
+	vpxor		x2,   x1, x1; \
+	vpand		x4,   x2, x2;
+#define SI1_2(x0, x1, x2, x3, x4)     \
+	vpxor		x1,   x4, x4; \
+	vpor		x3,   x1, x1; \
+	vpxor		tp,   x3, x3; \
+	vpxor		tp,   x2, x2; \
+	vpor		x4,   tp, x0; \
+	vpxor		x4,   x2, x2; \
+	vpxor		x0,   x1, x1; \
+	vpxor		x1,   x4, x4;
+
+#define SI2_1(x0, x1, x2, x3, x4)     \
+	vpxor		x1,   x2, x2; \
+	vpxor		RNOT, x3, tp; \
+	vpor		x2,   tp, tp; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x0,   x3, x4; \
+	vpxor		x1,   tp, x3; \
+	vpor		x2,   x1, x1; \
+	vpxor		x0,   x2, x2;
+#define SI2_2(x0, x1, x2, x3, x4)     \
+	vpxor		x4,   x1, x1; \
+	vpor		x3,   x4, x4; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x2,   x4, x4; \
+	vpand		x1,   x2, x2; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x4,   x3, x3; \
+	vpxor		x0,   x4, x4;
+
+#define SI3_1(x0, x1, x2, x3, x4)     \
+	vpxor		x1,   x2, x2; \
+	vpand		x2,   x1, tp; \
+	vpxor		x0,   tp, tp; \
+	vpor		x1,   x0, x0; \
+	vpxor		x3,   x1, x4; \
+	vpxor		x3,   x0, x0; \
+	vpor		tp,   x3, x3; \
+	vpxor		x2,   tp, x1;
+#define SI3_2(x0, x1, x2, x3, x4)     \
+	vpxor		x3,   x1, x1; \
+	vpxor		x2,   x0, x0; \
+	vpxor		x3,   x2, x2; \
+	vpand		x1,   x3, x3; \
+	vpxor		x0,   x1, x1; \
+	vpand		x2,   x0, x0; \
+	vpxor		x3,   x4, x4; \
+	vpxor		x0,   x3, x3; \
+	vpxor		x1,   x0, x0;
+
+#define SI4_1(x0, x1, x2, x3, x4)     \
+	vpxor		x3,   x2, x2; \
+	vpand		x1,   x0, tp; \
+	vpxor		x2,   tp, tp; \
+	vpor		x3,   x2, x2; \
+	vpxor		RNOT, x0, x4; \
+	vpxor		tp,   x1, x1; \
+	vpxor		x2,   tp, x0; \
+	vpand		x4,   x2, x2;
+#define SI4_2(x0, x1, x2, x3, x4)     \
+	vpxor		x0,   x2, x2; \
+	vpor		x4,   x0, x0; \
+	vpxor		x3,   x0, x0; \
+	vpand		x2,   x3, x3; \
+	vpxor		x3,   x4, x4; \
+	vpxor		x1,   x3, x3; \
+	vpand		x0,   x1, x1; \
+	vpxor		x1,   x4, x4; \
+	vpxor		x3,   x0, x0;
+
+#define SI5_1(x0, x1, x2, x3, x4)     \
+	vpor		x2,   x1, tp; \
+	vpxor		x1,   x2, x2; \
+	vpxor		x3,   tp, tp; \
+	vpand		x1,   x3, x3; \
+	vpxor		x3,   x2, x2; \
+	vpor		x0,   x3, x3; \
+	vpxor		RNOT, x0, x0; \
+	vpxor		x2,   x3, x3; \
+	vpor		x0,   x2, x2;
+#define SI5_2(x0, x1, x2, x3, x4)     \
+	vpxor		tp,   x1, x4; \
+	vpxor		x4,   x2, x2; \
+	vpand		x0,   x4, x4; \
+	vpxor		tp,   x0, x0; \
+	vpxor		x3,   tp, x1; \
+	vpand		x2,   x0, x0; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x2,   x0, x0; \
+	vpxor		x4,   x2, x2; \
+	vpxor		x3,   x4, x4;
+
+#define SI6_1(x0, x1, x2, x3, x4)     \
+	vpxor		x2,   x0, x0; \
+	vpand		x3,   x0, tp; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x2,   tp, tp; \
+	vpxor		x1,   x3, x3; \
+	vpor		x0,   x2, x2; \
+	vpxor		x3,   x2, x2; \
+	vpand		tp,   x3, x3;
+#define SI6_2(x0, x1, x2, x3, x4)     \
+	vpxor		RNOT, tp, tp; \
+	vpxor		x1,   x3, x3; \
+	vpand		x2,   x1, x1; \
+	vpxor		tp,   x0, x4; \
+	vpxor		x4,   x3, x3; \
+	vpxor		x2,   x4, x4; \
+	vpxor		x1,   tp, x0; \
+	vpxor		x0,   x2, x2;
+
+#define SI7_1(x0, x1, x2, x3, x4)     \
+	vpand		x0,   x3, tp; \
+	vpxor		x2,   x0, x0; \
+	vpor		x3,   x2, x2; \
+	vpxor		x1,   x3, x4; \
+	vpxor		RNOT, x0, x0; \
+	vpor		tp,   x1, x1; \
+	vpxor		x0,   x4, x4; \
+	vpand		x2,   x0, x0; \
+	vpxor		x1,   x0, x0;
+#define SI7_2(x0, x1, x2, x3, x4)     \
+	vpand		x2,   x1, x1; \
+	vpxor		x2,   tp, x3; \
+	vpxor		x3,   x4, x4; \
+	vpand		x3,   x2, x2; \
+	vpor		x0,   x3, x3; \
+	vpxor		x4,   x1, x1; \
+	vpxor		x4,   x3, x3; \
+	vpand		x0,   x4, x4; \
+	vpxor		x2,   x4, x4;
+
+#define get_key(i,j,t) \
+	vpbroadcastd (4*(i)+(j))*4(CTX), t;
+
+#define K2(x0, x1, x2, x3, x4, i) \
+	get_key(i, 0, RK0); \
+	get_key(i, 1, RK1); \
+	get_key(i, 2, RK2); \
+	get_key(i, 3, RK3); \
+	vpxor RK0,	x0 ## 1, x0 ## 1; \
+	vpxor RK1,	x1 ## 1, x1 ## 1; \
+	vpxor RK2,	x2 ## 1, x2 ## 1; \
+	vpxor RK3,	x3 ## 1, x3 ## 1; \
+		vpxor RK0,	x0 ## 2, x0 ## 2; \
+		vpxor RK1,	x1 ## 2, x1 ## 2; \
+		vpxor RK2,	x2 ## 2, x2 ## 2; \
+		vpxor RK3,	x3 ## 2, x3 ## 2;
+
+#define LK2(x0, x1, x2, x3, x4, i) \
+	vpslld $13,		x0 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 13),	x0 ## 1, x0 ## 1;          \
+	vpor			x4 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x0 ## 1, x1 ## 1, x1 ## 1; \
+	vpslld $3,		x2 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 3),	x2 ## 1, x2 ## 1;          \
+	vpor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	vpxor			x2 ## 1, x1 ## 1, x1 ## 1; \
+		vpslld $13,		x0 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 13),	x0 ## 2, x0 ## 2;          \
+		vpor			x4 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x0 ## 2, x1 ## 2, x1 ## 2; \
+		vpslld $3,		x2 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 3),	x2 ## 2, x2 ## 2;          \
+		vpor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		vpxor			x2 ## 2, x1 ## 2, x1 ## 2; \
+	vpslld $1,		x1 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 1),	x1 ## 1, x1 ## 1;          \
+	vpor			x4 ## 1, x1 ## 1, x1 ## 1; \
+	vpslld $3,		x0 ## 1, x4 ## 1;          \
+	vpxor			x2 ## 1, x3 ## 1, x3 ## 1; \
+	vpxor			x4 ## 1, x3 ## 1, x3 ## 1; \
+	get_key(i, 1, RK1); \
+		vpslld $1,		x1 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 1),	x1 ## 2, x1 ## 2;          \
+		vpor			x4 ## 2, x1 ## 2, x1 ## 2; \
+		vpslld $3,		x0 ## 2, x4 ## 2;          \
+		vpxor			x2 ## 2, x3 ## 2, x3 ## 2; \
+		vpxor			x4 ## 2, x3 ## 2, x3 ## 2; \
+		get_key(i, 3, RK3); \
+	vpslld $7,		x3 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 7),	x3 ## 1, x3 ## 1;          \
+	vpor			x4 ## 1, x3 ## 1, x3 ## 1; \
+	vpslld $7,		x1 ## 1, x4 ## 1;          \
+	vpxor			x1 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x3 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x3 ## 1, x2 ## 1, x2 ## 1; \
+	vpxor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	get_key(i, 0, RK0); \
+		vpslld $7,		x3 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 7),	x3 ## 2, x3 ## 2;          \
+		vpor			x4 ## 2, x3 ## 2, x3 ## 2; \
+		vpslld $7,		x1 ## 2, x4 ## 2;          \
+		vpxor			x1 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x3 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x3 ## 2, x2 ## 2, x2 ## 2; \
+		vpxor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		get_key(i, 2, RK2); \
+	vpxor			RK1, x1 ## 1, x1 ## 1;     \
+	vpxor			RK3, x3 ## 1, x3 ## 1;     \
+	vpslld $5,		x0 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 5),	x0 ## 1, x0 ## 1;          \
+	vpor			x4 ## 1, x0 ## 1, x0 ## 1; \
+	vpslld $22,		x2 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 22),	x2 ## 1, x2 ## 1;          \
+	vpor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	vpxor			RK0, x0 ## 1, x0 ## 1;     \
+	vpxor			RK2, x2 ## 1, x2 ## 1;     \
+		vpxor			RK1, x1 ## 2, x1 ## 2;     \
+		vpxor			RK3, x3 ## 2, x3 ## 2;     \
+		vpslld $5,		x0 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 5),	x0 ## 2, x0 ## 2;          \
+		vpor			x4 ## 2, x0 ## 2, x0 ## 2; \
+		vpslld $22,		x2 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 22),	x2 ## 2, x2 ## 2;          \
+		vpor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		vpxor			RK0, x0 ## 2, x0 ## 2;     \
+		vpxor			RK2, x2 ## 2, x2 ## 2;
+
+#define KL2(x0, x1, x2, x3, x4, i) \
+	vpxor			RK0, x0 ## 1, x0 ## 1;     \
+	vpxor			RK2, x2 ## 1, x2 ## 1;     \
+	vpsrld $5,		x0 ## 1, x4 ## 1;          \
+	vpslld $(32 - 5),	x0 ## 1, x0 ## 1;          \
+	vpor			x4 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			RK3, x3 ## 1, x3 ## 1;     \
+	vpxor			RK1, x1 ## 1, x1 ## 1;     \
+	vpsrld $22,		x2 ## 1, x4 ## 1;          \
+	vpslld $(32 - 22),	x2 ## 1, x2 ## 1;          \
+	vpor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	vpxor			x3 ## 1, x2 ## 1, x2 ## 1; \
+		vpxor			RK0, x0 ## 2, x0 ## 2;     \
+		vpxor			RK2, x2 ## 2, x2 ## 2;     \
+		vpsrld $5,		x0 ## 2, x4 ## 2;          \
+		vpslld $(32 - 5),	x0 ## 2, x0 ## 2;          \
+		vpor			x4 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			RK3, x3 ## 2, x3 ## 2;     \
+		vpxor			RK1, x1 ## 2, x1 ## 2;     \
+		vpsrld $22,		x2 ## 2, x4 ## 2;          \
+		vpslld $(32 - 22),	x2 ## 2, x2 ## 2;          \
+		vpor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		vpxor			x3 ## 2, x2 ## 2, x2 ## 2; \
+	vpxor			x3 ## 1, x0 ## 1, x0 ## 1; \
+	vpslld $7,		x1 ## 1, x4 ## 1;          \
+	vpxor			x1 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	vpsrld $1,		x1 ## 1, x4 ## 1;          \
+	vpslld $(32 - 1),	x1 ## 1, x1 ## 1;          \
+	vpor			x4 ## 1, x1 ## 1, x1 ## 1; \
+		vpxor			x3 ## 2, x0 ## 2, x0 ## 2; \
+		vpslld $7,		x1 ## 2, x4 ## 2;          \
+		vpxor			x1 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		vpsrld $1,		x1 ## 2, x4 ## 2;          \
+		vpslld $(32 - 1),	x1 ## 2, x1 ## 2;          \
+		vpor			x4 ## 2, x1 ## 2, x1 ## 2; \
+	vpsrld $7,		x3 ## 1, x4 ## 1;          \
+	vpslld $(32 - 7),	x3 ## 1, x3 ## 1;          \
+	vpor			x4 ## 1, x3 ## 1, x3 ## 1; \
+	vpxor			x0 ## 1, x1 ## 1, x1 ## 1; \
+	vpslld $3,		x0 ## 1, x4 ## 1;          \
+	vpxor			x4 ## 1, x3 ## 1, x3 ## 1; \
+		vpsrld $7,		x3 ## 2, x4 ## 2;          \
+		vpslld $(32 - 7),	x3 ## 2, x3 ## 2;          \
+		vpor			x4 ## 2, x3 ## 2, x3 ## 2; \
+		vpxor			x0 ## 2, x1 ## 2, x1 ## 2; \
+		vpslld $3,		x0 ## 2, x4 ## 2;          \
+		vpxor			x4 ## 2, x3 ## 2, x3 ## 2; \
+	vpsrld $13,		x0 ## 1, x4 ## 1;          \
+	vpslld $(32 - 13),	x0 ## 1, x0 ## 1;          \
+	vpor			x4 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x2 ## 1, x1 ## 1, x1 ## 1; \
+	vpxor			x2 ## 1, x3 ## 1, x3 ## 1; \
+	vpsrld $3,		x2 ## 1, x4 ## 1;          \
+	vpslld $(32 - 3),	x2 ## 1, x2 ## 1;          \
+	vpor			x4 ## 1, x2 ## 1, x2 ## 1; \
+		vpsrld $13,		x0 ## 2, x4 ## 2;          \
+		vpslld $(32 - 13),	x0 ## 2, x0 ## 2;          \
+		vpor			x4 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x2 ## 2, x1 ## 2, x1 ## 2; \
+		vpxor			x2 ## 2, x3 ## 2, x3 ## 2; \
+		vpsrld $3,		x2 ## 2, x4 ## 2;          \
+		vpslld $(32 - 3),	x2 ## 2, x2 ## 2;          \
+		vpor			x4 ## 2, x2 ## 2, x2 ## 2;
+
+#define S(SBOX, x0, x1, x2, x3, x4) \
+	SBOX ## _1(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	SBOX ## _2(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	SBOX ## _1(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
+	SBOX ## _2(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2);
+
+#define SP(SBOX, x0, x1, x2, x3, x4, i) \
+	get_key(i, 0, RK0); \
+	SBOX ## _1(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	get_key(i, 2, RK2); \
+	SBOX ## _2(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	get_key(i, 3, RK3); \
+	SBOX ## _1(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
+	get_key(i, 1, RK1); \
+	SBOX ## _2(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
+
+#define transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	vpunpckldq		x1, x0, t0; \
+	vpunpckhdq		x1, x0, t2; \
+	vpunpckldq		x3, x2, t1; \
+	vpunpckhdq		x3, x2, x3; \
+	\
+	vpunpcklqdq		t1, t0, x0; \
+	vpunpckhqdq		t1, t0, x1; \
+	vpunpcklqdq		x3, t2, x2; \
+	vpunpckhqdq		x3, t2, x3;
+
+#define read_blocks(x0, x1, x2, x3, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
+
+#define write_blocks(x0, x1, x2, x3, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
+
+.align 8
+__serpent_enc_blk16:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: plaintext
+	 * output:
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: ciphertext
+	 */
+
+	vpcmpeqd RNOT, RNOT, RNOT;
+
+	read_blocks(RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	read_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+						 K2(RA, RB, RC, RD, RE, 0);
+	S(S0, RA, RB, RC, RD, RE);		LK2(RC, RB, RD, RA, RE, 1);
+	S(S1, RC, RB, RD, RA, RE);		LK2(RE, RD, RA, RC, RB, 2);
+	S(S2, RE, RD, RA, RC, RB);		LK2(RB, RD, RE, RC, RA, 3);
+	S(S3, RB, RD, RE, RC, RA);		LK2(RC, RA, RD, RB, RE, 4);
+	S(S4, RC, RA, RD, RB, RE);		LK2(RA, RD, RB, RE, RC, 5);
+	S(S5, RA, RD, RB, RE, RC);		LK2(RC, RA, RD, RE, RB, 6);
+	S(S6, RC, RA, RD, RE, RB);		LK2(RD, RB, RA, RE, RC, 7);
+	S(S7, RD, RB, RA, RE, RC);		LK2(RC, RA, RE, RD, RB, 8);
+	S(S0, RC, RA, RE, RD, RB);		LK2(RE, RA, RD, RC, RB, 9);
+	S(S1, RE, RA, RD, RC, RB);		LK2(RB, RD, RC, RE, RA, 10);
+	S(S2, RB, RD, RC, RE, RA);		LK2(RA, RD, RB, RE, RC, 11);
+	S(S3, RA, RD, RB, RE, RC);		LK2(RE, RC, RD, RA, RB, 12);
+	S(S4, RE, RC, RD, RA, RB);		LK2(RC, RD, RA, RB, RE, 13);
+	S(S5, RC, RD, RA, RB, RE);		LK2(RE, RC, RD, RB, RA, 14);
+	S(S6, RE, RC, RD, RB, RA);		LK2(RD, RA, RC, RB, RE, 15);
+	S(S7, RD, RA, RC, RB, RE);		LK2(RE, RC, RB, RD, RA, 16);
+	S(S0, RE, RC, RB, RD, RA);		LK2(RB, RC, RD, RE, RA, 17);
+	S(S1, RB, RC, RD, RE, RA);		LK2(RA, RD, RE, RB, RC, 18);
+	S(S2, RA, RD, RE, RB, RC);		LK2(RC, RD, RA, RB, RE, 19);
+	S(S3, RC, RD, RA, RB, RE);		LK2(RB, RE, RD, RC, RA, 20);
+	S(S4, RB, RE, RD, RC, RA);		LK2(RE, RD, RC, RA, RB, 21);
+	S(S5, RE, RD, RC, RA, RB);		LK2(RB, RE, RD, RA, RC, 22);
+	S(S6, RB, RE, RD, RA, RC);		LK2(RD, RC, RE, RA, RB, 23);
+	S(S7, RD, RC, RE, RA, RB);		LK2(RB, RE, RA, RD, RC, 24);
+	S(S0, RB, RE, RA, RD, RC);		LK2(RA, RE, RD, RB, RC, 25);
+	S(S1, RA, RE, RD, RB, RC);		LK2(RC, RD, RB, RA, RE, 26);
+	S(S2, RC, RD, RB, RA, RE);		LK2(RE, RD, RC, RA, RB, 27);
+	S(S3, RE, RD, RC, RA, RB);		LK2(RA, RB, RD, RE, RC, 28);
+	S(S4, RA, RB, RD, RE, RC);		LK2(RB, RD, RE, RC, RA, 29);
+	S(S5, RB, RD, RE, RC, RA);		LK2(RA, RB, RD, RC, RE, 30);
+	S(S6, RA, RB, RD, RC, RE);		LK2(RD, RE, RB, RC, RA, 31);
+	S(S7, RD, RE, RB, RC, RA);		 K2(RA, RB, RC, RD, RE, 32);
+
+	write_blocks(RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	write_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+	ret;
+ENDPROC(__serpent_enc_blk16)
+
+.align 8
+__serpent_dec_blk16:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2: ciphertext
+	 * output:
+	 *	RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2: plaintext
+	 */
+
+	vpcmpeqd RNOT, RNOT, RNOT;
+
+	read_blocks(RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	read_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+						 K2(RA, RB, RC, RD, RE, 32);
+	SP(SI7, RA, RB, RC, RD, RE, 31);	KL2(RB, RD, RA, RE, RC, 31);
+	SP(SI6, RB, RD, RA, RE, RC, 30);	KL2(RA, RC, RE, RB, RD, 30);
+	SP(SI5, RA, RC, RE, RB, RD, 29);	KL2(RC, RD, RA, RE, RB, 29);
+	SP(SI4, RC, RD, RA, RE, RB, 28);	KL2(RC, RA, RB, RE, RD, 28);
+	SP(SI3, RC, RA, RB, RE, RD, 27);	KL2(RB, RC, RD, RE, RA, 27);
+	SP(SI2, RB, RC, RD, RE, RA, 26);	KL2(RC, RA, RE, RD, RB, 26);
+	SP(SI1, RC, RA, RE, RD, RB, 25);	KL2(RB, RA, RE, RD, RC, 25);
+	SP(SI0, RB, RA, RE, RD, RC, 24);	KL2(RE, RC, RA, RB, RD, 24);
+	SP(SI7, RE, RC, RA, RB, RD, 23);	KL2(RC, RB, RE, RD, RA, 23);
+	SP(SI6, RC, RB, RE, RD, RA, 22);	KL2(RE, RA, RD, RC, RB, 22);
+	SP(SI5, RE, RA, RD, RC, RB, 21);	KL2(RA, RB, RE, RD, RC, 21);
+	SP(SI4, RA, RB, RE, RD, RC, 20);	KL2(RA, RE, RC, RD, RB, 20);
+	SP(SI3, RA, RE, RC, RD, RB, 19);	KL2(RC, RA, RB, RD, RE, 19);
+	SP(SI2, RC, RA, RB, RD, RE, 18);	KL2(RA, RE, RD, RB, RC, 18);
+	SP(SI1, RA, RE, RD, RB, RC, 17);	KL2(RC, RE, RD, RB, RA, 17);
+	SP(SI0, RC, RE, RD, RB, RA, 16);	KL2(RD, RA, RE, RC, RB, 16);
+	SP(SI7, RD, RA, RE, RC, RB, 15);	KL2(RA, RC, RD, RB, RE, 15);
+	SP(SI6, RA, RC, RD, RB, RE, 14);	KL2(RD, RE, RB, RA, RC, 14);
+	SP(SI5, RD, RE, RB, RA, RC, 13);	KL2(RE, RC, RD, RB, RA, 13);
+	SP(SI4, RE, RC, RD, RB, RA, 12);	KL2(RE, RD, RA, RB, RC, 12);
+	SP(SI3, RE, RD, RA, RB, RC, 11);	KL2(RA, RE, RC, RB, RD, 11);
+	SP(SI2, RA, RE, RC, RB, RD, 10);	KL2(RE, RD, RB, RC, RA, 10);
+	SP(SI1, RE, RD, RB, RC, RA, 9);		KL2(RA, RD, RB, RC, RE, 9);
+	SP(SI0, RA, RD, RB, RC, RE, 8);		KL2(RB, RE, RD, RA, RC, 8);
+	SP(SI7, RB, RE, RD, RA, RC, 7);		KL2(RE, RA, RB, RC, RD, 7);
+	SP(SI6, RE, RA, RB, RC, RD, 6);		KL2(RB, RD, RC, RE, RA, 6);
+	SP(SI5, RB, RD, RC, RE, RA, 5);		KL2(RD, RA, RB, RC, RE, 5);
+	SP(SI4, RD, RA, RB, RC, RE, 4);		KL2(RD, RB, RE, RC, RA, 4);
+	SP(SI3, RD, RB, RE, RC, RA, 3);		KL2(RE, RD, RA, RC, RB, 3);
+	SP(SI2, RE, RD, RA, RC, RB, 2);		KL2(RD, RB, RC, RA, RE, 2);
+	SP(SI1, RD, RB, RC, RA, RE, 1);		KL2(RE, RB, RC, RA, RD, 1);
+	S(SI0, RE, RB, RC, RA, RD);		 K2(RC, RD, RB, RE, RA, 0);
+
+	write_blocks(RC1, RD1, RB1, RE1, RK0, RK1, RK2);
+	write_blocks(RC2, RD2, RB2, RE2, RK0, RK1, RK2);
+
+	ret;
+ENDPROC(__serpent_dec_blk16)
+
+ENTRY(serpent_ecb_enc_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vzeroupper;
+
+	load_16way(%rdx, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	call __serpent_enc_blk16;
+
+	store_16way(%rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(serpent_ecb_enc_16way)
+
+ENTRY(serpent_ecb_dec_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vzeroupper;
+
+	load_16way(%rdx, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	call __serpent_dec_blk16;
+
+	store_16way(%rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(serpent_ecb_dec_16way)
+
+ENTRY(serpent_cbc_dec_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vzeroupper;
+
+	load_16way(%rdx, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	call __serpent_dec_blk16;
+
+	store_cbc_16way(%rdx, %rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2,
+			RK0);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(serpent_cbc_dec_16way)
+
+ENTRY(serpent_ctr_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (little endian, 128bit)
+	 */
+
+	vzeroupper;
+
+	load_ctr_16way(%rcx, .Lbswap128_mask, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
+		       RD2, RK0, RK0x, RK1, RK1x, RK2, RK2x, RK3, RK3x, RNOT,
+		       tp);
+
+	call __serpent_enc_blk16;
+
+	store_ctr_16way(%rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(serpent_ctr_16way)
+
+ENTRY(serpent_xts_enc_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
+	 */
+
+	vzeroupper;
+
+	load_xts_16way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
+		       RD2, RK0, RK0x, RK1, RK1x, RK2, RK2x, RK3, RK3x, RNOT,
+		       .Lxts_gf128mul_and_shl1_mask_0,
+		       .Lxts_gf128mul_and_shl1_mask_1);
+
+	call __serpent_enc_blk16;
+
+	store_xts_16way(%rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(serpent_xts_enc_16way)
+
+ENTRY(serpent_xts_dec_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
+	 */
+
+	vzeroupper;
+
+	load_xts_16way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
+		       RD2, RK0, RK0x, RK1, RK1x, RK2, RK2x, RK3, RK3x, RNOT,
+		       .Lxts_gf128mul_and_shl1_mask_0,
+		       .Lxts_gf128mul_and_shl1_mask_1);
+
+	call __serpent_dec_blk16;
+
+	store_xts_16way(%rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
+
+	vzeroupper;
+
+	ret;
+ENDPROC(serpent_xts_dec_16way)
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
new file mode 100644
index 0000000..23aabc6
--- /dev/null
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -0,0 +1,562 @@
+/*
+ * Glue Code for x86_64/AVX2 assembler optimized version of Serpent
+ *
+ * Copyright © 2012-2013 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <crypto/algapi.h>
+#include <crypto/ctr.h>
+#include <crypto/lrw.h>
+#include <crypto/xts.h>
+#include <crypto/serpent.h>
+#include <asm/xcr.h>
+#include <asm/xsave.h>
+#include <asm/crypto/serpent-avx.h>
+#include <asm/crypto/ablk_helper.h>
+#include <asm/crypto/glue_helper.h>
+
+#define SERPENT_AVX2_PARALLEL_BLOCKS 16
+
+/* 16-way AVX2 parallel cipher functions */
+asmlinkage void serpent_ecb_enc_16way(struct serpent_ctx *ctx, u8 *dst,
+				      const u8 *src);
+asmlinkage void serpent_ecb_dec_16way(struct serpent_ctx *ctx, u8 *dst,
+				      const u8 *src);
+asmlinkage void serpent_cbc_dec_16way(void *ctx, u128 *dst, const u128 *src);
+
+asmlinkage void serpent_ctr_16way(void *ctx, u128 *dst, const u128 *src,
+				  le128 *iv);
+asmlinkage void serpent_xts_enc_16way(struct serpent_ctx *ctx, u8 *dst,
+				      const u8 *src, le128 *iv);
+asmlinkage void serpent_xts_dec_16way(struct serpent_ctx *ctx, u8 *dst,
+				      const u8 *src, le128 *iv);
+
+static const struct common_glue_ctx serpent_enc = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_8way_avx) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+	} }
+};
+
+static const struct common_glue_ctx serpent_ctr = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_16way) }
+	},  {
+		.num_blocks = 8,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_8way_avx) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(__serpent_crypt_ctr) }
+	} }
+};
+
+static const struct common_glue_ctx serpent_enc_xts = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_8way_avx) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc) }
+	} }
+};
+
+static const struct common_glue_ctx serpent_dec = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_8way_avx) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+	} }
+};
+
+static const struct common_glue_ctx serpent_dec_cbc = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_8way_avx) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+	} }
+};
+
+static const struct common_glue_ctx serpent_dec_xts = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_8way_avx) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec) }
+	} }
+};
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ecb_crypt_128bit(&serpent_enc, desc, dst, src, nbytes);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ecb_crypt_128bit(&serpent_dec, desc, dst, src, nbytes);
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_cbc_encrypt_128bit(GLUE_FUNC_CAST(__serpent_encrypt), desc,
+				       dst, src, nbytes);
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_cbc_decrypt_128bit(&serpent_dec_cbc, desc, dst, src,
+				       nbytes);
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		     struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ctr_crypt_128bit(&serpent_ctr, desc, dst, src, nbytes);
+}
+
+static inline bool serpent_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+{
+	/* since reusing AVX functions, starts using FPU at 8 parallel blocks */
+	return glue_fpu_begin(SERPENT_BLOCK_SIZE, 8, NULL, fpu_enabled, nbytes);
+}
+
+static inline void serpent_fpu_end(bool fpu_enabled)
+{
+	glue_fpu_end(fpu_enabled);
+}
+
+struct crypt_priv {
+	struct serpent_ctx *ctx;
+	bool fpu_enabled;
+};
+
+static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = serpent_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes >= SERPENT_AVX2_PARALLEL_BLOCKS * bsize) {
+		serpent_ecb_enc_16way(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * SERPENT_AVX2_PARALLEL_BLOCKS;
+		nbytes -= bsize * SERPENT_AVX2_PARALLEL_BLOCKS;
+	}
+
+	while (nbytes >= SERPENT_PARALLEL_BLOCKS * bsize) {
+		serpent_ecb_enc_8way_avx(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * SERPENT_PARALLEL_BLOCKS;
+		nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		__serpent_encrypt(ctx->ctx, srcdst, srcdst);
+}
+
+static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = serpent_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes >= SERPENT_AVX2_PARALLEL_BLOCKS * bsize) {
+		serpent_ecb_dec_16way(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * SERPENT_AVX2_PARALLEL_BLOCKS;
+		nbytes -= bsize * SERPENT_AVX2_PARALLEL_BLOCKS;
+	}
+
+	while (nbytes >= SERPENT_PARALLEL_BLOCKS * bsize) {
+		serpent_ecb_dec_8way_avx(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * SERPENT_PARALLEL_BLOCKS;
+		nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		__serpent_decrypt(ctx->ctx, srcdst, srcdst);
+}
+
+static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_AVX2_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->serpent_ctx,
+		.fpu_enabled = false,
+	};
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = encrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = lrw_crypt(desc, dst, src, nbytes, &req);
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_AVX2_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->serpent_ctx,
+		.fpu_enabled = false,
+	};
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = decrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = lrw_crypt(desc, dst, src, nbytes, &req);
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+
+	return glue_xts_crypt_128bit(&serpent_enc_xts, desc, dst, src, nbytes,
+				     XTS_TWEAK_CAST(__serpent_encrypt),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+
+	return glue_xts_crypt_128bit(&serpent_dec_xts, desc, dst, src, nbytes,
+				     XTS_TWEAK_CAST(__serpent_encrypt),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
+}
+
+static struct crypto_alg srp_algs[10] = { {
+	.cra_name		= "__ecb-serpent-avx2",
+	.cra_driver_name	= "__driver-ecb-serpent-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[0].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__cbc-serpent-avx2",
+	.cra_driver_name	= "__driver-cbc-serpent-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[1].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__ctr-serpent-avx2",
+	.cra_driver_name	= "__driver-ctr-serpent-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[2].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		= "__lrw-serpent-avx2",
+	.cra_driver_name	= "__driver-lrw-serpent-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[3].cra_list),
+	.cra_exit		= lrw_serpent_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= lrw_serpent_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__xts-serpent-avx2",
+	.cra_driver_name	= "__driver-xts-serpent-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[4].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE * 2,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE * 2,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= xts_serpent_setkey,
+			.encrypt	= xts_encrypt,
+			.decrypt	= xts_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ecb(serpent)",
+	.cra_driver_name	= "ecb-serpent-avx2",
+	.cra_priority		= 600,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[5].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(serpent)",
+	.cra_driver_name	= "cbc-serpent-avx2",
+	.cra_priority		= 600,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[6].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= __ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ctr(serpent)",
+	.cra_driver_name	= "ctr-serpent-avx2",
+	.cra_priority		= 600,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[7].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_encrypt,
+			.geniv		= "chainiv",
+		},
+	},
+}, {
+	.cra_name		= "lrw(serpent)",
+	.cra_driver_name	= "lrw-serpent-avx2",
+	.cra_priority		= 600,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[8].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "xts(serpent)",
+	.cra_driver_name	= "xts-serpent-avx2",
+	.cra_priority		= 600,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(srp_algs[9].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE * 2,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE * 2,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+} };
+
+static int __init init(void)
+{
+	u64 xcr0;
+
+	if (!cpu_has_avx2 || !cpu_has_osxsave) {
+		pr_info("AVX2 instructions are not detected.\n");
+		return -ENODEV;
+	}
+
+	xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
+	if ((xcr0 & (XSTATE_SSE | XSTATE_YMM)) != (XSTATE_SSE | XSTATE_YMM)) {
+		pr_info("AVX detected but unusable.\n");
+		return -ENODEV;
+	}
+
+	return crypto_register_algs(srp_algs, ARRAY_SIZE(srp_algs));
+}
+
+static void __exit fini(void)
+{
+	crypto_unregister_algs(srp_algs, ARRAY_SIZE(srp_algs));
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Serpent Cipher Algorithm, AVX2 optimized");
+MODULE_ALIAS("serpent");
+MODULE_ALIAS("serpent-asm");
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 0f8519c..9ae83cf 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -41,7 +41,32 @@
 #include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
-static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+/* 8-way parallel cipher functions */
+asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					 const u8 *src);
+EXPORT_SYMBOL_GPL(serpent_ecb_enc_8way_avx);
+
+asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					 const u8 *src);
+EXPORT_SYMBOL_GPL(serpent_ecb_dec_8way_avx);
+
+asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					 const u8 *src);
+EXPORT_SYMBOL_GPL(serpent_cbc_dec_8way_avx);
+
+asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+				     const u8 *src, le128 *iv);
+EXPORT_SYMBOL_GPL(serpent_ctr_8way_avx);
+
+asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					 const u8 *src, le128 *iv);
+EXPORT_SYMBOL_GPL(serpent_xts_enc_8way_avx);
+
+asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					 const u8 *src, le128 *iv);
+EXPORT_SYMBOL_GPL(serpent_xts_dec_8way_avx);
+
+void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	be128 ctrblk;
 
@@ -51,18 +76,22 @@ static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 	__serpent_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
+EXPORT_SYMBOL_GPL(__serpent_crypt_ctr);
 
-static void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
 				  GLUE_FUNC_CAST(__serpent_encrypt));
 }
+EXPORT_SYMBOL_GPL(serpent_xts_enc);
 
-static void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
 				  GLUE_FUNC_CAST(__serpent_decrypt));
 }
+EXPORT_SYMBOL_GPL(serpent_xts_dec);
+
 
 static const struct common_glue_ctx serpent_enc = {
 	.num_funcs = 2,
@@ -86,7 +115,7 @@ static const struct common_glue_ctx serpent_ctr = {
 		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_8way_avx) }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_crypt_ctr) }
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(__serpent_crypt_ctr) }
 	} }
 };
 
@@ -224,13 +253,8 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 		__serpent_decrypt(ctx->ctx, srcdst, srcdst);
 }
 
-struct serpent_lrw_ctx {
-	struct lrw_table_ctx lrw_table;
-	struct serpent_ctx serpent_ctx;
-};
-
-static int lrw_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
-			      unsigned int keylen)
+int lrw_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
+		       unsigned int keylen)
 {
 	struct serpent_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
@@ -243,6 +267,7 @@ static int lrw_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return lrw_init_table(&ctx->lrw_table, key + keylen -
 						SERPENT_BLOCK_SIZE);
 }
+EXPORT_SYMBOL_GPL(lrw_serpent_setkey);
 
 static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
@@ -296,20 +321,16 @@ static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ret;
 }
 
-static void lrw_exit_tfm(struct crypto_tfm *tfm)
+void lrw_serpent_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct serpent_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	lrw_free_table(&ctx->lrw_table);
 }
+EXPORT_SYMBOL_GPL(lrw_serpent_exit_tfm);
 
-struct serpent_xts_ctx {
-	struct serpent_ctx tweak_ctx;
-	struct serpent_ctx crypt_ctx;
-};
-
-static int xts_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
-			      unsigned int keylen)
+int xts_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
+		       unsigned int keylen)
 {
 	struct serpent_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *flags = &tfm->crt_flags;
@@ -331,6 +352,7 @@ static int xts_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
 	/* second half of xts-key is for tweak */
 	return __serpent_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2);
 }
+EXPORT_SYMBOL_GPL(xts_serpent_setkey);
 
 static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
@@ -420,7 +442,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_exit		= lrw_exit_tfm,
+	.cra_exit		= lrw_serpent_exit_tfm,
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= SERPENT_MIN_KEY_SIZE +
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/include/asm/crypto/serpent-avx.h
index 56e79cc..33c2b8a 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -6,6 +6,16 @@
 
 #define SERPENT_PARALLEL_BLOCKS 8
 
+struct serpent_lrw_ctx {
+	struct lrw_table_ctx lrw_table;
+	struct serpent_ctx serpent_ctx;
+};
+
+struct serpent_xts_ctx {
+	struct serpent_ctx tweak_ctx;
+	struct serpent_ctx crypt_ctx;
+};
+
 asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src);
 asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
@@ -21,4 +31,18 @@ asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 
+extern void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
+				le128 *iv);
+
+extern void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+extern void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+
+extern int lrw_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen);
+
+extern void lrw_serpent_exit_tfm(struct crypto_tfm *tfm);
+
+extern int xts_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen);
+
 #endif
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1ba48dd..9ad3d78 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1131,6 +1131,29 @@ config CRYPTO_SERPENT_AVX_X86_64
 	  See also:
 	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
 
+config CRYPTO_SERPENT_AVX2_X86_64
+	tristate "Serpent cipher algorithm (x86_64/AVX2)"
+	depends on X86 && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_GLUE_HELPER_X86
+	select CRYPTO_SERPENT
+	select CRYPTO_SERPENT_AVX_X86_64
+	select CRYPTO_LRW
+	select CRYPTO_XTS
+	help
+	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
+
+	  Keys are allowed to be from 0 to 256 bits in length, in steps
+	  of 8 bits.
+
+	  This module provides Serpent cipher algorithm that processes 16
+	  blocks parallel using AVX2 instruction set.
+
+	  See also:
+	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+
 config CRYPTO_TEA
 	tristate "TEA, XTEA and XETA cipher algorithms"
 	select CRYPTO_ALGAPI
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fea7841..f5e13de 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1645,6 +1645,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "__cbc-serpent-avx",
 		.test = alg_test_null,
 	}, {
+		.alg = "__cbc-serpent-avx2",
+		.test = alg_test_null,
+	}, {
 		.alg = "__cbc-serpent-sse2",
 		.test = alg_test_null,
 	}, {
@@ -1673,6 +1676,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "__driver-cbc-serpent-avx",
 		.test = alg_test_null,
 	}, {
+		.alg = "__driver-cbc-serpent-avx2",
+		.test = alg_test_null,
+	}, {
 		.alg = "__driver-cbc-serpent-sse2",
 		.test = alg_test_null,
 	}, {
@@ -1701,6 +1707,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "__driver-ecb-serpent-avx",
 		.test = alg_test_null,
 	}, {
+		.alg = "__driver-ecb-serpent-avx2",
+		.test = alg_test_null,
+	}, {
 		.alg = "__driver-ecb-serpent-sse2",
 		.test = alg_test_null,
 	}, {
@@ -1969,6 +1978,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "cryptd(__driver-cbc-camellia-aesni)",
 		.test = alg_test_null,
 	}, {
+		.alg = "cryptd(__driver-cbc-serpent-avx2)",
+		.test = alg_test_null,
+	}, {
 		.alg = "cryptd(__driver-ecb-aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
@@ -1988,6 +2000,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "cryptd(__driver-ecb-serpent-avx)",
 		.test = alg_test_null,
 	}, {
+		.alg = "cryptd(__driver-ecb-serpent-avx2)",
+		.test = alg_test_null,
+	}, {
 		.alg = "cryptd(__driver-ecb-serpent-sse2)",
 		.test = alg_test_null,
 	}, {

