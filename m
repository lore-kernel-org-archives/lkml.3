Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967815Ab3HICZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:25:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967150Ab3HIB6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 002/102] ARM: poison memory between kuser helpers
Date: Thu,  8 Aug 2013 18:56:38 -0700
Message-Id: <20130809015010.765021468@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 5b43e7a383d69381ffe53423e46dd0fafae07da3 upstream.

Poison the memory between each kuser helper.  This ensures that any
branch between the kuser helpers will be appropriately trapped.

Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/entry-armv.S |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -741,6 +741,17 @@ ENDPROC(__switch_to)
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
@@ -831,18 +842,13 @@ kuser_cmpxchg64_fixup:
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
 
@@ -915,13 +921,14 @@ kuser_cmpxchg32_fixup:
 
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
 


