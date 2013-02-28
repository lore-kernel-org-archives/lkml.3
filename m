Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3B1JvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:51:25 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53103 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3B1JvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:51:21 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Date: Thu, 28 Feb 2013 10:42:28 +0100
Message-Id: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/Makefile            |    1 +
 arch/arm/mach-omap2/board-rx51-secure.c |   66 +++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-rx51-secure.h |   36 +++++++++++++++++
 arch/arm/mach-omap2/board-rx51-smc.S    |   34 ++++++++++++++++
 arch/arm/mach-omap2/board-rx51.c        |    7 ++++
 5 files changed, 144 insertions(+)
 create mode 100644 arch/arm/mach-omap2/board-rx51-secure.c
 create mode 100644 arch/arm/mach-omap2/board-rx51-secure.h
 create mode 100644 arch/arm/mach-omap2/board-rx51-smc.S

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 0ebbdd50..8eb4fb4 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -241,6 +241,7 @@ obj-$(CONFIG_MACH_NOKIA_RX51)		+= board-rx51.o sdram-nokia.o
 obj-$(CONFIG_MACH_NOKIA_RX51)		+= board-rx51-peripherals.o
 obj-$(CONFIG_MACH_NOKIA_RX51)		+= board-rx51-video.o
 obj-$(CONFIG_MACH_NOKIA_RX51)		+= board-rx51-camera.o
+obj-$(CONFIG_MACH_NOKIA_RX51)		+= board-rx51-smc.o board-rx51-secure.o
 obj-$(CONFIG_MACH_OMAP_ZOOM2)		+= board-zoom.o board-zoom-peripherals.o
 obj-$(CONFIG_MACH_OMAP_ZOOM2)		+= board-zoom-display.o
 obj-$(CONFIG_MACH_OMAP_ZOOM2)		+= board-zoom-debugboard.o
diff --git a/arch/arm/mach-omap2/board-rx51-secure.c b/arch/arm/mach-omap2/board-rx51-secure.c
new file mode 100644
index 0000000..361dc78
--- /dev/null
+++ b/arch/arm/mach-omap2/board-rx51-secure.c
@@ -0,0 +1,66 @@
+/*
+ * RX51 Secure PPA API.
+ *
+ * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
+ *
+ *
+ * This program is free software,you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <asm/cacheflush.h>
+
+#include "board-rx51-secure.h"
+
+/**
+ * rx51_secure_dispatcher: Routine to dispatch secure PPA API calls
+ * @idx: The PPA API index
+ * @flag: The flag indicating criticality of operation
+ * @nargs: Number of valid arguments out of four.
+ * @arg1, arg2, arg3 args4: Parameters passed to secure API
+ *
+ * Return the non-zero error value on failure.
+ */
+u32 rx51_secure_dispatcher(u32 idx, u32 flag, u32 nargs, u32 arg1, u32 arg2,
+			   u32 arg3, u32 arg4)
+{
+	u32 ret;
+	u32 param[5];
+
+	param[0] = nargs+1;
+	param[1] = arg1;
+	param[2] = arg2;
+	param[3] = arg3;
+	param[4] = arg4;
+
+	/*
+	 * Secure API needs physical address
+	 * pointer for the parameters
+	 */
+	flush_cache_all();
+	outer_clean_range(__pa(param), __pa(param + 5));
+	ret = rx51_ppa_smc(idx, flag, __pa(param));
+
+	return ret;
+}
+
+/**
+ * rx51_secure_update_aux_cr: Routine to modify the contents of Auxiliary Control Register
+ *  @set_bits: bits to set in ACR
+ *  @clr_bits: bits to clear in ACR
+ *
+ * Return the non-zero error value on failure.
+*/
+u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits)
+{
+	u32 acr;
+
+	/* Read ACR */
+	asm volatile ("mrc p15, 0, %0, c1, c0, 1" : "=r" (acr));
+	acr &= ~clear_bits;
+	acr |= set_bits;
+
+	return rx51_secure_dispatcher(RX51_PPA_WRITE_ACR,
+			       FLAG_START_CRITICAL,
+			       1,acr,0,0,0);
+}
diff --git a/arch/arm/mach-omap2/board-rx51-secure.h b/arch/arm/mach-omap2/board-rx51-secure.h
new file mode 100644
index 0000000..61c760b
--- /dev/null
+++ b/arch/arm/mach-omap2/board-rx51-secure.h
@@ -0,0 +1,36 @@
+/*
+ * board-rx51-secure.h: OMAP Secure infrastructure header.
+ *
+ * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef OMAP_RX51_SECURE_H
+#define OMAP_RX51_SECURE_H
+
+/* HAL API error codes */
+#define  API_HAL_RET_VALUE_OK           0x00
+#define  API_HAL_RET_VALUE_FAIL         0x01
+
+/* Secure HAL API flags */
+#define FLAG_START_CRITICAL             0x4
+#define FLAG_IRQFIQ_MASK                0x3
+#define FLAG_IRQ_ENABLE                 0x2
+#define FLAG_FIQ_ENABLE                 0x1
+#define NO_FLAG                         0x0
+
+/* Secure PPA(Primary Protected Application) APIs */
+#define RX51_PPA_L2_INVAL               40
+#define RX51_PPA_WRITE_ACR              42
+
+#ifndef __ASSEMBLER__
+
+extern u32 rx51_secure_dispatcher(u32 idx, u32 flag, u32 nargs,
+                                u32 arg1, u32 arg2, u32 arg3, u32 arg4);
+extern u32 rx51_ppa_smc(u32 id, u32 flag, u32 pargs);
+
+extern u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits);
+#endif /* __ASSEMBLER__ */
+#endif /* OMAP_RX51_SECURE_H */
diff --git a/arch/arm/mach-omap2/board-rx51-smc.S b/arch/arm/mach-omap2/board-rx51-smc.S
new file mode 100644
index 0000000..70e2eb7
--- /dev/null
+++ b/arch/arm/mach-omap2/board-rx51-smc.S
@@ -0,0 +1,34 @@
+/*
+ * RX51 secure APIs file.
+ *
+ * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
+ *
+ *
+ * This program is free software,you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+/**
+ * u32 rx51_ppa_smc(u32 id, u32 flag, u32 pargs)
+ * Low level common routine for secure HAL and PPA APIs.
+ * @id: Secure Service ID
+ * @flag: Flag to indicate the criticality of operation
+ * @pargs: Physical address of parameter list starting
+ *          with number of parametrs
+ */
+ENTRY(rx51_ppa_smc)
+	.arch_extension sec
+	stmfd	sp!, {r4-r12, lr}
+	mov	r12, r0		@ Copy the secure service ID
+	mov	r3, r2		@ Copy the pointer to va_list in R3
+	mov	r2, r1		@ Copy the flags in R2
+	mov	r1, #0x0	@ Process ID - 0
+	mov	r6, #0xff	@ Indicate new Task call
+	dsb
+	dmb
+	smc	#1		@ call PPA service
+	ldmfd	sp!, {r4-r12, pc}
+ENDPROC(rx51_ppa_smc)
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index 92117a13..fd85081 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -31,6 +31,7 @@
 #include "gpmc.h"
 #include "pm.h"
 #include "sdram-nokia.h"
+#include "board-rx51-secure.h"
 
 #define RX51_GPIO_SLEEP_IND 162
 
@@ -103,6 +104,12 @@ static void __init rx51_init(void)
 	rx51_peripherals_init();
 	rx51_camera_init();
 
+#ifdef CONFIG_ARM_ERRATA_430973
+	printk(KERN_INFO "Enabling ARM errata 430973 workaround.\n");
+	/* set IBE to 1 */
+	rx51_secure_update_aux_cr(1 << 6, 0);
+#endif
+
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
 	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
-- 
1.7.10.4

