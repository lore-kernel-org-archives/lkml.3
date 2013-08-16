Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab3HPWhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:37:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab3HPWg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:36:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 073/133] ARM: poison memory between kuser helpers
Date: Fri, 16 Aug 2013 15:33:35 -0700
Message-Id: <1376692475-28413-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 5b43e7a383d69381ffe53423e46dd0fafae07da3 upstream.

Poison the memory between each kuser helper.  This ensures that any
branch between the kuser helpers will be appropriately trapped.

Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/entry-armv.S | 25 ++++++++++++++++---------
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
1.8.1.2

