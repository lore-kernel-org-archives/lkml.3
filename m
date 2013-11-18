Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3KRSuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:50:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3KRSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:41:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 3.4 10/12] ARM: 7670/1: fix the memset fix
Date: Mon, 18 Nov 2013 10:41:43 -0800
Message-Id: <20131118184133.088850747@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184130.257996039@linuxfoundation.org>
References: <20131118184130.257996039@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit 418df63adac56841ef6b0f1fcf435bc64d4ed177 upstream.

Commit 455bd4c430b0 ("ARM: 7668/1: fix memset-related crashes caused by
recent GCC (4.7.2) optimizations") attempted to fix a compliance issue
with the memset return value.  However the memset itself became broken
by that patch for misaligned pointers.

This fixes the above by branching over the entry code from the
misaligned fixup code to avoid reloading the original pointer.

Also, because the function entry alignment is wrong in the Thumb mode
compilation, that fixup code is moved to the end.

While at it, the entry instructions are slightly reworked to help dual
issue pipelines.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Tested-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Eric Bénard <eric@eukrea.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/lib/memset.S |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

--- a/arch/arm/lib/memset.S
+++ b/arch/arm/lib/memset.S
@@ -14,31 +14,15 @@
 
 	.text
 	.align	5
-	.word	0
-
-1:	subs	r2, r2, #4		@ 1 do we have enough
-	blt	5f			@ 1 bytes to align with?
-	cmp	r3, #2			@ 1
-	strltb	r1, [ip], #1		@ 1
-	strleb	r1, [ip], #1		@ 1
-	strb	r1, [ip], #1		@ 1
-	add	r2, r2, r3		@ 1 (r2 = r2 - (4 - r3))
-/*
- * The pointer is now aligned and the length is adjusted.  Try doing the
- * memset again.
- */
 
 ENTRY(memset)
-/*
- * Preserve the contents of r0 for the return value.
- */
-	mov	ip, r0
-	ands	r3, ip, #3		@ 1 unaligned?
-	bne	1b			@ 1
+	ands	r3, r0, #3		@ 1 unaligned?
+	mov	ip, r0			@ preserve r0 as return value
+	bne	6f			@ 1
 /*
  * we know that the pointer in ip is aligned to a word boundary.
  */
-	orr	r1, r1, r1, lsl #8
+1:	orr	r1, r1, r1, lsl #8
 	orr	r1, r1, r1, lsl #16
 	mov	r3, r1
 	cmp	r2, #16
@@ -127,4 +111,13 @@ ENTRY(memset)
 	tst	r2, #1
 	strneb	r1, [ip], #1
 	mov	pc, lr
+
+6:	subs	r2, r2, #4		@ 1 do we have enough
+	blt	5b			@ 1 bytes to align with?
+	cmp	r3, #2			@ 1
+	strltb	r1, [ip], #1		@ 1
+	strleb	r1, [ip], #1		@ 1
+	strb	r1, [ip], #1		@ 1
+	add	r2, r2, r3		@ 1 (r2 = r2 - (4 - r3))
+	b	1b
 ENDPROC(memset)


