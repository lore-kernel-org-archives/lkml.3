Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab3HMUUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:20:33 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13016 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759183Ab3HMUUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:20:31 -0400
Message-ID: <201308132020.r7DKKUJw022759@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 13 Aug 2013 15:26:23 -0400
Subject: [PATCH] tile: simplify code referencing hypervisor API addresses
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to make up new ways of computing the addresses
of the Tilera hypervisor APIs; just use the standard method
of relying on the symbols to provide the addresses.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/relocate_kernel_32.S | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/arch/tile/kernel/relocate_kernel_32.S b/arch/tile/kernel/relocate_kernel_32.S
index 010b418..f7fd37b 100644
--- a/arch/tile/kernel/relocate_kernel_32.S
+++ b/arch/tile/kernel/relocate_kernel_32.S
@@ -20,15 +20,6 @@
 #include <asm/page.h>
 #include <hv/hypervisor.h>
 
-#define ___hvb	MEM_SV_INTRPT + HV_GLUE_START_CPA
-
-#define ___hv_dispatch(f) (___hvb + (HV_DISPATCH_ENTRY_SIZE * f))
-
-#define ___hv_console_putc ___hv_dispatch(HV_DISPATCH_CONSOLE_PUTC)
-#define ___hv_halt         ___hv_dispatch(HV_DISPATCH_HALT)
-#define ___hv_reexec       ___hv_dispatch(HV_DISPATCH_REEXEC)
-#define ___hv_flush_remote ___hv_dispatch(HV_DISPATCH_FLUSH_REMOTE)
-
 #undef RELOCATE_NEW_KERNEL_VERBOSE
 
 STD_ENTRY(relocate_new_kernel)
@@ -43,8 +34,8 @@ STD_ENTRY(relocate_new_kernel)
 	addi	sp, sp, -8
 	/* we now have a stack (whether we need one or not) */
 
-	moveli	r40, lo16(___hv_console_putc)
-	auli	r40, r40, ha16(___hv_console_putc)
+	moveli	r40, lo16(hv_console_putc)
+	auli	r40, r40, ha16(hv_console_putc)
 
 #ifdef RELOCATE_NEW_KERNEL_VERBOSE
 	moveli	r0, 'r'
@@ -114,11 +105,11 @@ STD_ENTRY(relocate_new_kernel)
 	}
 	{
 	 move	r8, zero	 /* asids */
-	 moveli	r20, lo16(___hv_flush_remote)
+	 moveli	r20, lo16(hv_flush_remote)
 	}
 	{
 	 move	r9, zero	 /* asidcount */
-	 auli	r20, r20, ha16(___hv_flush_remote)
+	 auli	r20, r20, ha16(hv_flush_remote)
 	}
 
 	jalr	r20
@@ -175,8 +166,8 @@ STD_ENTRY(relocate_new_kernel)
 	move	r0, r32
 	moveli	r1, 0		/* arg to hv_reexec is 64 bits */
 
-	moveli	r41, lo16(___hv_reexec)
-	auli	r41, r41, ha16(___hv_reexec)
+	moveli	r41, lo16(hv_reexec)
+	auli	r41, r41, ha16(hv_reexec)
 
 	jalr	r41
 
@@ -267,8 +258,8 @@ STD_ENTRY(relocate_new_kernel)
 	moveli	r0, '\n'
 	jalr	r40
 .Lhalt:
-	moveli	r41, lo16(___hv_halt)
-	auli	r41, r41, ha16(___hv_halt)
+	moveli	r41, lo16(hv_halt)
+	auli	r41, r41, ha16(hv_halt)
 
 	jalr	r41
 	STD_ENDPROC(relocate_new_kernel)
-- 
1.8.3.1

