Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbaEJAIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 20:08:11 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64382 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbaEJAIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 20:08:10 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] powerpc: Fix "attempt to move .org backwards" error (again)
Date: Fri,  9 May 2014 17:07:58 -0700
Message-Id: <1399680478-4970-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4e243b7 (powerpc: Fix "attempt to move .org backwards" error) fixes the
allyesconfig build by moving machine_check_common to a different location.
While this fixes most of the errors, both allmodconfig and allyesconfig still
fail as follows.

arch/powerpc/kernel/exceptions-64s.S:1315: Error: attempt to move .org backwards

Fix by moving machine_check_common after the offending address.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
This fixes the build error, but unfortunately I don't have a system to test
the resulting image.

 arch/powerpc/kernel/exceptions-64s.S | 49 ++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 3afd391..25398be 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1138,31 +1138,6 @@ unrecov_user_slb:
 
 #endif /* __DISABLED__ */
 
-
-	/*
-	 * Machine check is different because we use a different
-	 * save area: PACA_EXMC instead of PACA_EXGEN.
-	 */
-	.align	7
-	.globl machine_check_common
-machine_check_common:
-
-	mfspr	r10,SPRN_DAR
-	std	r10,PACA_EXGEN+EX_DAR(r13)
-	mfspr	r10,SPRN_DSISR
-	stw	r10,PACA_EXGEN+EX_DSISR(r13)
-	EXCEPTION_PROLOG_COMMON(0x200, PACA_EXMC)
-	FINISH_NAP
-	DISABLE_INTS
-	ld	r3,PACA_EXGEN+EX_DAR(r13)
-	lwz	r4,PACA_EXGEN+EX_DSISR(r13)
-	std	r3,_DAR(r1)
-	std	r4,_DSISR(r1)
-	bl	.save_nvgprs
-	addi	r3,r1,STACK_FRAME_OVERHEAD
-	bl	.machine_check_exception
-	b	.ret_from_except
-
 	.align	7
 	.globl alignment_common
 alignment_common:
@@ -1328,6 +1303,30 @@ fwnmi_data_area:
 initial_stab:
 	.space	4096
 
+	/*
+	 * Machine check is different because we use a different
+	 * save area: PACA_EXMC instead of PACA_EXGEN.
+	 */
+	.align	7
+	.globl machine_check_common
+machine_check_common:
+
+	mfspr	r10,SPRN_DAR
+	std	r10,PACA_EXGEN+EX_DAR(r13)
+	mfspr	r10,SPRN_DSISR
+	stw	r10,PACA_EXGEN+EX_DSISR(r13)
+	EXCEPTION_PROLOG_COMMON(0x200, PACA_EXMC)
+	FINISH_NAP
+	DISABLE_INTS
+	ld	r3,PACA_EXGEN+EX_DAR(r13)
+	lwz	r4,PACA_EXGEN+EX_DSISR(r13)
+	std	r3,_DAR(r1)
+	std	r4,_DSISR(r1)
+	bl	.save_nvgprs
+	addi	r3,r1,STACK_FRAME_OVERHEAD
+	bl	.machine_check_exception
+	b	.ret_from_except
+
 #ifdef CONFIG_PPC_POWERNV
 _GLOBAL(opal_mc_secondary_handler)
 	HMT_MEDIUM_PPR_DISCARD
-- 
1.9.1

