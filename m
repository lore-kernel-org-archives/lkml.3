Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3GJNAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:00:05 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48325 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3GJNAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:00:03 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 2/2] RX-51: ARM errata 430973 workaround
Date: Wed, 10 Jul 2013 14:59:05 +0200
Message-Id: <1373461145-9812-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373461145-9812-1-git-send-email-pali.rohar@gmail.com>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
 <1373461145-9812-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Closed and signed Nokia X-Loader bootloader stored in RX-51 nand does not set
IBE bit in ACTLR and starting kernel in non-secure mode. So direct write to
ACTLR by our kernel does not working and the code for ARM errata 430973 in
commit 7ce236fcd6fd45b0441a2d49acb2ceb2de2e8a47 that sets IBE bit is a noop.

In order to have workaround for ARM errata 430973 from non-secure world on
RX-51 we needs Secure Monitor Call to set IBE BIT in ACTLR.

This patch adds RX-51 specific SMC support and sets IBE bit in ACTLR during
board init code for ARM errata 430973 workaround.

ARM errata 430973 workaround is needed for thumb-2 ISA compiled userspace
binaries. Without this workaround thumb-2 binaries crashing. So with this
patch it is possible to recompile and run applications/binaries with thumb-2
ISA on RX-51.

Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/board-rx51.c |   78 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index 03663c2..f234dee 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -2,6 +2,8 @@
  * Board support file for Nokia N900 (aka RX-51).
  *
  * Copyright (C) 2007, 2008 Nokia
+ * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
+ * Copyright (C) 2013 Pali Rohár <pali.rohar@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -21,6 +23,7 @@
 #include <linux/usb/musb.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 
+#include <asm/cacheflush.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -31,7 +34,14 @@
 #include "mux.h"
 #include "gpmc.h"
 #include "pm.h"
+#include "soc.h"
 #include "sdram-nokia.h"
+#include "omap-secure.h"
+
+/* Secure PPA (Primary Protected Application) APIs */
+#define RX51_PPA_HWRNG			29
+#define RX51_PPA_L2_INVAL		40
+#define RX51_PPA_WRITE_ACR		42
 
 #define RX51_GPIO_SLEEP_IND 162
 
@@ -90,6 +100,66 @@ static struct omap_musb_board_data musb_board_data = {
 	.power			= 0,
 };
 
+/**
+ * rx51_secure_dispatcher: Routine to dispatch secure PPA API calls
+ * @idx: The PPA API index
+ * @process: Process ID
+ * @flag: The flag indicating criticality of operation
+ * @nargs: Number of valid arguments out of four.
+ * @arg1, arg2, arg3 args4: Parameters passed to secure API
+ *
+ * Return the non-zero error value on failure.
+ */
+static u32 rx51_secure_dispatcher(u32 idx, u32 process, u32 flag, u32 nargs,
+			   u32 arg1, u32 arg2, u32 arg3, u32 arg4)
+{
+	u32 ret;
+	u32 param[5];
+
+	param[0] = nargs+1; /* RX-51 needs number of arguments + 1 */
+	param[1] = arg1;
+	param[2] = arg2;
+	param[3] = arg3;
+	param[4] = arg4;
+
+	/*
+	 * Secure API needs physical address
+	 * pointer for the parameters
+	 */
+	local_irq_disable();
+	local_fiq_disable();
+	flush_cache_all();
+	outer_clean_range(__pa(param), __pa(param + 5));
+	ret = omap_smc3(idx, process, flag, __pa(param));
+	flush_cache_all();
+	local_fiq_enable();
+	local_irq_enable();
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
+static u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits)
+{
+	u32 acr;
+
+	/* Read ACR */
+	asm volatile ("mrc p15, 0, %0, c1, c0, 1" : "=r" (acr));
+	acr &= ~clear_bits;
+	acr |= set_bits;
+
+	return rx51_secure_dispatcher(RX51_PPA_WRITE_ACR,
+				      0,
+				      FLAG_START_CRITICAL,
+				      1, acr, 0, 0, 0);
+}
+
 static void __init rx51_init(void)
 {
 	struct omap_sdrc_params *sdrc_params;
@@ -105,6 +175,14 @@ static void __init rx51_init(void)
 	rx51_peripherals_init();
 	rx51_camera_init();
 
+	if (omap_type() == OMAP2_DEVICE_TYPE_SEC) {
+#ifdef CONFIG_ARM_ERRATA_430973
+		pr_info("RX-51: Enabling ARM errata 430973 workaround\n");
+		/* set IBE to 1 */
+		rx51_secure_update_aux_cr(BIT(6), 0);
+#endif
+	}
+
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
 	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
-- 
1.7.10.4

