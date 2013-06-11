Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab3FKTZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 15:25:32 -0400
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:38552 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab3FKTZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 15:25:30 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Subject: [PATCH] crypto: aesni_intel - fix accessing of unaligned memory
To: linux-crypto@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Tue, 11 Jun 2013 22:25:22 +0300
Message-ID: <20130611192522.12995.57979.stgit@localhost6.localdomain6>
In-Reply-To: <20130611191746.GA31945@redhat.com>
References: <20130611191746.GA31945@redhat.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new XTS code for aesni_intel uses input buffers directly as memory operands
for pxor instructions, which causes crash if those buffers are not aligned to
16 bytes.

Patch changes XTS code to handle unaligned memory correctly, by loading memory
with movdqu instead.

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/aesni-intel_asm.S |   48 +++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 62fe22c..477e9d7 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2681,56 +2681,68 @@ ENTRY(aesni_xts_crypt8)
 	addq %rcx, KEYP
 
 	movdqa IV, STATE1
-	pxor 0x00(INP), STATE1
+	movdqu 0x00(INP), INC
+	pxor INC, STATE1
 	movdqu IV, 0x00(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE2
-	pxor 0x10(INP), STATE2
+	movdqu 0x10(INP), INC
+	pxor INC, STATE2
 	movdqu IV, 0x10(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE3
-	pxor 0x20(INP), STATE3
+	movdqu 0x20(INP), INC
+	pxor INC, STATE3
 	movdqu IV, 0x20(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE4
-	pxor 0x30(INP), STATE4
+	movdqu 0x30(INP), INC
+	pxor INC, STATE4
 	movdqu IV, 0x30(OUTP)
 
 	call *%r11
 
-	pxor 0x00(OUTP), STATE1
+	movdqu 0x00(OUTP), INC
+	pxor INC, STATE1
 	movdqu STATE1, 0x00(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE1
-	pxor 0x40(INP), STATE1
+	movdqu 0x40(INP), INC
+	pxor INC, STATE1
 	movdqu IV, 0x40(OUTP)
 
-	pxor 0x10(OUTP), STATE2
+	movdqu 0x10(OUTP), INC
+	pxor INC, STATE2
 	movdqu STATE2, 0x10(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE2
-	pxor 0x50(INP), STATE2
+	movdqu 0x50(INP), INC
+	pxor INC, STATE2
 	movdqu IV, 0x50(OUTP)
 
-	pxor 0x20(OUTP), STATE3
+	movdqu 0x20(OUTP), INC
+	pxor INC, STATE3
 	movdqu STATE3, 0x20(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE3
-	pxor 0x60(INP), STATE3
+	movdqu 0x60(INP), INC
+	pxor INC, STATE3
 	movdqu IV, 0x60(OUTP)
 
-	pxor 0x30(OUTP), STATE4
+	movdqu 0x30(OUTP), INC
+	pxor INC, STATE4
 	movdqu STATE4, 0x30(OUTP)
 
 	_aesni_gf128mul_x_ble()
 	movdqa IV, STATE4
-	pxor 0x70(INP), STATE4
+	movdqu 0x70(INP), INC
+	pxor INC, STATE4
 	movdqu IV, 0x70(OUTP)
 
 	_aesni_gf128mul_x_ble()
@@ -2738,16 +2750,20 @@ ENTRY(aesni_xts_crypt8)
 
 	call *%r11
 
-	pxor 0x40(OUTP), STATE1
+	movdqu 0x40(OUTP), INC
+	pxor INC, STATE1
 	movdqu STATE1, 0x40(OUTP)
 
-	pxor 0x50(OUTP), STATE2
+	movdqu 0x50(OUTP), INC
+	pxor INC, STATE2
 	movdqu STATE2, 0x50(OUTP)
 
-	pxor 0x60(OUTP), STATE3
+	movdqu 0x60(OUTP), INC
+	pxor INC, STATE3
 	movdqu STATE3, 0x60(OUTP)
 
-	pxor 0x70(OUTP), STATE4
+	movdqu 0x70(OUTP), INC
+	pxor INC, STATE4
 	movdqu STATE4, 0x70(OUTP)
 
 	ret

