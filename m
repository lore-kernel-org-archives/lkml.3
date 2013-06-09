Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3FIB7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 21:59:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47476 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3FIB7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 21:59:50 -0400
Date: Sun, 9 Jun 2013 03:59:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: aaro.koskinen@iki.fi, linux-omap@vger.kernel.org,
        lauri.leukkunen@nokia.com
Subject: N900 device tree conversion: how to do first step
Message-ID: <20130609015944.GA23559@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'd like to convert Nokia N900 to device tree.

Unfortunately, serial port is not easily available (very special cable
would be needed, does someone know where to get one?) and I don't have
BDI (and very special cable would be needed, too).

So I tried doing very small first step, hoping that I get booting
system... obviously I did not.

I tried formally switching to device tree while still booting using
hardcoded functions. No luck. Does anyone see what I did wrong?

Is it possible that n900 has its main memory somewhere else than
0x80000000?

Thanks,
									Pavel

diff --git a/.config b/.config
index a36bbe2..130a7a8 100644
--- a/.config
+++ b/.config
@@ -498,11 +498,11 @@ CONFIG_ATAGS=y
 # CONFIG_DEPRECATED_PARAM_STRUCT is not set
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
-# CONFIG_ARM_APPENDED_DTB is not set
-CONFIG_CMDLINE="init=/sbin/preinit ubi.mtd=rootfs root=ubi0:rootfs rootfstype=ubifs rootflags=bulk_read,no_chk_data_crc rw mtdoops.mtddev=log console=tty0 console=ttyO2"
-CONFIG_CMDLINE_FROM_BOOTLOADER=y
-# CONFIG_CMDLINE_EXTEND is not set
-# CONFIG_CMDLINE_FORCE is not set
+CONFIG_ARM_APPENDED_DTB=y
+CONFIG_ARM_ATAG_DTB_COMPAT=y
+# CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER is not set
+CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND=y
+CONFIG_CMDLINE=""
 CONFIG_KEXEC=y
 CONFIG_ATAGS_PROC=y
 # CONFIG_CRASH_DUMP is not set
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 9c62558..7b1a075 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -119,6 +119,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	omap3-beagle-xm.dtb \
 	omap3-evm.dtb \
 	omap3-tobi.dtb \
+	omap3-n900.dtb \
 	omap4-panda.dtb \
 	omap4-panda-a4.dtb \
 	omap4-panda-es.dtb \
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
new file mode 100644
index 0000000..e093543
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+
+/include/ "skeleton.dtsi"
+/* FIXME: "omap3.dtsi" */
+
+/ {
+	model = "Nokia N900";
+	compatible = "nokia,omap3-n900", "ti,omap3";
+
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x10000000>; /* 256 MB */
+	};
+};
+
+/*
+&mmc1 {
+	status = "disabled";
+};
+
+&mmc2 {
+	status = "disabled";
+};
+
+&mmc3 {
+	status = "disabled";
+};
+*/
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index 74f83a5..f857b5b 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -36,6 +36,8 @@
 
 #define RX51_GPIO_SLEEP_IND 162
 
+/* This lights up left part of keyboard */
+
 static struct gpio_led gpio_leds[] = {
 	{
 		.name	= "sleep_ind",
@@ -119,21 +121,21 @@ static void __init rx51_init(void)
 	platform_device_register(&leds_gpio);
 }
 
-static void __init rx51_reserve(void)
-{
-	omap_reserve();
-}
+static const char *omap3_boards_compat[] __initdata = {
+	"nokia,omap3-n900",
+        NULL,
+};
 
-MACHINE_START(NOKIA_RX51, "Nokia RX-51 board")
-	/* Maintainer: Lauri Leukkunen <lauri.leukkunen@nokia.com> */
-	.atag_offset	= 0x100,
-	.reserve	= rx51_reserve,
+DT_MACHINE_START(N900_DT, "Nokia N900 (Flattened Device Tree)")
+	.atag_offset    = 0x100,
+	.reserve	= omap_reserve,
 	.map_io		= omap3_map_io,
-	.init_early	= omap3430_init_early,
-	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
-	.init_machine	= rx51_init,
-	.init_late	= omap3430_init_late,
-	.init_time	= omap3_sync32k_timer_init,
-	.restart	= omap3xxx_restart,
+	.init_early     = omap3430_init_early,
+	.init_irq       = omap3_init_irq, /* FIXME: omap_intc_of_init, */
+	.handle_irq     = omap3_intc_handle_irq,
+	.init_machine   = rx51_init, /* FIXME: omap_generic_init, */
+	.init_late      = omap3430_init_late, /* FIXME: omap3_init_late, */
+	.init_time      = omap3_sync32k_timer_init,
+	.dt_compat      = omap3_boards_compat,
+	.restart        = omap3xxx_restart,
 MACHINE_END
diff --git a/mkit b/mkit
index 354610c..e9ffc02 100755
--- a/mkit
+++ b/mkit
@@ -1,3 +1,4 @@
 #!/bin/bash
 ARCH=arm time make -j 3 && \
-    sudo ../maemo/0xffff/src/0xFFFF -m arch/arm/boot/zImage -l -b 'root=/dev/mmcblk0p6 rootwait'
\ No newline at end of file
+    cat arch/arm/boot/zImage arch/arm/boot/dts/omap3-n900.dtb > zImage_dtb && \
+    sudo ../maemo/0xffff/src/0xFFFF -m zImage_dtb -l -b 'root=/dev/mmcblk0p6 rootwait'
\ No newline at end of file


 
 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
