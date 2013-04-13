Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3DMKrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 06:47:03 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:47714 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3DMKq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 06:46:58 -0400
Subject: [RFC PATCH 4/6] crypto: twofish - add AVX2/x86_64 assembler
 implementation of twofish cipher
To: linux-crypto@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Sat, 13 Apr 2013 13:46:50 +0300
Message-ID: <20130413104650.10667.80520.stgit@localhost6.localdomain6>
In-Reply-To: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
References: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds AVX2/x86-64 implementation of Twofish cipher, requiring 16 parallel
blocks for input (256 bytes). Table look-ups are performed using vpgatherdd
instruction directly from vector registers and thus should be faster than
earlier implementations. Implementation also uses 256-bit wide YMM registers,
which should give additional speed up compared to the AVX implementation.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/Makefile               |    2 
 arch/x86/crypto/glue_helper-asm-avx2.S |  180 ++++++++++
 arch/x86/crypto/twofish-avx2-asm_64.S  |  600 ++++++++++++++++++++++++++++++++
 arch/x86/crypto/twofish_avx2_glue.c    |  584 +++++++++++++++++++++++++++++++
 arch/x86/crypto/twofish_avx_glue.c     |   14 +
 arch/x86/include/asm/crypto/twofish.h  |   18 +
 crypto/Kconfig                         |   24 +
 crypto/testmgr.c                       |   12 +
 8 files changed, 1432 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/crypto/glue_helper-asm-avx2.S
 create mode 100644 arch/x86/crypto/twofish-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/twofish_avx2_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 28464ef..1f6e0c2 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -43,6 +43,7 @@ endif
 # These modules require assembler to support AVX2.
 ifeq ($(avx2_supported),yes)
 	obj-$(CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64) += blowfish-avx2.o
+	obj-$(CONFIG_CRYPTO_TWOFISH_AVX2_X86_64) += twofish-avx2.o
 endif
 
 aes-i586-y := aes-i586-asm_32.o aes_glue.o
@@ -71,6 +72,7 @@ endif
 
 ifeq ($(avx2_supported),yes)
 	blowfish-avx2-y := blowfish-avx2-asm_64.o blowfish_avx2_glue.o
+	twofish-avx2-y := twofish-avx2-asm_64.o twofish_avx2_glue.o
 endif
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
diff --git a/arch/x86/crypto/glue_helper-asm-avx2.S b/arch/x86/crypto/glue_helper-asm-avx2.S
new file mode 100644
index 0000000..a53ac11
--- /dev/null
+++ b/arch/x86/crypto/glue_helper-asm-avx2.S
@@ -0,0 +1,180 @@
+/*
+ * Shared glue code for 128bit block ciphers, AVX2 assembler macros
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
+#define load_16way(src, x0, x1, x2, x3, x4, x5, x6, x7) \
+	vmovdqu (0*32)(src), x0; \
+	vmovdqu (1*32)(src), x1; \
+	vmovdqu (2*32)(src), x2; \
+	vmovdqu (3*32)(src), x3; \
+	vmovdqu (4*32)(src), x4; \
+	vmovdqu (5*32)(src), x5; \
+	vmovdqu (6*32)(src), x6; \
+	vmovdqu (7*32)(src), x7;
+
+#define store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7) \
+	vmovdqu x0, (0*32)(dst); \
+	vmovdqu x1, (1*32)(dst); \
+	vmovdqu x2, (2*32)(dst); \
+	vmovdqu x3, (3*32)(dst); \
+	vmovdqu x4, (4*32)(dst); \
+	vmovdqu x5, (5*32)(dst); \
+	vmovdqu x6, (6*32)(dst); \
+	vmovdqu x7, (7*32)(dst);
+
+#define store_cbc_16way(src, dst, x0, x1, x2, x3, x4, x5, x6, x7, t0) \
+	vpxor t0, t0, t0; \
+	vinserti128 $1, (src), t0, t0; \
+	vpxor t0, x0, x0; \
+	vpxor (0*32+16)(src), x1, x1; \
+	vpxor (1*32+16)(src), x2, x2; \
+	vpxor (2*32+16)(src), x3, x3; \
+	vpxor (3*32+16)(src), x4, x4; \
+	vpxor (4*32+16)(src), x5, x5; \
+	vpxor (5*32+16)(src), x6, x6; \
+	vpxor (6*32+16)(src), x7, x7; \
+	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
+
+#define inc_le128(x, minus_one, tmp) \
+	vpcmpeqq minus_one, x, tmp; \
+	vpsubq minus_one, x, x; \
+	vpslldq $8, tmp, tmp; \
+	vpsubq tmp, x, x;
+
+#define add2_le128(x, minus_one, minus_two, tmp1, tmp2) \
+	vpcmpeqq minus_one, x, tmp1; \
+	vpcmpeqq minus_two, x, tmp2; \
+	vpsubq minus_two, x, x; \
+	vpor tmp2, tmp1, tmp1; \
+	vpslldq $8, tmp1, tmp1; \
+	vpsubq tmp1, x, x;
+
+#define load_ctr_16way(iv, bswap, x0, x1, x2, x3, x4, x5, x6, x7, t0, t0x, t1, \
+		       t1x, t2, t2x, t3, t3x, t4, t5) \
+	vpcmpeqd t0, t0, t0; \
+	vpsrldq $8, t0, t0; /* ab: -1:0 ; cd: -1:0 */ \
+	vpaddq t0, t0, t4; /* ab: -2:0 ; cd: -2:0 */\
+	\
+	/* load IV and byteswap */ \
+	vmovdqu (iv), t2x; \
+	vmovdqa t2x, t3x; \
+	inc_le128(t2x, t0x, t1x); \
+	vbroadcasti128 bswap, t1; \
+	vinserti128 $1, t2x, t3, t2; /* ab: le0 ; cd: le1 */ \
+	vpshufb t1, t2, x0; \
+	\
+	/* construct IVs */ \
+	add2_le128(t2, t0, t4, t3, t5); /* ab: le2 ; cd: le3 */ \
+	vpshufb t1, t2, x1; \
+	add2_le128(t2, t0, t4, t3, t5); \
+	vpshufb t1, t2, x2; \
+	add2_le128(t2, t0, t4, t3, t5); \
+	vpshufb t1, t2, x3; \
+	add2_le128(t2, t0, t4, t3, t5); \
+	vpshufb t1, t2, x4; \
+	add2_le128(t2, t0, t4, t3, t5); \
+	vpshufb t1, t2, x5; \
+	add2_le128(t2, t0, t4, t3, t5); \
+	vpshufb t1, t2, x6; \
+	add2_le128(t2, t0, t4, t3, t5); \
+	vpshufb t1, t2, x7; \
+	vextracti128 $1, t2, t2x; \
+	inc_le128(t2x, t0x, t3x); \
+	vmovdqu t2x, (iv);
+
+#define store_ctr_16way(src, dst, x0, x1, x2, x3, x4, x5, x6, x7) \
+	vpxor (0*32)(src), x0, x0; \
+	vpxor (1*32)(src), x1, x1; \
+	vpxor (2*32)(src), x2, x2; \
+	vpxor (3*32)(src), x3, x3; \
+	vpxor (4*32)(src), x4, x4; \
+	vpxor (5*32)(src), x5, x5; \
+	vpxor (6*32)(src), x6, x6; \
+	vpxor (7*32)(src), x7, x7; \
+	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
+
+#define gf128mul_x_ble(iv, mask, tmp) \
+	vpsrad $31, iv, tmp; \
+	vpaddq iv, iv, iv; \
+	vpshufd $0x13, tmp, tmp; \
+	vpand mask, tmp, tmp; \
+	vpxor tmp, iv, iv;
+
+#define gf128mul_x2_ble(iv, mask1, mask2, tmp0, tmp1) \
+	vpsrad $31, iv, tmp0; \
+	vpaddq iv, iv, tmp1; \
+	vpsllq $2, iv, iv; \
+	vpshufd $0x13, tmp0, tmp0; \
+	vpsrad $31, tmp1, tmp1; \
+	vpand mask2, tmp0, tmp0; \
+	vpshufd $0x13, tmp1, tmp1; \
+	vpxor tmp0, iv, iv; \
+	vpand mask1, tmp1, tmp1; \
+	vpxor tmp1, iv, iv;
+
+#define load_xts_16way(iv, src, dst, x0, x1, x2, x3, x4, x5, x6, x7, tiv, \
+		       tivx, t0, t0x, t1, t1x, t2, t2x, t3, \
+		       xts_gf128mul_and_shl1_mask_0, \
+		       xts_gf128mul_and_shl1_mask_1) \
+	vbroadcasti128 xts_gf128mul_and_shl1_mask_0, t1; \
+	\
+	/* load IV and construct second IV */ \
+	vmovdqu (iv), tivx; \
+	vmovdqa tivx, t0x; \
+	gf128mul_x_ble(tivx, t1x, t2x); \
+	vbroadcasti128 xts_gf128mul_and_shl1_mask_1, t2; \
+	vinserti128 $1, tivx, t0, tiv; \
+	vpxor (0*32)(src), tiv, x0; \
+	vmovdqu tiv, (0*32)(dst); \
+	\
+	/* construct and store IVs, also xor with source */ \
+	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
+	vpxor (1*32)(src), tiv, x1; \
+	vmovdqu tiv, (1*32)(dst); \
+	\
+	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
+	vpxor (2*32)(src), tiv, x2; \
+	vmovdqu tiv, (2*32)(dst); \
+	\
+	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
+	vpxor (3*32)(src), tiv, x3; \
+	vmovdqu tiv, (3*32)(dst); \
+	\
+	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
+	vpxor (4*32)(src), tiv, x4; \
+	vmovdqu tiv, (4*32)(dst); \
+	\
+	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
+	vpxor (5*32)(src), tiv, x5; \
+	vmovdqu tiv, (5*32)(dst); \
+	\
+	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
+	vpxor (6*32)(src), tiv, x6; \
+	vmovdqu tiv, (6*32)(dst); \
+	\
+	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
+	vpxor (7*32)(src), tiv, x7; \
+	vmovdqu tiv, (7*32)(dst); \
+	\
+	vextracti128 $1, tiv, tivx; \
+	gf128mul_x_ble(tivx, t1x, t2x); \
+	vmovdqu tivx, (iv);
+
+#define store_xts_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7) \
+	vpxor (0*32)(dst), x0, x0; \
+	vpxor (1*32)(dst), x1, x1; \
+	vpxor (2*32)(dst), x2, x2; \
+	vpxor (3*32)(dst), x3, x3; \
+	vpxor (4*32)(dst), x4, x4; \
+	vpxor (5*32)(dst), x5, x5; \
+	vpxor (6*32)(dst), x6, x6; \
+	vpxor (7*32)(dst), x7, x7; \
+	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/twofish-avx2-asm_64.S b/arch/x86/crypto/twofish-avx2-asm_64.S
new file mode 100644
index 0000000..e1a83b9
--- /dev/null
+++ b/arch/x86/crypto/twofish-avx2-asm_64.S
@@ -0,0 +1,600 @@
+/*
+ * x86_64/AVX2 assembler optimized version of Twofish
+ *
+ * Copyright © 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
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
+.file "twofish-avx2-asm_64.S"
+
+.data
+.align 16
+
+.Lvpshufb_mask0:
+.long 0x80808000
+.long 0x80808004
+.long 0x80808008
+.long 0x8080800c
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
+/* structure of crypto context */
+#define s0	0
+#define s1	1024
+#define s2	2048
+#define s3	3072
+#define w	4096
+#define	k	4128
+
+/* register macros */
+#define CTX	%rdi
+
+#define RS0	CTX
+#define RS1	%r8
+#define RS2	%r9
+#define RS3	%r10
+#define RK	%r11
+#define RW	%rax
+#define RROUND  %r12
+#define RROUNDd %r12d
+
+#define RA0	%ymm8
+#define RB0	%ymm9
+#define RC0	%ymm10
+#define RD0	%ymm11
+#define RA1	%ymm12
+#define RB1	%ymm13
+#define RC1	%ymm14
+#define RD1	%ymm15
+
+/* temp regs */
+#define RX0	%ymm0
+#define RY0	%ymm1
+#define RX1	%ymm2
+#define RY1	%ymm3
+#define RT0	%ymm4
+#define RIDX	%ymm5
+
+#define RX0x	%xmm0
+#define RY0x	%xmm1
+#define RX1x	%xmm2
+#define RY1x	%xmm3
+#define RT0x	%xmm4
+
+/* vpgatherdd mask and '-1' */
+#define RNOT	%ymm6
+
+/* byte mask, (-1 >> 24) */
+#define RBYTE	%ymm7
+
+/**********************************************************************
+  16-way AVX2 twofish
+ **********************************************************************/
+#define init_round_constants() \
+	vpcmpeqd RNOT, RNOT, RNOT; \
+	vpsrld $24, RNOT, RBYTE; \
+	leaq k(CTX), RK; \
+	leaq w(CTX), RW; \
+	leaq s1(CTX), RS1; \
+	leaq s2(CTX), RS2; \
+	leaq s3(CTX), RS3; \
+
+#define g16(ab, rs0, rs1, rs2, rs3, xy) \
+	vpand RBYTE, ab ## 0, RIDX; \
+	vpgatherdd RNOT, (rs0, RIDX, 4), xy ## 0; \
+	vpcmpeqd RNOT, RNOT, RNOT; \
+		\
+		vpand RBYTE, ab ## 1, RIDX; \
+		vpgatherdd RNOT, (rs0, RIDX, 4), xy ## 1; \
+		vpcmpeqd RNOT, RNOT, RNOT; \
+	\
+	vpsrld $8, ab ## 0, RIDX; \
+	vpand RBYTE, RIDX, RIDX; \
+	vpgatherdd RNOT, (rs1, RIDX, 4), RT0; \
+	vpcmpeqd RNOT, RNOT, RNOT; \
+	vpxor RT0, xy ## 0, xy ## 0; \
+		\
+		vpsrld $8, ab ## 1, RIDX; \
+		vpand RBYTE, RIDX, RIDX; \
+		vpgatherdd RNOT, (rs1, RIDX, 4), RT0; \
+		vpcmpeqd RNOT, RNOT, RNOT; \
+		vpxor RT0, xy ## 1, xy ## 1; \
+	\
+	vpsrld $16, ab ## 0, RIDX; \
+	vpand RBYTE, RIDX, RIDX; \
+	vpgatherdd RNOT, (rs2, RIDX, 4), RT0; \
+	vpcmpeqd RNOT, RNOT, RNOT; \
+	vpxor RT0, xy ## 0, xy ## 0; \
+		\
+		vpsrld $16, ab ## 1, RIDX; \
+		vpand RBYTE, RIDX, RIDX; \
+		vpgatherdd RNOT, (rs2, RIDX, 4), RT0; \
+		vpcmpeqd RNOT, RNOT, RNOT; \
+		vpxor RT0, xy ## 1, xy ## 1; \
+	\
+	vpsrld $24, ab ## 0, RIDX; \
+	vpgatherdd RNOT, (rs3, RIDX, 4), RT0; \
+	vpcmpeqd RNOT, RNOT, RNOT; \
+	vpxor RT0, xy ## 0, xy ## 0; \
+		\
+		vpsrld $24, ab ## 1, RIDX; \
+		vpgatherdd RNOT, (rs3, RIDX, 4), RT0; \
+		vpcmpeqd RNOT, RNOT, RNOT; \
+		vpxor RT0, xy ## 1, xy ## 1;
+
+#define g1_16(a, x) \
+	g16(a, RS0, RS1, RS2, RS3, x);
+
+#define g2_16(b, y) \
+	g16(b, RS1, RS2, RS3, RS0, y);
+
+#define encrypt_round_end16(a, b, c, d, nk) \
+	vpaddd RY0, RX0, RX0; \
+	vpaddd RX0, RY0, RY0; \
+	vpbroadcastd nk(RK,RROUND,8), RT0; \
+	vpaddd RT0, RX0, RX0; \
+	vpbroadcastd 4+nk(RK,RROUND,8), RT0; \
+	vpaddd RT0, RY0, RY0; \
+	\
+	vpxor RY0, d ## 0, d ## 0; \
+	\
+	vpxor RX0, c ## 0, c ## 0; \
+	vpsrld $1, c ## 0, RT0; \
+	vpslld $31, c ## 0, c ## 0; \
+	vpor RT0, c ## 0, c ## 0; \
+	\
+		vpaddd RY1, RX1, RX1; \
+		vpaddd RX1, RY1, RY1; \
+		vpbroadcastd nk(RK,RROUND,8), RT0; \
+		vpaddd RT0, RX1, RX1; \
+		vpbroadcastd 4+nk(RK,RROUND,8), RT0; \
+		vpaddd RT0, RY1, RY1; \
+		\
+		vpxor RY1, d ## 1, d ## 1; \
+		\
+		vpxor RX1, c ## 1, c ## 1; \
+		vpsrld $1, c ## 1, RT0; \
+		vpslld $31, c ## 1, c ## 1; \
+		vpor RT0, c ## 1, c ## 1; \
+
+#define encrypt_round16(a, b, c, d, nk) \
+	g2_16(b, RY); \
+	\
+	vpslld $1, b ## 0, RT0; \
+	vpsrld $31, b ## 0, b ## 0; \
+	vpor RT0, b ## 0, b ## 0; \
+	\
+		vpslld $1, b ## 1, RT0; \
+		vpsrld $31, b ## 1, b ## 1; \
+		vpor RT0, b ## 1, b ## 1; \
+	\
+	g1_16(a, RX); \
+	\
+	encrypt_round_end16(a, b, c, d, nk);
+
+#define encrypt_round_first16(a, b, c, d, nk) \
+	vpslld $1, d ## 0, RT0; \
+	vpsrld $31, d ## 0, d ## 0; \
+	vpor RT0, d ## 0, d ## 0; \
+	\
+		vpslld $1, d ## 1, RT0; \
+		vpsrld $31, d ## 1, d ## 1; \
+		vpor RT0, d ## 1, d ## 1; \
+	\
+	encrypt_round16(a, b, c, d, nk);
+
+#define encrypt_round_last16(a, b, c, d, nk) \
+	g2_16(b, RY); \
+	\
+	g1_16(a, RX); \
+	\
+	encrypt_round_end16(a, b, c, d, nk);
+
+#define decrypt_round_end16(a, b, c, d, nk) \
+	vpaddd RY0, RX0, RX0; \
+	vpaddd RX0, RY0, RY0; \
+	vpbroadcastd nk(RK,RROUND,8), RT0; \
+	vpaddd RT0, RX0, RX0; \
+	vpbroadcastd 4+nk(RK,RROUND,8), RT0; \
+	vpaddd RT0, RY0, RY0; \
+	\
+	vpxor RX0, c ## 0, c ## 0; \
+	\
+	vpxor RY0, d ## 0, d ## 0; \
+	vpsrld $1, d ## 0, RT0; \
+	vpslld $31, d ## 0, d ## 0; \
+	vpor RT0, d ## 0, d ## 0; \
+	\
+		vpaddd RY1, RX1, RX1; \
+		vpaddd RX1, RY1, RY1; \
+		vpbroadcastd nk(RK,RROUND,8), RT0; \
+		vpaddd RT0, RX1, RX1; \
+		vpbroadcastd 4+nk(RK,RROUND,8), RT0; \
+		vpaddd RT0, RY1, RY1; \
+		\
+		vpxor RX1, c ## 1, c ## 1; \
+		\
+		vpxor RY1, d ## 1, d ## 1; \
+		vpsrld $1, d ## 1, RT0; \
+		vpslld $31, d ## 1, d ## 1; \
+		vpor RT0, d ## 1, d ## 1;
+
+#define decrypt_round16(a, b, c, d, nk) \
+	g1_16(a, RX); \
+	\
+	vpslld $1, a ## 0, RT0; \
+	vpsrld $31, a ## 0, a ## 0; \
+	vpor RT0, a ## 0, a ## 0; \
+	\
+		vpslld $1, a ## 1, RT0; \
+		vpsrld $31, a ## 1, a ## 1; \
+		vpor RT0, a ## 1, a ## 1; \
+	\
+	g2_16(b, RY); \
+	\
+	decrypt_round_end16(a, b, c, d, nk);
+
+#define decrypt_round_first16(a, b, c, d, nk) \
+	vpslld $1, c ## 0, RT0; \
+	vpsrld $31, c ## 0, c ## 0; \
+	vpor RT0, c ## 0, c ## 0; \
+	\
+		vpslld $1, c ## 1, RT0; \
+		vpsrld $31, c ## 1, c ## 1; \
+		vpor RT0, c ## 1, c ## 1; \
+	\
+	decrypt_round16(a, b, c, d, nk)
+
+#define decrypt_round_last16(a, b, c, d, nk) \
+	g1_16(a, RX); \
+	\
+	g2_16(b, RY); \
+	\
+	decrypt_round_end16(a, b, c, d, nk);
+
+#define encrypt_cycle16() \
+	encrypt_round16(RA, RB, RC, RD, 0); \
+	encrypt_round16(RC, RD, RA, RB, 8);
+
+#define encrypt_cycle_first16() \
+	encrypt_round_first16(RA, RB, RC, RD, 0); \
+	encrypt_round16(RC, RD, RA, RB, 8);
+
+#define encrypt_cycle_last16() \
+	encrypt_round16(RA, RB, RC, RD, 0); \
+	encrypt_round_last16(RC, RD, RA, RB, 8);
+
+#define decrypt_cycle16(n) \
+	decrypt_round16(RC, RD, RA, RB, 8); \
+	decrypt_round16(RA, RB, RC, RD, 0);
+
+#define decrypt_cycle_first16(n) \
+	decrypt_round_first16(RC, RD, RA, RB, 8); \
+	decrypt_round16(RA, RB, RC, RD, 0);
+
+#define decrypt_cycle_last16(n) \
+	decrypt_round16(RC, RD, RA, RB, 8); \
+	decrypt_round_last16(RA, RB, RC, RD, 0);
+
+#define transpose_4x4(x0,x1,x2,x3,t1,t2) \
+	vpunpckhdq x1, x0, t2; \
+	vpunpckldq x1, x0, x0; \
+	\
+	vpunpckldq x3, x2, t1; \
+	vpunpckhdq x3, x2, x2; \
+	\
+	vpunpckhqdq t1,	x0, x1; \
+	vpunpcklqdq t1,	x0, x0; \
+	\
+	vpunpckhqdq x2, t2, x3; \
+	vpunpcklqdq x2,	t2, x2;
+
+#define read_blocks8(offs,a,b,c,d) \
+	transpose_4x4(a, b, c, d, RX0, RY0);
+
+#define write_blocks8(offs,a,b,c,d) \
+	transpose_4x4(a, b, c, d, RX0, RY0);
+
+#define inpack_enc8(a,b,c,d) \
+	vpbroadcastd 4*0(RW), RT0; \
+	vpxor RT0, a, a; \
+	\
+	vpbroadcastd 4*1(RW), RT0; \
+	vpxor RT0, b, b; \
+	\
+	vpbroadcastd 4*2(RW), RT0; \
+	vpxor RT0, c, c; \
+	\
+	vpbroadcastd 4*3(RW), RT0; \
+	vpxor RT0, d, d;
+
+#define outunpack_enc8(a,b,c,d) \
+	vpbroadcastd 4*4(RW), RX0; \
+	vpbroadcastd 4*5(RW), RY0; \
+	vpxor RX0, c, RX0; \
+	vpxor RY0, d, RY0; \
+	\
+	vpbroadcastd 4*6(RW), RT0; \
+	vpxor RT0, a, c; \
+	vpbroadcastd 4*7(RW), RT0; \
+	vpxor RT0, b, d; \
+	\
+	vmovdqa RX0, a; \
+	vmovdqa RY0, b;
+
+#define inpack_dec8(a,b,c,d) \
+	vpbroadcastd 4*4(RW), RX0; \
+	vpbroadcastd 4*5(RW), RY0; \
+	vpxor RX0, a, RX0; \
+	vpxor RY0, b, RY0; \
+	\
+	vpbroadcastd 4*6(RW), RT0; \
+	vpxor RT0, c, a; \
+	vpbroadcastd 4*7(RW), RT0; \
+	vpxor RT0, d, b; \
+	\
+	vmovdqa RX0, c; \
+	vmovdqa RY0, d;
+
+#define outunpack_dec8(a,b,c,d) \
+	vpbroadcastd 4*0(RW), RT0; \
+	vpxor RT0, a, a; \
+	\
+	vpbroadcastd 4*1(RW), RT0; \
+	vpxor RT0, b, b; \
+	\
+	vpbroadcastd 4*2(RW), RT0; \
+	vpxor RT0, c, c; \
+	\
+	vpbroadcastd 4*3(RW), RT0; \
+	vpxor RT0, d, d;
+
+#define read_blocks16(a,b,c,d) \
+	read_blocks8(0, a ## 0, b ## 0, c ## 0, d ## 0); \
+	read_blocks8(8, a ## 1, b ## 1, c ## 1, d ## 1);
+
+#define write_blocks16(a,b,c,d) \
+	write_blocks8(0, a ## 0, b ## 0, c ## 0, d ## 0); \
+	write_blocks8(8, a ## 1, b ## 1, c ## 1, d ## 1);
+
+#define xor_blocks16(a,b,c,d) \
+	xor_blocks8(0, a ## 0, b ## 0, c ## 0, d ## 0); \
+	xor_blocks8(8, a ## 1, b ## 1, c ## 1, d ## 1);
+
+#define inpack_enc16(a,b,c,d) \
+	inpack_enc8(a ## 0, b ## 0, c ## 0, d ## 0); \
+	inpack_enc8(a ## 1, b ## 1, c ## 1, d ## 1);
+
+#define outunpack_enc16(a,b,c,d) \
+	outunpack_enc8(a ## 0, b ## 0, c ## 0, d ## 0); \
+	outunpack_enc8(a ## 1, b ## 1, c ## 1, d ## 1);
+
+#define inpack_dec16(a,b,c,d) \
+	inpack_dec8(a ## 0, b ## 0, c ## 0, d ## 0); \
+	inpack_dec8(a ## 1, b ## 1, c ## 1, d ## 1);
+
+#define outunpack_dec16(a,b,c,d) \
+	outunpack_dec8(a ## 0, b ## 0, c ## 0, d ## 0); \
+	outunpack_dec8(a ## 1, b ## 1, c ## 1, d ## 1);
+
+.align 8
+__twofish_enc_blk16:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1: plaintext
+	 * output:
+	 *	RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1: ciphertext
+	 */
+	init_round_constants();
+
+	read_blocks16(RA, RB, RC, RD);
+	inpack_enc16(RA, RB, RC, RD);
+
+	xorl RROUNDd, RROUNDd;
+	encrypt_cycle_first16();
+	movl $2, RROUNDd;
+
+.align 4
+.L__enc_loop:
+	encrypt_cycle16();
+
+	addl $2, RROUNDd;
+	cmpl $14, RROUNDd;
+	jne .L__enc_loop;
+
+	encrypt_cycle_last16();
+
+	outunpack_enc16(RA, RB, RC, RD);
+	write_blocks16(RA, RB, RC, RD);
+
+	ret;
+ENDPROC(__twofish_enc_blk16)
+
+.align 8
+__twofish_dec_blk16:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1: ciphertext
+	 * output:
+	 *	RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1: plaintext
+	 */
+	init_round_constants();
+
+	read_blocks16(RA, RB, RC, RD);
+	inpack_dec16(RA, RB, RC, RD);
+
+	movl $14, RROUNDd;
+	decrypt_cycle_first16();
+	movl $12, RROUNDd;
+
+.align 4
+.L__dec_loop:
+	decrypt_cycle16();
+
+	addl $-2, RROUNDd;
+	jnz .L__dec_loop;
+
+	decrypt_cycle_last16();
+
+	outunpack_dec16(RA, RB, RC, RD);
+	write_blocks16(RA, RB, RC, RD);
+
+	ret;
+ENDPROC(__twofish_dec_blk16)
+
+ENTRY(twofish_ecb_enc_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vzeroupper;
+	pushq %r12;
+
+	load_16way(%rdx, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
+
+	call __twofish_enc_blk16;
+
+	store_16way(%rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
+
+	popq %r12;
+	vzeroupper;
+
+	ret;
+ENDPROC(twofish_ecb_enc_16way)
+
+ENTRY(twofish_ecb_dec_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vzeroupper;
+	pushq %r12;
+
+	load_16way(%rdx, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
+
+	call __twofish_dec_blk16;
+
+	store_16way(%rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
+
+	popq %r12;
+	vzeroupper;
+
+	ret;
+ENDPROC(twofish_ecb_dec_16way)
+
+ENTRY(twofish_cbc_dec_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vzeroupper;
+	pushq %r12;
+
+	load_16way(%rdx, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
+
+	call __twofish_dec_blk16;
+
+	store_cbc_16way(%rdx, %rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1,
+			RX0);
+
+	popq %r12;
+	vzeroupper;
+
+	ret;
+ENDPROC(twofish_cbc_dec_16way)
+
+ENTRY(twofish_ctr_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (little endian, 128bit)
+	 */
+
+	vzeroupper;
+	pushq %r12;
+
+	load_ctr_16way(%rcx, .Lbswap128_mask, RA0, RB0, RC0, RD0, RA1, RB1, RC1,
+		       RD1, RX0, RX0x, RX1, RX1x, RY0, RY0x, RY1, RY1x, RNOT,
+		       RBYTE);
+
+	call __twofish_enc_blk16;
+
+	store_ctr_16way(%rdx, %rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
+
+	popq %r12;
+	vzeroupper;
+
+	ret;
+ENDPROC(twofish_ctr_16way)
+
+.align 8
+twofish_xts_crypt_16way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
+	 *	%r8: pointer to __twofish_enc_blk16 or __twofish_dec_blk16
+	 */
+
+	vzeroupper;
+	pushq %r12;
+
+	load_xts_16way(%rcx, %rdx, %rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1,
+		       RD1, RX0, RX0x, RX1, RX1x, RY0, RY0x, RY1, RY1x, RNOT,
+		       .Lxts_gf128mul_and_shl1_mask_0,
+		       .Lxts_gf128mul_and_shl1_mask_1);
+
+	call *%r8;
+
+	store_xts_16way(%rsi, RA0, RB0, RC0, RD0, RA1, RB1, RC1, RD1);
+
+	popq %r12;
+	vzeroupper;
+
+	ret;
+ENDPROC(twofish_xts_crypt_16way)
+
+ENTRY(twofish_xts_enc_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
+	 */
+	leaq __twofish_enc_blk16, %r8;
+	jmp twofish_xts_crypt_16way;
+ENDPROC(twofish_xts_enc_16way)
+
+ENTRY(twofish_xts_dec_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (t ⊕ αⁿ ∈ GF(2¹²⁸))
+	 */
+	leaq __twofish_dec_blk16, %r8;
+	jmp twofish_xts_crypt_16way;
+ENDPROC(twofish_xts_dec_16way)
diff --git a/arch/x86/crypto/twofish_avx2_glue.c b/arch/x86/crypto/twofish_avx2_glue.c
new file mode 100644
index 0000000..ce33b5b
--- /dev/null
+++ b/arch/x86/crypto/twofish_avx2_glue.c
@@ -0,0 +1,584 @@
+/*
+ * Glue Code for x86_64/AVX2 assembler optimized version of Twofish
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
+#include <crypto/twofish.h>
+#include <crypto/lrw.h>
+#include <crypto/xts.h>
+#include <asm/xcr.h>
+#include <asm/xsave.h>
+#include <asm/crypto/twofish.h>
+#include <asm/crypto/ablk_helper.h>
+#include <asm/crypto/glue_helper.h>
+#include <crypto/scatterwalk.h>
+
+#define TF_AVX2_PARALLEL_BLOCKS 16
+
+/* 16-way AVX2 parallel cipher functions */
+asmlinkage void twofish_ecb_enc_16way(struct twofish_ctx *ctx, u8 *dst,
+				      const u8 *src);
+asmlinkage void twofish_ecb_dec_16way(struct twofish_ctx *ctx, u8 *dst,
+				      const u8 *src);
+asmlinkage void twofish_cbc_dec_16way(void *ctx, u128 *dst, const u128 *src);
+
+asmlinkage void twofish_ctr_16way(void *ctx, u128 *dst, const u128 *src,
+				  le128 *iv);
+
+asmlinkage void twofish_xts_enc_16way(struct twofish_ctx *ctx, u8 *dst,
+				      const u8 *src, le128 *iv);
+asmlinkage void twofish_xts_dec_16way(struct twofish_ctx *ctx, u8 *dst,
+				      const u8 *src, le128 *iv);
+
+static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	__twofish_enc_blk_3way(ctx, dst, src, false);
+}
+
+static const struct common_glue_ctx twofish_enc = {
+	.num_funcs = 4,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_enc_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_enc_8way) }
+	}, {
+		.num_blocks = 3,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk) }
+	} }
+};
+
+static const struct common_glue_ctx twofish_ctr = {
+	.num_funcs = 4,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_ctr_16way) }
+	},  {
+		.num_blocks = 8,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_ctr_8way) }
+	}, {
+		.num_blocks = 3,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr) }
+	} }
+};
+
+static const struct common_glue_ctx twofish_enc_xts = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_enc_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_enc_8way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_enc) }
+	} }
+};
+
+static const struct common_glue_ctx twofish_dec = {
+	.num_funcs = 4,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_dec_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_dec_8way) }
+	}, {
+		.num_blocks = 3,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
+	} }
+};
+
+static const struct common_glue_ctx twofish_dec_cbc = {
+	.num_funcs = 4,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_cbc_dec_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_cbc_dec_8way) }
+	}, {
+		.num_blocks = 3,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
+	} }
+};
+
+static const struct common_glue_ctx twofish_dec_xts = {
+	.num_funcs = 3,
+	.fpu_blocks_limit = 8,
+
+	.funcs = { {
+		.num_blocks = 16,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_dec_16way) }
+	}, {
+		.num_blocks = 8,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_dec_8way) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_dec) }
+	} }
+};
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ecb_crypt_128bit(&twofish_enc, desc, dst, src, nbytes);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ecb_crypt_128bit(&twofish_dec, desc, dst, src, nbytes);
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_cbc_encrypt_128bit(GLUE_FUNC_CAST(twofish_enc_blk), desc,
+				       dst, src, nbytes);
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_cbc_decrypt_128bit(&twofish_dec_cbc, desc, dst, src,
+				       nbytes);
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		     struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ctr_crypt_128bit(&twofish_ctr, desc, dst, src, nbytes);
+}
+
+static inline bool twofish_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+{
+	/* since reusing AVX functions, starts using FPU at 8 parallel blocks */
+	return glue_fpu_begin(TF_BLOCK_SIZE, 8, NULL, fpu_enabled, nbytes);
+}
+
+static inline void twofish_fpu_end(bool fpu_enabled)
+{
+	glue_fpu_end(fpu_enabled);
+}
+
+struct crypt_priv {
+	struct twofish_ctx *ctx;
+	bool fpu_enabled;
+};
+
+static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = twofish_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	while (nbytes >= TF_AVX2_PARALLEL_BLOCKS * bsize) {
+		twofish_ecb_enc_16way(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * TF_AVX2_PARALLEL_BLOCKS;
+		nbytes -= bsize * TF_AVX2_PARALLEL_BLOCKS;
+	}
+
+	while (nbytes >= 8 * bsize) {
+		twofish_ecb_enc_8way(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * 8;
+		nbytes -= bsize * 8;
+	}
+
+	while (nbytes >= 3 * bsize) {
+		twofish_enc_blk_3way(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * 3;
+		nbytes -= bsize * 3;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		twofish_enc_blk(ctx->ctx, srcdst, srcdst);
+}
+
+static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = twofish_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	while (nbytes >= TF_AVX2_PARALLEL_BLOCKS * bsize) {
+		twofish_ecb_dec_16way(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * TF_AVX2_PARALLEL_BLOCKS;
+		nbytes -= bsize * TF_AVX2_PARALLEL_BLOCKS;
+	}
+
+	while (nbytes >= 8 * bsize) {
+		twofish_ecb_dec_8way(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * 8;
+		nbytes -= bsize * 8;
+	}
+
+	while (nbytes >= 3 * bsize) {
+		twofish_dec_blk_3way(ctx->ctx, srcdst, srcdst);
+		srcdst += bsize * 3;
+		nbytes -= bsize * 3;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		twofish_dec_blk(ctx->ctx, srcdst, srcdst);
+}
+
+static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[TF_AVX2_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->twofish_ctx,
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
+	twofish_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[TF_AVX2_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->twofish_ctx,
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
+	twofish_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+
+	return glue_xts_crypt_128bit(&twofish_enc_xts, desc, dst, src, nbytes,
+				     XTS_TWEAK_CAST(twofish_enc_blk),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+
+	return glue_xts_crypt_128bit(&twofish_dec_xts, desc, dst, src, nbytes,
+				     XTS_TWEAK_CAST(twofish_enc_blk),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
+}
+
+static struct crypto_alg tf_algs[10] = { {
+	.cra_name		= "__ecb-twofish-avx2",
+	.cra_driver_name	= "__driver-ecb-twofish-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__cbc-twofish-avx2",
+	.cra_driver_name	= "__driver-cbc-twofish-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__ctr-twofish-avx2",
+	.cra_driver_name	= "__driver-ctr-twofish-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		= "__lrw-twofish-avx2",
+	.cra_driver_name	= "__driver-lrw-twofish-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_exit		= lrw_twofish_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE +
+					  TF_BLOCK_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE +
+					  TF_BLOCK_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= lrw_twofish_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__xts-twofish-avx2",
+	.cra_driver_name	= "__driver-xts-twofish-avx2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE * 2,
+			.max_keysize	= TF_MAX_KEY_SIZE * 2,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= xts_twofish_setkey,
+			.encrypt	= xts_encrypt,
+			.decrypt	= xts_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ecb(twofish)",
+	.cra_driver_name	= "ecb-twofish-avx2",
+	.cra_priority		= 500,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(twofish)",
+	.cra_driver_name	= "cbc-twofish-avx2",
+	.cra_priority		= 500,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= __ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ctr(twofish)",
+	.cra_driver_name	= "ctr-twofish-avx2",
+	.cra_priority		= 500,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_encrypt,
+			.geniv		= "chainiv",
+		},
+	},
+}, {
+	.cra_name		= "lrw(twofish)",
+	.cra_driver_name	= "lrw-twofish-avx2",
+	.cra_priority		= 500,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE +
+					  TF_BLOCK_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE +
+					  TF_BLOCK_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "xts(twofish)",
+	.cra_driver_name	= "xts-twofish-avx2",
+	.cra_priority		= 500,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE * 2,
+			.max_keysize	= TF_MAX_KEY_SIZE * 2,
+			.ivsize		= TF_BLOCK_SIZE,
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
+		pr_info("AVX2 detected but unusable.\n");
+		return -ENODEV;
+	}
+
+	return crypto_register_algs(tf_algs, ARRAY_SIZE(tf_algs));
+}
+
+static void __exit fini(void)
+{
+	crypto_unregister_algs(tf_algs, ARRAY_SIZE(tf_algs));
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Twofish Cipher Algorithm, AVX2 optimized");
+MODULE_ALIAS("twofish");
+MODULE_ALIAS("twofish-asm");
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index a62ba54..2047a56 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -50,18 +50,26 @@
 /* 8-way parallel cipher functions */
 asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
+EXPORT_SYMBOL_GPL(twofish_ecb_enc_8way);
+
 asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
+EXPORT_SYMBOL_GPL(twofish_ecb_dec_8way);
 
 asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
+EXPORT_SYMBOL_GPL(twofish_cbc_dec_8way);
+
 asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
 				 const u8 *src, le128 *iv);
+EXPORT_SYMBOL_GPL(twofish_ctr_8way);
 
 asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src, le128 *iv);
+EXPORT_SYMBOL_GPL(twofish_xts_enc_8way);
 asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src, le128 *iv);
+EXPORT_SYMBOL_GPL(twofish_xts_dec_8way);
 
 static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 					const u8 *src)
@@ -69,17 +77,19 @@ static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-static void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
 				  GLUE_FUNC_CAST(twofish_enc_blk));
 }
+EXPORT_SYMBOL_GPL(twofish_xts_enc);
 
-static void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
 				  GLUE_FUNC_CAST(twofish_dec_blk));
 }
+EXPORT_SYMBOL_GPL(twofish_xts_dec);
 
 
 static const struct common_glue_ctx twofish_enc = {
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index 878c51c..e655c60 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -28,6 +28,20 @@ asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
+/* 8-way parallel cipher functions */
+asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src);
+asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src);
+asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src);
+asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
+				 const u8 *src, le128 *iv);
+asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src, le128 *iv);
+asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src, le128 *iv);
+
 /* helpers from twofish_x86_64-3way module */
 extern void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src);
 extern void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src,
@@ -43,4 +57,8 @@ extern void lrw_twofish_exit_tfm(struct crypto_tfm *tfm);
 extern int xts_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
 			      unsigned int keylen);
 
+/* helpers from twofish-avx module */
+extern void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+extern void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+
 #endif /* ASM_X86_TWOFISH_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6b9564f..1ba48dd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1250,6 +1250,30 @@ config CRYPTO_TWOFISH_AVX_X86_64
 	  See also:
 	  <http://www.schneier.com/twofish.html>
 
+config CRYPTO_TWOFISH_AVX2_X86_64
+	tristate "Twofish cipher algorithm (x86_64/AVX2)"
+	depends on X86 && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_GLUE_HELPER_X86
+	select CRYPTO_TWOFISH_COMMON
+	select CRYPTO_TWOFISH_X86_64
+	select CRYPTO_TWOFISH_X86_64_3WAY
+	select CRYPTO_TWOFISH_AVX_X86_64
+	select CRYPTO_LRW
+	select CRYPTO_XTS
+	help
+	  Twofish cipher algorithm (x86_64/AVX2).
+
+	  Twofish was submitted as an AES (Advanced Encryption Standard)
+	  candidate cipher by researchers at CounterPane Systems.  It is a
+	  16 round block cipher supporting key sizes of 128, 192, and 256
+	  bits.
+
+	  See also:
+	  <http://www.schneier.com/twofish.html>
+
 comment "Compression"
 
 config CRYPTO_DEFLATE
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f3effb4..fea7841 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1651,6 +1651,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "__cbc-twofish-avx",
 		.test = alg_test_null,
 	}, {
+		.alg = "__cbc-twofish-avx2",
+		.test = alg_test_null,
+	}, {
 		.alg = "__driver-cbc-aes-aesni",
 		.test = alg_test_null,
 		.fips_allowed = 1,
@@ -1676,6 +1679,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "__driver-cbc-twofish-avx",
 		.test = alg_test_null,
 	}, {
+		.alg = "__driver-cbc-twofish-avx2",
+		.test = alg_test_null,
+	}, {
 		.alg = "__driver-ecb-aes-aesni",
 		.test = alg_test_null,
 		.fips_allowed = 1,
@@ -1701,6 +1707,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "__driver-ecb-twofish-avx",
 		.test = alg_test_null,
 	}, {
+		.alg = "__driver-ecb-twofish-avx2",
+		.test = alg_test_null,
+	}, {
 		.alg = "__ghash-pclmulqdqni",
 		.test = alg_test_null,
 		.fips_allowed = 1,
@@ -1985,6 +1994,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "cryptd(__driver-ecb-twofish-avx)",
 		.test = alg_test_null,
 	}, {
+		.alg = "cryptd(__driver-ecb-twofish-avx2)",
+		.test = alg_test_null,
+	}, {
 		.alg = "cryptd(__driver-gcm-aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,

