Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031176Ab3HIVAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:00:12 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:26153 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031161Ab3HIVAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:00:05 -0400
Message-ID: <201308092100.r79L055x011270@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 16:21:43 -0400
Subject: [PATCH] tile: fix strncpy_from_user bug
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In strncpy_from_user_asm, when the destination buffer length was the
same as the actual string length, we were returning the size of the
destination buffer.  But since it's a NUL terminated string, we should
return the length of the string instead.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/usercopy_32.S | 11 ++++++-----
 arch/tile/lib/usercopy_64.S | 11 ++++++-----
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/tile/lib/usercopy_32.S b/arch/tile/lib/usercopy_32.S
index bb4c127b..1bc1622 100644
--- a/arch/tile/lib/usercopy_32.S
+++ b/arch/tile/lib/usercopy_32.S
@@ -48,12 +48,13 @@ strnlen_user_fault:
  */
 STD_ENTRY(strncpy_from_user_asm)
 	{ bz r2, 2f; move r3, r0 }
-1:      { lb_u r4, r1; addi r1, r1, 1; addi r2, r2, -1 }
+1:	{ lb_u r4, r1; addi r1, r1, 1; addi r2, r2, -1 }
 	{ sb r0, r4; addi r0, r0, 1 }
-	bz r2, 2f
-	bnzt r4, 1b
-	addi r0, r0, -1   /* don't count the trailing NUL */
-2:      { sub r0, r0, r3; jrp lr }
+	bz r4, 2f
+	bnzt r2, 1b
+	{ sub r0, r0, r3; jrp lr }
+2:	addi r0, r0, -1   /* don't count the trailing NUL */
+	{ sub r0, r0, r3; jrp lr }
 	STD_ENDPROC(strncpy_from_user_asm)
 	.pushsection .fixup,"ax"
 strncpy_from_user_fault:
diff --git a/arch/tile/lib/usercopy_64.S b/arch/tile/lib/usercopy_64.S
index 0d94844e..b3b31a3 100644
--- a/arch/tile/lib/usercopy_64.S
+++ b/arch/tile/lib/usercopy_64.S
@@ -48,12 +48,13 @@ strnlen_user_fault:
  */
 STD_ENTRY(strncpy_from_user_asm)
 	{ beqz r2, 2f; move r3, r0 }
-1:      { ld1u r4, r1; addi r1, r1, 1; addi r2, r2, -1 }
+1:	{ ld1u r4, r1; addi r1, r1, 1; addi r2, r2, -1 }
 	{ st1 r0, r4; addi r0, r0, 1 }
-	beqz r2, 2f
-	bnezt r4, 1b
-	addi r0, r0, -1   /* don't count the trailing NUL */
-2:      { sub r0, r0, r3; jrp lr }
+	beqz r4, 2f
+	bnezt r2, 1b
+	{ sub r0, r0, r3; jrp lr }
+2:	addi r0, r0, -1   /* don't count the trailing NUL */
+	{ sub r0, r0, r3; jrp lr }
 	STD_ENDPROC(strncpy_from_user_asm)
 	.pushsection .fixup,"ax"
 strncpy_from_user_fault:
-- 
1.8.3.1

