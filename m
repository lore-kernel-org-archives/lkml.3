Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaDUVxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:53:51 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:62503 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbaDUVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:53:38 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/10] ARM: bcm: use inline assembly for "smc" request
Date: Mon, 21 Apr 2014 16:53:09 -0500
Message-Id: <1398117191-2433-9-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398117191-2433-1-git-send-email-elder@linaro.org>
References: <1398117191-2433-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code that implements the "smc" call into a C function that
uses inline assembly.  This allows us to make that function private,
and enables us to get rid of "arch/arm/mach-bcm/bcm_kona_smc_asm.S".
Rename what had been the "buffer_addr" argument to be "buffer_phys"
so it's consistent with other usage in this file.

Since it's now easy to do, verify that r12 contains SEC_EXIT_NORMAL
upon completion of the SMC.  There really isn't a good way to handle
the abnormal completion of a secure monitor request.

Since "bcm_kona_smc.h" is now only included from C files, eliminate
the #ifndef __ASSEMBLY__.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/mach-bcm/Makefile           |  7 +++---
 arch/arm/mach-bcm/bcm_kona_smc.c     | 46 +++++++++++++++++++++++++++++++++++-
 arch/arm/mach-bcm/bcm_kona_smc.h     |  6 -----
 arch/arm/mach-bcm/bcm_kona_smc_asm.S | 41 --------------------------------
 4 files changed, 49 insertions(+), 51 deletions(-)
 delete mode 100644 arch/arm/mach-bcm/bcm_kona_smc_asm.S

diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index 5154981..d5b60fe 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -20,9 +20,10 @@ obj-$(CONFIG_ARCH_BCM_21664)	+= board_bcm21664.o
 obj-$(CONFIG_ARCH_BCM_MOBILE_L2_CACHE) += kona.o
 
 # Support for secure monitor traps
-obj-$(CONFIG_ARCH_BCM_MOBILE_SMC) += bcm_kona_smc.o bcm_kona_smc_asm.o
-plus_sec := $(call as-instr,.arch_extension sec,+sec)
-AFLAGS_bcm_kona_smc_asm.o	:=-Wa,-march=armv7-a$(plus_sec)
+obj-$(CONFIG_ARCH_BCM_MOBILE_SMC) += bcm_kona_smc.o
+ifeq ($(call as-instr,.arch_extension sec,as_has_sec),as_has_sec)
+CFLAGS_bcm_kona_smc.o		+= -Wa,-march=armv7-a+sec -DREQUIRES_SEC
+endif
 
 # BCM2835
 obj-$(CONFIG_ARCH_BCM2835)	+= board_bcm2835.o
diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index 6fdcf96..cc81c86 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -76,6 +76,50 @@ int __init bcm_kona_smc_init(void)
 	return 0;
 }
 
+/*
+ * Since interrupts are disabled in the open mode, we must keep
+ * interrupts disabled in secure mode by setting R5=0x3. If interrupts
+ * are enabled in open mode, we can set R5=0x0 to allow interrupts in
+ * secure mode.  If we did this, the secure monitor would return back
+ * control to the open mode to handle the interrupt prior to completing
+ * the secure service. If this happened, R12 would not be
+ * SEC_EXIT_NORMAL and we would need to call SMC again after resetting
+ * R5 (it gets clobbered by the secure monitor) and setting R4 to
+ * SSAPI_RET_FROM_INT_SERV to indicate that we want the secure monitor
+ * to finish up the previous uncompleted secure service.
+ */
+static int bcm_kona_do_smc(u32 service_id, u32 buffer_phys)
+{
+	register u32 ip asm("ip");	/* Also called r12 */
+	register u32 r0 asm("r0");
+	register u32 r4 asm("r4");
+	register u32 r5 asm("r5");
+	register u32 r6 asm("r6");
+
+	r4 = service_id;
+	r5 = 0x3;		/* Keep IRQ and FIQ off in SM */
+	r6 = buffer_phys;
+
+	asm volatile (
+		/* Make sure we got the registers we want */
+		__asmeq("%0", "ip")
+		__asmeq("%1", "r0")
+		__asmeq("%2", "r4")
+		__asmeq("%3", "r5")
+		__asmeq("%4", "r6")
+#ifdef REQUIRES_SEC
+		".arch_extension sec\n"
+#endif
+		"	smc    #0\n"
+		: "=r" (ip), "=r" (r0)
+		: "r" (r4), "r" (r5), "r" (r6)
+		: "r1", "r2", "r3", "r7", "lr");
+
+	BUG_ON(ip != SEC_EXIT_NORMAL);
+
+	return r0;
+}
+
 /* __bcm_kona_smc() should only run on CPU 0, with pre-emption disabled */
 static void __bcm_kona_smc(void *info)
 {
@@ -95,7 +139,7 @@ static void __bcm_kona_smc(void *info)
 	flush_cache_all();
 
 	/* Trap into Secure Monitor and record the request result */
-	data->result = bcm_kona_smc_asm(data->service_id, bcm_smc_buffer_phys);
+	data->result = bcm_kona_do_smc(data->service_id, bcm_smc_buffer_phys);
 }
 
 unsigned bcm_kona_smc(unsigned service_id, unsigned arg0, unsigned arg1,
diff --git a/arch/arm/mach-bcm/bcm_kona_smc.h b/arch/arm/mach-bcm/bcm_kona_smc.h
index 629e64a..2e29ec6 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.h
+++ b/arch/arm/mach-bcm/bcm_kona_smc.h
@@ -21,7 +21,6 @@
 #define SEC_ROM_RET_OK			0x00000001
 #define SEC_EXIT_NORMAL			0x1
 
-#ifndef	__ASSEMBLY__
 extern int __init bcm_kona_smc_init(void);
 
 extern unsigned bcm_kona_smc(unsigned service_id,
@@ -30,9 +29,4 @@ extern unsigned bcm_kona_smc(unsigned service_id,
 			     unsigned arg2,
 			     unsigned arg3);
 
-extern int bcm_kona_smc_asm(u32 service_id,
-			    u32 buffer_addr);
-
-#endif	/* __ASSEMBLY__ */
-
 #endif /* BCM_KONA_SMC_H */
diff --git a/arch/arm/mach-bcm/bcm_kona_smc_asm.S b/arch/arm/mach-bcm/bcm_kona_smc_asm.S
deleted file mode 100644
index a160848..0000000
--- a/arch/arm/mach-bcm/bcm_kona_smc_asm.S
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * Copyright (C) 2013 Broadcom Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/linkage.h>
-#include "bcm_kona_smc.h"
-
-/*
- * int bcm_kona_smc_asm(u32 service_id, u32 buffer_addr)
- */
-
-ENTRY(bcm_kona_smc_asm)
-	stmfd	sp!, {r4-r12, lr}
-	mov	r4, r0		@ service_id
-	mov	r5, #3		@ Keep IRQ and FIQ off in SM
-	/*
-	 * Since interrupts are disabled in the open mode, we must keep
-	 * interrupts disabled in secure mode by setting R5=0x3. If interrupts
-	 * are enabled in open mode, we can set R5=0x0 to allow interrupts in
-	 * secure mode.  If we did this, the secure monitor would return back
-	 * control to the open mode to handle the interrupt prior to completing
-	 * the secure service. If this happened, R12 would not be
-	 * SEC_EXIT_NORMAL and we would need to call SMC again after resetting
-	 * R5 (it gets clobbered by the secure monitor) and setting R4 to
-	 * SSAPI_RET_FROM_INT_SERV to indicate that we want the secure monitor
-	 * to finish up the previous uncompleted secure service.
-	 */
-	mov	r6, r1		@ buffer_addr
-	smc	#0
-	/* Check r12 for SEC_EXIT_NORMAL here if interrupts are enabled */
-	ldmfd	sp!, {r4-r12, pc}
-ENDPROC(bcm_kona_smc_asm)
-- 
1.9.1

