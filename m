Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3IKF21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:28:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3IKE5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:24 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=KS4u23Jao5wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=mLK90JvhmjcA:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=ULMaIIxtx4fm30VP:21 a=CFfS9qN-r8FQbPt4:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042912.249146534@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [120/251] ARM: poison memory between kuser helpers
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0120-ARM-poison-memory-between-kuser-helpers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

[ Upstream commit 5b43e7a383d69381ffe53423e46dd0fafae07da3 ]

Poison the memory between each kuser helper.  This ensures that any
branch between the kuser helpers will be appropriately trapped.

Cc: <stable@vger.kernel.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/entry-armv.S |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..9c80c1d 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -784,6 +784,17 @@ ENDPROC(__switch_to)
 #endif
 	.endm
 
+	.macro	kuser_pad, sym, size
+	.if	(. - \sym) & 3
+	.rept	4 - (. - \sym) & 3
+	.byte	0
+	.endr
+	.endif
+	.rept	(\size - (. - \sym)) / 4
+	.word	0xe7fddef1
+	.endr
+	.endm
+
 	.align	5
 	.globl	__kuser_helper_start
 __kuser_helper_start:
@@ -874,18 +885,13 @@ kuser_cmpxchg64_fixup:
 #error "incoherent kernel configuration"
 #endif
 
-	/* pad to next slot */
-	.rept	(16 - (. - __kuser_cmpxchg64)/4)
-	.word	0
-	.endr
-
-	.align	5
+	kuser_pad __kuser_cmpxchg64, 64
 
 __kuser_memory_barrier:				@ 0xffff0fa0
 	smp_dmb	arm
 	usr_ret	lr
 
-	.align	5
+	kuser_pad __kuser_memory_barrier, 32
 
 __kuser_cmpxchg:				@ 0xffff0fc0
 
@@ -958,13 +964,14 @@ kuser_cmpxchg32_fixup:
 
 #endif
 
-	.align	5
+	kuser_pad __kuser_cmpxchg, 32
 
 __kuser_get_tls:				@ 0xffff0fe0
 	ldr	r0, [pc, #(16 - 8)]	@ read TLS, set in kuser_get_tls_init
 	usr_ret	lr
 	mrc	p15, 0, r0, c13, c0, 3	@ 0xffff0fe8 hardware TLS code
-	.rep	4
+	kuser_pad __kuser_get_tls, 16
+	.rep	3
 	.word	0			@ 0xffff0ff0 software TLS value, then
 	.endr				@ pad up to __kuser_helper_version
 
-- 
1.7.10.4


